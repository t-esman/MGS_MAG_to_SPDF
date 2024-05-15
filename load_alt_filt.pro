;run by run_monthly_fft_orb.pro in order to get orbavg
;runs tme_filt_fft
pro load_alt_filt,month,year,orb_x_avg, orb_y_avg, orb_z_avg,spice_frame, month2=month2
  fft_time = 1
  plot_time = 0
  alt_filt = 200
  freq_range='' ; '' means 9 - 14
  orb_x_avg=make_array(8000,value=!values.F_NAN)
  orb_y_avg=make_array(8000,value=!values.F_NAN)
  orb_z_avg=make_array(8000,value=!values.F_NAN)

  ;if ~keyword_set(year) then year = 2018

  if ~keyword_set(month2) then $
    restore,'../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_'+strtrim(string(alt_filt),2)+'/'+strtrim(string(year),2)+'/mvn_mag_l2_lt_'+strtrim(string(alt_filt),2)+'_full_'+strtrim(string(year),2)+month+'_'+spice_frame+'.sav'
  if keyword_set(month2) then $
    restore,'../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_'+strtrim(string(alt_filt),2)+'/'+strtrim(string(year),2)+'/mvn_mag_l2_lt_'+strtrim(string(alt_filt),2)+'_full_'+strtrim(string(year),2)+month+month2+'_'+spice_frame+'.sav'

  ; dataorb = {x:time, y:orb_num}
  dataalt = {x:time, y:altitude}
  datax = {x:time, y:x_vec}
  datay = {x:time, y:y_vec}
  dataz = {x:time, y:z_vec}
  datamag = {x:time, y:bmag}


  if fft_time eq 1 then begin
    ;store_data, 'mvn_B_full_filt_orb',data=dataorb,dlim=dlim
    store_data, 'mvn_B_full_filt_mag', data=datamag, dlim=dlim
    store_data, 'mvn_B_full_filt_x', data=datax, dlim=dlim
    store_data, 'mvn_B_full_filt_y', data=datay, dlim=dlim
    store_data, 'mvn_B_full_filt_z', data=dataz, dlim=dlim
    store_data, 'mvn_B_full_filt_alt', data=dataalt,dlim=dlim
  endif
  ;for orb_count = orb_num(0),orbnum(n_elements(orbnum)-1) do begin

  if plot_time eq 1 then begin
    if month eq '01' then p=plot(orb_num, orb_num, 'r', name='altitude', sym='S')
    if month ne '01' then $
      p=plot(orb_num, orb_num,'r',name='altitude',sym='S',/overplot)

  endif
  orb_num=round(orb_num) ; need to rerun all these


  if fft_time eq 1 then begin
    tme_filt_fft,orb_num,x_avg,y_avg,z_avg,fft_orb_num,fft_time_track
    start_orbit=orb_num(0)
    end_orbit=orb_num(n_elements(orb_num)-1)


;    ;Average for an entire orbit
;    for i = start_orbit,end_orbit do begin
;      orb_indx=where(fft_orb_num eq i)
;      if orb_indx(0) ne -1 then begin
;        ;x= n_elements(where(fft_orb_num eq i)) ;find how many seconds are available
;        if i eq 27 then begin
;          print,'stop'
;        endif
;
;        orb_x_avg(i)=mean(x_avg(orb_indx))
;        orb_y_avg(i)=mean(y_avg(orb_indx))
;        orb_z_avg(i)=mean(z_avg(orb_indx))
;
;      endif
;    endfor
;    ;
    ;Average for ...? 10 seconds

    
    for i = start_orbit,end_orbit do begin
      orb_indx=where(fft_orb_num eq i)
      if orb_indx(0) ne -1 then begin
        indx_count=0
        sm_x_avg=make_array(800,value=!values.F_NAN)
        sm_y_avg=make_array(800,value=!values.F_NAN)
        sm_z_avg=make_array(800,value=!values.F_NAN)
        sm_time_prox=make_array(800,value=!values.F_NAN)
        sm_time=make_array(800,value=!values.F_NAN)
        orb_seconds=n_elements(orb_indx) ; number of seconds in the orbit

        for orb_sec_length = 0,orb_seconds-10,5 do begin
          sm_x_avg(indx_count)=mean(x_avg(orb_indx(orb_sec_length):orb_indx(orb_sec_length+9)))
          sm_y_avg(indx_count)=mean(y_avg(orb_indx(orb_sec_length):orb_indx(orb_sec_length+9)))
          sm_z_avg(indx_count)=mean(z_avg(orb_indx(orb_sec_length):orb_indx(orb_sec_length+9)))
          sm_time_prox(indx_count)=i+100.0/(150.1-(indx_count/10.0))
          sm_time(indx_count)=fft_time_track(orb_indx(orb_sec_length))
          indx_count++
          
        endfor
        if ~isa(orb_seconds/5.0,/int) then begin
          sm_x_avg(indx_count)=mean(x_avg(orb_indx(orb_seconds-10):orb_indx(orb_seconds-1)))
          sm_y_avg(indx_count)=mean(y_avg(orb_indx(orb_seconds-10):orb_indx(orb_seconds-1)))
          sm_z_avg(indx_count)=mean(z_avg(orb_indx(orb_seconds-10):orb_indx(orb_seconds-1)))
           sm_time_prox(indx_count)=i+100.0/(150.1-(indx_count/10.0))
           sm_time(indx_count)=fft_time_track(orb_indx(orb_seconds-10))
        endif

        save,filename='../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_'+strtrim(string(alt_filt),2)+'/tensecavg/mvn_mag_l2_full_fft_tenavg_orb'+strtrim(string(i),2)+'_'+spice_frame+freq_range+'.sav',$
          sm_x_avg,sm_y_avg,sm_z_avg,sm_time_prox,sm_time

      endif
    endfor

    ;   print,'Saving file'
    ;   save,filename='../../../../Volumes/Tesman_WD/MAVEN/schumann_search/lt_'+strtrim(string(alt_filt),2)+'/orbavg/mvn_mag_l2_full_fft_orbavg_'+strtrim(string(year),2)+month+'_'+spice_frame+freq_range+'.sav',orb_x_avg,orb_y_avg,orb_z_avg
  endif


end

