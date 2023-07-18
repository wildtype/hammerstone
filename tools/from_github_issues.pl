#!/usr/bin/env perl
package FromGithubIssues;
use strict;
use warnings;

use Mojo::UserAgent;
use Mojo::JSON 'decode_json';
use Data::Dumper;

use FindBin '$Bin';

our $BaseDir;

$BaseDir = "$Bin/../site/posts/";

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

sub as_post {
  my $issue = shift;
  my @slug_matches = ($issue->{body}) =~ /\$slug:(\w+)\s*$/;

  $issue->{slug} = $slug_matches[0];

  return $issue;
}

sub issues {
  my $data = shift;
  my @issues = map { as_post($_) }
              grep { issue_is_post($_) }
               map { as_issue($_) } @{$data};

  return @issues;
}

sub from_github {
  my $ua = Mojo::UserAgent->new;
  my $data = decode_json $ua->get(
    'https://api.github.com/repos/wildtype/hammerstone/issues'
  )->result->body;

  return $data;
}

sub existing_files {
  my $dir = Mojo::File->new($BaseDir);

  return $dir->list();
}

sub main {
  my @issues = issues from_github;

  print Dumper @issues;
  print $issues[0]->{body};
}

__PACKAGE__->main() unless caller();
1;
