#lang racket

(require parser-tools/yacc
         parser-tools/lex
         dcc019/exercise/logic/lexer
         dcc019/exercise/logic/ast)

(provide parse repl-parse)

(define core-parser
  (parser

   (start prog) ; the start nonterminal is prog
   (end EOF) ; define the final of the input stream as EOF
   (tokens value-tokens op-tokens)
   (src-pos)
   (error   
    (lambda (tok-ok tok-name tok-value d end-pos)
      (begin (printf "parse error when found token ~a at line ~a and column ~a" tok-name (position-line d) (position-col d))
             (void))))
   
   (grammar

    (prog [() '()]
          [(clause prog) (cons $1 $2)])

    (clause [(head DOT) (ast:clause $1 '())]
            [(head ARROW body DOT) (ast:clause $1 $3)])

    (body [(body-elem) $1]
          [(body-elem COMMA body) (cons $1 $3)])

    (body-elem [(term) $1]
          [(term EQ term) (ast:eq $1 $3)]
          [(term NEQ term) (ast:neq $1 $3)])
    
    (term [(VAR) (ast:var $1)]
          [(head) $1])
    
    (head [(ATOM) (ast:atom $1)]
          [(functor) $1])
   
    (functor [(ATOM LPAREN args RPAREN) (ast:functor $1 $3)])
    
    (args [(arg) $1]
          [(arg COMMA args) (cons $1 $3)])

    (arg [(term) $1]
         [(UNKNOW-VAR) (ast:unknow-var)])
    
     )))

(define (parse ip)
  (port-count-lines! ip)
  (core-parser (lambda () (next-token ip))))


(define repl-core-parser
  (parser

   (start query) ; the start nonterminal is query
   (end EOF) ; define the final of the input stream as EOF
   (tokens value-tokens op-tokens)
   (src-pos)
   (error   
    (lambda (tok-ok tok-name tok-value d end-pos)
      (begin (printf "parse error when found token ~a at line ~a and column ~a" tok-name (position-line d) (position-col d))
             (void))))
   
   (grammar

    (query [(body DOT) $1])

    (body [(body-elem) $1]
          [(body-elem COMMA body) (cons $1 $3)])

    (body-elem [(term) $1]
          [(term EQ term) (ast:eq $1 $3)]
          [(term NEQ term) (ast:neq $1 $3)])
    
    (term [(VAR) (ast:var $1)]
          [(head) $1])
    
    (head [(ATOM) (ast:atom $1)]
          [(functor) $1])
   
    (functor [(ATOM LPAREN args RPAREN) (ast:functor $1 $3)])
    
    (args [(arg) $1]
          [(arg COMMA args) (cons $1 $3)])

    (arg [(term) $1]
         [(UNKNOW-VAR) (ast:unknow-var)])
     )))


(define (repl-parse ip)
  (port-count-lines! ip)
  (repl-core-parser (lambda () (next-token ip))))

            
(define p (open-input-string
           "
parent(pam, bob), X.

"))
