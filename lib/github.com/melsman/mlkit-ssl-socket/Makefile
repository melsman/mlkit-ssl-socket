OPT := -Wall -std=gnu99 -g -O2
CFLAGS = -DTAG_VALUES -DTAG_FREE_PAIRS -DENABLE_GC $(OPT)

MLKIT_INCLUDEDIR ?= /usr/share/mlkit/include/
SSL_INCLUDEDIR ?= /usr/include/ssl
#SSL_INCLUDEDIR ?= /usr/local/opt/openssl/include

SSL_LIBDIR ?= /usr/lib/ssl

MLKIT ?= mlkit

SRCFILES = $(shell ls -1 *.sml *.sig)

.PHONY: lib
lib: libsmlssl.a

.PHONY: all
all: lib ssl-socket.exe

libsmlssl.a: libsmlssl.c Makefile
	gcc $(CFLAGS) -c -I $(MLKIT_INCLUDEDIR) -I $(SSL_INCLUDEDIR) -o $@ $<

ssl-socket.exe: ssl-socket.mlb $(SRCFILES) libsmlssl.a
	$(MLKIT) -o $@ -libdirs ".,$(SSL_LIBDIR)" -libs "smlssl,ssl,m" $<

.PHONY: test
test:
	$(MAKE) -C test test

.PHONY: clean
clean:
	rm -rf a.out *~ *.o *.a *.exe MLB
	$(MAKE) -C test clean
