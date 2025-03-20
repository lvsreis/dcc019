#lang dcc019/exercise/logic

on(c, b).
on(b, a).

above(X, Y) :- on(X, Y).
above(X, Y) :- on(X, Z), above(Z, Y).
above(X, Y) :- above(X, Y).

% consultas:

   % above(X, Y).

