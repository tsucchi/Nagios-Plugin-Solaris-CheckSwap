#!/usr/bin/perl
use strict;
use warnings;

use t::util;
BEGIN {
    no warnings 'redefine';
    use Nagios::Plugin::Solaris::CheckSwap;
    package Nagios::Plugin::Solaris::CheckSwap;
    sub _exec_swap_l {
        my $self = shift;
        return <<EOM;
swapfile             dev  swaplo blocks   free
/dev/dsk/c1t0d0s1   61,65      8       50        0
/swapfile             -        8       50        9
EOM
    }
}

use Test::More;
$ARGV[0]="-c10%";
$ARGV[1]="-w20%";

my $r = Nagios::Plugin::Solaris::CheckSwap->new();
is($r->_swap_total, 100);
is($r->_swap_used, 91);

eval {
    $r->run();
};
is($@, "check_swap CRITICAL - usage 91%\n");

done_testing();
