#!/usr/bin/env perl
package Blog;
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use Blog::Post;

__PACKAGE__->run unless caller;

sub run
{
  my $self = shift;
  my $command  = $ARGV[0];
  $self->$command and return if $self->can($command);

  print STDERR "invalid command: $command\n" ;
}

sub publish
{
  my $self = shift;
  my $source  = $ARGV[1];

  Blog::Post->load_from_file($source)
            ->render_all;
}

sub deploy
{
  print "deploy\n";
}

1;
