input_file = '/Users/sua/Documents/Stig_aarhus/Lab_lists/Journal_files/2011_07_26/gph7/gph7_gph8_for_r.txt' 

### Read Data
table <- read.table(input_file)

d <- cbind(table[,4],table[,5],table[,9],table[,10])

### initialize p_values object
p_values <- numeric(0)

		
### create contingency tables and run Fisher tests
for (i in 1:length(d[,1]))
		{ 
		line <- as.numeric(d[i,])
		t <- matrix (line, nr=2)
		p_values =  rbind(p_values,fisher.test(t)$p.value)
		}
		
final <- cbind(table,0.5-table[,4]/(table[,4]+table[,5]), 0.5-table[,9]/(table[,9]+table[,10]),(0.5-table[,4]/(table[,4]+table[,5]))-( 0.5-table[,9]/(table[,9]+table[,10])),p_values)


### print the results to file
# ouput format: <chr>	<position>	<coverage_pool1>	<parentA_allele_count_pool1>	<parentB_allele_count_pool1> 	<chr>	<position>	<coverage_pool2>	<parentA_allele_count_pool2>	<parentB_allele_count_pool2>	<percentage_parentA_pool1>	<percentage_parentA_pool2>	<difference_percentage_parentA_pool1-pool2>	<p_value_Fisher's_exact_test>

## for perl processing
write.table(final, file ="/Users/sua/Documents/Stig_aarhus/Lab_lists/Journal_files/2011_07_26/gph7/gph7_gph8_r_out.txt", row.names = FALSE, col.names = FALSE, sep ="\t", quote = FALSE, dec=".")

## for opening in excel
write.table(final, file ="/Users/sua/Documents/Stig_aarhus/Lab_lists/Journal_files/2011_07_26/gph7/gph7_gph8_r_out_excel.txt", row.names = FALSE, col.names = FALSE, sep ="\t", quote = FALSE, dec=",")



