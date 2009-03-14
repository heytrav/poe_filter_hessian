package  POE::Filter::Hessian;

use Moose;
use Hessian::Translator;

with 'MooseX::Clone';

has 'version' => ( is => 'ro', isa => 'Int', default => 1 );

has 'translator' => (    #{{{
    is      => 'ro',
    isa     => 'Hessian::Translator',
    lazy    => 1,
    default => sub {
        my $self    = shift;
        my $version = $self->version();
        my $translator =
          Hessian::Translator->new( chunked => 1, version => $version );
        return $translator;
      }

);    #}}}

has 'internal_buffer' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub {
        [];
      }

);

sub get_one_start {    #{{{
    my ( $self, $array ) = @_;
    push @{ $self->internal_buffer() }, @{$array};
}    #}}}

sub get_one {    #{{{
    my $self       = shift;
    my $translator = $self->translator();
   my $next_element = shift @{ $self->internal_buffer() };
   return unless $next_element;

   $translator->input_string($next_element);
    return [ $translator->deserialize_message() ];
}    #}}}

sub get {    #{{{
    my ( $self, $array ) = @_;
    my $translator = $self->translator();
    my $input_string = join '' => @{$array};
    $translator->input_string($input_string);
    return $translator->process_message();
}    #}}}

sub put {    #{{{
    my ( $self, $array ) = @_;
    my $translator = $self->translator();
    $translator->serializer();
    my @data = map { $translator->serialize_message($_) } @{$array};
    return \@data;

}    #}}}

sub get_pending {    #{{{
    my $self = shift;
}    #}}}

"one, but we're not the same";

__END__


=head1 NAME

POE::Filter::Hessian - Translate datastructures to and from Hessian for
transmission via a POE ReadWrite wheel.

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE

=head2 clone

=head2 get_one_start

=head2 get_one

=head2 get

=head2 put

=head2 get_pending
