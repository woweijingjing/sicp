; Exercise 2.1

;;;from chapter 1
(define (square x) (* x x))

;;;from section 1.2.5, for Section 2.1.1
(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

;; from section 2.1
(define (numer x) (car x))

(define (denom x) (cdr x))

(define (print-rat x)
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))

;; original make-rat
(define (make-rat n d)
  (let ((g (gcd n d)))
    (cons (/ n g) (/ d g))))

;;new, improved make-rat
(define (make-rat n d)
  (let ((g (abs (gcd n d))))
    (cond
     ((and (< n 0) (< d 0)) (make-rat (abs n) (abs d)))
     ((and (> n 0) (< d 0)) (make-rat (- n) (- d)))
     (else (cons (/ n g) (/ d g))))))

;; Exercise 2.2

(define (make-segment a b) (cons a b))

(define (start-segment a) (car a))

(define (end-segment b) (cdr b))

(define (make-point x y) (cons x y))

(define (x-point p) (car p))

(define (y-point p) (cdr p))

(define (midpoint-segment s)
  (make-point (/ (+ (x-point (start-segment s)) (x-point (end-segment s))) 2)
	      (/ (+ (y-point (start-segment s)) (y-point (end-segment s))) 2)))

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(define (print-segment s) (print-point (start-segment s))
  (print-point (end-segment s)))

;; exercise 2.3

;; Representation 1: define rectable by the top-left and bottom-right  points
(define (make-rect tl br) (cons tl br))

(define (top-left-rect r) (car r))
(define (bottom-right-rect r) (cdr r))

(define (width-rect r) (- (x-point (bottom-right-rect r)) (x-point (top-left-rect r))))
(define (height-rect r) (- (y-point (top-left-rect r)) (y-point (bottom-right-rect r))))

;; Representation 2: define rectangle by an origin point and a size, which consists of a width and height
(define (make-rect origin size) (cons origin size))
(define (origin-rect r) (car r))
(define (size-rect r) (cdr r))

(define (width-rect r) (x-point (size-rect r)))
(define (height-rect r) (y-point (size-rect r)))

;;;; These procedures work with either representation above.
(define (perimeter-rect r) (+ (* 2 (width-rect r)) (* 2 (height-rect r))))
(define (area-rect r) (* (width-rect r) (height-rect r)))

;;exercise 2.4

(define (cons2 x y)
  (lambda (m) (m x y)))

(define (car2 z)
  (z (lambda (p q) p)))

;;substitution for (car (cons 1 2))

(car (cons 1 2))
(car (lambda (m) (m 1 2)))
((lambda (m) (m 1 2)) (lambda (p q) p))
((lambda (p q) p) 1 2)
(lambda (1 2) 1)
1
;; resulting definition

(define (cdr2 z)
  (z (lambda (p q) q)))

;; Exercise 2.5

(define (cons3 a b)
  (* (expt 2 a) (expt 3 b)))

(define (cdr3 c)
  (define (helper x count)
    (if (= 0 (remainder x 3))
	(helper (/ x 3) (+ 1 count))
	count))
  (helper c 0))

(define (car3 c)
  (define (helper x count)
    (if (= 0 (remainder x 2))
	(helper (/ x 2) (+ 1 count))
	count))
  (helper c 0))

;; Exercise 2.6

(define zero (lambda (f) (lambda (x) x)))

(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

(add-1 zero)
(lambda (f) (lambda (x) (f ((zero f) x))))
(lambda (f) (lambda (x) (f (lambda (x1) x1) x)))
(lambda (f) (lambda (x) (f x)))

(define one
  (lambda (f) (lambda (x) (f x))))

(add-1 one)
(lambda (f) (lambda (x) (f ((one f) x))))
(lambda (f) (lambda (x) (f ((lambda (x) f x) x))))
(lambda (f) (lambda (x) (f (f x))))

(define two
  (lambda (f) (lambda (x) (f (f x)))))

(define (add-2 n)
  (lambda (f)
    (lambda (x)
      (f (f ((n f) x))))))

(define (add-3 n)
  (lambda (f)
    (lambda (x)
      (f (f (f ((n f) x)))))))

(add zero one)
...
(lambda (f) (lambda (x) (f x)))

(add one one)
...
(lambda (f) (lambda (x) (f (f x))))



(define (add a b)
  (lambda (f)
    (lambda (x)
      (f ((a f) x))))) ;; add-1, need to do this b times

(define (add a b)
  (lambda (f)
    (lambda (x)
      ((b f) ((a f) x)))))



;;Takes a procedure and returns a procedure that takes one argument and applies the original procedure applied to 

;; let b =   (lambda (f) (lambda (x) (f x))))

