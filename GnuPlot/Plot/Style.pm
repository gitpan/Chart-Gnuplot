package Chart::GnuPlot::Plot::Style;

use strict;
use vars qw($VERSION);

use Chart::GnuPlot::Tools;
my $tools = new Chart::GnuPlot::Tools;

$VERSION = '0.01';

sub new {
	my $class = shift;
	my $terminal = shift;
	my $file = shift;
	my $self =	{
				'terminal'	=> $terminal,
				'data_file'	=> $file,
			};
	bless $self, $class;
	return $self;
}

sub make {
	my $self = shift;
	my $settings = shift;
	my $files = $self -> {'data_file'};
	my $data_id = 0;
	$data_id = $settings -> {'data'} if exists( $settings -> {'data'} );
	my @output = $tools -> make_quote( $files -> [ $data_id ] );
	push @output, &_using( $settings -> {'columns'} );
	push @output, &_with( $self, $settings );
	return join( ' ', @output );
}


##############


sub _using {
	my $columns = shift;
	return 'using ' . join( ':', @$columns );
}

sub _with {
	my $self = shift;
	my $settings = shift;
	my @output;
	if ( $settings -> {'title'} ) {
		push( @output, 'title ' . $tools -> make_quote( $settings -> {'title'} ) );
	} else {
		push( @output, 'notitle' );
	}
	push @output, 'with';
	push @output, $settings -> {'type'};
	return @output;
}

1;



