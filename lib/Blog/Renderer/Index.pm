package Blog::Renderer::Index;
use strict;
use warnings;
use Path::Tiny 'path';
use Template::Semantic;
use Cpanel::JSON::XS;

sub render
{
  my ($self, $data) = @_;
  my $json_file = path("public/index.json");
  my $json_index = $json_file->slurp_utf8;

  my $index = decode_json $json_index;
  push @{$index}, {
    title => $data->{title},
    timestamp => $data->{timestamp},
    slug => $data->{slug}
  };

  $json_file->spew(encode_json $index);
}

1;
