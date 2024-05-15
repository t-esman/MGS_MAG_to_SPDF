;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Purpose: Take overlapping FFTs of a MAG time series 
;which is limited by altitude and sampling rate. 
;Put the resulting average power in a frequency range
;into a time series - track the time and altitude for the ffts.
;
;Author: Teresa Esman
;Last Edited: 11/9/2022
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro tme_mgs_fft, fft_alt_track,avg_mag_spec_x, avg_mag_spec_y, avg_mag_spec_z,fft_dday_track,fft_year_track
  
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
  fft_unix_time_track=[]

;the issue now is only doing the parts with 32 samples/sec
  init_direct = 'D:\TESMAN\NPP_WORK\MGS\COMPILATION_FILES_PREMAP\'
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
        restore, filename=filename

altitude_limiter = 400.;km
rate_lower_limit = 31.
ineq = 'ge'



where_rate = tme_determine_sample_rate(rate_lower_limit, DECIMAL_DAY_HIGH,ineq)

new_bxss = OUTBOARD_B_J2000_X_HIGH_PL_SS(where_rate)
new_byss = OUTBOARD_B_J2000_Y_HIGH_PL_SS(where_rate)
new_bzss = OUTBOARD_B_J2000_Z_HIGH_PL_SS(where_rate)
new_alt_high = ALT_HIGH(where_rate)
new_unix_time_high = UNIX_TIME_HIGH(where_rate)


;OUTBOARD_B_J2000_X_HIGH_PL_SS 

where_alt = where(new_alt_high le altitude_limiter)
bxss = new_bxss(where_alt)
byss = new_byss(where_alt)
bzss = new_bzss(where_alt)
alt_high = new_alt_high(where_alt)
unix_time_high = new_unix_time_high(where_alt)


            store_data, 'bxss',data={x:UNIX_TIME_HIGH,y:bxss}
            store_data,'byss',data={x:UNIX_TIME_HIGH,y:new_byss}
            store_data,'bzss',data={x:UNIX_TIME_HIGH,y:new_bzss}
            store_data,'alt',data={x:UNIX_TIME_HIGH, y:alt_high}
            
            for var_count=1,3 do begin
              if var_count eq 1 then varName = 'bxss'
              if var_count eq 2 then varName = 'byss'
              if var_count eq 3 then varName = 'bzss'
              ;data=mvn_mag_getData(varName)
              get_data,varName,data=data
              print,varName
              ; non_nan = where(finite(data.y))
              time_array = data.x;*24.*60.*60.
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


                      fft_unix_time_track=[fft_unix_time_track,time_array(indx_time)]

                    ;  fft_year_track=[fft_year_track,yy]

                     ; altitude = sqrt(new_xss^2+new_yss^2+new_zss^2)-3390.

                      fft_alt_track=[fft_alt_track,alt_high(indx_time)]


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
              
;            OTMINDX=where(avg_mag_spec_y gt 0.08);what does this do and why?
;            if OTMINDX(0) ne -1 then begin
;              avg_mag_spec_x(OTMINDX)=!values.F_NAN
;              avg_mag_spec_y(OTMINDX)=!values.F_NAN
;              avg_mag_spec_z(OTMINDX)=!values.F_NAN
;            endif

            save,avg_mag_spec_x, avg_mag_spec_y, avg_mag_spec_z, fft_unix_time_track,fft_alt_track,filename='D:\TESMAN\NPP_WORK\MGS\FFT_TIME_SERIES\'+fnstem+'_fft.sav'
            endif
         ;   fft_year_num=[]
        ;   fft_dday_track=[]
         ;  fft_year_track=[]
           fft_alt_track=[]
           avg_mag_spec_x = []
            avg_mag_spec_y = []
            avg_mag_spec_z = []
            fft_unix_time_track=[]
            var_count=0
            endif
            endfor
            endfor
        ;  endif
     
      

 ; endfor
 ; save,avg_mag_spec_x, avg_mag_spec_y, avg_mag_spec_z, fft_year_track, fft_dday_track,fft_alt_track,filename='Documents\IDL\MGS_fft_results\mgs_all.sav'

end