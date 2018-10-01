#lang racket/base

#|
My Running statistics


Mostly everything revolves around a struct `rundatum`
```
(struct rundatum (len where))
```


|#

; import everything needed
(require "private/structs.rkt")



(define DATA
  (list
   (month "oct18" (list
                       (run 0.0 'gym)
                       (run 1.0 'track)
                       (run 2.0 'outside)
                       ))
   (month "nov18" (list
                        (run 0.0 'gym)
                        ))))



(module+ main
  (displayln "Nothing here yet lol"))

; end
