use Test::More;
use FindBin;
use IPC::Run 'run';

subtest 'command not found' => sub {
  plan tests => 1;

  my ($stdin, $stdout, $stderr);
  run ["$FindBin::Bin/../blog.pl", 'sembarang'], \$stdin, \$stdout, \$stderr;

  chomp $stderr;
  is $stderr, 'invalid command: sembarang';
};

done_testing;
