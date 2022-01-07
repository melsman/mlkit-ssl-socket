(** Signature with functionality for computing over SSL-layered
    internet sockets.
*)

signature SSL_SOCKET = sig

  type t

  val mkAndConnect : INetSock.inet Socket.sock_addr -> t
  val sendVec      : t * Word8VectorSlice.slice -> int
  val recvVec      : t * int -> Word8Vector.vector
  val close        : t -> unit

end

(**

Description:

[type t] represents an ssl-layered active inet stream socket.

[mkAndConnect saddr] creates and initializes an SSL-layered active
stream socket and connects it to the internet socket address saddr. On
success, the function returns the SSL-layered active stream
socket. The function raises SysErr in case of errors.

[sendVec (s,sl)] sends the bytes in the slice slc on the SSL-layered
active stream socket s. It returns the number of bytes actually sent.
The function raises SysErr if sock has been closed.

[recvVec (s,n)] receives up to n bytes from the SSL-layered active
stream socket s.  The size of the resulting vector is the number of
bytes that were successfully received, which may be less than n. If
the connection has been closed at the other end (or if n is 0), then
the empty vector will be returned.  The function raises SysErr if the
socket s has been closed and it raises Size if n < 0 or n >
Word8Vector.maxLen.

[close s] closes the socket SSL-layered socket s.

*)
