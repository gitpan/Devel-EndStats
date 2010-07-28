package Devel::EndStats;
BEGIN {
  $Devel::EndStats::VERSION = '0.02';
}
# ABSTRACT: Show various statistics at the end of program run


use 5.010;

sub _inc2modname {
    local $_ = shift;
    s!/!::!g;
    s/\.pm$//;
    $_;
}

sub _mod2incname {
    local $_ = shift;
    s!::!/!g;
    "$_.pm";
}

my @my_modules = qw(
                       Data::Dump
               );

my %excluded_modules;

my %opts = (
    verbose => 0,
    exclude_endstats_modules => 1,
);


sub import {
    my ($class, %args) = @_;
    $opts{verbose} = $ENV{VERBOSE} if defined($ENV{VERBOSE});
    if ($ENV{DEVELENDSTATS_OPTS}) {
        while ($ENV{DEVELENDSTATS_OPTS} =~ /(\w+)=(\S+)/g) {
            $opts{$1} = $2;
        }
    }
    $opts{$_} = $args{$_} for keys %args;
}

INIT {
    for (qw(feature Devel::EndStats)) {
        $excluded_modules{ _mod2incname($_) }++
            if $opts{exclude_endstats_modules};
    }

    # load our modules and exclude it from stats
    for my $m (@my_modules) {
        my $im = _mod2incname($m);
        next if $INC{$im};
        my %INC0 = %INC;
        require $im;
        if ($opts{exclude_endstats_modules}) {
            for (keys %INC) {
                $excluded_modules{$_}++ unless $INC0{$_};
            }
        }
    }
}

END {
    print "# BEGIN stats from Devel::EndStats\n";

    printf "# Program runtime duration (s): %d\n", (time() - $^T);

    my $modules = 0;
    my $lines = 0;
    my %lines;
    local *F;
    for my $im (keys %INC) {
        next if $excluded_modules{$im};
        $modules++;
        open F, $INC{$im} or next;
        while (<F>) { $lines++; $lines{$im}++ }
    }
    printf "# Total number of module files loaded: %d\n", $modules;
    printf "# Total number of modules lines loaded: %d\n", $lines;
    if ($opts{verbose}) {
        for my $im (sort {$lines{$b} <=> $lines{$a}} keys %lines) {
            printf "#   Lines from %s: %d\n", _inc2modname($im), $lines{$im};
        }
    }

    print "# END stats\n";
}


1;

__END__
=pod

=head1 NAME

Devel::EndStats - Show various statistics at the end of program run

=head1 VERSION

version 0.02

=head1 SYNOPSIS

 # from the command line
 % perl -MDevel::EndStats script.pl

=head1 DESCRIPTION

Devel::EndStats runs in the END block, displaying various statistics about your
program, such as: how many seconds the program ran, how many module files and
total number of lines loaded (by inspecting %INC), etc.

Some notes/caveats:

END blocks declared after Devel::EndStats' will be executed after it, so in that
case it's ideal to load Devel::EndStats as the last module.

In modules statistics, Devel::EndStats excludes itself and the modules it uses.
Devel::EndStats tries to check whether those modules are actually loaded/used by
your program instead of just by Devel::EndStats and if so, will not exclude them.

=head1 OPTIONS

Some options are accepted. They can be passed via the B<use> statement:

 # from the command line
 % perl -MDevel::EndStats=verbose,1 script.pl

 # from script
 use Devel::EndStats verbose=>1;

or via the DEVELENDSTATS_OPTS environment variable:

 % DEVELENDSTATS_OPTS='verbose=1' perl -MDevel::EndStats script.pl

=over 4

=item * verbose => BOOL

Can also be set via VERBOSE environment variable. If set to true, display more
statistics (like per-module statistics). Default is 0.

=item * exclude_endstats_modules => BOOL

If set to true, exclude Devel::EndStats itself and the modules it uses from the
statistics. Default is 1.

=back

=head1 FAQ

=head2 What is the purpose of this module?

This module might be useful during development. I first wrote this module when
trying to reduce startup overhead of a command line application, by looking at
how many modules the app has loaded and try to avoid loading modules whenever
it's unnecessary.

=head2 Can you add (so and so) information to the stats?

Sure, if it's useful. As they say, (comments|patches) are welcome.

=head1 SEE ALSO

=head1 AUTHOR

  Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

