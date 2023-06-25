#lang dcc019/exercise/iclasses

class c1 extends object
  method initialize() return 1
  method m1() send self m2()
  method m2() return 13

class c2 extends c1
  method m1() return 22
  method m2() return 23
  method m3() super m1()

class c3 extends c2
  method m1() return 31
  method m2() return 33

var o3; {
  o3 = new c3();
  print send o3 m3()
}

% Result: 33
