#lang dcc019/exercise/logic

f_constructed(f(T,_), T).
bizarre(X) :- f_constructed(X,X).
crazy(X) :- bizarre(f(_,X)).

% consultas:

   % crazy(X).
