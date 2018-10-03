#lang racket/base

#|

|#

(require "utils.rkt")

(provide r
         m
         (struct-out month)
         (struct-out run))


(struct month  (name datum))
(struct run   (dist dur day where))


; month-datum init wrapper
(define (m name run-data)
  (if (not (all? (filter run? run-data)))
      (error (format "Invalid rundata list for ~a" name))
      (month name run-data)))

; run-datum init wrapper
(define (r dist dur day where)
  (if (not (and (number? dist) (number? dur) (string? day) (symbol? where)))
      (error "Run data not given a number and a symbol")
      (run dist dur day where)))


; end
