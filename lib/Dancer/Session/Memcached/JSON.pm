use strict;
use warnings;
package Dancer::Session::Memcached::JSON;

# VERSION
# ABSTRACT: Session store in memcached with JSON serialization

use base 'Dancer::Session::Abstract';

use JSON;
use Cache::Memcached;
use Function::Parameters qw(:strict);
use Storable qw(dclone);
use Data::Structure::Util qw(unbless);
use Dancer::Config qw(setting);

use Dancer::Session::Memcached::JSON::Signature qw(sign unsign);

my $MEMCACHED;
my $secret;

sub init {
    my ($class) = @_;
    my @servers = split ',', (setting('memcached_servers') // '');

    $class->SUPER::init;
    $secret = setting('memcached_secret');

    if(!@servers or grep { not $_ =~ /^\d+\.\d+\.\d+\.\d+:\d+$/ } @servers) {
        die "Invalid value for memcached_servers. Should be a comma " .
                "separated list of the form `server:port'";
    }

    $MEMCACHED = Cache::Memcached->new(servers => \@servers);
}

method TO_JSON {
    return unbless(dclone($self));
}

fun create(Str $class) {
    my $self = $class->new;

    $self->{id} = sign($self->id, $secret)
        if $secret;

    $MEMCACHED->set($self->id => to_json($self, {
        allow_blessed   => 1,
        convert_blessed => 1,
    }));

    return $self;
}

fun retrieve(Str $class, Str|Int $id) {
    my $id = $secret
        ? unsign($self->id, $secret)
        : $self->id;

    my $val = $MEMCACHED->get($id);

    $val
        ? bless(from_json($val), $class)
        : create($class);
}

method destroy() {
    my $id = $secret
        ? unsign($self->id, $secret)
        : $self->id;

    $MEMCACHED->delete($id);
}

method flush() {
    my $id = $secret
        ? unsign($self->id, $secret)
        : $self->id;

    $MEMCACHED->set($id => to_json($self, {
        allow_blessed   => 1,
        convert_blessed => 1,
    }));

    return $self;
}

1;

__END__;

=head1 NAME

Dancer::Session::Memcached::JSON

=head1 SYNOPSIS

  session: "Memcached::JSON"
  memcached_servers: "127.0.0.1:11211,10.0.0.5:11211"

=head1 DESCRIPTION

This module implements a session store on top of Memcached. All data is
converted to JSON before being sent to Memcached, which prevents invocations of
C<Storable::nfreeze>. This common format allows the data to be shared among web
applications written in different languages.

If C<memcached_secret> is specified, all generated session IDs will be of the
form C<id.base64_mac>. This is to maintain compatibility with the session store
mechanism that L<Express|http://expressjs.com/> uses.
