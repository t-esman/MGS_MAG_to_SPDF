;loadct2, 34
timespan, '2021-06-01', 900
maven_orbit_tplot, /load, result=result, extended=3

tplot, ['alt2']
ylim, 'lon', 0, 360

get_data, 'alt', data=altstruct
get_data, 'lat', data=latstruct
get_data, 'lon', data=lonstruct
get_data, 'sza', data=szastruct
alt=altstruct.y
alttime=altstruct.x
lat=latstruct.y
lon=lonstruct.y
sza=szastruct.y

;InSight
;good=where(alt LT 200. and (lat GE 1. and lat LE 7.) and (lon GE 133. and lon LE 139.) )

;Exomas EDL
;good=where(alt LT 200. and (lat GE -2. and lat LE 5.) and (lon GE 351. and lon LE 357.) )

;Tianwen-1
;https://www.space.com/china-mars-rover-tianwen-1-landing-site
;https://en.wikipedia.org/wiki/Tianwen-1#/media/File:Mars_map_with_landing_site_Tianwen-1.png
good=where(alt LT 200. and (lat GE 19 and lat LE 29) and (lon GE 105. and lon LE 115.) )

print,good
altperi=alt[good]
alttimeperi=alttime[good]
latperi=lat[good]
lonperi=lon[good]
szaperi=sza[good]

store_data, 'latperi', data={x:alttimeperi, y:latperi}
store_data, 'lonperi', data={x:alttimeperi, y:lonperi}
store_data, 'szaperi', data={x:alttimeperi, y:szaperi}

options, 'latperi', psym=1
options, 'lonperi', psym=1
options, 'szaperi', psym=1
ylim, 'lonperi', 130, 140
;ylim, 'altperi', 130, 200
;mvn_mag_itplot, ['palt', 'latperi', 'lonperi']
;mvn_mag_itplot, ['palt', 'alt', 'lon', 'lat', 'latperi', 'lonperi']

options, 'palt', ytitle='Alt. at periapsis!C[km]'
options, 'lonperi', ytitle='Lon. at periapsis!C[degrees]'
options, 'latperi', ytitle='Lat. at periapsis!C[degrees]'
options, 'sza', ytitle='Solar!CZenith!CAngle!C[degrees]'
options, 'szaperi', ytitle='SZA at periapsis!C[degrees]'

print, time_string(alttimeperi)

print, time_string(alttime[0])
print, time_string(alttime[-1])