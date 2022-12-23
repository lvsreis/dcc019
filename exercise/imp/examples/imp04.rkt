#lang dcc019/exercise/imp

var f; var x;
{
 f = proc (x) proc (y) -(x, -(0,y));
 x = 5;
 print ((f 7) x)
}
     
