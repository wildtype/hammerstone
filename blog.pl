#!/usr/bin/env perl
package Blog;
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use Blog::Post;
use Blog::Post::Html;
use Blog::Renderer::Index;

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
  my $self   = shift;
  my $source = $ARGV[1];
  my $post   = Blog::Post->load_from_file($source);

  Blog::Post::Html->new(blog_post => $post)
                  ->write_file;

  Blog::Renderer::Index->render($post);
}

sub deploy
{
  print "deploy\n";
}

1;
