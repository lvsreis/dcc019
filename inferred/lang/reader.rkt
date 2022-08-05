#lang racket

(require dcc019/inferred/parser
         dcc019/inferred/interpreter)

(provide (rename-out [inferred-read read]
                     [inferred-read-syntax read-syntax]))

(define (inferred-read in)
  (syntax->datum
   (inferred-read-syntax #f in)))

(define (inferred-read-syntax path port)
  (datum->syntax
   #f
   `(module inferred-mod racket
      ,(value-of-program (parse port)))))
