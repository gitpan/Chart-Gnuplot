package Chart::GnuPlot::GnuPlot;

use strict;

use Chart::GnuPlot::Plot;
use Chart::GnuPlot::Titles;
use Chart::GnuPlot::Settings;

use Chart::GnuPlot::Tools;
my $tools = new Chart::GnuPlot::Tools;

my $mod_root = 'Chart::GnuPlot::';

sub new {
	my $class = shift;
	my $settings = shift;
	my $self =	{
				'settings'	=> $settings,
			};
	bless $self, $class;
	return $self;
}


sub plot {
	my $self = shift;
	my $settings = $self -> {'settings'};
	my $titles = $settings -> {'titles'};

	my @parts = qw( Settings Titles Plot );
	my %split_set =	(
				'terminal'	=> [ qw( size grid_set x_label_off y_label_off colours ), map( $_ . '_font', 'text', @$titles ) ],
				'Settings'	=> [ qw( full_file timefmt xformat yformat xyformat grid key set xrange yrange ) ],
				'Titles'	=> [ @$titles ],
				'Plot'		=> [ qw( data plots full_file ) ],
			);

	my( $key, $values );

	foreach $key ( keys %split_set ) {
		$values = $split_set{$key};
		$split_set{$key} = { map { $_, $settings -> {$_} } @$values };
	}

	my $module_name = $mod_root . 'Terminal::' . $settings -> {'terminal'};
	my $require_name = $module_name;

	$require_name =~ s#::#/#g;
	$require_name .= '.pm';
	require $require_name;

	my $module = $module_name -> new( $split_set{'terminal'} );

	my $plot_file = $settings -> {'full_file'} . '.plt';

	my( $id, $extra );
	my $data = $settings -> {'data'};
	my $data_file = [];

	for $id ( 0 .. $#$data ) {
		$extra = '';
		$extra = '_' . $id if $id;
		push @$data_file, $settings -> {'full_file'} . $extra . '.dat'
	}

	my $image_file = $settings -> {'full_file'} . '.' . $module -> extension();

	$split_set{'Plot'} -> {'data_file'} = $data_file;
	$split_set{'Settings'} -> {'image_file'} = $image_file;

	my( $part_mod, @script );
	foreach $key ( @parts ) {
		$split_set{$key} -> {'terminal'} = $module;
		$module_name = $mod_root . $key;
		$part_mod = $module_name -> new( $split_set{$key} );
		push @script, $part_mod -> make();
	}

	die "unable to open output '$plot_file' ($!)" unless ( open OUTPUT, ">$plot_file" );
	my $script = join( "\n", @script, '' );
	warn $script, "\n" if ( exists( $ENV{'DEBUG'} ) && $ENV{'DEBUG'} );
	print OUTPUT $script;
	close OUTPUT;

	my $image = &_run_plot( $settings -> {'gnu_exe'}, $plot_file, $image_file );
	unlink( $plot_file, @$data_file, $image_file ) unless ( exists( $ENV{'DEBUG'} ) && $ENV{'DEBUG'} );
	return ( $image, $module -> extension() );
}

######################

sub _run_plot {
	my $gnu_exe = shift;
	my $plot = shift;
	my $image = shift;
	my $command = "$gnu_exe $plot";
	warn $command, "\n" if ( exists( $ENV{'DEBUG'} ) && $ENV{'DEBUG'} );
	die "can't find gnuplot '$gnu_exe'" unless -x $gnu_exe;
	system( $command );
	die "file '$image' wasn't found" unless -f $image;
	die "unable to open image file '$image' ($!)" unless open( INPUT, "<$image" );
	binmode INPUT;
	local $/;
	undef $/;
	my $output = <INPUT>;
	close INPUT;
	return $output;
}

1;
