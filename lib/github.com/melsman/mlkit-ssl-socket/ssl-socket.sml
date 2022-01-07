
structure SSLSocket :> SSL_SOCKET = struct

  (* error utilities *)

  fun getCtx () : foreignptr = prim("__get_ctx",())

  fun failure s =
      let fun errno () : int = prim("sml_errno",())
          fun errmsg (i : int) : string = prim("sml_errormsg", i)
      in raise OS.SysErr (s ^ ": " ^ errmsg(errno()), NONE)
      end

  fun maybe_failure s i =
      if i < 0 then failure s
      else ()

  fun maybe_failuref s (i:foreignptr) =
      if (prim("id",i):int) < 0 then failure s
      else i

  (* an active inet stream socket with ssl layer *)

  type inet = INetSock.inet
  type sock_addr = INetSock.sock_addr
  type active = Socket.active
  type 'm stream_sock = 'm INetSock.stream_sock

  type ctx = foreignptr
  type con = foreignptr

  type t = ctx * con * active stream_sock

  fun socketToInt s =
      let fun fdToInt (x:OS.IO.iodesc) : int = prim("id", x)
      in fdToInt (Socket.ioDesc s)
      end

  fun ssl_init () : ctx =
      let val ctx = prim("sml_ssl_init", ())
      in maybe_failuref "SSLSocket.ssl_init" ctx
      end

  fun ssl_ctx_free (ctx:ctx) : ctx =
      prim("sml_ssl_ctx_free", ctx)

  fun ssl_conn (ctx:ctx, fd:int) : con =
      let val con = prim("sml_ssl_conn", (ctx,fd))
      in maybe_failuref "SSLSocket.ssl_conn" con
      end

  fun mkAndConnect (saddr:sock_addr) : t =
      let val ctx = ssl_init()
          val s = INetSock.TCP.socket()
      in ( Socket.connect (s, saddr)
         ; (ctx, ssl_conn (ctx, socketToInt s), s)
         )
         handle X => ( ssl_ctx_free ctx
                     ; Socket.close s
                     ; raise X
                     )
      end

  fun sendVec ((_,con,_):t, slc: Word8VectorSlice.slice) : int =
      let val (v,i,n) = Word8VectorSlice.base slc
          val ret = prim("sml_ssl_sendvec", (con,v,i,n))
      in maybe_failure "SSLSocket.sendVec" ret
       ; ret
      end

  fun recvVec ((_,con,_):t, n:int) : Word8Vector.vector =
      if n < 0 orelse n > Word8Vector.maxLen then raise Size
      else prim("sml_ssl_recvvec",(getCtx(),con,n))
           handle Overflow => failure "SSLSocket.recvVec"

  fun close ((ctx,con,sock):t) : unit =
      ( prim ("sml_ssl_close", con) : unit
      ; ssl_ctx_free ctx
      ; Socket.close sock
      )

end
