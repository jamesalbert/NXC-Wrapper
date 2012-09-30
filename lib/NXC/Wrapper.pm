package NXC::Wrapper;

use strict;
use warnings;
use Carp qw/croak/;
use YAML qw/LoadFile/;

our $VERSION = 0.01;

sub new {
    my ( $class, %opt ) = @_;
    my $self = {};
    return bless $self, $class;
};

sub write_and_compile {
    my ( $self, $filename, $output ) = @_;
    system("perl $filename > $output");
    system("nbc $output.nxc -sm+ -d -S=usb");
}

sub start_void {
    my ( $self, $name ) = @_;
    return print "void $name() {\n";
};

sub start_task {
    my $self = shift;
    return print "task main() {\n";
};

sub start_if {
    my ( $self, $cond ) = @_;
    if ( $cond !~ m/((.+) > (.+)|(.+) >= (.+)|(.+) <= (.+)|(.+) < (.+)|(.+) == (.+)|(.+) != (.+)|(.*)|true|!(.*)|false)/ ) {
        croak "Incorrect condition syntax.";
    };
    return print "if ( $cond ) {\n";
};

sub start_else_if {
    my ( $self, $cond ) = @_;
    if ( $cond !~ m/((.+) > (.+)|(.+) >= (.+)|(.+) <= (.+)|(.+) < (.+)|(.+) == (.+)|(.+) != (.+)|(.*)|true|!(.*)|false)/ ) {
        croak "Incorrect condition syntax.";
    };
    return print "else if ( $cond ) {\n";
}

sub start_for {
    my ( $self, %opt ) = @_;
    return print "for (int i = $opt{init}; i < $opt{end}; i++) {\n";
}

sub end {
    my ( $self, %opt ) = @_;
    return print "}\n";
};

sub int_var {
    my ( $self, %opt ) = @_;
    if ( $opt{name} !~ m/(.+)/ ) {
        croak "Undefined variable name."
    };
    return print "int $opt{name} = $opt{value};\n";
}

sub char_var {
    my ( $self, %opt ) = @_;
    if ( $opt{name} !~ m/(.+)/ ) {
        croak "Undefined variable name."
    };
    return print "char $opt{name} = $opt{value};\n";
}

sub long_var {
    my ( $self, %opt ) = @_;
    if ( $opt{name} !~ m/(.+)/ ) {
        croak "Undefined variable name."
    };
    return print "in $opt{name} = $opt{value};\n";
}

sub start_while {
    my ( $self, $cond ) = @_;
    if ( $cond !~ m/((.+) > (.+)|(.+) >= (.+)|(.+) <= (.+)|(.+) < (.+)|(.+) == (.+)|(.+) != (.+)|(.*)|true|!(.*)|false)/ ) {
        croak "Incorrect condition syntax.";
    };
    return print "while ($cond) {\n";
}

sub inc_plus {
    my ( $self, $var ) = @_;
    if ( $var !~ m/(.+)/ ) {
        croak "Invalid variable name";
    }
    print "$var++;\n";
}

sub inc_minus {
    my ( $self, $var ) = @_;
    if ( $var !~ m/(.+)/ ) {
        croak "Invalid variable name";
    }
    print "$var--;\n";
}

sub define {
    my ( $self, %opt ) = @_;
    return print "#define $opt{var} $opt{value}\n";
}

sub forward {
    my ( $self, %opt ) = @_;
    return print "OnFwd(OUT_$opt{motors}, $opt{speed});\n";
}

sub reverse {
    my ( $self, %opt ) = @_;
    return print "OnRev(OUT_$opt{motors}, $opt{speed});\n";
}

sub suspend {
    my ( $self, %opt ) = @_;
    return print "Off(OUT_$opt{motors});";
}

sub display_text {
    my ( $self, %opt ) = @_;
    return print "TextOut($opt{x}, LCD_LINE$opt{y}, $opt{text}, true);\n";
}

sub display_number {
    my ( $self, %opt ) = @_;
    return print "NumOut($opt{x}, LCD_LINE$opt{y}, $opt{number});\n";
}

sub display_graphic {
    my ( $self, %opt ) = @_;
    return print "GraphicOut( $opt{x}, $opt{y},", '"' , "$opt{filename}", '"' , ");\n";
}

sub clear_screen {
    my ( $self, %opt ) = @_;
    return print "ClearScreen();\n";
}

sub reset_screen {
    my $self = shift;
    return print "ResetScreen();\n";
}

sub display_rect {
    my ( $self, %opt ) = @_;
    return print "RectOut($opt{x}, $opt{y}, $opt{width}, $opt{height});\n";
}

sub display_point {
    my ( $self, %opt ) = @_;
    return print "PointOut($opt{x}, $opt{y});\n";
}

sub display_circle {
    my ( $self, %opt ) = @_;
    return print "CircleOut($opt{x}, $opt{y}, $opt{radius});\n";
}

