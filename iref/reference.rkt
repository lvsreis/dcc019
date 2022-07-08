#lang racket

(module reader racket
  (require dcc019/iref/parser
           dcc019/iref/ast
           dcc019/util/env
           dcc019/util/memory)

  (provide (rename-out [iref-read read]
                       [iref-read-syntax read-syntax]))

  ; Representação de procedimentos para escopo estático

  ; call-by-reference
  (define (proc-val var exp Δ)
    (lambda (val flag)
      (if flag (value-of exp (extend-env var (newref val) Δ))
          (value-of exp (extend-env var val Δ)))))
  
  (define (apply-proc proc val)
    (proc val #t))
  
  (define (apply-proc-ref proc val)
    (proc val #f))
  
  ; Criação de ambiente estendido com procedimento recursivo
  (define (extend-env-rec name var body env)
    (lambda (svar)
      (if (equal? svar name)
          (newref (proc-val var body (extend-env-rec name var body env)))
          (apply-env env svar))))
  
  ; value-of :: Exp -> ExpVal
  (define (value-of exp Δ)
    (match exp
      [(ast:int n) n]
      [(ast:dif e1 e2) (- (value-of e1 Δ) (value-of e2 Δ))]
      [(ast:zero? e) (zero? (value-of e Δ))]
      [(ast:if e1 e2 e3) (if (value-of e1 Δ) (value-of e2 Δ) (value-of e3 Δ))]
      [(ast:var v) (deref (apply-env Δ v))]
      [(ast:let (ast:var x) e1 e2) (value-of e2 (extend-env x (newref (value-of e1 Δ)) Δ))]
      [(ast:proc (ast:var v) e) (proc-val v e Δ)]
      [(ast:call e1 e2) ; call by reference
       (match e2
         [(ast:var z) (apply-proc-ref (value-of e1 Δ) (apply-env Δ z))]
         [_ (apply-proc (value-of e1 Δ) (value-of e2 Δ))])]
      [(ast:letrec (ast:var f) (ast:var v) e1 e2) (value-of e2 (extend-env-rec f v e1 Δ))]
      [(ast:begin es) (foldl (lambda (e v) (value-of e Δ)) (value-of (first es) Δ) (rest es))]
      [(ast:assign (ast:var x) e) (begin
                                    (setref! (apply-env Δ x) (value-of e Δ)) ;set the value in the store
                                    42)] ; return the 42 value
      [e (raise-user-error "unimplemented-construction: " e)]
      ))
  
  (define (value-of-program prog)
    (empty-store)
    (value-of prog init-env))
  
  
  (define (iref-read in)
    (syntax->datum
     (iref-read-syntax #f in)))
  
  (define (iref-read-syntax path port)
    (datum->syntax
     #f
     `(module iref-reference-mod racket
        ,(value-of-program (parse port)))))
  )
