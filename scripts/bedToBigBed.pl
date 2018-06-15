#!/usr/bin/perl 
# Takes bed files, sorts them and converts them to bigBed for UCSC Track Hub
# Kenneth Condon July 2017
###############################################################################
use strict;
use warnings;

# Path to bedfiles
my $wd = "$ARGV[0]" or die ("\nUSAGE:\tperl bedToBigBed.pl <pathToBedFiles> <bedFileSuffix> <mm9|mm10>\n File path not included\n\n");

# Bedfile suffix
my $suffix  = "$ARGV[1]" or die ("\nUSAGE:\tperl bedToBigBed.pl <pathToBedFiles> <bedFileSuffix> <mm9|mm10>\nBed file suffix not included\n\n");

# genome build
my $genome = "$ARGV[2]" or die ("\nUSAGE:\tperl bedToBigBed.pl <pathToBedFiles> <bedFileSuffix> <mm9|mm10>\nGenome build not included - enter mm9 or mm10\n\n");

# Store the bed files
opendir(DIR, $wd);		
my @all_files = readdir(DIR);
close DIR;

# Parse each bed file
foreach my $bed(@all_files)
 	{
 		if ($bed =~ m/^(.+).$suffix.bed$/)
 			{	
 				# Prepare the bed files
 				print "\nCreating $1.$suffix.bb...\n";
 				system "sed -i '/track/d' $wd/$bed"; # removes UCSC file header
 				system "sed -i '/NT_/d' $wd/$bed"; # removes NT contigs
				system "sed -i '/chrUn_/d' $wd/$bed"; # removes chrUn contigs
				system "sed -i '/_random/d' $wd/$bed"; # removes _random contigs
  				system "sort -k1,1 -k2,2n $wd/$bed >$wd/$bed.sorted"; # required
  				#system "mv $wd/$bed.sorted $wd/$bed.sorted.alt; cut -f1-4 $wd/$bed.sorted.alt >$wd/$bed.sorted; rm $wd/$bed.sorted.alt;"; # See below

  				# Are these MM9 or MM10 files?
  				my $chr_size;
          if ($genome eq "mm9") {$chr_size = "/NGS/users/Kenneth/chromsizes/mm9.txt";}
          else {$chr_size = "/NGS/musRefs_10/mm10_chr_size.txt";}

  				# Create the bigbed files
  				system "bedToBigBed -tab $wd/$bed.sorted $chr_size $wd/$1.$suffix.bb";
  				system "rm $wd/$bed.sorted";
				print "done!\n\n";
 			}
 	}
exit;



#	this line is necessary only when you get the following error:
#	column #10 isSizeLink do not match: Yours=[0]  BED Standard=[1]	asObjects differ
#	This indicates a problem with some of the extra columns in the sorted bed file - i.e. thay are not standard bed format
#	The command removes all but the first 4 required columns from the sorted bed file - but this means that no colours can be shown on the UCSC browser (requires 9 columns)