#lang racket

(provide (all-defined-out))

#| The AST of LET language

Exp ::= INT | VAR
     |  ZERO? Exp | DIFF Exp Exp
     |  IF Exp Exp Exp | LET VAR Exp Exp

or, in a list notation

Exp ::= INT | VAR
     |  (ZERO? Exp) | (DIFF Exp Exp)
     |  (IF Exp Exp Exp) | (LET VAR Exp Exp)

|#

(struct exp-node ()) ; just for simulating a subtyping relation and making some checkings

;;  leaves

; INT
(struct int-ast exp-node (value) #:transparent
  #:guard (lambda (value type-name)
            (cond
              [(integer? value) value]
              [else (error type-name
                           "not an integer value: ~e"
                           value)])))
; BOOL, althought we don't have the concrete syntax for boolean literals
(struct bool-ast exp-node (value) #:transparent
  #:guard (lambda (value type-name)
            (cond
              [(boolean? value) value]
              [else (error type-name
                           "not a boolean value: ~e"
                           value)])))

; VAR
(struct var-ast exp-node (name) #:transparent
  #:guard (lambda (name type-name)
            (cond
              [(string? name) name]
              [(symbol? name) (symbol->string name)]
              [else (error type-name
                           "bad name: ~e"
                           name)])))

;; internal nodes

; ZERO? Exp
(struct zero?-ast exp-node (exp) #:transparent
  #:guard (lambda (exp type-name)
            (if (exp-node? exp)
                exp
                (error type-name
                       "not an expression: ~e"
                       exp))))
; DIFF Exp Exp
(struct diff-ast exp-node (lexp rexp) #:transparent
  #:guard (lambda (lexp rexp type-name)
            (if (and (exp-node? lexp) (exp-node? rexp))
                (values lexp rexp)
                (error type-name
                       "bad arguments: ~e1 or ~e2"
                       lexp rexp))))

  
; IF Exp Exp Exp
(struct if-ast exp-node (guard-exp then-exp else-exp) #:transparent
  #:guard (lambda (guard-exp then-exp else-exp type-name)
            (if (and (exp-node? guard-exp) (exp-node? then-exp) (exp-node? else-exp))
                (values guard-exp then-exp else-exp)
                (error type-name
                       "bad arguments: ~e1 or ~e2 or ~e3"
                       guard-exp then-exp else-exp))))
; LET VAR Exp Exp
(struct let-ast exp-node (var iexp vexp) #:transparent
  #:guard (lambda (var iexp vexp type-name)
            (if (var-ast? var)
                (if (and (exp-node? iexp) (exp-node? vexp))
                    (values var iexp vexp)
                    (error type-name
                           "bad arguments: ~e1 or ~e2"
                           iexp vexp))
                (error type-name
                       "bad arguments: ~e"
                       var))))
