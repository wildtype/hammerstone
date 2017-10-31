package Blog::Post;
use strict;
use warnings;
use Object::Simple -base;
use Path::Tiny;
use Blog::Renderer::Post;
use Blog::Renderer::Index;

has 'title';
has 'created_at';
has 'slug';
has 'summary';
has 'body';
has 'url' => sub { 'https://prehistoric.me/' . shift->slug; };

sub load_from_file
{
  my ($klass, $filename) = @_;
  my $filecontent = path($filename)->slurp_utf8;

  my ($metadata, $summary, $body) = split /\n+\-+\n+/, $filecontent, 3;
  my ($title, $timestamp, $slug) = $klass->_parse_metadata($metadata);

  unless ($body) {
    $body = $summary;
    $summary = undef;
  }

  chomp $summary if $summary;
  chomp $body if $body;

  return $klass->new(
    title      => $title,
    created_at => $timestamp,
    slug       => $slug,
    summary    => $summary,
    body       => $body
  );
}

sub _parse_metadata
{
  my ($self, $metadata) = @_;
  my ($title, $timestamp, $slug) = split /\n+/, $metadata;

  return ($title, $timestamp, $slug);
}

1;
