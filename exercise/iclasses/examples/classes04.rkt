#lang dcc019/exercise/iclasses

class c1 extends object
  field x
  field y
  method initialize() return 1
  method setx1(v) x = v
  method sety1(v) y = v
  method getx1() return x
  method gety1() return y

class c2 extends c1
  field y
  method sety2(v) y = v
  method getx2() return x
  method gety2() return y

var o2; {
  o2 = new c2();
  send o2 setx1(101);
  send o2 sety1(102);
  send o2 sety2(999);
  print -(send o2 gety1(), send o2 gety2())
}

% Result: -897
