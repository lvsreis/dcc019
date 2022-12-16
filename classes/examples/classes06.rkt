#lang dcc019/classes

class c1 extends object
  method initialize() 1
  method m1() send self m2()
  method m2() 13

class c2 extends c1
  method m1() 22
  method m2() 23
  method m3() super m1()

class c3 extends c2
  method m1() 31
  method m2() 33

let o3 = new c3()
in send o3 m3()

% Result: 33
