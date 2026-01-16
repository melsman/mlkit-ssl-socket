//
// libsmlssl.c
//
// SSL communication over sockets
//

#include <stdio.h>
#include <stdlib.h>
#include <openssl/ssl.h>
#include <openssl/err.h>
#include "String.h"
#include "Tagging.h"
#include "Exception.h"
#include "Runtime.h"

#define sml_debug(x) ;

// Tagging scheme for foreign pointers: We need to tag the values as
// scalars so that the garbage collector won't trace the objects. It
// goes for both the SSL connections and for SSL contexts.

// Initialise the SSL library and create an SSL context
uintptr_t
sml_ssl_init(void)
{
  OPENSSL_init_ssl(0,NULL);
  const SSL_METHOD *method = TLS_client_method();
  SSL_CTX *ctx = SSL_CTX_new(method);
  check_tag_scalar(ctx);
  return (uintptr_t)(tag_scalar(ctx));
}

// Create and return an SSL connection
uintptr_t
sml_ssl_conn (uintptr_t ctx0, long fd) {
  fd = convertIntToC(fd);
  SSL_CTX* ctx = (SSL_CTX *)untag_scalar(ctx0);
  SSL *con = SSL_new(ctx);
  SSL_set_mode(con, SSL_MODE_AUTO_RETRY);
  SSL_set_fd(con, fd);
  long res = SSL_connect(con);
  if ( res < 0 ) {
    return convertIntToML(res);
  }
  check_tag_scalar(con);
  return (uintptr_t)(tag_scalar(con));
}

// Send a vector over an SSL connection
long
sml_ssl_sendvec(uintptr_t con0, String v, size_t i, long n)
{
  SSL* con = (SSL *)untag_scalar(con0);
  i = convertIntToC(i);
  n = convertIntToC(n);
  long res = SSL_write(con, (char*)(&(v->data)) + i, n);
  return convertIntToML(res);
}

// Receive a vector (of max size i) from an SSL connection
String
REG_POLY_FUN_HDR(sml_ssl_recvvec, Region rString, Context mlctx, uintptr_t con0, size_t i)
{
  SSL* con = (SSL *)untag_scalar(con0);
  i = convertIntToC(i);
  char *buf = (char *)malloc(i+1);    // temporary storage
  if (buf == NULL) {
    raise_exn(mlctx,(uintptr_t)&exn_OVERFLOW);
    return NULL;
  }
  int ret = SSL_read(con, buf, i);
  if (ret < 0) {
    free(buf);
    raise_exn(mlctx,(uintptr_t)&exn_OVERFLOW);
    return NULL;
  }
  String s = REG_POLY_CALL(convertBinStringToML, rString, ret, buf);
  free(buf);
  return s;
}

// Close an SSL connection
void
sml_ssl_close (uintptr_t con0)
{
  SSL* con = (SSL *)untag_scalar(con0);
  SSL_shutdown(con);
  SSL_free(con);
}

void
sml_ssl_ctx_free (uintptr_t ctx0)
{
  SSL_CTX* ctx = (SSL_CTX *)untag_scalar(ctx0);
  SSL_CTX_free(ctx);
}
