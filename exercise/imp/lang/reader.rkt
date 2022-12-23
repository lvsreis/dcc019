#lang racket

(require dcc019/exercise/imp/parser
         dcc019/exercise/imp/interpreter)

(provide (rename-out [imp-read read]
                     [imp-read-syntax read-syntax]))

(define (imp-read in)
  (syntax->datum
   (imp-read-syntax #f in)))

(define (imp-read-syntax path port)
  (datum->syntax
   #f
   `(module imp-mod racket
      ,(value-of-program (parse port)))))
