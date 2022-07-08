#lang dcc019/iref/name

letrec loop(x) = (loop -(x, -(0,1)))
in let f = proc (z) 7
   in (f (loop 0))
