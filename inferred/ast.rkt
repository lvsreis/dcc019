#lang racket

(provide (prefix-out ast: (all-defined-out)))

#| The AST of LETREC language

Exp ::= INT | VAR
     |  ZERO? Exp | DIF Exp Exp
     |  IF Exp Exp Exp | LET VAR Exp Exp
     | PROC VAR Type Exp | CALL Expr Exp
     | LETREC Type VAR VAR Type Exp Exp

Type ::= INT-TYPE | BOOL-TYPE | -> TYPE TYPE

or, in a list notation

Exp ::= INT | VAR
     |  (ZERO? Exp) | (DIF Exp Exp)
     |  (IF Exp Exp Exp) | (LET VAR Exp Exp)
     |  (PROC VAR Type Exp)   | (CALL Exp Exp)
     |  (LETREC Type VAR VAR Type Exp Exp)

Type ::= (INT-TYPE) | (BOOL-TYPE) | (-> TYPE TYPE)

|#

;;  leaves

; INT
(struct int (value) #:transparent)

; BOOL, althought we don't have the concrete syntax for boolean literals
(struct bool (value) #:transparent)

; VAR
(struct var (name) #:transparent)

;; internal nodes

; ZERO? Exp
(struct zero? (exp) #:transparent)

; DIF Exp Exp
(struct dif (lexp rexp) #:transparent)
  
; IF Exp Exp Exp
(struct if (guard-exp then-exp else-exp) #:transparent)

; LET VAR Exp Exp
(struct let (var iexp vexp) #:transparent)

; PROC VAR Exp
(struct proc (var type body) #:transparent)

; CALL Exp Exp
(struct call (lexp rexp) #:transparent)

; LETREC VAR VAR Exp Exp
(struct letrec (type-return name var type-param body exp) #:transparent)

; types
(struct int-type () #:transparent)
(struct bool-type () #:transparent)
(struct arrow-type (t1 t2) #:transparent)
(struct non-type () #:transparent) ; using when there is no type annotation by the user
