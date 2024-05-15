pro plot_lat_lon
  year=2014
  alt_filt = 200
  spice_frame='pl'
  get_numbers=2
  plot_time=1
  bin_size=10.0
  lat_start = -80
  lat_end = 80
  lon_start = 0.
  lon_end = 360.
  power_limit=0.03
  ;Latitude bins are -80 to 80 in increments of 10  (16 bins)
  number_lat_bins=16
  ;Longitude bins are 0 to 360 in increments of 10 (36 bins)
  number_lon_bins=36
  ;

  bincount=fltarr(number_lon_bins,number_lat_bins)
  secondcount=fltarr(number_lon_bins,number_lat_bins)
  ;  lat_bin_count=fltarr(number_lat_bins)
  ;  lon_bin_count=fltarr(number_lon_bins)




  if plot_time eq 1 then begin
    restore,'latandlon_bincount.sav'

    total_points = total(bincount)
    percentage_bincount = 100.*bincount/total_points
    hours_bincount = bincount/3600.0

    lon=MAKE_ARRAY(number_lon_bins+1,1,index=1,increment=10)
    lat=MAKE_ARRAY(number_lat_bins+1,1,index=1,increment=10,start=-80)

    c1=CONTOUR(hours_bincount, lon, lat, $
      /XSTYLE, /YSTYLE, $
      rgb_table=1, /FILL, $
      TITLE = 'Time Spent In Region (Hours)', $
      XTITLE = 'Longitude (Degrees)', $
      YTITLE = 'Latitude (Degrees)');, $
    c = COLORBAR(Target=c1, ORIENTATION=1)
  endif

  if plot_time eq 2 then begin
    map = MAP('Geographic',POSITION=[0.1,0.1,0.9,0.9], $
      LIMIT=[-80,0,80,360], TITLE='Data Collection (Hours)')




  endif



  if get_numbers eq 1 then begin
    for i=10,12 do begin
      if i lt 10 then begin
        month='0'+strtrim(string(i),2)
      endif else begin
        month=strtrim(string(i),2)
      endelse


      restore,'ResultYearly/result'+strtrim(string(year),2)+'.sav'
      restore,'../../../../Volumes/Tesman_WD/MAVEN/LowAlt/lt_'+strtrim(string(alt_filt),2)+'/'+strtrim(string(year),2)+'/mvn_mag_l2_lt_'$
        +strtrim(string(alt_filt),2)+'_full_'+strtrim(string(year),2)+month+'_'+spice_frame+'.sav'
      orb_num=round(orb_num)

      for indx_count = 0,n_elements(latitude)-1 do begin
        y = latitude(indx_count)
        x = longitude(indx_count)
        for lat_bin = 0,number_lat_bins-1     do begin
          if (y GT lat_start+bin_size*lat_bin) AND (y LE lat_start+bin_size*(lat_bin+1))  then begin
            ;l lat_bin_count(lat_bin)=lat_bin_count(lat_bin)+1.

            for lon_bin = 0,number_lon_bins-1 do begin
              if (x GT lon_start+bin_size*lon_bin) AND (x LE lon_start+bin_size*(lon_bin+1)) then begin

                bincount(lon_bin,lat_bin)=bincount(lon_bin,lat_bin)+1.

              endif
            endfor
          endif
        endfor
      endfor
    endfor




    ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    for year = 2015,2018 do begin
      for i=1,12 do begin
        if i lt 10 then begin
          month='0'+strtrim(string(i),2)
        endif else begin
          month=strtrim(string(i),2)
        endelse


        restore,'ResultYearly/result'+strtrim(string(year),2)+'.sav'
        restore,'../../../../Volumes/Tesman_WD/MAVEN/LowAlt/lt_'+strtrim(string(alt_filt),2)+'/'+strtrim(string(year),2)+'/mvn_mag_l2_lt_'$
          +strtrim(string(alt_filt),2)+'_full_'+strtrim(string(year),2)+month+'_'+spice_frame+'.sav'
        orb_num=round(orb_num)


        for indx_count = 0,n_elements(latitude)-1 do begin
          y = latitude(indx_count)
          x = longitude(indx_count)
          for lat_bin = 0,number_lat_bins-1     do begin
            if (y GT lat_start+bin_size*lat_bin) AND (y LE lat_start+bin_size*(lat_bin+1))  then begin
              ;l lat_bin_count(lat_bin)=lat_bin_count(lat_bin)+1.

              for lon_bin = 0,number_lon_bins-1 do begin
                if (x GT lon_start+bin_size*lon_bin) AND (x LE lon_start+bin_size*(lon_bin+1)) then begin

                  bincount(lon_bin,lat_bin)=bincount(lon_bin,lat_bin)+1.

                endif
              endfor
            endif
          endfor
        endfor
      endfor
    endfor

    year=2019
    for i=1,2 do begin
      if i lt 10 then begin
        month='0'+strtrim(string(i),2)
      endif else begin
        month=strtrim(string(i),2)
      endelse


      restore,'ResultYearly/result'+strtrim(string(year),2)+'.sav'
      restore,'../../../../Volumes/Tesman_WD/MAVEN/LowAlt/lt_'+strtrim(string(alt_filt),2)+'/'+strtrim(string(year),2)+'/mvn_mag_l2_lt_'$
        +strtrim(string(alt_filt),2)+'_full_'+strtrim(string(year),2)+month+'_'+spice_frame+'.sav'
      orb_num=round(orb_num)





      for indx_count = 0,n_elements(latitude)-1 do begin
        y = latitude(indx_count)
        x = longitude(indx_count)
        for lat_bin = 0,number_lat_bins-1     do begin
          if (y GT lat_start+bin_size*lat_bin) AND (y LE lat_start+bin_size*(lat_bin+1))  then begin
            ;l lat_bin_count(lat_bin)=lat_bin_count(lat_bin)+1.

            for lon_bin = 0,number_lon_bins-1 do begin
              if (x GT lon_start+bin_size*lon_bin) AND (x LE lon_start+bin_size*(lon_bin+1)) then begin

                bincount(lon_bin,lat_bin)=bincount(lon_bin,lat_bin)+1.

              endif
            endfor
          endif
        endfor
      endfor
    endfor

    ;Relevant variables:
    ; Altitude
    ; Dataplat
    ; Dataplon
    ; Peri_INDX
    ; Longitude
    ; Latitude
    ; SZA
    ; PSZA
    ; Time
    print,'vertical is longitude, horizontal is latitude'
    print,bincount

    save,filename='latandlon_bincount.sav',bincount
  endif




  if get_numbers eq 2 then begin


    for year = 2014,2019 do begin
      for i=1,12 do begin
        if i lt 10 then begin
          month='0'+strtrim(string(i),2)
        endif else begin
          month=strtrim(string(i),2)
        endelse


        if file_search('../../../../Volumes/Tesman_WD/MAVEN/LowAlt/lt_'+strtrim(string(alt_filt),2)+'/tensecavg/mvn_mag_l2_full_fft_tenavg_'$
          +strtrim(string(year),2)+month+spice_frame+'5_16.sav') ne '' then begin
          restore,'../../../../Volumes/Tesman_WD/MAVEN/LowAlt/lt_'+strtrim(string(alt_filt),2)+'/tensecavg/mvn_mag_l2_full_fft_tenavg_'$
            +strtrim(string(year),2)+month+spice_frame+'5_16.sav'

          if fft_orb_num(0) eq 6974 then begin
            limit_indx=where((fft_orb_num ne 7098) and (x_avg+y_avg+z_avg gt power_limit))
          endif else begin
            limit_indx=where(x_avg+y_avg+z_avg gt power_limit)
          endelse

          if limit_indx(0) ne -1 then begin
            latitude=fft_lat_track(limit_indx)
            longitude=fft_lon_track(limit_indx)
            time=fft_time_track(limit_indx)

           ; for indx_count = 0,n_elements(latitude)-1 do begin
              y = latitude;(indx_count)
              x = longitude;(indx_count)

              for lat_bin=0,number_lat_bins-1 do begin
                for lon_bin=0,number_lon_bins-1 do begin
                  interest =  where( (y gt lat_start+bin_size*lat_bin) and (y le lat_start+bin_size*(lat_bin+1)) and (x GT lon_start+bin_size*lon_bin) AND (x LE lon_start+bin_size*(lon_bin+1)))
                  ;  for lat_bin = 0,number_lat_bins-1     do begin
                  ;   if (y GT lat_start+bin_size*lat_bin) AND (y LE lat_start+bin_size*(lat_bin+1))  then begin
                  ;      for lon_bin = 0,number_lon_bins-1 do begin
                  ;  if (x GT lon_start+bin_size*lon_bin) AND (x LE lon_start+bin_size*(lon_bin+1)) then begin
                  if interest(0) ne -1 then begin
                    seconds_to_add = 0.

                    if n_elements(interest) eq 1 then begin
                      seconds_to_add = 10.
                      secondcount(lon_bin,lat_bin)=secondcount(lon_bin,lat_bin)+seconds_to_add
                      ;bincount(lon_bin,lat_bin)=bincount(lon_bin,lat_bin)+1.

                    endif else begin

                      for uh = 1,n_elements(interest) do begin
                        if uh lt n_elements(interest) then begin
                          if time(interest(uh))-time(interest(uh-1)) gt 1 and time(interest(uh))-time(interest(uh-1)) lt 10 then begin
                            seconds_to_add = (time(interest(uh))-time(interest(uh-1))) ;1.0
                          endif else begin
                            seconds_to_add=10.
                          endelse
                          secondcount(lon_bin,lat_bin)=secondcount(lon_bin,lat_bin)+seconds_to_add
                          ;bincount(lon_bin,lat_bin)=bincount(lon_bin,lat_bin)+1.
                        endif else begin
                          seconds_to_add = 10.
                          secondcount(lon_bin,lat_bin)=secondcount(lon_bin,lat_bin)+seconds_to_add
                          ;bincount(lon_bin,lat_bin)=bincount(lon_bin,lat_bin)+1.
                        endelse
                        
             
                      endfor
         

                    endelse
                 
                  endif
               ; endfor
                ;endif
              endfor
            endfor
          endif




        endif
      endfor
    endfor

    print,'vertical is longitude, horizontal is latitude'
    print,secondcount

    save,filename='events_seconds_bincount.sav',secondcount
  endif





end