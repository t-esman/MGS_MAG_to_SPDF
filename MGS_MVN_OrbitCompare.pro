

pro MGS_MVN_OrbitCompare

	;Begin by loading the MGS file
	MGSOrbitFile = 'MGSOrbitPositions.dat'
	restore, 'MGSOrbitFile.template'
	MGSdata = read_ascii(MGSOrbitFile, template=template)

	;set Mars type variables
	R_m	= 3389.9D
	R_e = 6371D
	;Bin the MGS data
	nBins = 1000
	nBins35=400
	xrangeArray = findgen(nBins35+1, start=-200.0)/10.0
	yrangeArray = findgen(nBins35+1, start=-200.0)/10.0 ; 500/100
	zrangeArray = findgen(nBins35+1, start=-200.0)/10.0
	srangeArray = findgen(nBins35+1, start=-200.0)/10.0
	
	xrangeArray35 = findgen(nBins35+1, start=-200.0)/10.0
	yrangeArray35 = findgen(nBins35+1, start=-200.0)/10.0
	zrangeArray35 = findgen(nBins35+1, start=-200.0)/10.0
	srangeArray35 = findgen(nBins35+1, start=-200.0)/10.0
	MGSCoverage = make_array(n_elements(xrangeArray35), $
							 n_elements(yrangeArray35), $
							 n_elements(zrangeArray35), $
							 value = 0.0)
	MGSCoverageSX = make_array(n_elements(xrangeArray35), $
							 n_elements(srangeArray35), $
							 value = 0.0)
	
	for i=0, n_elements(MGSdata.year)-1 do begin
		indX = where(xrangeArray35 gt MGSdata.posX[i]/R_m)
		if indX[0] ne 0 then indX = indX[0]-1
		if indX[0] eq 0 then indX = 0

		indY = where(YrangeArray35 gt MGSdata.posY[i]/R_m)
		if indY[0] ne 0 then indY = indY[0]-1
		if indY[0] eq 0 then indY = 0
		
		indZ = where(zrangeArray35 gt MGSdata.posZ[i]/R_m)
		if indZ[0] ne 0 then indZ = indZ[0]-1
		if indZ[0] eq 0 then indZ = 0
		
		curS = signum(MGSdata.posZ[i])*sqrt((MGSdata.posY[i]/R_m)^2.0+(MGSdata.posZ[i]/R_m)^2.0)
		indS = where(srangeArray35 gt curS)
		if indS[0] ne 0 then indS = indS[0]-1
		if indS[0] eq 0 then indS = 0
		
		MGSCoverage[indX, indY, indZ] += 1.0
		MGSCoverageSX[indX, indS] += 1.0
	endfor
;mk = mvn_spice_kernels(/all, /load)
	;Now load in the MAVEN data and bin it
	; seems like this doesn't like my startup.pro
	;maven_orbit_tplot, /load, /current, result=result
