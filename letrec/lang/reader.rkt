#lang racket

(require dcc019/letrec/parser
         dcc019/letrec/interpreter
         dcc019/util/env)

(provide (rename-out [letrec-read read]
                     [letrec-read-syntax read-syntax]))

(define (letrec-read in)
  (syntax->datum
   (letrec-read-syntax #f in)))

(define (letrec-read-syntax path port)
  (datum->syntax
   #f
   `(module letrec-mod racket
      ,(value-of (parse port) init-env))))
