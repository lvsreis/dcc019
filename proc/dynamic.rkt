#lang racket

(module reader racket
  (require dcc019/proc/parser
           dcc019/proc/ast
           dcc019/util/env)

  (provide (rename-out [proc-read read]
                       [proc-read-syntax read-syntax]))
 
  ; Representação de procedimentos

  ; Escopo Dinâmico
  ; proc-val :: Var x Expr -> Proc
  (define (proc-val var exp)
    (lambda (val Δ)
      (value-of exp (extend-env var val Δ))))

  ; apply-proc :: Proc x ExpVal x Env -> ExpVal
  (define (apply-proc proc val Δ)
    (proc val Δ))
  
  ; value-of :: Exp -> ExpVal
  (define (value-of exp Δ)
    (match exp
      [(ast:int n) n]
      [(ast:dif e1 e2) (- (value-of e1 Δ) (value-of e2 Δ))]
      [(ast:zero? e) (zero? (value-of e Δ))]
      [(ast:if e1 e2 e3) (if (value-of e1 Δ) (value-of e2 Δ) (value-of e3 Δ))]
      [(ast:var v) (apply-env Δ v)]
      [(ast:let (ast:var v) e1 e2) (value-of e2 (extend-env v (value-of e1 Δ) Δ))]
      [(ast:proc (ast:var v) e) (proc-val v e)]
      [(ast:call e1 e2) (apply-proc (value-of e1 Δ) (value-of e2 Δ) Δ)]
      [e (raise-user-error "unimplemented-construction: " e)]
      )
    )

  (define (proc-read in)
  (syntax->datum
   (proc-read-syntax #f in)))

  (define (proc-read-syntax path port)
    (datum->syntax
     #f
     `(module proc-dynamic-mod racket
        ,(value-of (parse port) init-env))))
  )
