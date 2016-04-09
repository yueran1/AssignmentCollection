#|

Name: Sun Yue Ran
student id:1297186
Computing325 LEC B1
Assugnment #2
|#


#| 
Number of arguments is one of things to identify function,
So we need to write a function to count the numbero f arguments.
If argument list is null, we return 0. If arg list is not null, we use recursion trace to 
count argument one by one
|#

(defun count_arg (args) 
     (if (null args)
	0
	(+ 1 (count_arg (cdr args)))
     )
)





#| 
A function definition is an expression (f X1 ... Xn = Exp), where f is function name and
(x1 ... xn) are parameters. We cons every parmeters into one list until we reach the
header of the function "=".
|#


(defun get_param (L)
    (cond
        ((eq (car L) '=) nil)
        (t (cons (car L) (get_param (cdr L))))
    )
)




#| 
A function definition is an expression (f X1 ... Xn = Exp), where
EXp is the body of function. We use the recursion to trace p,
when we reach header "=", we use the cadr to get the EXP, which is the body of funtion definition 
|#

(defun get_body (E)
    (if (eq (car E) '=) (cadr E)
        (get_body (cdr E))
    )
    
)


#| 
a function is identified by both its name and arity (number of arguments).
In this function, when function name "f" equal to the correspoing function name in p, and number of arguments equal to number of parameters in p. Then we form the function application.
|#



(defun form_function_application (f N p)
	(cond
             ((null p) nil)
	     ((and (equal (caar p) f) (equal N (count_arg (get_param (cdar p))))) 
                   (list (get_param (cdar p)) (get_body (car p))))
	     (t (form_function_application f N (cdr p)))
        )
)




#| 
For CT_extender function, we bind parameter names to the values (evaluate arugments), 
cons them to the same list and add 
these bindings to current context to form the next context
|#

(defun CT_extender (params value CT)
   	(if (null params) CT
           (cons (cons (car params ) (car value)) (CT_extender (cdr params) (cdr value) CT))
   	)
   
)


#| 
Evaluate every arguments in current context, and cons them to same list
|#


(defun eval_args (args P CT)
    (if (null args) nil
        (cons (fl-interp-helper (car args) P CT) (eval_args (cdr args) P CT))
    )
    
)



#| 
Use recursion to check evey expression in context
|#


(defun check_Expression (E CT)
   (cond
      ((null CT) E)
      ((eq E (caar CT)) (cdar CT))
      (t (check_Expression E (cdr CT)))
   )
)  


(defun fl-interp (E P)
    (fl-interp-helper E P nil)
)


(defun fl-interp-helper (E p CT0)
  (cond 
	((atom E) (check_Expression E CT0))   ;this includes the case where expr is nil
        (t
           (let ( (f (car E))  (arg (cdr E)) )
	      (cond 
                ; handle built-in functions
                ;((eq f 'first)  (car (fl-interp-helper (car arg) p CT0)))
		;((eq f 'rest)   (cdr (fl-interp-helper (car arg) p CT0)))
		 ((eq f 'first)  (car (fl-interp-helper (car arg) P CT0)))
                 ((eq f 'rest)  (cdr (fl-interp-helper (car arg) P CT0)))

		((eq f 'if)     (if (fl-interp-helper (car arg) p CT0) (fl-interp-helper (cadr arg) p CT0) 
					(fl-interp-helper (caddr arg) p CT0)))
		((eq f 'null)   (null (fl-interp-helper (car arg) p CT0)))
		((eq f 'eq)     (eq (fl-interp-helper (car arg) p CT0) (fl-interp-helper (cadr arg) p CT0)))
		((eq f 'cons)   (cons (fl-interp-helper (car arg) p CT0) (fl-interp-helper (cadr arg) p CT0)))
		((eq f 'equal)  (equal (fl-interp-helper (car arg) p CT0) (fl-interp-helper (cadr arg) p CT0)))
		((eq f 'number) (numberp (fl-interp-helper (car arg) p CT0)))
		((eq f '+)      (+ (fl-interp-helper (car arg) p CT0) (fl-interp-helper (cadr arg) p CT0)))
		((eq f '-)      (- (fl-interp-helper (car arg) p CT0) (fl-interp-helper (cadr arg) p CT0)))
		((eq f '*)      (* (fl-interp-helper (car arg) p CT0) (fl-interp-helper (cadr arg) p CT0)))
		((eq f '>)      (> (fl-interp-helper (car arg) p CT0) (fl-interp-helper (cadr arg) p CT0)))
		((eq f '<)      (< (fl-interp-helper (car arg) p CT0) (fl-interp-helper (cadr arg) p CT0)))
		((eq f '=)      (= (fl-interp-helper (car arg) p CT0) (fl-interp-helper (cadr arg) p CT0)))
		((eq f 'and)    (and (fl-interp-helper (car arg) p CT0) (fl-interp-helper (cadr arg) p CT0)))
		((eq f 'or)     (or  (fl-interp-helper (car arg) p CT0) (fl-interp-helper (cadr arg) p CT0)))
		((eq f 'not)    (not (fl-interp-helper (car arg) p CT0)))	

		
	        

	        ; if f is a user-defined function,
                ;    then evaluate the arguments 
                ;         and apply f to the evaluated arguments 
                ;             (applicative order reduction) 
               
		
		(t
		   (let ((function_application (form_function_application f (count_arg arg) p)))
		         (let ((values (eval_args arg p CT0)))
                              (if (not (eq function_application nil))
                                  (let ((CT1 (CT_extender (car function_application) values CT0)))
                                       (let ((body (cadr function_application)))
                                             (fl-interp-helper body P CT1)
                                       )
                                  ) E
                              )
                          )
                    )
                )
		

                ; otherwise f is undefined; in this case,
                ; E is returned as if it is quoted in lisp

		;
              )
           )
        )
   )
)