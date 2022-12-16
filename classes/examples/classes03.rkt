#lang dcc019/classes

class oddeven extends object
  method initialize () 1
  method even(n)
    if zero?(n) then 1 else send self odd(-(n,1))
  method odd(n)
    if zero?(n) then 0 else send self even(-(n,1))
let o1 = new oddeven()
in send o1 odd(13)

% Result: 1
