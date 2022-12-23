#lang racket

(require parser-tools/yacc
         dcc019/exercise/imp/lexer
         dcc019/exercise/imp/ast)

(provide parse)

(define core-parser
  (parser

   (start stmt) ; the start nonterminal is exp
   (end EOF) ; define the final of the input stream as EOF
   (tokens value-tokens op-tokens)
   (src-pos)
   (error
    (lambda (a b c d e)
      (begin (printf "parse error:\na = ~a\nb = ~a\nc = ~a\nd = ~a\ne = ~a\n" a b c d e)
             (void))))

   (grammar

    (stmt [(ID EQ exp) (ast:assign (ast:var $1) $3)]
          [(PRINT exp) (ast:print $2)]
          [(LBRACE stmt stmts RBRACE) (ast:block (cons $2 $3))]
          [(IF exp stmt stmt) (ast:if-stmt $2 $3 $4)]
          [(WHILE exp stmt) (ast:while $2 $3)]
          [(VAR ID SEMI stmt) (ast:local-decl (ast:var $2) $4)])

    (stmts [() '()]
           [(SEMI stmt stmts) (cons $2 $3)])
    
    (exp [(INT) (ast:int $1)]
         [(MINUS LPAREN exp COMMA exp RPAREN ) (ast:dif $3 $5)] ; -(exp, exp)
         [(ZERO? LPAREN exp RPAREN) (ast:zero? $3)] ; zero? (exp)
         [(NOT LPAREN exp RPAREN) (ast:not $3)] ; not (exp)
         [(IF exp THEN exp ELSE exp) (ast:if $2 $4 $6)] ; if exp then exp else exp
         [(ID) (ast:var $1)]
         [(LET ID EQ exp IN exp) (ast:let (ast:var $2) $4 $6)]
         [(PROC LPAREN ID RPAREN exp) (ast:proc (ast:var $3) $5)]
         [(LPAREN exp exp RPAREN) (ast:call $2 $3)]
         [(LETREC ID LPAREN ID RPAREN EQ exp IN exp) (ast:letrec (ast:var $2) (ast:var $4) $7 $9)]
         [(BEGIN exp exps END) (ast:begin (cons $2 $3))]
         ;[(SET ID EQ exp) (ast:assign (ast:var $2) $4)]
         )
    (exps [() '()]
          [(SEMI exp exps) (cons $2 $3)])
    )))

(define (parse ip)
  (port-count-lines! ip)
  (core-parser (lambda () (next-token ip))))

                     
            
