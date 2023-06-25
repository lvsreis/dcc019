#lang dcc019/exercise/iclasses

class c1 extends object
  method initialize() return 1
  method m1() return 11
  method m2() send self m1()

class c2 extends c1
  method m1() return 33

var o1;
  var o2; {
    o1 = new c1();
    o2 = new c2();
    print send o2 m1();
    print send o2 m2();
    print send o1 m1()
}

% Result:
% 33
% 33
% 11
