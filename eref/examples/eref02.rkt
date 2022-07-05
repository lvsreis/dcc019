#lang dcc019/eref

let x = newref(newref(0))
in begin
    setref(deref(x), 11);
    deref(deref(x))
   end
