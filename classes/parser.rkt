#lang racket

(require parser-tools/yacc
         dcc019/classes/lexer
         dcc019/classes/ast)

(provide parse)

(define core-parser
  (parser

   (start prog) ; the start nonterminal is exp
   (end EOF) ; define the final of the input stream as EOF
   (tokens value-tokens op-tokens)
   (src-pos)
   (error
    (lambda (a b c d e)
      (begin (printf "parse error:\na = ~a\nb = ~a\nc = ~a\nd = ~a\ne = ~a\n" a b c d e)
             (void))))

   (grammar

    (prog [(decls exp) (ast:prog $1 $2)])

    (decls [() '()]
           [(decl decls) (cons $1 $2)])
    (decl [(CLASS VAR EXTENDS VAR fields methods) (ast:decl (ast:var $2) (ast:var $4) $5 $6)])

    (fields [() '()]
            [(FIELD VAR fields) (cons (ast:var $2) $3)])

    (methods [() '()]
             [(METHOD VAR LPAREN args? RPAREN exp methods) (cons (ast:method (ast:var $2) $4 $6) $7)])
    (args? [() '()]
           [(VAR args) (cons (ast:var $1) $2)])
    (args [() '()]
          [(COMMA VAR args) (cons (ast:var $2) $3)])

    (exp [(INT) (ast:int $1)]
         [(MINUS LPAREN exp COMMA exp RPAREN ) (ast:dif $3 $5)] ; -(exp, exp)
         [(ZERO? LPAREN exp RPAREN) (ast:zero? $3)] ; zero? (exp)
         [(IF exp THEN exp ELSE exp) (ast:if $2 $4 $6)] ; if exp then exp else exp
         [(VAR) (ast:var $1)]
         [(LET VAR EQ exp IN exp) (ast:let (ast:var $2) $4 $6)]
         [(PROC LPAREN VAR RPAREN exp) (ast:proc (ast:var $3) $5)]
         [(LPAREN exp exp RPAREN) (ast:call $2 $3)]
         [(LETREC VAR LPAREN VAR RPAREN EQ exp IN exp) (ast:letrec (ast:var $2) (ast:var $4) $7 $9)]
         [(BEGIN exp exps END) (ast:begin (cons $2 $3))]
         [(SET VAR EQ exp) (ast:assign (ast:var $2) $4)]
         [(NEW VAR LPAREN params? RPAREN) (ast:new (ast:var $2) $4)]
         [(SEND exp VAR LPAREN params? RPAREN) (ast:send $2 (ast:var $3) $5)]
         [(SUPER VAR LPAREN params? RPAREN) (ast:super (ast:var $2) $4)]
         [(SELF) (ast:self)])

    (params? [() '()]
             [(exp params) (cons $1 $2)])
    (params [() '()]
            [(COMMA exp params) (cons $2 $3)])
    
    (exps [() '()]
          [(SEMI exp exps) (cons $2 $3)])
    )))

(define (parse ip)
  (port-count-lines! ip)
  (core-parser (lambda () (next-token ip))))

                     
            
