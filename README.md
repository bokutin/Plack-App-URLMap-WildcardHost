# NAME

Plack::App::URLMap::WildcardHost - Plack::App::URLMap のワイルドカード対応版です。

# SYNOPSIS

    use Plack::App::URLMap::Wildcard;

    my $app1 = sub { ... };
    my $app2 = sub { ... };
    my $app3 = sub { ... };
    my $app4 = sub { ... };

    my $urlmap = Plack::App::URLMap::WildcardHost->new;
    $urlmap->map("/" => $app1);
    $urlmap->map("/foo" => $app2);
    $urlmap->map("http://bar.example.com/" => $app3);
    $urlmap->map("http://*.bar.example.com/" => $app4);

    my $app = $urlmap->to_app;
