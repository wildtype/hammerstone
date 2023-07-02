use Mojo::Base -strict;

use Test::Mojo;
use Test::More;

use Mojo::File 'curfile';
my $t = Test::Mojo->new(curfile->dirname->sibling('cms'));

$t->get_ok('/')
  ->text_is('html head title' => 'Dashboard')
  ->text_is('h1' => 'Published Posts');

$t->get_ok('/posts')
  ->status_is(200)
  ->json_has('/posts/0')
  ->json_like('/posts/0/title', qr/2019: Dari Birdwatching/);

done_testing();
