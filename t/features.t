use Test::More;
use FindBin;
use IPC::Run 'run';
use Cwd;
use Path::Tiny;

subtest 'command not found' => sub {
  plan tests => 1;

  my ($stdin, $stdout, $stderr);
  run ["$FindBin::Bin/../blog.pl", 'sembarang'], \$stdin, \$stdout, \$stderr;

  chomp $stderr;
  is $stderr, 'invalid command: sembarang';
};

subtest 'publishing article' => sub {
  plan tests => 9;

  my $original_directory = getcwd;
  chdir 't/fixtures/skeleton/draft';

  my ($stdin, $stdout, $stderr);
  run ["$FindBin::Bin/../blog.pl", 'publish', 'sample_file.txt'], \$stdin, \$stdout, \$stderr;

  chomp $stderr;
  is $stderr, '';

  chdir $original_directory;
  my $post_dir = path('t/fixtures/skeleton/public/fixture_slug');

  my $index_json = path('t/fixtures/skeleton/public/index.json');
  my $index_html = path('t/fixtures/skeleton/public/index.html');
  my $index_xml = path('t/fixtures/skeleton/public/index.xml');

  my $json_content = $index_json->slurp;
  my $xml_content = $index_xml->slurp;
  my $html_content = $index_html->slurp;

  ok ($json_content =~ m/Title for First Post/);
  ok ($xml_content =~ m/Title for First Post/);
  ok ($html_content =~ m/Title for First Post/);

  ok $post_dir->exists;
  ok $post_dir->child('index.html')->exists;

  ok $index_json->exists;
  ok $index_html->exists;
  ok $index_xml->exists;

  # cleanup

  $post_dir->remove_tree;
  $index_html->remove;
  $index_xml->remove;

  # we can't remove index.json, as for now its necessary to start running script
  $index_json->spew_utf8('[]');
};

done_testing;
