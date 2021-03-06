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
	$line1 =~ /(^\@)(.+)(\/1)/; #adds only the read name to hash using the special variable $2
	#populate hash
	$entries{$2}++ if $line1 =~ m/(^\@)(.+)(\/1)/;
}

### add data from INFILE2 to hash:
while(my $line2 = <INFILE2>) {
	#remove \n
	chomp($line2);
	$line2 =~ /(^\@)(.+)(\/2)/;
	#populate hash
	$entries{$2}++ if $line2 =~ m/(^\@)(.+)(\/2)/;
}

### print only unique read names
while (($key, $value) = each(%entries)){
	print OUTFILE1 $key , "\n" if $key ne "";
	print OUTFILE2 $key , "\n" if $key ne "";
	# print OUTFILE1 $key , "\t", $value , "\n" if $key ne "";
	# to add information on how many times each read was seen (1 or 2)
}


### close files
close INFILE1;
close INFILE2;
close OUTFILE1;
close OUTFILE2;
