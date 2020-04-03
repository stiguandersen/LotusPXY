#!/usr/bin/perl
use warnings;
use strict;

my $input=$ARGV[0];
my $output1=$ARGV[1];

my $low_cutoff = 2;
my $high_cutoff = 40;

### open files
open (INFILE, "<$input") or die $!;
open (OUTFILE, ">$output1") or die $!;


while(my $line = <INFILE>) {
	chomp ($line);
	my @a = split "\t", $line;
	my $A = (lc($a[8]) =~ tr/a/a/);
	my $C = (lc($a[8]) =~ tr/c/c/);
	my $G = (lc($a[8]) =~ tr/g/g/);
	my $T = (lc($a[8]) =~ tr/t/t/);
	my $ref = (lc($a[8]) =~ tr/\.\,/\.\,/);
	
	if ($a[2] eq "A") {
		$A =$ref;
		my $parentA = eval('$'."$a[14]"); #gets the parentA basecount
		my $parentB = eval('$'."$a[17]"); #gets the parentB basecount
		print OUTFILE "$a[0]\t$a[1]\t$a[7]\t$parentA\t$parentB\n"; 
	}
	
	if ($a[2] eq "C") {
		$C =$ref;
		my $parentA = eval('$'."$a[14]"); #gets the parentA basecount
		my $parentB = eval('$'."$a[17]"); #gets the parentB basecount
		print OUTFILE "$a[0]\t$a[1]\t$a[7]\t$parentA\t$parentB\n"; 
	}
	
	if ($a[2] eq "G") {
		$G =$ref;
		my $parentA = eval('$'."$a[14]"); #gets the parentA basecount
		my $parentB = eval('$'."$a[17]"); #gets the parentB basecount
		print OUTFILE "$a[0]\t$a[1]\t$a[7]\t$parentA\t$parentB\n"; 
	}
	
	if ($a[2] eq "T") {
		$T =$ref;
		my $parentA = eval('$'."$a[14]"); #gets the parentA basecount
		my $parentB = eval('$'."$a[17]"); #gets the parentB basecount
		print OUTFILE "$a[0]\t$a[1]\t$a[7]\t$parentA\t$parentB\n"; 
	}
	
}

# close files
close INFILE;
close OUTFILE;

