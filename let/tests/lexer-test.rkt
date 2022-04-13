#lang racket

(require dcc019/let/lexer
         parser-tools/lex)

(provide my-lex-test)

(define (lex-text ip)
  (port-count-lines! ip)
  (letrec ([one-line
            (lambda ()
              (let ([result (next-token ip)])
                (unless (equal? (position-token-token result) 'EOF)
                  (printf "~a\n" result)
                  (one-line)
                  )))])
    (one-line)))

(define (my-lex-test str)
  (lex-text (open-input-string str)))
