package Chart::GnuPlot::ModArgs;

use strict;
use vars qw($VERSION);

$VERSION = '0.01';

sub new {
	my $class = shift;
	my %options = @_;

	die "I need some defaults" unless defined( $options{'defaults'} );

	my $needed = {};
	my $need;

	if ( defined( $options{'needed'} ) ) {
		foreach $need ( @{ $options{'needed'} } ) {
			$needed -> {$need} = 1;
		}
	}

	my $self =	{
					'defaults'	=>	$options{'defaults'},
					'needed'	=>	$needed,
				};

	bless $self, $class;
	return $self;
}

sub options {
	my $self = shift;
	my %options;
	if ( @_ ) {
		if ( ref($_[0]) eq 'HASH' ) {
			%options = %{ $_[0] };
		} elsif ( ! scalar(@_) % 2 ) {
			%options = @_ ;
		}
	}
	my( $need );
	my $needed = $self -> {'needed'};
	foreach $need ( keys %$needed ) {
		next if defined( $options{$need} );
		die "I need option '$need' to be set";
	}
	my $defaults = $self -> {'defaults'};
	my $output = {};
	foreach $need ( keys %$defaults ) {
		if ( defined $options{$need} ) {
			$output -> {$need} = $options{$need};
		} else {
			$output -> {$need} = $defaults -> {$need};
		}
	}
	return $output;
}


1;
__END__
