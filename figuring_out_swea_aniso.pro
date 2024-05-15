pro figuring_out_swea_aniso,df, vpara, vperp, dens, Babs, A_vpara, gr_fce, f_fce, rdf
restore,'wavearray.sav'
  k=0

 ; print,wave_array(k)
  mm = strmid(wave_array(k),0,2)
  day = strmid(wave_array(k),3,2)
  yy = strmid(wave_array(k),6,2)
  daystring='20'+yy+'-'+mm+'-'+day
  timespan,daystring,1
  mk = mvn_spice_kernels(/all, /load)
  hour = strmid(wave_array(k),9,2)
  minute = strmid(wave_array(k),12,2)
  second =strmid(wave_array(k),15,2)

  ehour=strmid(wave_array(k),18,2)
  eminute=strmid(wave_array(k),21,2)
  esecond=strmid(wave_array(k),24,2)
  ; timespan, 'time ' , 5, /minutes
  ;time = [time_double(' '): time_double(' ')]


  ;mvn_swe_topo
  ; rpad=mvn_swe_getpad(time)
  time= [time_double('20'+yy+'-'+mm+'-'+day+'/'+hour+':'+minute+':'+second):time_double('20'+yy+'-'+mm+'-'+day+'/'+ehour+':'+eminute+':'+esecond)]
;maybe time needs to be smaller? isn't lpw cadence 4s... this broke idl (2 second interval)



timespan,'2015-01-23',1

  ;mvn_swe_load_l2, /spec,/pad ; loads stuff into the common block....?

 ; pad = mvn_swe_getpad(time, /sum)
 ;64 energy, 16 original SWEA angular bins that cover 0- pi twice in radians 
  
 ; The enepa2vv assumes that the energy and pa arrays have the same dimension as the data. Also, it looks like pad.pa returns pitch angles in radians, while enepa2vv assumes degrees. Given your purpose, you might also want to convert the units to the distribution function. My suggested use is:

 mvn_swe_load_l2,/spec,/pad
 mvn_swe_addmag
 mvn_swe_addlpw
 mvn_mag_tplot,['mvn_B_1sec']
 get_data,'mvn_mag_l2_bamp_1sec', data = B_data
 Babs = B_data.y(where(b_data.x gt time(0) and b_data.x lt time(n_elements(time)-1)))

 get_data,'mvn_lpw_lp_ne_l2',data=lpw_data
 dens = lpw_data.y(where(lpw_data.x gt time(0) and lpw_data.x lt time(n_elements(time)-1)))
 pad = mvn_swe_getpad(time,/sum) ; time is a time interval of a wave event - ok but mag and dens not limited by time... is this an issue?
 
 
 
 
 
 pad2 = conv_units(pad,'df') ; convert units to df - what does this mean? what does f mean? distribution function... 
 energy = pad2.energy
 pa = pad2.pa * !radeg ;- convert radian to degree
 data = pad2.data
; enepa2vv,data,energy,pa,newdata,vpara,vperp,erange=[10,1000] ; set erange to only include meaningful counts

; The newdata contains the interpolated data into a regular grid (vpara,vperp):

 ;You can visualize the results by using contour, specplot, plotxyz and other tools, for example:

 ;specplot,reform(vpara[*,0]),reform(vperp[0,*]),newdata, lim={xmargin:[10,12],zlog:1,zrange:[1e-18,1e-10],ztitle:units_string('df'),xtitle:'v_par [km/s]',ytitle:'v_perp [km/s]',title:time_string(pad.time)}

 ;Attached is a random example.

 ;Sometimes smoothing is useful to reduce statistical fluctuations and the /mirror_vperp option returns a better interpolation near pa=0,180:
 enepa2vv,data,energy,pa,newdata,vpara,vperp,erange=[10,1000],smooth=7,/mirror_vperp
 specplot,reform(vpara[*,0]),reform(vperp[0,*]),newdata, lim={xmargin:[10,12],zlog:1,zrange:[1e-18,1e-10],ztitle:units_string('df'),xtitle:'v_par [km/s]',ytitle:'v_perp [km/s]',title:time_string(pad.time)}



df = newdata
dens = mean(dens,/NaN)
print,dens
Babs = mean(Babs,/NaN)
print,Babs



aniso, df, vpara, vperp, dens, Babs, A_vpara, gr_fce, f_fce, rdf ;, vg=vg, gr_len=gr_len
;INPUTS:
;       df: distribution function as a function of
;           regularly-gridded vpara and vperp
;       vpara: parallel velocities of the data points
;       vperp: perpendicular velocities of the data points
;       dens: density in cm-3 required for the growth rate calculation
;       Babs: |B| in nT required for the growth rate calculation
;       avpara: named variable to return the anisotropy
;       gr_fce: named variable to return the growth rate/fce for
;               whistler mode as a function of f_fce
;       f_fce: named variable to return the frequency/fce for gr_fce
;       rdf: named variable to return the reduced distribution function


 
 

 ;tr2 = '2015-01-23:'+['00','05']
 ;tr2= '2015-05-01/17:'+['45','47']
 
 
 




end
