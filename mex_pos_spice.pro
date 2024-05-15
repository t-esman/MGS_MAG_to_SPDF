pro MEX_pos_spice,MEX_x,MEX_y,MEX_z
  R_M = double(3390.0)
  restore,'shocks_mse.sav'
  ;clear what is in spice
  cspice_kclear
  ;load kernels
  mk=mvn_spice_kernels(/all,/load)
  KERNELS_TO_LOAD = ['/Users/tesman/Desktop/MARS-EXPRESS/spk/ORMM_T19_140901000000_01102.BSP']
  cspice_furnsh, KERNELS_TO_LOAD
  ;; Define the number of divisions of the time interval and the time interval.
  STEP = 20000
  utc = [ 'September 23, 2014', 'September 24, 2014' ]
  cspice_str2et, utc, et
  times = [et[0]]
  ;new way defining step size
  while times[-1] lt et[1] do begin
    newTime = times[-1]+(30.0*60.0)
    times = [times, newTime]
  endwhile
  ;Old way defining steps
  times2 = dindgen(STEP)*(et[1]-et[0])/STEP + et[0]
  ;determine state vector
  cspice_spkpos, 'MEX', times, 'MAVEN_MSO', 'NONE', 'MARS', pos, ltime
  ; cspice_spkpos, 'Deimos', times, 'MAVEN_PL', 'NONE', 'MARS', pos_PL, ltime
  ;; Plot the resulting trajectory.
  x = transpose(pos[0,*]/R_M)
  y = transpose(pos[1,*]/R_M)
  z = transpose(pos[2,*]/R_M)
  rho_p = sqrt(y^2+z^2)
  ;;Determine the times
  cspice_timout, times, 'YYYY', 5, year
  cspice_timout, times, 'DOY', 4, doy
  cspice_timout, times, 'HR', 3, hour
  cspice_timout, times, 'MN', 3, minute
  cspice_timout, times, 'SC', 3, second
  ;Make a sanity check plot
  pS = scatterplot(x,y, symbol='o', sym_size=0.5, /aspect_ratio)
  pS.yrange=[-4.0, 1.0]
  pS.xrange=[-4.0, 1.0]
  pS.xtitle='Mars X [R_M]'
  pS.ytitle='Mars Y [R_M]'
 ; pMars = ellipse(0.0, 0.0, '-2', major=1.0, /data, fill_color='dark red')
  pBS = plot(xshock/RM,yshock/RM,linestyle=2,thick=2,/overplot,color='r',name='BS')
  pMPB = plot(xpileup/RM,ypileup/RM,linestyle=2,thick=2,/overplot,color='m',name='MPB')


  pS1 = scatterplot(x,z, symbol='o', sym_size=0.5, /aspect_ratio)
  pS1.yrange=[-4.0, 1.0]
  pS1.xrange=[-4.0, 1.0]
  pS1.xtitle='Mars X [R_M]'
  pS1.ytitle='Mars Z [R_M]'
 ; pMars = ellipse(0.0, 0.0, '-2', major=1.0, /data, fill_color='dark red')
  pBS = plot(xshock/RM,yshock/RM,linestyle=2,thick=2,/overplot,color='r',name='BS')
  pMPB = plot(xpileup/RM,ypileup/RM,linestyle=2,thick=2,/overplot,color='m',name='MPB')

  ;;print to a file
  outFile = 'MEX_pos_20140923_20140924.txt'
  openw, 1, outFile
  printf, 1, '  Year  '+$
    '  DOY  '+$
    '  HR  '+$
    '  MN  '+$
    '  SC  '+$
    '  X_MSO [km]  '+$
    '  Y_MSO [km]  '+$
    '  Z_MSO [km]  '
  for i=0, n_elements(times)-1 do begin
    printf, 1, '  '+year[i]+'  '+$
      '  '+doy[i]+'  '+$
      '  '+hour[i]+'  '+$
      '  '+minute[i]+'  '+$
      '  '+second[i]+'  '+$
      '  '+strtrim(string(pos[0,i]),1)+'   '+$
      '  '+strtrim(string(pos[1,i]),1)+'   '+$
      '  '+strtrim(string(pos[2,i]),1)+'   '
  endfor
  close, 1
  mex_x=pos(0,*)
  mex_y=pos(1,*)
  mex_z=pos(2,*)
end