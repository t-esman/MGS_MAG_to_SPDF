pro pickup_dens
;data=read_csv('DistantWavesCode/feldmandata.csv',header=sedheader,n_table_header=1,table_header=sedtableheader)
data=read_csv('DistantWavesCode/newfeldman.csv',header=sedheader,n_table_header=1,table_header=sedtableheader)
m=make_array(10000,increment=-1.e5/10000.,start=1.e5,/index) ;km
m=reverse(m)
altitude=data.field2; km
neu_density=data.field1 ;/cc
r_m=339E6;cm
newdensity=interpol(neu_density,altitude,m)

;plot,newdensity,m
;print, newdensity(0)
altitude_cm=altitude*1e5 ;cm

;altitude_cm=m*1e5
;x=where(altitude_cm/r_m gt 4.999 and altitude_cm/r_m lt 5.001)
;print,x

i=44 ;x(0) ; 9 is approx 14 Rm, 20 is approx 3.5 Rm, 19 is approx 4 Rm, 17 is approx 5
;new is 18, 29, 44
int_density=int_tabulated(altitude_cm(0:i),neu_density(0:i))
;int_density=int_tabulated(altitude_cm(0:i),newdensity(0:i))

ionizationRate=3e-7; /s
v=7e7 ; cm/s
print,int_density
pickupdens=int_density*ionizationRate*1/v
print,pickupdens
print,'at'
print,altitude_cm(i)/r_m
print,'R_m'

end