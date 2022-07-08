#lang racket

(provide (prefix-out ast: (all-defined-out)))

#| The AST of IREF language

Exp ::= INT | VAR
     |  ZERO? Exp | DIF Exp Exp
     |  IF Exp Exp Exp | LET VAR Exp Exp
     | PROC VAR Exp | CALL Expr Exp
     | LETREC VAR VAR Exp Exp
     | BEGIN Exp {Exp}
     | ASSIGN VAR Exp


or, in a list notation

Exp ::= INT | VAR
     |  (ZERO? Exp) | (DIF Exp Exp)
     |  (IF Exp Exp Exp) | (LET VAR Exp Exp)
     |  (PROC VAR Exp)   | (CALL Exp Exp)
     |  (LETREC VAR VAR Exp Exp)
     |  (BEGIN Exp Exp ... )
     |  (ASSIGN VAR Exp)
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
(struct proc (var body) #:transparent)

; CALL Exp Exp
(struct call (lexp rexp) #:transparent)

; LETREC VAR VAR Exp Exp
(struct letrec (name var body exp) #:transparent)

; BEGIN Exp {Exp}
(struct begin (exps) #:transparent)

; SETREF Exp Exp
(struct assign (var exp) #:transparent)
