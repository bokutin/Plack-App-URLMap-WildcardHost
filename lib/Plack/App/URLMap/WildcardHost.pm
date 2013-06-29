package Plack::App::URLMap::WildcardHost;
# ABSTRACT: Plack::Builder のホストマッチでワイルドカード対応に

use strict;
use Plack::App::URLMap;

{
    my $source = do { open(my $fh, '<', $INC{'Plack/App/URLMap.pm'}) or die $!; local $/; <$fh> };

    my @pairs = (
        [
            '($_->[0] ? length $_->[0] : 0)',
            '(defined($_->[0]) && $_->[0]=~m/^(?:\*\.)?(.+)$/ ? length $1 : 0)',
        ],
        [
            'next unless not defined $host     or',
            'next unless not defined $host or $host =~ /^\*\.(.*)$/ ? $http_host =~ /(?:^|\.)\Q$1\E$/ || $server_name =~ /(?:^|\.)\Q$1\E$/ : 0 or',
        ],
    );

    $source =~ s/^package .*//;
    $source =~ s/\Q$_->[0]\E/$_->[1]/mg or die $_->[0] for @pairs;

    eval $source or die $@;
}

__END__

=pod

=encoding utf-8

=head1 NAME

Plack::App::URLMap::WildcardHost - Plack::App::URLMap のワイルドカード対応版です。

=head1 SYNOPSIS

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

=cut

1;
