#lang racket

(require parser-tools/yacc
         dcc019/let/lexer
         dcc019/let/ast)

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

    (exp [(INT) (int-ast $1)]
         [(MINUS LPAREN exp COMMA exp RPAREN ) (diff-ast $3 $5)] ; -(exp, exp)
         [(ZERO? LPAREN exp RPAREN) (zero?-ast $3)] ; zero? (exp)
         [(IF exp THEN exp ELSE exp) (if-ast $2 $4 $6)] ; if exp then exp else exp
         [(VAR) (var-ast $1)]
         [(LET VAR EQ exp IN exp) (let-ast (var-ast $2) $4 $6)]
    ))))

(define (parse ip)
  (port-count-lines! ip)
  (core-parser (lambda () (next-token ip))))

                     
            
