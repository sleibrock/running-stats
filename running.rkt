#lang racket/base

#|
My Running statistics


Mostly everything revolves around a struct `rundatum`
```
(struct rundatum (len where))
```


|#

; import everything needed
(require racket/cmdline
         "private/structs.rkt"
         "private/stats.rkt"
         "private/html.rkt"
         )



(define DATA
  (list
   (m "oct18" (list
               (r 0.69   950   "2018-10-01" 'gym)
               (r 0.60   1000  "2018-10-02" 'track)
               ))
;   (m "nov18" (list
;                   (r 0.0 0 "" 'gym)
;                        ))
   ))



(module+ main
  (command-line
   #:program "runstats"
   #:args (command)
   (cond ([string=? command "build_pages"] (build-pages-directory DATA))
         ([string=? command "text"]        (print-text-stats DATA))
         (else (displayln "LOL")))))

; end
