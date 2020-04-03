#!/usr/bin/perl

use warnings;
use strict;


# sliding window analysis

my $window_size = 400000;
my $window_step_size = 20000;
my $p_cutoff = 0.2;
#my $minimum_markers_in_bin = 5;
my $low_coverage_cutoff = 4;
my $high_coverage_cutoff = 30;
my $allele_score_scaling_factor = 3; #just to get nicer plots
my $allele_score_y_move = 1.0; #just to get nicer plots
 
my $input1 = $ARGV[0];
my $output1 = "$ARGV[0]".'_sliding_'."$window_size".'_'."$window_step_size".'_'."$p_cutoff".'.txt';
open (INFILE1, "<$input1") or die $!;
open (OUTFILE1, ">$output1") or die $!;

my $line = <INFILE1>; 
chomp($line);
my @a = split ("\t" , $line);
my $window_start = 0;
my $total_win_marker_count=1;
my $passed_win_marker_count;
my $total_pval_sum;
my $passed_pval_sum;
my $total_allele_sum_pool1 = $a[10];
my $total_allele_sum_pool2 = $a[11];
my $passed_allele_sum_pool1;
my $passed_allele_sum_pool2;
my $prev_pos;
 
while ( <INFILE1> ) {
   chomp;
   my @a = split;
   if ($a[2] > $low_coverage_cutoff && $a[7] > $low_coverage_cutoff && $a[2] < $high_coverage_cutoff && $a[7] < $high_coverage_cutoff && $a[1] > $window_start) {
   #print "$_\n";
   # reset values is out of range and print results
   if ($a[1] > $window_start + $window_size) { 
   #&& $passed_win_marker_count > $minimum_markers_in_bin) {
		my $avg_pos = $window_size / 2 + $window_start;
    	# calculate scores
    	my $total_pval_score;
    	my $passed_pval_score;
		my $total_allele_score;
		my $passed_allele_score;
		my $total_score;
		if ($passed_win_marker_count > 0 && $total_pval_sum > 0) {
			$total_pval_score = 1/ ($total_pval_sum / $total_win_marker_count) ;
			$passed_pval_score = (1/ ($passed_pval_sum / $passed_win_marker_count)) * ($passed_win_marker_count / $total_win_marker_count ) ;
       		$total_allele_score = (($total_allele_sum_pool1 / $total_win_marker_count) - ($total_allele_sum_pool2 / $total_win_marker_count)) * $allele_score_scaling_factor + $allele_score_y_move;
       		$passed_allele_score = (($passed_allele_sum_pool1 / $passed_win_marker_count) - ($passed_allele_sum_pool2 / $passed_win_marker_count)) * ($passed_win_marker_count / $total_win_marker_count ) ;
       		$total_score = $passed_allele_score * $passed_pval_score;
       }
       else {
       		$total_pval_score = 1;
       		$passed_pval_score = 0;
       		$total_allele_score = 1;
       		$passed_allele_score = 0;
       		$total_score = 0;
       		
       	}
       
       print OUTFILE1 "$a[0]\t$avg_pos\t$total_win_marker_count\t$passed_win_marker_count\t$total_pval_score\t$passed_pval_score\t$total_allele_score\t$passed_allele_score\t$total_score\t$prev_pos\t$window_start\n";
       
		$total_win_marker_count = 0;
		$passed_win_marker_count = 0;
		$total_pval_sum = 0;
		$passed_pval_sum = 0;
		$passed_allele_sum_pool1 = 0;
		$passed_allele_sum_pool2 = 0;
		$total_allele_sum_pool1 = 0;
		$total_allele_sum_pool2 = 0;
		
		$window_start += $window_step_size;
		
    	close INFILE1;
    	open (INFILE1, "<$input1") or die $!;
    	
    }
    
    # increase passed marker count and values, if markers passes    
    elsif ($a[13] < $p_cutoff) {
    $passed_win_marker_count++;
    $total_win_marker_count++;
    $passed_pval_sum += $a[13];
    $total_pval_sum += $a[13];
    $passed_allele_sum_pool1 += $a[10];
	$passed_allele_sum_pool2 += $a[11];
	$total_allele_sum_pool1 += $a[10];
	$total_allele_sum_pool2 += $a[11];
	#print "$passed_allele_sum_pool1\n";
    }
    
    else {
        $total_win_marker_count++;
        $total_pval_sum += $a[13];
        if ($a[10] ne "NA" && $a[11] ne "NA") { 
        	$total_allele_sum_pool1 += $a[10];
			$total_allele_sum_pool2 += $a[11];
      	}
      	$prev_pos = $a[1];
    }
  
  }
    
}




close INFILE1;
close OUTFILE1;

