## mlkit-ssl-socket [![CI](https://github.com/melsman/mlkit-ssl-socket/workflows/CI/badge.svg)](https://github.com/melsman/mlkit-ssl-socket/actions)

SSL Socket library for the MLKit Standard ML compiler.

This library provides SSL Socket functionality from within Standard ML
using the `libssl` API.

## Overview of MLB files

- `lib/github.com/melsman/mlkit-ssl-socket/ssl-socket.mlb`:

  - **structure** `SSLSocket` :> [`SSL_SOCKET`](lib/github.com/melsman/mlkit-ssl-socket/ssl-socket.sig)`

## Assumptions

A working [MLKit installation](https://github.com/melsman/mlkit). Use
`brew install mlkit` on macOS or download a binary release from the
[MLKit github site](https://github.com/melsman/mlkit).

### Testing

To test the library, first do as follows:

    $ make
    ...
    $ make test
    ...

Notice that, dependent on the architecture, you may need first to set the
environment variable `MLKIT_INCLUDEDIR` to something different than
the default value `/usr/share/mlkit/include/`.

You may also need to set the environment variables `SSL_INCLUDEDIR`
and `SSL_LIBDIR` to something different from the default values
`/usr/include/ssl` and `/usr/lib/ssl`.

For instance, if you use `brew` under macOS, you should do as follows:

    $ export MLKIT_INCLUDEDIR=/usr/local/share/mlkit/include
    $ export SSL_INCLUDEDIR=/usr/local/opt/openssl/include
    $ export SSL_LIBDIR=/usr/local/opt/openssl/lib
    $ make
    ...
    $ make test
    ...

It may be necessary to tweak the files
[lib/github.com/melsman/mlkit-ssl-sockets/Makefile](lib/github.com/melsman/mlkit-ssl-sockets/Makefile)
and
[lib/github.com/melsman/mlkit-ssl-sockets/test/Makefile](lib/github.com/melsman/mlkit-ssl-sockets/test/Makefile)
to specify the location of the MLKit compiler binary, the MLKit
include files, and the MLKit basis library.

## Use of the package

This library is set up to work well with the SML package manager
[smlpkg](https://github.com/diku-dk/smlpkg).  To use the package, in
the root of your project directory, execute the command:

```
$ smlpkg add github.com/melsman/mlkit-ssl-socket
```

This command will add a _requirement_ (a line) to the `sml.pkg` file
in your project directory (and create the file, if there is no file
`sml.pkg` already).

To download the library into the directory
`lib/github.com/melsman/mlkit-ssl-socket` (along with other necessary
libraries), execute the command:

```
$ smlpkg sync
```

You can now reference the `mlb`-file using relative paths from within
your project's `mlb`-files.

Notice that you can choose either to treat the downloaded package as
part of your own project sources (vendoring) or you can add the
`sml.pkg` file to your project sources and make the `smlpkg sync`
command part of your build process.


## License

This library is licensed under the [MIT license](LICENSE).

Copyright (c) 2022, Martin Elsman.
