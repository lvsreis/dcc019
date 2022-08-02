#lang dcc019/checked

letrec int double (x : int) =
   if zero?(x) then 0 else -((double -(x,1)), -(0,2))
in (double 2)
