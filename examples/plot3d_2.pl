#!/usr/bin/perl -w
use strict;
use Chart::Gnuplot;

my $chart = Chart::Gnuplot->new(
    output => "gallery/plot3d_2.png",
    title  => "3D plot from data file",
);


my $dataSet = Chart::Gnuplot::DataSet->new(
    datafile => "plot3d_2.dat",
);

$chart->plot3d($dataSet);
