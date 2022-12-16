#lang racket

(require dcc019/exercise/let/ast
         dcc019/util/env)

(provide value-of)

; value-of :: Exp -> ExpVal
(define (value-of exp Δ)
  (match exp
    [(int-ast n) n]
    [(diff-ast e1 e2) (- (value-of e1 Δ) (value-of e2 Δ))]
    [(zero?-ast e) (zero? (value-of e Δ))]
    [(if-ast e1 e2 e3) (if (value-of e1 Δ) (value-of e2 Δ) (value-of e3 Δ))]
    [(var-ast v) (apply-env Δ v)]
    [(let-ast (var-ast v) e1 e2) (value-of e2 (extend-env v (value-of e1 Δ) Δ))]
    ; put your solution for exercise 1 here
    
    [e (raise-user-error "unimplemented-construction: " e)]
    )
  )
