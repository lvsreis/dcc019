#lang racket

(require dcc019/exercise/let/parser
         dcc019/exercise/let/interpreter
         dcc019/util/env)

(provide (rename-out [let-read read]
                     [let-read-syntax read-syntax]))

(define (let-read in)
  (syntax->datum
   (let-read-syntax #f in)))

(define (let-read-syntax path port)
  (datum->syntax
   #f
   `(module let-mod racket
      ,(value-of (parse port) init-env)))) ; change the environment
