package Chart::GnuPlot::Plot::Data;

use strict;
use vars qw($VERSION);

$VERSION = '0.01';

sub new {
	my $class = shift;
	my $data = shift;
	my $self =	{
				'data'		=> $data,
			};
	bless $self, $class;
	return $self;
}

sub in_line {
	my $self = shift;
	my @output = &_handle_data( $self -> {'data'} );
	return ( @output, 'e' );
}

sub file {
	my $self = shift;
	my $file = shift;
	die "unable to open output '$file' ($!)" unless ( open OUTPUT, ">$file" );
	my $line;
	foreach $line ( &_handle_data( $self -> {'data'} ) ) {
		print OUTPUT $line, "\n";
	}
	close OUTPUT;
}


sub _handle_data {
	my $data = shift;
	return undef unless @$data;
	my( $item, @output, $field_tmp );
	my $field_cnt = scalar( @{ $data -> [0] } );
	foreach $item ( @$data ) {
		push @output, join( ' ', @$item );
		$field_tmp = scalar( @$item );
		next unless ( $field_tmp && $field_cnt != $field_tmp ) ;
		die "irregular field count (was $field_cnt now $field_tmp)";
	}
	return @output;
}

1;
