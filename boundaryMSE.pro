;+
; PROCEDURE: boundaryMSE
; 
; PURPOSE:  Code to read in my boundary files and translate the positions to MSE
;		    coordinates when able
; 
; USAGE:
;       boundaryMSE, IMFAvgFile, /BowShock
;
; INPUTS:
;       SWAvgFile - IDL .sav file which contains the upstream IMF and SW average structure
;
; KEYWORDS:
;		BowShock - Set to translate the bow shock boundary file
; 		MPB      - Set to translate the MPB boundary file
;		Aberr    - Flag to compute the aberrated data
; 
; HISTORY:
;       2015-10-08: Initial coding, JRG
;
; CREATED BY:
;       2015-10-08: Jacob R Gruesbeck
;-

pro boundaryMSE, SWAvgFile, BowShock=BowShock, MPB=MPB, Aberr=Aberr

	;HardCoded distance (in units of orbital number) treshhold. If boundary further than this we don't use it
	distMax = 0.5

	;Begin by checking that at least one file was set
	if ~keyword_set(BowShock) and ~keyword_set(MPB) then begin
		print, 'Need to pick at least one boundary file!'
		return
	endif
	
	if keyword_set(BowShock) and keyword_set(MPB) then begin
		print, 'Please only pick one at a time!'
		return
	endif
	
	;Restore the upstream avg file
	print, '--- Restoring the upstream data ---'
	restore, SWAvgFile
	
	;Process the bow shock file if desired
	if keyword_set(BowShock) then begin
		print, '--- Processing Bow Shock file ---'
		
		;read in the BS file
		BSboundaryFile = 'BowShockLocations.txt'
		BStemplateFile = 'BowShockLocations.template'
		
		restore, BStemplateFile
		boundaryData = read_ascii(BSboundaryFile, template=template)
		
		;Set output file information
		if keyword_set(aberr) then BSOutFile = 'BowShockLocations_MSE_aberr.txt' else $
								   BSOutFile = 'BowShockLocations_MSE.txt'
	endif else if keyword_set(MPB) then begin
		print, '--- Processing MPB file ---'
		
		;read in the BS file
		BSboundaryFile = 'MPBLocations.txt'
		BStemplateFile = 'BowShockLocations.template'
		
		restore, BStemplateFile
		boundaryData = read_ascii(BSboundaryFile, template=template)
		
		;Set output file information
		if keyword_set(aberr) then BSOutFile = 'MPBLocations_MSE_aberr.txt' else $
								   BSOutFile = 'MPBLocations_MSE.txt'
	endif
	
	;begin processing
	openw, 1, BSOutFile
	printf, 1, '  Orbit Num  '+$
			   '  Cross Time           '+$
			   '  MAVEN X_MSE  '+$
			   '  MAVEN Y_MSE  '+$
			   '  MAVEN Z_MSE  '+$
			   '  Upstream/Downstream   '+$
			   '  MultiCross   '
	
	;determine only the single crossing events
	indSingle = where(boundaryData.multicrossflag eq 'n')
	
	;Loop through all pairs of crossings
	for i = 0, n_elements(indSingle)-1, 2 do begin
		;For this orbit, set the upstream and downstream index
		indUp = where(boundaryData.placeInOrbit[indSingle[i:i+1]] eq 'Upstream')
		if indUp eq 0 then begin
			indUp = indSingle[i]
			indDown = indSingle[i+1]
		endif else begin
			indUp = indSingle[i+1]
			indDown = indSingle[i]
		endelse
		
		;THIS DETERMINES WHICH UPSTREAM CONDITION WE USe
		;Find the nearest orbit number in the structure 
		midPointOrbNum = (boundaryData.orbnum[indUp]+boundaryData.orbnum[indDown])/2
		indUpstream = where(round(midPointOrbNum) eq avgSWStruct.orbNum)
		
		if (indUpStream ge 0) then begin
		
			;upstream found, check that it is within distance threshhold
			if (abs(midPointOrbNum - avgSWStruct.orbNum[indUpStream]) le distMax) then begin
				
				;if abberration is desired then process this string
				if keyword_set(aberr) then begin
					;stuff for aberration stuff
					Vaberr = -24.0
					Vsw = sqrt(avgSWStruct.swVec[indUpStream,0]^2 + $
							   avgSWStruct.swVec[indUpStream,1]^2 + $
							   avgSWStruct.swVec[indUpStream,2]^2)
							   
					phi = atan(vaberr, vsw)
					
					xMSOUp = boundaryData.xBoundary[indUp] * cos(phi) + boundaryData.yBoundary[indUp] * sin(phi)
					yMSOUp = -1.0 * boundaryData.xBoundary[indUp] * sin(phi) + boundaryData.yBoundary[indUp] * cos(phi)
					zMSOUp = boundaryData.zBoundary[indUp]
					
					xMSODown = boundaryData.xBoundary[indDown] * cos(phi) + boundaryData.yBoundary[indDown] * sin(phi)
					yMSODown = -1.0 * boundaryData.xBoundary[indDown] * sin(phi) + boundaryData.yBoundary[indDown] * cos(phi)
					zMSODown = boundaryData.zBoundary[indDown]					
				endif else begin
					xMSOUp = boundaryData.xBoundary[indUp]
					yMSOUp = boundaryData.yBoundary[indUp]
					zMSOUp = boundaryData.zBoundary[indUp]
					
					xMSODown = boundaryData.xBoundary[indDown]
					yMSODown = boundaryData.yBoundary[indDown]
					zMSODown = boundaryData.zBoundary[indDown]
				endelse
				
										
				IMFX = avgSWStruct.BVec[indUpStream, 0]
				IMFY = avgSWStruct.BVec[indUpStream, 1]
				IMFZ = avgSWStruct.BVec[indUpStream, 2]
				
				;Now go to MSE
				theta = atan(IMFZ, IMFY)
				
				xMSEUp = xMSOUp
				xMSEDown = xMSODown
				
				yMSEUp = yMSOUp*cos(theta) + zMSOUp*sin(theta)
				yMSEDown = yMSODown*cos(theta) + zMSODown*sin(theta)
				
				zMSEUp = -1*yMSOUp*sin(theta) + zMSOUp*cos(theta)
				zMSEDown = -1*yMSODown*sin(theta) + zMSODown*cos(theta)
				
				;Now print to file
				printf, 1,  '  '+strtrim(string(boundaryData.orbNum[indUp]),1)+'  '+$
							'  '+time_string(boundaryData.strTime[indUp])+'  '+$
							'  '+strtrim(string(xMSEUp, format='(F7.3)'),1)+'  '+$
							'  '+strtrim(string(yMSEUp, format='(F7.3)'),1)+'  '+$
							'  '+strtrim(string(zMSEUp, format='(F7.3)'),1)+'  '+$
							'  '+boundaryData.placeInOrbit[indUp]+'  '+$
							'  '+boundaryData.multiCrossFlag[indUp]
							
				printf, 1,  '  '+strtrim(string(boundaryData.orbNum[indDown]),1)+'  '+$
							'  '+time_string(boundaryData.strTime[indDown])+'  '+$
							'  '+strtrim(string(xMSEDown, format='(F7.3)'),1)+'  '+$
							'  '+strtrim(string(yMSEDown, format='(F7.3)'),1)+'  '+$
							'  '+strtrim(string(zMSEDown, format='(F7.3)'),1)+'  '+$
							'  '+boundaryData.placeInOrbit[indDown]+'  '+$
							'  '+boundaryData.multiCrossFlag[indDown]                      			
			endif
		endif
		
	endfor
	;close output file
	close, 1
end