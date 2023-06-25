#lang dcc019/exercise/iclasses

class oddeven extends object
  method initialize () return 1
  method even(n)
    return if zero?(n) then true else send self odd(-(n,1))
  method odd(n)
    return if zero?(n) then false else send self even(-(n,1))

var o1; {
  o1 = new oddeven();
  print send o1 odd(13)
}

% Result: true
