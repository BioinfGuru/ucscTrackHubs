#!/usr/bin/perl 
# takes a list of files and creates tracks for them for use in a single composite track. Copy output to tracks.db
# Kenneth Condon Apr 2017
###############################################################################
use strict;
use warnings;

# working directory
my $wd = "$ARGV[0]" or die ("\nUSAGE: perl makeTracks.pl <pathToFiles (on NGS)> <lab> <filezilla directory> <parent>\nFile path not included\n\n");

# Store Hub
my $lab = "$ARGV[1]"  or die ("\nUSAGE:\tperl makeTracks.pl <pathToFiles (on NGS)> <lab> <filezilla directory> <parent>\nLab not included. Enter Mallon, Cox, Nolan or Greenfield\n\n");
my $hub;
if ($lab eq "Mallon"){$hub = "ftp://Mallonlab:9WghvSq4qJGG\@ftp.har.mrc.ac.uk/MallonLabHubDirectory"}
elsif ($lab eq "Cox"){$hub = "ftp://CoxLab:coX1184\@ftp.har.mrc.ac.uk/CoxLabHubDirectory";}
elsif ($lab eq "Nolan"){$hub = "ftp://NolanLab:nolaN1091\@ftp.har.mrc.ac.uk/NolanLabHubDirectory";}
elsif ($lab eq "Greenfield"){$hub = "ftp://Greenfieldlab:fGGa6Opsty\@ftp.har.mrc.ac.uk/GreenfieldLabhubDirectory";}

# Store the URL
my $fzdir = "$ARGV[2]"  or die ("\nUSAGE:\tperl makeTracks.pl <pathToBedFiles (on NGS)> <lab> <filezilla directory> <parent>\nPlease enter the path to the files from the hubdirectory onward:\nCopy the URL from filezilla\nFor:\tftp://Mallonlab\@ftp.har.mrc.ac.uk/MallonLabHubDirectory/mm10/data/Sid/chromHmm/filename.bb\nEnter:\tmm10/data/Sid/chromHmm\n\n");

# Store parent name
my $parent = "$ARGV[3]"  or die  ("\nUSAGE: perl makeTracks.pl <pathToFiles (on NGS)> <lab> <filezilla directory> <parent>\nparent not included\nplease provide the name of parent composite track (see first line of composite track header)\n\n");

# Store the input filenames
opendir(DIR, $wd);		
my @all_files = readdir(DIR);
close DIR;

# create out file
open (OUT, ">appendToTrackDb.txt");
foreach my $filename(@all_files)
	{
		# Bigbeds
		if ($filename =~ m/^(.+)\.bb$/)
			{
				print OUT "\ttrack $1\n";
				print OUT "\tparent $parent off\n";
				print OUT "\ttype bigBed 9\n"; # For colours to be shown you must have 9 columns and you must declare “type bigBed 9”.
				print OUT "\tbigDataUrl $hub/$fzdir/$filename\n";
				print OUT "\tshortLabel $1\n";
				print OUT "\tlabelOnFeature off\n";
				print OUT "\titemRgb on\n\n";
			}

		# BigWigs
		elsif (($filename =~ m/^(.+)\.bw$/) or ($filename =~ m/^(.+)\.bigwig$/) or ($filename =~ m/^(.+)\.bigWig$/))
			{
				print OUT "\ttrack $1\n";
				print OUT "\tparent $parent on\n";
				print OUT "\tbigDataUrl $hub/$fzdir/$filename\n";
				print OUT "\tshortLabel $1\n";
				print OUT "\tlongLabel $1\n";
				print OUT "\tcolor 0,0,102\n";
				print OUT "\ttype bigWig\n";
				print OUT "\twindowingFunction mean\n\n";
			}
		#else{print "$filename\n";}
	}