(((lambda (f) (lambda (x) (f x)))) (a f)) x)

;;;;; Extended Exercise


(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (div-interval x y)
  (mul-interval x 
                (make-interval (/ 1.0 (upper-bound y))
                               (/ 1.0 (lower-bound y)))))

;; EXERCISE 2.7

(define (make-interval a b) (cons a b))

(define (upper-bound c) (cdr c))
(define (lower-bound c) (car c))

;; EXERCISE 2.11


(define (mul-interval x y)
  (let ((lower-x (lower-bound x))
	(upper-x (upper-bound x))
	(lower-y (lower-bound y))
	(upper-y (upper-bound y)))    
  (cond ((and (< 0 lower-x) (< 0 upper-x) (< 0 lower-y) (< 0 upper-y)) ;; (+ . +) (+ . +)
	 (make-interval (* lower-x lower-y) (* upper-x upper-y)))
	((and (> 0 lower-x) (> 0 upper-x) (> 0 lower-y) (> 0 upper-y)) ;; (- . -) (- . -)
	 (make-interval (* upper-x upper-y) (* lower-x lower-y)))
	((and (> 0 lower-x ;; (- . -) (+ . +)
	(else (display "Not Implemented")))))

;; Ex

;;;SECTION 2.1.4 again

(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))

(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))

(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))


;; parallel resistors

(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1))) 
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))

(mul-interval (make-interval 1 2) (make-interval 4 5))

;;Exercise 2.17
(define (last-pair l)
  (define (find-last this-pair prev-pair)
    (if (null? (cdr this-pair))
	prev-pair
	(find-last (cdr this-pair) (car (cdr this-pair)))))
  (if (null? l)
      '()
      (find-last l (car l))))

;;; Exercise 2.18
(define (remove-last l)
  (if (null? (cdr l))
      '()
      (cons (car l) (remove-last (cdr l)))))

(define (reverse l)
  (if (null? (cdr l))
      (list (car l))
      (cons (last-pair l) (reverse (remove-last l)))))

;; 2.19

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
         (+ (cc amount
                (except-first-denomination coin-values))
            (cc (- amount
                   (first-denomination coin-values))
                coin-values)))))

(define us-coins (list 50 25 10 5 1))

(define (first-denomination lst)
  (car lst))

(define (except-first-denomination lst)
  (cdr lst))

(define (no-more? lst)
  (null? lst))

;;2.20

(define (same-parity x . y)
  (let ((first-is-even (even? x)))
    (define (parity-list l)
      (cond
       ((null? l) l)
       ((and first-is-even (even? (car l)))(cons (car l) (parity-list (cdr l))))
       ((and (not first-is-even) (odd? (car l))) (cons (car l) (parity-list (cdr l))))
       (else (parity-list (cdr l)))))
    (parity-list (cons x y))))
	   
	  
      
;;2.21
(define nil '())

(define (square-list items)
  (if (null? items)
      nil
      (cons (square (car items)) (square-list (cdr items)))))

(define (square-list items)
  (map square items))

;;2.22
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things) 
              (cons (square (car things))
                    answer))))
  (trace iter)
  (iter items nil))

;;(cons (square (car things)) answer)
;; answer = nil
;;(car things) -> 2
;; (cons 4 nil) -> (4)
;; answer -> (4)
;; (cons (square (car things)) answer)
;; (cons 9 (4))
;; (cons 16 (9 4))


(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (trace iter)
  (iter items nil))

;;substitution
(cons (answer (square (car things))))
(cons nil 4)
(() . 4)
(cons (() . ) 9)
((() . 4) . 9)

