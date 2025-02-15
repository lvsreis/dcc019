#lang dcc019/exercise/logic

filho(joao, jose).
filho(ana, jose).
filho(maria, jose).
filho(jose,tiago).
filho(pedro, judas).
filho(gabriel, judas).
filho(judas, tiago).
filho(augusto, manuel).

pais(X,Y) :- filho(Y, X).
tio(X,Y) :- pais(P,X), pais(P,Z), X \= Z, pais(Z,Y).
primo(X,Y) :- pais(P,A), pais(P,B), A \= B, pais(A,X), pais(B,Y), X \= Y.

% consultas:
   % filho(pedro, jose).
   % filho(X, jose).
   % pais(X, tiago).
   % tio(jose, pedro).
   % primo(X, gabriel).

