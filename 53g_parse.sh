### set directory
dir='/u/vgupta/2011_jin_stig/110401_SN132_A_GPH-3-8/Sequences/'

### set read name variables
read_5_1="$dir"'110401_SN132_A_s_6_1_corrected_GPH-7.txt'
read_5_2="$dir"'110401_SN132_A_s_6_2_corrected_GPH-7.txt'
read_6_1="$dir"'110401_SN132_A_s_6_1_corrected_GPH-8.txt'
read_6_2="$dir"'110401_SN132_A_s_6_2_corrected_GPH-8.txt'

### generate test files
#cd "$dir"
#for y in 110401_SN132_A*;
#do nice -n 19 awk 'NR >= 1; NR == 1000 {exit}' $y > $y.txt
#done;

## tagdust all fastq files
echo ""
echo "--------- tagdust all fastq files ---------"
export PATH=$PATH:/u/vgupta/2011_jin_stig/programs/TagDust
cd "$dir"
for y in *.txt;
do nice -n 19 tagdust /u/vgupta/2011_jin_stig/programs/TagDust/test/solexa_paired_end_primers.fa $y -fdr 0.01 -a $y.dust;
done;

### make non-redundant dust lists
echo ""
echo "------- make non-redundant dust lists -----------"
nice -n 19 perl /u/vgupta/2011_jin_stig/scripts/55_parse.pl "$read_5_1".dust "$read_5_2".dust "$read_5_1".dust.nonred "$read_5_2".dust.nonred
nice -n 19 perl /u/vgupta/2011_jin_stig/scripts/55_parse.pl "$read_6_1".dust "$read_6_2".dust "$read_6_1".dust.nonred "$read_6_2".dust.nonred


### split original fastq file into tagdusted and dust fractions
echo ""
echo "--- split original fastq file into tagdusted and dust fractions -----"
cd "$dir"
for y in *.txt;
do nice -n 19 perl /u/vgupta/2011_jin_stig/scripts/54_parse.pl $y $y.dust.nonred $y.tagdusted.fq $y.dust.fq;
done;

### bowtie map tagdusted fastq files against ljrep sequences and filter sam alignment for hits
echo ""
echo "--- bowtie map against ljrep sequences -----"
cd "$dir"
for y in *.txt.tagdusted.fq;
do nice -n 19 bowtie -q --solexa1.3-quals --seedmms 3 --maqerr 800 --seedlen 32 -k 1 --sam --time --offbase 0 --threads 6 /u/vgupta/2011_jin_stig/ljr25/lotus_rep.fa $y $y.ljrep.temp.sam; nice -n 19 perl -lane 'print $_ if ($F[3] > 0)' $y.ljrep.temp.sam > $y.ljrep.sam; rm $y.ljrep.temp.sam;
done;

### make nonredundant list of lj_rep mapping tags
echo ""
echo "--- make nonredundant list of lj_rep mapping tags -----"
nice -n 19 perl /u/vgupta/2011_jin_stig/scripts/52_parse.pl "$read_5_1".tagdusted.fq.ljrep.sam "$read_5_2".tagdusted.fq.ljrep.sam "$read_5_1".tagdusted.fq.ljrep.nonred "$read_5_2".tagdusted.fq.ljrep.nonred
nice -n 19 perl /u/vgupta/2011_jin_stig/scripts/52_parse.pl "$read_6_1".tagdusted.fq.ljrep.sam "$read_6_2".tagdusted.fq.ljrep.sam "$read_6_1".tagdusted.fq.ljrep.nonred "$read_6_2".tagdusted.fq.ljrep.nonred


### split tagdusted fastq file into refiltered and repseq fractions
echo ""
echo "--- split tagdusted fastq file into refiltered and repseq fractions -----"
cd "$dir"
for y in *.txt.tagdusted.fq;
do nice -n 19 perl /u/vgupta/2011_jin_stig/scripts/54_parse.pl $y $y.ljrep.nonred $y.repfiltered.fq $y.repseq.fq;
done;

### remove temporary files
echo ""
echo "----- remove temporary files -----"
cd "$dir"
#rm *.txt
rm *.dust
rm *.nonred
rm *.sam
rm *.tagdusted.fq
