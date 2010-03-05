use inc::Module::Install;
name           'Nagios-Plugin-Solaris-CheckSwap';
author         'Takuya Tsuchida tsucchi@cpan.org';
license        'perl';
all_from       'lib/Nagios/Plugin/Solaris/CheckSwap.pm';

author_tests   'xt';
test_requires  'Test::More'  => '0.88';   # want to use done_testing()
requires       'Nagios::Plugin';
install_script 'check_swap';
WriteMakefile(
    INSTALLSITESCRIPT        => '/usr/local/nagios/libexec',
);
