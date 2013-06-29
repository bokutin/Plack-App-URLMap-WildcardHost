
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Plack::Builder \343\201\256\343\203\233\343\202\271\343\203\210\343\203\236\343\203\203\343\203\201\343\201\247\343\203\257\343\202\244\343\203\253\343\203\211\343\202\253\343\203\274\343\203\211\345\257\276\345\277\234\343\201\253",
  "AUTHOR" => "Tomohiro Hosaka <bokutin\@bokut.in>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Plack-App-URLMap-WildcardHost",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Plack::App::URLMap::WildcardHost",
  "PREREQ_PM" => {
    "Plack::App::URLMap" => 0
  },
  "TEST_REQUIRES" => {
    "HTTP::Request::Common" => 0
  },
  "VERSION" => "0.131800",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



