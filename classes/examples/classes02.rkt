#lang dcc019/classes

class tree extends object
  field left
  field right

  method initialize (l,r) begin
    set left = l;
    set right = r
  end

  method sum() -(send left sum(), -(0, send right sum()))

class leaf extends object
  field value

  method initialize (v) set value = v

  method sum() value

let o1 = new tree(
          new tree(
            new leaf(3),
            new leaf(4)),
          new leaf(5))
in send o1 sum()

% Result: 12
