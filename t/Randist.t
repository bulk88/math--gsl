package Math::GSL::Randist::Test;
use base q{Test::Class};
use Test::Most tests => 6;
use Math::GSL::Test    qw/:all/;
use Math::GSL::RNG     qw/:all/;
use Math::GSL::Errno   qw/:all/;
use Math::GSL::Randist qw/:all/;
use Math::GSL::Const   qw/ $M_PI /;
use Data::Dumper;
BEGIN { gsl_set_error_handler_off() }

use strict;
use warnings;

sub make_fixture : Test(setup) {
    my $self = shift;
    $self->{rng} = Math::GSL::RNG->new;
}

sub teardown : Test(teardown) {
    my $self = shift;
    undef $self->{rng};
}

sub GSL_RAN_PDF : Tests(4) {
    ok_similar(0, gsl_ran_bernoulli_pdf(2, 0.5), 'gsl_ran_bernoulli_pdf(2,0.5)=0' );
    ok_similar( gsl_ran_gaussian_pdf(0,1), 1/sqrt(2*$M_PI), 'gsl_ran_gaussian_pdf' );
    ok_similar( gsl_ran_ugaussian_pdf(0), 1/sqrt(2*$M_PI), 'gsl_ran_ugaussian_pdf' );
    ok_similar( gsl_ran_chisq_pdf(1,2), exp(-1/2)/2, 'gsl_ran_chisq_pdf' );
}

sub GSL_RAN_BASIC : Tests {
    my $self = shift;
    lives_ok( sub{ gsl_ran_lognormal($self->{rng}->raw, 0.1, 0.2 ) },
        'gsl_ran_lognormal works');
}

sub GSL_RAN_DIRICHLET : Tests {
    my $self = shift;
    local $TODO = 'const double alpha [] and double theta [] not correctly supported yet';
    my $alpha = [ 1.0, 2.0 ];
    my $theta = [ 2.0, 3.0 ];

    lives_ok( sub{ gsl_ran_dirichlet($self->{rng}->raw, 3, $alpha , $theta ) }, 'gsl_ran_dirichlet');
}

Test::Class->runtests;
