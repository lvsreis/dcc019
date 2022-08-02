#lang dcc019/checked

let h = proc (f : (bool -> int))
          proc (n : int)
            (f zero?(n))
in ((h proc (x : bool) if x then 11 else 22) 0)

