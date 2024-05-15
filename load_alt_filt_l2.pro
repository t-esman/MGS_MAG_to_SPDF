;run by run_monthly_fft_orb.pro in order to get orbavg
;runs tme_filt_fft
pro load_alt_filt_l2,month,year,orb_x_avg, orb_y_avg, orb_z_avg,spice_frame, month2=month2
  fft_time = 1
  plot_time = 0
  ;alt_filt = 400
  freq_range='5_16' ; '' means 9 - 14
  ;orb_x_avg=make_array(8000,value=!values.F_NAN)
  ;orb_y_avg=make_array(8000,value=!values.F_NAN)
  ;orb_z_avg=make_array(8000,value=!values.F_NAN)

restore,'ResultYearly/result'+strtrim(string(year),2)+'.sav'
;  restore,'../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_'+strtrim(string(alt_filt),2)+'/'+strtrim(string(year),2)+'/mvn_mag_l2_lt_'$
 ;   +strtrim(string(alt_filt),2)+'_full_'+strtrim(string(year),2)+month+'_'+spice_frame+'.sav'
  restore,'../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_400_gt_200/'+strtrim(string(year),2)+'/mvn_mag_l2_lt_400_gt_200_full_'+strtrim(string(year),2)+month+'_'+spice_frame+'.sav'


  ; dataorb = {x:time, y:orb_num}
 ; dataalt = {x:time, y:altitude}
  datax = {x:time, y:x_vec}
  datay = {x:time, y:y_vec}
  dataz = {x:time, y:z_vec}
 ; datamag = {x:time, y:bmag}

  ;store_data, 'mvn_B_full_filt_mag', data=datamag, dlim=dlim
  store_data, 'mvn_B_full_filt_x', data=datax, dlim=dlim
  store_data, 'mvn_B_full_filt_y', data=datay, dlim=dlim
  store_data, 'mvn_B_full_filt_z', data=dataz, dlim=dlim
  ;store_data, 'mvn_B_full_filt_alt', data=dataalt,dlim=dlim

  orb_num=round(orb_num)

  tme_filt_fft,orb_num,altitude,latitude,longitude,sza,x_avg,y_avg,z_avg,fft_orb_num,fft_time_track,fft_alt_track,$
    fft_sza_track,fft_lon_track,fft_lat_track
  start_orbit=orb_num(0)
  end_orbit=orb_num(n_elements(orb_num)-1)

;remove,0,fft_time_track
;  save,filename='../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_'+strtrim(string(alt_filt),2)+'/tensecavg/mvn_mag_l2_full_fft_tenavg_'+strtrim(string(year),2)+month+spice_frame+freq_range+'.sav',$
 ;   x_avg,y_avg,z_avg,fft_orb_num,fft_time_track,fft_alt_track,fft_sza_track,fft_lon_track,fft_lat_track
   save,filename='../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_400_gt_200/tensecavg/mvn_mag_l2_full_fft_tenavg_'+strtrim(string(year),2)+month+spice_frame+freq_range+'.sav',$
 x_avg,y_avg,z_avg,fft_orb_num,fft_time_track,fft_alt_track,fft_sza_track,fft_lon_track,fft_lat_track
;restore,'totaltimecountlowalt.sav'
;time_total=[time_total,n_elements(dataz.x)/32.0]
;save,filename='totaltimecountlowalt.sav',time_total
end

