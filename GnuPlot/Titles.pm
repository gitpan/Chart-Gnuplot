package Chart::GnuPlot::Titles;

use strict;
use vars qw($VERSION);

use Chart::GnuPlot::Tools;
my $tools = new Chart::GnuPlot::Tools;

$VERSION = '0.01';

my %types = 	(
			'title'		=> 'title',
			'xtitle'	=> 'xlabel',
			'ytitle'	=> 'ylabel',
			'tr_label'	=> 'label',
			'tl_label'	=> 'label',
			'br_label'	=> 'label',
			'bl_label'	=> 'label',
		);

my %offsets =	(
			'tr'	=> 'screen 1 - _xos_, screen 1 - _yos_ right',
			'tl'	=> 'graph 0, screen 1 - _yos_ left',
			'br'	=> 'screen 1 - _xos_, screen _yos_ right',
			'bl'	=> 'screen _xos_, screen _yos_ left',
		);


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
	my( @output, $type, $val );
	foreach $type ( keys %types ) {
		$val = &_handle_text( $self, $type );
		next unless $val;
		push @output, $val;
	}
	return @output;
}

###############################

sub _handle_text {
	my $self = shift;
	my $type = shift;
	my $settings = $self -> {'settings'};
	return '' unless $settings -> {$type};
	my $output = join ' ', 'set', $types{$type}, $tools -> make_quote( $settings -> {$type} );
	if ( $types{$type} eq 'label' ) {
		my @offs = map $settings -> { $_ . '_label_off' }, qw( x y );
		$output .= &_label_offset( $type, $settings -> {'terminal'} -> offsets() ) ;
		$output .= ' font';
	}
	$output .= $settings -> {'terminal'} -> title_font($type);
	return $output;
}

sub _label_offset {
	my $type = shift;
	my $x_off = shift;
	my $y_off = shift;
	return '' unless $type =~ /^([tb][rl])_/;
	my $key = $1;
	my $template = $offsets{$key};
	$template =~ s/_xos_/$x_off/;
	$template =~ s/_yos_/$y_off/;
	return ' at ' . $template;
}

1;
