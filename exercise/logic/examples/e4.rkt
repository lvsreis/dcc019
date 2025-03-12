#lang dcc019/exercise/logic

m(a,b).
m(b,c).
m(c,e).

n(X,Y) :- m(X,Y).
n(X,Y) :- m(X,Z), m(Z,Y).


child(anne, bridget).
child(bridget, caroline).
child(caroline, donna).
child(donna, emily).

descend(X,Y) :- child(X,Y).
descend(X,Y) :- child(X,Z), descend(Z,Y).


% consultas:

   % n(a,e).
   % descend(X,Y).
