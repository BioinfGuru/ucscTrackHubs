#!/usr/bin/perl 
# Creates fold enrichment, log likelihood and poisson q-value signal tracks as bigwig files
# Required: *treat_pileup.bdg, *control_lambda.bdg, *.bed/bam, mm10_chr_size.txt
# Kenneth Condon Mar 2017
############################################################################################
use strict;
use warnings;

# working directory
my $wd = "$ARGV[0]" or die ("USAGE: perl grid_macs2bdg_slave.pl [full path to directory containing required files] [sample prefix] [bed|bam]\nRequired files - \n\tMACS2 INPUT:\t*_sorted_rmdup.bam or *.bed files\n\tMACS2 OUTPUT:\t*_control_lambda.bdg and *_treat_pileup.bdg\n");

# store the path to MACS2 + bedClip (on the grid)
my $macs2 = "/usr/bin/macs2";
my $bedClip = "/home/k.condon/NGS_new/Software/blat_src/userApps/bin/bedClip";

# # Sample name
my $prefix = "$ARGV[1]"or die ("USAGE: perl grid_macs2bdg_slave.pl [full path to directory containing required files] [sample prefix] [bed|bam]\nRequired files - \n\tMACS2 INPUT:\t*_sorted_rmdup.bam or *.bed files\n\tMACS2 OUTPUT:\t*_control_lambda.bdg and *_treat_pileup.bdg\n");

# Input chromosome size file
my $chr_size = "/home/k.condon/NGS_new/musRefs_10/mm10_chr_size.txt";

###########################################################################################
# Create signal tracks + convert to bigwig
###########################################################################################

# prepare bdgcmp command to create bedgraphs for conversion to bigwig
my $bdgcmp = "$macs2 bdgcmp -t $wd/$prefix"."_treat_pileup.bdg -c $wd/$prefix"."_control_lambda.bdg --o-prefix $wd/$prefix";

# calculate scaling factor for poisson p/qpois bigwigs
my $bedorbam = "$ARGV[2]" or die ("USAGE: perl grid_macs2bdg_slave.pl [full path to directory containing required files] [sample prefix] [bed|bam]\nRequired files - \n\tMACS2 INPUT:\t*_sorted_rmdup.bam or *.bed files\n\tMACS2 OUTPUT:\t*_control_lambda.bdg and *_treat_pileup.bdg\n");

my $scaling_factor;

if ($bedorbam eq "bed")
	{
		my $mapped_reads = `wc -l <$wd/$prefix.bed`;	#####
		chomp $mapped_reads;							# counts reads per million in bed file used in callpeak -t option
		$scaling_factor=$mapped_reads/1000000;			#####
	}
		elsif ($bedorbam eq "bam")
			{	
				my $bam = "$wd/$prefix"."_sorted_rmdup.bam";
				my $mapped_reads = `samtools view -c -q 30 $bam`;
				chomp($mapped_reads);
				$scaling_factor = $mapped_reads/1000000;
			}

# create the signal track bedgraphs 				# UTAH runtime per sample
#system "$bdgcmp -m FE";							# 20 min			
#system "$bdgcmp -m logLR -p 0.0000000001";			# 15 min					
system "$bdgcmp -m ppois -S $scaling_factor";		# 20 min					
#system "$bdgcmp -m qpois -S $scaling_factor ";		# 20 min							

# ############################################################################################
# exit;


#	/usr/bin/macs2 bdgcmp
#	-t /home/k.condon/NGS_new/working_projects/Zfhx3_ChipSeq_v2/FASTQ_2_filtered/Macs_results_005_test/Zt3_treat_pileup.bdg
#	-c /home/k.condon/NGS_new/working_projects/Zfhx3_ChipSeq_v2/FASTQ_2_filtered/Macs_results_005_test/Zt3_control_lambda.bdg
#	--o-prefix /home/k.condon/NGS_new/working_projects/Zfhx3_ChipSeq_v2/FASTQ_2_filtered/Macs_results_005_test/Zt3
#	-m ppois
#	-S 22.494594