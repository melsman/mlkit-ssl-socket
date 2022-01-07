
infix |>
fun x |> f = f x

fun sendVecAll (sock, slc) =
    let val i = SSLSocket.sendVec (sock, slc)
        val len = Word8VectorSlice.length slc
    in if i < len then
         sendVecAll (sock, Word8VectorSlice.subslice(slc, i, NONE))
       else ()
    end

fun fetchRaw {host:string, port:int, msg:string} : string option =
    case NetHostDB.getByName host of
        NONE => NONE
      | SOME e =>
        let val addr = INetSock.toAddr (NetHostDB.addr e, port)
            val bufsz = 2048
            val sock = SSLSocket.mkAndConnect addr
            fun loop acc =
                let val v = SSLSocket.recvVec(sock, bufsz)
                    val l = Word8Vector.length v
                in if l = 0
                   then rev acc
                            |> Word8Vector.concat
                            |> Byte.bytesToString
                   else loop (v::acc)
                end
          in ( sendVecAll (sock, Byte.stringToBytes msg
                                 |> Word8VectorSlice.full )
             ; SOME (loop nil) before SSLSocket.close sock
             ) handle _ => ( SSLSocket.close sock; NONE )
          end

val msg = "GET / HTTP/1.0\r\nHost: futhark-lang.org\r\n\r\n"

val s =
    (case fetchRaw {host="futhark-lang.org", port=443,
                    msg=msg} of
         SOME s => s
       | NONE => "nope")
    handle e => "EXN(" ^ General.exnMessage e ^ ")"

fun take (n,suf) s =
    if size s <= n then s
    else String.extract (s,0,SOME n) ^ suf

val () =
    if String.isPrefix "HTTP/1.0 200 OK" s then
      if String.isSubstring "DIKU" s
         andalso String.isSubstring "Futhark" s
      then print "OK\n"
      else print "ERR: Missing 'DIKU' and 'Futhark' in response\n"
    else print ("ERR: Wrong response; got:\n" ^
                take (30,"...") s ^ "\n")
