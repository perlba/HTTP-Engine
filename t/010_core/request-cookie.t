use strict;
use warnings;
use Test::More tests => 7;
use t::Utils;
use HTTP::Engine;
use HTTP::Request;
use CGI::Simple::Cookie;

# exist Cookie header.
do {
    # prepare
    my $req = HTTP::Request->new(
        'GET',
        '/',
        HTTP::Headers::Fast->new(
            'Cookie' => "Foo=Bar; Bar=Baz",
        ),
    );

    # do test
    run_engine {
        my $req = shift;
	use Data::Dumper;
	is '2', $req->cookie;
        is $req->cookie('undef'), undef;
        is $req->cookie('undef', 'undef'), undef;
        is $req->cookie('Foo')->value, 'Bar';
        is $req->cookie('Bar')->value, 'Baz';
        is_deeply $req->cookies, {Foo => 'Foo=Bar; path=/', Bar => 'Bar=Baz; path=/'};
        return ok_response;
    } $req;
};

# no Cookie header
do {
    # prepare
    my $req = HTTP::Request->new(
        'GET',
        '/',
    );

    # do test
    run_engine {
        my $req = shift;
        is_deeply $req->cookies, {};
        return ok_response;
    } $req;
};

