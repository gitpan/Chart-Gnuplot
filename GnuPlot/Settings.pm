package Chart::GnuPlot::Settings;

use strict;
use vars qw($VERSION);

use Chart::GnuPlot::Tools;
my $tools = new Chart::GnuPlot::Tools;

$VERSION = '0.01';

sub new {
	my $class = shift;
	my $self =	{
				'settings'	=> shift,
			};
	bless $self, $class;
	return $self;
}

sub make {
	my $self = shift;
	my( @output, $type );
	my $settings = $self -> {'settings'};
	my $terminal = $settings -> {'terminal'};

	push @output, 'set terminal ' . $terminal -> terminal();
	push @output, 'set output ' . $tools -> make_quote( $settings-> {'image_file'} );

#	my $size = $settings-> {'terminal'} -> size();
#	push @output, "set size $size" if $size;

	if ( $settings-> {'timefmt'} ) {
		push @output, 'set xdata time';
		push @output, 'set timefmt ' . $tools -> make_quote( $settings-> {'timefmt'} );
	}

	if ( $settings-> {'xyformat'} ) {
		push @output, 'set format ' . $tools -> make_quote( $settings-> {'xyformat'} );
	}

	if ( $settings-> {'xformat'} ) {
		push @output, 'set format x ' . $tools -> make_quote( $settings-> {'xformat'} );
	}

	if ( $settings-> {'yformat'} ) {
		push @output, 'set format y ' . $tools -> make_quote( $settings-> {'yformat'} );
	}

	foreach my $type ( qw( x y ) ) {
		my $ftype = $type . 'range';
		if ( ref( $settings-> {$ftype} ) eq 'ARRAY' ) {
			if ( $settings -> {$ftype} -> [-1] ) {
				my $range = $settings-> {$ftype};
				my @tmp = ( 'set', $ftype, '[', shift( @$range ), ':', shift( @$range ), ']' );
				push( @tmp, @$range ) if @$range;
				push @output, join( ' ', @tmp );
			}
		} else {
			die "option '$ftype' should be a reference to an array";
		}
	}

	if ( ref( $settings-> {'set'} ) eq 'ARRAY' ) {
		foreach my $set ( @{ $settings-> {'set'} } ) {
			push @output, 'set ' . $set;
		}
	} else {
		die "option 'set' should be a reference to an array"
	}

	push( @output, 'set grid ' . $terminal -> grid_set() ) if $settings-> {'grid'};

	push( @output, 'set key ' . $settings-> {'key'} ) if $settings-> {'key'};

	foreach $type ( $terminal -> margins() ) {
		push @output, 'set ' . $type;
	}

	return @output;
}

###############################

1;
