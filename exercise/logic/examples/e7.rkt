#lang dcc019/exercise/logic

car(list(H, _), H).
cdr(list(_, T), T).

member(H, list(H, _)).
member(H, list(_, T)) :- member(H, T).

concate(null, L, L).
concate(list(H, T1), L, list(H, T2)) :- concate(T1, L, T2).

add(X, L, list(X, L)).

rem(H, list(H, T), T).
rem(X, list(H, T), list(H, R)) :- rem(X, T, R).

% consultas:

   % car(list(a, list(b, list(c, null))), X).
   % cdr(list(a, list(b, list(c, null))), X).
   % member(a, list(a, list(a, list(a, null)))).
   % concate(list(a, list(b, null)), list(c, null), X).
   % concate(X, list(c, null), list(a, list(b, list(c, list(d, null))))).
   % concate(list(a, list(b, null)), X, list(a, list(b, list(c, null)))).
   % add(X, list(b, list(c, null)), list(a, list(b, list(c, null)))).
   % rem(a, list(a, list(b, list(a, list(a, null)))), L).

