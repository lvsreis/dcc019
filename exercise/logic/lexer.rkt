#lang racket

(require parser-tools/lex
         (prefix-in :  parser-tools/lex-sre))

(provide value-tokens op-tokens next-token)

(define-tokens value-tokens
  (VAR ATOM))

(define-empty-tokens op-tokens
  (EOF DOT
       COMMA
       LPAREN
       RPAREN
       ARROW
       EQ
       NEQ
       UNKNOW-VAR
       ))

(define next-token
  (lexer-src-pos
   [(eof) (token-EOF)]
   [(:+ whitespace #\newline) (return-without-pos (next-token input-port))]
   [(:: "/*" (complement (:: any-string "*/" any-string)) "*/") (return-without-pos (next-token input-port))]
   [(:: "%" (:* (:~ #\newline)) #\newline) (return-without-pos (next-token input-port))]
   ["=" (token-EQ)]
   ["\\=" (token-NEQ)]
   ["." (token-DOT)]
   ["(" (token-LPAREN)]
   [")" (token-RPAREN)]
   ["," (token-COMMA)]
   [":-" (token-ARROW)]
   ["_" (token-UNKNOW-VAR)]
   [(:: lower-case (:* (:or alphabetic numeric "_"))) (token-ATOM lexeme)]
   [(:: (:or upper-case "_") (:* (:or alphabetic numeric "_"))) (token-VAR lexeme)]))

