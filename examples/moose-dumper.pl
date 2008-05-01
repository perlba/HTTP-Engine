use strict;
use warnings;
use lib 'lib';
use Data::Dumper;
use HTTP::Engine;
use HTTP::Engine::Interface::ServerSimple;
use HTTP::Engine::Plugin::DebugScreen;

my $engine = HTTP::Engine::Interface::ServerSimple->new(
    port    => 9999,
    handler => sub {
        my $c        = shift;
        my $req_dump = Dumper( $c->req );
        my $raw      = $c->req->raw_body;
        my $body     = <<"...";
    <form method="post">
        <input type="text" name="foo" />
        <input type="submit" />
    </form>
    <pre>$raw</pre>
    <pre>$req_dump</pre>
...

        $c->res->body($body);
    },
);
$engine->load_plugins(qw/DebugScreen/);
$engine->run;

