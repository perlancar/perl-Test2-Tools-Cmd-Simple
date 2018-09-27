## no critic (Modules::ProhibitAutomaticExportation)

package Test2::Tools::Cmd::Simple;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
use Test2::API qw/context run_subtest/;
use Test2::Tools::ClassicCompare qw/is/;

use Exporter qw(import);
our @EXPORT = qw(test_cmd);

sub test_cmd {
    my %args = @_;

    my $ctx = context();

    my $code = sub {
        system $args{cmd};
        my $has_tests;
        if (exists $args{test_exit_code}) {
            $has_tests++;
            {
                my $name = "command exits with exit code $args{test_exit_code}";
                if ($? == $args{test_exit_code}) {
                    $ctx->ok(1, $name);
                } else {
                    $ctx->ok(0, $name, ["command exits with exit code $?"]);
                }
            }
        }
        $ctx->ok(1, "no tests") unless $has_tests;
    };

    my $pass = run_subtest($args{name}, $code, {buffered=>0});
    $ctx->release;
    $pass;
}

1;
