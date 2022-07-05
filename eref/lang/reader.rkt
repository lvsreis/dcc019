#lang racket

(require dcc019/eref/parser
         dcc019/eref/interpreter)

(provide (rename-out [eref-read read]
                     [eref-read-syntax read-syntax]))

(define (eref-read in)
  (syntax->datum
   (eref-read-syntax #f in)))

(define (eref-read-syntax path port)
  (datum->syntax
   #f
   `(module eref-mod racket
      ,(value-of-program (parse port)))))
