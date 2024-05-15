pro add_only_rotang_itplot,start_time,end_time,freq,res


if res eq 1 then begin
get_data,'mvn_B_1sec_MAVEN_MSO_x',data=datax
get_data,'mvn_B_1sec_MAVEN_MSO_y',data=datay
get_data,'mvn_B_1sec_MAVEN_MSO_z',data=dataz
endif

if res eq 32 then begin
  mso='y'
if mso eq 'y' then begin
get_data,'mvn_B_full_MAVEN_MSO_x',data=datax
get_data,'mvn_B_full_MAVEN_MSO_y',data=datay
get_data,'mvn_B_full_MAVEN_MSO_z',data=dataz
endif else begin

get_data,'mvn_B_full_MAVEN_x',data=datax
get_data,'mvn_B_full_MAVEN_y',data=datay
get_data,'mvn_B_full_MAVEN_z',data=dataz
endelse
endif

mvnTimeSpan = [time_double(start_time), time_double(end_time)]
indAnalyzed = where(dataz.x ge mvnTimeSpan[0] and dataz.x le mvnTimeSpan[1] and finite(dataz.y) ne 0)
wave_x = datax.y[indAnalyzed]
wave_y = datay.y[indAnalyzed]
wave_z = dataz.y[indAnalyzed]

wave_x=jre_filter(wave_x,samplerate=1,high=1.5*freq)
wave_y=jre_filter(wave_y,samplerate=1,high=1.5*freq)
wave_z=jre_filter(wave_z,samplerate=1,high=1.5*freq)



time = dataz.x[indAnalyzed] ; because the time isn't passed ot jre_mf_calc, the discontinuities are ignored
jre_mf_calc,wave_x,wave_y,wave_z,bpar,bt,bn,btran,rotang

  datarotang = {x:time,y:rotang}
  store_data,'rotang',data=datarotang
  options,'rotang',ytitle='rotang (degree)'
  options,'rotang',psym=2
  ylim,'rotang',-180,180

 tplot
end
