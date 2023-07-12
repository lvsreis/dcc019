#lang dcc019/exercise/iclasses

var i; {
  i = 10;
  while ¬zero?(i) {
    print i;
    i = -(i, 1)                
  }
}
