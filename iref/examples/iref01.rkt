#lang dcc019/iref

let g = let counter = 0
        in proc(dummy)
            begin
             set counter = -(counter, -(0,1));
             counter
            end
in let a = (g 11)
   in let b = (g 11)
      in -(a,b)
