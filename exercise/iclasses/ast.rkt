#lang racket

(provide (prefix-out ast: (all-defined-out)))

#| The AST of CLASSES language

Prog ::= {Decl} Stmt

Decl ::= CLASS ID ID {ID} {Method}
Method ::= METHOD ID {ID} Stmt
MethodCall ::= SEND Exp ID {Exp}
           |   SUPER ID {Exp}

Exp ::= INT | TRUE | FALSE | ID
     |  ZERO? Exp | NOT Exp | DIF Exp Exp
     |  IF Exp Exp Exp | LET VAR Exp Exp
     |  NEW ID {Exp}
     |  MethodCall
     |  SELF

Stmt ::= ASSIGN ID Exp
     |   PRINT Exp
     |   BLOCK {Stmt}
     |   IF-STMT Exp Stmt Stmt
     |   WHILE Exp Stmt
     |   VAR ID Stmt
     |   RETURN Exp
     |   MethodCall

or, in a list notation

Prog ::= (PROG (Decl ...) Stmt)
Decl ::= (CLASS ID ID (ID ...) (Method ...))
Method ::= (METHOD ID (ID ...) Stmt)
MethodCall ::= (SEND Exp ID (Exp ...))
           |   (SUPER ID (Exp ...))

Stmt ::= (ASSIGN ID Exp)
     |   (PRINT Exp)
     |   (BLOCK (Stmt ...))
     |   (IF-STMT Exp Stmt Stmt)
     |   (WHILE Exp Stmt)
     |   (VAR ID Stmt)
     |   (RETURN Exp)
     |   MethodCall

Exp ::= INT | TRUE | FALSE | ID
     |  (ZERO? Exp) | (NOT Exp) | (DIF Exp Exp)
     |  (IF Exp Exp Exp) | (LET ID Exp Exp)
     |  (NEW ID (Exp ...))
     |  MethodCall
     |  (SELF)

|#

;;  leaves

; INT
(struct int (value) #:transparent)

; BOOL
(struct bool (value) #:transparent)

; VAR
(struct var (name) #:transparent)

;; internal nodes

; ZERO? Exp
(struct zero? (exp) #:transparent)

; NOT Exp
(struct not (exp) #:transparent)

; DIF Exp Exp
(struct dif (lexp rexp) #:transparent)
  
; IF Exp Exp Exp
(struct if (guard-exp then-exp else-exp) #:transparent)

; LET VAR Exp Exp
(struct let (var iexp vexp) #:transparent)

; Nodes for statments

(struct assign (var exp) #:transparent)
(struct print (exp) #:transparent)
(struct block (stmts) #:transparent)
(struct if-stmt (exp then-stmt else-stmt) #:transparent)
(struct while (exp stmt) #:transparent)
(struct local-decl (var stmt) #:transparent)
(struct return (exp) #:transparent)

#| Specific nodes for classes |#

; Prog ::= {Decls} Stmt
(struct prog (decls stmt) #:transparent)

; Decl ::= CLASS VAR VAR {VAR} {Method}
(struct decl (name super fields methods) #:transparent)

; Method ::= METHOD VAR {VAR} Stmt
(struct method (name params body) #:transparent)

; Exp ::= NEW VAR {Exp}
(struct new (class args) #:transparent)

; Exp ::= SEND Exp VAR {Exp}
(struct send (object method args) #:transparent)

; Exp ::= SUPER VAR {Exp}
(struct super (name args) #:transparent)

; Exp ::= SELF
(struct self () #:transparent)
