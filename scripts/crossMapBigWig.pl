# !/usr/bin/perl 
# converts bigwig files from mm9 to mm10 using CrossMap
# Runtime: 4 hours per bigwig (runs 1 file at a time)
# Kenneth Condon July 2017
#################################################################################################################
use strict;
use warnings;

# Path to bigwig files
my $wd = "$ARGV[0]" or die ("\nUSAGE:\tperl liftOverBigWig.pl <pathToBigWigFiles>\n\n");

# Store the file names
opendir(DIR, $wd);	
my @allfiles = readdir(DIR);
close DIR;

# Run Crossmap
foreach my $bw(@allfiles)
	{
		if ($bw =~ m/mm10.bw$/) {next;}
		elsif (($bw =~ m/(.+)\.bw$/) or ($bw =~ m/(.+)\.bigWig$/)) 
			{
				system "CrossMap.py bigwig /NGS/Software/CrossMap/mm9ToMm10.over.chain.gz $wd/$bw $wd/$1.mm10";
			}
	}
