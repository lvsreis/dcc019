#lang racket

(provide empty-store
         newref
         freeref
         deref
         setref!
         σ)
         

; Representação da memória usando o vetor e uma lista endereços disponíveis
(struct store (mem free) #:transparent)

(define TAM 100) ; tamanho da memória

(define (init-free-address tam)
  (if (> tam 0)
      (range 0 tam)
      '()))

(define (init-store tam)
  (store (make-vector tam) (init-free-address tam)))

(define σ (init-store TAM)) ; the global store

; empty-store
(define (empty-store) (set! σ (init-store TAM)))

;newref :: ExpVal -> Ref
(define (newref v)
  (if (empty? (store-free σ))
      (error "Memory overflow")
      (let ([addr (first (store-free σ))] ; the first available reference
            [free-ref (rest (store-free σ))] ; the list of available reference without the first one
            [mem (store-mem σ)]) ; the memory vector
        (begin
          (vector-set! mem addr v) ; set the value v in memory reference addr
          (set! σ (store mem free-ref)) ; set the new memory state
          addr)))) ; return the reference address

; deref :: Ref -> ExpVal
(define (deref addr)
  (if (or (< addr 0) (> addr (sub1 TAM)))
      (error "Memory error: trying to access an invalid location")
      (vector-ref (store-mem σ) addr)))

; setref! :: Ref x ExpVal -> ?
(define (setref! addr v)
  (if (or (< addr 0) (> addr (sub1 TAM)))
      (error "Memory error: trying to access an invalid location")
      (vector-set! (store-mem σ) addr v)))

; freeref :: Ref -> ?
(define (freeref addr)
  (if (or (< addr 0) (> addr (sub1 TAM)))
      (error (format "Memory error: reference ~a is not a valid location" addr))
      (let ([free (cons addr (store-free σ))])
        (set! σ (store (store-mem σ) free)))))
