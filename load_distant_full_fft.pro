pro load_distant_full_fft

tplot_restore,filename='DistantWavesCode/09222014.tplot'

get_data,'fft_x',data=fft_x
get_data,'fft_y',data=fft_y
get_data,'fft_z',data=fft_z
get_data,'mvn_B_mso_mag',data=data
get_data,'alt',data=alt
get_data,'sza',data=sza
get_data,'mvn_B_full_MAVEN_MSO_x',data=magfullx
get_data,'mvn_B_full_MAVEN_MSO_y',data=magfully
get_data,'mvn_B_full_MAVEN_MSO_z',data=magfullz


tplot_restore,filename='DistantWavesCode/09232014.tplot'

get_data,'fft_x',data=fft_x1
get_data,'fft_y',data=fft_y1
get_data,'fft_z',data=fft_z1
get_data,'mvn_B_mso_mag',data=data1
get_data,'alt',data=alt1
get_data,'sza',data=sza1
get_data,'mvn_B_full_MAVEN_MSO_x',data=magfullx1
get_data,'mvn_B_full_MAVEN_MSO_y',data=magfully1
get_data,'mvn_B_full_MAVEN_MSO_z',data=magfullz1

mag_full_x=[magfullx.y,magfullx1.y]
mag_full_y=[magfully.y,magfully1.y]
mag_full_z=[magfullz.y,magfullz1.y]
magfulltime= [magfullx.x,magfullx1.x]
solarzen = [sza.y,sza1.y]
szatime = [sza.x,sza1.x]
altitude=[alt.y,alt1.y]
alt_time = [alt.x,alt1.x]
fft_x_val = [fft_x.y,fft_x1.y]
fft_y_val = [fft_y.y,fft_y1.y]
fft_z_val = [fft_z.y,fft_z1.y]
fft_time = [fft_x.x,fft_x1.x]
mvn_B = [data.y,data1.y]
time = [data.x,data1.x]




tplot_restore,filename='DistantWavesCode/09242014.tplot'

get_data,'fft_x',data=fft_x2
get_data,'fft_y',data=fft_y2
get_data,'fft_z',data=fft_z2
get_data,'mvn_B_mso_mag',data=data2
get_data,'alt',data=alt2
get_data,'sza',data=sza2
get_data,'mvn_B_full_MAVEN_MSO_x',data=magfullx2
get_data,'mvn_B_full_MAVEN_MSO_y',data=magfully2
get_data,'mvn_B_full_MAVEN_MSO_z',data=magfullz2

mag_full_x=[mag_full_x,magfullx2.y]
mag_full_y=[mag_full_y,magfully2.y]
mag_full_z=[mag_full_z,magfullz2.y]
magfulltime= [magfulltime,magfullx2.x]
solarzen = [solarzen,sza2.y]
szatime = [szatime,sza2.x]

altitude=[altitude,alt2.y]
alt_time = [alt_time,alt2.x]
fft_x_val = [fft_x_val,fft_x2.y]
fft_y_val = [fft_y_val,fft_y2.y]
fft_z_val = [fft_z_val,fft_z2.y]
fft_time = [fft_time,fft_x2.x]
mvn_B = [mvn_B,data2.y]
time = [time,data2.x]


tplot_restore,filename='DistantWavesCode/09252014.tplot'

get_data,'fft_x',data=fft_x3
get_data,'fft_y',data=fft_y3
get_data,'fft_z',data=fft_z3
get_data,'mvn_B_mso_mag',data=data3
get_data,'alt',data=alt3
get_data,'sza',data=sza3
get_data,'mvn_B_full_MAVEN_MSO_x',data=magfullx3
get_data,'mvn_B_full_MAVEN_MSO_y',data=magfully3
get_data,'mvn_B_full_MAVEN_MSO_z',data=magfullz3

