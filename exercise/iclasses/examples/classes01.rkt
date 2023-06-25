#lang dcc019/exercise/iclasses

class c1 extends object
  field i
  field j

  method initialize (x) {
      i = x;
      j = -(0,x);
      return j
  }

  method countup (d) {
      i = -(i, -(0,d));
      j = -(j,d);
      return j
  }

  method geti() return i

  method getj() return j

var o1; {
  o1 = new c1(3);
  print send o1 geti();
  send o1 countup(2);
  print send o1 geti()
}

% Result:
% 3
% 5
