#lang racket/base

(require xml
         "stats.rkt"
         )


(provide build-pages-directory)

(define COPY-DIRECTORY (string->path "html"))
(define HTML-DIRECTORY (string->path "public"))
(define INDEX-FILE     (string->path "index.html"))
(define MAIN-GRAPH     "main_graph.png")
(define STYLE-SHEET    "style.css")
(define EXTRA-JS       "extra.js")



; Templating parameters to adjust later
(define TOTAL-RUNS     (make-parameter "0"))
(define TOTAL-DISTANCE (make-parameter "0"))
(define AVG-DISTANCE   (make-parameter "0"))
(define AVG-TIME       (make-parameter "0"))
(define AVG-PLACE      (make-parameter "0"))
(define STDEV          (make-parameter "0"))
(define VARIANCE       (make-parameter "0"))
(define REGRESSION     (make-parameter "0"))




(define INTRO "
Hi, I started running recently and to help me keep track 
and try to keep working on it, I wrote a program in Racket to 
help me keep track of my stats and present them in visual form. 
Below are my stats where each mark represents a different \"run\",
and the height is how many miles I ran.
")


(define TECHNICAL "
Every time I run I record it into a new struct, and keep track of 
how many miles were ran, how long it took, where it took place,
which day, and so on and so forth. Sometimes I might break up my
runs into run-walk alternations but I will do my best to keep track
of how many miles were \"ran\".
")



; Create a template function that will return an xexpr tree when called
; This is so we can call parameters *later* as opposed to now
; Which will be useful when we template out certain bits of data
(define TEMPLATE
  (λ ()
    `(html
      (head
       (title "Steven's Running Stats")
       (link ((rel "stylesheet") (type "text/css") (href ,STYLE-SHEET)))
       (script ((type "text/javascript") (src ,EXTRA-JS))))
      (body
       (article 
        (h1 "Steven's Running Stats")
        (p ((class "paragraph")) ,INTRO)
        
        (center
         (img ((class "graph") (src ,MAIN-GRAPH))))
         
        (hr)
        (h2 "Technical")
        (p ,TECHNICAL)

        (hr)
        (h2 "Table of Data")
        (table
         (tr (th "Name")           (th "Value"))
         (tr (td "# Runs")         (th ,(TOTAL-RUNS)))
         (tr (td "Total Distance") (th ,(TOTAL-DISTANCE)))
         (tr (td "Avg Distance")   (th ,(AVG-DISTANCE)))
         )
        
       )
       (footer
        (p "Steven Leibrock 2018 | "
           (a ((href "https://github.com/sleibrock/running-stats")) "github")
           " | "
           (a ((href "https://gitlab.com/sleibrock/running-stats")) "gitlab")))))))
  

(define (create-index-page)
  (parameterize
      ([current-output-port (open-output-file
                             (build-path HTML-DIRECTORY INDEX-FILE)
                             #:exists 'truncate)])
    (display-xml/content (xexpr->xml (TEMPLATE)))))


(define (copy-files-from-src)
  (define files (directory-list COPY-DIRECTORY))
  (for-each (λ (f)
              (define copy-path (build-path COPY-DIRECTORY f))
              (define target-path (build-path HTML-DIRECTORY f))
              (displayln (format "Copying ~a ..." (path->string copy-path)))
              (unless (file-exists? target-path)
                (copy-file copy-path target-path)))
            files)
  (displayln "Copied all files from /html to /public"))



; execute this from the main program
(define (build-pages-directory data)

  (define graph-path (build-path HTML-DIRECTORY MAIN-GRAPH))
  
  (unless (directory-exists? HTML-DIRECTORY)
    (make-directory HTML-DIRECTORY))

  (copy-files-from-src)           ; copy the template flies
  (create-index-page)             ; generate the index.html
  (make-graph data graph-path)    ; create the graph file
  (displayln "lol"))


(module+ main
  (build-pages-directory '()))


; end

