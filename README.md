# NAME

Dancer::Session::Memcached::JSON - Session store in memcached with JSON serialization

# VERSION

version 0.001

# SYNOPSIS

    session: "Memcached::JSON"
    memcached_servers: "127.0.0.1:11211,10.0.0.5:11211"

# DESCRIPTION

This module implements a session store on top of Memcached. All data is
converted to JSON before being sent to Memcached, which prevents invocations of
`Storable::nfreeze`. This common format allows the data to be shared among web
applications written in different languages.

# NAME

Dancer::Session::Memcached::JSON

# AUTHOR

Forest Belton <forest@homolo.gy>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by Forest Belton.

This is free software, licensed under:

    The MIT (X11) License
