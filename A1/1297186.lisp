#|

Name: Sun Yue Ran
student id:1297186
Computing325 LEC B1
Assignment #1
|#












#| Question 1


It returns T if argument X is a member of the argument list Y and NIL otherwise. This should also test for lists being members of lists. Both the argument X and the list Y may be NIL or lists containing NIL. 

Test Cases:
>(xmember '1 '(1))
T

>(xmember '1 '( (1) 2 3))
NIL

>(xmember '(1) '((1) 2 3))
T

|#

(defun xmember (x y)	
	(if (null y)
	    nil
            (if (equal x (car y))
                t
            (xmember x (cdr y))
            )
            
         )
)




#| Question 2


where the argument x is a list with sublists nested to any depth, such that the result of (flatten x) is just a list of atoms with the property that all the atoms appearing in x also appear in (flatten x) and in the same order.


test cases:
>(flatten '(a (b c) d))
(a b c d)

>(flatten '((((a))))) 
(a)

>(flatten '(a (b c) (d ((e)) f)))
(a b c d e f)


|#

(defun flatten(x)
   (if (null x) 
       nil
       (if (atom (car x))
            (cons (car x) (flatten (cdr x)))
            (append (flatten(car x)) (flatten(cdr x)))
       )
   )
)





#| Question 3


that mixes the elements of L1 and L2 into a single list, by choosing elements from L1 and L2 alternatingly. If one list is shorter than the other, then append all elements from the longer list at the end.

In the function, firstly we use null to test whether list1 and list2  are empty list or not.
Second, if list2 is '(nil), we do not remove nil.
if list is not '(nil), we remove nil



test cases:
>(mix '(a b c) '(d e f))
(a d b e c f)

>(mix '(1 2 3) '(a))
(1 a 2 3)

|#

(defun mix(l1 l2)
    (if (and (null l1) (null l2))
        nil
        (if (equal '(nil) l2)
	   (append(cons(car l1) (cons(car l2) nil))   (mix (cdr l1)(cdr l2)))
        
	   (remove nil (append(cons(car l1) (cons(car l2) nil))   (mix (cdr l1)(cdr l2))))
        )
        
       

        
     )
)






#| Question 4


splits the elements of L into a list of two sublists (L1 L2), by putting elements from L into L1 and L2 alternatingly.

We use cddr lst to test the number of element in list is even number or odd number,
then we use recursion to split list alternatingly.


test cases:
>(split '(1 2 3 4 5 6))
((1 3 5) (2 4 6))

>(split '((a) (b c) (d e f) g h)) 
(((a) (d e f) h) ((b c) g))

>(split '())
(nil nil)

|#




(defun split (lst)
  (if lst
      (if (cddr lst)
          (let ((l (split(cddr lst))))
            (list
             (cons (car lst) (car l))
             (cons (cadr lst) (cadr l))
            )
       )
           (list(list (car lst)) (cdr lst)))'(nil nil)
   )
)





#| Question 5

5.1
No, it is not always true that (split (mix L1 L2)) returns the list (L1 L2). From the question 3 and question 4 we know that mix is the function which combine two list's 
elements alternatingly, and function split is seprate one list's element to two lists with equal length. If we give two list with different length to mix function, split function will return two euqal length list to us, but this is not the result we want.

For counter example

* (split (mix '(a b c) '(d e f g h)))

((A B C G) (D E F H))
Therefore, it is not always true that (split (mix L1 L2)) returns the list (L1 L2).


5.2
Yes, it is always true that (mix (car (split L)) (cadr (split L))) returns L, because (car (split L)) will return the odd number index elements of list L, and (cadr (split L))
will return the even number index elements. After using mix function, we will get original list L.



|#






#| Question 6


Write a Lisp function to solve the subset sum problem: given a list of numbers L and a sum S, find a subset of the numbers in L that sums up to S. Each number in L can only be used once.

We use cond to identify different conditions
if list is empty we should return nil
if the first is part of the solution then we need to use it and a solution of the simpler problem (rest L) (- S (first L))
if it's not part of the solution then we need to solve instead the simpler problem (rest L) S

test case:

> (subsetsum '(1 2 3 4 5) 6)

(1 2 3)


|#

(defun subsetsum (L S)
     (cond 
       ((null L) nil)

       ((> (first L) S) (subsetsum (rest L) S))

       ((= (first L) S)   (cons (first L) ()))
				
       ((< (first L) S)
	   (if (null (subsetsum (rest L) (- S (first L))))
	      (subsetsum (rest L) S)
	      (cons (first L) (subsetsum (rest L) (- S (first L))))
	   )

	)
     )
)


