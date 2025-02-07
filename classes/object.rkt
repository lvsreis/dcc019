#lang racket

(require dcc019/util/memory
         dcc019/classes/class)

(provide new-obj
         get-class
         get-locations)


; it returns the class descriptor of an object
(define (get-class obj)
  'to-implement:get-class
  )

; it returns the list of location for the object fields
(define (get-locations obj)
  'to-implement:get-locations
  )

; this function recieves a class descritor and returns a object of it
(define (new-obj c)
  'to-implement:new-obj
  )
