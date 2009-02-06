package  TestSuite::Filter::V1;

use strict;
use warnings;
use base 'TestSuite::Filter';

use YAML;
use Test::More;
use Test::Deep;

use POE::Filter::Hessian;

sub prep001_set_version : Test(startup) {    #{{{
    my $self = shift;
    $self->{version} = 1;
}    #}}}

sub t007_hessian_simple_buffer_read : Test(5) {    #{{{
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
    my $some_chunk = $filter->get_one();
    cmp_deeply( $some_chunk->[0], [ 0, 1 ],
        "First chunk taken out of filter." );
    my $second_chunk = $filter->get_one();
    isa_ok( $second_chunk->[0], 'SomeType',
        'Data structure returned by deserializer' );
    is( $second_chunk->[0]->{model},
        'Beetle', 'Model attribute has correct value.' );
    like( $second_chunk->[0]->{mileage},
        qr/\d+/, 'Mileage attribute is an integer.' );

    my $third_chunk = $filter->get_one()->[0];
    isa_ok( $third_chunk, 'LinkedList', "Object parsed by deserializer" );
    $self->{dataset1}     = [ $some_chunk, $second_chunk];
    $self->{hessian_sets} = $hessian_elements;

}    #}}}

sub t009_hessian_filter_get : Test(3) {    #{{{
    my $self             = shift;
    my $hessian_elements = [
        "MI\x00\x00\x00\x01S\x00\x03fee"
          . "I\x00\x00\x00\x10S\x00\x03fieI\x00\x00\x01\x00S\x00\x03foez",
        "O\x9bexample.Car\x92\x05color\x05model",
        "o\x90\x05green\x05civic",
        "Vt\x00\x04[intl\x00\x00\x00\x02\x90\x91z",
        "\x4dt\x00\x08SomeType\x05color\x0aaquamarine"
          . "\x05model\x06Beetle\x07mileageI\x00\x01\x00\x00z",
        "Mt\x00\x0aLinkedListS\x00"
          . "\x04headI\x00\x00\x00\x01S\x00\x04tailR\x00\x00\x00\x04z",
    ];

    my $processed_chunks = $self->{filter}->get($hessian_elements);
    cmp_deeply(
        $processed_chunks->[0],
        { 1 => 'fee', 16 => 'fie', 256 => 'foe' },
        "Received expected datastructure."
    );

    my $object = $processed_chunks->[2];

    is( $object->color(), 'green', 'Correctly accessed object color' );
    is( $object->model(), 'civic', 'Correclty accessed object model' );
}    #}}}

sub t011_put_hessian_data : Test(2) {    #{{{
    my $self              = shift;
    my $dataset           = $self->{dataset1};
    my $hessian_elements  = $self->{hessian_sets};
    my $filter            = $self->{filter};
    my $processed_hessian = $filter->put($dataset);
    print "Processed ".Dump($dataset)."\ninto\n".Dump($processed_hessian)."\n";
    isa_ok( $processed_hessian, 'ARRAY', "Received expected datastructure." );
   my $first_element = $processed_hessian->[0];
   my $first_hessian = $hessian_elements->[0];
   is($first_element,
   $first_hessian,
   "Received expected hessian.");
}    #}}}

"one, but we're not the same";

__END__


=head1 NAME

TestSuite::Filter - Base class for testing POE::Filter::Hessian

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE


