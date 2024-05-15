pro plots_for_orals
full_result_lst=[]
full_result_lat=[]
full_result_lon=[]
full_result_alt=[]
full_result_sza=[]
full_psza=[]
full_plon=[]
full_plat=[]

for i=1,5 do begin

if i eq 1 then begin
  restore,'result2014.sav'
  print,'2014'
  color='k'
endif
if i eq 2 then begin
  restore,'result2015.sav'
  print,'2015'
  color='g'
endif
if i eq 3 then begin
  restore,'result2016.sav'
  print,'2016'
  color='r'
endif
if i eq 4 then begin
  restore,'result2017.sav'
  print,'2017'
color='b'
endif
if i eq 5 then begin
  restore,'result2018.sav'
  print,'2018'
color='y'
endif
full_result_lst=[full_result_lst,datalt.lst]
full_result_lat=[full_result_lat,result.lat]
full_result_lon=[full_result_lon,result.lon]
full_result_alt=[full_result_alt,result.hgt]
full_result_sza=[full_result_sza,result.sza]
full_psza=[full_psza,datapsza.y]
full_plon=[full_plon,dataplon.y]
full_plat=[full_plat,dataplat.y]


endfor
save,filename='full_result.sav',full_result_lst,full_result_lat,full_result_lon,full_result_sza,full_result_alt,full_psza,full_plon,full_plat

;density,full_result_lst,full_result_lat,ct=2
;if i eq 1 then begin
; density,datalt.lst,result.lat,ct=2
;  ;p=plot(datalt.lst,result.lat,'k',sym='S')
;endif else begin
;  density,datalt.lst,result.lat,ct=2,/overplot
;  ;p=plot(datalt.lst,result.lat,color,sym='S',/overplot)
;endelse
;
;
;endfor
end