use strict;
use Test;
use Test::Differences;

BEGIN { plan test => 18 };

use Mojo::File 'path';
use Mojo::UserAgent;

my $ua = Mojo::UserAgent->new;

oldstyle_diff;
eq_or_diff($ua->get('https://prehistoric.me/rmvcamu/')->result->body, path('site/public/rmvcamu/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/tdd-jasmine-intro/')->result->body, path('site/public/tdd-jasmine-intro/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/archive/')->result->body, path('site/public/archive/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/vim-save-with-sudo/')->result->body, path('site/public/vim-save-with-sudo/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/mengacak-blogroll/')->result->body, path('site/public/mengacak-blogroll/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/motret/')->result->body, path('site/public/motret/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/blogroll/')->result->body, path('site/public/blogroll/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/mesin-baru/')->result->body, path('site/public/mesin-baru/index.html')->slurp);
# eq_or_diff($ua->get('https://prehistoric.me/gsheet2json/')->result->body, path('site/public/gsheet2json/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/hello-bye/')->result->body, path('site/public/hello-bye/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/nspawn/')->result->body, path('site/public/nspawn/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/wh2upd8/')->result->body, path('site/public/wh2upd8/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/2019/')->result->body, path('site/public/2019/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/')->result->body, path('site/public/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/py-dl/')->result->body, path('site/public/py-dl/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/upgr8-ram/')->result->body, path('site/public/upgr8-ram/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/freebsd-gcp/')->result->body, path('site/public/freebsd-gcp/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/about/')->result->body, path('site/public/about/index.html')->slurp);
eq_or_diff($ua->get('https://prehistoric.me/mewarnai/')->result->body, path('site/public/mewarnai/index.html')->slurp);
#eq_or_diff($ua->get('https://prehistoric.me/feed/index.xml')->result->body, path('site/public/feed/index.xml')->slurp);