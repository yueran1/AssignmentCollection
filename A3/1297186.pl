/* Name: Sun Yue Ran
   Sid: 1297186
   course: computing 325
*/



/* Question 1 

Define the predicate xreverse(L, R) to reverse a list,
where L is a given list
and R is either a variable or another given list.

rhelper is the predicate which track the first element of list L 
and recursively join this first element to the
head of the accumulator. When the tail is empty, we reach the
base case and get the reverse list.

Finally we use the xreverse call the rhelper

xreverse([7,3,4],[4,3,7]) should return yes, 
xreverse([7,3,4],[4,3,5]) should return no, 
xreverse([7,3,4], R) should return R = [4,3,7].
*/

xreverse(L,R) :-rhelper(L,[],R).

rhelper([H|T],A,R) :- rhelper(T,[H|A],R).
rhelper([],A,A).







/* Question 2

Define the predicate xunique(L, Lu) 
where L is a given list of atoms and 
Lu is a copy of L where all the duplicates have been removed. 

For predicate xunique, each time we take the head of the list, and use
delete to delete every element which is duplicate in the list, 
after the deleting, we get the TN, use the recursive call to pass TN to
xunique and continue track the tail until L and Lu is empty.Finally, we
use [H|TU] to merge the all none duplicate elements together to
form the unique list.

xunique([a,c,a,d], L) should return L = [a,c,d], 
xunique([a,c,a,d], [a,c,d]) should return yes, 
xunique([a,c,a,d], [c,a,d]) should return no (because of wrong order), 
xunique([a,a,a,a,a,b,b,b,b,b,c,c,c,c,b,a], L) should return L = [a,b,c], 
xunique([], L) should return L = [].

*/

xunique([H|T],[H|TU]) :- delete(T,H,TN), xunique(TN,TU).
xunique([],[]).





/* Question 3

The idea at here is pretty straight, we append L1 and L2 together to form the
L3, then we use xunique which we defined in question2 to remove every duplicates
and get the xunion.  L contains the unique elements that are contained in both
L1 and L2

xunion([a,c,a,d], [b,a,c], L). should return L = [a,c,d,b], 
xunion([a,c,d], [b,a,c], [a,c,d,b]). should return yes, 
xunion([a,c,d], [b,a,c], [a,c,d,b,a]). should return no.

*/

xunion(L1,L2,L) :- append(L1,L2,L3),xunique(L3,L).



/* Question 4
Define the predicate removeLast(L1, L2, Last) where L1 is a given nonempty list,
L2 is the result of removing the last element from L1, and Last is that last 
element.

We just use the xreverse which defined in question1 to reverse the list.
Then use takeHead to take the head of reverse list, which is the last element of L1. L3 is the reverse version of the L2, so we reverse the L3 again to get L2, which is the
result list after removing the last element from L.

removeLast([a,c,a,d], L1, Last). should return L1 = [a,c,a], Last = d, 
removeLast([a,c,a,d], L1, d). should return L1 = [a,c,a], 
removeLast([a,c,a,d], L1, [d]). should return no (why?), 

Fisrt of all, d is in lower case, so we can not assign any value to d.
Second when we put d into [], it become a list, [d] does not equal to d, so
we return false.

removeLast([a], L1, Last). should return L1 = [], Last = a, 
removeLast([[a,b,c]], L1, Last). should return L1 = [], Last = [a,b,c].
*/

takeHead(L,H,T):- [H|T]=L.


removeLast(L1,L2,Last) :- xreverse(L1,R),takeHead(R,Last,RT),xreverse(RT,L2).



/* Question 5.1
clique and xsubset are predicates definded in the question.
We defined the allConnected which track every node in the list to check whether
each node connect to all other nodes or not.

The predicate connected test if A is connected to every node in L.
(edge(A,H);edge(H,A)) test the both way between A and H.




*/


clique(L) :- findall(X,node(X),Nodes),
             xsubset(L,Nodes), allConnected(L).

xsubset([], _).
xsubset([X|Xs], Set) :-
append(_, [X|Set1], Set),
xsubset(Xs, Set1).

allConnected([]).
allConnected([A|L]) :- connected(A,L),allConnected(L).

connected(A,[]).
connected(A,[H|T]) :- (edge(A,H);edge(H,A)),connected(A,T).



/* Question 5.2
predicate maxclique(N, Cliques) compute all the maximal
cliques of size N that are contained in a given graph. 

We define maxhelper to make three constraint, First is the list we get
should be a clique,
Second is the length of clique is N, Third is cliques we get are not
subset of other cliques in graph.

To check the cliques we get is not the subset of other cliques,
we define the predicate nonSubsetTraker to check each clique in the graph.

We use predicate nonSubset in the nonSubsetTraker to implment the checking,
if we detect the subset clique, we use predicate deleteSubset to delete those
subset cliques.

After above process nonSubsetTraker will elinimate all the subset clique,and
maxhelper will return each clique which satified the length and nonsubset
condition. 


Finally maxclique will use findall and maxhelper to form
all the cliques we want into a list.



*/
nonSubsetTraker(_, []).

nonSubsetTraker(L, [H|T]) :-
   nonSubset(L, H),
   nonSubsetTraker(L, T).

nonSubset(L1, L2) :-
    L1 == L2.

nonSubset([H|T], L) :-
    deleteSubset(H, L).

nonSubset([H|T], L) :-
    member(H, L),
    nonSubset(T, L).

deleteSubset(E, L) :-
    delete(L, E, R),
    length(L, N),
    length(R, N).


all(N,L2) :- findall(L,clique(L),L2).
maxhelper(N,L) :- clique(L),length(L,N),all(N,L2),nonSubsetTraker(L, L2).
maxclique(N,L3) :- findall(L,maxhelper(N,L),L3).


 


