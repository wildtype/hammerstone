use Test::More;
use FindBin;
use Path::Tiny 'path';
use Cpanel::JSON::XS;

use lib "$FindBin::Bin/../lib";
use Blog::Index;

my $base_path = $FindBin::Bin;

my $index = Blog::Index->from_json(
  $base_path . '/fixtures/sample_index.json'
);

ok 1;

done_testing;
