;run after run_monthly_fft_orb, which saves the orbavg files
pro plot_fft_l2
  !EXCEPT=0 ; My NaN array causes overflow
  ; freq_range options: '9_11', '10_12', '11_13', '12_14' or ''
  ; 2018 dust storm ~7200-7500 (could be narrowed)
  ;restore,'result2014.sav'
  ;start_orbit_num=8306
  ;end_orbit_num=8820
  freq_range='5_16'
  number_of_points=0
  spice_frame='pl'
  month=10
  year=2014
  restore,'../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_400_gt_200/tensecavg/mvn_mag_l2_full_fft_tenavg_'+strtrim(string(year),2)+strtrim(string(month),2)+spice_frame+freq_range+'.sav'
;  q=plot(fft_lon_track,x_avg+y_avg+z_avg,'k',name='X+Y+Z Avg',sym='S');xrange=[start_orbit_num,end_orbit_num]
p=plot(fft_sza_track*360/!Pi,x_avg+y_avg+z_avg,'k',name='x',sym='S',/ylog,yrange=[0.01,1.0],xrange=[0,360])
; 
 ; p1=plot(fft_sza_track*360/!Pi,y_avg,'r',name='y',sym='S',/ylog,/overplot)
 ;p2=plot(fft_sza_track*360/!Pi,z_avg,'g',name='z',sym='S',/ylog,/overplot)
  ; leg = LEGEND(TARGET=[p,p1,p2],/DATA, /AUTO_TEXT_COLOR)
 ;number_of_points=number_of_points+n_elements(x_avg)

  for month=11,12 do begin

    if month lt 10 then begin
      month_str='0'+strtrim(string(month),2)
    endif else begin
      month_str=strtrim(string(month),2)
    endelse
    if file_search('../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_400_gt_200/tensecavg/mvn_mag_l2_full_fft_tenavg_'+strtrim(string(year),2)+month_str+spice_frame+freq_range+'.sav') ne '' then begin $
      restore,'../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_400_gt_200/tensecavg/mvn_mag_l2_full_fft_tenavg_'+strtrim(string(year),2)+month_str+spice_frame+freq_range+'.sav'
    ;  q=plot(fft_lon_track,x_avg+y_avg+z_avg,'k',name='X+Y+Z Avg', sym='S',/overplot);xrange=[start_orbit_num,end_orbit_num],
    p=plot(fft_sza_track*360/!Pi,x_avg+y_avg+z_avg,'k',name='x',sym='S',/overplot,yrange=[0.3,1],ylog=0)
 ;  p=plot(fft_sza_track*360/!Pi,y_avg,'r',name='y',sym='S',/overplot)
 ;  p=plot(fft_sza_track*360/!Pi,z_avg,'g',name='z',sym='S',/overplot)
 ;    number_of_points=number_of_points+n_elements(x_avg)
  endif

endfor



for year = 2015,2018 do begin
  for month=1,12 do begin
    
    if month lt 10 then begin
      month_str='0'+strtrim(string(month),2)
    endif else begin
      month_str=strtrim(string(month),2)
    endelse
    if file_search('../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_400_gt_200/tensecavg/mvn_mag_l2_full_fft_tenavg_'+strtrim(string(year),2)+month_str+spice_frame+freq_range+'.sav') ne '' then begin $
      restore,'../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_400_gt_200/tensecavg/mvn_mag_l2_full_fft_tenavg_'+strtrim(string(year),2)+month_str+spice_frame+freq_range+'.sav'
    
   if fft_orb_num(0) eq 6974 then begin 
   plot_indx=where(fft_orb_num ne 7098) ;5/23/2018
   ;q=plot(fft_lon_track(plot_indx),x_avg+y_avg+z_avg,'k',name='X+Y+Z Avg', sym='S',/overplot);xrange=[start_orbit_num,end_orbit_num],
   p=plot(fft_sza_track(plot_indx)*360/!Pi,x_avg(plot_indx)+y_avg(plot_indx)+z_avg(plot_indx),'k',name='x',sym='S',/overplot)
;   p=plot(fft_sza_track(plot_indx)*360/!Pi,y_avg(plot_indx),'r',name='y',sym='S',/overplot)
;   p=plot(fft_sza_track(plot_indx)*360/!Pi,z_avg(plot_indx),'g',name='z',sym='S',/overplot)
;     number_of_points=number_of_points+n_elements(x_avg(plot_indx))
     endif else begin
       p=plot(fft_sza_track*360/!Pi,x_avg+y_avg+z_avg,'k',name='x',sym='S',/overplot)
;       p=plot(fft_sza_track*360/!Pi,y_avg,'r',name='y',sym='S',/overplot)
;       p=plot(fft_sza_track*360/!Pi,z_avg,'g',name='z',sym='S',/overplot)
;       number_of_points=number_of_points+n_elements(x_avg)
      ; q=plot(fft_lon_track,x_avg+y_avg+z_avg,'k',name='X+Y+Z Avg', sym='S',/overplot);xrange=[start_orbit_num,end_orbit_num],

     endelse
  endif
endfor
endfor


year=2019
  for month=1,2 do begin

    if month lt 10 then begin
      month_str='0'+strtrim(string(month),2)
    endif else begin
      month_str=strtrim(string(month),2)
    endelse
    if file_search('../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_400_gt_200/tensecavg/mvn_mag_l2_full_fft_tenavg_'+strtrim(string(year),2)+month_str+spice_frame+freq_range+'.sav') ne '' then begin $
      restore,'../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_400_gt_200/tensecavg/mvn_mag_l2_full_fft_tenavg_'+strtrim(string(year),2)+month_str+spice_frame+freq_range+'.sav'
      ;q=plot(fft_lon_track,x_avg+y_avg+z_avg,'k',name='X+Y+Z Avg', sym='S',/overplot);xrange=[start_orbit_num,end_orbit_num],
    p=plot(fft_sza_track*360/!Pi,x_avg+y_avg+z_avg,'k',name='x',sym='S',/overplot)
   ; p=plot(fft_sza_track*360/!Pi,y_avg,'r',name='y',sym='S',/overplot)
   ;p=plot(fft_sza_track*360/!Pi,z_avg,'g',name='z',sym='S',/overplot)
    ; number_of_points=number_of_points+n_elements(x_avg)
  endif

endfor
;print,number_of_points
end