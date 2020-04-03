#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;

### declare variables
my $input1 = $ARGV[0];
my $input2 = $ARGV[1];
my $output1 = $ARGV[2];
my $output2 = $ARGV[3];
my %entries; #hash
my $key = "";
my $value = "";
$"="\t";

### open files
print $input1, "\t", $input2, "\t", $output1, "\t", $output2, "\n";
open (INFILE1, "<$input1") or die $!;
open (INFILE2, "<$input2") or die $!;
open (OUTFILE1, ">$output1") or die $!;
open (OUTFILE2, ">$output2") or die $!;


### populate a hash with data from INFILE1:
while(my $line1 = <INFILE1>) {
	#remove \n
	chomp($line1);
	my @a = split "\t", $line1;
	$entries{"@a[0..1]"} = $line1;
}

while (my $line2 = <INFILE2>) {
	chomp($line2);
	my @a = split "\t", $line2;
	#position to look for
	$key = "@a[0..1]";
	my $value = "0";
	if (exists $entries{$key}) {
		print  OUTFILE1 "$entries{$key}\t$line2\n";
	}
	else {
	print  OUTFILE2 "$line2\n" ;
	}
}



### close files
close INFILE1;
close INFILE2;
close OUTFILE1;
close OUTFILE2;
