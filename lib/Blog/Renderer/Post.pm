package Blog::Renderer::Post;
use strict;
use warnings;
use Path::Tiny 'path';
use Template::Semantic;

sub render
{
  my ($self, $blog_post) = @_;
  my $rendered = Template::Semantic->process('src/views/post.html', {
      'title, h2' => $blog_post->title,
      'div.post__timestamp' => $blog_post->created_at,
      'div.post__content' => \$blog_post->body
  });

  my $path = path("public/" . $blog_post->slug);
  $path->mkpath;
  $path->child('index.html')->spew($rendered);
}

1;
