/* Name: Sun Yue Ran
   Sid: 1297186
   course: computing 325
*/


/*Question1

Number can be expressed as the sum of four or fewer squares. We use the CLP at here. 
We specify four variables S1,S2,S3 and S4, and constraint domain of N to S1*S1 + S2*S2 + S3*S3 + S4*S4.
Then create a predicate checkOrder to make sure that S1 bigger than 0, S2 bigger than S1, S3 bigger than S2,
and S4 biiger than S3. Finally, label will list out the answer we want.

Test case:
%tc1
tc1(Var) :- fourSquares(20, Var).
%Var = [0, 0, 2, 4] ;
%Var = [1, 1, 3, 3] ;
%false.

%tc2
tc2(Var) :- fourSquares(-20, Var).
%false.

%tc3
tc3(Var) :- fourSquares(0, Var).  
%Var = [0, 0, 0, 0].

*/


:- use_module(library(clpfd)).

fourSquares(N, [S1, S2, S3, S4]) :- N #= S1*S1 + S2*S2 + S3*S3 + S4*S4, checkOrder([S1, S2, S3, S4]), label([S1, S2, S3, S4]).

checkOrder([S1, S2, S3, S4]) :- S1#>=0, S1#=<S2, S2#=<S3, S3#=<S4.



/*Question2
I have create a new atom which named Desc to make sure that the total strength of one month's dismantlement is less than or equal to the total strength of next month's dismantlement.

There are two cases:
First case is dismantlement of A smaller than dismantlement Of B, so we need to make sure two dismantlement of A and one dismantlement of B will be disarmed. We use the predicate 'select' at here, "select(DA1,A,NA1)" will remove the element "DA1"from the list 'A' and create a new list "NA1", and use select again to remove the second dismantlement from A. The third select remove one dismantlement from B.

Then we create the constraint to make sure DA1 smaller than DA2, and DB equals to DA1 plus DA2. In order to make sure smaller dismantlement remove first, we create another constraint Desc =<DB to achieve that. 

At next step, we append the result into the empty list NS, and create a new list which named S, S is the answer we get from the disarm predicate.

Finally we call the disarm(NA1,NB,NS,DB),where NA1 is the new list A we get, NB is the new list B we get, and DB is the new Desc value.


Second case is similar with first case, the difference is we handle the case when dismantlement of B smaller than dismantlement Of A


Test Case:
%tc4
p1(S) :- disarm([1,3,3,4,6,10,12],[3,4,7,9,16],S).
%S = [[[1, 3], [4]], [[3, 6], [9]], [[10], [3, 7]], [[4, 12], [16]]].

p2 :- disarm([],[],[]).
%true.

p3(S) :- disarm([1,2,3,3,8,5,5],[3,6,4,4,10],S).
%S = [[[1, 2], [3]], [[3, 3], [6]], [[8], [4, 4]], [[5, 5], [10]]].


p4(S) :- disarm([1,2,2,3,3,8,5],[3,2,6,4,4,10],S).
%false.




*/

disarm([],[],[],_).
disarm(A,B,S) :- disarm(A,B,S,Desc).


%Case 1: dismantlement of A smaller than dismantlement Of B
disarm(A,B,S,Desc):- select(DA1,A,NA1),select(DA2,NA1,NA2),select(DB,B,NB),
	DA1#=<DA2,DB#=DA1+DA2,Desc#=<DB,append([[[DA1,DA2],[DB]]],NS,S),
	disarm(NA2,NB,NS,DB).

%Case 2: dismantlement of B smaller than dismantlement Of A

disarm(A,B,S,Desc):- select(DB1,B,NB1),select(DB2,NB1,NB2),select(DA,A,NA),
	DB1#=<DB2,DA#=DB1+DB2,Desc#=<DA, append([[[DA],[DB1,DB2]]],NS,S),
	disarm(NA,NB2,NS,DA).


