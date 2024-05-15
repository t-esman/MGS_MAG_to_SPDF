;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Purpose: Obsolete-ish
; One part puts all the fft files into one file
; The other part is limiting conditions
;
;Author: Teresa Esman
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro tme_mgs_analysis,where_overlap,magtime,spectime,bxss,byss,bzss,sum_spec

saveall = 'n'

full_avg_spec_x=[]
full_avg_spec_y=[]
full_avg_spec_z =[]
full_bxss=[]
full_byss=[]
full_bzss = []

full_time=[]
full_fft_dday=[]
full_fft_alt=[]
full_fft_year=[]  



if saveall eq 'y' then begin
  for year = 97,99 do begin

    yy = strtrim(year,1)

    for day = 1,365 do begin
      if day lt 10 then ddd = '00'+strtrim(day,1)
      if day lt 100 and day gt 9 then ddd = '0'+strtrim(day,1)
      if day ge 100 then ddd = strtrim(day,1)

      print, yy
      print, ddd

for over_count = 0,18 do begin
      filename = 'Documents\IDL\MGS_fft_results\m'+yy+'d'+ddd+'_fft'+strtrim(over_count,1)+'.sav'
      if file_test(filename) eq 1 then begin 
        restore, filename=filename
       ; restore, filename='D:\TESMAN\MGS\MGS_all\m'+yy+'d'+ddd+'_all.sav'




full_avg_spec_x = [full_avg_spec_x,avg_mag_spec_x]
full_avg_spec_y = [full_avg_spec_y,avg_mag_spec_y]
full_avg_spec_z = [full_avg_spec_z,avg_mag_spec_z]
full_bxss = [full_bxss, new_bxss]
full_byss = [full_byss, new_byss]
full_bzss = [full_bzss, new_bzss]
full_time = [full_time, new_dday]


full_fft_dday = [full_fft_dday, fft_dday_track]
full_fft_alt = [full_fft_alt, fft_alt_track]
full_fft_year = [full_fft_year, fft_year_track]


endif

endfor
endfor
  endfor
  save,full_avg_spec_x,full_avg_spec_y,full_avg_spec_z, full_bxss,full_byss, full_bzss, full_time,$
    full_fft_dday, full_fft_alt, full_fft_year,filename='Documents\IDL\MGS_fft_results\full_results.sav'
endif



if saveall eq 'n' then begin
 ; restore,'Documents\IDL\MGS_fft_results\full_results.sav'
  ;average_power_x = mean(full_avg_spec_x,/nan)
  ;average_power_y = mean(full_avg_spec_y,/nan)
  ;average_power_z = mean(full_avg_spec_z,/nan)
 year_count=0 
 ; full_time_secs = make_array(n_elements(full_time))
 ; full_fft_time_secs = make_array(n_elements(full_fft_dday))
  ;the coordinate system shouldn't matter, so take the magnitude or sum... 
  ; 3 standard deviations is 0.051 - > 3230 points, but that translates to 
  ; how many distinct time periods?
  
 ; sum_full_avg = full_avg_spec_x + full_avg_spec_y + full_avg_spec_z
;where_enhanced = where(sum_full_avg gt 0.051)

;some reason the subscript out of range
;
;for i = 0,n_elements(full_time)-1 do begin
;  
;  if full_time(i) eq 365 then year_count=year_count+1
;
;full_time_secs(i) = 852094800.+(full_time(i)*24.*60.*60.)+year_count*(365.*24.*60.*60.)
;endfor
;year_count=0

;for i = 0,n_elements(full_fft_dday)-1 do begin
 ; if full_fft_year(i) eq '97' then year_count =0
 ; if full_fft_year(i) eq '98' then year_count =1
 ; if full_fft_year(i) eq '99' then year_count =2
  
 ; full_fft_time_secs(i) = 852094800.+(full_fft_dday(i)*24.*60.*60.)+year_count*(365.*24.*60.*60.)

  
;endfor

;store_data,'full_spec_avg',data={x:full_fft_time_secs,y:sum_full_avg}
;store_data,'full_spec_avg',data={x:full_fft_dday,y:sum_full_avg}
yy=''
ddd=''
read, yy, $
  prompt='Enter the year (yy):'
