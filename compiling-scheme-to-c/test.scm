; TODO: recursion example (try using letrec, then desugar it)
; seems OK without CPS, but broken with it - ???
;; test case, CPS conversion fails: (set! fnc (lambda (i) i))
(letrec ((fnc (lambda (i) 
                (begin
                    (display i)
                    (if i (fnc (- i 1)) 0)))))
    (fnc 10))


;(call/cc
;  (lambda (k) ; call it 'return' and things break... uh oh
;    (begin
;      (display 1)
;      (display 2)
;      (k 2)
;      (display 3)
;      (display 4))))
