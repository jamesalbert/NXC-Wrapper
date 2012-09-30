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
    my ( $self, %opts ) = @_;

    my $motors = "$opts{motor_1}$opts{motor_2}";
    my $speed  = $opts{speed};

    $self->start_void("forward");
        $self->forward(
            motors => $self->{conf}->{motors}->{$motors},
            speed  => $self->{conf}->{speed}->{$speed}
        );
    $self->end;
    return $self;
};

sub REVERSE {
    my ( $self, %opts ) = @_;

    my $motors = "$opts{motor_1}$opts{motor_2}";
    my $speed  = $opts{speed};

    $self->start_void("reverse");
        $self->reverse(
            motors => $self->{conf}->{motors}->{$motors},
            speed  => $self->{conf}->{speed}->{$speed}
        );
    $self->end;
    return $self;
};

sub TURN_LEFT {
    my ( $self, %opts ) = @_;

    my $motor_1 = $opts{motor_1};
    my $motor_2 = $opts{motor_2};

    $self->start_void("turn_left");
        $self->forward(
            motors => $self->{conf}->{motors}->{$motor_1},
            speed  => $self->{conf}->{speed}->{half}
        );
        $self->reverse(
            motors => $self->{conf}->{motors}->{$motor_2},
            speed  => $self->{conf}->{speed}->{half}
        );
        $self->wait($opts{duration});
    $self->end;
    return $self;
};

sub TURN_RIGHT {
    my ( $self, %opts ) = @_;

    my $motor_1 = $opts{motor_1};
    my $motor_2 = $opts{motor_2};

    $self->start_void("turn_right");
        $self->reverse(
            motors => $self->{conf}->{motors}->{$motor_1},
            speed  => $self->{conf}->{speed}->{half}
        );
        $self->forward(
            motors => $self->{conf}->{motors}->{$motor_2},
            speed  => $self->{conf}->{speed}->{half}
        );
        $self->wait($opts{duration});
    $self->end;
    return $self;
};

sub BASIC_MOVEMENTS {
    my ( $self, %opts ) = @_;

    $self->FORWARD(
        motor_1 => $opts{motor_1},
        motor_2 => $opts{motor_2},
        speed   => $opts{speed}
    );
    $self->REVERSE(
        motor_1 => $opts{motor_1},
        motor_2 => $opts{motor_2},
        speed   => $opts{speed}
    );
    $self->TURN_LEFT(
        motor_1  => $opts{motor_1},
        motor_2  => $opts{motor_2},
        duration => $opts{turn_time}
    );
    $self->TURN_RIGHT(
    motor_1  => $opts{motor_1},
    motor_2  => $opts{motor_2},
    duration => $opts{turn_time}
    );
    return $self;
};

1;
