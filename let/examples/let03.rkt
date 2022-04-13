#lang dcc019/let

let z = 5
   in let x = 3
      in let y = -(x,1) ; What's the value of x?
         in let x = 4
            in -(z,-(x,y)) ; What's the value of x?
