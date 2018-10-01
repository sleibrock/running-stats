#lang racket/base


; provide (publicize) functions written here
(provide any?
         all?)


; equivalent to any/all from python
; ```
; (any? '())      => false
; (any? '(#t))    => true
; (any? '(#f))    => false
; (any? '(#t #f)) => true
; ```
(define (any? datum)
  (if (eq? '() datum)
      #f
      (if (eq? #t (car datum))
          #t
          (any? (cdr datum)))))


; ```
; (all? '())        => true
; (all? '(#f #f))   => false
; (all? '(#t #t))   => true
; (all? '(#t #f))   => false
; ```
(define (all? datum)
  (foldl (lambda (a b) (and a b)) #t datum))



; end
