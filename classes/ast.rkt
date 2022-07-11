#lang racket

(provide (prefix-out ast: (all-defined-out)))

#| The AST of CLASSES language

Prog ::= {Decl} Exp

Decl ::= CLASS VAR VAR {VAR} {Method}
Method ::= METHOD VAR {VAR} Exp

Exp ::= INT | VAR
     |  ZERO? Exp | DIF Exp Exp
     |  IF Exp Exp Exp | LET VAR Exp Exp
     | PROC VAR Exp | CALL Expr Exp
     | LETREC VAR VAR Exp Exp
     | BEGIN Exp {Exp}
     | ASSIGN VAR Exp
     | NEW VAR {Exp}
     | SEND Exp VAR {Exp}
     | SUPER VAR {Exp}
     | SELF

or, in a list notation

Prog ::= (PROG (Decl ...) Exp)
Decl ::= (CLASS VAR VAR (VAR ...) (Method ...))
Method ::= (METHOD VAR (VAR ...) Exp)

Exp ::= INT | VAR
     |  (ZERO? Exp) | (DIF Exp Exp)
     |  (IF Exp Exp Exp) | (LET VAR Exp Exp)
     |  (PROC VAR Exp)   | (CALL Exp Exp)
     |  (LETREC VAR VAR Exp Exp)
     |  (BEGIN Exp Exp ... )
     |  (ASSIGN VAR Exp)
     |  (NEW VAR (Exp ...))
     |  (SEND Exp VAR (Exp ...))
     |  (SUPER VAR (Exp ...))
     |  (SELF)

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

; SET Exp Exp
(struct assign (var exp) #:transparent)

#| Specific nodes for classes |#

; Prog ::= {Decls} Exp
(struct prog (decls exp) #:transparent)

; Decl ::= CLASS VAR VAR {VAR} {Method}
(struct decl (name super fields methods) #:transparent)

; Method ::= METHOD VAR {VAR} Exp
(struct method (name params body) #:transparent)

; Exp ::= NEW VAR {Exp}
(struct new (class args) #:transparent)

; Exp ::= SEND Exp VAR {Exp}
(struct send (object method args) #:transparent)

; Exp ::= SUPER VAR {Exp}
(struct super (name args) #:transparent)

; Exp ::= SELF
(struct self () #:transparent)
