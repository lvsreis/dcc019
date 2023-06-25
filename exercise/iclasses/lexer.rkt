#lang racket

(require parser-tools/lex
         (prefix-in :  parser-tools/lex-sre))

(provide value-tokens op-tokens next-token)

(define-tokens value-tokens
  (INT ID))

(define-empty-tokens op-tokens
  (EOF ; LET related tokens
       EQ
       MINUS
       LPAREN
       RPAREN
       COMMA
       ZERO?
       NOT
       IF
       THEN
       ELSE
       LET
       IN
       TRUE
       FALSE
       ; statements tokens
       SEMI
       VAR
       WHILE
       PRINT
       RETURN
       LBRACE
       RBRACE
       ; CLASSES related tokens
       CLASS
       EXTENDS
       FIELD
       METHOD
       NEW
       SEND
       SUPER
       SELF
       ))

(define next-token
  (lexer-src-pos
   [(eof) (token-EOF)]
   [(:+ whitespace #\newline) (return-without-pos (next-token input-port))]
   [(:: "%" (:* (:~ #\newline)) #\newline) (return-without-pos (next-token input-port))]
   ["=" (token-EQ)]
   ["-" (token-MINUS)]
   ["(" (token-LPAREN)]
   [")" (token-RPAREN)]
   ["{" (token-LBRACE)]
   ["}" (token-RBRACE)]
   ["," (token-COMMA)]
   [";" (token-SEMI)]
   ["zero?" (token-ZERO?)]
   ["¬" (token-NOT)]
   ["if" (token-IF)]
   ["then" (token-THEN)]
   ["else" (token-ELSE)]
   ["let" (token-LET)]
   ["in" (token-IN)]
   ["var" (token-VAR)]
   ["while" (token-WHILE)]
   ["print" (token-PRINT)]
   ["return" (token-RETURN)]
   ["class" (token-CLASS)]
   ["extends" (token-EXTENDS)]
   ["field" (token-FIELD)]
   ["method" (token-METHOD)]
   ["new" (token-NEW)]
   ["send" (token-SEND)]
   ["super" (token-SUPER)]
   ["self" (token-SELF)]
   ["true" (token-TRUE)]
   ["false" (token-FALSE)]
   [(:: alphabetic (:* (:or alphabetic numeric))) (token-ID lexeme)]
   [(:+ numeric) (token-INT (string->number lexeme))]))

