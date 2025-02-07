#lang racket

(require dcc019/util/env)

(provide get-fields
         find-method
         build-descriptor
         object-class
         get-method-env)

; the class descriptor of the object class, the super class of all
(define object-class 'to-implement:object-class)


; it returns a list of the fields name for a given class
(define (get-fields c)
;  'to-implement:get-fields
  (list 'i 'j)
  )

; it returns the method environment of the class
(define (get-method-env c)
  'to-implement:get-method-env
  )

; it returns a method m of a given class descriptor
(define (find-method c m)
  (apply-env (get-method-env c) m))

(define (build-descriptor super fields mth-env)
  'to-implement:build-descriptor
  )

