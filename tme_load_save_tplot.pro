pro tme_load_save_tplot
timespan,'2014-09-22',1
mk = mvn_spice_kernels(/all, /load)
mvn_mag_load, spice_frame='MAVEN_MSO'
split_vec, 'mvn_B_1sec_MAVEN_MSO'
options, 'mvn_B_1sec_MAVEN_MSO_x', ytitle='B!Dx!N [nT]'
options, 'mvn_B_1sec_MAVEN_MSO_y', ytitle='B!Dy!N [nT]'
options, 'mvn_B_1sec_MAVEN_MSO_z', ytitle='B!Dz!N [nT]'
get_data, 'mvn_B_1sec_MAVEN_MSO', data=data, alim=alim, dlim=dlim
bmag = sqrt(data.y[*,0]^2.0+data.y[*,1]^2.0+data.y[*,2]^2.0)
dataMag = {x:data.x, y:bmag}
store_data, 'mvn_B_mso_mag', data=dataMag, dlim=dlim
options, 'mvn_B_mso_mag', ytitle='|B| [nT]'

;../../Volumes/Tesman_WD/maven/mag/l1/sav/full/
end

; Step 1: get the data
; get_data, 'mvn_swi_mso_vel_mag',data=data
; Step 2: find the time range
; mvnTimeSpan = [time_double('2014-12-27/07:00:00'), time_double('2014-12-27/07:20:00')]
; indAnalyzed = where(data.x ge mvnTimeSpan[0] and data.x le mvnTimeSpan[1])
; Step 3: Find the mean
; avg_vel_mag = mean(data.y[indAnalyzed])
; Step 4: Subtract the mean from the data
; vel_fluc = data.y[indAnalyzed] - avg_vel_mag
; avg_vel_fluc = mean(vel_fluc)
; 
; mvnTimeSpan = [time_double('2014-12-27/07:00:00'), time_double('2014-12-27/07:20:00')]
;indAnalyzed = where(datamag.x ge mvnTimeSpan[0] and datamag.x le mvnTimeSpan[1])
;avg_B_mag = mean(datamag.y[indAnalyzed])
;mag_fluc = datamag.y[indAnalyzed] - avg_B_mag
;avg_B_fluc = mean(mag_fluc)
;

;
;Circular/Elliptical analysis
;get_data,'mvn_B_1sec_MAVEN_MSO_x',data=datax
;get_data,'mvn_B_1sec_MAVEN_MSO_y',data=datay
;get_data,'mvn_B_1sec_MAVEN_MSO_z',data=dataz
;mvnTimeSpan = [time_double('2014-09-22/18:03:00'), time_double('2014-09-22/18:38:00')]
;indAnalyzed = where(dataz.x ge mvnTimeSpan[0] and dataz.x le mvnTimeSpan[1])
;wave_x = datax.y[indAnalyzed]
;wave_y = datay.y[indAnalyzed]
;wave_z = dataz.y[indAnalyzed]
;jre_mf_calc,wave_x,wave_y,wave_z,bpar,bt,bn,btran,rotang
;


; orbit_rounded = round(dataorb.y-0.5)
; indx_uniq=uniq(orbit_rounded)
; i need the tplot information, so i need to reload the result files 
; also need to load the localtime information 
; getting localtime at periapse is going to be annoying... 
; ... isn't there a variable that shows periapse time???? yes
; everything is a different size, so we have to go off time
; 1) time of periapse
; tperi=dataplon.x
; for i = 0,n_elements(tperi)-1 do begin
; test(i) = where(dataorb.x eq tperi(i))
; endfor