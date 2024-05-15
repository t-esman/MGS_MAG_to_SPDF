pro low_alt_find_latlon,find_latlon

restore,filename='enhanced_array_tensec_smooth_comp_pt03.sav'


string_comp=string_comp(uniq(string_comp))
lon_comp=lon_comp(uniq(eph_comp))
lat_comp=lat_comp(uniq(eph_comp))
eph_comp=eph_comp(uniq(eph_comp))
string_date=strarr(n_elements(eph_comp))
for i = 0,n_elements(eph_comp)-1 do begin
time_structure=time_struct(eph_comp(i))

string_date(i)=strtrim(string(time_structure.month),2)+'-'+strtrim(string(time_structure.date),2)+$
  '-'+strtrim(string(time_structure.year),2)+'/'+strtrim(string(time_structure.hour),2)+':'+strtrim(string(time_structure.min),2)+$
  ':'+strtrim(string(time_structure.sec),2)
endfor

x=where(string_date eq find_latlon)
if x(0) ne -1 then begin
print, 'Latitude is equal to: '
print,lat_comp(x(0))
print,'Longitude is equal to: ' 
print,lon_comp(x(0))
endif else begin
  print,'Negative One Problem'
restore,filename= 'enhanced_array_tensec_smooth_comp_indpt01.sav'
string_comp=string_comp(uniq(string_comp))
lon_comp=lon_comp(uniq(eph_comp))
lat_comp=lat_comp(uniq(eph_comp))
eph_comp=eph_comp(uniq(eph_comp))
string_date=strarr(n_elements(eph_comp))
for i = 0,n_elements(eph_comp)-1 do begin
  time_structure=time_struct(eph_comp(i))

  string_date(i)=strtrim(string(time_structure.month),2)+'-'+strtrim(string(time_structure.date),2)+$
    '-'+strtrim(string(time_structure.year),2)+'/'+strtrim(string(time_structure.hour),2)+':'+strtrim(string(time_structure.min),2)+$
    ':'+strtrim(string(time_structure.sec),2)
endfor

x=where(string_date eq find_latlon)
if x(0) ne -1 then begin
  print, 'Latitude is equal to: '
  print,lat_comp(x(0))
  print,'Longitude is equal to: '
  print,lon_comp(x(0))
endif else begin
  print,'Negative One Problem'
  print,string_comp
endelse
endelse
end