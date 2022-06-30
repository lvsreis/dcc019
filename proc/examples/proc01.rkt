#lang dcc019/proc

let f = proc (x) -(x,11) in
  (f (f 77))

