package Chart::GnuPlot::Tools;

use strict;
use vars qw($VERSION);

$VERSION = '0.01';

sub new {
	my $class = shift;
	my $self = {};
	bless $self, $class;
	return $self;
}

sub make_quote {
	my $self = shift;
	my $text = shift;
	$text =~ tr/"/\\"/;
	return '"' . $text . '"';
}

1;
