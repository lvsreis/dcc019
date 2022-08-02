#lang racket

(require parser-tools/lex
         (prefix-in :  parser-tools/lex-sre))

(provide value-tokens op-tokens next-token)

(define-tokens value-tokens
  ;(INT BOOL VAR))
  (INT VAR))

(define-empty-tokens op-tokens
  (EOF EQ
       MINUS
       LPAREN
       RPAREN
       COMMA
       COLON
       ARROW
       ZERO?
       IF
       THEN
       ELSE
       LET
       IN
       PROC
       LETREC
       INT-TYPE
       BOOL-TYPE
       ;TRUE
       ;FALSE
       ))

(define next-token
  (lexer-src-pos
   [(eof) (token-EOF)]
   [(:+ whitespace #\newline) (return-without-pos (next-token input-port))]
   [(:: ";" (:* (:~ #\newline)) #\newline) (return-without-pos (next-token input-port))]
   ["=" (token-EQ)]
   ["-" (token-MINUS)]
   ["(" (token-LPAREN)]
   [")" (token-RPAREN)]
   ["," (token-COMMA)]
   [":" (token-COLON)]
   ["->" (token-ARROW)]
   ["zero?" (token-ZERO?)]
   ["if" (token-IF)]
   ["then" (token-THEN)]
   ["else" (token-ELSE)]
   ["let" (token-LET)]
   ["in" (token-IN)]
   ["proc" (token-PROC)]
   ["letrec" (token-LETREC)]
   ["int" (token-INT-TYPE)]
   ["bool" (token-BOOL-TYPE)]
   #;["true" (token-TRUE)]
   #;["false" (token-FALSE)]
   [(:: alphabetic (:* (:or alphabetic numeric))) (token-VAR lexeme)]
   [(:+ numeric) (token-INT (string->number lexeme))]))

