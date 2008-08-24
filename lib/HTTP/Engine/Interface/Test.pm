package HTTP::Engine::Interface::Test;
use HTTP::Engine::Interface;

use URI::WithBase;
use IO::Scalar;

builder 'NoEnv';

writer {
    attributes => {
        '_response' => {
            is => "rw",
            clearer => "_clear_response",
        },
    },
    methods => {
        finalize => sub {
            my ( $self, $req, $res ) = @_;
            $self->_response($res->as_http_response);
        },
        get_response => sub {
            my $self = shift;
            my $res = $self->_response;
            $self->_clear_response;
            return $res;
        },
        write       => sub { die "dummy" },
        output_body => sub { die "dummy" },
    },
};

sub run {
    my ( $self, $request, %args ) = @_;

    $self->handle_request(
        request_args => {
            uri        => URI::WithBase->new( $request->uri ),
            base       => do {
                my $base = $request->uri->clone;
                $base->path_query('/');
                $base;
            },
            headers    => $request->headers,
            method     => $request->method,
            protocol   => $request->protocol,
            address    => "127.0.0.1",
            port       => "80",
            user       => undef,
            https_info => undef,
            _builder_params => {
                request => $request,
            },
            _connection => {
                input_handle  => IO::Scalar->new( \( $request->content ) ),
            },
        },
        %args,
    );

    $self->response_writer->get_response; # FIXME yuck, should be a ret from handle_request
}

__INTERFACE__

__END__

=encoding utf8

=head1 NAME

HTTP::Engine::Interface::Test - HTTP::Engine Test Interface

=head1 SYNOPSIS

  use Data::Dumper;
  use HTTP::Engine;
  use HTTP::Request;
  my $response = HTTP::Engine->new(
      interface => {
          module => 'Test',
      },
      request_handler => sub {
          my $req = shift;
          HTTP::Engine::Response->new( body => Dumper($req) );
      }
  )->run(HTTP::Request->new( GET => 'http://localhost/'), \%ENV);

=head1 DESCRIPTION

HTTP::Engine::Interface::Test is test engine base class

=head1 AUTHOR

Kazuhiro Osawa E<lt>ko@yappo.ne.jpE<gt>
