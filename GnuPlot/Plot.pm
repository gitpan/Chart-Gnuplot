package Chart::GnuPlot::Plot;

use strict;
use vars qw($VERSION);
use Chart::GnuPlot::Plot::Style;
use Chart::GnuPlot::Plot::Data;

$VERSION = '0.01';

# plot {<ranges>}
#            {<function> | {"<datafile>" {datafile-modifiers}}}
#            {axes <axes>} {<title-spec>} {with <style>}
#            {, {definitions,} <function> ...}

sub new {
	my $class = shift;
	my $self =	{
				'settings'	=> shift,
				'script'	=> [],
			};
	bless $self, $class;
	return $self;
}

sub make {
	my $self = shift;
	my $settings = $self -> {'settings'};

	my $data = $settings -> {'data'};
	my $data_file = $settings -> {'data_file'};

	my $id;

	for $id ( 0 .. $#$data ) {
		&_make_data( $data_file -> [$id], $data -> [$id] );
	}
	return &_make_plot( $self, $data_file );
}

###############################

sub _make_plot {
	my $self = shift;
	my $dat_file = shift;
	my $settings = $self -> {'settings'};

	my $plots = $settings -> {'plots'};
	my $style_obj = Chart::GnuPlot::Plot::Style -> new( $settings -> {'terminal'}, $dat_file );

	my( $plot, @output );
	foreach $plot ( @$plots ) {
		push @output, $style_obj -> make( $plot );
	}

	my $std_break = "\\\n\t";
	return "plot $std_break" . join( ", $std_break", @output ) . "\n";
}

sub _make_data {
	my $file = shift;
	my $data = shift;
	my $data_obj = Chart::GnuPlot::Plot::Data -> new( $data );
	return $data_obj -> file( $file );
}


1;
