BIN=racket
MAIN=running.rkt

GIT=git

text:
	$(BIN) $(MAIN) text

pages:
	$(BIN) $(MAIN) build_pages

push:
	$(GIT) push origin master
	$(GIT) push gitlab master

