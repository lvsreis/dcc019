#lang dcc019/proc

let makemult = proc (maker) proc (x) if zero?(x) then 0 else -(((maker maker) -(x,1)), -(0,4))
in let times = proc (x) ((makemult makemult) x)
   in (times 3)
