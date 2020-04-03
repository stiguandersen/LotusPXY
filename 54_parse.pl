#!/usr/bin/perl
use strict;
#use diagnostics;

### declare variables
my $input1=$ARGV[0];
my $input2=$ARGV[1];
my $output1=$ARGV[2];
my $output2=$ARGV[3];

my %entries; #hash
my $key = "";
my $value = "";

### open files
print "\n$input1\t$input2\n";
open (INFILE1, "<$input1") or die $!;
open (INFILE2, "<$input2") or die $!;
open (OUTFILE1, ">$output1") or die $!;
open (OUTFILE2, ">$output2") or die $!;


### populate hash with data from INFILE2 (repetitive read names list):
while(my $line2 = <INFILE2>) {
	#remove \n
	chomp($line2);
	$entries{$line2}++;
}

### check up that the right things are in the hash
#while (($key, $value) = each(%entries)){
#	print $key , "\n";
#}

### sort fastq file so that reads on the repetitive list go into the repseq file and the rest go into the repfiltered file
while (my $line1 = <INFILE1>) {
	# extract the read name from the line 
	$line1 =~ /(^.)(.+)(\/.)/;
	my $read_name = $2;
	#print $read_name, "\n";
	# put reads in repseq file if the read name is found in the hash
	if (exists $entries{$read_name}) {print OUTFILE2 $line1; my $nextline = <INFILE1>; print OUTFILE2 $nextline;
	}
	# the $nextline variable is needed to get the sequences and quality values printed in the repseq file by reading in the next line of the infile.
	# put the non-matching reads in the repfiltered file
	else {
	print  OUTFILE1 $line1;
	}
}


### close files
close INFILE1;
close INFILE2;
close OUTFILE1;
