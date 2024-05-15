;run after run_monthly_fft_orb, which saves the orbavg files
pro plot_fft_sm_avg,spice_frame,freq_range
  !EXCEPT=0 ; My NaN array causes overflow
  ; freq_range options: '9_11', '10_12', '11_13', '12_14' or ''
  ; 2018 dust storm ~7200-7500 (could be narrowed)
  ;restore,'result2014.sav'
  start_orbit_num=6000
  end_orbit_num=6299
  restore,'../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_200/tensecavg/mvn_mag_l2_full_fft_tenavg_orb'+strtrim(string(start_orbit_num),2)+'_'+spice_frame+freq_range+'.sav'
   
   q=plot(sm_time,sm_x_avg+sm_y_avg+sm_z_avg,'k',name='X+Y+Z Avg', yrange=[0.4,1.2],sym='S');xrange=[start_orbit_num,end_orbit_num]
   ; p=plot(sm_time_prox,sm_x_avg,'b',name='x',sym='S')
    ;  p1=plot(sm_time_prox,sm_y_avg,'r',name='y',sym='S',/overplot)
     ;   p2=plot(sm_time_prox,sm_z_avg,'g',name='z',sym='S',/overplot)
      ;  leg = LEGEND(TARGET=[p,p1,p2],/DATA, /AUTO_TEXT_COLOR)
  for i = start_orbit_num+1,end_orbit_num do begin
  if file_search('../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_200/tensecavg/mvn_mag_l2_full_fft_tenavg_orb'+strtrim(string(i),2)+'_'+spice_frame+freq_range+'.sav') ne '' then begin $
  restore,'../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_200/tensecavg/mvn_mag_l2_full_fft_tenavg_orb'+strtrim(string(i),2)+'_'+spice_frame+freq_range+'.sav'
    q=plot(sm_time,sm_x_avg+sm_y_avg+sm_z_avg,'k',name='X+Y+Z Avg',yrange=[0.4,1.2], sym='S',/overplot);xrange=[start_orbit_num,end_orbit_num],
  ;  p=plot(sm_time_prox,sm_x_avg,'b',name='x',sym='S',/overplot)
   ;   p=plot(sm_time_prox,sm_y_avg,'r',name='y',sym='S',/overplot)
   ;     p=plot(sm_time_prox,sm_z_avg,'g',name='z',sym='S',/overplot)
        endif

endfor


end