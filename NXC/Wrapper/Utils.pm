package NXC::Wrapper::Utils;

use strict;
use warnings;
use Carp qw/croak/;
use YAML qw/LoadFile/;

use parent qw/NXC::Wrapper/;

sub new {
    my ( $class, %opts ) = @_;
    my $self  = {};
    if (!$opts{config}) {
        croak "Config file not specified.";
    }
    $self->{conf} = LoadFile( "$opts{config}" );
    return bless $self, $class;
};

sub FORWARD {
    my $self = shift;

    $self->start_void("forward");
        $self->forward(
            motors => $self->{conf}->{motors}->{AC},
            speed  => $self->{conf}->{speed}->{half}
        );
    $self->end;
    return $self;
};

sub REVERSE {
    my $self = shift;

    $self->start_void("reverse");
        $self->reverse(
            motors => $self->{conf}->{motors}->{AC},
            speed  => $self->{conf}->{speed}->{half}
        );
    $self->end;
    return $self;
};

sub TURN_LEFT {
    my ( $self, $dur ) = @_;

    $self->start_void("turn_left");
        $self->forward(
            motors => $self->{conf}->{motors}->{A},
            speed  => $self->{conf}->{speed}->{half}
        );
        $self->reverse(
            motors => $self->{conf}->{motors}->{C},
            speed  => $self->{conf}->{speed}->{half}
        );
        $self->wait($dur);
    $self->end;
    return $self;
};

sub TURN_RIGHT {
    my ( $self, $dur ) = @_;

    $self->start_void("turn_right");
        $self->reverse(
            motors => $self->{conf}->{motors}->{A},
            speed  => $self->{conf}->{speed}->{half}
        );
        $self->forward(
            motors => $self->{conf}->{motors}->{C},
            speed  => $self->{conf}->{speed}->{half}
        );
        $self->wait($dur);
    $self->end;
    return $self;
};

sub BASIC_MOVEMENTS {
    my ( $self, $turn_time ) = @_;

    $self->FORWARD;
    $self->REVERSE;
    $self->TURN_LEFT( $turn_time );
    $self->TURN_RIGHT( $turn_time );
    return $self;
};

1;
