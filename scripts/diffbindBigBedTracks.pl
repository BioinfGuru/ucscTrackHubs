#!/usr/bin/perl 
# Writes a file with the code for diffbind bigbed tracks 
# Copy the file content into trackdb.txt
# Cop
# Kenneth Condon May 2017
###############################################################################
use strict;
use warnings;

# store file names
my $bb_dir = "/NGS/working_projects/AtacSeq/data/12_diff_binding/bigbeds";
opendir(DIR, $bb_dir);
my @all_files = readdir(DIR);
close DIR;

# create output file
open OUT, ">fortrackdb.txt";

# print header
print OUT "######################################\n";
print OUT "# Differential Binding composite track\n";
print OUT "######################################\n\n";

# print composite track
print OUT "track atac_diffbind_composite\n";
print OUT "compositeTrack on\n";
print OUT "shortLabel ATAC Diff\n";
print OUT "longLabel ATAC Differential\n";
print OUT "type bigBed 9\n";
print OUT "visibility dense\n";
print OUT "allButtonPair on\n";
print OUT "dragAndDrop subTracks\n\n";

# print individual tracks
my $count = 0;
foreach my $bb(@all_files)
	{
		if ($bb =~ /^(.+)\.bb/)
			{
				$count++;
				print OUT "\ttrack $1\n";
				print OUT "\tparent atac_diffbind_composite off\n";
				print OUT "\ttype bigBed 9\n";
				print OUT "\tbigDataUrl ftp://CoxLab:coX1184\@ftp.har.mrc.ac.uk/CoxLabHubDirectory/mm10/data/atacseq/diffbind/$bb\n";
				print OUT "\tshortLabel $bb\n";
				print OUT "\tlabelOnFeature off\n";
				print OUT "\titemRgb on\n\n";
			}	
	}
print "$count\n";
