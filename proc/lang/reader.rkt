#lang racket

(require dcc019/proc/parser
         dcc019/proc/interpreter
         dcc019/util/env)

(provide (rename-out [proc-read read]
                     [proc-read-syntax read-syntax]))

(define (proc-read in)
  (syntax->datum
   (proc-read-syntax #f in)))

(define (proc-read-syntax path port)
  (datum->syntax
   #f
   `(module proc-mod racket
      ,(value-of (parse port) init-env)))) ; change the environment
