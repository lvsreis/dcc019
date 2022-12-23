#lang racket

(require parser-tools/lex
         (prefix-in :  parser-tools/lex-sre))

(provide value-tokens op-tokens next-token)

(define-tokens value-tokens
  (INT ID))

(define-empty-tokens op-tokens
  (EOF EQ
       MINUS
       LPAREN
       RPAREN
       COMMA
       SEMI
       ZERO?
       IF
       THEN
       ELSE
       LET
       IN
       PROC
       LETREC
       BEGIN
       END
       NOT
       SET
       VAR
       WHILE
       PRINT
       LBRACE
       RBRACE
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
   ["if" (token-IF)]
   ["then" (token-THEN)]
   ["else" (token-ELSE)]
   ["let" (token-LET)]
   ["in" (token-IN)]
   ["proc" (token-PROC)]
   ["letrec" (token-LETREC)]
   ["begin" (token-BEGIN)]
   ["end" (token-END)]
   ["not" (token-NOT)]
   ["set" (token-SET)]
   ["var" (token-VAR)]
   ["while" (token-WHILE)]
   ["print" (token-PRINT)]
   [(:: alphabetic (:* (:or alphabetic numeric))) (token-ID lexeme)]
   [(:+ numeric) (token-INT (string->number lexeme))]))

