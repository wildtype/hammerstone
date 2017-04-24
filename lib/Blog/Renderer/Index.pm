package Blog::Renderer::Index;
use strict;
use warnings;
use Path::Tiny 'path';
use Template::Semantic;
use Cpanel::JSON::XS;
use DateTime;
use DateTime::Format::Strptime;
use Blog::Post;
use HTML::Packer;
use XML::Feed;

sub load_index
{
  my ($self, $filename) = @_;
  my $date_format = DateTime::Format::Strptime->new(
    pattern   => '%d/%m/%Y, %H:%M',
    locale    => 'id_ID',
    time_zone => 'Asia/Jakarta'
  );

  my $json_file = path($filename);
  my $json_index = $json_file->slurp_utf8;
  my $index = decode_json $json_index;

  my @index_date_parsed = map {
    my $item = $_;
    $item->{created_at_dt} = $date_format->parse_datetime($item->{created_at});
    $item;
  } @{$index};

  return \@index_date_parsed;
}

sub add_to_index
{
  my ($self, $post, $index) = @_;
  my $date_format = DateTime::Format::Strptime->new(
    pattern   => '%d/%m/%Y, %H:%M',
    locale    => 'id_ID',
    time_zone => 'Asia/Jakarta'
  );


  push @{$index}, {
    title      => $post->{title},
    created_at => $post->{created_at},
    created_at_dt => $date_format->parse_datetime($post->{created_at}),
    slug       => $post->{slug}
  } unless grep { $_->{slug} eq $post->{slug} } @{$index};
}

sub sort_index
{
  my ($self, $index) = @_;

  my $sorter = sub {
    my $first = $a->{created_at_dt};
    my $second = $b->{created_at_dt};

    return $second->compare($first);
  };

  return sort $sorter @{$index};
}

sub write_rss_feed
{
  my ($self, $filename, $data) = @_;
  my $feed = XML::Feed->new('RSS', version => '2.0');

  $feed->title('Prehistoric.Me');
  $feed->tagline('Ya, aku bakal dibaca');
  $feed->base('https://prehistoric.me/');
  $feed->link('https://prehistoric.me/index.xml');
  $feed->self_link('https://prehistoric.me/index.xml');
  $feed->author('Mufti');
  $feed->language('id');
  $feed->generator('hammerstone');
  $feed->modified(DateTime->now);

  foreach my $item (@{$data}) {
    my $entry = XML::Feed::Entry->new;
    $entry->id('https://prehistoric.me/' . $item->{slug});
    $entry->link('https://prehistoric.me/' . $item->{slug});
    $entry->title($item->{title});
    $entry->modified($item->{created_at_dt});
    $entry->issued($item->{created_at_dt});
    $entry->author('dev-null@prehistoric.me (Mufti)');
    $feed->add_entry($entry);
  }

  my $rss_file = path($filename);
  $rss_file->spew($feed->as_xml);
}

sub write_json_index
{
  my ($self, $filename, $data) = @_;

  foreach my $item (@{$data}) {
    delete $item->{created_at_dt};
  }

  my $json_index_file = path($filename);
  $json_index_file->spew(encode_json $data);
}

sub render_index_item
{
  my ($self, $data) = @_;
  return {
    '.post-index__item-timestamp' => \($data->{created_at_dt}->ymd('/')),
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

  my $index_html_uncompressed = Template::Semantic->process('src/views/index.html', {
      '.post-index .post-index__item' => [@index_items]
  })->as_string;

  my $packer = HTML::Packer->init();
  my $index_html = $packer->minify(\$index_html_uncompressed, {
      remove_newlines => 1,
      remove_comments => 1
  });

  path('../public/index.html')->spew_utf8($index_html);
}

sub render
{
  my ($self, $data) = @_;
  my $index = $self->load_index('../public/index.json');
  $self->add_to_index($data, $index);

  my @sorted_index = $self->sort_index($index);
  $self->render_index(\@sorted_index);
  $self->write_rss_feed('../public/index.xml', \@sorted_index);
  $self->write_json_index('../public/index.json', \@sorted_index);
}

1;
