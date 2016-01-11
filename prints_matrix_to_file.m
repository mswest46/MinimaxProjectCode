fid = fopen('myfile2.txt', 'wt'); % Open for writing
for i=1:size(sorted_incidence_matrix,1)
   fprintf(fid, '%d ', sorted_incidence_matrix(i,:));
   fprintf(fid, '\n');
end
fclose(fid);
