package Blog::Renderer::Index;
use strict;
use warnings;
use Path::Tiny 'path';
use Template::Semantic;
use Cpanel::JSON::XS;
use DateTime::Format::Strptime;
use Blog::Post;

sub load_index
{
  my ($self, $filename) = @_;

  my $json_file = path($filename);
  my $json_index = $json_file->slurp_utf8;
  my $index = decode_json $json_index;

  return $index;
}

sub add_to_index
{
  my ($self, $post, $index) = @_;

  push @{$index}, {
    title      => $post->{title},
    created_at => $post->{created_at},
    slug       => $post->{slug}
  } unless grep { $_->{slug} eq $post->{slug} } @{$index};
}

sub sort_index
{
  my ($self, $index) = @_;

  my $datetime_parser = DateTime::Format::Strptime->new(
    pattern   => '%d/%m/%Y, %H:%M',
    locale    => 'id_ID',
    time_zone => 'Asia/Jakarta'
  );

  my $sorter = sub {
    my $first = $datetime_parser->parse_datetime($a->{created_at});
    my $second = $datetime_parser->parse_datetime($b->{created_at});

    return $second->compare($first);
  };

  return sort $sorter @{$index};
}

sub write_json_index
{
  my ($self, $filename, $data) = @_;
  my $json_index_file = path($filename);
  $json_index_file->spew(encode_json $data);
}

sub render_index_item
{
  my ($self, $data) = @_;
  return {
    '.post-index__item-timestamp' => \$data->{created_at},
    '.post-index__item-title'     => {
      'a'      => $data->{title},
      'a@href' => ('/' . $data->{slug})
    }
  };
}

sub render_index
{
  my ($self, $data) = @_;
  my @index_items = map { $self->render_index_item($_); } @{$data};

  my $index_html = Template::Semantic->process('src/views/index.html', {
      '.post-index .post-index__item' => [@index_items]
  });

  path('public/index.html')->spew($index_html);
}

sub render
{
  my ($self, $data) = @_;
  my $index = $self->load_index('public/index.json');
  $self->add_to_index($data, $index);

  my @sorted_index = $self->sort_index($index);
  $self->write_json_index('public/index.json', \@sorted_index);
  $self->render_index(\@sorted_index);
}

1;
