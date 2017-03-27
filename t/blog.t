use strict;
use Test::More tests => 2;
require 'blog.pl';

subtest "load_post_content" => sub {
  ok Blog->file_content('fixtures/sample_file.md') eq 'this is sample';
};
