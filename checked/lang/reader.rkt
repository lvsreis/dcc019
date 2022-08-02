#lang racket

(require dcc019/checked/parser
         dcc019/checked/interpreter)

(provide (rename-out [checked-read read]
                     [checked-read-syntax read-syntax]))

(define (checked-read in)
  (syntax->datum
   (checked-read-syntax #f in)))

(define (checked-read-syntax path port)
  (datum->syntax
   #f
   `(module checked-mod racket
      ,(value-of-program (parse port)))))
