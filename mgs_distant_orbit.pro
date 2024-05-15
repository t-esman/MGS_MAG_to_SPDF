
pro MGS_DISTANT_ORBIT

  ;Begin by loading the MGS file
  indAnalyzed=[]

  ;set Mars type variables
  R_m = 3389.9D
  R_e = 6371D
  ;Bin the MGS data
  nBins = 1000
  nBins35=400

  xrangeArray35 = findgen(nBins35+1, start=-200.0)/10.0
  yrangeArray35 = findgen(nBins35+1, start=-200.0)/10.0
  zrangeArray35 = findgen(nBins35+1, start=-200.0)/10.0
  srangeArray35 = findgen(nBins35+1, start=-200.0)/10.0

  x=date_conv('2014-09-22 16:56:00.00','J')
  e=2440587.5
  ;e2=735600.0
  unix_time = (x-e)*86400.


  ;mk = mvn_spice_kernels(/all, /load)
  ;Now load in the MAVEN data and bin it
  ; seems like this doesn't like my startup.pro
  ;maven_orbit_tplot, /load, /current, result=result
  restore,'result2014.sav'
restore,'distant_orb_data.sav'
  ;load in MVN distant magnetosphere data and bin it
  ;maven_orbit_tplot, /load, /current, result=result
  mvnTimeSpan = [time_double('2014-09-22/00:00:00'), time_double('2014-10-28/00:00:00')]
  M35Coverage = make_array(n_elements(xrangeArray35), $
    n_elements(yrangeArray35), $
    n_elements(zrangeArray35), $
    value = 0.0)
  M35CoverageSX = make_array(n_elements(xrangeArray35), $
    n_elements(srangeArray35), $
    value = 0.0)


  for i=0, n_elements(indAnalyzed)-1 do begin
    indX = where(xrangeArray35 gt result.x[indAnalyzed[i]])
    if indX[0] ne 0 then indX = indX[0]-1
    if indX[0] eq 0 then indX = 0

    indY = where(YrangeArray35 gt result.y[indAnalyzed[i]])
    if indY[0] ne 0 then indY = indY[0]-1
    if indY[0] eq 0 then indY = 0

    indZ = where(zrangeArray35 gt result.z[indAnalyzed[i]])
    if indZ[0] ne 0 then indZ = indZ[0]-1
    if indZ[0] eq 0 then indZ = 0

    curS = signum(result.z[indAnalyzed[i]])*sqrt((result.y[indAnalyzed[i]])^2.0+(result.z[indAnalyzed[i]])^2.0)
    ;curS = sqrt((result.y[indAnalyzed[i]])^2.0+(result.z[indAnalyzed[i]])^2.0)
    indS = where(srangeArray35 gt curS)
    if indS[0] ne 0 then indS = indS[0]-1
    if indS[0] eq 0 then indS = 0

    M35Coverage[indX, indY, indZ] += 1.0
    M35CoverageSX[indX, indS] += 1.0
  endfor


  ;Define the Trotignon boundaries
  ;Bow Shock
  ;Trotignon, et al. 2006 parameters
  xTrot = 0.6
  LTrot = 2.081
  psiTrot = 1.026
  phi = (-180. + findgen(361))*!dtor
  rho = LTrot/(1. + psiTrot*cos(phi))
  L0 = sqrt((LTrot + psiTrot*xTrot)^2.-xTrot*xTrot)

  xshockTrot = [xTrot + rho*cos(phi)]
  yshockTrot = L0*cos(phi)
  zshockTrot = L0*sin(phi)
  sshockTrot = rho*sin(phi)

  wherelt4=where(xshockTrot lt 4)

  ;IMB
  x0_p1  = 0.640
  psi_p1 = 0.770
  L_p1   = 1.080

  x0_p2  = 1.600
  psi_p2 = 1.009
  L_p2   = 0.528
  L0 = sqrt((L_p1+psi_p1*x0_p1)^2.-x0_p1*x0_p1)

  ;Shock conic
  phi = (-180. + findgen(180))*!dtor
  rho = L_p1/(1. + psi_p1*cos(phi))
  x1 = x0_p1 + rho*cos(phi)
  y1 = rho*sin(phi)

  rho = L_p2/(1. + psi_p2*cos(phi))
  x2 = x0_p2 + rho*cos(phi)
  y2 = rho*sin(phi)

  indx = where(x1 ge 0)
  jndx = where(x2 lt 0)
  xpileup = [x2[jndx], x1[indx]]
  ypileup = [y2[jndx], y1[indx]]

  phi = findgen(181)*!dtor

  rho = L_p1/(1. + psi_p1*cos(phi))
  x1 = x0_p1 + rho*cos(phi)
  y1 = rho*sin(phi)

  rho = L_p2/(1. + psi_p2*cos(phi))
  x2 = x0_p2 + rho*cos(phi)
  y2 = rho*sin(phi)

  indx = where(x1 ge 0)
  jndx = where(x2 lt 0)
  phi = (-180. + findgen(361))*!dtor ;reset phi for the y and z components
  xIMBTrot = [xpileup, x1[indx], x2[jndx]]
  sIMBTrot = [ypileup, y1[indx], y2[jndx]]
  yIMBTrot = L0*cos(phi)
  zIMBTrot = L0*sin(phi)

  ;Begin making plots
  ;load a colortable for the image and place white in the first bin, so that the background is white
  tbl = colortable(1, /reverse)
  ;tbl[0,*] = [255,255,255]

  ;Dictate Mars Parameters
  phi = findgen(361)*!dtor
  xm = cos(phi)
  ym = sin(phi)

  ;Only consider subset of data
  xrangeBnds35  = [-15.0, 5.0]
  srangeBnds35  = [-15.0, 5.0] ;10
  yrangeBnds35  = [-15.0, 5.0]
  zrangeBnds35  = [-15.0, 5.0]

  M35CoverageSmall = M35Coverage[where(xrangeArray35 eq xrangeBnds35[0]):where(xrangeArray35 eq xrangeBnds35[1]), $
    where(yrangeArray35 eq yrangeBnds35[0]):where(yrangeArray35 eq yrangeBnds35[1]), $
    where(zrangeArray35 eq zrangeBnds35[0]):where(zrangeArray35 eq zrangeBnds35[1])]
  M35CoverageSmallXS = M35CoverageSX[where(xrangeArray35 eq xrangeBnds35[0]):where(xrangeArray35 eq xrangeBnds35[1]), $
    where(srangeArray35 eq srangeBnds35[0]):where(srangeArray35 eq srangeBnds35[1])]


  xrangeArray35 = xrangeArray35[where(xrangeArray35 eq xrangeBnds35[0]):where(xrangeArray35 eq xrangeBnds35[1])]
  yrangeArray35 = yrangeArray35[where(yrangeArray35 eq yrangeBnds35[0]):where(yrangeArray35 eq yrangeBnds35[1])]
  zrangeArray35 = zrangeArray35[where(zrangeArray35 eq zrangeBnds35[0]):where(zrangeArray35 eq zrangeBnds35[1])]
  srangeArray35 = srangeArray35[where(srangeArray35 eq srangeBnds35[0]):where(srangeArray35 eq srangeBnds35[1])]


  ;*******************************************************************************************************
  ;MVN 35 - Y-Z projection
  ;*******************************************************************************************************
  M35PlotData = total(M35CoverageSmall,1, /NAN)

  imgMVN35YZ = image(M35PlotData/total(M35PlotData), yrangeArray35, zrangeArray35,$
    axis_style=2, min_value=0.0, max_value=max(M35PlotData/total(M35PlotData))*.10, $
    font_size=12, /aspect_ratio, $
    rgb_table=tbl,xtitle="$y_{MSO}\ [R_M]$",$
    xthick=2, ythick=2,thick=5,position=[0.10,0.2,0.84,0.90]) ;  position=[0.52,0.2,0.84,0.95],/current

  t = text(0.43, 0.93, 'MVN 35', font_style=1) ; 0.43,0.88
  t = text(0.12, 0.5, "$z_{MSO}\ [R_M]$", orientation=90, font_size=12) ; 0.5, 0.52
  polyMars = polygon(xm, ym, /data, fill_color='Maroon', fill_transparency=25, target=imgM35YZ)
  pTModel = plot(yshockTrot, zshockTrot, linestyle='--', color='dark goldenrod', /overplot, thick=2)
  pTIMBModel = plot(yIMBTrot, zIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)


  pMars = plot(xm,ym, color='red', /overplot)


  c = colorbar(target=imgMVN35YZ, orientation=1, position = [0.87, 0.12, 0.91, 0.92], textpos=1, $
    taper=3, tickname = ['','','','','',''], tickvalues = [0.0, $
    max(M35PlotData/total(M35PlotData))*.02, $
    max(M35PlotData/total(M35PlotData))*.04, $
    max(M35PlotData/total(M35PlotData))*.06, $
    max(M35PlotData/total(M35PlotData))*.08, $
    max(M35PlotData/total(M35PlotData))*.10], $
    title='Relative Orbital Density', font_size=12, /border_on, text_orientation=45)


  M35PlotData = total(M35CoverageSmall,1, /NAN)

  imgMVN35YZ2 = image(M35PlotData/total(M35PlotData), yrangeArray35, zrangeArray35,$
    axis_style=2, min_value=0.0, max_value=max(M35PlotData/total(M35PlotData))*.10, $
    font_size=12, /aspect_ratio, $
    rgb_table=tbl,xtitle="$y_{MSO}\ [R_M]$",$
    xthick=2, ythick=2,thick=5,position=[0.10,0.2,0.84,0.90]) ;  position=[0.52,0.2,0.84,0.95],/current

  t = text(0.43, 0.93, 'MVN 35', font_style=1) ; 0.43,0.88
  t = text(0.12, 0.5, "$z_{MSO}\ [R_M]$", orientation=90, font_size=12) ; 0.5, 0.52
  polyMars = polygon(xm, ym, /data, fill_color='Maroon', fill_transparency=25, target=imgM35YZ2)
  pTModel = plot(yshockTrot, zshockTrot, linestyle='--', color='dark goldenrod', /overplot, thick=2)
  pTIMBModel = plot(yIMBTrot, zIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
  ;OxyWaveLocation = scatterplot(oxy_ywave,oxy_zwave, symbol='S',sym_color='red',overplot=1, name='Oxygen Cyclotron Wave')
  ;ProWaveLocation = scatterplot(pro_ywave,pro_zwave, symbol='S',sym_color='cyan',overplot=1,sym_thick=2,name='Proton Cyclotron Wave')
  ;UnkWaveLocation = scatterplot(unk_ywave,unk_zwave, symbol='S',sym_color='green',overplot=1, name='Unknown Wave')
  ;leg = LEGEND(TARGET=[ProWaveLocation], position=[9.7,8.5],font_size=10,$
   ; /DATA, /AUTO_TEXT_COLOR)


  pMars = plot(xm,ym, color='red', /overplot)


  c = colorbar(target=imgMVN35YZ2, orientation=1, position = [0.87, 0.12, 0.91, 0.92], textpos=1, $
    taper=3, tickname = ['','','','','',''], tickvalues = [0.0, $
    max(M35PlotData/total(M35PlotData))*.02, $
    max(M35PlotData/total(M35PlotData))*.04, $
    max(M35PlotData/total(M35PlotData))*.06, $
    max(M35PlotData/total(M35PlotData))*.08, $
    max(M35PlotData/total(M35PlotData))*.10], $
    title='Relative Orbital Density', font_size=12, /border_on, text_orientation=45)


  M35PlotData = total(M35CoverageSmall,1, /NAN)

  imgMVN35YZ3 = image(M35PlotData/total(M35PlotData), yrangeArray35, zrangeArray35,$
    axis_style=2, min_value=0.0, max_value=max(M35PlotData/total(M35PlotData))*.10, $
    font_size=12, /aspect_ratio, $
    rgb_table=tbl,xtitle="$y_{MSO}\ [R_M]$",$
    xthick=2, ythick=2,thick=5,position=[0.10,0.2,0.84,0.90]) ;  position=[0.52,0.2,0.84,0.95],/current

  t = text(0.43, 0.93, 'MVN 35', font_style=1) ; 0.43,0.88
  t = text(0.12, 0.5, "$z_{MSO}\ [R_M]$", orientation=90, font_size=12) ; 0.5, 0.52
  polyMars = polygon(xm, ym, /data, fill_color='Maroon', fill_transparency=25, target=imgM35YZ3)
  pTModel = plot(yshockTrot, zshockTrot, linestyle='--', color='dark goldenrod', /overplot, thick=2)
  pTIMBModel = plot(yIMBTrot, zIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
  ;OxyWaveLocation = scatterplot(oxy_ywave,oxy_zwave, symbol='S',sym_color='red',overplot=1, name='Oxygen Cyclotron Wave')
  ;ProWaveLocation = scatterplot(pro_ywave,pro_zwave, symbol='S',sym_color='blue',overplot=1, name='Proton Cyclotron Wave')
  ;UnkWaveLocation = scatterplot(unk_ywave,unk_zwave, symbol='S',sym_color='green',overplot=1, sym_thick=2,name='Unknown Wave')
  ;leg = LEGEND(TARGET=[UnkWaveLocation], position=[9.7,8.5],font_size=10,$
   ; /DATA, /AUTO_TEXT_COLOR)


  pMars = plot(xm,ym, color='red', /overplot)


  c = colorbar(target=imgMVN35YZ3, orientation=1, position = [0.87, 0.12, 0.91, 0.92], textpos=1, $
    taper=3, tickname = ['','','','','',''], tickvalues = [0.0, $
    max(M35PlotData/total(M35PlotData))*.02, $
    max(M35PlotData/total(M35PlotData))*.04, $
    max(M35PlotData/total(M35PlotData))*.06, $
    max(M35PlotData/total(M35PlotData))*.08, $
    max(M35PlotData/total(M35PlotData))*.10], $
    title='Relative Orbital Density', font_size=12, /border_on, text_orientation=45)


  M35PlotData = total(M35CoverageSmall,1, /NAN)

  imgMVN35YZ4 = image(M35PlotData/total(M35PlotData), yrangeArray35, zrangeArray35,$
    axis_style=2, min_value=0.0, max_value=max(M35PlotData/total(M35PlotData))*.10, $
    font_size=12, /aspect_ratio, $
    rgb_table=tbl,xtitle="$y_{MSO}\ [R_M]$",$
    xthick=2, ythick=2,thick=5,position=[0.10,0.2,0.84,0.90]) ;  position=[0.52,0.2,0.84,0.95],/current

  t = text(0.43, 0.93, 'MVN 35', font_style=1) ; 0.43,0.88
  t = text(0.12, 0.5, "$z_{MSO}\ [R_M]$", orientation=90, font_size=12) ; 0.5, 0.52
  polyMars = polygon(xm, ym, /data, fill_color='Maroon', fill_transparency=25, target=imgM35YZ2)
  pTModel = plot(yshockTrot, zshockTrot, linestyle='--', color='dark goldenrod', /overplot, thick=2)
  pTIMBModel = plot(yIMBTrot, zIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
  ;OxyWaveLocation = scatterplot(oxy_ywave,oxy_zwave, symbol='S',sym_color='red',overplot=1, name='Oxygen Cyclotron Wave')
  ;HeWaveLocation = scatterplot(he_ywave,he_zwave, symbol='S',sym_color='yellow',overplot=1,sym_thick=2,name='Helium Cyclotron Wave')
  ;UnkWaveLocation = scatterplot(unk_ywave,unk_zwave, symbol='S',sym_color='green',overplot=1, name='Unknown Wave')
  ;leg = LEGEND(TARGET=[HeWaveLocation], position=[9.7,8.5],font_size=10,$
  ;  /DATA, /AUTO_TEXT_COLOR)

  pMars = plot(xm,ym, color='red', /overplot)


  c = colorbar(target=imgMVN35YZ4, orientation=1, position = [0.87, 0.12, 0.91, 0.92], textpos=1, $
    taper=3, tickname = ['','','','','',''], tickvalues = [0.0, $
    max(M35PlotData/total(M35PlotData))*.02, $
    max(M35PlotData/total(M35PlotData))*.04, $
    max(M35PlotData/total(M35PlotData))*.06, $
    max(M35PlotData/total(M35PlotData))*.08, $
    max(M35PlotData/total(M35PlotData))*.10], $
    title='Relative Orbital Density', font_size=12, /border_on, text_orientation=45)

end