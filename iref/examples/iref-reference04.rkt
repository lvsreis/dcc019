#lang dcc019/iref/reference

let b = 3
in let p = proc (x) proc (y)
             begin
               set x = 4;
               y
             end
   in ((p b) b)
