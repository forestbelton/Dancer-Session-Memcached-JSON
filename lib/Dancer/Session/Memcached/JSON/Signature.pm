use strict;
use warnings;
package Dancer::Session::Memcached::JSON::Signature;

# Adapted from https://github.com/visionmedia/node-cookie-signature

use Digest::SHA qw(hmac_sha256_base64 sha1_hex);
use Function::Parameters qw(:strict);

use Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(sign unsign);

fun sign(Str $val, Str $secret) {
    my $mac = hmac_sha256_base64($val, $secret);
    $mac =~ s/\=+$//;

    return "s:$val.$mac";
}

fun unsign(Str $val, Str $secret) {
    $val =~ s/^s://;

    my ($str, $id) = split /\./, $val;
    my $mac = sign($str, $secret);

    return $str
        if sha1_hex($mac) eq sha1_hex("s:$val");
}

1;
