use strict;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;

use_ok('Plack::App::URLMap::WildcardHost');

my $make_app = sub {
    my $name = shift;
    sub {
        my $env = shift;
        my $body = join "|", $name, $env->{SCRIPT_NAME}, $env->{PATH_INFO};
        return [ 200, [ 'Content-Type' => 'text/plain' ], [ $body ] ];
    };
};

my $app1 = $make_app->("app1");
my $app2 = $make_app->("app2");
my $app3 = $make_app->("app3");
my $app4 = $make_app->("app4");
my $app5 = $make_app->("app5");
my $app6 = $make_app->("app6");
my $app7 = $make_app->("app7");
my $app8 = $make_app->("app8");

my $app = Plack::App::URLMap::WildcardHost->new;
$app->map("/" => $app1);
$app->map("/foo" => $app2);
$app->map("/foobar" => $app3);
$app->map("http://bar.example.com/" => $app4);
$app->map("http://*.bar.example.com/" => $app5);
$app->map("http://*.baz.example.com/" => $app6);
$app->map("http://baz.example.com/" => $app7);
$app->map("http://*.qux.example.com/" => $app8);

test_psgi app => $app, client => sub {
    my $cb = shift;

    my $res ;

    $res = $cb->(GET "http://localhost/");
    is $res->content, 'app1||/';

    $res = $cb->(GET "http://localhost/foo");
    is $res->content, 'app2|/foo|';

    $res = $cb->(GET "http://localhost/foo/bar");
    is $res->content, 'app2|/foo|/bar';

    $res = $cb->(GET "http://localhost/foox");
    is $res->content, 'app1||/foox';

    $res = $cb->(GET "http://localhost/foox/bar");
    is $res->content, 'app1||/foox/bar';

    $res = $cb->(GET "http://localhost/foobar");
    is $res->content, 'app3|/foobar|';

    $res = $cb->(GET "http://localhost/foobar/baz");
    is $res->content, 'app3|/foobar|/baz';

    $res = $cb->(GET "http://localhost/bar/foo");
    is $res->content, 'app1||/bar/foo';

    $res = $cb->(GET "http://bar.example.com/");
    is $res->content, 'app4||/';

    $res = $cb->(GET "http://bar.example.com/foo");
    is $res->content, 'app4||/foo';

    $res = $cb->(GET "http://foo.bar.example.com/");
    is $res->content, 'app5||/';

    $res = $cb->(GET "http://baz.example.com/");
    is $res->content, 'app6||/';

    $res = $cb->(GET "http://bar.baz.example.com/");
    is $res->content, 'app6||/';

    $res = $cb->(GET "http://qux.example.com/");
    is $res->content, 'app8||/';

    $res = $cb->(GET "http://buz.qux.example.com/");
    is $res->content, 'app8||/';

    # Fix a bug where $location eq ''
    $_ = "bar"; /bar/;
    $res = $cb->(GET "http://localhost/");
    is $res->content, 'app1||/';

};

done_testing;
