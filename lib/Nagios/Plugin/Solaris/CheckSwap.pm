package Nagios::Plugin::Solaris::CheckSwap;
use strict;
use warnings;
use Nagios::Plugin;

our $VERSION = "0.01";
use 5.008;

=head1 NAME

Nagios::Plugin::Solaris::CheckSwap - Nagios plugin for checking swap usage

=head1 SYNOPSIS

  use strict;
  use warnings;
  use Nagios::Plugin::Solaris::CheckSwap;
  my $c = Nagios::Plugin::Solaris::CheckSwap->new();
  $c->run();

=head1 DESCRIPTION

Nagios plugin for checking swap usage. this module is intended to used for NRPE agent.

=cut

=head1 methods

=cut

=head2 new

=cut

sub new {
    my $class = shift;
    my (%option) = @_;
    my $self = {
        np => Nagios::Plugin->new(
            shortname => 'check_swap',
            usage => "Usage: %s [ -v|--verbose ]  [-H <host>] [-t <timeout>]"
                   . "[ -c|--critical=<threshold>% ] [ -w|--warning=<threshold>% ]",
        ),
        swap  => $option{swap} || '/usr/sbin/swap',
    };
    bless $self, $class;

    $self->{np}->add_arg(
        spec => 'warning|w=s',
        help => '-w, --warning=INTEGER%',
        required => 1,
    );
    $self->{np}->add_arg(
        spec => 'critical|c=s',
        help => '-c, --critical=INTEGER%',
        required => 1,
    );

    $self->{np}->getopts;
    return $self;
}

=head2 run

start checking raid status

=cut

sub run {
    my $self = shift;

    my $percent_usage = $self->_swap_used() / $self->_swap_total() * 100;
    my $rest = 100 - $percent_usage;

    (my $warning  = $self->{np}->opts->warning) =~ s/%$//;
    (my $critical = $self->{np}->opts->critical) =~ s/%$//;
    if ( $warning < $critical ) {
        $self->{np}->nagios_exit(UNKNOWN, "critical threshold is largar than warning");
    }
    elsif ( $rest <= $critical ) {
        $self->{np}->nagios_exit(CRITICAL, sprintf("usage %d%%", $percent_usage));
    }
    elsif ( $rest <= $warning ) {
        $self->{np}->nagios_exit(WARNING, sprintf("usage %d%%", $percent_usage));
    }
    $self->{np}->nagios_exit(OK, sprintf("usage %d%%", $percent_usage));
}

# return swap total blocks
sub _swap_total {
    my $self = shift;
    return $self->_parse_swap(3);
}

# return used swap in blocks
sub _swap_used {
    my $self = shift;
    return $self->_swap_total() - $self->_swap_remain();
}

sub _swap_remain {
    my $self = shift;
    return $self->_parse_swap(4);
}

sub _parse_swap {
    my $self = shift;
    my ($index) = @_;
    my $swap_l = $self->_exec_swap_l();
    my @lines = split(/\n/, $swap_l);
    shift @lines; #ignore header
    my $total = 0;
    for my $line ( @lines ) {
        $total += (split(/\s+/, $line))[$index];
    }

    return $total;
}

# execute swap -l
sub _exec_swap_l {
    my $self = shift;
    if ( !defined $self->{swap_result} ) {
        my $swap = $self->{swap};
        $self->{np}->nagios_exit(UNKNOWN, 'swap command not found') if ( !defined $swap || !-x $swap );
        my $result = `$swap -l`;
        $self->{swap_result} = $result;
    }
    return $self->{swap_result};
}

1;
__END__

=head1 AUTHOR

Takuya Tsuchida E<lt>tsucchi@cpan.orgE<gt>

=head1 SEE ALSO

script/check_swap : script bundled with this module

=head1 REPOSITORY

L<http://github.com/tsucchi/Nagios-Plugin-Solaris-CheckSwap>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2010 Takuya Tsuchida

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
