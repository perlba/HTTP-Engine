package HTTP::Engine::RequestBuilder::CGI;
use Mouse;

with qw(
    HTTP::Engine::Role::RequestBuilder
    HTTP::Engine::Role::RequestBuilder::ParseEnv
    HTTP::Engine::Role::RequestBuilder::HTTPBody
);

__PACKAGE__
