#lang racket/base

(require plot
         "structs.rkt")

; toggle plotting in a new window separate from DrRacket
(plot-new-window? #t)


(provide plot-month
         plot-lifetime
         pie-chart-preference
         text-statistics)



(define (plot-month) 0)
(define (plot-lifetime) 0)
(define (pie-chart-preference) 0)


; print out some text-based statistics instead of a graph
(define (text-statistics) 0)

; end
