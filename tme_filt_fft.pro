;fft for each full second (32 data points)
pro tme_filt_fft, orb_num, altitude,latitude,longitude,sza,avg_mag_spec_x, avg_mag_spec_y, avg_mag_spec_z,fft_orb_num,fft_time_track,fft_alt_track, fft_sza_track,fft_lon_track,fft_lat_track
  count=0
  paneldatarate=32
  OTMINDX=[]
  Coaddinterval = 0
  fft_orb_num=[]
  
  fft_time_track=[]
   ; fft_time_track=fltarr(1)
  fft_alt_track=[]
  fft_lon_track=[]
  fft_lat_track=[]
  fft_sza_track=[]
  avg_mag_spec_x = []
  avg_mag_spec_y = []
  avg_mag_spec_z = []
  for var_count=1,3 do begin
    if var_count eq 1 then varName = 'mvn_B_full_filt_x'
    if var_count eq 2 then varName = 'mvn_B_full_filt_y'
    if var_count eq 3 then varName = 'mvn_B_full_filt_z'
    ;data=mvn_mag_getData(varName)
    get_data,varName,data=data
    print,varName
    ; non_nan = where(finite(data.y))
    number_of_seconds=10.0
    length_of_fft=32.0*number_of_seconds ;number of index  -> divide by 32 for number of seconds
    window_step=32.0*1.0

    for indx_time = 0,n_elements(data.x)-length_of_fft-1,window_step do begin
      if (data.x(indx_time+length_of_fft)-data.x(indx_time) eq number_of_seconds) then begin ; checking time length and for datagaps
        N=1.0      
        fft_data = data.y(indx_time:indx_time+length_of_fft-1)-smooth(data.y(indx_time:indx_time+length_of_fft-1), N*32.0);data.y(indx_time:indx_time+length_of_fft-1) ; setting vec data length
        if n_elements(where(finite(fft_data))) eq length_of_fft then begin
          jre_fft, fft_data, paneldatarate, Coaddinterval, FFTfreqs, FFTspectra

          freq_range_of_interest = where(FFTfreqs ge 5 and FFTfreqs le 16)

          ; average spectral power for each second from 9-14 Hz
          if var_count eq 1 then begin
            if FFTspectra(0) gt 1000.0 then begin
              FFTspectra(freq_range_of_interest) = !values.F_NAN
            endif
            avg_mag_spec_x = [avg_mag_spec_x,mean(FFTspectra(freq_range_of_interest))]

            fft_orb_num = [fft_orb_num,orb_num(indx_time)]
            fft_alt_track=[fft_alt_track,altitude(indx_time)]
            fft_time_track = [fft_time_track,data.x(indx_time)]
            fft_lon_track=[fft_lon_track,longitude(indx_time)]
            fft_lat_track=[fft_lat_track,latitude(indx_time)]
            fft_sza_track=[fft_sza_track,sza(indx_time)]
           
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
    OTMINDX=where(avg_mag_spec_y gt 0.08)
  if OTMINDX(0) ne -1 then begin 
  avg_mag_spec_x(OTMINDX)=!values.F_NAN
  avg_mag_spec_y(OTMINDX)=!values.F_NAN
  avg_mag_spec_z(OTMINDX)=!values.F_NAN
endif
end