read, ddd, $
  prompt='Enter the day of year (ddd):'

 restore, filename='D:\TESMAN\MGS\MGS_all\m'+yy+'d'+ddd+'_all.sav'
day_dday=[]
spec_x = []
spec_y = []
spec_z = []
spec_dday =[]
     for over_count = 0,18 do begin
       filename = 'Documents\IDL\MGS_fft_results\m'+yy+'d'+ddd+'_fft'+strtrim(over_count,1)+'.sav'
       if file_test(filename) eq 1 then begin
         restore, filename=filename
         day_dday=[day_dday,dday]
         spec_x = [spec_x,avg_mag_spec_x]
         spec_y = [spec_y,avg_mag_spec_y]
         spec_z = [spec_z,avg_mag_spec_z]
         spec_dday = [spec_dday,fft_dday_track]
         endif
         endfor
         
         ;only part of the day that is lt 400 km and the rate is 32 Hz
         
         
;time_secs=make_array(n_elements(bxss))
;seconds_in_a_year = 365.*24.*60.*60.
;seconds_in_a_day = 24.*60.*60.
; for i = 0,n_elements(dday)-1 do begin
;   if yy eq '97' then year_count =0
;   if yy eq '98' then year_count =1
;   if yy eq '99' then year_count =2
;
;   time_secs(i) = 852094800.+((double(dday(i))-1.)*seconds_in_a_day)+year_count*(seconds_in_a_year)
;
;
; endfor




;store_data,'bxss',data={x:day_dday,y:bxss}
;store_data,'byss',data={x:day_dday,y:byss}
;store_data,'bzss',data={x:day_dday,y:bzss}

sum_spec= spec_x+spec_y+spec_z
;store_data,'spec_sum',data={x:spec_dday,y:sum_spec}

spectime = spec_dday
magtime = day_dday
where_overlap = make_array(n_elements(spectime))
for i = 0, n_elements(spectime)-1 do begin
where_overlap(i) = where(magtime eq spectime(i))
endfor


jre_magplot,magtime,bxss,byss,bzss,spectime,$
  sum_spec,freqlower=3, freqhigher=16, spectralow=-3, spectrahigh=1
;jre_magplot,magtime,bxss,byss,sum_spec




endif




wavelet_plot = 'n'
if wavelet_plot eq 'y' then begin
restore,'C:\Users\tesman\Documents\IDL\MGS_fft_results\m97d291_fft0.sav'

new_time = 852094800.+(new_dday*24.*60.*60.)
store_data,'bxss',data={x:new_time,y:new_bxss}
get_data,'bxss',data=data

bxwave=wavelet(new_bxss, 1./32., period=period, /pad, param=12)
bxpsd=alog10(abs(bxwave)^2)


;bywave=wavelet(bypay[overlapstart(i):overlapend(i)], 1./rate[overlapstart(i)], period=period, /pad, param=12)
;bypsd=alog10(abs(bywave)^2)
;bzwave=wavelet(bzpay[overlapstart(i):overlapend(i)], 1./rate[overlapstart(i)], period=period, /pad, param=12)
;bzpsd=alog10(abs(bzwave)^2)

window, 3, xsize=1500, ysize=900
device,decompose=0
!p.charsize=1
loadct, 39
plotxyz, new_dday, 1./period, bxpsd, /noiso, /ylog, ticklen=-0.02, yrange=[1,16],zrange=[-4,1],ytitle='Hz', xstyle=1,xtitle='Decimal Day',title=fn
;plotxyz, dday[overlapstart(i):overlapend(i)], 1./period, bypsd, /noiso, /ylog, yrange=[7,15], $
;  zrange=[-3,-1], ticklen=-0.02, /addpanel, ytitle='Hz', xtitle='Decimal Day',xstyle=1
;plotxyz, dday[overlapstart(i):overlapend(i)], 1./period, bzpsd, /noiso, /ylog, yrange=[7,15], $
  ;zrange=[-3,-1], ticklen=-0.02, /addpanel, ytitle='Hz', xtitle='Decimal Day',xstyle=1

  endif
  end