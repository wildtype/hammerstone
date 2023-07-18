use strict;
use warnings;
use Test::More;

use FindBin '$Bin';
use lib "$Bin/../tools";
use Mojo::JSON 'decode_json';
use Mojo::File;

require_ok('from_github_issues.pl');

my $tmp_posts = Mojo::File->tempdir('tempYAYAXXXX');

$FromGithubIssues::BaseDir = $tmp_posts->to_string();

my $json = do { local $/; <DATA> };
my $data = decode_json($json);
my @issues = FromGithubIssues::issues($data);

is $issues[0]->{title}, 'Menulis blog, menulis issues';
is $issues[0]->{slug}, 'issues';

my $f = $tmp_posts->child('issues.yml')->touch;

my $existing_files = FromGithubIssues::existing_files()->map(sub { $_->to_string })->to_array();

is $existing_files->[0], $tmp_posts->child('issues.yml')->to_string();
done_testing();

print $tmp_posts->to_string;

__DATA__
[
  {
    "url": "https://api.github.com/repos/wildtype/hammerstone/issues/13",
    "repository_url": "https://api.github.com/repos/wildtype/hammerstone",
    "labels_url": "https://api.github.com/repos/wildtype/hammerstone/issues/13/labels{/name}",
    "comments_url": "https://api.github.com/repos/wildtype/hammerstone/issues/13/comments",
    "events_url": "https://api.github.com/repos/wildtype/hammerstone/issues/13/events",
    "html_url": "https://github.com/wildtype/hammerstone/issues/13",
    "id": 1330771177,
    "node_id": "I_kwDOBSvd985PUfTp",
    "number": 13,
    "title": "Menulis blog, menulis issues",
    "user": {
      "login": "wildtype",
      "id": 112799,
      "node_id": "MDQ6VXNlcjExMjc5OQ==",
      "avatar_url": "https://avatars.githubusercontent.com/u/112799?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/wildtype",
      "html_url": "https://github.com/wildtype",
      "followers_url": "https://api.github.com/users/wildtype/followers",
      "following_url": "https://api.github.com/users/wildtype/following{/other_user}",
      "gists_url": "https://api.github.com/users/wildtype/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/wildtype/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/wildtype/subscriptions",
      "organizations_url": "https://api.github.com/users/wildtype/orgs",
      "repos_url": "https://api.github.com/users/wildtype/repos",
      "events_url": "https://api.github.com/users/wildtype/events{/privacy}",
      "received_events_url": "https://api.github.com/users/wildtype/received_events",
      "type": "User",
      "site_admin": false
    },
    "labels": [
      {
        "id": 4400611952,
        "node_id": "LA_kwDOBSvd988AAAABBkwCcA",
        "url": "https://api.github.com/repos/wildtype/hammerstone/labels/published",
        "name": "published",
        "color": "8B8442",
        "default": false,
        "description": ""
      },
      {
        "id": 5713905872,
        "node_id": "LA_kwDOBSvd988AAAABVJNI0A",
        "url": "https://api.github.com/repos/wildtype/hammerstone/labels/post",
        "name": "post",
        "color": "0377B4",
        "default": false,
        "description": ""
      }
    ],
    "state": "open",
    "locked": false,
    "assignee": null,
    "assignees": [

    ],
    "milestone": null,
    "comments": 1,
    "created_at": "2022-08-06T14:48:57Z",
    "updated_at": "2023-07-08T20:13:06Z",
    "closed_at": null,
    "author_association": "OWNER",
    "active_lock_reason": null,
    "body": "Sekadar eksperimen saja, saya mencoba memanfaatkan github issue untuk menulis postingan blog ini. Bisa dilihat di history issue ini di github, idenya sudah lama ada, tetapi belum terang benar bagaimana terapannya dari issue menjadi post yang terpublikasi.\r\n\r\n$slug:issues\r\n",
    "reactions": {
      "url": "https://api.github.com/repos/wildtype/hammerstone/issues/13/reactions",
      "total_count": 0,
      "+1": 0,
      "-1": 0,
      "laugh": 0,
      "hooray": 0,
      "confused": 0,
      "heart": 0,
      "rocket": 0,
      "eyes": 0
    },
    "timeline_url": "https://api.github.com/repos/wildtype/hammerstone/issues/13/timeline",
    "performed_via_github_app": null,
    "state_reason": "reopened"
  }
]
