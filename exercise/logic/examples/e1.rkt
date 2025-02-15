#lang dcc019/exercise/logic

parent(pam, bob). % pam é um dos pais de bob

parent(tom, bob). % tom é um dos pais de bob
parent(tom, liz). % tom é um dos pais de liz

parent(bob, ann). % bob é um dos pais de ann
parent(bob, pat). % bob é um dos pais de pat

parent(pat, jim). % pat é um dos pais de jim.

granparent(X,Y) :- parent(X,Z), parent(Z,Y).

% ******************** CONSULTAS ************************************

% Use a lingugaem para realizar consultas a respeito do programa:
  % conusultar se bob é um dos pais de pat
   % ?- parent(bob, pat).

  % cosultar quem são os pais de liz
   % ?- parent(X, liz).

  % consultar quem é filho de bob
   % ?- parent(bob, X).

  % consultar quem é um dos avós de jim
   % ?- parent(X,Y), parent(Y,jim).

  % consultas usando o predicado granparent:
   % granparent(X, jim).
   % granparent(X,Y).
