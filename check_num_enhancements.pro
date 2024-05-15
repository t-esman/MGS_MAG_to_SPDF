pro check_num_enhancements

count = 0
restore,'Documents\IDL\MGS_fft_results\full_results.sav'
sum_full_avg = full_avg_spec_x + full_avg_spec_y + full_avg_spec_z
where_enhanced = where(sum_full_avg gt 0.101) ;three standard dev is 0.051


for i = 0,n_elements(where_enhanced)-2 do begin
  if where_enhanced(i+1)-where_enhanced(i) ne 1 then count = count +1
endfor
print,count
;0.051 --> 307
;0.061 --> 150
;0.071 --> 138
;0.081
;0.091
;0.101 --> 78
end