package  POE::Filter::Hessian;

use Moose;
use Hessian::Translator;

has 'version' => ( is => 'ro', isa => 'Int', default => 1 );
has 'translator' => (
    is      => 'ro',
    isa     => 'Hessian::Translator',
    lazy    => 1,
    default => sub {
        my $self    = shift;
        my $version = $self->version();
        return Hessian::Translator->new( version => $version );
      }

);


sub clone {    #{{{
    my $self = shift;
}    #}}}

sub get_one_start {    #{{{
    my ( $self, $arg ) = @_;
}    #}}}

sub get_one {    #{{{
    my $self = shift;
}    #}}}

sub get {    #{{{
    my ( $self, $arg ) = @_;
}    #}}}

sub put {    #{{{
    my ( $self, $arg ) = @_;
}    #}}}

sub get_pending {    #{{{
    my $self = shift;
}    #}}}

"one, but we're not the same";

__END__


=head1 NAME

POE::Filter::Hessian - Translate datastructures to and from Hessian for
transmission Wheel::ReadWrite

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE


