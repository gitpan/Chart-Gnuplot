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
		if ( $settings-> {'xformat'} ) {
			push @output, 'set format x ' . $tools -> make_quote( $settings-> {'xformat'} );
		}
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
