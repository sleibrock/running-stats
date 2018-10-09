#lang racket/base

(require plot/no-gui
         "utils.rkt"
         "structs.rkt")

(provide data->stats
         yank-all-run-data
         print-text-stats
         make-line-graph
         make-monthly-graph
         make-scatter-graph
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


(define GRAPH-WIDTH  400)
(define GRAPH-HEIGHT 400)


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


(define (make-line-graph stat-data fpath)
  (displayln "Creating line graph...")
  ;(plot-font-family 'system)
  ;(plot-x-ticks no-ticks)

  ; enumerate my run distances with numbers for plotting
  (define pairs (enumerate (stats-distance-list stat-data)))
  (define graph (lines pairs))
  (plot-file graph
             fpath
             'png
             #:width GRAPH-WIDTH
             #:height GRAPH-HEIGHT
             #:title   "Steven's Running Stats"
             #:x-label "days"
             #:y-label "distance (miles)"))



; use discrete-histogram to form a monthly distance graph
(define (make-monthly-graph raw-data fpath)
  (displayln "Creating monthly graph...")

  ; TODO: much later
  ; we might only want the last ~6 months or so
  ; ie: if we have 12 months, take the 6 most recent months
  ; our data is stored from low to high in month order
  ; so reverse list -> take 6 -> reverse that -> graph it
  ; or drop (length - 6) from the list and graph it
  (define graph
    (discrete-histogram
     (map (λ (m)
            (vector (month-name m)
                    (sum (map run-dist (month-datum m)))))
          raw-data)
     #:color 2
     #:line-color 2))
  (plot-file graph
             fpath
             'png
             #:width GRAPH-WIDTH
             #:height GRAPH-HEIGHT
             #:title      "Monthly Total Distance Ran"
             #:x-label    "months"
             #:y-label    "distance (miles)"))


(define (make-scatter-graph raw-data fpath)
  (displayln "Creating scatterplot graph...")

  (define runs (yank-all-run-data raw-data))
  (define pairs
    (map (λ (r)
           (vector (run-dur r) (run-dist r)))
         runs))

  (define graph (points pairs
                        #:color 3))

  (plot-file graph
             fpath
             'png
             #:width    GRAPH-WIDTH
             #:height   GRAPH-HEIGHT
             #:title    "Time vs. Distance"
             #:x-label  "Time (seconds)"
             #:y-label  "Distance (miles)"))


; end
