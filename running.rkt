#lang racket/base

#|
My Running statistics

Record all your data in here underneath the DATA var
|#

; import everything needed
(require racket/cmdline
         "private/structs.rkt"
         "private/stats.rkt"
         "private/html.rkt"
         )

; In case you want to import the data elsewhere, expose it
(provide DATA)


; All running data goes here
(define DATA
  (list
   (m "oct18" (list
               (r 0.69    950  "2018-10-01" 'gym)
               (r 0.60   1000  "2018-10-02" 'track)
               (r 0.30    700  "2018-10-03" 'outside)
               (r 1.30   1500  "2018-10-04" 'gym)
               (r 1.10   1200  "2018-10-05" 'gym)
               (r 1.77   1900  "2018-10-07" 'mixed)
               ))
;   (m "nov18" (list
;                   (r 0.0 0 "" 'gym)
;                        ))
   ))


; Add a few basic entrypoint actions for the command line
; Will be used to build the web pages for Gitlab
(module+ main
  (command-line
   #:program "runstats"
   #:args (command)
   (cond ([string=? command "build_pages"] (build-pages-directory DATA))
         ([string=? command "text"]        (print-text-stats DATA))
         (else (displayln "LOL")))))

; end
