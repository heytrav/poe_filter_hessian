package  TestSuite::Filter::V2;

use strict;
use warnings;
use base 'TestSuite::Filter';

use YAML;
use Test::More;
use Test::Deep;

use POE::Filter::Hessian;

sub prep001_set_version : Test(startup) {    #{{{
    my $self = shift;
    $self->{version} = 2;
}    #}}}

sub t007_hessian_simple_buffer_read : Test(4) {    #{{{
    my $self             = shift;
    my $hessian_elements = [
        "Vt\x00\x04[int\x90\x91\xd7\xff\xffz",
        
    "Mt\x00\x08SomeType"
    ."\x05color\x0aaquamarine"
      . "\x05model\x06Beetle\x07mileageI\x00\x01\x00\x00z",
    ];
    my $filter = $self->{filter};
    $filter->get_one_start($hessian_elements);
    my $some_chunk = $filter->get_one()->[0];
    cmp_deeply(
        $some_chunk,
        [ 0, 1, 262143 ],
        "Array [ 0, 1, 262143 ] taken out of filter."
    );
    my $second_chunk = $filter->get_one()->[0];
    isa_ok( $second_chunk, 'SomeType',
        'Data structure returned by deserializer' );
    is( $second_chunk->{model}, 'Beetle',
        'Model attribute has correct value.' );
    like( $second_chunk->{mileage},
        qr/\d+/, 'Mileage attribute is an integer.' );

    $self->{dataset1} = [ $some_chunk, $second_chunk, ];
    $self->{hessian_sets} = $hessian_elements;

}    #}}}

sub t009_hessian_filter_get : Test(3) {    #{{{
    my $self             = shift;
    my $filter           = POE::Filter::Hessian->new( version => 2 );
    my $first_hash = { 1 => 'hello', word => 'Beetle' };

    my $hessian_data = "Ot\x00\x0bexample.Car\x92\x05color\x05model";


    my $hessian_elements = [
        "M\x91\x05hello\x04word\x06Beetlez",
        "Ot\x00\x0bexample.Car\x92\x05color\x05model",
        "o\x90\x03RED\x06ferari"
    ];

    my $processed_chunks = $filter->get($hessian_elements);

    cmp_deeply(
        $processed_chunks->[0],
        { 1 => 'hello', word => 'Beetle' },
        "Received expected datastructure."
    );

    my $object = $processed_chunks->[2];
    is( $object->color(), 'RED', 'Correctly accessed object color' );
    is( $object->model(), 'ferari', 'Correclty accessed object model' );
}    #}}}

sub t011_put_hessian_data : Test(2) {    #{{{
    my $self             = shift;
    my $filter           = POE::Filter::Hessian->new( version => 2 );
    my $dataset          = $self->{dataset1};
    my $hessian_elements = $self->{hessian_sets};

    my $processed_hessian = $filter->put($dataset);
    isa_ok( $processed_hessian, 'ARRAY', "Received expected datastructure." );
    my $reverse_processed = $filter->get($processed_hessian);
    cmp_deeply( $dataset, $reverse_processed,
        "Received same datastructure we put in.." );
}    #}}}

"one, but we're not the same";

__END__


=head1 NAME

TestSuite::Filter - Base class for testing POE::Filter::Hessian

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE


