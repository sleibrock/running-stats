#lang racket/base


#|
All utility functions go here

This file can not import any other local source files to make it unique
and portable across all other source files
|#

; provide (publicize) functions written here

(provide any?
         all?
         empty?
         sum
         avg
         avg-and-len
         enumerate
         max
         min
         take
         drop
         round-to
         )


; equivalent to any/all from python
; ```
; (any? '())      => false
; (any? '(#t))    => true
; (any? '(#f))    => false
; (any? '(#t #f)) => true
; ```
; early exits when one item is #t
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
  (foldl (λ (a b) (and a b)) #t datum))


; empty? is part of racket/list, we can redefine it here
(define (empty? lst)
  (equal? '() lst))


; sum adds up all elements in a list (if they are all numerical)
(define (sum lst)
  (foldl + 0 lst))


; Same code as above but yields two values with define-values
; Returns (values average len)
(define (avg-and-len lst)
  (define (inner lst acc cnt)
    (if (empty? lst)
        (if (= 0 cnt)
            (values 0 0)
            (values (/ acc cnt) cnt))
        (inner (cdr lst) (+ acc (car lst)) (+ cnt 1))))
  (inner lst 0.0 0))


; Simply throws away the length value from avg-and-len
(define (avg lst)
  (define-values (a len) (avg-and-len lst))
  (values a))


; Enumerate a list with index numbers (python equivalent)
(define (enumerate lst)
  (define (inner lst acc cnt)
    (if (empty? lst)
        acc
        (inner (cdr lst) (append acc `((,cnt ,(car lst)))) (+ cnt 1))))
  (inner lst '() 1))


; Take and Drop functions for Racket (no racket/list import)
(define (take n lst)
  (define (inner n lst acc)
    (if (or (empty? lst) (= n 0))
        acc
        (inner (sub1 n) (cdr lst) (append acc `(,(car lst))))))
  (inner n lst '()))


(define (drop n lst)
  (if (or (empty? lst) (= n 0))
      lst
      (drop (sub1 n) (cdr lst))))


; Higher-order function for generating max/min functions
(define (list-comp op)
  (λ (lst)
    (if (empty? lst)
        0
        (foldr op (car lst) (cdr lst)))))

(define max (list-comp (λ (a b) (if (< a b) b a))))
(define min (list-comp (λ (a b) (if (< a b) a b))))



; Used to round numbers to a certain place
(define (round-to n-digits num)
  (if (not (and (number? n-digits) (number? num)))
      (error "Invalid arguments given to round-to")

      (let ((v (expt 10 n-digits)))
        (/ (truncate (* num v)) v))))


; end
