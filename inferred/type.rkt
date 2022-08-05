#lang racket

(provide new-tyvar
         unifier
         empty-subst)

#|
; Representação para variáveis de tipos

Type -> int | bool | (-> Type Type)
       | (tyvar Num)

* Exemplo:

proc (f) proc (x) -((f 3), (f x))

           Expressão                          Variável de Tipo
____________________________________________________________________
              f                                (tvar-type 0)
              x                                (tvar-type 1)
proc (f) proc (x) -((f 3), (f x))              (tvar-type 2)
    proc (x) -((f 3), (f x))                   (tvar-type 3)
       -((f 3), (f x))                         (tvar-type 4)
            (f 3)                              (tvar-type 5)
            (f x)                              (tvar-type 6)

; Substituição

    Solução parcial                    Incluir
 _____________________            _________________
  t₂ = t₀ → (t₁ → int)                 t₄ = int

 * Representação
   - par: variável de tipo X tipo

; apply-subst :: Type x TyVar x Type -> Type

****** Representação das Substituições ******
; * Uma substituição é uma lista pares (TyVar . Type)

|#

(define number 0)

(define (new-tyvar)
  (define num number)
  (set! number (add1 number))
  (list 'tyvar num))

; tyvar? :: Type -> Bool 
(define (tyvar? ty)
  (match ty
    [(list 'tyvar n) #t]
    [_ #f]))

; proc-type? :: Type -> Bool
(define (proc-type? ty)
  (match ty
    [(list '-> _ _) #t]
    [_ #f]))

; ############################ EXAMPLE #################################
#;(define ex-sub
  (list
   (cons '(tyvar 0) 'bool)
   (cons '(tyvar 1) '(-> (tyvar 0) int))
    ))
; ######################################################################

; search-subst :: TyVar x Subst -> (TyVar . Type)
(define (search-subst ty sub)
  (match sub
    ['() #f]
    [(cons h t) (if (equal? (cadr ty) (cadr (car h)))
                    h
                    (search-subst ty t))
                    ]))

; apply-subst :: Type x TyVar x Type -> Type
(define (apply-subst t₁ vt t₂)
  (match t₁
    ['int 'int]
    ['bool 'bool]
    [(list '-> ty₁ ty₂) (list '-> (apply-subst ty₁ vt t₂) (apply-subst ty₂ vt t₂))]
    [(list 'tyvar n) (if (equal? (cadr vt) n)
                         t₂ t₁)]
    [_ (error "Expressão não representa um tipo")]))

(define (apply-subst-type type sub)
  (match type
    ['int 'int]
    ['bool 'bool]
    [(list '-> ty₁ ty₂) (list '-> (apply-subst-type ty₁ sub) (apply-subst-type ty₂ sub))]
    [(list 'tyvar n) (let [(tmp (search-subst type sub))]
                       (if tmp (cdr tmp) type))]
    [_ (error "Expressão não representa um tipo")]))

; empty-subst :: Subst
(define empty-subst null)

; extend-subst :: Subst x TyVar x Type -> Subst
(define (extend-subst sub var ty)
  (cons (cons var ty)
        (map (lambda (s)
               (cons (car s)
                     (apply-subst (cdr s) var ty))) sub)))

#| *** Unificador *** |#
#|

Expressões                             Tipo               Equações                Substituição
__________________________________   _________   ________________________       ________________
f                                        t₀             t₂ = t₀ → t₃              t₂ = t₀ → t₃
x                                        t₁             t₃ = t₁ → t₄
proc (f) proc (x) -((f 3), (f x))        t₂             t₅ = int
proc (x) -((f 3), (f x))                 t₃             t₆ = int
-((f 3), (f x))                          t₄             t₄ = int
(f 3)                                    t₅             t₀ = int → t₅
(f x)                                    t₆             t₀ = t₁ → t₆

|#

; no-occorrence? :: TyVar -> Bool
(define (no-occurrence? tvar t)
  (match t
    ['int #t]
    ['bool #t]
    [(list '-> t₁ t₂) (and (no-occurrence? tvar t₁)
                           (no-occurrence? tvar t₂))]
    [(list 'tyvar n) (not (equal? tvar t))]))

; unifier :: Type x Type x Subst -> Subst
(define (unifier t₁ t₂ sub)
  ; 1º aplicamos a substituição em ambos os tipos
  (let ([ty₁ (apply-subst-type t₁ sub)]
        [ty₂ (apply-subst-type t₂ sub)])
    (cond [(equal? ty₁ ty₂) sub] ; tipos iguais, remove a equação
          ; Lado esquerdo é uma variável e não ocorre no lado direito
          [(tyvar? ty₁) (if (no-occurrence? ty₁ ty₂) (extend-subst sub ty₁ ty₂)
                            (error "Não unifica: teste de ocorrência"))]
          ; Lado direito é uma variável e não ocorre no lado esquerdo
          [(tyvar? ty₂) (if (no-occurrence? ty₂ ty₁) (extend-subst sub ty₂ ty₁)
                            (error "Não unifica: teste de ocorrência"))]
          ; Nenhum dos dois lados é uma variável
          [(and (proc-type? ty₁) (proc-type? ty₂))
           (let [(sub₁ (unifier (cadr ty₁) (cadr ty₂) sub))] ; unifica os argumentos
             (let [(sub₂ (unifier (caddr ty₁) (caddr ty₂) sub₁))] ; unifica os retornos
               sub₂))]
          [else (error "Impossível unificar: tipos diferentes")])))
