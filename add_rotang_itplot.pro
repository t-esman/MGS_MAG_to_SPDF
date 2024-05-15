pro add_rotang_itplot,start_time,end_time,firsttime,res


 mvn_mag_circ_check, bpar, bt, bn, btran, rotang,time,start_time=start_time, end_time=end_time,res=res


databn = {x: time, y:bn}
store_data,'bn',data=databn
options,'bn',ytitle = 'bn (nT)'
ylim,'bn',default=default
;     options,'bn',yrange=[-1.0,1.0]
databt= {x: time, y:bt}
store_data,'bt',data=databt
options,'bt',ytitle = 'bt (nT)'
ylim,'bt',default=default
;     options,'bt',yrange=[-1.0,1.0]
  ; databtran = {x: time, y:btran}
   ;store_data,'btran',data=databtran
   ;options,'btran',ytitle = 'btran (nT)'

   databpar = {x:time, y:bpar}
   store_data,'bpar',data=databpar
   options,'bpar',ytitle = 'bpar (nT)'
ylim,'bpar',default=default
;     options,'bpar',yrange=[-1.0,1.0]

   datarotang = {x:time,y:rotang}
   store_data,'rotang',data=datarotang
   options,'rotang',ytitle='rotang (degree)'
   options,'rotang',psym=2
  
   ylim,'rotang',-180,180
   get_data,'bn',data=bn
   get_data,'bt',data=bt
   transverse=bn.y+bt.y;sqrt(bn.y^2+bt.y^2)
   store_data,'transverse',data={x:bn.x, y:transverse}
   
   if firsttime EQ 'y' then begin
     tplot, 'rotang', /add
     tplot, 'bpar', /add
    ; tplot,'bn',/add
    ; tplot, 'bt', /add
     tplot,'transverse',/add
     ;tplot, 'btran', /add
   endif else begin tplot
 endelse


end
