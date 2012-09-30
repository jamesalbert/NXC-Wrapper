#!/usr/bin/env perl

use strict;
use warnings;
use NXC::Wrapper;
use NXC::Wrapper::Utils;

sub BASIC {
    my $r = shift;

    $r->BASIC_MOVEMENTS(
        motor_1   => "B",
        motor_2   => "A",
        speed     => "three_quarters",
        turn_time => 3
    );
};

sub COLOR_SORT {
    my $r = shift;

    $r->start_void( "color_sort" );
        $r->start_if( "SENSOR_1 == 1" );
            $r->call( "reverse");
            $r->until( "SENSOR_1 == 0" );
            $r->call( "turn_left" );
            $r->call( "forward" );
        $r->end;
    $r->end;
};

sub MAIN_TASK {
    my $r = shift;

    $r->start_task;
        $r->call("forward");
        $r->touch_setup(1);
        $r->start_while( 1 );
            $r->call( "color_sort" );
            $r->end;
        $r->end;
    $r->end;
    return $r;
};

my $robot = NXC::Wrapper->new;
my $utils = NXC::Wrapper::Utils->new(
    config => "/home/jbert/dev/NXC-Wrapper/data.yaml"
);

BASIC( $utils );
COLOR_SORT( $robot );
MAIN_TASK( $robot );