restore,'ResultYearly/result2014.sav'
;	mvnTimeSpan = [time_double('2014-10-01/00:00:00'), time_double('2014-12-30/00:00:00')]
;	;mvnTimeSpan = [time_double('2016-12-26/00:00:00'), time_double('2017-02-30/00:00:00')]
;	MVNCoverage = make_array(n_elements(xrangeArray), $
;							 n_elements(yrangeArray), $
;							 n_elements(zrangeArray), $
;							 value = 0.0)
;	MVNCoverageSX = make_array(n_elements(xrangeArray), $
;							 n_elements(srangeArray), $
;							 value = 0.0)
;	
;	indAnalyzed = where(result.t ge mvnTimeSpan[0] and result.t lt mvnTimeSpan[1])
;	for i=0, n_elements(indAnalyzed)-1 do begin
;		indX = where(xrangeArray gt result.x[indAnalyzed[i]])
;		if indX[0] ne 0 then indX = indX[0]-1
;		if indX[0] eq 0 then indX = 0
;
;		indY = where(YrangeArray gt result.y[indAnalyzed[i]])
;		if indY[0] ne 0 then indY = indY[0]-1
;		if indY[0] eq 0 then indY = 0
;		
;		indZ = where(zrangeArray gt result.z[indAnalyzed[i]])
;		if indZ[0] ne 0 then indZ = indZ[0]-1
;		if indZ[0] eq 0 then indZ = 0
;		
;		curS = signum(result.z[indAnalyzed[i]])*sqrt((result.y[indAnalyzed[i]])^2.0+(result.z[indAnalyzed[i]])^2.0)
;		;curS = sqrt((result.y[indAnalyzed[i]])^2.0+(result.z[indAnalyzed[i]])^2.0)
;		indS = where(srangeArray gt curS)
;		if indS[0] ne 0 then indS = indS[0]-1
;		if indS[0] eq 0 then indS = 0
;		
;		MVNCoverage[indX, indY, indZ] += 1.0
;		MVNCoverageSX[indX, indS] += 1.0
;	endfor
;	
;	;load in the Mars Express data and bin it
;	MEXCoverage = make_array(n_elements(xrangeArray), $
;							 n_elements(yrangeArray), $
;							 n_elements(zrangeArray), $
;							 value = 0.0)
;	MEXCoverageSX = make_array(n_elements(xrangeArray), $
;							 n_elements(srangeArray), $
;							 value = 0.0)
;	
;	filename='MEX_Ephemeris.dat'
;	restore, 'MEX_location.template'
;	MEXdata = read_ascii(filename, template=template)
;	
;	for i=0, n_elements(MEXdata.time)-1 do begin
;		indX = where(xrangeArray gt MEXdata.pos_X[i])
;		if indX[0] ne 0 then indX = indX[0]-1
;		if indX[0] eq 0 then indX = 0
;
;		indY = where(YrangeArray gt MEXdata.pos_Y[i])
;		if indY[0] ne 0 then indY = indY[0]-1
;		if indY[0] eq 0 then indY = 0
;		
;		indZ = where(zrangeArray gt MEXdata.pos_Z[i])
;		if indZ[0] ne 0 then indZ = indZ[0]-1
;		if indZ[0] eq 0 then indZ = 0
;		
;		curS = signum(MEXdata.pos_Z[i])*sqrt((MEXdata.pos_Y[i])^2.0+(MEXdata.pos_Z[i])^2.0)
;		indS = where(srangeArray gt curS)
;		if indS[0] ne 0 then indS = indS[0]-1
;		if indS[0] eq 0 then indS = 0
;		
;		MEXCoverage[indX, indY, indZ] += 1.0
;		MEXCoverageSX[indX, indS] += 1.0
;	endfor
;	
	
	
;load in MVN distant magnetosphere data and bin it
;maven_orbit_tplot, /load, /current, result=result
mvnTimeSpan = [time_double('2014-09-22/00:00:00'), time_double('2014-10-01/00:00:00')]
  M35Coverage = make_array(n_elements(xrangeArray35), $
               n_elements(yrangeArray35), $
               n_elements(zrangeArray35), $
               value = 0.0)
  M35CoverageSX = make_array(n_elements(xrangeArray35), $
               n_elements(srangeArray35), $
               value = 0.0)
  
  indAnalyzed = where(result.t ge mvnTimeSpan[0] and result.t lt mvnTimeSpan[1])
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
  
