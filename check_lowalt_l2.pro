pro check_lowalt_l2,year,month,day
  length=1
  crust_on=0
  timespan,year+'-'+month+'-'+day,length
  mvn_swe_topo
  ;tplot_restore,filename='../../../../Volumes/Tesman_WD/MAVEN/tplot_files/mag/mso/'+year+'/mvn_mag_l2_pl_full_'+year+month+day+'.tplot
  restore,filename='../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_200/'+year+'/mvn_mag_l2_lt_200_full_'+year+month+'_pl.sav'
  ;tplot_restore,filename='../../../../Volumes/Tesman_WD/MAVEN/tplot_files/mag/pl/'+year+'/orbitresult'+year+'.tplot'
  restore,'ResultYearly/result'+year+'.sav'
  store_data,'lat',data={x:dataorb.x,y:result.lat}
  store_data,'lon',data={x:dataorb.x,y:result.lon}
  store_data,'alt',data={x:dataorb.x,y:result.hgt}
  store_data,'sza',data={x:dataorb.x,y:180./!pi*result.sza}
  ; dataorb = {x:time, y:orb_num}
  dataalt = {x:time, y:altitude}
  datax = {x:time, y:x_vec}
  datay = {x:time, y:y_vec}
  dataz = {x:time, y:z_vec}
  datamag = {x:time, y:bmag}


  store_data, 'mvn_B_mag', data=datamag, dlim=dlim
  store_data, 'mvn_B_full_x', data=datax, dlim=dlim
  store_data, 'mvn_B_full_y', data=datay, dlim=dlim
  store_data, 'mvn_B_full_z', data=dataz, dlim=dlim

  options, 'mvn_B_full_x', ytitle='B!Dx!N [nT]'
  options, 'mvn_B_full_y', ytitle='B!Dy!N [nT]'
  options, 'mvn_B_full_z', ytitle='B!Dz!N [nT]'

  options, 'mvn_B_mag', ytitle='|B| [nT]'
  options,'lon',yrange=[0,90]
  options,'lat',yrange=[0,20]
  options,'sza',yrange=[0,180]
  ; options, 'lon', yrange=[0, 360]
  
  if (year eq '2018') and (month eq '07') and (day eq '14') then begin
    tplot_restore,filename='191_197rw.tplot'
    mvn_mag_itplot,['mvn_B_full_x','mvn_B_full_y','mvn_B_full_z','mvn_B_mag','alt'],xyz_full='y',rw_check='y';'orbnum','sza','lat','lon'

  endif else begin
  mvn_mag_itplot,['sza','mvn_B_full_x','mvn_B_full_y','mvn_B_full_z','mvn_B_mag'],xyz_full='y';'orbnum','sza','lat','lon'
  ;,'lat','lon','alt','sza'
  ;mvn_mag_itplot,['mvn_B_mag','sza','lat','lon'],mf_rot='y',res=32
endelse


end