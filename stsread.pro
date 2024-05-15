pro stsread, filename, data, colNames, cmdLine, unitNames, titleLine, $
             minusone=minusone, strout=strout, VERBOSE = verbose, HELPME=helpme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;stsread.pro								;
;									;
; Procedure loads data from .sts file.  If the ODL header is 		;
;  present it also loads the column names, mgan command line, and the 	;
;  unit names for each column.  The output array is double precision. 	;
;  The routine won't work if your sts file contains columns of string 	;
;  output from MGAN.  If your file contains "NOCANDO"s or "********"s 	;
;  or empty columns it just skips those lines				;
;                                                                       ;
;  Updated version with strout keyword will work when there are columns ;
;  of strings.  The output is an array of structures.  The ODL header   ;
;  is required for the strout keyword option.                           ;
;									;
; Passed Variables							;
;	filename	-	Name of the STS file to read		;
;	data		-	NxM array containing the data 		;
;				from the STS file			;
;  	colNames	-	1D array with the column names 		;
;				for the data array			;
;  	cmdLine		-	Returns CMD_LINE line from filestr 	;
;				(mgan command used to create the file)	;
;	unitNames	-	1D array with the unit names 		;
;				for the data array			;
;       titleLine       -       Returns TITLE line from filestr         ;
;       minusone        -       return data = -1 instead of stopping    ;
;	strout          -       keyword: return data as structure       ;
;                                  Requires ODL header.                 ;
;  	VERBOSE		-	keyword: Gives a report before exiting	;
;  	HELPME		-	keyword: Prints a help screen		;
;									;
; Called Routines:							;
;	parsestr.pro	-	Separates string into array of parts	;
;									;
; Written by:		Monte Kaelberer					;
; Last Modified: 	Nov 19, 1998	(Pat Lawton and Dave Brain)	;
;			24 Feb 2000  PJL  handle when command line is   ;
;					  more than one line long       ;
;                       11 Apr 2000  PJL  corrected typo - 'repor' to   ;
;					  'report'                      ;
;                       31 Aug 2011  PJL  added obtaining TITLE line    ;
;                                         and n_params(0) check         ;
;                        1 Sep 2011  PJL  remove 'TITLE' and '=' from   ;
;                                         titleLine                     ;
;                        6 Jan 2014  PJL  add minusone and strout       ;
;                                         keywords                      ;
;                       15 Jan 2014  PJL  update prolog and help info;  ;
;                                         handle tags with characters   ;
;                                         that can not be in tagnames   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

COMMON REPVARS, RepNumCols, RepValidDat, RepHdrLines, RepNocandos, $
		RepAsterisk, RepBadLines, RepTotLines

IF keyword_set(verbose) EQ 0 THEN $
   verbose = 0

start1 = systime(1)

;Give help if requested.
IF ( (keyword_set(helpme)) or (n_params(0) eq 0) ) THEN BEGIN
  print,''
  print,'Procedure loads data from an .sts file.  If the ODL header is'
  print,' present it also loads the column names, mgan command line, and the'
  print,' unit names for each column.  The output array is double precision.'
  print,' The routine won''t work if your sts file contains columns of string'
  print,' output from MGAN.  If your file contains "NOCANDO"s or "********"s'
  print,' or empty columns it just skips those lines).'
  print,''
  print,'Syntax:'
  print,'stsread, filename, data, colNames, cmdLine, unitNames, ' +   $
     'titleLine, /verbose, /minusone, /strout, /HELPME'
  print,''
  print,'  filename  -   File name of file to process (input)'
  print,'  data      -   NxM array containing the data from the STS file.'
  print,'  colNames  -   1D array with the column names for the data array.'
  print,'  cmdLine   -   Returns CMD_LINE line from filestr (mgan command '
  print,'                used to create the file).' 
  print,'  titleLine -   Returns TITLE line from filestr.'
  print,'  unitNames -   Returns 1D array containing unit names for the data'
  print,'                array.'
  print,'  /VERBOSE  -   keyword: Gives a report before exiting'
  print,'  /MINUSONE -   keyword: returns data equal to -1 instead of stopping'
  print,'  /STROUT   -   keyword: returns data as IDL structure (ODL required)'
  print,'  /HELPME   -   keyword: If present, displays this screen.'
  return
