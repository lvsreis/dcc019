#lang racket

(provide (prefix-out ast: (all-defined-out)))

#| The AST of LOGIC language

Prog ::= {Clause}

Clause ::= CLAUSE Head {Body}
Head ::= ATOM | Functor
Functor ::= FUNC ATOM {Arg}
Body ::= EQ Head | NEQ Head | Term

Arg ::= VAR | ATOM | Functor | UNKNOW-VAR
Term ::= VAR | ATOM | Functor

or, in a list notation

Prog ::= (PROG (Clause ...))
Clause ::= (CLAUSE Head (Body ...))
Head ::= ATOM | Functor
Functor ::= (FUNC ATOM (Arg ...))
Body ::= (EQ Term Term) | (NEQ Term Term) | Term

Term ::= VAR | ATOM | Functor

Arg ::= VAR | ATOM | Functor | UNKOW-VAR

|#

; ATOM
(struct atom (name) #:transparent)

; VAR
(struct var (name) #:transparent)

; Anonymous VAR
(struct unknow-var () #:transparent)

; Functor
(struct functor (name args) #:transparent)

; EQ functor
(struct eq (lterm rterm) #:transparent)

; NEQ functor
(struct neq (lterm rterm) #:transparent)
  
; Clause
(struct clause (head body) #:transparent)

