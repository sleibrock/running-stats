#lang racket/base

#|

|#

(require "utils.rkt")

(provide run
         month
         (struct-out month-datum)
         (struct-out run-datum))


(struct month-datum  (name datum))
(struct run-datum    (len where))


; month-datum init wrapper
(define (month name run-data)
  (if (not (all? (filter run-datum? run-data)))
      (error (format "Invalid rundata list for ~a" name))
      (month-datum name run-data)))

; run-datum init wrapper
(define (run len where)
  (run-datum len where))


; end
