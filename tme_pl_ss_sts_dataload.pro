;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Purpose:
;Load .sts detail file for MGS MAG low time 
; resolution sun-state (MSO) data
;No changes to the data are performed
;
;Code Dependency: stsread.pro 
;     (Written by: Monte Kaelberer)
;     (Last Edited: 2014)
;
;Author: Teresa (Tracy) Esman
; teresa.Esman@nasa.gov
; NASA Postdoctoral Fellow at NASA GSFC
;
; Last edited: 05/23/2024
; 05/15/2024
; 11/9/2022
; 11/3/2022
; 7/18/2014
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro tme_pl_ss_sts_dataload,fnh,TIME_DOY_HIGH_PL_SS,TIME_HOUR_HIGH_PL_SS,TIME_MIN_HIGH_PL_SS,$
  TIME_SEC_HIGH_PL_SS,TIME_MSEC_HIGH_PL_SS,TIME_YEAR_HIGH_PL_SS,$
  DECIMAL_DAY_HIGH_PL_SS, OUTBOARD_B_J2000_RANGE_HIGH_PL_SS, OUTBOARD_B_J2000_X_HIGH_PL_SS, $
  OUTBOARD_B_J2000_Y_HIGH_PL_SS,OUTBOARD_B_J2000_Z_HIGH_PL_SS, OUTBOARD_B_PAYLOAD_RANGE_HIGH_PL_SS,$
  OUTBOARD_B_PAYLOAD_X_HIGH_PL_SS,OUTBOARD_B_PAYLOAD_Y_HIGH_PL_SS,$
  OUTBOARD_B_PAYLOAD_Z_HIGH_PL_SS,colNames_HIGH_PL_SS,cmdLine_HIGH_PL_SS,unitNames_HIGH_PL_SS,titleLine_HIGH_PL_SS

  stsread,fnh,data,colNames,cmdLine,unitNames,titleLine

TIME_YEAR_HIGH_PL_SS = reform(data[0,*])
TIME_DOY_HIGH_PL_SS = reform(data[1,*])
TIME_HOUR_HIGH_PL_SS = reform(data[2,*])
TIME_MIN_HIGH_PL_SS = reform(data[3,*])
TIME_SEC_HIGH_PL_SS = reform(data[4,*])
TIME_MSEC_HIGH_PL_SS = reform(data[5,*])
DECIMAL_DAY_HIGH_PL_SS = reform(data[6,*])
OUTBOARD_B_PAYLOAD_X_HIGH_PL_SS = reform(data[7,*])
OUTBOARD_B_PAYLOAD_Y_HIGH_PL_SS = reform(data[8,*])
OUTBOARD_B_PAYLOAD_Z_HIGH_PL_SS = reform(data[9,*])
OUTBOARD_B_PAYLOAD_RANGE_HIGH_PL_SS = reform(data[10,*])
OUTBOARD_B_J2000_X_HIGH_PL_SS = reform(data[11,*])
OUTBOARD_B_J2000_Y_HIGH_PL_SS = reform(data[12,*])
OUTBOARD_B_J2000_Z_HIGH_PL_SS = reform(data[13,*])
OUTBOARD_B_J2000_RANGE_HIGH_PL_SS = reform(data[14,*])
colNames_HIGH_PL_SS = colNames
cmdLine_HIGH_PL_SS = cmdLine
unitNames_HIGH_PL_SS = unitNames
titleLine_HIGH_PL_SS = titleLine


end
