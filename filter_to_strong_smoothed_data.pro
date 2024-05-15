pro filter_to_strong_smoothed_data
  ; My goal here is to find where the avg is ge power_limit and record that orbit number and date
  ; So that I can load that data into mvn_mag_itplot and look at the signal
  
  ;USE THIS ONE!

  !EXCEPT=0 ; My NaN array causes overflow
  power_limit=0.03
  upper_limit=0.3
  eph_time=[]
  lat=[]
  lon=[]
  eph_comp=[]
  spice_frame='pl'
  alt_filt=200
  freq_range='5_16'
  string_comp = strarr(1)
  lat_comp=fltarr(1)
  lon_comp=fltarr(1)

  for year = 2014,2019 do begin

    for month_count = 1, 12 do begin
      if month_count lt 10 then begin
        month='0'+strtrim(string(month_count),2)
      endif else begin
        month=strtrim(string(month_count),2)
      endelse

      if file_search('../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_200/tensecavg/mvn_mag_l2_full_fft_tenavg_'+strtrim(string(year),2)+month+spice_frame+freq_range+'.sav') ne '' then begin
        restore,'../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_200/tensecavg/mvn_mag_l2_full_fft_tenavg_'+strtrim(string(year),2)+month+spice_frame+freq_range+'.sav'

        array_size=n_elements(x_avg)

        string_date=strarr(array_size)

        date = fltarr(array_size)
        orbit_num =  fltarr(array_size )
        longitude = fltarr(array_size)
        latitude=fltarr(array_size)
        x =  fltarr(array_size )
        y =  fltarr(array_size )
        z =  fltarr(array_size )
        enhanced = CREATE_STRUCT('name','avg power record', 'orbit_num', orbit_num,  $
          'x',x,'y',y,'z',z,'date',date,'longitude',longitude,'latitude',latitude)

        for i = 0,array_size-1 do begin
         ;if (x_avg(i) ge power_limit and x_avg(i) le upper_limit) or $
         ;  (y_avg(i) ge power_limit and y_avg(i) le upper_limit)  or $
         ;  (z_avg(i) ge power_limit and z_avg(i) le upper_limit) then begin
      if (x_avg(i)+y_avg(i)+z_avg(i) gt power_limit) then begin
      ;  if (fft_lon_track(i) gt 100 and fft_lon_track(i) lt 110 and $
       ;   fft_lat_track(i) gt 10 and fft_lat_track(i) lt 21 and x_avg(i)+y_avg(i)+z_avg(i) gt power_limit) then begin

        
            enhanced.orbit_num(i)=fft_orb_num(i)
            enhanced.x(i)=x_avg(i)
            enhanced.y(i)=y_avg(i)
            enhanced.z(i)=z_avg(i)
            enhanced.date(i)=fft_time_track(i)
            enhanced.longitude(i)=fft_lon_track(i)
            enhanced.latitude(i)=fft_lat_track(i)
          endif
        endfor

;print,enhanced.date

        date_count=0
        for j = 0,array_size-1 do begin
          if enhanced.date(j) ne 0 then begin
            time_structure=time_struct(enhanced.date(j))

            string_date(date_count)=strtrim(string(time_structure.month),2)+'-'+strtrim(string(time_structure.date),2)+$
              '-'+strtrim(string(time_structure.year),2)+'/'+strtrim(string(time_structure.hour),2)+':'+strtrim(string(time_structure.min),2)+$
              ':'+strtrim(string(time_structure.sec),2)
            eph_time=[eph_time,enhanced.date(j)]
            lat=[lat,enhanced.latitude(j)]
            lon=[lon,enhanced.longitude(j)]
            date_count=date_count+1


          endif
        endfor
eph_comp=[eph_comp,eph_time]


        string_date=string_date(uniq(string_date))
        string_comp=[string_comp,string_date]
        lat_comp=[lat_comp,lat];enhanced.latitude]
        lon_comp=[lon_comp,lon];enhanced.longitude]
        ; print,string_date
    ; save,filename='enhanced_array_tensec_smooth'+strtrim(string(year),2)+month+spice_frame+freq_range+'.sav',enhanced,string_date
      endif

    endfor


  endfor
  save,filename='enhanced_array_tensec_smooth_comp_pt03.sav',string_comp,lat_comp,lon_comp,eph_comp

end