#lang dcc019/exercise/logic

plus(zero,X,X).
plus(s(X),Y,s(Z)) :- plus(X,Y,Z).

mult(zero, Y, zero).
mult(s(X), Y, W) :- mult(X, Y, Z), plus(Z, Y, W).
      
% consultas:

   % plus(s(s(zero)), s(s(s(zero))), Z).
   % mult(s(s(zero)), s(s(s(zero))), Z).
