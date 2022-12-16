#lang dcc019/classes

class c1 extends object
  field i
  field j

  method initialize (x)
    begin
      set i = x;
      set j = -(0,x)
    end

  method countup (d)
    begin
      set i = -(i, -(0,d));
      set j = -(j,d)
    end

  method geti() i

  method getj() j

let t1 = 0
in let t2 = 0
   in let o1 = new c1(3)
      in begin
        set t1 = send o1 geti();
        send o1 countup (2);
        set t2 = send o1 geti();
        -(t1,t2)
       end

% Result: -2
