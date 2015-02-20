(define *num-passed* 0)
(define (assert:equal msg actual expected)
  (if (not (equal? actual expected))
      (error "Unit test failed [" msg "] actual [" actual "] expected [" expected "]")
      (set! *num-passed* (+ *num-passed* 1))))

(define (assert:not-equal msg x y)
  (assert:equal msg (not (equal? x y)) #t))

(define (assert msg val)
  (assert:equal msg (not val) #f))

(assert "Testing assert function" #t)
(assert "Testing assert function" 1)

;; Adder example
(define (make-adder x)
  (lambda (y) (+ x  y)))
(define increment (make-adder +1))
(assert:equal "Adder #1" (increment 41) 42)
(define decrement (make-adder -1))
(assert:equal "Adder #2" (decrement 42) 41)

(assert:equal "Application example"
  ((lambda (x) x) (+ 41 1))
  42)

;; Apply section
(assert:equal "" (apply length '((#t #f))) 2)
(assert:equal "" (apply cons '(#t #f)) '(#t . #f))
(assert:equal "" (apply cadr (list (list 1 2 3 4))) 2)
(assert:equal "" (apply null? (list '())) #t)
;; Varargs
(define (list2 a b . objs) objs)
(assert:equal "apply varargs" (list 42 1) '(42 1))
(assert:equal "apply varargs" (list 42 1 2) '(42 1 2))
(assert:equal "apply varargs" (list2 42 1) '())
(assert:equal "apply varargs" (list2 42 1 2) '(2))

(assert:equal "begin" (begin 1 2 (+ 1 2) (+ 3 4)) 7)

;; Continuation section
(assert:equal
    "simple call/cc"
    (call/cc
      (lambda (k)
        (k 2)))
    2)
(assert:equal "escape continuation"
    (call/cc
      (lambda (return)
        (begin
          (return 'return))))
    'return)

;; Closure section
(assert:equal "simple closure"
  (((lambda (x.1) 
    (lambda (y.2) 
      (cons x.1 y.2))) #t) #f)
 '(#t . #f))
(assert:equal "closure #2"
  ((lambda (x y)
    ((lambda () (- x y)))) 5 4)
  1)

;; Factorial
(define (fac n) (if (= n 0) 1 (* n (fac (- n 1)))))
(assert:equal "Factorial example" (fac 10) 3628800)

;; If section
(assert:equal "if example" (if #t 1 2) 1)
(assert:equal "if example" (if #f 1 2) 2)
(assert:equal "if example" (if (+ 1 2) (+ 3 4) (* 3 4)) 7)
(assert:equal "if" (if ((lambda (x) (+ x 1)) 0) (+ 1 1) (* 0 0)) 2)
(assert:equal "no else clause" (if #t 'no-else-clause) 'no-else-clause)

(assert:equal "" (+ (+ 1 1) (* 3 4)) 14)

;; Set section
((lambda (x)
    (set! x #t) ; (+ 2 (* 3 4)))
    (assert:equal "set local x" x #t))
 #f)

(define a '(#f #f))
(define b '(#f . #f))

(set-car! a 1)
(set-cdr! a '(2))
(assert:equal "set car/cdr a" a '(1 2))
(set-cdr! a 2)
(set-car! b '(#t))
(set-cdr! b '#t)

(assert:equal "set a" a '(1 . 2))
(assert:equal "set b" b '((#t) . #t))

;; Scoping example
(define scope #f)
(assert:equal "outer scope" scope #f)
((lambda (scope)
    (assert:equal "inner scope" scope #t)
 ) #t)

;; Square example
(let ((x 10) 
      (y 20) 
      (square (lambda (x) (* x x)))) 
  (begin 
    (assert:equal "square x" (square x) 100) 
    (assert:equal "square y" (square y) 400)))

;; String section
(define a "a0123456789")
(assert:equal "string eq" a "a0123456789")
(assert:not-equal "string eq" a 'a0123456789)
(define b "abcdefghijklmnopqrstuvwxyz")
(define c "hello, world!")
(define d (list->string '(#\( #\" #\a #\b #\c #\" #\))))
(assert:equal "strings" d "(\"abc\")")
(assert:equal "strings" d "(\"abc\")") ;; Test GC
(assert:equal "strings" d "(\"abc\")") ;; Test GC
(set! a "hello 2")
(assert:equal "strings" a "hello 2")

;; Recursion example:
(letrec ((fnc (lambda (i) 
                (begin
                    ;(display i)
                    (if (> i 0) (fnc (- i 1)) 0)))))
    (fnc 10))

(assert:equal "numeric small reverse" (reverse '(1 2)) '(2 1))
(assert:equal "small reverse" (reverse '(a b c)) '(c b a))
(assert:equal "larger reverse" (reverse '(1 2 3 4 5 6 7 8 9 10)) '(10 9 8 7 6 5 4 3 2 1))
;;  ;TODO: improper list, this is an error: (reverse '(1 . 2))
(assert:equal "char whitespace" (char-whitespace? #\space) #t)
(assert:equal "char whitespace" (char-whitespace? #\a) #f)
(assert:equal "char numeric" (char-numeric? #\1) #t)
(assert:equal "char numeric" (char-numeric? #\newline) #f)
(assert:equal "" (and 1 2 3) 3)
(assert:equal "" (and #t #f 'a 'b 'c) #f)
(assert:equal "" (or 1 2 3) 1)
(assert:equal "" (or #f 'a 'b 'c) 'a)
(assert:equal "" (string-append "") "")
;error - (string-append 1)
(assert:equal "" (string-append "test") "test")
(assert:equal "" (string-append "ab" "cdefgh ij" "klmno" "p" "q" "rs  " "tuv" "w" " x " "yz")
  "abcdefgh ijklmnopqrs  tuvw x yz")
(assert:equal "" (string->number "0") 0)
(assert:equal "" (string->number "42") 42)
;(assert:equal "" (string->number "343243243232") ;; Note no bignum support
(assert:equal "" (string->number "3.14159") 3) ;; Currently no float support
(assert:equal "" (list->string (list #\A #\B #\C)) "ABC")
(assert:equal "" (list->string (list #\A)) "A")
(assert:equal "" (list->string (list)) "") 
(assert:equal "" (integer->char 65) #\A)
(assert:equal "" (char->integer #\a) 97)

(assert:equal "" (number->string (+ 1 2)) "3")
(assert:equal "" (string->list "test") '(#\t #\e #\s #\t))
(assert:equal "" (string->symbol "a-b-c-d") 'a-b-c-d)
(assert:equal "" (symbol->string 'a/test-01) "a/test-01")
(assert:equal "" (eq? 'a-1 'a-1) #t)
(assert:equal "" (eq? (string->symbol "aa") 'aa) #t)
(assert:equal "" (equal? (string->symbol "aa") 'aa) #t)

;; Map
(assert:equal "map 1" (map (lambda (x) (car x)) '((a . b) (1 . 2) (#\h #\w))) '(a 1 #\h))
(assert:equal "map 2" (map car '((a . b) (1 . 2) (#\h #\w))) '(a 1 #\h))
(assert:equal "map 3" (map cdr '((a . b) (1 . 2) (#\h #\w))) '(b 2 (#\w)))
(assert:equal "map length"
  (map length '(() (1) (1 2) (1 2 3) (1 2 3 4)))
 '(0 1 2 3 4))

;; Prove internal defines are compiled properly
;;
;; Illustrates an old problem with compiling parser.
;; how to handle the internal define p?
;; trans was trying to wrap p with a lambda, which is not going to
;; work because callers want to pass a,b,c directly.
(define (glob a b c)
  (define (p d)
    (list a b c d))
  (p 4))
(assert:equal "internal defs for global funcs"
        (glob 1 2 3)
       '(1 2 3 4))

;; Global shadowing issue
;; Do not allow global define to shadow local ones
(define x 'global)
((lambda ()
  (define x 1)
  ((lambda ()
    (define x 2)
    (assert:equal "local define of x" x 2)))
  (assert:equal "another local define of x" x 1)))
(assert:equal "global define of x" x 'global)

; TODO: could add parser tests for these
;(
;123(list)
;1'b
;(write
;  (list
;  1;2
;  ))
;1;2
;3"four five"
;#\space
;)

;; EVAL section
(define x 1)
(define y 2)
(define *z* 3)
;(write (eval '(Cyc-global-vars)))
(assert:equal "eval compiled - x" (eval 'x) x)
(eval '(set! x 'mutated-x))
(assert:equal "Access var with a mangled name" (eval '*z*) *z*)
(assert:equal "Access compile var mutated by eval" x 'mutated-x)
;; END eval

; TODO: use display, output without surrounding quotes
(write (list *num-passed* " tests passed with no errors"))
;;