mag_full_x=[mag_full_x,magfullx3.y]
mag_full_y=[mag_full_y,magfully3.y]
mag_full_z=[mag_full_z,magfullz3.y]
magfulltime= [magfulltime,magfullx3.x]
solarzen = [solarzen,sza3.y]
szatime = [szatime,sza3.x]

altitude=[altitude,alt3.y]
alt_time = [alt_time,alt3.x]
fft_x_val = [fft_x_val,fft_x3.y]
fft_y_val = [fft_y_val,fft_y3.y]
fft_z_val = [fft_z_val,fft_z3.y]
fft_time = [fft_time,fft_x3.x]
mvn_B = [mvn_B,data3.y]
time = [time,data3.x]


tplot_restore,filename='DistantWavesCode/09262014.tplot'

get_data,'fft_x',data=fft_x4
get_data,'fft_y',data=fft_y4
get_data,'fft_z',data=fft_z4
get_data,'mvn_B_mso_mag',data=data4
get_data,'alt',data=alt4
get_data,'sza',data=sza4
get_data,'mvn_B_full_MAVEN_MSO_x',data=magfullx4
get_data,'mvn_B_full_MAVEN_MSO_y',data=magfully4
get_data,'mvn_B_full_MAVEN_MSO_z',data=magfullz4

mag_full_x=[mag_full_x,magfullx4.y]
mag_full_y=[mag_full_y,magfully4.y]
mag_full_z=[mag_full_z,magfullz4.y]
magfulltime= [magfulltime,magfullx4.x]
solarzen = [solarzen,sza4.y]
szatime = [szatime,sza4.x]

altitude=[altitude,alt4.y]
alt_time = [alt_time,alt4.x]
fft_x_val = [fft_x_val,fft_x4.y]
fft_y_val = [fft_y_val,fft_y4.y]
fft_z_val = [fft_z_val,fft_z4.y]
fft_time = [fft_time,fft_x4.x]
mvn_B = [mvn_B,data4.y]
time = [time,data4.x]

tplot_restore,filename='DistantWavesCode/09272014.tplot'

get_data,'fft_x',data=fft_x5
get_data,'fft_y',data=fft_y5
get_data,'fft_z',data=fft_z5
get_data,'mvn_B_mso_mag',data=data5
get_data,'alt',data=alt5
get_data,'sza',data=sza5
get_data,'mvn_B_full_MAVEN_MSO_x',data=magfullx5
get_data,'mvn_B_full_MAVEN_MSO_y',data=magfully5
get_data,'mvn_B_full_MAVEN_MSO_z',data=magfullz5

mag_full_x=[mag_full_x,magfullx5.y]
mag_full_y=[mag_full_y,magfully5.y]
mag_full_z=[mag_full_z,magfullz5.y]
magfulltime= [magfulltime,magfullx5.x]
solarzen = [solarzen,sza5.y]
szatime = [szatime,sza5.x]

altitude=[altitude,alt5.y]
alt_time = [alt_time,alt5.x]
fft_x_val = [fft_x_val,fft_x5.y]
fft_y_val = [fft_y_val,fft_y5.y]
fft_z_val = [fft_z_val,fft_z5.y]
fft_time = [fft_time,fft_x5.x]
mvn_B = [mvn_B,data5.y]
time = [time,data5.x]

store_data,'alt',data={x:alt_time,y:altitude}
store_data,'mvn_B_mso_mag',data={x:time,y:mvn_B}
store_data,'fft_x',data={x:fft_time,y:fft_x_val}
store_data,'fft_y',data={x:fft_time,y:fft_y_val}
store_data,'fft_z',data={x:fft_time,y:fft_z_val}
store_data,'mvn_B_full_MAVEN_MSO_x',data={x:magfulltime,y:mag_full_x}
store_data,'mvn_B_full_MAVEN_MSO_y',data={x:magfulltime,y:mag_full_y}
store_data,'mvn_B_full_MAVEN_MSO_z',data={x:magfulltime,y:mag_full_z}

tplot_save,filename='distant_full_fft'
end