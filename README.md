# NAME

Dancer::Session::Memcached::JSON - Session store in memcached with JSON serialization

# VERSION

version 0.004

# SYNOPSIS

    session: "Memcached::JSON"
    memcached_servers: "127.0.0.1:11211,10.0.0.5:11211"

# DESCRIPTION

This module implements a session store on top of Memcached. All data is
converted to JSON before being sent to Memcached, which prevents invocations of
`Storable::nfreeze`. This common format allows the data to be shared among web
applications written in different languages.

If `memcached_secret` is specified, all generated session IDs will be of the
form `id.base64_mac`. This is to maintain compatibility with the session store
mechanism that [Express](http://expressjs.com/) uses.

# NAME

Dancer::Session::Memcached::JSON

# AUTHOR

Forest Belton <forest@homolo.gy>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by Forest Belton.

This is free software, licensed under:

    The MIT (X11) License
