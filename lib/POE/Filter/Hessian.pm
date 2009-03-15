package  POE::Filter::Hessian;

use Moose;
use Hessian::Translator;
use Hessian::Exception;

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

);                       #}}}

has 'internal_buffer' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub {
        [];
    }
);

sub get_one_start {      #{{{
    my ( $self, $array ) = @_;
    my $internal_buffer = $self->internal_buffer();
    push @{$internal_buffer}, @{$array};
}    #}}}

sub get_one {    #{{{
    my $self            = shift;
    my $translator      = $self->translator();
    my $internal_buffer = $self->internal_buffer();
    my $element         = shift @{$internal_buffer};
    return unless $element;
    $translator->append_input_buffer($element);

    my $result;
    eval { $result = $translator->process_message(); };
    if ( my $e = $@ ) {
        my $exception = ref $e;
        if ($exception) {
            return if Exception::Class->caught('MessageIncomplete::X');
            $e->rethrow();
        }
    }
    return [$result];

}    #}}}

sub get {    #{{{
    my ( $self, $array ) = @_;
    $self->get_one_start($array);
    my $result = [];
    while ( my $processed_chunk = $self->get_one() ) {
        push @{$result}, @{$processed_chunk};
    }
    return $result;
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
