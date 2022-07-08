#lang dcc019/iref

letrec fun(x) = if zero?(x) then 0 else -(x, -(0, (fun -(x,1))))
in (fun 3)
