; filter .tplot files by altitude
;after this, should run run_monthly_fft_orb.pro
pro alt_filter_mvnmag_tplot,alt_limit=alt_limit,spice_frame
alt_filt=400

  if ~keyword_set(alt_limit) then alt_limit=200
; for year_num = 1 do begin
 year_num=6
  if year_num eq 1 then year='2014' ;
  if year_num eq 2 then year='2015' ;
  if year_num eq 3 then year='2016' ;
  if year_num eq 4 then year='2017' ;
  if year_num eq 5 then year='2018' ;
  if year_num eq 6 then year='2019'
 ; year = '2015'
 numb_month = 1
  for month_numb = 1,2 do begin
    ; month_numb=11
    if month_numb lt 10 then begin
      month='0'+strtrim(string(month_numb),2)
    endif else begin
      month=strtrim(string(month_numb),2)
    endelse


    restore,'ResultYearly/result'+year+'.sav'
    latitude=result.lat
    longitude=result.lon
    sza=result.sza
    altitude=result.hgt
    time=result.t
    daily_time=[]
    x_vec=[]
    y_vec=[]
    z_vec=[]
    orb_num=dataorb.y

    if numb_month eq 1 then begin
      for i=1,9 do begin
       name='../../../../Volumes/ExtremeSSD/MAVEN/tplot_files/mag/'+spice_frame+'/'+year+'/mvn_mag_l2_pl_full_'+year+month+'0'+strtrim(string(i),2)+'_'+spice_frame+'.tplot'
      ; name='../../../../Volumes/Tesman_WD/MAVEN/tplot_files/mag/'+spice_frame+'/'+year+'/mvn_mag_l1_pl_full_'+year+month+'0'+strtrim(string(i),2)+'_'+spice_frame+'.tplot'

        if file_test(name) then begin
          tplot_restore,filename=name

          if spice_frame eq 'iau' then $
            get_data,'mvn_B_full_IAU_MARS',data=data

          if spice_frame eq 'mso' then $
            get_data,'mvn_B_full_MAVEN_MSO',data=data

          if spice_frame eq 'pl' then $
            get_data,'mvn_B_full',data=data ;check
            
            
            
          if spice_frame eq 'mse' then $
            print, 'not yet'
          if spice_frame eq 'mf' then $
            print, 'not yet'


          daily_time=[daily_time,data.x]
          x_vec=[x_vec,data.y(*,0)]
          y_vec=[y_vec,data.y(*,1)]
          z_vec=[z_vec,data.y(*,2)]
        endif
      endfor
      for i=10,31 do begin
        name='../../../../Volumes/ExtremeSSD/MAVEN/tplot_files/mag/'+spice_frame+'/'+year+'/mvn_mag_l2_pl_full_'+year+month+strtrim(string(i),2)+'_'+spice_frame+'.tplot'
        if file_test(name) then begin
          tplot_restore,filename=name
          
          if spice_frame eq 'iau' then $
            get_data,'mvn_B_full_IAU_MARS',data=data

          if spice_frame eq 'mso' then $
            get_data,'mvn_B_full_MAVEN_MSO',data=data
            
            if spice_frame eq 'pl' then $
            get_data,'mvn_B_full',data=data ;check

          if spice_frame eq 'mse' then $
            print, 'not yet'
          if spice_frame eq 'mf' then $
            print, 'not yet'

          daily_time=[daily_time,data.x]
          x_vec=[x_vec,data.y(*,0)]
          y_vec=[y_vec,data.y(*,1)]
          z_vec=[z_vec,data.y(*,2)]
          if i eq 31 then print,'31'
        endif
      endfor
    endif
    interp_sza=interpol(sza,time,daily_time)
    interp_latitude=interpol(latitude,time,daily_time)
    interp_longitude=interpol(longitude,time,daily_time)
    interp_altitude=interpol(altitude,time,daily_time)
    interp_orb = interpol(orb_num,time,daily_time)
    find_alt_limit_indx=where(interp_altitude lt alt_limit and interp_altitude gt 200.) ; SET TO LESS THAN 
    time=daily_time(find_alt_limit_indx)
    x_vec=x_vec(find_alt_limit_indx)
    y_vec=y_vec(find_alt_limit_indx)
    z_vec=z_vec(find_alt_limit_indx)
    bmag = sqrt(x_vec^2.0+y_vec^2.0+z_vec^2.0)
    altitude=interp_altitude(find_alt_limit_indx)
    orb_num=interp_orb(find_alt_limit_indx)
    latitude=interp_latitude(find_alt_limit_indx)
    longitude=interp_longitude(find_alt_limit_indx)
    sza=interp_sza(find_alt_limit_indx)

    print,'Saving File'
    ;set for l2
     ; save,filename='../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_'+strtrim(string(alt_filt),2)+'/'+year+'/mvn_mag_l2_lt_'+strtrim(string(alt_limit),2)+'_full_'+year+month+'_'+spice_frame+'.sav',$
      ;  time,altitude,x_vec,y_vec,z_vec,bmag,orb_num,latitude,longitude,sza
      save,filename='../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_400_gt_200/'+year+'/mvn_mag_l2_lt_400_gt_200_full_'+year+month+'_'+spice_frame+'.sav',$
        time,altitude,x_vec,y_vec,z_vec,bmag,orb_num,latitude,longitude,sza

; endfor
endfor
end