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
; TODO: add more fields to avoid having to re-calculate data between graphs
; currently have to re-calculate lots of mins/maxes on distance/time
; so maybe add those four fields for convenience in graphing?
(struct stats (total-runs
               total-distance
               avg-distance
               avg-time
               avg-place
               dist-stdev
               dist-variance
               regression
               distance-list
               time-list
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
  (define total-runs (length runs))
  (define distances (map run-dist runs))
  (define times (map run-dur runs))
  (define avg-dist (avg distances))
  (define avg-time (avg times))
  (define summation (sum distances))
  (stats total-runs
         summation
         avg-dist
         avg-time  ; fix time average
         'outside  ; fix place average
         0.0       ; fix stdev and variance
         0.0       ; <- variance is (stdev^2)
         0.0       ; calculate least squares regression
         distances
         '()))     ; append a time list similar to distance list
         

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
  (define distances (stats-distance-list stat-data))
  (define maximum (max distances)) 
  (define pairs (enumerate distances)) 
  (define graph (lines pairs))
  (plot-file graph
             fpath
             'png
             #:width   GRAPH-WIDTH
             #:height  GRAPH-HEIGHT
             #:y-min   0
             #:y-max   (+ maximum 0.5)
             #:title   "Steven's Running Stats"
             #:x-label "days"
             #:y-label "Distance (Miles)"))


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
             #:width      GRAPH-WIDTH
             #:height     GRAPH-HEIGHT
             #:y-min      0
             #:title      "Monthly Total Distance Ran"
             #:x-label    "Months"
             #:y-label    "Distance (Miles)"))


; Use points to create a scatter plot graph of time vs distance
(define (make-scatter-graph raw-data fpath)
  (displayln "Creating scatterplot graph...")

  (define runs      (yank-all-run-data raw-data))
  (define distances (map (λ (r) (run-dist r)) runs))
  (define times     (map (λ (r) (run-dur r)) runs))

  (define min-dist (min distances))
  (define max-dist (max distances))
  (define min-time (min times))
  (define max-time (max times))
  
  (define graph (points (map list times distances)
                        #:size 10
                        #:sym 'diamond
                        #:color 3))

  (plot-file graph
             fpath
             'png
             #:width    GRAPH-WIDTH
             #:height   GRAPH-HEIGHT
             #:x-min    (- min-time 60)
             #:x-max    (+ max-time 60)
             #:y-min    0
             #:y-max    (+ max-dist 0.5)
             #:title    "Time vs. Distance"
             #:x-label  "Time (seconds)"
             #:y-label  "Distance (miles)"))


; end
