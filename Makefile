.PHONY: all
all:
	$(MAKE) -C lib/github.com/melsman/mlkit-ssl-socket all

.PHONY: test
test:
	$(MAKE) -C lib/github.com/melsman/mlkit-ssl-socket test

.PHONY: clean
clean:
	$(MAKE) -C lib/github.com/melsman/mlkit-ssl-socket clean
	rm -rf MLB *~ .*~
