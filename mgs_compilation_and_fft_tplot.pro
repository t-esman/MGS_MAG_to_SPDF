;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Purpose:
; Open compilation file and fft file given year and doy.
; Program sets timespan automatically. 
; Stops the program if the date doesn't have an fft file. 
; Set to premapping only, as that is what the ffts are for.
; Set to high time resolution data load. 
; Create and plot tplot variables in MSO coordinates. 
; 
;       Inputs: 
;            ref = ref, coordinate system: pc, planetocentric, pl, payload, ss, sunstate, mso 
;       Outputs: tplot variables are saved
;
;Author:Teresa Esman
;
;last edited:11/17/22
;11/17/22 - added other coordinate system data load, required input ref
;11/9/2022
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro mgs_compilation_and_fft_tplot, ref=ref

yy=''
ddd=''
read, yy, PROMPT='Enter year (yy): '
read, ddd, PROMPT='Enter day of year (ddd): '


fn = 'D:\TESMAN\NPP_WORK\MGS\FFT_TIME_SERIES\m'+yy+'d'+ddd+'_fft.sav'
t=file_search(fn)
if t eq '' then begin
  print, 'File not found. Day not within conditions.'
  stop
endif


restore,'D:\TESMAN\NPP_WORK\MGS\COMPILATION_FILES_PREMAP\m'+yy+'d'+ddd+'.sav'
restore,fn




year = float(yy)
if year lt 10 then year = year +2000.
if year gt 90 then year = year +1900.
date = fltarr(5)
date(0) = year
date(1) = float(ddd)
date(2) = 0
date(3) = 0
date(4) = 0

results = strmid(date_conv(date,'fits'),0,10)

timespan, results,1

spec_x = avg_mag_spec_x
spec_y = avg_mag_spec_y
spec_z = avg_mag_spec_z
fft_time = fft_unix_time_track
if ref eq 'ss' or ref eq 'sunstate' or ref eq 'mso' then begin
  print, 'Sunstate (SS, MSO)'
bx = OUTBOARD_B_J2000_X_HIGH_PL_SS
by = OUTBOARD_B_J2000_Y_HIGH_PL_SS
bz = OUTBOARD_B_J2000_Z_HIGH_PL_SS
alt = ALT_HIGH
unix = UNIX_TIME_HIGH
endif else begin
  if ref eq 'pc' or ref eq 'planetocentric' then begin
    print,'Planetocentric'
    bx = OUTBOARD_B_J2000_X_LOW_PC
    by = OUTBOARD_B_J2000_Y_LOW_PC
    bz = OUTBOARD_B_J2000_Z_LOW_PC
    alt = ALT_LOW
    UNIX = UNIX_TIME_LOW
    endif else begin
      if ref eq 'pl' or ref eq 'payload' then begin
        print, 'Payload'
        bx = OUTBOARD_B_PAYLOAD_X_HIGH_PL_SS
        by = OUTBOARD_B_PAYLOAD_Y_HIGH_PL_SS
        bz = OUTBOARD_B_PAYLOAD_Z_HIGH_PL_SS
        
        alt = ALT_HIGH
        UNIX = UNIX_TIME_HIGH
      endif else begin
        print, 'Typo? Unrecognized coordinate system."
        STOP
      endelse
    endelse
endelse
bmag = sqrt(bx^2+by^2+bz^2)

store_data,'bmag',data = {x:UNIX,y:bmag}
store_data,'ref', data =ref
  store_data, 'bx',data={x:UNIX,y:bx}
  options, 'bx',ytitle = 'Bx (nT)'
  store_data,'by',data={x:UNIX,y:by}
  options, 'by',ytitle = 'By (nT)'
  store_data,'bz',data={x:UNIX,y:bz}
  options, 'bz',ytitle = 'Bz (nT)'
  store_data,'alt',data={x:UNIX, y:alt}
  options, 'alt',ytitle = 'Altitude (km)'

sum_spec = sqrt(spec_x^2+spec_y^2+spec_z^2)

store_data,'fft_pow',data = {x:fft_time,y:sum_spec}
options,'fft_pow', ytitle = 'Sum of Avg Spectral Power (nT/Hz)'

mvn_mag_itplot,['bx','by','bz','alt','fft_pow'],mgs='y'



end