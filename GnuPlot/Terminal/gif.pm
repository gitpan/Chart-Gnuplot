package Chart::GnuPlot::Terminal::gif;

use strict;
use vars qw($VERSION);
use Chart::GnuPlot::ModArgs;

$VERSION = '0.01';

my $colours =	{
			'background'	=> 'ffffff',
			'foreground'	=> '000000',
			'something'	=> 'aaaaaa',
			'series'	=> [ qw( 0000ff 00ff00 ff0000 ) ],
		};

my $defaults = 	{
			'title_font'	=> 'large',
			'xtitle_font'	=> 'medium',
			'ytitle_font'	=> 'medium',
			'text_font'	=> 'small',
			'tl_label_font'	=> 'small',
			'tr_label_font'	=> 'small',
			'bl_label_font'	=> 'small',
			'br_label_font'	=> 'small',

			'extension'	=> 'gif',
			'name'		=> 'gif',
#			'extension'	=> 'ps',
#			'name'		=> 'postscript',

			'size'		=> '',
			'grid_set'	=> '5',
			'x_label_off'	=> .01,
			'y_label_off'	=> .04,
			'colours'	=> {},
			'tmargin'	=> 2,
			'rmargin'	=> 4,
			'bmargin'	=> 4,
			'lmargin'	=> 0,
		};

my $args = Chart::GnuPlot::ModArgs
	-> 	new(
			'defaults'	=>	$defaults,
			'needed'	=>	[],
		);

my $col_args = Chart::GnuPlot::ModArgs
	-> 	new(
			'defaults'	=>	$colours,
			'needed'	=>	[ ],
		);
sub new {
	my $class = shift;
	my $settings = $args -> options( @_ );
	my $self =	{
				'settings'	=> $settings,
			};
	bless $self, $class;
	return $self;
}

sub terminal {
	my $self = shift;
	my $settings = $self -> {'settings'};
	my @output = ( $settings -> {'name'} );
	my $size = $settings -> {'size'};
	if ( $size ) {
		push @output, 'size', $size;
	}
	push @output, &_colours( $settings -> {'colours'} );
	return join ' ', @output;
}

sub _colours {
	my $col_set = $col_args -> options( shift );
	my @output = map $col_set -> {$_}, qw( background foreground something );
	push @output, @{ $col_set -> {'series'} };
	return map 'x' . $_, @output;
}

sub margins {
	my $self = shift;
	my $settings = $self -> {'settings'};
	my( $type, $key, $val, @output );
	foreach $type ( qw( t r b l ) ) {
		$key = $type . 'margin';
		$val = $settings -> {$key};
		next unless $val;
		push @output, "$key $val";
	}
	return @output;
}

sub grid_set {
	my $self = shift;
	return $self -> {'settings'} -> {'grid_set'};
}
sub name {
	my $self = shift;
	return $self -> {'settings'} -> {'name'};
}

my $default_size = [ 640, 480 ];

sub size {
	my $self = shift;
	my $size = $self -> {'settings'} -> {'size'};
	return '' unless @$size;
	my( $id, @output );
	for $id ( 0, 1 ) {
		if ( $size -> [$id] ) {
			$output[$id] = $size -> [$id] / $default_size -> [$id];
		} else {
			$output[$id] = 1;
		}
	}
	return sprintf "%2.3f, %2.3f", @output;
	return join( ', ', map { sprintf "%2.3f", $_ } @output );
}

sub offsets {
	my $self = shift;
	return map $self -> {'settings'} -> { $_ . '_label_off' }, qw( x y );
}

sub title_font {
	my $self = shift;
	my $type = shift;
	$type .= '_font';
	return '' unless exists( $self -> {'settings'} -> {$type} );
	my $font = $self -> {'settings'} -> {$type};
	return ' "' . $font . '"';
}

sub extension {
	my $self = shift;
	return $self -> {'settings'} -> {'extension'};
}

###############

