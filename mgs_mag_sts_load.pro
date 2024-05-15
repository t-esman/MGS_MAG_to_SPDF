;+
; PROCEDURE:
; MGS_MAG_STS_LOAD
;
; PURPOSE:
; Read magnetometer .sts files and loads into TPlot variables
;
; AUTHOR:
; adapted from MVN_MAG_STS_LOAD
; Jacob Gruesbeck
;
; CALLING SEQUENCE:
;
;
; INPUT:
; FILENAME - String containing .sts filename to be loaded
;
; KEYWORDS:
; TPLOT    - If set, produces the usual TPlot variables
;   timeD    - if set, outputs timing info
;
; NOTES:
;     Uses mvn_mag_stshdr.pro.
;     Based on parts from mvn_mag_sts_read.pro, shrink.pro.
;
; EXAMPLE:
;     IDL> data_structure = mvn_mag_sts_load(filename)
;
; HISTORY:
;
;-

function mgs_mag_sts_load, filename, tplot=tplot, timeD=timeD
frame = 'pc'
  if keyword_set(timeD) then start1 = systime(/seconds)

  ;make sure file is there (from mvn_mag_sts_read.pro)
  file=file_search(filename)
  if size(file,/type) eq 7 and file[0] eq '' then begin
    print, 'ERROR: File '+filename+' not found/loaded.'
    return, 0
  endif

  ;filename is there, now read header to get the variable names and the end line of the
  ;header
  mvn_mag_stshdr, fname=filename, varnames, fmt, linenum=linenum

  ;make sure varnames doesn't have empty title, since it currently brings along a leading one
  varnames = varnames[where(varnames ne '')]

 
  ;Determine the length of the file, minus the header
  numLines = file_lines(filename) - linenum


  ;read data into big array
  dataFull = dblarr(n_elements(varnames), numLines)
  openr, lun, filename, /get_lun
  skip_lun, lun, linenum, /lines
  readf, lun, dataFull
  close, lun
  free_lun, lun
return,dataFull


;if Tplot set, produce tplot variables
;if keyword_set(tplot) then begin
  ;Produce array of unix times
  timeString = strcompress(string(dataFull(0,*), format='(I4.4)'), /remove_all) +'-'+$
    strcompress(string(dataFull(1,*), format='(I3.3)'), /remove_all) +'/'+$
    strcompress(string(dataFull(2,*), format='(I2.2)'),/remove_all) + ':' + $
    strcompress(string(dataFull(3,*), format='(I2.2)'),/remove_all) + ':' + $
    strcompress(string(dataFull(4,*), format='(I2.2)'),/remove_all) + '.' + $
    strcompress(string(dataFull(5,*), format='(I3.3)'),/remove_all)
  magTime = time_double(timeString, tformat='YYYY-DOY/hh:mm:ss.fff')

  ;Store Bx, By and Bz
  varRoot = 'OB_B'
;  if (frame eq 'pl' or frame eq 'ql') then varRoot = varRoot+'PL'
 ; if (frame eq 'bs') then varRoot = varRoot+'S'

  indX = where(varnames eq (varRoot+'_X'))
  indY = where(varnames eq (varRoot+'_Y'))
  indZ = where(varnames eq (varRoot+'_Z'))

;  if (indX eq -1) then begin
;    varRoot = 'IB_B'
;    if (frame eq 'bs') then varRoot = varRoot+'S'
;    indX = where(varnames eq (varRoot+'_X'))
;    indY = where(varnames eq (varRoot+'_Y'))
;    indZ = where(varnames eq (varRoot+'_Z'))
;  endif


  tplotSuffix = ''
  if (frame ne 'pl' and frame ne 'ql') then tplotSuffix = '_'+frameName
  store_data, 'mgs_B_full'+tplotSuffix, data={x:magTime, y:[[data.(indX+2)], [data.(indY+2)], [data.(indZ+2)]]}, $
    dlimit = {spice_frame:frameName}, limit = {level:strupcase(lvl)}
  options, 'mgs_B_full'+tplotSuffix, ytitle=strupcase(lvl)+' [Full] Mag [nT]',/def
;endif

;print timing stuff
if keyword_set(timeD) then print, 'Elapsed time (seconds): '+string((systime(/seconds)-start1))
end