#lang racket/base

(require plot
         "utils.rkt"
         "structs.rkt")

(provide plot-month
         plot-lifetime
         pie-chart-preference
         data->stats
         yank-all-run-data
         print-text-stats
         make-graph

         (struct-out stats)
         )


(struct stats (sum avg cnt regression))


(define (plot-month) 0)
(define (plot-lifetime) 0)
(define (pie-chart-preference) 0)


(define (yank-all-run-data data)
  (define (inner data acc)
    (if (empty? data)
        acc
        (inner (cdr data) (append acc (month-datum (car data))))))
  (inner data '()))
  


; Returns a stats struct based on the running data received
(define (data->stats data)
  (define runs (yank-all-run-data data))
  (define distances (map run-dist runs))
  (define-values (a len) (avg-and-len (map run-dist runs)))
  (define summation (sum distances))
  (stats summation a len 0.0)) 

   
  


; A bare-bones print-stats function
(define (print-text-stats data)
  (define the-stats (data->stats data))
  (displayln (format "Total number of runs: ~a" (stats-cnt the-stats)))
  (displayln (format "Total distance ran: ~a" (stats-sum the-stats)))
  (displayln (format "Average distance ran: ~a" (stats-avg the-stats)))
  (displayln (format "Regression: ~a (not impl)" (stats-regression the-stats))))




(define (make-graph data fpath)
  (define the-stats (data->stats data))
  (define runs (yank-all-run-data data))
  (define distances (map run-dist runs))
  (define pairs (enumerate distances))


  
  (displayln "Creating graph")

  (define graph (lines pairs))
  (plot-file graph fpath 'png))

; end
