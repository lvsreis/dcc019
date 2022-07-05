#lang dcc019/eref

let g = let counter = newref(0)
        in proc(dummy)
            begin
             setref(counter, -(deref(counter), -(0,1)));
             deref(counter)
            end
in let a = (g 11)
   in let b = (g 11)
      in -(a,b)
