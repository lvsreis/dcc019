#lang dcc019/iref/name

let f = proc (x) proc (y)
         begin
           set x = 42;
           y
         end
in let i = 10
   in ((f i) -(i,5))
