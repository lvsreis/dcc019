#lang racket

(require dcc019/util/env
         dcc019/checked/ast)

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

(define (ast2type type)
  (match type
    [(ast:int-type) 'int]
    [(ast:bool-type) 'bool]
    [(ast:arrow-type t1 t2) (list '-> (ast2type t1) (ast2type t2))]
  ))

; Type = 'int | 'bool | '(-> Type Type)
; value-of :: Exp -> Type
(define (type-of exp Δ)
  (match exp
    [(ast:int n) 'int]
    [(ast:dif e1 e2) (if (and (equal? (type-of e1 Δ) 'int)
                                       (equal? (type-of e2 Δ) 'int))
                                  'int (raise-user-error "Type error on dif expression"))]
    [(ast:zero? e) (if (equal? (type-of e Δ) 'int) 'bool
                       ((raise-user-error "Type error on zero? expression")))]
    [(ast:if e1 e2 e3) (if (equal? (type-of e1 Δ) 'bool)
                           (let [(t₁ (type-of e2 Δ)) (t₂ (type-of e3 Δ))]
                             (if (equal? t₁ t₂) t₁ (raise-user-error "Different types on if-then-else")))
                           (raise-user-error "The test expression is not a boolean type"))]
    [(ast:var v) (apply-env Δ v)]
    [(ast:let (ast:var v) e1 e2) (type-of e2 (extend-env v (type-of e1 Δ) Δ))]
    ; t₁ = (-> t t')
    [(ast:proc (ast:var v) t e) (list '-> (ast2type t)
                                     (type-of e (extend-env v (ast2type t) Δ)))]
    [(ast:call e1 e2) (let [(t₁ (type-of e1 Δ)) (t₂ (type-of e2 Δ))]
                                 (if (and (list? t₁) (equal? (car t₁) '->))
                                     (if (equal? (cadr t₁) t₂) (caddr t₁)
                                         (raise-user-error "Mismatching typing on function call"))
                                     (raise-user-error "Function application is wrong")))]
    [(ast:letrec r (ast:var f) (ast:var v) t e1 e2)
     (let* [(arg-type (ast2type t))
            (ret-type (ast2type r))
            (fun-type (list '-> arg-type ret-type))]
       (if (equal? (type-of e1 (extend-env v arg-type
                                           (extend-env f fun-type Δ))) ret-type)
           (type-of e2 (extend-env f fun-type Δ))
           (raise-user-error "Mismatching typing on letrec")))]
    [e (raise-user-error "unimplemented-construction: " e)]
    )
  )

; value-of :: Exp -> ExpVal
(define (value-of exp Δ)
  (match exp
    [(ast:int n) n]
    [(ast:dif e1 e2) (- (value-of e1 Δ) (value-of e2 Δ))]
    [(ast:zero? e) (zero? (value-of e Δ))]
    [(ast:if e1 e2 e3) (if (value-of e1 Δ) (value-of e2 Δ) (value-of e3 Δ))]
    [(ast:var v) (apply-env Δ v)]
    [(ast:let (ast:var v) e1 e2) (value-of e2 (extend-env v (value-of e1 Δ) Δ))]
    [(ast:proc (ast:var v) _ e) (proc-val v e Δ)]
    [(ast:call e1 e2) (apply-proc (value-of e1 Δ) (value-of e2 Δ))]
    [(ast:letrec _ (ast:var f) (ast:var v) _ e1 e2) (value-of e2 (extend-env-rec f v e1 Δ))]
    [e (raise-user-error "unimplemented-construction: " e)]
    )
  )

(define (value-of-program prog)
  (type-of prog init-env)
  (value-of prog init-env))