;;Ex 2.23
(define (my-for-each proc l)
  (cond ((null? l) #t)
	(else (proc (car l)) (my-for-each proc (cdr l)))))

(for-each (lambda (x) (newline) (display x))
          (list 57 321 88))

(my-for-each (lambda (x) (newline) (display x))
          (list 57 321 88))

(list 1 2 (list 5 7) 9)
(car (cdr (car (cdr (cdr (list 1 2 (list 5 7) 9))))))
(car (car '((7))))
(list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7))))))
(car (cdr (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7))))))))))))))))))

;;2.27

(define (last-pair l)
  (define (find-last this-pair prev-pair)
    (if (null? (cdr this-pair))
	prev-pair
	(find-last (cdr this-pair) (car (cdr this-pair)))))
  (if (null? l)
      '()
      (find-last l (car l))))

(define (remove-last l)
  (if (null? (cdr l))
      (list)
      (cons (car l) (remove-last (cdr l)))))

(define (reverse l)
  (if (null? (cdr l))
      (list (car l))
      (cons (last-pair l) (reverse (remove-last l)))))






(define (deep-reverse l)
  (cond ((null? l) nil)
	((not (pair? l)) l)
	(else (cons (deep-reverse (last l))
		    (deep-reverse (remove-last l))))))

;; 2.28

