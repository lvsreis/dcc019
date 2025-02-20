#lang racket

(require dcc019/util/env
         dcc019/util/memory
         dcc019/eref/ast)

(provide value-of-program)

; Representação de procedimentos para escopo estático

; proc-val :: Var x Expr x Env -> Proc
(define (proc-val var exp Δ)
  (lambda (val)
    (value-of exp (extend-env var val Δ))))

; apply-proc :: Proc x ExpVal -> ExpVal  
(define (apply-proc proc val)
  (proc val))

; Criação de ambiente estendido com procedimento recursivo
(define (extend-env-rec name var body env)
  (lambda (svar)
    (if (equal? svar name)
        (proc-val var body (extend-env-rec name var body env))
        (apply-env env svar))))

; value-of :: Exp -> ExpVal
(define (value-of exp Δ)  
  (match exp
    [(ast:int n) n]
    [(ast:dif e1 e2) (- (value-of e1 Δ) (value-of e2 Δ))]
    [(ast:zero? e) (zero? (value-of e Δ))]
    [(ast:if e1 e2 e3) (if (value-of e1 Δ) (value-of e2 Δ) (value-of e3 Δ))]
    [(ast:var v) (apply-env Δ v)]
    [(ast:let (ast:var v) e1 e2) (value-of e2 (extend-env v (value-of e1 Δ) Δ))]
    [(ast:proc (ast:var v) e) (proc-val v e Δ)]
    [(ast:call e1 e2) (apply-proc (value-of e1 Δ) (value-of e2 Δ))]
    [(ast:letrec (ast:var f) (ast:var v) e1 e2) (value-of e2 (extend-env-rec f v e1 Δ))]
    [(ast:begin es) (foldl (lambda (e v) (value-of e Δ)) (value-of (first es) Δ) (rest es))]
    [(ast:newref e) (newref (value-of e Δ))]
    [(ast:freeref e) (freeref (value-of e Δ))]
    [(ast:deref e) (deref (value-of e Δ))]
    [(ast:setref e₁ e₂) (setref! (value-of e₁ Δ) (value-of e₂ Δ))]    
    [e (raise-user-error "unimplemented-construction: " e)]
    )
  )

(define (value-of-program prog)
  (empty-store)
  (value-of prog init-env))

