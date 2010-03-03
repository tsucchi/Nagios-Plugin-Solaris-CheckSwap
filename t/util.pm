package t::util;

BEGIN {
    no warnings 'redefine';

    use Nagios::Plugin::Functions;
    package Nagios::Plugin::Functions;
    sub _nagios_exit {
        my ($code, $output) = @_;
        CORE::die $output;
    }
}

1;
