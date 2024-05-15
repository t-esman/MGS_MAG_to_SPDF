pro orbit_to_phys,peri_indx

restore,'result2014.sav'

 orbit_rounded = round(dataorb.y-0.5)
indx_uniq=uniq(orbit_rounded)
; i need the tplot information, so i need to reload the result files
; maven_orbit_tplot,/load,/current,result=result
; mvn_mars_localtime,result=dataLT
;resave orbit so that they are all the same size/
 tperi=dataplon.x ; get the time of periapse
 peri_indx=make_array(n_elements(tperi)) ;setup array for location of peri in dataorb
for i = 0,n_elements(tperi)-1 do begin
 peri_indx(i) = where(dataorb.x eq tperi(i))

if peri_indx(i) eq -1 then peri_indx(i) = !values.F_NAN
 endfor

nan_indx = where(finite(peri_indx) eq 0)
if nan_indx(0) ne -1 then remove,nan_indx,peri_indx
end