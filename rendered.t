use strict;
use Test;
use Test::Differences;

BEGIN { plan test => 18 };

use Mojo::File 'path';
use Mojo::UserAgent;

my $ua = Mojo::UserAgent->new;
my @slugs = qw(
  rmvcamu tdd-jasmine-intro archive vim-save-with-sudo
  mengacak-blogroll motret blogroll mesin-baru hello-bye
  nspawn wh2upd8 2019 py-dl upgr8-ram freebsd-gcp about mewarnai
);


oldstyle_diff;

eq_or_diff(
  $ua->get('https://prehistoric.me/')->result->body,
  path('site/public/index.html')->slurp
);

eq_or_diff(
  $ua->get("https://prehistoric.me/$_/")->result->body,
  path("site/public/$_/index.html")->slurp
) for (@slugs);