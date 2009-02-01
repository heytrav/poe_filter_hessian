package  TestSuite::Filter;

use strict;
use warnings;
use base 'Test::Class';

use Test::More;
use Test::Deep;

use POE::Filter::Hessian;

sub t005_create_filter : Test(2) {    #{{{
    my $self       = shift;
    my $filter     = POE::Filter::Hessian->new( version => 1 );
    my $translator = $filter->translator();
    isa_ok( $translator, 'Hessian::Translator',
        'Object received from translator accessor' );
    can_ok($translator, qw/clone/);
}    #}}}

"one, but we're not the same";

__END__


=head1 NAME

TestSuite::Filter - Base class for testing POE::Filter::Hessian

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE


