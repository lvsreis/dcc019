#lang dcc019/letrec

letrec double(x) = if zero?(x) then 0 else -((double -(x,1)), -(0,2))
in (double 6)
