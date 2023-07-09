#!/usr/bin/env perl
use strict;
use warnings;

use Mojo::UserAgent;
use Mojo::JSON 'decode_json';
use Data::Dumper;

sub as_issue {
    my $from_json = shift;
    my $issue = {};

    my @labels = map { $_->{name} } @{$from_json->{labels}};

    $issue->{title} = $from_json->{title};
    $issue->{author} = $from_json->{user}->{login};
    $issue->{labels} = \@labels;
    $issue->{body} = $from_json->{body};

    return $issue;
}

sub issue_is_post {
  my $issue = shift;

  my $is_by_me = $issue->{author} eq 'wildtype';

  my $labels = join(',',sort(@{$issue->{labels}}));
  my $is_posts_published = $labels eq 'post,published';

  return ($is_by_me && $is_posts_published);
}

my $ua = Mojo::UserAgent->new;
my $json = decode_json $ua->get(
  'https://api.github.com/repos/wildtype/hammerstone/issues'
)->result->body;

my $data = do { local $/; <DATA> };
my $json = decode_json($data);

my @issues  = grep { issue_is_post($_) } map { as_issue($_) } @{$json};

print Dumper @issues;
my $body = @issues[0]->{body};
