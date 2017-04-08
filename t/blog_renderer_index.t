use Test::More;
use FindBin;
use Path::Tiny 'path';
use Cpanel::JSON::XS;

use lib "$FindBin::Bin/../lib";
use Blog::Renderer::Index;

my $base_path = $FindBin::Bin;
my $index = Blog::Renderer::Index->load_index(
  $base_path . '/fixtures/sample_index.json'
);

my @sorted_index = Blog::Renderer::Index->sort_index($index);

is $sorted_index[0]->{slug}, "ketiga";
is $sorted_index[1]->{slug}, "pertama";
is $sorted_index[2]->{slug}, "kedua";

Blog::Renderer::Index->add_to_index({
    title      => 'title',
    created_at => '10/11/1212, 13:14',
    slug       => 'ketiga'
}, \@sorted_index);

is scalar(@sorted_index), 3;

Blog::Renderer::Index->write_json_index('/tmp/test_json_index.json', \@sorted_index);
my $tested_index = decode_json path('/tmp/test_json_index.json')->slurp_utf8;

is $tested_index->[0]->{slug}, "ketiga";
is $tested_index->[1]->{slug}, "pertama";
is $tested_index->[2]->{slug}, "kedua";

path('/tmp/test_json_index.json')->remove;

done_testing;
