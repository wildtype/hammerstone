#!/usr/bin/env perl
package Blog;
use strict;
use warnings;
use Path::Tiny 'path';
use Template::Semantic;

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
  my $raw_content = path($source)->slurp_utf8;
  my $parsed = $self->parse($raw_content);
  my $output  = $self->render($parsed);

  my $path = path("public/$parsed->{slug}");
  $path->mkpath;
  $path->child('index.html')->spew($output);
}

sub render
{
  my ($self, $content) = @_;
  my $rendered = Template::Semantic->process('src/views/post.html', {
      'title, h2' => $content->{title},
      'div.post__timestamp' => $content->{timestamp},
      'div.post__content' => \$content->{body}
  });

  return $rendered;
}

sub parse
{
  my ($self, $raw) = @_;
  my ($meta, $summary, $raw_body) = split("\n+\-+\n+", $raw, 3);
  my ($title, $timestamp, $slug)  = split "\n", $meta;
  $raw_body = $summary unless $raw_body;

  return {
    title     => $title,
    timestamp => $timestamp,
    slug      => $slug,
    body      => $raw_body
  };
}

sub deploy
{
  print "deploy\n";
}

1;
