#!perl

use strict;
use warnings;
use Test::More;
use Path::Tiny;
use JSON::MaybeXS;

my $tw = path('t/test_wiki');
my $rc = system($^X, 'cmds/doku', $tw, 'build');

ok(!$rc, "doku ran without errors ($rc)");

my $db = decode_json(path('build')->child('db.json')->slurp_raw);
ok($db, 'loaded db properly');


done_testing();