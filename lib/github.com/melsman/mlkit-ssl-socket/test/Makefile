ifeq ($(shell uname),Darwin)
SSL_INCLUDEDIR ?= /usr/local/opt/openssl/include
SSL_LIBDIR ?= /usr/local/opt/openssl/lib/
else
SSL_INCLUDEDIR ?= /usr/include/openssl
SSL_LIBDIR ?= /usr/lib/openssl
endif

OPT:=-Wall -std=gnu99 -g -O2
CFLAGS=-DTAG_VALUES -DTAG_FREE_PAIRS -DENABLE_GC $(OPT) -I $(SSL_INCLUDEDIR)

MLKIT ?= mlkit

.PHONY: all
all: test

.PHONY: test
test: testssl.res
	cat $^

testssl.exe: testssl.mlb testssl.sml
	$(MAKE) -C .. lib
	$(MLKIT) -o $@ -libdirs "..,$(SSL_LIBDIR)" -libs "smlssl,ssl,m" $<

%.out: %.exe
	./$< > $@

%.res: %.out
	@(diff -aq $< $<.ok > /dev/null 2>&1; \
         if [ $$? -eq 0 ]; then \
             echo "OK:  $*" > $@ \
         ; else \
             if [ -e $<.ok ]; then \
                echo "ERR: $* - file $< differs from $<.ok"; \
                echo "ERR: $* - file $< differs from $<.ok" > $@ \
             ; else \
                echo "ERR: $* - file $<.ok does not exist"; \
                echo "ERR: $* - file $<.ok does not exist" > $@ \
             ; fi \
             ; exit 1 \
         ;fi)

.PHONY: clean
clean:
	rm -rf a.out *~ *.o *.a *.exe MLB a.out.dSYM *.res *.out
