#lang racket/base

(require plot/no-gui
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

; A struct used to name and simplify access
; to a handful of different data attributes
(struct stats (total-runs
               total-distance
               avg-distance
               avg-time
               avg-place
               dist-stdev
               dist-variance
               regression
               distance-list
               ))


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
  (stats len 
         summation
         a
         0.0       ; fix time average
         'outside  ; fix place average
         0.0       ; fix stdev and variance
         0.0       ; <- variance is (stdev^2)
         0.0       ; calculate least squares regression
         distances))
         

; A bare-bones print-stats function
(define (print-text-stats data)
  (define the-stats (data->stats data))
  (displayln (format "Total number of runs: ~a" (stats-total-runs the-stats)))
  (displayln (format "Total distance ran: ~a" (stats-total-distance the-stats)))
  (displayln (format "Average distance ran: ~a" (stats-avg-distance the-stats)))
  (displayln (format "Regression: ~a (not impl)" (stats-regression the-stats))))


(define (make-graph stat-data fpath)
  (displayln "Creating graph")
  (plot-font-family 'system)
  (plot-title "My Running Data")

  ; pass the param a tickset to use
  (date-ticks-format #:formats '("~Y-~m-~d ~H:~M:~f"))
  (plot-x-ticks (date-ticks))

  ; enumerate my run distances with numbers for plotting
  (define pairs (enumerate (stats-distance-list stat-data)))
  (define graph (lines pairs))
  (plot-file graph
             fpath
             'png
             #:x-label "day"
             #:y-label "distance (mi)"))

; end