(define (fringe l)
  (cond ((null? l) '())
	((not (pair? (car l))) (cons (car l) (fringe (cdr l))))
	(else (append (fringe (car l)) (fringe (cdr l))))))



;; exer 2.29

(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

;; part a

(define (left-branch mobile)
  (car mobile))
(define (right-branch mobile)
  (car (cdr mobile)))

(define (branch-length branch)
  (car branch))
(define (branch-structure branch)
  (car (cdr branch)))

;; part b
(define (total-weight mobile)
  (define (mobile-weight m)
    (+ (branch-weight (left-branch m))
       (branch-weight (right-branch m))))
  (define (branch-weight b)
    (let ((structure (branch-structure b)))
      (cond ((null? b) 0)
	    ((not (pair? structure)) structure)
	    (else (mobile-weight structure)))))
  (mobile-weight mobile))



(define mobile '((1 1)(2 ((3 3)(4 4)))))

;; part c
(define (balanced? m)
  (define (branch-weight b)
    (let ((structure (branch-structure b)))
      (cond ((null? b) 0)
	    ((not (pair? structure)) structure)
	    (else (mobile-weight structure)))))
  (define (mobile-weight m)
    (+ (branch-weight (left-branch m))
       (branch-weight (right-branch m))))
  (let ((left-struct (branch-structure (left-branch m)))
	(right-struct (branch-structure (right-branch m))))
    (cond ((not (= (branch-weight (right-branch m)) (branch-weight (left-branch m)))) #f)
	  ((and (pair? right-struct) (pair? left-struct)) 
	   (and (balanced? right-struct) (balanced? left-struct)))
	  ((pair? left-struct) (balanced? left-struct))
	  ((pair? right-struct) (balanced? right-struct))
	  (else #t))))
    


(define (balanced? m)
  (define (branch-weight b)
    (let ((structure (branch-structure b)))
      (cond ((null? b) 0)
	    ((not (pair? structure)) structure)
	    (else (mobile-weight structure)))))
  (define (mobile-weight m)
    (+ (branch-weight (left-branch m))
       (branch-weight (right-branch m))))
  (define (branch-torque b)
    (* (branch-weight b)(branch-length b)))
    
  (let ((left-struct (branch-structure (left-branch m)))
	(right-struct (branch-structure (right-branch m))))
    (cond ((not (= (branch-torque (right-branch m)) (branch-torque (left-branch m)))) #f)
	  ((and (pair? right-struct) (pair? left-struct)) 
	   (and (balanced? right-struct) (balanced? left-struct)))
	  ((pair? left-struct) (balanced? left-struct))
	  ((pair? right-struct) (balanced? right-struct))
	  (else #t))))

;;ex 2.30

(define (square-tree tree)
  (cond ((null? tree) nil)
	((not (pair? (car tree))) (cons (square (car tree)) (square-tree (cdr tree))))
	(else (cons (square-tree (car tree)) (square-tree (cdr tree))))))

(define (square-tree tree)
  (map (lambda (x)
	 (if (pair? x)
	     (square-tree x)
	     (square x)))
       tree))

;; 2.31

(define (tree-map proc tree)
  (map (lambda (x)
	 (if (pair? x)
	     (tree-map proc x)
	     (proc x)))
       tree))

(define (square-tree tree) (tree-map square tree))

;;2.32

(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map <??> rest)))))



;; 2.33

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (mapp p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) nil sequence))
(define (appendd seq1 seq2)
  (accumulate cons seq2 seq1))
(define (lengthh sequence)
  (accumulate (lambda (x y) (1+ y))  0 sequence))


;;2.34

(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms) (+ this-coeff
						   (* higher-terms x)))
              0
              coefficient-sequence))

(horner-eval 2 (list 1 3 0 5 0 1))
(+ 1 (* 3 2) (* 5 (expt 2 3)) (expt 2 5))

(accumulate (lambda (x y) (cons (* x x) y)) nil '(1 2 3))

;;2.35

;; Original procedure from 2.2.2
(define (count-leaves x)
  (cond ((null? x) 0)  
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))

(define (fringe l)
  (cond ((null? l) '())
	((not (pair? (car l))) (cons (car l) (fringe (cdr l))))
	(else (append (fringe (car l)) (fringe (cdr l))))))

(define (count-leaves t)
  (accumulate (lambda (x y) (1+ y)) 0 (fringe t)))

(define (count-leaves t)
  (accumulate + 0 (map (lambda (x)
			 (if (pair? x)
			     (count-leaves x)
			     1)) t)))
						 


(accumulate + 0 '(1 2 3))
(map (lambda (x)
       (if ((null? x)'())
	     ((pair? x)(car x))
	     (else x)))
			'(1 2 3 4))

;; 3xercise 2.36

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))

(accumulate-n + 0 '((1 2 3)(4 5 6)(7 8 9)(10 11 12)))
(cons (numerical sum) (list of results))


numerical num 
(pair? (car seqs)) -> take the next one until not a pair


((1 2 3) (4 5 6) (7 8 9) (10 11 12))
(22 26 30)
;;exercise 2.37
(define (dot-product v w)
  (accumulate + 0 (map * v w)))
(define v1 '(1 2 3 4))
(define v2 '(5 6 7 8))
(define m1 '((1 2 3 4)(5 6 7 8)))

(define (matrix-*-vector m v)
  (map (lambda (x) (map * x v))
       m))

(define (transpose mat)
  (accumulate-n (lambda (x y)
		  (cons x y))
		'() mat))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (x)
	   (map (lambda (y) (dot-product x y)) cols))
	 m)))

;; 2.38
(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
	result
	(iter (op result (car rest))
		  (cdr rest))))
  (iter initial sequence))

(fold-right / 1 (list 1 2 3))
(fold-left / 1 (list 1 2 3))

(fold-right / 2 '(2 4 6))
(accumulate / 2 '(2 4 6))


(fold-right / 2 '(3 4 5))
(/ 3 (/ 4 (/ 5 2)))

(fold-left / 2 '(3 4 5))
(/ (/ (/ 2 3) 4) 5)

;;commutative

(fold-right / 2 '(5 4 3))



(fold-right list nil (list 1 2 3))
(list 1 (list 2 (list 3 '())))

(fold-left list nil (list 1 2 3))
(list (list (list '() 1) 2) 3)

(fold-left cons nil '(1 2 3))
(fold-right cons nil '(1 2 3))

(fold-left cons '() '(1 2 3))

(fold-right cons '() '(1 2 3))

;;2.39
(define (reverse sequence)
  (fold-right (lambda (x y) (append y (list x))) nil sequence))



(define (reverse sequence)
  (fold-left (lambda (x y) (cons y x)) nil sequence))




;;Nested mappings
(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))


(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum?
               (flatmap
                (lambda (i)
                  (map (lambda (j) (list i j))
                       (enumerate-interval 1 (- i 1))))
                (enumerate-interval 1 n)))))

(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

;;exer 2.40
(define (unique-pairs n)
  (+ 1 n))

(accumulate append
            nil
            (map (lambda (i)
                   (map (lambda (j) (list i j))
                        (enumerate-interval 1 (- i 1))))
                 (enumerate-interval 1 n)))


(flatmap (lambda (x) (list (list x 1))) '(1 2 3))
(map (lambda (x) (list x 1)) '(1 2 3))

;;Exer 2.40
(define (unique-pairs n)
  (map (lambda (x) (map (e)
       (enumerate-interval 1  n)))))

(flatmap
 (lambda (i)
   (map (lambda (j) (list i j))
	(enumerate-interval 1 (- i 1))))
 '(1 2 3))

(define (reverse l)
  (fold-right (lambda (x y) (append y (list x))) '() l))

(define (reverse l)
  (fold-left (lambda (x y) (cons y x)) '() l))


;;for MIT Scheme graphics
(define g 
  (let ((dev (make-graphics-device 'x))) ;;X11
    (graphics-set-coordinate-limits dev 0 0 1 1)
    dev))

(define (draw-line start end)
  (graphics-draw-line g
		      (xcor-vect start)
		      (ycor-vect start)
		      (xcor-vect end)
		      (ycor-vect end)))


(graphics-clear g)
(graphics-close g)


;;exer 2.44

(define (up-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (up-split painter (- n 1))))
	(below painter (beside smaller smaller)))))

;;Exercise 2.45
(define (split large small)
  (lambda (painter n)
    (if (= n 0)
	painter
	(let ((smaller ((split first small) painter (- n 1))))
	  (large painter (small smaller smaller))))))

(define (split large small)
  (lambda (painter n)
    (if (= n 0)
	painter
	(let ((smaller ((split large small) painter (- n 1))))
	  (large painter (small smaller smaller))))))

(define right-split (split beside below))
 
(define up-split (split below beside))

;;exer 2.46
(define (make-vect x y)
  (list x y))
(define (xcor-vect v)
  (car v))
(define (ycor-vect v)
  (cadr v))

(define (add-vect v1 v2)
  (make-vect (+ (xcor-vect v1) (xcor-vect v2))
	     (+ (ycor-vect v1) (ycor-vect v2))))
(define (sub-vect v1 v2)
  (make-vect (- (xcor-vect v1) (xcor-vect v2))
	     (- (ycor-vect v1) (ycor-vect v2))))
(define (scale-vect s v)
  (make-vect (* (xcor-vect v) s)
	     (* (ycor-vect v) s)))

;;2.47
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))
(define (origin-frame f)
  (car f))
(define (edge1-frame f)
  (cadr f))
(define (edge2-frame f)
  (caddr f))


(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))
(define (origin-frame f)
  (car f))
(define (edge1-frame f)
  (car (cdr f)))
(define (edge2-frame f)
  (cdr (cdr f)))

;; The frame designed to work with the grphics device g defined above
(define f (make-frame (make-vect 0 0) (make-vect 1 0) (make-vect 0 1)))

;;2.48
(define (make-segment start end)
  (cons start end))
(define (start-segment s)
  (car s))
(define (end-segment s)
  (cdr s))

(define (make-segment start end)
  (list start end))
(define (start-segment s)
  (car s))
(define (end-segment s)
  (cadr s))

;;2.49

(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
     (origin-frame frame)
     (add-vect (scale-vect (xcor-vect v)
                           (edge1-frame frame))
               (scale-vect (ycor-vect v)
                           (edge2-frame frame))))))

;;from text
(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
     (lambda (segment)
(       (draw-line
        ((frame-coord-map frame) (start-segment segment))
        ((frame-coord-map frame) (end-segment segment))))
     segment-list)))


;; circles
(define (length-segment s)
  (let ((difference-vect (sub-vect (start-segment s) (end-segment s))))
    (let ((height (ycor-vect difference-vect))
	  (width (xcor-vect difference-vect)))
      (sqrt (+ (* height height) (* width width))))))

(define (make-circle origin radius)
  (list origin radius))

(define (origin-circle circle)
  (car circle))
(define (radius-circle circle)
  (cadr circle))

(define (circle-painter frame)
  (let ((m (frame-coord-map frame)))
    (let ((origin (m (make-vect 0.5 0.5)))
	  (bottom (m (make-vect 0.5 0.0)))
	  (left (m (make-vect 0.0 0.5))))
      (let ((r1 (length-segment (make-segment origin bottom)))
	    (r2 (length-segment (make-segment origin left))))
	  (draw-circle origin (if (> r1 r2) r2 r1))))))



;; draw circle based on origin and radius
(define (draw-circle origin radius)
  (graphics-operation g 'fill-circle (xcor-vect origin)
		      (ycor-vect origin)
		      radius))
;; end circles

(define (diagonal-painter frame)
   ((segments->painter (list (make-segment (make-vect 0 0) (make-vect 1 1)))) frame))


(define f1 (make-frame
	    (make-vect 0 0)
	    (make-vect 1 0)
	    (make-vect 0 1)))
(define f2 (make-frame
	    (make-vect 0 0)
	    (make-vect 0 .5)
	    (make-vect .5 0)))
(define f3 (make-frame
	    (make-vect .2 .2)
	    (make-vect .4 .25)
	    (make-vect .25 .4)))

(define (square-painter frame)
  (let ((v1 (make-vect 0 0))
	(v2 (make-vect 0 1))
	(v3 (make-vect 1 1))
	(v4 (make-vect 1 0)))
    (let ((segments (list (make-segment v1 v2)
			  (make-segment v2 v3)
			  (make-segment v3 v4)
			  (make-segment v4 v1))))
      ((segments->painter segments) frame))))


(define (x-painter frame)
  (let ((v1 (make-vect 0 0))
	(v2 (make-vect 1 1))
	(v3 (make-vect 0 1))
	(v4 (make-vect 1 0)))
    (let ((segments (list (make-segment v1 v2)
			  (make-segment v3 v4))))
      ((segments->painter segments) frame))))

(define (diamond-painter frame)
  (let ((v1 (make-vect 0 .5))
	(v2 (make-vect .5 0))
	(v3 (make-vect 1 .5))
	(v4 (make-vect .5 1)))
    (let ((segments (list (make-segment v1 v2)
			  (make-segment v2 v3)
			  (make-segment v3 v4)
			  (make-segment v4 v1))))
      ((segments->painter segments) frame))))
  
(define (pattern-painter frame)
  (x-painter frame)
  ((shrink-to-upper-right circle-painter) frame)
  ((transform-painter diamond-painter (make-vect 0 0) (make-vect 0 .5) (make-vect .5 0)) frame)
  (square-painter frame))

;;Transforms
(define (transform-painter painter origin corner1 corner2)
  (lambda (frame)
    (let ((m (frame-coord-map frame)))
      (let ((new-origin (m origin)))
        (painter
         (make-frame new-origin
                     (sub-vect (m corner1) new-origin)
                     (sub-vect (m corner2) new-origin)))))))

(define (flip-vert painter)
  (transform-painter painter
                     (make-vect 0.0 1.0)    ; new origin
                     (make-vect 1.0 1.0)    ; new end of edge1
                     (make-vect 0.0 0.0)))  ; new end of edge2


(define (shrink-to-upper-right painter)
  (transform-painter painter
                     (make-vect 0.5 0.5)
                     (make-vect 1.0 0.5)
                     (make-vect 0.5 1.0)))


(define (rotate90 painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)))


(define (squash-inwards painter)
  (transform-painter painter
                     (make-vect 0.0 0.0)
                     (make-vect 0.65 0.35)
                     (make-vect 0.35 0.65)))


(define (beside painter1 painter2)
  (let ((split-point (make-vect 0.5 0.0)))
    (let ((paint-left
           (transform-painter painter1
                              (make-vect 0.0 0.0)
                              split-point
                              (make-vect 0.0 1.0)))
          (paint-right
           (transform-painter painter2
                              split-point
                              (make-vect 1.0 0.0)
                              (make-vect 0.5 1.0))))
      (lambda (frame)
        (paint-left frame)
        (paint-right frame)))))


;;2.50
(define (flip-horiz painter)
  (transform-painter painter
		     (make-vect 1 0)
		     (make-vect 0 0)
		     (make-vect 1 1)))

(define (rotate180 painter)
  (transform-painter painter
		     (make-vect 1 1)
		     (make-vect 0 1)
		     (make-vect 1 0)))

(define (rotate270 painter)
  (transform-painter painter
		     (make-vect 0 1)
		     (make-vect 0 0)
		     (make-vect 1 1)))

(define (below painter1 painter2)
  (let ((split-point (make-vect 0.0 0.5)))
    (let ((paint-up
	   (transform-painter painter2
			      split-point
			      (make-vect 1.0 .5)
			      (make-vect 0.0 1.0)))
	  (paint-down
	   (transform-painter painter1
			      (make-vect 0.0 0.0)
			      (make-vect 1.0 0.0)
			      split-point)))
      (lambda (frame)
	(paint-up frame)
	(paint-down frame)))))

(define (below painter1 painter2)
  (rotate90 (beside (rotate270 painter1) (rotate270 painter2))))

;;Exercise 2.54

(define (e? a b)
  (if (and (pair? a) (pair? b))
      (and (e? (car a) (car b)) (e? (cdr a) (cdr b)))
      (eq? a b)))

;;Exercise 2.55
(car ''abracadabra)
(car (quote (quote abracadabra)))

;;Exercise 2.56

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        (else
         (error "unknown expression type -- DERIV" exp))))


(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (make-sum a1 a2) (list '+ a1 a2))

(define (make-product m1 m2) (list '* m1 m2))

(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))

(define (addend s) (cadr s))

(define (augend s) (caddr s))

(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (multiplier p) (cadr p))

(define (multiplicand p) (caddr p))

;;
(deriv '(+ x 3) 'x)

(deriv '(* x y) 'x)

(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))

(define (base x) (cadr x))

(define (exponent x) (caddr x))

(define (make-exponentiation b e)
  (list '** b e))

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
	((exponentiation? exp)
	 (make-product
	  (make-product (exponent exp)
			(make-exponentiation (base exp)
					     (make-sum (exponent exp) -1)))
	  (deriv (base exp) var)))
        (else
         (error "unknown expression type -- DERIV" exp))))

;; With simplification

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list '+ a1 a2))))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list '* m1 m2))))



(deriv '(** x 2) 'x)
;Value 19: (* 2 (** x 1))

(deriv '(** x 4) 'x)
;Value 20: (* 4 (** x 3))

(deriv '(** x y) 'x)
;Value 21: (* y (** x (+ y -1)))


;; Exercise 2.57

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list '+ a1 a2))))

(define (make-sum a1 . a2)
  (if (null? (cdr a2))
      (if (sum? (car a2))
	  (append (list '+ a1) (cdar a2))
	  (list '+ a1 (car a2)))
	(append (list '+ a1) a2)))



(define (simplify-sum s)
  (define (simplify num sym rest)
    (cond ((null? rest) (append (list '+ num) sym))
	  ((number? (car rest)) (simplify (+ num (car rest)) sym (cdr rest)))
	  ((variable? (car rest)) (simplify num (cons (car rest) sym) (cdr rest)))))
  (simplify 0 '() (cdr s)))
	    
  

(define (augend sum)
  (let ((rest (cddr sum)))
    (if (null? (cdr rest))
	(car rest)
	(append (make-sum (car rest) (cadr rest)) (cddr rest)))))


(define (make-product m1 . m2)
  (if (null? (cdr m2))
      (if (product? (car m2))
	  (append (list '* m1) (cdar m2))
	  (list '* m1 (car m2)))
      (append (list '* m1) m2)))

(define (multiplicand p)
  (let ((rest (cddr p)))
    (if (null? (cdr rest))
	(car rest)
	(append (make-product (car rest) (cadr rest)) (cddr rest)))))


(make-sum (addend (make-sum 1 2 3 4)) (augend (make-sum 1 2 3 4)))
;Value 86: (+ 1 2 3 4)

(make-product (multiplier (make-product 1 2 3 4)) (multiplicand (make-product 1 2 3 4)))
;Value 92: (* 1 2 3 4)

(deriv '(* x y (+ x 3)) 'x)
;Value 93: (+ (* x (+ (* y (+ 1 0)) (* 0 (+ x 3)))) (* 1 y (+ x 3)))

(deriv '(* (* x y) (+ x 3)) 'x)
;Value 94: (+ (* (* x y) (+ 1 0)) (* (+ (* x 0) (* 1 y)) (+ x 3)))


;Exercise 2.58 - infix

(define (make-sum a1 a2)
 (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
	(else (list a1 '+ a2))))

(define (make-sum a1 a2)
  (list a1 '+ a2))
(define (sum? s)
  (and (pair? s) (eq? (cadr s) '+)))

(define (addend s)
  (car s))

(define (augend s)
  (caddr s))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
	((=number? m1 1) m2)
	((=number? m2 1) m1)
	((and (number? m1) (number? m2)) (* m1 m2))
	(else (list m1 '* m2))))

(define (make-product m1 m2)
  (list m1 '* m2))

(define (product? p)
  (and (pair? p) (eq? (cadr p) '*)))

(define (multiplier p)
  (car p))

(define (multiplicand p)
  (caddr p))

(deriv '(x + (3 * (x + (y + 2)))) 'x)
;Value: 4
(deriv '(+ x (* 3 (+ x (+ y 2)))) 'x)
;Value: 4

;;Exercise 2.59

(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))


(define (union-set s1 s2)
  (cond ((null? s1) s2)
	((element-of-set? (car s1) s2) (union-set (cdr s1) s2))
	(else (union-set (cdr s1) (cons (car s1) s2)))))




;;Exercise 2.60

;;same as above
(define (element-of-set? x set)
  (cond ((null? x) false)
	((equal? x (car set)) true)
	(else (element-of-set? x (cdr set)))))
     
  
(define (adjoin-set x set)
  (cons x set))

(define (union-set set1 set2)
  (append set1 set2))

(define (memq item x)
  (cond ((null? x) '())
        ((eq? item (car x)) x)
        (else (memq item (cdr x)))))

(define (union-set s1 s2)
  (define (union-right set1 set2)
    (cond ((null? set1) set2)
	  ((element-of-set? (car set1) set2) (union-set (cdr set1) set2))
	  (else (cons (car set1) (union-set (cdr set1) set2)))))
  (union-right (union-right s1 s2) s1))



(define s1 '(1 1 2 2 3 3))
(define s2 '(1 2 3))


(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
	((element-of-set? (car set1) set2)
	 (cons (car set1) (intersection-set (cdr set1) (cdr set2))))
	(else (intersection-set (cdr set1) set2))))

;;Exercise 2.61

(define (adjoin-set x set)
  (let ((next (car set)))
    (cond ((< x next) (cons x set))
	  ((> x next) (if (null? (cdr set))
			       (list (car set) x)
			       (cons next (adjoin-set x (cdr set)))))
	  (else set))))

;;Exercise 2.62

(define (union-set set1 set2)
(if (or (null? set1) (null? set2)) '()
  (let ((x1 (car set1)) (x2 (car set2)))
    (cond ((= x1 x2) (cons x1 (union-set (cdr set1) (cdr set2))))
	  ((< x1 x2) (union-set (cdr set1) set2))
	  ((> x1 x2) (union-set set1 (cdr set2)))))))


;; 2.63

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

(define (element-of-set? x set)
  (cond ((null? set) false)
        ((= x (entry set)) true)
        ((< x (entry set))
         (element-of-set? x (left-branch set)))
        ((> x (entry set))
         (element-of-set? x (right-branch set)))))

(define (adjoin-set x set)
  (cond ((null? set) (make-tree x '() '()))
        ((= x (entry set)) set)
        ((< x (entry set))
         (make-tree (entry set) 
                    (adjoin-set x (left-branch set))
                    (right-branch set)))
        ((> x (entry set))
         (make-tree (entry set)
                    (left-branch set)
                    (adjoin-set x (right-branch set))))))


(define (tree->list-1 tree)
  (if (null? tree)
      '()
      (append (tree->list-1 (left-branch tree))
              (cons (entry tree)
                    (tree->list-1 (right-branch tree))))))

(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list (right-branch tree)
                                          result-list)))))
  (copy-to-list tree '()))

