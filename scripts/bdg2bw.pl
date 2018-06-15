#!/usr/bin/perl 
# Converts *_FE|LogLR|ppois|qpois.bdg files to bigwig files
# Required: *treat_pileup.bdg, *control_lambda.bdg, *.bed, mm10_chr_size.txt
# Runtime = 7-10 min per file
# Kenneth Condon Mar 2017
############################################################################################
use strict;
use warnings;
use File::Copy qw(move);

# working directory
my $wd = "$ARGV[0]" or die ("USAGE: perl bdg2bw.pl [full path to directory containing .bdg files]\n");

# chromosome size file
my $chr_size = "/NGS/musRefs_10/mm10_chr_size.txt";

# convert bdg to bw
opendir(DIR, $wd);		
my @all_files = readdir(DIR);
close DIR;
foreach my $bdg(@all_files)
 	{
 		chomp $bdg;
 		if (($bdg =~ /^(.+_FE)\.bdg$/) or ($bdg =~ /^(.+_ppois)\.bdg$/) or ($bdg =~ /^(.+_qpois)\.bdg$/) or ($bdg =~ /^(.+_logLR)\.bdg$/))
			{
				print "Creating $1.bw...\n";																	
				system "bedtools slop -i $wd/$bdg -g $chr_size -b 0 | bedClip stdin $chr_size $wd/$bdg.clip";	# 5 min per sample
				system "bedGraphToBigWig $wd/$bdg.clip $chr_size $wd/$bdg.bw";									# 3 min per sample
				move "$wd/$bdg.bw", "$wd/$1.bw";
				system "rm $wd/$bdg.clip";
				print "Done!\n"; 
			}	
	}

############################################################################################
exit;