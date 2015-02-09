[<img src="https://github.com/justinethier/nugget/raw/master/cyclone/web/cyclone-logo-03-header.png" alt="cyclone-scheme">](http://justinethier.github.com/nugget/cyclone)

Cyclone is an experimental Scheme-to-C compiler that uses the [Cheney on the MTA](http://www.pipeline.com/~hbaker1/CheneyMTA.html) technique to implement full tail recursion, continuations, and generational garbage collection.

Building
------------

Prerequisites:

- make
- gcc
- CHICKEN Scheme

CHICKEN is required to bootstrap the Scheme parts of Cyclone. A long-term goal is for the compiler to be self-hosting.

From the source directory, to build and run the compiler:

    $ make
    ...
    $ ./cyclone
    
To build the interpreter:

    $ make repl
    ...
    $ ./repl

Installation
------------
At the moment there is no support for a separate installation. Just run `cyclone` from the build directory.

Documentation
-------------
Run the `cyclone` command to compile a single Scheme file, and the `repl` command to start the interactive interpreter.

List of [features](FEATURES.md).

TODO: "how it works section", or a link to a document that provides a brief overview. Much of this would also involve tying together references

References
----------

- [CONS Should Not CONS Its Arguments, Part II: Cheney on the M.T.A.](http://www.pipeline.com/~hbaker1/CheneyMTA.html), by Henry Baker
- [CHICKEN Scheme](http://www.call-cc.org/)
- [Chibi Scheme](http://code.google.com/p/chibi-scheme/)
- [Compiling Scheme to C with closure conversion](http://matt.might.net/articles/compiling-scheme-to-c/)
- [Lisp in Small Pieces](http://pagesperso-systeme.lip6.fr/Christian.Queinnec/WWW/LiSP.html), by Christian Queinnec
- [R<sup>5</sup>RS Scheme Specification](http://www.schemers.org/Documents/Standards/R5RS/HTML/)
- [R<sup>7</sup>RS Scheme Specification](http://trac.sacrideo.us/wg/wiki)
- [Structure and Interpretation of Computer Programs](https://mitpress.mit.edu/sicp/full-text/book/book.html), by Harold Abelson and Gerald Jay Sussman with Julie Sussman 
- [The 90 minute Scheme to C compiler](http://churchturing.org/y/90-min-scc.pdf)

License
-------
Copyright (C) 2014 [Justin Ethier](http://github.com/justinethier)

License terms TBD
