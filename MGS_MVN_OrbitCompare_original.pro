

pro MGS_MVN_OrbitCompare

	;Begin by loading the MGS file
	MGSOrbitFile = 'MGSOrbitPositions.dat'
	restore, 'MGSOrbitFile.template'
	MGSdata = read_ascii(MGSOrbitFile, template=template)

	;set Mars type variables
	R_m	= 3389.9D
	
	;Bin the MGS data
	nBins = 1000
	xrangeArray = findgen(nBins+1, start=-500.0)/100.0
	yrangeArray = findgen(nBins+1, start=-500.0)/100.0
	zrangeArray = findgen(nBins+1, start=-500.0)/100.0
	srangeArray = findgen(nBins+1, start=-500.0)/100.0
	MGSCoverage = make_array(n_elements(xrangeArray), $
							 n_elements(yrangeArray), $
							 n_elements(zrangeArray), $
							 value = 0.0)
	MGSCoverageSX = make_array(n_elements(xrangeArray), $
							 n_elements(srangeArray), $
							 value = 0.0)
	
	for i=0, n_elements(MGSdata.year)-1 do begin
		indX = where(xrangeArray gt MGSdata.posX[i]/R_m)
		if indX[0] ne 0 then indX = indX[0]-1
		if indX[0] eq 0 then indX = 0

		indY = where(YrangeArray gt MGSdata.posY[i]/R_m)
		if indY[0] ne 0 then indY = indY[0]-1
		if indY[0] eq 0 then indY = 0
		
		indZ = where(zrangeArray gt MGSdata.posZ[i]/R_m)
		if indZ[0] ne 0 then indZ = indZ[0]-1
		if indZ[0] eq 0 then indZ = 0
		
		curS = signum(MGSdata.posZ[i])*sqrt((MGSdata.posY[i]/R_m)^2.0+(MGSdata.posZ[i]/R_m)^2.0)
		indS = where(srangeArray gt curS)
		if indS[0] ne 0 then indS = indS[0]-1
		if indS[0] eq 0 then indS = 0
		
		MGSCoverage[indX, indY, indZ] += 1.0
		MGSCoverageSX[indX, indS] += 1.0
	endfor
	
	;Now load in the MAVEN data and bin it
	maven_orbit_tplot, /load, /current, result=result
	mvnTimeSpan = [time_double('2014-11-15/00:00:00'), time_double('2017-04-30/00:00:00')]
	;mvnTimeSpan = [time_double('2016-12-26/00:00:00'), time_double('2017-02-30/00:00:00')]
	MVNCoverage = make_array(n_elements(xrangeArray), $
							 n_elements(yrangeArray), $
							 n_elements(zrangeArray), $
							 value = 0.0)
	MVNCoverageSX = make_array(n_elements(xrangeArray), $
							 n_elements(srangeArray), $
							 value = 0.0)
	
	indAnalyzed = where(result.t ge mvnTimeSpan[0] and result.t lt mvnTimeSpan[1])
	for i=0, n_elements(indAnalyzed)-1 do begin
		indX = where(xrangeArray gt result.x[indAnalyzed[i]])
		if indX[0] ne 0 then indX = indX[0]-1
		if indX[0] eq 0 then indX = 0

		indY = where(YrangeArray gt result.y[indAnalyzed[i]])
		if indY[0] ne 0 then indY = indY[0]-1
		if indY[0] eq 0 then indY = 0
		
		indZ = where(zrangeArray gt result.z[indAnalyzed[i]])
		if indZ[0] ne 0 then indZ = indZ[0]-1
		if indZ[0] eq 0 then indZ = 0
		
		curS = signum(result.z[indAnalyzed[i]])*sqrt((result.y[indAnalyzed[i]])^2.0+(result.z[indAnalyzed[i]])^2.0)
		;curS = sqrt((result.y[indAnalyzed[i]])^2.0+(result.z[indAnalyzed[i]])^2.0)
		indS = where(srangeArray gt curS)
		if indS[0] ne 0 then indS = indS[0]-1
		if indS[0] eq 0 then indS = 0
		
		MVNCoverage[indX, indY, indZ] += 1.0
		MVNCoverageSX[indX, indS] += 1.0
	endfor
	
	;load in the Mars Express data and bin it
	;MEXCoverage = make_array(n_elements(xrangeArray), $
	;						 n_elements(yrangeArray), $
	;						 n_elements(zrangeArray), $
	;						 value = 0.0)
	;MEXCoverageSX = make_array(n_elements(xrangeArray), $
	;						 n_elements(srangeArray), $
	;						 value = 0.0)
	
	;filename='MEX_Ephemeris.dat'
	;restore, 'MEX_location.template'
	;MEXdata = read_ascii(filename, template=template)
	
	;for i=0, n_elements(MEXdata.time)-1 do begin
	;	indX = where(xrangeArray gt MEXdata.pos_X[i])
	;	if indX[0] ne 0 then indX = indX[0]-1
	;	if indX[0] eq 0 then indX = 0
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
    xrangeBnds	= [-4.0, 4.0]
    srangeBnds  = [-4.0, 4.0]
    yrangeBnds  = [-4.0, 4.0]
    zrangeBnds  = [-4.0, 4.0]
    
    MGSCoverageSmall = MGSCoverage[where(xrangeArray eq xrangeBnds[0]):where(xrangeArray eq xrangeBnds[1]), $
    							   where(yrangeArray eq yrangeBnds[0]):where(yrangeArray eq yrangeBnds[1]), $
    							   where(zrangeArray eq zrangeBnds[0]):where(zrangeArray eq zrangeBnds[1])]
    MGSCoverageSmallXS = MGSCoverageSX[where(xrangeArray eq xrangeBnds[0]):where(xrangeArray eq xrangeBnds[1]), $
    							     where(srangeArray eq srangeBnds[0]):where(srangeArray eq srangeBnds[1])]
    MVNCoverageSmall = MVNCoverage[where(xrangeArray eq xrangeBnds[0]):where(xrangeArray eq xrangeBnds[1]), $
    							   where(yrangeArray eq yrangeBnds[0]):where(yrangeArray eq yrangeBnds[1]), $
    							   where(zrangeArray eq zrangeBnds[0]):where(zrangeArray eq zrangeBnds[1])]
    MVNCoverageSmallXS = MVNCoverageSX[where(xrangeArray eq xrangeBnds[0]):where(xrangeArray eq xrangeBnds[1]), $
    							     where(srangeArray eq srangeBnds[0]):where(srangeArray eq srangeBnds[1])]	
    							     
   ; MEXCoverageSmall = MEXCoverage[where(xrangeArray eq xrangeBnds[0]):where(xrangeArray eq xrangeBnds[1]), $
    ;							   where(yrangeArray eq yrangeBnds[0]):where(yrangeArray eq yrangeBnds[1]), $
    ;							   where(zrangeArray eq zrangeBnds[0]):where(zrangeArray eq zrangeBnds[1])]
    ;MEXCoverageSmallXS = MEXCoverageSX[where(xrangeArray eq xrangeBnds[0]):where(xrangeArray eq xrangeBnds[1]), $
    ;							     where(srangeArray eq srangeBnds[0]):where(srangeArray eq srangeBnds[1])]							     

    xrangeArray = xrangeArray[where(xrangeArray eq xrangeBnds[0]):where(xrangeArray eq xrangeBnds[1])]
    yrangeArray = yrangeArray[where(yrangeArray eq yrangeBnds[0]):where(yrangeArray eq yrangeBnds[1])]
    zrangeArray = zrangeArray[where(zrangeArray eq zrangeBnds[0]):where(zrangeArray eq zrangeBnds[1])]
    srangeArray = srangeArray[where(srangeArray eq srangeBnds[0]):where(srangeArray eq srangeBnds[1])]
    
   ;*******************************************************************************************************
   ;MGS - X-S projection
   ;*******************************************************************************************************
   MGSPlotData = MGSCoverageSmallXS
   yTitleText = "$s_{MSO}\ \sqrt{}(y^2+z^2)[R_M]$"
   imgMGSXS = image(MGSPlotData/total(MGSPlotData), xrangeArray, srangeArray,$
				 axis_style=2, min_value=0.0, max_value=max(MGSPlotData/total(MGSPlotData))*.10, $
				 ytitle=yTitleText, xtitle="$x_{MSO}\ [R_M]$", $
 	 	 		 ;title ="MGS", $
 				 font_size=18, /aspect_ratio, $
				 rgb_table=tbl, position=[0.12,0.13,0.49,0.50], $
				 xrange=xrangeBnds, xstyle=1, xthick=2, $
				 yrange=yrangeBnds, ystyle=1, ythick=2)
				 
   t = text(2.0, 3.0, 'MGS', font_style=1, /data, target=imgMGSXS)
   polyMarsNight = polygon(xm[where(xm lt 0.0)], ym[where(xm lt 0.0)], /data, fill_color='black', target=imgMGSXS)		
   polyMars = polygon(xm[where(xm ge 0.0)], ym[where(xm ge 0.0)], /data, fill_color='Maroon', fill_transparency=25, target=imgMGSXS)	
   pTModel = plot(xshockTrot, sshockTrot, linestyle='--', color='dark goldenrod', /overplot, thick=2)
   pTIMBModel = plot(xIMBTrot, sIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
   pMars = plot(xm,ym, color='red', /overplot)
   
   ;*******************************************************************************************************
   ;MGS - Y-Z projection
   ;*******************************************************************************************************
	MGSPlotData = total(MGSCoverageSmall,1, /NAN)

	imgMGSYZ = image(MGSPlotData/total(MGSPlotData), yrangeArray, zrangeArray,$
				 axis_style=2, min_value=0.0, max_value=max(MGSPlotData/total(MGSPlotData))*.10, $
				 ytitle="$z_{MSO}\ [R_M]$", xtitle="$y_{MSO}\ [R_M]$", $
 	 	 		 ;title ="MGS", $
 			     font_size=18, /aspect_ratio, $
				 rgb_table=tbl, position=[0.5,0.13,0.87,0.5], /current, $
				 xthick=2, $
				 yshowtext=0, ythick=2)
	
	t = text(0.71, 0.43, 'MGS', font_style=1)
	t = text(0.49, 0.63, "$z_{MSO}\ [R_M]$", orientation=90, font_size=18)
	polyMars = polygon(xm, ym, /data, fill_color='Maroon', fill_transparency=25, target=imgMGSYZ)
	pTModel = plot(yshockTrot, zshockTrot, linestyle='--', color='dark goldenrod', /overplot, thick=2)
	pTIMBModel = plot(yIMBTrot, zIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
	pMars = plot(xm,ym, color='red', /overplot)

   ;*******************************************************************************************************
   ;MVN - X-S projection
   ;*******************************************************************************************************
	MVNPlotData = MVNCoverageSmallXS
	imgMVNXS = image(MVNPlotData/total(MVNPlotData), xrangeArray, srangeArray,$
				 axis_style=2, min_value=0.0, max_value=max(MVNPlotData/total(MVNPlotData))*.10, $
				 xtitle="$x_{MSO}\ [R_M]$", ytitle=yTitleText, $
 	 	 		 ;title ="MAVEN", $
 				 font_size=18, /aspect_ratio, $
				 rgb_table=tbl, position=[0.12,0.55,0.49,0.92], $
				 xrange=xrangeBnds, xstyle=1, xthick=2, xshowtext=0, $
				 yrange=yrangeBnds, ystyle=1, ythick=2, /current)
				 		 
   t = text(0.32, 0.85, 'MAVEN', font_style=1)				 
   polyMarsNight = polygon(xm[where(xm lt 0.0)], ym[where(xm lt 0.0)], /data, fill_color='black', target=imgMVNXS)		
   polyMars = polygon(xm[where(xm ge 0.0)], ym[where(xm ge 0.0)], /data, fill_color='Maroon', fill_transparency=25, target=imgMVNXS)	
   pTModel = plot(xshockTrot, sshockTrot, linestyle='--', color='dark goldenrod', /overplot, thick=2)
   pTIMBModel = plot(xIMBTrot, sIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
   pMars = plot(xm,ym, color='red', /overplot)
   
   ;*******************************************************************************************************
   ;MVN - Y-Z projection
   ;*******************************************************************************************************
   MVNPlotData = total(MVNCoverageSmall,1, /NAN)


	imgMVNYZ = image(MVNPlotData/total(MVNPlotData), yrangeArray, zrangeArray,$
				 axis_style=2, min_value=0.0, max_value=max(MVNPlotData/total(MVNPlotData))*.10, $
				 xtitle="$y_{MSO}\ [R_M]$", ytitle="$z_{MSO}\ [R_M]$", $
 	 	 		 ;title ="MAVEN", $
 				 font_size=18, /aspect_ratio, $
				 rgb_table=tbl, position=[0.5,0.55,0.87,0.92], /current, $
				 xshowtext=0, xthick=2, yshowtext=0, ythick=2)
				 
	t = text(0.73, 0.85, 'MAVEN', font_style=1)
	t = text(0.49, 0.2, "$z_{MSO}\ [R_M]$", orientation=90, font_size=18)	 
	polyMars = polygon(xm, ym, /data, fill_color='Maroon', fill_transparency=25, target=imgMVNYZ)
	pTModel = plot(yshockTrot, zshockTrot, linestyle='--', color='dark goldenrod', /overplot, thick=2)
	pTIMBModel = plot(yIMBTrot, zIMBTrot, linestyle='-.', color='dark goldenrod', /overplot, thick=2)
	pMars = plot(xm,ym, color='red', /overplot)
	
	
	c = colorbar(target=imgMVNYZ, orientation=1, position = [0.87, 0.12, 0.90, 0.92], textpos=1, $
				 taper=3, tickname = ['','','','','',''], tickvalues = [0.0, $
				 													 max(MVNPlotData/total(MVNPlotData))*.02, $
				 													 max(MVNPlotData/total(MVNPlotData))*.04, $
				 													 max(MVNPlotData/total(MVNPlotData))*.06, $
				 													 max(MVNPlotData/total(MVNPlotData))*.08, $
				 													 max(MVNPlotData/total(MVNPlotData))*.10], $
				 title='Relative Orbital Density', font_size=18, /border_on, text_orientation=45)

end