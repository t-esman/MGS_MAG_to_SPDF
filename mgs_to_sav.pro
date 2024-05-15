;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Purpose:
;Create .sav files out of MGS mag .sts files
;including low time and high time resolution data.
;
;Processes are performed.
;
;These include:
;1) Translating Doy/hour/min/sec/msec to unix time
;2) Calculating the altitude based on low time resolution
;spacecraft position data and the radius of Mars.
; Please note that the radius is a reasonable chosen value, 
; but may not be accurate at the exact data acquisition location. 
; Equatorial radius (km): 3396.2
; Polar radius (km): 3376.2
; Volumetric mean radius (km): 3389.5
; Chosen value (km): 3389.5
;3) Interpolating the low time resolution altitude
;to the high time resolution data.
;
;Author:Teresa Esman
; teresa.esman@nasa.gov
;
; Last edited: 04/12/2023
; 04/12/2023: Switch to Mac file format
; 12/1/2022: Fix for when only some files exist 
;            (e.g., no high time resolution available)
; 11/9/2022
; 11/3/2022
; 
; Note: The 04/12/2023 version of this code was used to 
; create data files in the process of archiving MGS MAG
; data on the SPDF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro mgs_to_sav, timeFrame = timeFrame

  if ~keyword_set(timeFrame) then begin
    timeFrame=''
   
    ; This code is designed to do only one phase at a time: 
    ;pre-map or mapping phase. The user must change these 
    ;variables as necessary. 
    pre_map = 'n' ;Compile pre-mapping MGS files (1997-1999)
    mapping = 'y' ;Compile mapping MGS files (1999-2006)
  endif


  init_dir = '/Users/username/folder/MGS/Data' ;Location of saved data files
  end_dir = '/Users/username/folder/MGS/COMPILATION_FILES' ;Where to save the new files

  if pre_map eq 'y' then begin
    dirdet='/detail_pl_ss_premap/'
    dirlow_pc='/low_pc_premap/MAG_PCENTRIC/'
    dirlow_ss='/low_ss_premap/MAG_SUNSTATE/'
    end_dir = '/Users/tesman/Desktop/TESMAN/NPP_WORK/MGS/COMPILATION_FILES_PREMAP/'
  endif else begin
    if mapping eq 'y' then begin
      dirdet='/detail_pl_ss_MAP/'
      dirlow_pc ='/low_pc_MAP/'
      dirlow_ss = '/low_ss_MAP/'
    endif else begin
      print, 'Please choose pre mapping or mapping data.'
      stop
    endelse

  endelse


  
  for year = 106,107 do begin
    for day =30,356 do begin

      yy = strtrim(year,1)
      if year ge 100 then yy=strMid(strtrim(year,2),1,2)

      if day lt 10 then ddd = '00'+strtrim(day,1)
      if day lt 100 and day gt 9 then ddd = '0'+strtrim(day,1)
      if day ge 100 then ddd = strtrim(day,1)


      fnstem='m'+yy+'d'+ddd
      fnstem_num=yy+ddd

      fnh=init_dir+dirdet+fnstem+'_detail.sts' ; high time resolution
      fnlss=init_dir+dirlow_ss+fnstem_num+'.sts'
      fnlpc=init_dir+dirlow_pc+fnstem_num+'.sts'
      print,fnh

      ;Make sure that the file exists
      search_high=file_search(fnh)
      search_lowpc = file_search(fnlpc)
      search_lowss = file_search(fnlss)
      if search_high eq '' and search_lowpc eq '' and search_lowss eq '' then begin
        print, 'Files (detail, low pc, low ss) not found. Continuing to next day.'
        continue
      endif
      if search_high eq '' then print, 'Detail file does not exist.'
      if search_lowpc eq '' then print, 'Low resolution PC file does not exist.'

      if search_lowss eq '' then $
        print, 'Low resolution SS file does not exist.'

      ;Check if the compilation file already exists.
      if mapping eq 'y' then $
        check_end_file = end_dir + '/' + fnstem +'.sav'
      if pre_map eq 'y' then $
        check_end_file = end_dir + '_PREMAP/' + fnstem +'.sav'
      t = file_search(check_end_file)
      if t ne '' then begin
        print, 'Compilation file already exists. Continuing to next day.'
        continue
      endif
      
      ; Load the high time resolution payload and sun-state data
      if search_high ne '' then $
        tme_pl_ss_sts_dataload,fnh,TIME_DOY_HIGH,TIME_HOUR_HIGH,TIME_MIN_HIGH,$
        TIME_SEC_HIGH,TIME_MSEC_HIGH,TIME_YEAR_HIGH_PL_SS,DECIMAL_DAY_HIGH,$
        OUTBOARD_B_J2000_RANGE_HIGH_PL_SS, OUTBOARD_B_J2000_X_HIGH_PL_SS, $
        OUTBOARD_B_J2000_Y_HIGH_PL_SS,OUTBOARD_B_J2000_Z_HIGH_PL_SS, OUTBOARD_B_PAYLOAD_RANGE_HIGH_PL_SS,$
        OUTBOARD_B_PAYLOAD_X_HIGH_PL_SS,OUTBOARD_B_PAYLOAD_Y_HIGH_PL_SS,$
        OUTBOARD_B_PAYLOAD_Z_HIGH_PL_SS,colNames_HIGH,cmdLine_HIGH,unitNames_HIGH,titleLine

      ; Load the low time resolution sunstate data and position data
      if search_lowss ne '' then $
        tme_ss_low_sts_dataload,fnlss,TIME_DOY_LOW,TIME_HOUR_LOW,TIME_MIN_LOW,$
        TIME_SEC_LOW,TIME_MSEC_LOW,TIME_YEAR_LOW,DECIMAL_DAY_LOW, $
        OUTBOARD_B_J2000_X_LOW_SS, OUTBOARD_B_J2000_Y_LOW_SS,OUTBOARD_B_J2000_Z_LOW_SS, $
        OUTBOARD_B_J2000_RANGE_LOW_SS, SC_POSITION_X_LOW_SS, SC_POSITION_Y_LOW_SS, $
        SC_POSITION_Z_LOW_SS, OUTBOARD_RMS_X_LOW_SS, OUTBOARD_RMS_Y_LOW_SS, $
        OUTBOARD_RMS_Z_LOW_SS, OUTBOARD_RMS_RANGE_LOW_SS, OUTBOARD_BSC_PAYLOAD_X_LOW_SS, $
        OUTBOARD_BSC_PAYLOAD_Y_LOW_SS, OUTBOARD_BSC_PAYLOAD_Z_LOW_SS, OUTBOARD_BSC_PAYLOAD_RANGE_LOW_SS,$
        OUTBOARD_BD_PAYLOAD_X_LOW_SS,OUTBOARD_BD_PAYLOAD_Y_LOW_SS,OUTBOARD_BD_PAYLOAD_Z_LOW_SS,$
        OUTBOARD_BD_PAYLOAD_RANGE_LOW_SS,SA_NEGY_CURRENT_LOW_SS,SA_POSY_CURRENT_LOW_SS,SA_OUTPUT_CURRENT_LOW_SS,$
        colNames_LOW,cmdLine_LOW_SS,unitNames_LOW

      ; Load the low time resolution planetocentric data and position data
      if search_lowpc ne '' then $
        tme_pc_low_sts_dataload,fnlpc,OUTBOARD_B_J2000_X_LOW_PC, OUTBOARD_B_J2000_Y_LOW_PC,$
        OUTBOARD_B_J2000_Z_LOW_PC, OUTBOARD_B_J2000_RANGE_LOW_PC, SC_POSITION_X_LOW_PC,$
        SC_POSITION_Y_LOW_PC,SC_POSITION_Z_LOW_PC, OUTBOARD_RMS_X_LOW_PC, OUTBOARD_RMS_Y_LOW_PC, $
        OUTBOARD_RMS_Z_LOW_PC, OUTBOARD_RMS_RANGE_LOW_PC, OUTBOARD_BSC_PAYLOAD_X_LOW_PC, $
        OUTBOARD_BSC_PAYLOAD_Y_LOW_PC, OUTBOARD_BSC_PAYLOAD_Z_LOW_PC, OUTBOARD_BSC_PAYLOAD_RANGE_LOW_PC,$
        OUTBOARD_BD_PAYLOAD_X_LOW_PC,OUTBOARD_BD_PAYLOAD_Y_LOW_PC,OUTBOARD_BD_PAYLOAD_Z_LOW_PC,$
        OUTBOARD_BD_PAYLOAD_RANGE_LOW_PC,SA_NEGY_CURRENT_LOW_PC,SA_POSY_CURRENT_LOW_PC,SA_OUTPUT_CURRENT_LOW_PC,$
        cmdLine_LOW_PC


      ;Switch from year, day, hour, minute, second, msec to unix time
      ; THIS WILL BREAK IF LOW SS FILE DOES NOT EXIST. SO FAR NOT ENCOUNTERED.
      unix_time_low = make_array(n_elements(TIME_YEAR_LOW),/DOUBLE)
      for time_count_low = 0, n_elements(TIME_YEAR_LOW)-1 do begin
        unix_time_low(time_count_low) = doyday_to_unix(TIME_YEAR_LOW(time_count_low), floor(DECIMAL_DAY_LOW(time_count_low)), $
          TIME_HOUR_LOW(time_count_low), TIME_MIN_LOW(time_count_low),TIME_SEC_LOW(time_count_low),TIME_MSEC_LOW(time_count_low))
      endfor

      if search_high ne '' then begin
        unix_time_high = make_array(n_elements(TIME_YEAR_HIGH_PL_SS),/DOUBLE)
        for time_count_high =0, n_elements(TIME_YEAR_HIGH_PL_SS)-1 do begin
          unix_time_high(time_count_high) = doyday_to_unix(TIME_YEAR_HIGH_PL_SS(time_count_high), $
            floor(DECIMAL_DAY_HIGH(time_count_high)), TIME_HOUR_HIGH(time_count_high), TIME_MIN_HIGH(time_count_high), TIME_SEC_HIGH(time_count_high),$
            TIME_MSEC_HIGH(time_count_high))
        endfor
      endif

      ;Interpolate the low resolution altitude to the high resolution data.
      RADIUS_OF_MARS = 3389.5
      ALT_LOW = sqrt(SC_POSITION_X_LOW_SS^2+SC_POSITION_Y_LOW_SS^2+SC_POSITION_Z_LOW_SS^2)-RADIUS_OF_MARS
      if search_high ne '' then $
        ALT_HIGH = interpol(ALT_LOW, UNIX_TIME_LOW, UNIX_TIME_HIGH)

      ;Delete unnecessary variables
      delvar, i, day, year, fnstem_num, fnlss, fnlpc, fnh
      ;Save all other variables
      save,filename=end_dir+'/'+fnstem+'.sav'

    endfor
  endfor


end