ENDIF


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize Report Variables ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RepNumCols  = 0L				; # of Columns of Data
RepValidDat = 0L				; # of rows in output data array
RepHdrLines = 0L				; # of header lines
RepNocandos = 0L				; # of NOCANDO Lines removed
RepAsterisk = 0L				; # of ******* lines removed
RepBadLines = 0L				; # of other lines removed
RepTotLines = 0L				; # of total lines in the file


;;;;;;;;;;;;;
; Read file ;
;;;;;;;;;;;;;
openr, lun, filename, /get_lun			; open file
nrows = 0L
s = ''
WHILE NOT EOF(lun) DO BEGIN			; count # of lines
   readf, lun, s
   nrows = nrows + 1
ENDWHILE
point_lun, lun, 0				; reset pointer
IF nrows EQ 0 THEN BEGIN
   if (keyword_set(minusone)) then begin
      data = -1
      colNames  = ''				; Return blank string
      cmdLine   = ''				; Return blank string
      unitNames = ''				; Return blank string
      titleLine = ''                            ; Return blank string
      IF verbose THEN report
      return
   endif else begin
      print, ' ***stsread.pro: File Empty***'
      print, ' ***Stopping***'
      IF verbose THEN report
      STOP
   endelse  ; keyword_set(minusone)
ENDIF
FILEstr = strarr(nrows)				; initialize file str
readf, lun, FILEstr				; read entire file into FILEstr
RepTotLines = nrows
free_lun, lun


;;;;;;;;;;;;;;;;;;;;;
; Handle ODL Header ;
;;;;;;;;;;;;;;;;;;;;;
odl = where(strpos(FILEstr,'END_OBJECT') NE -1)	; Locate ODL header, if present

IF odl(0) EQ -1 THEN $
   IF verbose THEN $
      print, 'No ODL Header'

IF odl(0) NE -1 THEN BEGIN			; If the ODL header is present

   start3 = systime(1)				; Start timer
   
   ; get # of header lines
   numhdrlines = odl(n_elements(odl)-1) + 1
   RepHdrLines = numhdrlines
   IF nrows EQ numhdrlines THEN BEGIN
      if (keyword_set(minusone)) then begin
         data = -1
         colNames  = ''				; Return blank string
         cmdLine   = ''				; Return blank string
         unitNames = ''				; Return blank string
         titleLine = ''                         ; Return blank string
         IF verbose THEN report
         return
      endif else begin
         print, ' ***stsread.pro: No Data after ODL Header***'
         print, ' ***Stopping***'
         IF verbose THEN report
         STOP
      endelse  ; keyword_set(minusone)
   ENDIF

   ; Define string arrays
   HDRstr  = FILEstr(0:numhdrlines-1)		; Define string array for header
   FILEstr = FILEstr(numhdrlines:nrows-1)	; Make FILEstr records only

   ; Retrieve MGAN command line
   cmdLine = strpos(HDRstr, 'CMD_LINE')
   cmdLine = where(cmdLine NE -1)
   IF cmdLine(0) EQ -1 THEN BEGIN		; squawk if problem
      print, ' ***stsread.pro : Command Line Not Found***'
      print, ' ***Continuing***'
      cmdLine = "Command Line Not Found"
   ENDIF ELSE BEGIN
      nextLine = cmdLine(0) + 1                 ; next line in header

      cmdLine = STRTRIM(HDRstr(cmdLine(0)), 2)  ; variable definition changes!

      ; command line may be more than one line long

      while ( (strpos( HDRstr(nextLine), '=') eq -1) and   $
              (strpos( HDRstr(nextLine), 'OBJECT') eq -1) ) do begin
         cmdLine = cmdLine + ' ' + STRTRIM(HDRstr(nextLine), 2)
         nextLine = nextLine + 1
      endwhile  ; strpos( HDRstr(nextLine), '=') eq -1 ...
   ENDELSE  ; cmdLine(0) EQ -1

   ; Retrieve STS title line
   titleLine = strpos(HDRstr, 'TITLE')
   titleLine = where(titleLine NE -1)
   IF (titleLine(0) EQ -1) THEN BEGIN		; squawk if problem
      print, ' ***stsread.pro : Title Line Not Found***'
      print, ' ***Continuing***'
      titleLine = "Title Line Not Found"
   ENDIF ELSE BEGIN
      nextLine = titleLine(0) + 1                 ; next line in header

      titleLine = STRTRIM(HDRstr(titleLine(0)), 2) ;variable definition changes!

      ; title line may be more than one line long

      while ( (strpos( HDRstr(nextLine), '=') eq -1) and   $
              (strpos( HDRstr(nextLine), 'OBJECT') eq -1) ) do begin
         titleLine = titleLine + ' ' + STRTRIM(HDRstr(nextLine), 2)
         nextLine = nextLine + 1
      endwhile  ; strpos( HDRstr(nextLine), '=') eq -1 ...
   ENDELSE  ; titleLine(0) EQ -1
   titleLine = strtrim(strmid(titleLine,strpos(titleLine,'=')+1,   $
      strlen(titleLine)),2)

   ; Find object records
   rcrdstrt = strpos(HDRstr, 		      $
              'OBJECT      =  RECORD')
   rcrdstrt = where(rcrdstrt NE -1)

