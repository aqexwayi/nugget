;; Cyclone Scheme
;; Copyright (c) 2014, Justin Ethier
;; All rights reserved.
;;
;; This module contains a front-end for the compiler itself.
;;

(cond-expand
 (chicken
   (require-extension extras) ;; pretty-print
   (require-extension chicken-syntax) ;; when
))
;(load "bootstrap-chicken.scm")
;(load "bootstrap-husk.scm")
(load "parser.scm")
(load "trans.scm")
(load "cgen.scm")

;; Code emission.
  
; c-compile-and-emit : (string -> A) exp -> void
(define (c-compile-and-emit input-program)
  (call/cc 
    (lambda (return)
      (define globals '())
      (emit *c-file-header-comment*) ; Guarantee placement at top of C file
    
      (trace:info "---------------- input program:")
      (trace:info input-program) ;pretty-print
      
      (set! input-program (add-libs input-program))
    
      (set! input-program (expand input-program))
      (trace:info "---------------- after macro expansion:")
      (trace:info input-program) ;pretty-print
    
      (set! input-program 
        (filter-unused-variables
          (isolate-globals input-program)))
      (trace:info "---------------- after processing globals")
      (trace:info input-program) ;pretty-print
    
      ; Note alpha-conversion is overloaded to convert internal defines to 
      ; set!'s below, since all remaining phases operate on set!, not define.
      ;
      ; TODO: consider moving some of this alpha-conv logic below back into trans?
      (set! globals (global-vars input-program))
      (set! input-program 
        (map
          (lambda (expr)
            (alpha-convert expr globals return))
          input-program))
      (trace:info "---------------- after alpha conversion:")
      (trace:info input-program) ;pretty-print
    
      (set! input-program 
        (map 
          (lambda (expr)
            (cps-convert expr))
          input-program))
      (trace:info "---------------- after CPS:")
      (trace:info input-program) ;pretty-print
    
      (set! input-program
        (map
          (lambda (expr)
            (clear-mutables)
            (analyze-mutable-variables expr)
            (wrap-mutables expr globals))
          input-program))
      (trace:info "---------------- after wrap-mutables:")
      (trace:info input-program) ;pretty-print
    
      (set! input-program 
        (map
          (lambda (expr)
            (if (define? expr)
              ;; Global
             `(define ,(define->var expr)
                ,@(caddr (closure-convert (define->exp expr) globals)))
              (caddr ;; Strip off superfluous lambda
                (closure-convert expr globals))))
          input-program))
    ;    (caddr ;; Strip off superfluous lambda
    ;      (closure-convert input-program)))
      (trace:info "---------------- after closure-convert:")
      (trace:info input-program) ;pretty-print
      
      (if (not *do-code-gen*)
        (begin
          (trace:error "DEBUG, existing program")
          (exit)))
    
      (trace:info "---------------- C code:")
      (mta:code-gen input-program globals)
      (return '())))) ;; No codes to return

;; TODO: longer-term, will be used to find where cyclone's data is installed
(define (get-data-path)
  ".")

(define (get-lib filename)
  (string-append (get-data-path) "/" filename))

(define (read-file filename)
  (call-with-input-file filename
    (lambda (port)
      (read-all port))))

;; Compile and emit:
(define (run-compiler args cc?)
  (let* ((in-file (car args))
         (in-prog (read-file in-file))
         (exec-file (basename in-file))
         (src-file (string-append exec-file ".c"))
         (create-c-file 
           (lambda (program) 
             (with-output-to-file 
               src-file
               (lambda ()
                 (c-compile-and-emit program)))))
         (result (create-c-file in-prog)))
    ;; Load other modules if necessary
    (cond
     ((not (null? result))
      (let ((program
              (append
                (if (member 'eval result) 
                    (read-file (get-lib "eval.scm")) 
                   '())
                (if (member 'read result) 
                    (append
                        (read-file (get-lib "parser.scm"))
                       '((define read cyc-read)))
                   '())
                in-prog)))
        (create-c-file program))))

    ;; Compile the generated C file
    (if cc?
      (system 
        ;; -I is a hack, real answer is to use 'make install' to place .h file
        (string-append "gcc " src-file " -I. -g -o " exec-file)))))

;; Handle command line arguments
(let ((args (command-line-arguments))) ;; TODO: port (command-line-arguments) to husk??
  (cond
    ((< (length args) 1)
     (display "cyclone: no input file")
     (newline))
    ((member "-h" args)
     (display "TODO: display help text")
     (newline))
    ((member "-v" args)
     (display *version-banner*))
    ((member "-d" args)
     (run-compiler args #f)) ;; Debug, do not run GCC
    (else
      (run-compiler args #t))))

