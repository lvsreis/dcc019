#lang racket

(require dcc019/iref/parser
         dcc019/iref/interpreter)

(provide (rename-out [iref-read read]
                     [iref-read-syntax read-syntax]))

(define (iref-read in)
  (syntax->datum
   (iref-read-syntax #f in)))

(define (iref-read-syntax path port)
  (datum->syntax
   #f
   `(module iref-mod racket
      ,(value-of-program (parse port)))))