; squawk if problem

   IF rcrdstrt(0) EQ -1 OR n_elements(rcrdstrt) GT 1 THEN BEGIN	
      if (keyword_set(minusone)) then begin
         data = -1
         colNames  = ''				; Return blank string
         cmdLine   = ''				; Return blank string
         unitNames = ''				; Return blank string
         titleLine = ''                         ; Return blank string
         IF verbose THEN report
         return
      endif else begin
         print, ' ***stsread.pro: Error finding object records***'
         print, ' ***             (too few or too many in file)***'
         print, ' ***Stopping***'
         IF verbose THEN report
         STOP
      endelse  ; keyword_set(minusone)
   ENDIF

   HDRstr = HDRstr(rcrdstrt(0):numhdrlines(0)-1); Remove beginning of header

   ; Setup variables
   nendObjects  = 0  	 			; # of "END_OBJECTS"
   nobjects     = 1      	 		; # of "OBJECTS"
   colNames     = strarr(1000)  		; Holds names of columns
   allNames     = strarr(1000)  		; Holds every name found
   iAllNames    = 0				; # of names in allNames
   allAliases   = strarr(1000) 			; Holds every alias found
   iAllAliases  = 0           			; # of aliases
   unitNames    = replicate('NONE', 1000)	; Holds names of units
   formatvalues = replicate('', 1000)	        ; Holds formats
   tmpstr       = ''
   ifileLine    = 1				; Current file line #
   objectStr    = 'OBJECT   ='			; Search string
   endobjectStr = 'END_OBJECT'			; Search string
   nameStr      = 'NAME'			; Search string
   aliasStr     = 'ALIAS'			; Search string
   vectorStr    = 'VECTOR'			; Search string
   unitStr	= 'UNITS'			; Search string
   formatStr	= 'FORMAT'			; Search string
   readformat = ''                              ; format for reading
   vectorFlag   = 0  			; boolean: 1 for vector, else 0
   foundFlag    = 1 			; 1 for found object, 2 for end_object
   inames       = 0  			; Current colNames index to insert at
   prevLevName  = ''				; Name at the previous level

   ; Extract Col. Names, Units, etc.
   ; ( Use parsestr procedure to parse line into its components )
   WHILE (nendObjects LT nobjects) DO BEGIN

      line = HDRstr(ifileLine)				; store current line
      
      IF (strpos(line, objectStr) GE 0) THEN BEGIN	; if found object
         IF (strpos(line, vectorStr) GE 0) THEN       $	; Set vector flag
            vectorFlag = 1			      $
         ELSE 					      $
            vectorFlag = 0
         nobjects  = nobjects + 1			; add to # of objects
         foundFlag = 1					; set found object flag
      ENDIF

      IF (strpos(line, nameStr) GE 0) THEN BEGIN	; if name
         parsestr, line, strarr1
         allNames(iAllNames) = strarr1(2)
         IF (vectorFlag) THEN 			      $
	    prevLevName = strarr1(2)
         iAllNames = iAllNames + 1
      ENDIF

      IF (strpos(line, aliasStr) GE 0) THEN BEGIN	; if alias
         parsestr, line, strarr1
         allAliases(iAllAliases) = strarr1(2)
         allNames(iAllNames - 1) = strarr1(2)
         IF (vectorFlag) THEN                         $
	    prevLevName = strarr1(2)
         iAllAliases = iAllAliases + 1
      ENDIF

      IF (strpos(line, unitStr) GE 0) THEN BEGIN	; if units
         parsestr, line, strarr1
         unitNames(inames) = strarr1(2)
      ENDIF

      IF (strpos(line, formatStr) GE 0) THEN BEGIN	; if format
         parsestr, line, strarr1
         formatvalues(inames) = strarr1(2)
      ENDIF

      IF (strpos(line, endobjectStr) GE 0) THEN BEGIN	; if endobject
         nendobjects = nendobjects + 1
         IF (foundFlag EQ 1) THEN BEGIN
            tmpstr = allNames(iAllNames - 1)
            nnests = nobjects - nendObjects
            IF (nnests gt 1) THEN                     $
               colNames(inames) = prevLevName + '_' + $
	                          tmpstr	      $
            ELSE                                      $
               colNames(inames) = tmpstr
            inames = inames + 1
         ENDIF
         foundFlag = 2
      ENDIF

      ifileLine = ifileLine + 1				; move to next line

   ENDWHILE; (nendObjects LT nobjects)

   ; Handle Arrays
   ncolumns   = inames				; Set # of columns of data
   RepNumCols = ncolumns
   nrows      = nrows - numhdrlines(0)		; find # of rows of data
   colNames   = colNames(0:inames-1)		; resize arrays
   unitNames  = unitNames(0:inames-1)
   formatvalues = formatvalues[0:inames-1]

   ; Announce header parsing time
   IF verbose THEN print, 'Header parsed in time: ', $
      systime(1) - start3

