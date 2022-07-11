#lang racket

(require dcc019/classes/parser
         dcc019/classes/interpreter)

(provide (rename-out [classes-read read]
                     [classes-read-syntax read-syntax]))

(define (classes-read in)
  (syntax->datum
   (classes-read-syntax #f in)))

(define (classes-read-syntax path port)
  (datum->syntax
   #f
   `(module classes-mod racket
      ,(value-of-program (parse port)))))
