pro create_multiday_tplot

  store_data_x=[]
  store_data_y=[]
  store_data_z=[]
  store_data_time=[]



  for year = 2018,2019 do begin
    if year eq 2018 then i=12
    if year eq 2019 then i=1
    for j = 1,31 do begin
      if i lt 10 then begin
        month='0'+strtrim(string(i),2)
      endif else begin
        month=strtrim(string(i),2)
      endelse

      if j lt 10 then begin
        day='0'+strtrim(string(j),2)
      endif else begin
        day=strtrim(string(j),2)
      endelse

      if file_search('../../../../Volumes/Tesman_WD/MAVEN/tplot_files/mag/pl/'+strtrim(string(year),2)+'/mvn_mag_l2_pl_full_'+strtrim(string(year),2)+month+day+'_pl.tplot') ne '' then begin $
        tplot_restore,filename='../../../../Volumes/Tesman_WD/MAVEN/tplot_files/mag/pl/'+strtrim(string(year),2)+'/mvn_mag_l2_pl_full_'+strtrim(string(year),2)+month+day+'_pl.tplot'

      split_vec,'mvn_B_full'

      get_data,'mvn_B_full_x',data=datax
      get_data,'mvn_B_full_y',data=datay
      get_data,'mvn_B_full_z',data=dataz

      store_data_x=[store_data_x,datax.y]
      store_data_y=[store_data_y,datay.y]
      store_data_z=[store_data_z,dataz.y]
      store_data_time=[store_data_time,datax.x]


    endif
endfor
  endfor
 store_data,'mvn_B_full_x',data={x:store_data_time,y:store_data_x}
 store_data,'mvn_B_full_y',data={x:store_data_time,y:store_data_y}
 store_data,'mvn_B_full_z',data={x:store_data_time,y:store_data_z}
 
 tplot_save,['mvn_B_full_x','mvn_B_full_y','mvn_B_full_z'],filename='dec_jan_1819_proton'

 
end
