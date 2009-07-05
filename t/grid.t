#!/usr/bin/perl -w
use strict;
use Test::More (tests => 3);

BEGIN {use Chart::Gnuplot;}

my $temp = "temp.ps";

# Test default setting of gridlines
{
    my $c = Chart::Gnuplot->new(
        output => $temp,
        grid   => 'on',
    );
    ok(ref($c) eq 'Chart::Gnuplot');
}

# Test formatting the gridlines
{
    my $c = Chart::Gnuplot->new(
        output => $temp,
        grid   => {
            xlines   => "on, on",
            ylines   => "on, off",
            linetyle => "longdash, dot-longdash",
            width    => "2,1",
        },
    );
    ok(ref($c) eq 'Chart::Gnuplot');
}

# Test setting major and minor gridlines
{
    my $c = Chart::Gnuplot->new(
        output => $temp,
        grid   => {
            xlines   => "on",
            ylines   => "on",
            linetyle => "longdash",
            width    => "2",
        },
        minorgrid   => {
            xlines   => "on",
            ylines   => "off",
            linetyle => "dot-longdash",
            width    => "1",
        },
    );
    ok(ref($c) eq 'Chart::Gnuplot');
}
