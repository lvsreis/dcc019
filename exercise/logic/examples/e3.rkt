#lang dcc019/exercise/logic

p(a).                              /* #1 */  
p(X) :- q(X), r(X).                /* #2 */  
p(X) :- u(X).                      /* #3 */  
 
q(X) :- s(X).                      /* #4 */  


r(a).                              /* #5 */  
r(b).                              /* #6 */  


s(a).                              /* #7 */  
s(b).                              /* #8 */  
s(c).                              /* #9 */  
 
u(d).                              /* #10 */ 

% consultas:

   % p(X,f(Y),a) = p(a,f(a),Y).
   % p(X,f(Y),a) = p(a,f(b),Y).
   % p(X,f(Y),a) = p(Z,f(b),a).
   % X = a, Y = b, X \= Y.
   % f(X) = f(f(X)).
   % p(X).
