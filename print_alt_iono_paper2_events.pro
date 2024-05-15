pro print_alt_iono_paper2_events
;what if i interpolated? probably useful.... 
restore,'wavearray.sav'
fname='wave_event_alt.txt'
openw,lun,fname,/get_lun,/append

for k = 0, n_elements(wave_array)-1 do begin 
mm = strmid(wave_array(k),0,2)
day = strmid(wave_array(k),3,2)
yy = strmid(wave_array(k),6,2)
daystring='20'+yy+'-'+mm+'-'+day
timespan,daystring,1
mk = mvn_spice_kernels(/all, /load)
hour = strmid(wave_array(k),9,2)
minute = strmid(wave_array(k),12,2)
second =strmid(wave_array(k),15,2)

ehour=strmid(wave_array(k),18,2)
eminute=strmid(wave_array(k),21,2)
esecond=strmid(wave_array(k),24,2)




if ((yy eq '16') and (mm eq '07') and (day eq '22')) or ((yy eq '17') and (mm eq '11') and (day eq '02')) then begin
  restore,filename='../../../../Volumes/ExtremeSSD/MAVEN/Nei/mvn_wavealt_'+yy+mm+day+'_'+hour+minute+second+'20.sav'

endif else begin
  restore,filename='../../../../Volumes/ExtremeSSD/MAVEN/Nei/mvn_wavealt_'+yy+mm+day+'_'+hour+minute+'20.sav'
endelse


printf,lun, daystring
printf,lun, hour+minute+second
printf,lun, ' '
printf,lun, wave_alt
printf,lun, ' '


endfor

close,lun
end