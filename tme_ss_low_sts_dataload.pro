;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Purpose:
;Load .sts detail file for MGS MAG pl_ss
;Formatting
;No data changing processes are performed
;
;
;Author:
; teresa.Esman@nasa.gov
;
; Last edited: 05/15/2024
; 11/3/2022
; 7/18/2014
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro tme_ss_low_sts_dataload,fnlss,TIME_DOY_LOW_SS,TIME_HOUR_LOW_SS,TIME_MIN_LOW_SS,$
  TIME_SEC_LOW_SS,TIME_MSEC_LOW_SS,TIME_YEAR_LOW_SS,DECIMAL_DAY_LOW_SS, $
  OUTBOARD_B_J2000_X_LOW_SS, OUTBOARD_B_J2000_Y_LOW_SS,OUTBOARD_B_J2000_Z_LOW_SS, $
  OUTBOARD_B_J2000_RANGE_LOW_SS, SC_POSITION_X_LOW_SS, SC_POSITION_Y_LOW_SS, $
  SC_POSITION_Z_LOW_SS, OUTBOARD_RMS_X_LOW_SS, OUTBOARD_RMS_Y_LOW_SS, $
  OUTBOARD_RMS_Z_LOW_SS, OUTBOARD_RMS_RANGE_LOW_SS, OUTBOARD_BSC_PAYLOAD_X_LOW_SS, $
  OUTBOARD_BSC_PAYLOAD_Y_LOW_SS, OUTBOARD_BSC_PAYLOAD_Z_LOW_SS, OUTBOARD_BSC_PAYLOAD_RANGE_LOW_SS,$
  OUTBOARD_BD_PAYLOAD_X_LOW_SS,OUTBOARD_BD_PAYLOAD_Y_LOW_SS,OUTBOARD_BD_PAYLOAD_Z_LOW_SS,$
  OUTBOARD_BD_PAYLOAD_RANGE_LOW_SS,SA_NEGY_CURRENT_LOW_SS,SA_POSY_CURRENT_LOW_SS,SA_OUTPUT_CURRENT_LOW_SS,$
  colNames_LOW_SS,cmdLine_LOW_SS,unitNames_LOW_SS

  stsread,fnlss,data,colNames,cmdLine,unitNames,titleLine

  TIME_YEAR_LOW_SS = reform(data[0,*])
  TIME_DOY_LOW_SS = reform(data[1,*])
  TIME_HOUR_LOW_SS = reform(data[2,*])
  TIME_MIN_LOW_SS = reform(data[3,*])
  TIME_SEC_LOW_SS = reform(data[4,*])
  TIME_MSEC_LOW_SS = reform(data[5,*])
  DECIMAL_DAY_LOW_SS = reform(data[6,*])
  OUTBOARD_B_J2000_X_LOW_SS = reform(data[7,*])
  OUTBOARD_B_J2000_Y_LOW_SS = reform(data[8,*])
  OUTBOARD_B_J2000_Z_LOW_SS = reform(data[9,*])
  OUTBOARD_B_J2000_RANGE_LOW_SS = reform(data[10,*])
  SC_POSITION_X_LOW_SS = reform(data[11,*])
  SC_POSITION_Y_LOW_SS = reform(data[12,*])
  SC_POSITION_Z_LOW_SS = reform(data[13,*])
  OUTBOARD_RMS_X_LOW_SS = reform(data[14,*])
  OUTBOARD_RMS_Y_LOW_SS = reform(data[15,*])
  OUTBOARD_RMS_Z_LOW_SS = reform(data[16,*])
  OUTBOARD_RMS_RANGE_LOW_SS = reform(data[17,*])
  OUTBOARD_BSC_PAYLOAD_X_LOW_SS = reform(data[18,*])
  OUTBOARD_BSC_PAYLOAD_Y_LOW_SS = reform(data[19,*])
  OUTBOARD_BSC_PAYLOAD_Z_LOW_SS = reform(data[20,*])
  OUTBOARD_BSC_PAYLOAD_RANGE_LOW_SS = reform(data[21,*])
  OUTBOARD_BD_PAYLOAD_X_LOW_SS = reform(data[22,*])
  OUTBOARD_BD_PAYLOAD_Y_LOW_SS = reform(data[23,*])
  OUTBOARD_BD_PAYLOAD_Z_LOW_SS = reform(data[24,*])
  OUTBOARD_BD_PAYLOAD_RANGE_LOW_SS = reform(data[25,*])
  SA_NEGY_CURRENT_LOW_SS = reform(data[26,*])
  SA_POSY_CURRENT_LOW_SS = reform(data[27,*])
  SA_OUTPUT_CURRENT_LOW_SS = reform(data[28,*])
  colNames_LOW_SS = colNames
  cmdLine_LOW_SS = cmdLine
  unitNames_LOW_SS = unitNames
  titleLine_LOW_SS = titleLine


end
