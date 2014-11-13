;; The meta-circular evaluator from SICP 4.1
;; http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-26.html#%_sec_4.1
;;

(define (eval exp env)
  ((analyze exp) env))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (equal? (car exp) tag)
      #f))

(define (self-evaluating? exp)
  (cond ((number? exp) #t)
        ;((string? exp) true)
        (else #f)))

(define (quoted? exp)
  (tagged-list? exp 'quote))

;; Improvement from section 4.1.7 - Separate syntactic analysis from execution
(define (analyze exp)
  (cond ((self-evaluating? exp) 
         (analyze-self-evaluating exp))
         ((quoted? exp) (analyze-quoted exp))
        ;((variable? exp) (analyze-variable exp))
        ;((assignment? exp) (analyze-assignment exp))
        ;((definition? exp) (analyze-definition exp))
        ;((if? exp) (analyze-if exp))
        ;((lambda? exp) (analyze-lambda exp))
        ;((begin? exp) (analyze-sequence (begin-actions exp)))
        ;((cond? exp) (analyze (cond->if exp)))
        ;((application? exp) (analyze-application exp))
        (else
        ; (error "Unknown expression type -- ANALYZE" exp))))
         (lambda () 'TODO-unknown-exp-type)))) ; JAE - this is a debug line

(define (analyze-self-evaluating exp)
  (lambda (env) exp))

(define (analyze-quoted exp)
  (let ((qval (cadr exp)))
    (lambda (env) qval)))

;; JAE - Testing
(write (eval 2 #f))
(write (eval '''(1 2) #f))
(write (eval '''(1 . 2) #f))