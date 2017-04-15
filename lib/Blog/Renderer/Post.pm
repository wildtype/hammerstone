package Blog::Renderer::Post;
use strict;
use warnings;
use Path::Tiny 'path';
use Template::Semantic;
use HTML::Packer;

sub render
{
  my ($self, $blog_post) = @_;
  my $rendered_uncompressed = Template::Semantic->process('src/views/post.html', {
      'title' => $blog_post->title,
      '.post__title' => $blog_post->title,
      'div.post__timestamp' => $blog_post->created_at,
      'div.post__content' => \$blog_post->body
  })->as_string;

  my $packer = HTML::Packer->init();
  my $rendered = $packer->minify(\$rendered_uncompressed, {
      remove_newlines => 1,
      remove_comments => 1
  });

  my $path = path("../public/" . $blog_post->slug);
  $path->mkpath;
  $path->child('index.html')->spew_utf8($rendered);
}

1;
