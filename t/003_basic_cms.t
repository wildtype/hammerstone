use Mojo::Base -strict;

use Test::Mojo;
use Test::More;

use FindBin '$Bin';
use Mojo::File;
my $t = Test::Mojo->new(Mojo::File->new("$Bin/../cms/cms"));

$t->get_ok('/')
  ->text_is('html head title' => 'Dashboard: Index')
  ->text_is('h1' => 'Published Posts');

$t->get_ok('/posts')
  ->status_is(200)
  ->json_has('/posts/0')
  ->json_like('/posts/0/title', qr/2019: Dari Birdwatching/)
  ->json_is('/posts/0/slug', '2019')
  ->json_is('/posts/0/created_at', '2019-12-31T23:51:04+07:00');

$t->get_ok('/posts/2019')
  ->status_is(200)
  ->json_like('/title', qr/2019: Dari Birdwatching/)
  ->json_like('/content', qr/Meskipun akhir pekan banyak mengamat burung/)
  ->json_like('/excerpt', qr/Postingan wajib/);

done_testing();
