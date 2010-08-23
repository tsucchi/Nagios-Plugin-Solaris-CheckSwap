use inc::Module::Install;
name           'Nagios-Plugin-Solaris-CheckSwap';
author         'Takuya Tsuchida tsucchi@cpan.org';
license        'perl';
all_from       'lib/Nagios/Plugin/Solaris/CheckSwap.pm';

author_tests   'xt';
author_requires 'Test::Perl::Critic';
author_requires 'Test::Synopsis';
author_requires 'Test::Pod';
author_requires 'Test::Pod::Coverage';
author_requires 'Test::Module::Used' => '0.1.4';
author_requires 'Test::Script';

test_requires  'Test::More'  => '0.88';   # want to use done_testing()
test_requires  'Test::Mock::ExternalCommand';

requires       'Nagios::Plugin';
install_script 'check_swap';
WriteMakefile(
    INSTALLSITESCRIPT        => '/usr/local/nagios/libexec',
);
