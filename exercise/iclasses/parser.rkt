#lang racket

(require parser-tools/yacc
         dcc019/exercise/iclasses/lexer
         dcc019/exercise/iclasses/ast)

(provide parse)

(define core-parser
  (parser

   (start prog) ; the start nonterminal is prog
   (end EOF) ; define the final of the input stream as EOF
   (tokens value-tokens op-tokens)
   (src-pos)
   (error
    (lambda (a b c d e)
      (begin (printf "parse error:\na = ~a\nb = ~a\nc = ~a\nd = ~a\ne = ~a\n" a b c d e)
             (void))))

   (grammar

    (prog [(decls stmt) (ast:prog $1 $2)])

    (decls [() '()]
           [(decl decls) (cons $1 $2)])
    (decl [(CLASS ID EXTENDS ID fields methods) (ast:decl (ast:var $2) (ast:var $4) $5 $6)])

    (fields [() '()]
            [(FIELD ID fields) (cons (ast:var $2) $3)])

    (methods [() '()]
             [(METHOD ID LPAREN args? RPAREN stmt methods) (cons (ast:method (ast:var $2) $4 $6) $7)])
    (args? [() '()]
           [(ID args) (cons (ast:var $1) $2)])
    (args [() '()]
          [(COMMA ID args) (cons (ast:var $2) $3)])

    (stmt [(ID EQ exp) (ast:assign (ast:var $1) $3)]
          [(PRINT exp) (ast:print $2)]
          [(RETURN exp) (ast:return $2)]
          [(LBRACE stmt stmts RBRACE) (ast:block (cons $2 $3))]
          [(IF exp stmt stmt) (ast:if-stmt $2 $3 $4)]
          [(WHILE exp stmt) (ast:while $2 $3)]
          [(VAR ID SEMI stmt) (ast:local-decl (ast:var $2) $4)]
          ; chamdas de métodos também são tratados como comandos
          [(SEND exp ID LPAREN params? RPAREN) (ast:send $2 (ast:var $3) $5)]
          [(SUPER ID LPAREN params? RPAREN) (ast:super (ast:var $2) $4)]
          )

    (stmts [() '()]
           [(SEMI stmt stmts) (cons $2 $3)])
    
    (exp [(INT) (ast:int $1)]
         [(TRUE) (ast:bool #t)]
         [(FALSE) (ast:bool #f)]
         [(MINUS LPAREN exp COMMA exp RPAREN ) (ast:dif $3 $5)] ; -(exp, exp)
         [(ZERO? LPAREN exp RPAREN) (ast:zero? $3)] ; zero? (exp)
         [(NOT exp) (ast:not $2)] ; ¬ exp
         [(IF exp THEN exp ELSE exp) (ast:if $2 $4 $6)] ; if exp then exp else exp
         [(ID) (ast:var $1)]
         [(LET ID EQ exp IN exp) (ast:let (ast:var $2) $4 $6)]
         ; expressation related to objected oriented programmig
         [(NEW ID LPAREN params? RPAREN) (ast:new (ast:var $2) $4)]
         [(SEND exp ID LPAREN params? RPAREN) (ast:send $2 (ast:var $3) $5)]
         [(SUPER ID LPAREN params? RPAREN) (ast:super (ast:var $2) $4)]
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

                     
            
