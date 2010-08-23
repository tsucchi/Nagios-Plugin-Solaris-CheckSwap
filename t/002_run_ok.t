#!/usr/bin/perl
use strict;
use warnings;
use Test::Mock::ExternalCommand;
use t::util;
use Nagios::Plugin::Solaris::CheckSwap;

use Test::More;
$ARGV[0]="-c10%";
$ARGV[1]="-w20%";

my $m = Test::Mock::ExternalCommand->new();
my $swap_l_output = <<EOM;
swapfile             dev  swaplo blocks   free
/dev/dsk/c1t0d0s1   61,65      8       50       10
/swapfile             -        8       50       50
EOM

$m->set_command('swap', $swap_l_output);

my $r = Nagios::Plugin::Solaris::CheckSwap->new( swap => 'swap' );
is($r->_swap_total, 100);
is($r->_swap_used, 40);

eval {
    $r->run();
};
is($@, "check_swap OK - usage 40%\n");

done_testing();