ENDIF; (End of If block containing ODL header processing)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Remove Lines Containing Invalid Data ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; NOCANDOS
strnocando  = strpos(FILEstr, 'NOCANDO')
keeploc     = where(strnocando EQ -1)
IF keeploc(0) eq -1 THEN BEGIN
   print, ' ***stsread.pro: File contains only invlaid data!***'
   print, ' ***Stopping!***'
   IF verbose THEN BEGIN
      RepNocandos = nrows
      report
   ENDIF
   STOP
ENDIF
FILEstr     = FILEstr(keeploc)
RepNocandos = nrows - n_elements(FILEstr)
nrows       = n_elements(FILEstr)

; Asterisks
straskarr   = strpos(FILEstr, '**')
keeploc     = where(straskarr EQ -1)
IF keeploc(0) eq -1 THEN BEGIN
   print, ' ***stsread.pro: File contains only invlaid data!***'
   print, ' ***Stopping!***'
   IF verbose THEN BEGIN
      RepAsterisk = nrows
      report
   ENDIF
   STOP
ENDIF
FILEstr     = FILEstr(keeploc)
RepAsterisk = nrows - n_elements(FILEstr)
nrows       = n_elements(FILEstr)

; Keep only lines with correct # of columns
tmp     = strcompress(strtrim(filestr,2))
ncolchk = strlen(tmp) - $
          strlen(strcompress(tmp,/remove_all)) + 1
IF odl(0) EQ -1 THEN $
   ncolumns = max(ncolchk)
ncolchk = where(ncolchk EQ ncolumns)
IF ncolchk(0) NE -1 THEN BEGIN
   FILEstr = FILEstr(ncolchk)
   RepBadLines = nrows - n_elements(FILEstr)
   nrows = n_elements(FILEstr)
ENDIF ELSE BEGIN
   print, ' ***stsread.pro:***'
   print, ' ***Error reading correct # of columns!***'
   IF verbose THEN report
   STOP
ENDELSE
   		   
   		   
IF odl(0) EQ -1 THEN BEGIN				; IF no ODL header

   RepNumCols = ncolumns
	       
   colNames  = strarr(ncolumns)				; Return blank array
   cmdLine   = ''					; Return blank string
   unitNames = colNames					; Return blank array
   titleLine = ''

ENDIF

;  determine if format information is available

 readformatflag = 0
 for i=0,ncolumns-2 do begin
    if (strtrim(formatvalues[i],2) ne '') then    $
       readformat = readformat + formatvalues[i] + ','   $
    else readformatflag = 1
 endfor  ; i
 if (strtrim(formatvalues[ncolumns-1],2) ne '') then    $
     readformat = readformat + formatvalues[ncolumns-1]   $
 else readformatflag = 1

;  structure output - or not

; stop

 if ( (keyword_set(strout)) and (odl(0) ne -1) and (readformat ne '') ) then  $
   begin
;    strout = strtrim(strout,2)

