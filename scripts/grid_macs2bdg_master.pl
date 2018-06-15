#!/usr/bin/perl 
# Creates normalized peak signal track bigwig files for each sample from a consensus set of peaks
# Normalisation by fold enrichment, log likelihood or poisson q-value
# Required: *treat_pileup.bdg, *control_lambda.bdg, *.bed or *bam, mm10_chr_size.txt
# NB: Dont delete the bed files! you need them for calculating poisson q-value
# Kenneth Condon Mar 2017
############################################################################################
use strict;
use warnings;

# working with bed or bam files?
my $bedorbam = "$ARGV[0]" or die ("USAGE: perl grid_macs2bdg_master.pl [bed|bam] [full path to directory containing required files]\nRequired files - \n\tMACS2 INPUT:\t*_sorted_rmdup.bam or *.bed files\n\tMACS2 OUTPUT:\t*_control_lambda.bdg and *_treat_pileup.bdg\n");

# working directory
my $wd = "$ARGV[1]" or die ("USAGE: perl grid_macs2bdg_master.pl [bed|bam] [full path to directory containing required files]\nRequired files - \n\tMACS2 INPUT:\t*_sorted_rmdup.bam or *.bed files\n\tMACS2 OUTPUT:\t*_control_lambda.bdg and *_treat_pileup.bdg\n");
#"/home/k.condon/NGS_new/working_projects/Zfhx3_ChipSeq_v2/FASTQ_2_filtered/Macs_results_005_test";

# Slave script
my $slave_script = "/home/k.condon/NGS_new/UCSC_track_hubs/scripts/grid_macs2bdg_slave.pl";

# Submit jobs to the grid
opendir(DIR, $wd);
my @all_files = readdir(DIR);
close DIR;
foreach my $x(@all_files)
	{
 		if ($x =~ /^(.+)_sorted_rmdup\.bam$/)
 			{
 				print "qsub -cwd -j y -b yes -P NGS -N $1 -o $wd -pe big 6 perl $slave_script $wd $1 $bedorbam\n"; # on big q
 				# 8-10 hr runtime, not parallelised but needs memory from 6 cores
 			}
	}