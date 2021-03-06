#!/usr/bin/env perl
#
# $Id: mmd2LaTeX.pl 534 2009-06-19 20:52:55Z fletcher $
#
# Utility script to process MultiMarkdown files into LaTeX
#
# Copyright (c) 2009 Fletcher T. Penney
#	<http://fletcherpenney.net/>
#
# MultiMarkdown Version 2.0.b6
#

# Combine all the steps necessary to process MultiMarkdown text into LaTeX
# Not necessary, but easier than stringing the commands together manually.
#
# This script will process the text received via stdin, and output to stdout,
# OR
# will accept a list of files, and process each file individually.
#
# If a list of files is received, the input from "test.txt" will be output
# to "test.tex", for example.

use strict;
use warnings;

use File::Basename;
use Cwd;
use Cwd 'abs_path';

# Determine where MMD is installed.  Use a "common installation" if available.

my $me = $0;		# Where is this script located?
my $MMDPath = LocateMMD($me);


# Determine whether we are in "file mode" or "stdin mode"

my $count = @ARGV;

if ($count == 0) {
	# We're in "stdin mode"

	# process stdin
	undef $/;
	my $data .= <>;

	MultiMarkdown::Support::ProcessMMD2LaTeX($MMDPath, "", $data);

} else {
	# We're in "file mode"

	foreach(@ARGV) {
		# process each file individually

		# warn if directory
		if ( -d $_ ) {
			warn "This utility will not process directories.  Please specify the files to process.\n";
		} elsif ( -f $_ ) {
			# Determine filenames
			my $filename = $_;

			# Read input and process
			open(INPUT, "<$filename");
			local $/;
			my $data = <INPUT>;
			close(INPUT);

			MultiMarkdown::Support::ProcessMMD2LaTeX($MMDPath, $filename, $data);
		} else {
			system("perldoc $0");
		}
	}
}

sub LocateMMD {
	my $me = shift;		# Where am I running from?

	my $os = $^O;	# Mac = darwin; Linux = linux; Windows contains MSWin
	my $MMDPath = "";

	# Determine where MMD is installed.  Use a "common installation"
	# if available.

	$me = dirname($me);

	if ($os =~ /MSWin/) {
		# We're running Windows
	
		if ( -d "$ENV{HOMEDRIVE}$ENV{HOMEPATH}\\MultiMarkdown") {
			$MMDPath = "$ENV{HOMEDRIVE}$ENV{HOMEPATH}\\MultiMarkdown";
		} elsif ( -d "$ENV{HOMEDRIVE}\\Documents and Settings\\All Users\\MultiMarkdown") {
			$MMDPath = "$ENV{HOMEDRIVE}\\Documents and Settings\\All Users\\MultiMarkdown";
		} elsif ( -d "$me\\..\\..\\MultiMarkdown") {
			$MMDPath = "$me\\..";
		}

		# Load the MultiMarkdown::Support.pm module
		do "$MMDPath\\bin\\MultiMarkdown\\Support.pm" if ($MMDPath ne "");
	} else {
		# We're running Mac OS X or some *nix
		
		# First, look in user's home directory, then in commond directories

		if ( -d "$ENV{HOME}/Library/Application Support/MultiMarkdown") {
			$MMDPath = "$ENV{HOME}/Library/Application Support/MultiMarkdown";
		} elsif ( -d "$ENV{HOME}/.multimarkdown") {
			$MMDPath = "$ENV{HOME}/.multimarkdown";
		} elsif ( -d "/Library/Application Support/MultiMarkdown") {
			$MMDPath = "/Library/Application Support/MultiMarkdown";
		} elsif ( -d "/usr/share/multimarkdown") {
			$MMDPath = "/usr/share/multimarkdown";
		} elsif ( -d "$me/../../../MultiMarkdown") {
			$MMDPath = "$me/../..";
		}
		# Load the MultiMarkdown::Support.pm module
		do "$MMDPath/bin/MultiMarkdown/Support.pm" if ($MMDPath ne "");
	}

	if ($MMDPath eq "") {
		die "You do not appear to have MultiMarkdown installed.\n";
	}

	# Clean up the path
	$MMDPath = abs_path($MMDPath);

	return $MMDPath;
}

=head1 NAME

mmd2LaTeX.pl - utility script for MultiMarkdown to convert MultiMarkdown text
into LaTeX.

=head1 SYNOPSIS

mmd2LaTeX.pl [file ...]


=head1 DESCRIPTION

This script is designed as a "front-end" for MultiMarkdown. It can convert a
series of text files into LaTeX. Alternatively, it can accept MultiMarkdown
text on stdin, and provide the LaTeX output on stdout.

It effectively replaces the older multimarkdown2latex.pl script.

=head1 SEE ALSO

Designed for use with MultiMarkdown.

<http://fletcherpenney.net/multimarkdown/>

Mailing list support for MultiMarkdown:

<http://groups.google.com/group/multimarkdown/>

	OR

<mailto:multimarkdown@googlegroups.com>

=head1 AUTHOR

Fletcher T. Penney, E<lt>owner@fletcherpenney.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Fletcher T. Penney

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the
   Free Software Foundation, Inc.
   59 Temple Place, Suite 330
   Boston, MA 02111-1307 USA

=cut
