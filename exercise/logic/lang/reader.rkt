#lang racket

(require dcc019/exercise/logic/parser
         dcc019/exercise/logic/interpreter)

(provide (rename-out [logic-read read]
                     [logic-read-syntax read-syntax]
                     #;[logic-module-begin #%module-begin]))

(define (logic-read in)
  (syntax->datum
   (logic-read-syntax #f in)))

(define (logic-read-syntax path port)  
  (define prog (port->string port)) ; transforma o programa em uma string e faz o parse a cada query (ineficiente, mas funcionou!)
  ;(define ast (parse port))
  (datum->syntax
   #f
   `(module logic-mod racket
      (require dcc019/exercise/logic/interpreter
               dcc019/exercise/logic/parser)

      (define (read-one-line origin port)
        (define one-line (read-line port))
        (eval-query (parse (open-input-string ,prog))
                    (repl-parse (open-input-string one-line))))


      (current-read-interaction read-one-line)
      
      )))


#;(define-macro (logic-module-begin ast)
  #'(#%module-begin
     (require dcc019/exercise/logic/interpreter)
     (valu-of-program ast)))