;
;;load in Phobos 2 data and bin it
;  PHOOrbitFile = 'Phobos88_pos_19890129-19890331-MSO.txt'
;  PHOdata=read_ascii(PHOOrbitFile,DATA_START=1)
;Pho_x=PHOdata.field1(5,*)
;Pho_y=PHOdata.field1(6,*)
;Pho_z=PHOdata.field1(7,*)
;  PHOCoverage = make_array(n_elements(xrangeArray35), $
;    n_elements(yrangeArray35), $
;    n_elements(zrangeArray35), $
;    value = 0.0)
;  PHOCoverageSX = make_array(n_elements(xrangeArray35), $
;    n_elements(srangeArray35), $
;    value = 0.0)
;    
;  for i=0, n_elements(PHOdata.field1(0,*))-1 do begin
;    indX = where(xrangeArray35 gt Pho_x[i]/R_m)
;    if indX[0] ne 0 then indX = indX[0]-1
;    if indX[0] eq 0 then indX = 0
;
;    indY = where(YrangeArray35 gt Pho_y[i]/R_m)
;    if indY[0] ne 0 then indY = indY[0]-1
;    if indY[0] eq 0 then indY = 0
;
;    indZ = where(zrangeArray35 gt Pho_z[i]/R_m)
;    if indZ[0] ne 0 then indZ = indZ[0]-1
;    if indZ[0] eq 0 then indZ = 0
;
;    curS = signum(PHO_z[i])*sqrt((Pho_y[i]/R_m)^2.0+(Pho_z[i]/R_m)^2.0)
;    
;       ; curS = signum(MEXdata.pos_Z[i])*sqrt((MEXdata.pos_Y[i])^2.0+(MEXdata.pos_Z[i])^2.0)
;       ;signum returns the sign of a number, so it doesn't need to be divided by R_m
;    indS = where(srangeArray35 gt curS)
;    if indS[0] ne 0 then indS = indS[0]-1
;    if indS[0] eq 0 then indS = 0
;
;    PHOCoverage[indX, indY, indZ] += 1.0
;    PHOCoverageSX[indX, indS] += 1.0
;  endfor
;

	
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
    xrangeBnds	= [-20.0, 20.0]
    srangeBnds  = [-20.0, 20.0]
    yrangeBnds  = [-20.0, 20.0]
    zrangeBnds  = [-20.0, 20.0]
    
    
    xrangeBnds35  = [-20.0, 20.0]
    srangeBnds35  = [-20.0, 20.0]
    yrangeBnds35  = [-20.0, 20.0]
    zrangeBnds35  = [-20.0, 20.0]
    
    MGSCoverageSmall = MGSCoverage[where(xrangeArray35 eq xrangeBnds35[0]):where(xrangeArray35 eq xrangeBnds35[1]), $
    							   where(yrangeArray35 eq yrangeBnds35[0]):where(yrangeArray35 eq yrangeBnds35[1]), $
    							   where(zrangeArray35 eq zrangeBnds35[0]):where(zrangeArray35 eq zrangeBnds35[1])]
    MGSCoverageSmallXS = MGSCoverageSX[where(xrangeArray35 eq xrangeBnds35[0]):where(xrangeArray35 eq xrangeBnds35[1]), $
    							     where(srangeArray35 eq srangeBnds35[0]):where(srangeArray35 eq srangeBnds35[1])]
   ; MVNCoverageSmall = MVNCoverage[where(xrangeArray eq xrangeBnds[0]):where(xrangeArray eq xrangeBnds[1]), $
    ;							   where(yrangeArray eq yrangeBnds[0]):where(yrangeArray eq yrangeBnds[1]), $
    	;						   where(zrangeArray eq zrangeBnds[0]):where(zrangeArray eq zrangeBnds[1])]
   ; MVNCoverageSmallXS = MVNCoverageSX[where(xrangeArray eq xrangeBnds[0]):where(xrangeArray eq xrangeBnds[1]), $
    ;							     where(srangeArray eq srangeBnds[0]):where(srangeArray eq srangeBnds[1])]	
    	
   M35CoverageSmall = M35Coverage[where(xrangeArray35 eq xrangeBnds35[0]):where(xrangeArray35 eq xrangeBnds35[1]), $
    							   where(yrangeArray35 eq yrangeBnds35[0]):where(yrangeArray35 eq yrangeBnds35[1]), $
    							   where(zrangeArray35 eq zrangeBnds35[0]):where(zrangeArray35 eq zrangeBnds35[1])]
   M35CoverageSmallXS = M35CoverageSX[where(xrangeArray35 eq xrangeBnds35[0]):where(xrangeArray35 eq xrangeBnds35[1]), $
    							   where(srangeArray35 eq srangeBnds35[0]):where(srangeArray35 eq srangeBnds35[1])]

    							     
   ; MEXCoverageSmall = MEXCoverage[where(xrangeArray eq xrangeBnds[0]):where(xrangeArray eq xrangeBnds[1]), $
    ;							   where(yrangeArray eq yrangeBnds[0]):where(yrangeArray eq yrangeBnds[1]), $
    	;						   where(zrangeArray eq zrangeBnds[0]):where(zrangeArray eq zrangeBnds[1])]
   ; MEXCoverageSmallXS = MEXCoverageSX[where(xrangeArray eq xrangeBnds[0]):where(xrangeArray eq xrangeBnds[1]), $
    ;							     where(srangeArray eq srangeBnds[0]):where(srangeArray eq srangeBnds[1])]		
    							     
    							     
