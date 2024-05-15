pro gnc_reader
;used for getting the RW speed
year=20
for day_start = 126,130,7  do begin;275 do begin
for day_end = 130,137,7 do begin;day_start, day_start+1 do begin
  if day_start lt 10 then begin
    add_on_string_start='00'
  endif else if day_start lt 100 then add_on_string_start='0'
  if day_end lt 10 then begin
    add_on_string_end='00'
  endif else if day_end lt 100 then add_on_string_end='0'
  
  if day_start ge 100 then add_on_string_start=''
  if day_end ge 100 then add_on_string_end=''
  
file='../../../../Volumes/ExtremeSSD/MAVEN/sci_anc_gnc/sci_anc_gnc'+strtrim(string(year),2)+'_'+add_on_string_start+strtrim(string(day_start),2)+'_'+add_on_string_end+strtrim(string(day_end),2)+'.txt'
;data=read_ascii(file,data_start=5)
;OPENR, lun, file, /GET_LUN

readcol,file,time,ATT_QU_I2B_1, ATT_QU_I2B_2, ATT_QU_I2B_3, $
  ATT_QU_I2B_4, ATT_QU_I2B_T, ATT_RAT_BF_X, ATT_RAT_BF_Y, $
  ATT_RAT_BF_Z, $;APIG_ANGLE, APOG_ANGLE, APIG_APP_RAT, APOG_APP_RAT,$
  RW1_SPD_DGTL, RW2_SPD_DGTL, RW3_SPD_DGTL, RW4_SPD_DGTL, $;ACC_BOD_VECX,$
 ; ACC_BOD_VECY, ACC_BOD_VECZ, RW1_SPD_PTE,  RW2_SPD_PTE, RW3_SPD_PTE, $
 ; RW4_SPD_PTE, $
  FORMAT='A', skipline=4
  
  t1=file_search('../../../../Volumes/Tesman_WD/MAVEN/sci_anc_gnc/sci_anc_gnc'+strtrim(string(year),2)+'/sci_anc_gnc'+strtrim(string(year),2)+'_'+add_on_string_start+strtrim(string(day_start),2)+'_'+add_on_string_end+strtrim(string(day_end),2)+'.txt')

RW1_HZ = RW1_SPD_DGTL*(2*!pi)
RW2_HZ = RW2_SPD_DGTL*(2*!pi)
RW3_HZ = RW3_SPD_DGTL*(2*!pi)
RW4_HZ = RW4_SPD_DGTL*(2*!pi)
  if t1 eq '' then begin
    print,'Continuing to next day'
    continue
  endif
;save,filename='../../../../Volumes/Tesman_WD/MAVEN/sci_anc_gnc/sci_anc_gnc'+strtrim(string(year),2)+'/mvn_rw_gnc'+strtrim(string(year),2)+'_'+strtrim(string(day_start),2)+'_'+strtrim(string(day_end),2)+'.sav'
endfor
endfor
end