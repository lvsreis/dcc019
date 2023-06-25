#lang dcc019/exercise/iclasses

class tree extends object
  field left
  field right

  method initialize (l,r) {
    left = l;
    right = r
  }

  method sum() return -(send left sum(), -(0, send right sum()))

class leaf extends object
  field value

  method initialize (v) value = v

  method sum() return value

var o1; {
  o1 = new tree(
          new tree(
            new leaf(3),
            new leaf(4)),
          new leaf(5));
  print send o1 sum()
}

% Result: 12
