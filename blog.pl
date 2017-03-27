#!/usr/bin/env perl
package Blog;
use strict;
use warnings;
use lib 'lib';
use Blog::Post;

__PACKAGE__->run unless caller;

sub run
{
  my $self = shift;
  my $ref  = $ARGV[0];
  $self->$ref if $ref;
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
