use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Blog::Post;

my $base_path = $FindBin::Bin;

ok(Blog::Post->can('title'));
ok(Blog::Post->can('created_at'));
ok(Blog::Post->can('slug'));
ok(Blog::Post->can('summary'));
ok(Blog::Post->can('body'));

my $subject = Blog::Post->load_from_file(
  $base_path . '/fixtures/sample_file.txt'
);

is $subject->title, 'Title for First Post';
is $subject->created_at, '28 Maret 2017, 11:32';
is $subject->slug, 'tffp';
is $subject->summary, 'this is summary';
is $subject->body, 'this is body';
is $subject->url, 'https://prehistoric.me/tffp';

my $subject = Blog::Post->load_from_file(
  $base_path . '/fixtures/sample_file_without_summary.txt'
);

is $subject->summary, undef;
is $subject->body, 'this is body not summary';

done_testing;