;  command to create the structure

    command = 'data = replicate({ filename: filename, ' +   $
       'cmdline: cmdline, titleline: titleline, ' 

;  tag names and type

    tags = strlowcase(colnames)
    value_type = strarr(ncolumns) + 'A'      ;  default to ascii

    temp = strpos(formatvalues,'I')
    tempidx = where(temp ge 0,tempidxct)
    if (tempidxct gt 0) then value_type[tempidx] = 'I' ; integer values

    temp = strpos(formatvalues,'F')
    tempidx = where(temp ge 0,tempidxct)
    if (tempidxct gt 0) then value_type[tempidx] = 'F' ; real values

;  check tags for characters that can not be in tag name
;  when adding a not_permitted value, be sure to add a permitted value 

    not_permitted = ['-', '+', '/']
    permitted = ['m', 'p', 's']
    num_not_permitted = n_elements(not_permitted)
    for i=0,num_not_permitted-1 do begin
       temp = strpos(tags,not_permitted[i])
       tempidx = where(temp gt 0,tempidxct)
       for j=0,tempidxct-1 do begin
          tempstr = tags[tempidx[j]]
          strput,tempstr,permitted[i],temp[tempidx[j]]
          tags[tempidx[j]] = tempstr
          print,'Note: ' + strlowcase(colnames[tempidx[j]]) +    $
             ' will be ' + tags[tempidx[j]]
       endfor  ; j
    endfor  ; i

    for i=0,ncolumns-1 do begin
       case (value_type[i]) of 
          'A': command = command + tags[i] + ": '', "
          'F': command = command + tags[i] + ": 0.0D, "
          'I': command = command + tags[i] + ": 0L, "
          else:  print,'this should not happen'
       endcase  ; value_type
       command = command + tags[i] + "_units: '" + unitnames[i] + "', "
       if (i ne ncolumns-1) then   $
          command = command + tags[i] + "_format: '" + formatvalues[i] + "', " $
       else command = command + tags[i] + "_format: '" + formatvalues[i] + "'"
    endfor  ; i

    command = command + '},nrows)'
; print,command
    result = execute(command) 

;  put the data into the structure

    workwith = strcompress(strtrim(filestr,2))  
    for i = 0,nrows-1L do begin
       parts = str_sep(workwith[i],' ')
       for j = 0,ncolumns-1 do begin
          command = 'data[i].' + tags[j] + ' = '
          case(value_type[j]) of
             'A': command = 'data[i].' + tags[j] + ' = strtrim(parts[j],2)'
             'F': command = 'data[i].' + tags[j] + ' = double(parts[j])'
             'I': command = 'data[i].' + tags[j] + ' = long(parts[j])'
             else:  print,'This should not happen - 2'
          endcase  ; value_type[j]
; print,command
          result = execute(command) 

       endfor ; j
    endfor  ; i
      
; print,'in structure'
; stop
 endif else begin

;  not stucture output

    if (keyword_set(strout)) then   $
       print,'No - or incomplete - ODL header, output structure not possible'

;;;;;;;;;;;;;
; Load Data ;
;;;;;;;;;;;;;

    data = dblarr(ncolumns, nrows)			; dimension array
    reads, FILEstr, data				; read array
    RepValidDat = nrows
 endelse  ; (keyword_set(strout)) and (odl(0) ne -1) and (readformat ne '')

IF verbose THEN BEGIN
   print, 'Routine ran in time: ',$		; Calculate program run time
      systime(1) - start1
   report
ENDIF

end


pro report
;
COMMON REPVARS, RepNumCols, RepValidDat, RepHdrLines, RepNocandos, $
                RepAsterisk, RepBadLines, RepTotLines
print, ''
print, FORMAT = '(A,T40,I8)', ' # of columns of data:', RepNumCols
print, FORMAT = '(A,T40,I8)', ' # of lines of valid data:', RepValidDat
print, FORMAT = '(A,T40,I8)', ' # of total lines in file', RepTotLines
print, FORMAT = '(A,T40,I8)', ' # of ODL Header Lines:', RepHdrLines
print, FORMAT = '(A,T40,I8)', ' # of lines omitted for "NOCANDO":', RepNocandos
print, FORMAT = '(A,T40,I8)', ' # of lines omitted for "********":', RepAsterisk
print, FORMAT = '(A,T40,I8)', ' # of other invalid lines:', RepBadLines
print, ''

end
