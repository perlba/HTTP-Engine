package HTTP::Engine::Role::ResponseWriter::Finalize;
use Any::Moose ();
BEGIN {
    if (Any::Moose::is_moose_loaded()) {
        require Moose::Role;
        Moose::Role->import();
    }
    else {
        require Mouse::Role;
        Mouse::Role->import();        
    }
}
use Carp ();

requires qw(write output_body);

my $CRLF = "\015\012";

sub finalize {
    my($self, $req, $res) = @_;
    Carp::croak "argument missing" unless $res;

    $self->write($self->response_line($res) . $CRLF) if $self->can('response_line');
    $self->write($res->headers->as_string($CRLF));
    $self->write($CRLF);

    $self->output_body($res->body);
}

1;