sub itself_plus {
    my ( $self, %opt ) = @_;
    return print "$opt{var} += $opt{value};\n";
}

sub itself_minus {
    my ( $self, %opt ) = @_;
    return print "$opt{var} -= $opt{value};\n";
}

sub until {
    my ( $self, $cond ) = @_;
    return print "until ($cond);\n";
}

sub touch_setup {
    my ( $self, $motor_port ) = @_;
    return print "SetSensorTouch(IN_$motor_port);\n";
}

sub light_setup {
    my ( $self, $motor_port ) = @_;
    return print "SetSensorLight(IN_$motor_port);\n";
}

sub sound_setup {
    my ( $self, $motor_port ) = @_;
    return print "SetSensorSound(IN_$motor_port);\n";
}

sub ultrasonic_setup {
    my ( $self, $motor_port ) = @_;
    return print "SetSensorLowspeed(IN_$motor_port);\n";
}

sub start_int {
    my ( $self, %opt ) = @_;
    return print "int %opt{name}() {\n";
}

sub tone {
    my ( $self, %opt ) = @_;
    return print "PlayToneEx($opt{frequency}, $opt{duration}, $opt{volume}, $opt{loop});\n";
}

sub rotate_motor {
    my ( $self, %opt ) = @_;
    return print "RotateMotor(OUT_$opt{motors}, $opt{speed}, $opt{degrees});\n";
}

sub reset {
    my ( $self, $count ) = @_;
    return print "repeat($count){\n"
}

sub wait {
    my ( $self, $dur ) = @_;
    return print "Wait(", $dur, "000);\n";
};

sub call {
    my ( $self, $call ) = @_;
    return print "$call();\n";
};

1;

__END__

=pod

=head1 NAME

NXP - An easy to read, fully functional NXC wrapper for NXT Mindstorm.

=head1 SYNOPSIS

    #!/usr/bin/env perl

    use strict;
    use warnings;
    use NXC::Wrapper;

    sub FORWARD {
        my $r = shift;

        $r->start_void("forward");
            $r->forward(
                motors => "AC",
                speed  => 50
            );
        $r->end;
    };

    sub REVERSE {
        my $r = shift;

        $r->start_void("reverse");
            $r->reverse(
                motors => "AC",
                speed  => 50
            );
        $r->end;
    };

    sub TURN_LEFT {
        my ( $r, $dur ) = @_;

        $r->start_void("turn_left");
            $r->forward(
                motors => "A",
                speed  => 50
            );
            $r->reverse(
                motors => "C",
                speed  => 50
            );
            $r->wait($dur);
        $r->end;
    };

    sub TURN_RIGHT {
        my ( $r, $dur ) = @_;

        $r->start_void("turn_right");
            $r->reverse(
                motors => "A",
                speed  => 50
            );
            $r->forward(
                motors => "C",
                speed  => 50
            );
            $r->wait($dur);
        $r->end;
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

    my $r = NXC::Wrapper->new;
    FORWARD( $r );
    REVERSE( $r );
    TURN_LEFT( $r, 2 );
    TURN_RIGHT( $r, 2 );
    COLOR_SORT( $r );
    MAIN_TASK( $r );

=head2 DESCRIPTION

=head1 NXC::Wrapper

    The NXC::Wrapper base library has a series of functions that you can call which will spit out NXC.
    Start by initiating it.

    use NXC::Wrapper;

    my $r = NXC::Wrapper->new;

=head1 LIST OF FUNCTIONS

=head4 start_void($name)

    Starts a void function. $name is the name of the function being declared.

=head4 start_task()

    Starts the main task. This function must always be present in the script.

=head4 start_if($condition)

    Starts an if statement. $condition is, of course, the condition.

=head4 start_for(init => $init, end => $end, )

    Starts a for loop. Takes two arguments: a start value ( usually 0 ), and an end value,

=head4 start_while($condition)

    Starts a while loop. Takes the condition.

=head4 end()

    Prints a brace "}" and starts a newline.

=head4 int_var(name => $name, value => $value)

    defines a int variable

=head4 char_var(name => $name, value => $value)

    defines a char variable

=head4 long_var(name => $name, value => $value)

    defines a long variable

=head4 tone(frequency => $frequency, duration => $duration, volume => $vol, loop => "true")

    sets up a tone.

=head4 forward(motors => "AC", speed => $speed)

    drives the AC motors forward at a speed of $speed.

=head4 reverse(motors => "AC", speed => $speed)

    drives the AC motors in reverse at a speed of $speed.

=head4 wait($duration)

    Pauses the robot for the given amount of seconds. ( yes, SECONDS! )

=head4 call($function_name)

    Calls a given function.

=head3 AUTHORS

    James Albert <james.albert72@gmail.com>
    Casey Vega   <casey.vega@gmail.com>

=cut
