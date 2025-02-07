#lang racket

(require dcc019/util/env
         dcc019/util/memory
         dcc019/classes/ast
         dcc019/classes/object
         dcc019/classes/class)

(provide value-of-program)

; Representação de procedimentos para escopo estático

; proc-val :: Var x Expr x Env -> Proc
(define (proc-val var exp Δ Γ) ; call by value
  (lambda (val)
    (value-of exp (extend-env var (newref val) Δ) Γ)))

; apply-proc :: Proc x ExpVal -> ExpVal  
(define (apply-proc proc val)
  (proc val))

; Criação de ambiente estendido com procedimento recursivo
(define (extend-env-rec name var body env Γ)
  (lambda (svar)
    (if (equal? svar name)
        (newref (proc-val var body (extend-env-rec name var body env Γ) Γ))
        (apply-env env svar))))

#| Method Representation |#

; it creates a value that represents a method
(define (method-val super-name field-names params body)
  (lambda (obj args Γ)
    (value-of body
        (extend-env '%super
                    (apply-env Γ super-name)
                    (extend-env '%self obj
                                (foldl extend-env
                                       (foldl extend-env init-env
                                              field-names
                                              (take (get-locations obj)
                                                    (length field-names)))
                                       params args))) Γ)))


; it executes the method m with arguments args on object obj
(define (apply-method m obj args Γ)
  (m obj args Γ))


; value-of :: Exp -> ExpVal
(define (value-of exp Δ Γ)
  (match exp
    [(ast:int n) n]
    [(ast:dif e1 e2) (- (value-of e1 Δ Γ) (value-of e2 Δ Γ))]
    [(ast:zero? e) (zero? (value-of e Δ Γ))]
    [(ast:if e1 e2 e3) (if (value-of e1 Δ Γ) (value-of e2 Δ Γ) (value-of e3 Δ Γ))]
    [(ast:var v) (deref (apply-env Δ v))]
    [(ast:let (ast:var x) e1 e2) (value-of e2 (extend-env x (newref (value-of e1 Δ Γ)) Δ) Γ)]
    [(ast:proc (ast:var v) e) (proc-val v e Δ Γ)]
    [(ast:call e1 e2) (apply-proc (value-of e1 Δ Γ) (value-of e2 Δ Γ))] ; call by value
    [(ast:letrec (ast:var f) (ast:var v) e1 e2) (value-of e2 (extend-env-rec f v e1 Δ Γ) Γ)]
    [(ast:begin es) (foldl (lambda (e v) (value-of e Δ Γ)) (value-of (first es) Δ Γ) (rest es))]
    [(ast:assign (ast:var x) e) (let [(v (value-of e Δ Γ))]
                                  (setref! (apply-env Δ x) v)
                                  v)] ;set the value in the store and return it
    #| The CLASSES Constructions |#
    [(ast:self) (apply-env Δ '%self)]
    [(ast:new c args) (let* ([class-d (apply-env Γ (ast:var-name c))]
                                [args-v (map (lambda (e) (newref (value-of e Δ Γ))) args)]
                                [obj (new-obj class-d)])
                            (apply-method
                             (find-method class-d "initialize")
                             obj args-v Γ)
                            obj)]
    [(ast:send obj method args)     
     (let* ([o (value-of obj Δ Γ)]
            [class-d (get-class o)]
            [mth (find-method class-d (ast:var-name method))]
            [args-v (map (lambda (e) (newref (value-of e Δ Γ))) args)])
       (apply-method mth o args-v Γ))]
    [(ast:super method args)
     (let* ([obj (apply-env Δ '%self)]
            [class-d (apply-env Δ '%super)]
            [mth (find-method class-d (ast:var-name method))]
            [args-v (map (lambda (e) (newref (value-of e Δ Γ))) args)])
       (apply-method mth obj args-v Γ))]
                            
    [e (raise-user-error "unimplemented-construction: " e)]
    ))


(define (init-methods-env super-name field-names methods mth-env)
  (foldl (lambda (mth env)
           (extend-env (ast:var-name (ast:method-name mth))
                       (method-val
                        super-name
                        field-names
                        (map ast:var-name
                             (ast:method-params mth))
                        (ast:method-body mth))
                       env))
         mth-env
         methods))


(define (init-class c super-class)
  (let* ([super-fields (get-fields super-class)]
        [class-fields (map ast:var-name (ast:decl-fields c))]
        [super-method-env (get-method-env super-class)]
        [field-names (append super-fields class-fields)]
        [method-env (init-methods-env (ast:var-name (ast:decl-super c)) 
                       field-names (ast:decl-methods c) super-method-env)])
    (build-descriptor super-class
                      field-names
                      method-env)))
        
(define (init-class-env decls Γ)
  (foldl
   (lambda (c env)
     (extend-env (ast:var-name (ast:decl-name c))
                 (init-class c
                             (apply-env env (ast:var-name (ast:decl-super c))))
                 env))
   Γ decls))                                    
                      
                      
(define (value-of-program prog)
  (empty-store)
  (match prog
    [(ast:prog decls exp)
     (value-of exp init-env (init-class-env decls (extend-env "object" object-class init-env)))]))
