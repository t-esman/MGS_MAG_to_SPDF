;This loads already altitude filtered data. 


pro run_monthly_fft_orb,spice_frame
year=2014
;2018 starts with 6330
;2014 ends with 512
;2019 starts with 8306
;for year=2015,2018 do begin
for i=10,12 do begin
  
  
    if i lt 10 then begin
      month='0'+strtrim(string(i),2)
    endif else begin
      month=strtrim(string(i),2)
    endelse

;  load_alt_filt,month,year,orb_x_avg,orb_y_avg,orb_z_avg,spice_frame
;  load_alt_filt_l1,month,year,orb_x_avg,orb_y_avg,orb_z_avg,spice_frame
 load_alt_filt_l2,month,year,orb_x_avg,orb_y_avg,orb_z_avg,spice_frame
;  plot_lat_lon,month,year,spice_frame

endfor ; i loop
;endfor ;year loop
end