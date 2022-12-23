#lang dcc019/exercise/imp

var x; var y; var z;
{
 x = 3;
 y = 4;
 z = 0;
 while not(zero?(x))
 {
  z = -(z, -(0,y));
  x = -(x, 1)
 };
 print z
}
                    