;    PHOCoverageSmall = PHOCoverage[where(xrangeArray35 eq xrangeBnds35[0]):where(xrangeArray35 eq xrangeBnds35[1]), $
;    							     where(yrangeArray35 eq yrangeBnds35[0]):where(yrangeArray35 eq yrangeBnds35[1]), $
;    							     where(zrangeArray35 eq zrangeBnds35[0]):where(zrangeArray35 eq zrangeBnds35[1])]
;    PHOCoverageSmallXS = PHOCoverageSX[where(xrangeArray35 eq xrangeBnds35[0]):where(xrangeArray35 eq xrangeBnds35[1]), $
;    							     where(srangeArray35 eq srangeBnds35[0]):where(srangeArray35 eq srangeBnds35[1])]					     

    xrangeArray = xrangeArray[where(xrangeArray eq xrangeBnds[0]):where(xrangeArray eq xrangeBnds[1])]
    yrangeArray = yrangeArray[where(yrangeArray eq yrangeBnds[0]):where(yrangeArray eq yrangeBnds[1])]
    zrangeArray = zrangeArray[where(zrangeArray eq zrangeBnds[0]):where(zrangeArray eq zrangeBnds[1])]
    srangeArray = srangeArray[where(srangeArray eq srangeBnds[0]):where(srangeArray eq srangeBnds[1])]
    
    xrangeArray35 = xrangeArray35[where(xrangeArray35 eq xrangeBnds35[0]):where(xrangeArray35 eq xrangeBnds35[1])]
    yrangeArray35 = yrangeArray35[where(yrangeArray35 eq yrangeBnds35[0]):where(yrangeArray35 eq yrangeBnds35[1])]
    zrangeArray35 = zrangeArray35[where(zrangeArray35 eq zrangeBnds35[0]):where(zrangeArray35 eq zrangeBnds35[1])]
    srangeArray35 = srangeArray35[where(srangeArray35 eq srangeBnds35[0]):where(srangeArray35 eq srangeBnds35[1])]

    
   ;*******************************************************************************************************
   ;MGS - X-S projection
   ;*******************************************************************************************************
   MGSPlotData = MGSCoverageSmallXS
   yTitleText = "$s_{MSO}\ [R_M]$"
   imgMGSXS = image(MGSPlotData/total(MGSPlotData), xrangeArray35, srangeArray35,$
				 axis_style=2, min_value=0.0, max_value=max(MGSPlotData/total(MGSPlotData))*.10, $
				 ytitle=yTitleText, xtitle="$x_{MSO}\ [R_M]$", xminor=0, yminor=0,$
 	 	 		; title ="MGS", $
 				 font_size=12, /aspect_ratio, $
				 rgb_table=tbl, position=[0.12,0.07,0.5,0.27], $
				 xrange=xrangeBnds, xstyle=1, xthick=2, $
				 yrange=yrangeBnds, ystyle=1, ythick=2)
				 
  t = text(0.45, 0.17, 'MGS', font_style=1)
   polyMarsNight = polygon(xm[where(xm lt 0.0)], ym[where(xm lt 0.0)], /data, fill_color='black', target=imgMGSXS)		
   polyMars = polygon(xm[where(xm ge 0.0)], ym[where(xm ge 0.0)], /data, fill_color='Maroon', fill_transparency=25, target=imgMGSXS)	
   pTModel = plot(xshockTrot(wherelt4), sshockTrot(wherelt4), linestyle='--', color='dark goldenrod', /overplot, thick=2)
   pTIMBModel = plot(xIMBTrot, sIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
   pMars = plot(xm,ym, color='red', /overplot)
   
   ;*******************************************************************************************************
   ;MGS - Y-Z projection
   ;*******************************************************************************************************
	MGSPlotData = total(MGSCoverageSmall,1, /NAN)

	imgMGSYZ = image(MGSPlotData/total(MGSPlotData), yrangeArray35, zrangeArray35,$
				 axis_style=2, min_value=0.0, max_value=max(MGSPlotData/total(MGSPlotData))*.10, $
				 ytitle="$z_{MSO}\ [R_M]$", xtitle="$y_{MSO}\ [R_M]$",  xminor=0, yminor=0,$
 			     font_size=12, /aspect_ratio, xtickinterval=10,$
				 rgb_table=tbl, position=[0.5,0.07,0.87,0.27], /current, $
				 xthick=2, yshowtext=0, ythick=2)
	
	;t = text(0.88, 0.16, 'MGS', font_style=1)
	t = text(0.58, 0.11, "$z_{MSO}\ [R_M]$", orientation=90, font_size=12)
	polyMars = polygon(xm, ym, /data, fill_color='Maroon', fill_transparency=25, target=imgMGSYZ)
	pTModel = plot(yshockTrot, zshockTrot, linestyle='--', color='dark goldenrod', /overplot, thick=2)
	pTIMBModel = plot(yIMBTrot, zIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
	pMars = plot(xm,ym, color='red', /overplot)

   ;*******************************************************************************************************
   ;MVN - X-S projection
   ;*******************************************************************************************************
;	MVNPlotData = MVNCoverageSmallXS
;	imgMVNXS = image(MVNPlotData/total(MVNPlotData), xrangeArray, srangeArray,$
;				 axis_style=2, min_value=0.0, max_value=max(MVNPlotData/total(MVNPlotData))*.10, $
; 				 font_size=12, ytitle=yTitleText, /aspect_ratio, $
;				 rgb_table=tbl, position=[0.12,0.55,0.5,0.75], $
;				 xrange=xrangeBnds, xstyle=1, xthick=2, xshowtext=0,  xminor=0, yminor=0,$
;				 yrange=yrangeBnds, ystyle=1, ythick=2, /current)
;				 		 
;   t = text(0.45, 0.65, 'MAVEN', font_style=1)				 
;   polyMarsNight = polygon(xm[where(xm lt 0.0)], ym[where(xm lt 0.0)], /data, fill_color='black', target=imgMVNXS)		
;   polyMars = polygon(xm[where(xm ge 0.0)], ym[where(xm ge 0.0)], /data, fill_color='Maroon', fill_transparency=25, target=imgMVNXS)	
;   pTModel = plot(xshockTrot(wherelt4), sshockTrot(wherelt4), linestyle='--', color='dark goldenrod', /overplot, thick=2)
;   pTIMBModel = plot(xIMBTrot, sIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
;   pMars = plot(xm,ym, color='red', /overplot)
   
   ;*******************************************************************************************************
   ;MVN - Y-Z projection
   ;*******************************************************************************************************
;   MVNPlotData = total(MVNCoverageSmall,1, /NAN)
;
;	imgMVNYZ = image(MVNPlotData/total(MVNPlotData), yrangeArray, zrangeArray,$
;				 axis_style=2, min_value=0.0, max_value=max(MVNPlotData/total(MVNPlotData))*.10, $
; 				 font_size=12, /aspect_ratio, $
;				 rgb_table=tbl, position=[0.5,0.55,0.87,0.75], /current,  xminor=0,yminor=0, $
;				 xshowtext=0, xthick=2, yshowtext=0, ythick=2)
;				 
;	;t = text(0.88, 0.35, 'MAVEN', font_style=1)
;	t = text(0.58, 0.35, "$z_{MSO}\ [R_M]$", orientation=90, font_size=12)	 
;	polyMars = polygon(xm, ym, /data, fill_color='Maroon', fill_transparency=25, target=imgMVNYZ)
;	pTModel = plot(yshockTrot, zshockTrot, linestyle='--', color='dark goldenrod', /overplot, thick=2)
;	pTIMBModel = plot(yIMBTrot, zIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
;	pMars = plot(xm,ym, color='red', /overplot)
	

	;*******************************************************************************************************
	;MEX - X-S projection
	;*******************************************************************************************************
;	MEXPlotData = MEXCoverageSmallXS
;	yTitleText = "$s_{MSO}\ [R_M]$"
;	imgMEXXS = image(MEXPlotData/total(MEXPlotData), xrangeArray, srangeArray,$
;	  axis_style=2, ytitle=yTitleText,min_value=0.0, max_value=max(MEXPlotData/total(MEXPlotData))*.10, $
;	  font_size=12, /aspect_ratio, $
;	  rgb_table=tbl, position=[0.12,0.31,0.49,0.51], /current, xminor=0, yminor=0,$
;	  xrange=xrangeBnds, xstyle=1, xthick=2, $
;	  yrange=yrangeBnds, ystyle=1, ythick=2, xshowtext=0)
;
;t = text(0.45, 0.41, 'MEX', font_style=1)
;	polyMarsNight = polygon(xm[where(xm lt 0.0)], ym[where(xm lt 0.0)], /data, fill_color='black', target=imgMEXXS)
;	polyMars = polygon(xm[where(xm ge 0.0)], ym[where(xm ge 0.0)], /data, fill_color='Maroon', fill_transparency=25, target=imgMEXXS)
;	pTModel = plot(xshockTrot(wherelt4), sshockTrot(wherelt4), linestyle='--', color='dark goldenrod', /overplot, thick=2)
;	pTIMBModel = plot(xIMBTrot, sIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
;	pMars = plot(xm,ym, color='red', /overplot)

	;*******************************************************************************************************
	;MEX - Y-Z projection
	;*******************************************************************************************************
;	MEXPlotData = total(MEXCoverageSmall,1, /NAN)
;
;	imgMEXYZ = image(MEXPlotData/total(MEXPlotData), yrangeArray, zrangeArray,$
;	  axis_style=2, min_value=0.0, max_value=max(MEXPlotData/total(MEXPlotData))*.10, $
;	  ;ytitle="$z_{MSO}\ [R_M]$", xtitle="$y_{MSO}\ [R_M]$", $
;	 ; title='MEX',$
;	  font_size=12, /aspect_ratio, $
;	  rgb_table=tbl, position=[0.5,0.31,0.87,0.51], /current,  xminor=0, yminor=0,$
;	  xthick=2, xshowtext=0, $
;	  yshowtext=0, ythick=2)
;
;	;t = text(0.88, 0.55, 'MEX', font_style=1)
;	t = text(0.58, 0.59, "$z_{MSO}\ [R_M]$", orientation=90, font_size=12)
;	polyMars = polygon(xm, ym, /data, fill_color='Maroon', fill_transparency=25, target=imgMEXYZ)
;	pTModel = plot(yshockTrot, zshockTrot, linestyle='--', color='dark goldenrod', /overplot, thick=2)
;	pTIMBModel = plot(yIMBTrot, zIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
;	pMars = plot(xm,ym, color='red', /overplot)

	;*******************************************************************************************************
	;PHO - X-S projection
	;*******************************************************************************************************
;
;	PHOPlotData = PHOCoverageSmallXS ; all zero
;	imgPHOXS = image(PHOPlotData/total(PHOPlotData), xrangeArray35, srangeArray35,$
;	  axis_style=2, ytitle=yTitleText,min_value=0.0, max_value=max(PHOPlotData/total(PHOPlotData))*.10, $
;	  font_size=12, /aspect_ratio, thick=5,$
;	  rgb_table=tbl, position=[0.12,0.64,0.49,0.79], $
;	  xrange=xrangeBnds35, xstyle=1, xthick=2, xshowtext=0,  xminor=0, yminor=0,$
;	  yrange=yrangeBnds35, ystyle=1, ythick=2, /current)
;	;
;	t = text(0.43, 0.75, 'Phobos 2', font_style=1)
;	
;	polyMarsNight = polygon(xm[where(xm lt 0.0)], ym[where(xm lt 0.0)], /data, fill_color='black', target=imgPHOXS)
;	polyMars = polygon(xm[where(xm ge 0.0)], ym[where(xm ge 0.0)], /data, fill_color='Maroon', fill_transparency=25, target=imgPHOXS)
;	pTModel = plot(xshockTrot(wherelt4), sshockTrot(wherelt4), linestyle='--', color='dark goldenrod', /overplot, thick=2)
;	pTIMBModel = plot(xIMBTrot, sIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
;	pMars = plot(xm,ym, color='red', /overplot)
;	;
;	;;*******************************************************************************************************
;	;;PHO - Y-Z projection
;	;;*******************************************************************************************************
;	PHOPlotData = total(PHOCoverageSmall,1, /NAN)
;	;
;	;
;	imgPHOYZ = image(PHOPlotData/total(PHOPlotData), yrangeArray35, zrangeArray35,$
;	  axis_style=2, min_value=0.0, max_value=max(PHOPlotData/total(PHOPlotData))*.10, $
;	  ytitle="$z_{MSO}\ [R_M]$", $
;	  font_size=12, /aspect_ratio,  xminor=0, $
;	  rgb_table=tbl, position=[0.5,0.64,0.87,0.79],yminor=0, /current, $
;	  xshowtext=0, xthick=2, yshowtext=0, ythick=2)
;	;
;	;t = text(0.88, 0.75, 'Phobos 2', font_style=1)
;	t = text(0.6, 0.64, "$z_{MSO}\ [R_M]$", orientation=90, font_size=12)
;	polyMars = polygon(xm, ym, /data, fill_color='Maroon', fill_transparency=25, target=imgPHOYZ)
;	pTModel = plot(yshockTrot, zshockTrot, linestyle='--', color='dark goldenrod', /overplot, thick=2)
;	pTIMBModel = plot(yIMBTrot, zIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
;	pMars = plot(xm,ym, color='red', /overplot)

			;*******************************************************************************************************
			;MVN 35 - X-S projection
			;*******************************************************************************************************
			M35PlotData = M35CoverageSmallXS
			imgMVN35XS = image(M35PlotData/total(M35PlotData), xrangeArray35, srangeArray35,$
			  axis_style=2, min_value=0.0, max_value=max(M35PlotData/total(M35PlotData))*.10, $
			  font_size=12, /aspect_ratio,  xminor=0, $
			  rgb_table=tbl, position=[0.12,0.79,0.5,0.99], $
			  xrange=xrangeBnds35, ytitle=yTitleText, xstyle=1, xthick=2, xshowtext=0,yminor=0, $
			  yrange=yrangeBnds35, ystyle=1, ythick=2, thick=5,/current)
			
		;	t = text(0.45, 0.88, 'MVN 35', font_style=1)
			polyMarsNight = polygon(xm[where(xm lt 0.0)], ym[where(xm lt 0.0)], /data, fill_color='black', target=imgMVN35XS)
			polyMars = polygon(xm[where(xm ge 0.0)], ym[where(xm ge 0.0)], /data, fill_color='Maroon', fill_transparency=25, target=imgMVN35XS)
			pTModel = plot(xshockTrot(wherelt4), sshockTrot(wherelt4), linestyle='--', color='dark goldenrod', /overplot, thick=2)
			pTIMBModel = plot(xIMBTrot, sIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
			pMars = plot(xm,ym, color='red', /overplot)


			;*******************************************************************************************************
			;MVN 35 - Y-Z projection
			;*******************************************************************************************************
			M35PlotData = total(M35CoverageSmall,1, /NAN)


			imgMVN35YZ = image(M35PlotData/total(M35PlotData), yrangeArray35, zrangeArray35,$
			  axis_style=2, min_value=0.0, max_value=max(M35PlotData/total(M35PlotData))*.10, $
			  font_size=12, /aspect_ratio, $
			  rgb_table=tbl, position=[0.5,0.79,0.87,0.99], /current,  xminor=0,yminor=0, $
			  xshowtext=0, xthick=2, yshowtext=0, ythick=2,thick=5)
			
			t = text(0.45, 0.89, 'MAVEN', font_style=1)
			t = text(0.43, 0.86, 'First Orbits', font_style=1)
			t = text(0.58, 0.83, "$z_{MSO}\ [R_M]$", orientation=90, font_size=12)
			polyMars = polygon(xm, ym, /data, fill_color='Maroon', fill_transparency=25, target=imgMVN35YZ)
			pTModel = plot(yshockTrot, zshockTrot, linestyle='--', color='dark goldenrod', /overplot, thick=2)
			pTIMBModel = plot(yIMBTrot, zIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
			pMars = plot(xm,ym, color='red', /overplot)


			c = colorbar(target=imgMGSYZ, orientation=1, position = [0.85, 0.12, 0.89, 0.92], textpos=1, $
			  taper=3, tickname = ['','','','','',''], tickvalues = [0.0, $
			  max(MGSPlotData/total(MGSPlotData))*.02, $
			  max(MGSPlotData/total(MGSPlotData))*.04, $
			  max(MGSPlotData/total(MGSPlotData))*.06, $
			  max(MGSPlotData/total(MGSPlotData))*.08, $
			  max(MGSPlotData/total(MGSPlotData))*.10], $
			  title='Relative Orbital Density', font_size=12, /border_on, text_orientation=45)

end