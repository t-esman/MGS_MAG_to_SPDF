pro lowalt_event_findorbit,sorted_orbits

lowalt_events=['15-01-23','15-01-30','15-05-01','15-05-11','15-07-07','15-07-19','15-07-22','15-11-02',$
  '16-01-11','16-01-15','16-01-21','16-01-25','16-05-07','16-07-14','16-07-22','16-07-27','16-07-28',$
  '16-07-29','16-08-02','16-08-27','17-01-22','17-01-26','17-09-13','17-11-02','17-11-19','17-11-20',$
  '18-01-04','18-01-30','18-02-02','18-02-10','18-02-19','18-02-23','18-02-25','18-03-06','18-05-18',$
  '18-09-08','18-11-13','18-11-26','18-12-14','18-12-24','19-01-31','19-02-07','19-02-09','19-02-24',$
  '19-02-26']
  
  orbits=[0]
  for i = 3,n_elements(lowalt_events)-1 do begin

    subYear = strmid(lowalt_events(i),0,2)
    year = '20'+subYear
    print, year
    month = strmid(lowalt_events(i),3,2)
    day = strmid(lowalt_events(i),6,2)
    timespan,lowalt_events(i),1
    mvn_ngi_load
    get_data,'mvn_ngi_ion_osion_orbit',data=data
    orbits=[orbits,data.y]
    
  
    endfor
     sorted_orbits=orbits(uniq(orbits,sort(orbits a)))
  
  
  
  end