#lang racket

(require dcc019/util/env
         dcc019/inferred/ast
         dcc019/inferred/type)

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

; Representação dos tipos
; Type = 'int | 'bool | '(-> Type Type) | (tyvar num)


; type-of :: Expr x Env x Subst -> (Type . Subst)
(define (type-of exp env sub)
  (match exp
    [(ast:int n) (cons 'int sub)]
    [(ast:var v) (cons (apply-env env v) sub)]
    [(ast:dif e1 e2) (let [(r₁ (type-of e1 env sub))]
                       (let [(sub₁ (unifier (car r₁) 'int (cdr r₁)))]
                         (let [(r₂ (type-of e2 env sub₁))]
                           (let [(sub₂ (unifier (car r₂) 'int (cdr r₂)))]
                             (cons 'int sub₂)))))]
    [(ast:zero? e) (let [(t (type-of e env sub))]
                     (let [(sub₂ (unifier (car t) 'int (cdr t)))]
                       (cons 'bool sub₂)))]
    [(ast:if e1 e2 e3) (let [(r₁ (type-of e1 env sub))]
                         (let [(sub₁ (unifier (car r₁) 'bool (cdr r₁)))]
                           (let [(r₂ (type-of e2 env sub₁))]
                             (let [(r₃ (type-of e3 env (cdr r₂)))]
                               (let [(sub₂ (unifier (car r₂) (car r₃) (cdr r₃)))]
                                 (cons (car r₂) sub₂))))))]
    [(ast:call e1 e2) (let [(result-type (new-tyvar))
                            (r₁ (type-of e1 env sub))]
                        (let [(r₂ (type-of e2 env (cdr r₁)))]
                          (let [(sub₁ (unifier (car r₁) (list '-> (car r₂) result-type) (cdr r₂)))]
                            (cons result-type sub₁))))]
    [(ast:proc (ast:var v) _ e) (let* [(vtype (new-tyvar))
                                       (r₁ (type-of e (extend-env v vtype env) sub))]
                                  (cons (list '-> vtype (car r₁)) (cdr r₁)))]

    [(ast:let (ast:var v) e1 e2) (let [(r (type-of e1 env sub))]
                                   (type-of e2 (extend-env v (car r) env) (cdr r)))]
    [(ast:letrec _ (ast:var f) (ast:var v) _ e1 e2)
     (let* [(arg-type (new-tyvar))
            (ret-type (new-tyvar))
            (r₁ (type-of e1 (extend-env v arg-type
                                        (extend-env f (list '-> arg-type ret-type) env))
                         sub))
            (sub (unifier ret-type (car r₁) (cdr r₁)))]
       (type-of e2 (extend-env f (list '-> arg-type ret-type) env) sub))]    
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
  (type-of prog init-env empty-subst)
  (value-of prog init-env))
