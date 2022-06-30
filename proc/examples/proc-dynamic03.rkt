#lang dcc019/proc/dynamic

let a = 3
in let p = proc (z) a
   in let f = proc (x) (p 0)
      in let a = 2
         in (f 2)
