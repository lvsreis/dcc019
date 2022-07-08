#lang dcc019/iref

let p = proc (x) set x = 4
in let a = 3
   in begin
       (p a);
       a
      end
