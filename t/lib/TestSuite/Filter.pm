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
    my @methods = qw/new clone get_one_start get_one get_pending get put /;
    can_ok( $filter, @methods );
    $self->{filter} = $filter;
}    #}}}

sub t007_hessian_simple_buffer_read {    #{{{
    my $self             = shift;
    my $hessian_elements = [
        "Vt\x00\x04[intl\x00\x00\x00\x02\x90\x91z",
        "\x4dt\x00\x08SomeType\x05color\x0aaquamarine"
          . "\x05model\x06Beetle\x07mileageI\x00\x01\x00\x00z",
        "Mt\x00\x0aLinkedListS\x00"
          . "\x04headI\x00\x00\x00\x01S\x00\x04tailR\x00\x00\x00\x04z",
    ];
    my $filter = $self->{filter};
    $filter->get_one_start($hessian_elements);
}    #}}}

"one, but we're not the same";

__END__


=head1 NAME

TestSuite::Filter - Base class for testing POE::Filter::Hessian

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE


