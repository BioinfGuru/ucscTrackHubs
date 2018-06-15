# !/usr/bin/perl 
# converts bed files from mm9 to mm10
# Kenneth Condon July 2017
#################################################################################################################
use strict;
use warnings;

# Path to bedfiles
my $wd = "$ARGV[0]" or die ("\nUSAGE:\tperl remap.pl <pathToBedfiles>\n\n");

# Store the bed files
opendir(DIR, $wd);	
my @folder = readdir(DIR);
close DIR;

# # Process the bedfiles
foreach my $bedfile(@folder)
	{
		#print "$bedfile\n";
		if ($bedfile =~ m/mm10.bed$/) {next;}
		elsif ($bedfile =~ m/(.+).bed$/)
				{
					print "\nprocessing $bedfile ... removing header ...\n";
					system "sed -i '/track/d' $wd/$bedfile"; # removes UCSC file header
					print  "remapping ...\n";
					system "perl /home/k.condon/NGS_new/Software/Factory/New_remap/remap_api.pl --mode asm-asm --from GCF_000001635.18 --dest GCF_000001635.20 --annotation $wd/$bedfile --annot_out $wd/$1.mm10.bed --in_format bed"; # run remap
					print "Remapping complete ... removing contigs...\n";
					system "sed -i '/NT_/d' $wd/$1.mm10.bed"; # removes NT contigs
					system "sed -i '/chrUn_/d' $wd/$1.mm10.bed"; # removes chrUn contigs
					system "sed -i '/_random/d' $wd/$1.mm10.bed"; # removes _random contigs
					system "sort -k1,1 -k2,2n $wd/$1.mm10.bed >$wd/sorted.bed; rm $wd/$1.mm10.bed; mv $wd/sorted.bed $wd/$1.mm10.bed"; # sort the outfile
					print "FILE COMPLETE!\n\n";
				}
	}

# Common errors
	#1: "download of failed, 400 URL missing" - possibly due to interrupted connection so remap fails with no mm10 file downloaded, SED command has no input so also fails