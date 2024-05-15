;run after run_monthly_fft_orb, which saves the orbavg files
pro plot_fft_avg,spice_frame,freq_range
  !EXCEPT=0 ; My NaN array causes overflow
; freq_range options: '9_11', '10_12', '11_13', '12_14' or ''
  restore,'result2014.sav'
  restore,'../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_200/orbavg/mvn_mag_l2_full_fft_orbavg_201409_'+spice_frame+freq_range+'.sav'
  orb_to_ls = make_array(n_elements(orb_x_avg),value=!values.F_NAN)
  orb_to_plat= make_array(n_elements(orb_x_avg),value=!values.F_NAN)
  orb_to_plon= make_array(n_elements(orb_x_avg),value=!values.F_NAN)
  orb_to_psza= make_array(n_elements(orb_x_avg),value=!values.F_NAN)
  orb_to_lt= make_array(n_elements(orb_x_avg),value=!values.F_NAN)
 
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
    endif
  endfor
 
 p=plot(orb_x_avg,'b',name='x',sym='S')
; p=plot(orb_to_plat,orb_x_avg+orb_y_avg+orb_x_avg,'b',name='sum',sym='S')
 ; p=plot(orb_to_lt,orb_x_avg,'b',name='x',sym='S')
;p=plot(orb_to_plon,'b',name='x',sym='S')
  year = 2014
  for month = 10,12 do begin

    ; restore,'result2014.sav'
    ;restores ls, lst, lt, orb, plat, plon, psza, and orbit info for 9-12/2014
    restore,'../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_200/orbavg/mvn_mag_l2_full_fft_orbavg_'+strtrim(string(year),2)+strtrim(string(month),2)+'_'+spice_frame+freq_range+'.sav'
    ;restores orb_x_avg, orb_y_avg, and orb_z_avg, which are the fft avg per orbit where the indx is the orbit number
    ;periapse at start of orbit (confirm)
    ;peri_indx is the indx of periapse for the orbit data arrays
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
      endif
    endfor

   ; p=plot(orb_to_lt,orb_x_avg,'b',sym='S',/overplot)
;p=plot(orb_to_plon,'b',sym='S',/overplot)
;p=plot(orb_to_plat,orb_x_avg+orb_y_avg+orb_x_avg,'b',sym='S',/overplot)
p=plot(orb_x_avg,'b',sym='S',/overplot)
  endfor



  for year = 2015,2017 do begin
    for i = 1,12 do begin
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
        endif
      endfor

     ; p=plot(orb_to_lt,orb_x_avg,'b',sym='S',/overplot)
p=plot(orb_x_avg,'b',sym='S',/overplot)
  ;   p=plot(orb_to_plat,orb_x_avg+orb_y_avg+orb_x_avg,'b',sym='S',/overplot)
;p=plot(orb_to_plon,'b',sym='S',/overplot)
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
      endif
    endfor
   ; p=plot(orb_to_lt,orb_x_avg,'b',sym='S',/overplot)
  ; p=plot(orb_to_plat,orb_x_avg+orb_y_avg+orb_x_avg,'b',sym='S',/overplot)
p=plot(orb_x_avg,'b',sym='S',/overplot)
;p=plot(orb_to_plon,'b',sym='S',/overplot)
  endfor
;;;;;;;;;;;;;;;;;;; y ;;;;;;;;;;;;;;;;;;

  restore,'../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_200/orbavg/mvn_mag_l2_full_fft_orbavg_201409_'+spice_frame+'.sav'
  restore,'result2014.sav'
  orb_round = round(dataorb.y(peri_indx)) ; the orbit number for peri_indx
  orb_to_ls = make_array(n_elements(orb_x_avg),value=!values.F_NAN)
  orb_to_plat= make_array(n_elements(orb_x_avg),value=!values.F_NAN)
  orb_to_plon= make_array(n_elements(orb_x_avg),value=!values.F_NAN)
  orb_to_psza= make_array(n_elements(orb_x_avg),value=!values.F_NAN)
  orb_to_lt= make_array(n_elements(orb_x_avg),value=!values.F_NAN)
  
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
    endif
  endfor

 ; p=plot(orb_to_lt,orb_y_avg,'r',name='y',sym='S',/overplot)
p=plot(orb_y_avg,'r',sym='S',/overplot)
  year = 2014
  for month = 10,12 do begin


    restore,'../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_200/orbavg/mvn_mag_l2_full_fft_orbavg_'+strtrim(string(year),2)+strtrim(string(month),2)+'_'+spice_frame+'.sav'
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
      endif
    endfor
   ; p=plot(orb_to_lt,orb_y_avg,'r',sym='S',/overplot)
p=plot(orb_y_avg,'r',sym='S',/overplot)
  endfor


  ;
  for year = 2015,2017 do begin
    for i = 1,12 do begin
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
        endif
      endfor
    ;  p=plot(orb_to_lt,orb_y_avg,'r',sym='S',/overplot)
p=plot(orb_y_avg,'r',sym='S',/overplot)
    endfor
  endfor

  year = 2018
  for i = 1,8 do begin
    if i lt 10 then begin
      month='0'+strtrim(string(i),2)
    endif else begin
      month=strtrim(string(i),2)
    endelse
    restore,'result2018.sav'

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
      endif
    endfor
   ; p=plot(orb_to_lt,orb_y_avg,'r',sym='S',/overplot)
p=plot(orb_y_avg,'r',sym='S',/overplot)
  endfor
;

;;;;;;;;;;;;;;;;;;;;;;;; z;;;;;;;;;;;;;;;;
  restore,'../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_200/orbavg/mvn_mag_l2_full_fft_orbavg_201409_'+spice_frame+'.sav'
restore,'result2014.sav'
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
  endif
endfor
  ;p=plot(orb_to_lt,orb_z_avg,'g',name='z',sym='S',/overplot)
p=plot(orb_z_avg,'g',sym='S',/overplot)
  year = 2014
  for month = 10,12 do begin


    restore,'../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_200/orbavg/mvn_mag_l2_full_fft_orbavg_'+strtrim(string(year),2)+strtrim(string(month),2)+'_'+spice_frame+'.sav'
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
      endif
    endfor
   ; p=plot(orb_to_lt,orb_z_avg,'g',sym='S',/overplot)
p=plot(orb_z_avg,'g',sym='S',/overplot)
  endfor


  ;
  for year = 2015,2017 do begin
    for i = 1,12 do begin
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
        endif
      endfor
    ;  p=plot(orb_to_lt,orb_z_avg,'g',sym='S',/overplot)
p=plot(orb_z_avg,'g',sym='S',/overplot)
    endfor
  endfor

  year = 2018
  for i = 1,8 do begin
    if i lt 10 then begin
      month='0'+strtrim(string(i),2)
    endif else begin
      month=strtrim(string(i),2)
    endelse

restore,'result2018.sav'
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
      endif
    endfor
  ;  p=plot(orb_to_lt,orb_z_avg,'g',sym='S',/overplot)
p=plot(orb_z_avg,'g',sym='S',/overplot)
  endfor




end