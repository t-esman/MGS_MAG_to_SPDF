pro read_lowalt_from_csv,lat,lon
testfile='LowAltCode/LowAltCompiled.csv'
data = READ_CSV(testfile, HEADER=SedHeader, $
  N_TABLE_HEADER=1, TABLE_HEADER=SedTableHeader)
  
  
  string_date=data.field01
  latitude=data.field03
  longitude=data.field04
  lat=fltarr(n_elements(longitude))
  lon=fltarr(n_elements(longitude))
  for i = 0,n_elements(latitude)-1 do begin
    lat(i)=double(latitude(i))
lon(i)=double(longitude(i))
  endfor

  
  end