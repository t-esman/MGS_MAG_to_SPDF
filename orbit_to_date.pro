pro orbit_to_date,lookup

  if lookup eq 0 then begin
    restore,'ResultYearly/result2014.sav'
    array_size=n_elements(dataorb.x)
    string_date=strarr(array_size)

    for i = 0,array_size-1 do begin

      time_structure=time_struct(dataorb.x(i))

      string_date(i)=strtrim(string(time_structure.month),2)+'-'+strtrim(string(time_structure.date),2)+$
        '-'+strtrim(string(time_structure.year),2)

    endfor
    print,''
    ; save, datalss,datalst,datalt,peri_indx,dataorb,dataplat,dataplon,datapsza,result,string_date,time_structure, filename='result2014.sav'
  endif

  if lookup eq 1 then begin
    read, orbit_number, prompt='Orbit number? '
    for year_test = 2014, 2019 do begin
      restore,'ResultYearly/result'+strtrim(string(year_test),2)+'.sav'
      find_indx = where((dataorb.y ge orbit_number) and (dataorb.y lt orbit_number+1))
      if find_indx(0) ne -1 then print,string_date(find_indx(0))
    endfor

  endif
end