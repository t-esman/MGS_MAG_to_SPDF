;fft for each full second (32 data points)
pro MGS_premap_fft_filter_tme, fft_alt_track,avg_mag_spec_x, avg_mag_spec_y, avg_mag_spec_z,fft_dday_track,fft_year_track
  
  
  var_count=0
  indx_time=0
  paneldatarate=32
  OTMINDX=[]
  Coaddinterval = 0
  fft_year_num=[]
  fft_dday_track=[]
  fft_year_track=[]
  fft_alt_track=[]
  avg_mag_spec_x = []
  avg_mag_spec_y = []
  avg_mag_spec_z = []
  fft_bxss = []
  fft_byss = []
  fft_bzss = []

  ; OKAY SO open up
  ;MGS_altle400_rategtandlt3033
  ;then you have overlapstart and overlapend
  ;m##_d###_over_altle400_rategtandlt3033
  ;and THEN
  ;MGS_all
  ;m##d###_all.sav
  ;so then that part is 32 samples/sec and lt 400 km

  init_direct = 'D:\TESMAN\NPP_WORK\MGS\COMPILATION_FILES\'
  for year = 97,99 do begin

    yy = strtrim(year,1)

    for day = 1,365 do begin
      if day lt 10 then ddd = '00'+strtrim(day,1)
      if day lt 100 and day gt 9 then ddd = '0'+strtrim(day,1)
      if day ge 100 then ddd = strtrim(day,1)

      print, yy
      print, ddd

          fnstem='m'+yy+'d'+ddd

      filename = init_direct+fnstem+'.sav'
      if file_test(filename) eq 1 then begin
        restore, filename=init_direct+'altle400_rategtandlt3033\m'+yy+'d'+ddd+'_over_altle400_rategtandlt3033.sav'

        if (isa(overlapend(0),/number) eq 1) and (isa(overlapstart(0),/number) eq 1) then begin
          restore, filename=init_direct+'all\m'+yy+'d'+ddd+'_all.sav'


          for over_count = 0, n_elements(overlapstart)-1 do begin

            new_dday = dday(overlapstart(over_count):overlapend(over_count))
            new_bxss = bxss(overlapstart(over_count):overlapend(over_count))
            new_byss = byss(overlapstart(over_count):overlapend(over_count))
            new_bzss = bzss(overlapstart(over_count):overlapend(over_count))
            new_xss = xss(overlapstart(over_count):overlapend(over_count))
            new_yss = yss(overlapstart(over_count):overlapend(over_count))
            new_zss = zss(overlapstart(over_count):overlapend(over_count))

            store_data, 'bxss',data={x:new_dday,y:new_bxss}
            store_data,'byss',data={x:new_dday,y:new_byss}
            store_data,'bzss',data={x:new_dday,y:new_bzss}

            for var_count=1,3 do begin
              if var_count eq 1 then varName = 'bxss'
              if var_count eq 2 then varName = 'byss'
              if var_count eq 3 then varName = 'bzss'
              ;data=mvn_mag_getData(varName)
              get_data,varName,data=data
              print,varName
              ; non_nan = where(finite(data.y))
              time_array = data.x*24.*60.*60.
              number_of_seconds=10.0
              length_of_fft=32.0*number_of_seconds ;number of index  -> divide by 32 for number of seconds
              window_step=32.0*1.0

              for indx_time = 0,n_elements(time_array)-length_of_fft-1,window_step do begin
                if (abs(time_array(indx_time+length_of_fft)-time_array(indx_time) - number_of_seconds) lt 0.01) then begin ; checking time length and for datagaps
                  N=1.0
                  fft_data = data.y(indx_time:indx_time+length_of_fft-1)-smooth(data.y(indx_time:indx_time+length_of_fft-1), N*32.0);data.y(indx_time:indx_time+length_of_fft-1) ; setting vec data length
                  if n_elements(where(finite(fft_data))) eq length_of_fft then begin
                    jre_fft, fft_data, paneldatarate, Coaddinterval, FFTfreqs, FFTspectra

                    freq_range_of_interest = where(FFTfreqs ge 5 and FFTfreqs le 16)

                    if var_count eq 1 then begin
                      if FFTspectra(0) gt 1000.0 then begin
                        FFTspectra(freq_range_of_interest) = !values.F_NAN
                      endif
                      avg_mag_spec_x = [avg_mag_spec_x,mean(FFTspectra(freq_range_of_interest))]


                      fft_dday_track=[fft_dday_track,time_array(indx_time)/(24.*60.*60.)]

                      fft_year_track=[fft_year_track,yy]

                      altitude = sqrt(new_xss^2+new_yss^2+new_zss^2)-3390.

                      fft_alt_track=[fft_alt_track,altitude(indx_time)]


                    endif
                    if var_count eq 2 then begin
                      if FFTspectra(0) gt 1000.0 then FFTspectra(freq_range_of_interest) = !values.F_NAN
                      avg_mag_spec_y = [avg_mag_spec_y,mean(FFTspectra(freq_range_of_interest))]
                    endif
                    if var_count eq 3 then begin
                      if FFTspectra(0) gt 1000.0 then FFTspectra(freq_range_of_interest) = !values.F_NAN
                      avg_mag_spec_z = [avg_mag_spec_z,mean(FFTspectra(freq_range_of_interest))]
                    endif

                  endif
                endif
              endfor
            endfor
            if isa(avg_mag_spec_x) eq 1 then begin
              ;if the time interval is less than 10 seconds, there is no result. 
              
            OTMINDX=where(avg_mag_spec_y gt 0.08);what does this do and why?
            if OTMINDX(0) ne -1 then begin
              avg_mag_spec_x(OTMINDX)=!values.F_NAN
              avg_mag_spec_y(OTMINDX)=!values.F_NAN
              avg_mag_spec_z(OTMINDX)=!values.F_NAN
            endif
;852094800 1997
            save,new_dday,new_bxss, new_byss, new_bzss, avg_mag_spec_x, avg_mag_spec_y, avg_mag_spec_z, fft_year_track, fft_dday_track,fft_alt_track,filename='Documents\IDL\MGS_fft_results\m'+yy+'d'+ddd+'_fft'+strtrim(over_count,1)+'.sav'
            endif
            fft_year_num=[]
           fft_dday_track=[]
           fft_year_track=[]
           fft_alt_track=[]
           avg_mag_spec_x = []
            avg_mag_spec_y = []
            avg_mag_spec_z = []
            var_count=0
            endfor
          endif
        endif
      
    endfor
  endfor
 ; save,avg_mag_spec_x, avg_mag_spec_y, avg_mag_spec_z, fft_year_track, fft_dday_track,fft_alt_track,filename='Documents\IDL\MGS_fft_results\mgs_all.sav'

end