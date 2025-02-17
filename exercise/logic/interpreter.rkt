#lang racket

(require dcc019/exercise/logic/ast)

(provide eval-query)


(define (eval-query prog query)
  (printf "Programa:~n ~a~n" prog) ; representação do programa
  (printf "Query:~n ~a~n" query)   ; a query

  #'42 ; resposta da consulta
)

