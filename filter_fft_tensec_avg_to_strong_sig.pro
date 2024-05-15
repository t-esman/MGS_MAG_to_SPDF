pro filter_fft_tensec_avg_to_strong_sig
  ; My goal here is to find where the avg is ge power_limit
  ; So that I can load that data into mvn_mag_itplot and look at the signal

  !EXCEPT=0 ; My NaN array causes overflow
  power_limit=0.03
  spice_frame='pl'
  alt_filt=200
  freq_range='5_16'
  year = 2019
month=1
if month lt 10 then begin
  month_str='0'+strtrim(string(month),2)
endif else begin
  month_str=strtrim(string(month),2)
endelse
;start_orbit =8306
;end_orbit = 8820
  ;restore,'../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_'+strtrim(string(alt_filt),2)+'/tensecavg/mvn_mag_l2_full_fft_tenavg_orb'+strtrim(string(start_orbit),2)+'_'+spice_frame+freq_range+'.sav'
 ; restore,'../../../../Volumes/Tesman_WD/MAVEN/LowAlt/lt_'+strtrim(string(alt_filt),2)+'/tensecavg/mvn_mag_l1_full_fft_tenavg_orb'+strtrim(string(start_orbit),2)+'_'+spice_frame+freq_range+'.sav'
 ;restore,'../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_'+strtrim(string(alt_filt),2)+'/tensecavg/mvn_mag_l1_full_fft_tenavg_aerobraking_20190'+strtrim(string(month),2)+spice_frame+freq_range+'.sav'
 restore,'../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_400_gt_200/tensecavg/mvn_mag_l2_full_fft_tenavg_'+strtrim(string(year),2)+month_str+spice_frame+freq_range+'.sav'
 ;
  array_size=n_elements(x_avg)
  sm_to_plat= fltarr(array_size*2. )
  sm_to_plon= fltarr(array_size*2. )
  string_date=strarr(array_size*2.)
  sm_to_psza= fltarr(array_size*2. )
  date = fltarr(array_size*2.)
  orbit_num =  fltarr(array_size*2. )
  psza =  fltarr(array_size*2. )
  plat =  fltarr(array_size*2. )
  plon =  fltarr(array_size*2. )
  local_t =  fltarr(array_size*2. )
  x =  fltarr(array_size*2. )
  y =  fltarr(array_size*2. )
  z =  fltarr(array_size*2. )
  enhanced = CREATE_STRUCT('name','avg power record', 'orbit_num', orbit_num, 'psza', psza, $
    'plat',plat,'plon',plon,'x',x,'y',y,'z',z,'date',date)
  for month = 1, 2 do begin
    
    
    if month lt 10 then begin
      month_str='0'+strtrim(string(month),2)
    endif else begin
      month_str=strtrim(string(month),2)
    endelse
    if file_search('../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_400_gt_200/tensecavg/mvn_mag_l2_full_fft_tenavg_'+strtrim(string(year),2)+month_str+spice_frame+freq_range+'.sav') ne '' then begin
      restore,'../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_400_gt_200/tensecavg/mvn_mag_l2_full_fft_tenavg_'+strtrim(string(year),2)+month_str+spice_frame+freq_range+'.sav'


array_size=n_elements(x_avg)
      for i = 0,array_size-1 do begin
        if (x_avg(i) ge power_limit) || (y_avg(i) ge power_limit) || (z_avg(i) ge power_limit) then begin
          enhanced.orbit_num(i)=i
          enhanced.psza(i)=sm_to_psza(i)
          enhanced.plat(i)=sm_to_plat(i)
          enhanced.plon(i)=sm_to_plon(i)
          enhanced.x(i)=x_avg(i)
          enhanced.y(i)=y_avg(i)
          enhanced.z(i)=z_avg(i)
          enhanced.date(i)=fft_time_track(i)
        endif
      endfor
    endif
  endfor
array_size = n_elements(enhanced.date)
  date_count=0
  for i = 0,array_size-1 do begin
    if enhanced.date(i) ne 0 then begin
      time_structure=time_struct(enhanced.date(i))

      string_date(date_count)=strtrim(string(time_structure.month),2)+'-'+strtrim(string(time_structure.date),2)+$
        '-'+strtrim(string(time_structure.year),2)+'/'+strtrim(string(time_structure.hour),2)+':'+strtrim(string(time_structure.min),2)+$
        ':'+strtrim(string(time_structure.sec),2)
      date_count=date_count+1
    endif
  endfor
  string_date=string_date(uniq(string_date))

print,string_date
  save,filename='400distant_enhanced_array_tensec_'+strtrim(string(year),2)+'.sav',enhanced,string_date
end