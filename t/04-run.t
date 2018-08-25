use strict;
use warnings;

use FindBin '$Bin';

use Test::More;
use App::Aphra;

chdir("$Bin/data");

@ARGV = ('build');

my $outfile = 'docs/index.html';
my $outfile2 = 'docs/static.txt';

for ($outfile, $outfile2) {
  unlink $_ if -r $_;
}

App::Aphra->new->run;

ok(-e $outfile, 'Got an output file');
ok(-f $outfile, "... and it's a real file");

open my $out_fh, '<', $outfile or die $!;
my $contents = do { local $/; <$out_fh> };
my $exp_contents = qq[<h1 id="test">Test</h1>\n];

ok($contents, 'Got some contents');
is($contents, $exp_contents, 'Got the correct contents');

ok(-e $outfile2, 'Got another output file');
ok(-f $outfile2, "... and it's a real file");

open my $out2_fh, '<', $outfile2 or die $!;
my $contents2 = do { local $/; <$out2_fh> };
my $exp_contents2 = qq<[% static text %]\n>;

ok($contents2, 'Got some contents');
is($contents2, $exp_contents2, 'Got the correct contents');

for ($outfile, $outfile2) {
  unlink $_ if -r $_;
}

done_testing;
