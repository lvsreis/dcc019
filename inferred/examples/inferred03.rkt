#lang dcc019/inferred

let h = proc (f)
          proc (n)
            (f zero?(n))
in ((h proc (x) if x then 11 else 22) 0)

