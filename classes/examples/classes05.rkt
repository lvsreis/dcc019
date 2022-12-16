#lang dcc019/classes

class c1 extends object
  method initialize() 1
  method m1() 11
  method m2() send self m1()

class c2 extends c1
  method m1() 33

let o1 = new c1()
in let o2 = new c2()
   in -(send o2 m1(),
        -(send o2 m2(),
          send o1 m1()))

% Result: 11
