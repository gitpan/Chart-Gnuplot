package Chart::GnuPlot;

use Config;
use strict;
use vars qw($VERSION);
use Chart::GnuPlot::ModArgs;
use Chart::GnuPlot::GnuPlot;

$VERSION = '0.02';

my @titles = qw( title xtitle ytitle bl_label br_label tl_label tr_label );

my( $dos, $gnu_exe );

if ( $Config{'archname'} eq 'MSWin32' ) {
	$dos = 1;
	$gnu_exe = 'D:\\GNUPLOT\\WGNUPLOT.EXE';
} else {
	$dos = 0;
	$gnu_exe = '/usr/local/bin/gnuplot';
}

my $defaults = 	{
			'gnu_exe'	=> $gnu_exe,
			'terminal'	=> 'gif',
			'data'		=> [],
			'plots'		=> [],
			'set'		=> [],
			'size'		=> '',
			'file_name'	=> '',
			'temp_dir'	=> '/tmp',
			'timefmt'	=> '',
			'xformat'	=> '',
			'yformat'	=> '',
			'xrange'	=> [],
			'yrange'	=> [],
			'xformat'	=> '',
			'xyformat'	=> '',
			'grid'		=> 0,
			'key'		=> 'bottom right',
			'bl_label'	=> '',
			'br_label'	=> '',

			'grid_set'	=> undef,
			'x_label_off'	=> undef,
			'y_label_off'	=> undef,
			'tmargin'	=> undef,
			'rmargin'	=> undef,
			'bmargin'	=> undef,
			'lmargin'	=> undef,
			'colours'	=> {},
		};

&_add_title_stuff();

my $args = Chart::GnuPlot::ModArgs
	-> 	new(
			'defaults'	=>	$defaults,
			'needed'	=>	[ qw( data plots ) ],
		);

sub new {
	my $class = shift;
	my $self = {};
	bless $self, $class;
	return $self;
}


=head1 OPTIONS

  (* = mandatory)
  data *
  a reference to an array of array of arrays;
  [
    [ # data set 1
      [ 0, 1 ],
      [ 1, 3 ],
    ],
    [ # data set 2
      [ 0, -4 ],
      [ 1, -7 ],
    ],
  ]

  plots *
  a reference to a array of hashes.
  Each hash should be in the following format;
  [
    {
      'title'         => 'title of the series'.
      'data'          => index of dataset to use
                         (defaults to 0).
      'columns'       => [ array of column numbers to use for
                         the graph ].
      'type'          => 'errorbars' or 'lines' etc.
    },
    {
      etc.....
    },
  ]

  title           the title of the graph.
  title_font      the font to use for title.
  xtitle          title of x axis
  xtitle_font     the font to use for xtitle.
  ytitle          title of x axis
  ytitle_font     the font to use for xtitle.
  tl_label        label at top left of image.
  tl_label_font   the font to use.
  tr_label        as above but top right.
  tr_label_font   the font to use.
  bl_label        as above but bottom left.
  bl_label_font   the font to use.
  br_label        as above but bottom right.
  br_label_font   the font to use.

  gnu_exe         the full path to an alternative gnuplot,
  terminal        terminal type, there should be a matching
                  Chart::GnuPlot::Terminal::<terminal> method.
  size            size of output image (relative to terminal type).
  file_name       filename to use for the cache files.
  temp_dir        directory to place the cache files.
  grid            on (1) or off(0).
  key             ie. 'bottom right'
                  (this uses gnuplot 'set key' syntax).
  grid_set        grid setting (this uses gnuplot 'set grid' syntax).
  x_label_off     the offset (0 - 1) that the labels should be placed
                  from the side of the picture.
  y_label_off     as above but top/ bottom.
  colours         a hash that resembles (all entries are optional);
                  {
                    'background' => '000000',
                    'foreground' => 'ffffff',
                    'something'  => 'aaaaaa',
                    'series'     => [ qw( 0000ff 00ff00
                                       etc...) ],
                  }
  tmargin         top margin (in character spaces).
  rmargin         right margin.
  bmargin         bottom margin.
  lmargin         left margin.
  timefmt         the date picture of the datasets
                  (this uses gnuplot 'set timefmt' syntax)
  xrange          this value should be a reference to an array of two
                  values [ minimum, maximum ]. Either of these can be '*'.
		  If the range is a date, it should be in the same
		  format as timefmt.
  yrange          see xrange.
  xformat         the format values will be shown on the x axis
                  (this uses gnuplot 'set format x' syntax)
  yformat         the format values will be shown on the y axis
                  (this uses gnuplot 'set format y' syntax)
  xyformat        the format values will be shown on the both axis
                  (this uses gnuplot 'set format' syntax)
  set             this should be a reference to an array containing
                  a list of 'set' commands to pass gnuplot.
		  The main use for this is to access options that I
		  haven't put a wrapper around :-)

=cut


sub plot {
	my $self = shift;
	my $settings = $args -> options( @_ );

	$settings -> {'file_name'} = &_uniq_name() unless $settings -> {'file_name'};
	$settings -> {'full_file'} = join( '/', map $settings -> {$_}, qw( temp_dir file_name ) );
	$settings -> {'titles'} = \@titles;

	my $plot = Chart::GnuPlot::GnuPlot -> new( $settings );
	return $plot -> plot();
}

###############################

sub _uniq_name {
	return join( '_', $$, time );
}

sub _add_title_stuff {
	my $temp;
	foreach $temp ( @titles ) {
		next if ( $defaults -> {$temp} );
		$defaults -> {$temp} = undef;
	}
	foreach $temp ( 'text', @titles ) {
		next if ( $defaults -> {$temp} );
		$defaults -> { $temp . '_font' } = undef;
	}
}

=head1 NOTES

  If the enviroment variable 'DEBUG' is set ($ENV{'DEBUG'} = 1)
  the gnuplot command file  & gnuplot command line options will be
  output to stderr.

  Unfortunately I haven't been able to trap the error messages from
  Gnuplot yet, If the gif doesn't appear, try setting DEBUG & run
  the generated script manually.

=head1 AUTHOR

Nick Peskett - nick@soup.demon.co.uk

=cut

1;
__END__
