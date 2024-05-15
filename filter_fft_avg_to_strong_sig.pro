pro filter_fft_avg_to_strong_sig
  ; My goal here is to find where the avg is ge power_limit and record that orbit number and date
  ; So that I can load that data into mvn_mag_itplot and look at the signal

  !EXCEPT=0 ; My NaN array causes overflow
  power_limit=0.14
  spice_frame='mso'
alt_filt=200

  restore,'ResultYearly/result2014.sav'
  restore,'../../../../Volumes/ExtremeSSD/MAVEN/schumann_search/lt_200/orbavg/mvn_mag_l2_full_fft_orbavg_201409_'+spice_frame+'.sav'
  
  
  ;restore,'../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_'+strtrim(string(alt_filt),2)+'/tensecavg/mvn_mag_l2_full_fft_tenavg_orb'+strtrim(string(i),2)+'_'+spice_frame+freq_range+'.sav',$

  array_size=n_elements(orb_x_avg)
  orb_to_ls = fltarr(array_size )
  orb_to_plat= fltarr(array_size )
  orb_to_plon= fltarr(array_size )
  string_date=strarr(array_size)
  orb_to_psza= fltarr(array_size )
  orb_to_lt= fltarr(array_size)
  orb_to_date=fltarr(array_size)
  orb_round = round(dataorb.y(peri_indx)) ; the orbit number for peri_indx

  date = fltarr(array_size)
  orbit_num =  fltarr(array_size )
  psza =  fltarr(array_size )
  lsol =  fltarr(array_size )
  plat =  fltarr(array_size )
  plon =  fltarr(array_size )
  local_t =  fltarr(array_size )
  x =  fltarr(array_size )
  y =  fltarr(array_size )
  z =  fltarr(array_size )
  enhanced = CREATE_STRUCT('name','avg power record', 'orbit_num', orbit_num, 'psza', psza, $
    'ls', lsol,'plat',plat,'plon',plon,'local_t',local_t,'x',x,'y',y,'z',z,'date',date)

  year = 2014
  for count = 9,12 do begin
    if count lt 10 then begin
      month='0'+strtrim(string(count),2)
    endif else begin
      month=strtrim(string(count),2)
    endelse

    restore,'../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_200/orbavg/mvn_mag_l2_full_fft_orbavg_'+strtrim(string(year),2)+month+'_'+spice_frame+'.sav'
    orb_round = round(dataorb.y(peri_indx)) ; the orbit number for peri_indx

    for orbit_number = 0,n_elements(orb_x_avg)-1 do begin
      if finite(orb_x_avg(orbit_number)) then begin
        new_indx= where(orb_round eq orbit_number) ; figure out which peri_indx to use
        if new_indx(0) eq -1 then begin
          print,'stop'
        endif
        orb_to_psza(orbit_number) = datapsza.y(new_indx)
        orb_to_ls(orbit_number) = datals.y(new_indx)
        orb_to_plat(orbit_number) = dataplat.y(new_indx)
        orb_to_plon(orbit_number) = dataplon.y(new_indx)
        orb_to_lt(orbit_number) = datalst.y(new_indx)
        orb_to_date(orbit_number) = float(datapsza.x(new_indx))
      endif
    endfor

    for i = 0,array_size-1 do begin
      if (orb_x_avg(i) ge power_limit) then begin;|| (orb_y_avg(i) ge power_limit) || (orb_z_avg(i) ge power_limit) then begin
        enhanced.orbit_num(i)=i
        enhanced.psza(i)=orb_to_psza(i)
        enhanced.ls(i)=orb_to_ls(i)
        enhanced.plat(i)=orb_to_plat(i)
        enhanced.plon(i)=orb_to_plon(i)
        enhanced.local_t(i)=orb_to_lt(i)
        enhanced.x(i)=orb_x_avg(i)
        enhanced.y(i)=orb_y_avg(i)
        enhanced.z(i)=orb_z_avg(i)
        enhanced.date(i)=orb_to_date(i)
      endif
    endfor
  endfor


  for year = 2015,2017 do begin
    for count = 1,12 do begin
      if count lt 10 then begin
        month='0'+strtrim(string(count),2)
      endif else begin
        month=strtrim(string(count),2)
      endelse

      restore,'result'+strtrim(string(year),2)+'.sav'
      restore,'../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_200/orbavg/mvn_mag_l2_full_fft_orbavg_'+strtrim(string(year),2)+month+'_'+spice_frame+'.sav'

      orb_round = round(dataorb.y(peri_indx)) ; the orbit number for peri_indx

      for orbit_number = 0,n_elements(orb_x_avg)-1 do begin
        if finite(orb_x_avg(orbit_number)) then begin
          new_indx= where(orb_round eq orbit_number) ; figure out which peri_indx to use
          if new_indx(0) eq -1 then begin
            print,'stop'
          endif
          orb_to_psza(orbit_number) = datapsza.y(new_indx)
          orb_to_ls(orbit_number) = datals.y(new_indx)
          orb_to_plat(orbit_number) = dataplat.y(new_indx)
          orb_to_plon(orbit_number) = dataplon.y(new_indx)
          orb_to_lt(orbit_number) = datalst.y(new_indx)
          orb_to_date(orbit_number) = float(datapsza.x(new_indx))
        endif
      endfor

      for i = 0,n_elements(orb_x_avg)-1 do begin
        if orb_x_avg(i) ge power_limit then begin;|| orb_y_avg(i) ge power_limit || orb_z_avg(i) ge power_limit then begin
          enhanced.orbit_num(i)=i
          enhanced.psza(i)=orb_to_psza(i)
          enhanced.ls(i)=orb_to_ls(i)
          enhanced.plat(i)=orb_to_plat(i)
          enhanced.plon(i)=orb_to_plon(i)
          enhanced.local_t(i)=orb_to_lt(i)
          enhanced.x(i)=orb_x_avg(i)
          enhanced.y(i)=orb_y_avg(i)
          enhanced.z(i)=orb_z_avg(i)
          enhanced.date(i)=orb_to_date(i)
        endif
      endfor
    endfor
  endfor

  year = 2018
  for i = 1,8 do begin
    if i lt 10 then begin
      month='0'+strtrim(string(i),2)
    endif else begin
      month=strtrim(string(i),2)
    endelse

    restore,'result'+strtrim(string(year),2)+'.sav'
    restore,'../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_200/orbavg/mvn_mag_l2_full_fft_orbavg_'+strtrim(string(year),2)+month+'_'+spice_frame+'.sav'
    orb_round = round(dataorb.y(peri_indx)) ; the orbit number for peri_indx

    for orbit_number = 0,n_elements(orb_x_avg)-1 do begin
      if finite(orb_x_avg(orbit_number)) then begin
        new_indx= where(orb_round eq orbit_number) ; figure out which peri_indx to use
        if new_indx(0) eq -1 then begin
          print,'stop'
        endif
        orb_to_psza(orbit_number) = datapsza.y(new_indx)
        orb_to_ls(orbit_number) = datals.y(new_indx)
        orb_to_plat(orbit_number) = dataplat.y(new_indx)
        orb_to_plon(orbit_number) = dataplon.y(new_indx)
        orb_to_lt(orbit_number) = datalst.y(new_indx)
        orb_to_date(orbit_number) = float(datapsza.x(new_indx))
      endif
    endfor

    for i = 0,n_elements(orb_x_avg)-1 do begin
      if orb_x_avg(i) ge power_limit then begin;|| orb_y_avg(i) ge power_limit || orb_z_avg(i) ge power_limit then begin
        enhanced.orbit_num(i)=i
        enhanced.psza(i)=orb_to_psza(i)
        enhanced.ls(i)=orb_to_ls(i)
        enhanced.plat(i)=orb_to_plat(i)
        enhanced.plon(i)=orb_to_plon(i)
        enhanced.local_t(i)=orb_to_lt(i)
        enhanced.x(i)=orb_x_avg(i)
        enhanced.y(i)=orb_y_avg(i)
        enhanced.z(i)=orb_z_avg(i)
        enhanced.date(i)=orb_to_date(i)
      endif
    endfor
  endfor
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


  save,filename='enhanced_array.sav',enhanced,string_date
end