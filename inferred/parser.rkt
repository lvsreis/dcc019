#lang racket

(require parser-tools/yacc
         dcc019/inferred/lexer
         dcc019/inferred/ast)

(provide parse)

(define core-parser
  (parser

   (start exp) ; the start nonterminal is exp
   (end EOF) ; define the final of the input stream as EOF
   (tokens value-tokens op-tokens)
   (src-pos)
   (error
    (lambda (a b c d e)
      (begin (printf ("parse error:\na = ~a\nb = ~a\nc = ~a\nd = ~a\ne = ~a\n" a b c d e))
             (void))))

   (grammar

    (exp [(INT) (ast:int $1)]
         [(MINUS LPAREN exp COMMA exp RPAREN ) (ast:dif $3 $5)] ; -(exp, exp)
         [(ZERO? LPAREN exp RPAREN) (ast:zero? $3)] ; zero? (exp)
         [(IF exp THEN exp ELSE exp) (ast:if $2 $4 $6)] ; if exp then exp else exp
         [(VAR) (ast:var $1)]
         [(LET VAR EQ exp IN exp) (ast:let (ast:var $2) $4 $6)]
         [(PROC LPAREN VAR opt-type RPAREN exp) (ast:proc (ast:var $3) $4 $6)]
         [(LPAREN exp exp RPAREN) (ast:call $2 $3)]
         [(LETREC opt-return-type VAR LPAREN VAR opt-type RPAREN EQ exp IN exp) (ast:letrec $2 (ast:var $3) (ast:var $5) $6 $9 $11)]
         )

    (opt-return-type [() (ast:non-type)]
              [(type) $1])
    
    (opt-type [() (ast:non-type)]
              [(COLON type) $2])
    
    (type [(INT-TYPE) (ast:int-type)]
          [(BOOL-TYPE) (ast:bool-type)]
          [(LPAREN type ARROW type RPAREN) (ast:arrow-type $2 $4)])
    )))

(define (parse ip)
  (port-count-lines! ip)
  (core-parser (lambda () (next-token ip))))

                     
            
