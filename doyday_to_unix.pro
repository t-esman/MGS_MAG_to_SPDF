;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Purpose: switch from doy to unix time
;
;
;Inputs: year, day of year, hour, minute, second, msec
;Returns: unix time
;
;Author: Teresa Esman
;last edited: 11/9/2022
;11/9/2022 renamed to be more accurate to purpose
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


function doyday_to_unix,year,doy,hour,minute,second,msec
date=fltarr(5)


date(0) = float(year)
date(1) = float(doy)
date(2) = float(hour)
date(3) = float(minute)
date(4) = float(second+msec/1000.)

jd = date_conv(date,'julian')
unix_time=jul2unix(jd,time_string=time_string)
return,unix_time
end