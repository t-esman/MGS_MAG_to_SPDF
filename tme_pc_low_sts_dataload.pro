;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Purpose:
;Load .sts detail file for MGS MAG low time resolution pc
;No processes are performed on the data - just what is in the .sts file
;
;Author:
; teresa.Esman@nasa.gov
;
; Last edited: 11/9/2022
; 11/3/2022
; 7/18/2014
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro tme_pc_low_sts_dataload,fnlpc,OUTBOARD_B_J2000_X_LOW_PC, $
  OUTBOARD_B_J2000_Y_LOW_PC,OUTBOARD_B_J2000_Z_LOW_PC,OUTBOARD_B_J2000_RANGE_LOW_PC,$
  SC_POSITION_X_LOW_PC, SC_POSITION_Y_LOW_PC, SC_POSITION_Z_LOW_PC, $
  OUTBOARD_RMS_X_LOW_PC, OUTBOARD_RMS_Y_LOW_PC, OUTBOARD_RMS_Z_LOW_PC, $
  OUTBOARD_RMS_RANGE_LOW_PC, OUTBOARD_BSC_PAYLOAD_X_LOW_PC,OUTBOARD_BSC_PAYLOAD_Y_LOW_PC,$
  OUTBOARD_BSC_PAYLOAD_Z_LOW_PC,OUTBOARD_BSC_PAYLOAD_RANGE_LOW_PC,$
  OUTBOARD_BD_PAYLOAD_X_LOW_PC,OUTBOARD_BD_PAYLOAD_Y_LOW_PC,$
  OUTBOARD_BD_PAYLOAD_Z_LOW_PC,OUTBOARD_BD_PAYLOAD_RANGE_LOW_PC,$
  SA_NEGY_CURRENT_LOW_PC, SA_POSY_CURRENT_LOW_PC, SA_OUTPUT_CURRENT_LOWPC, $
  cmdLine_LOW_PC

  stsread,fnlpc,data,colNames,cmdLine,unitNames,titleLine

 TIME_YEAR_LOW_PC = reform(data[0,*])
  TIME_DOY_LOW_PC = reform(data[1,*])
  TIME_HOUR_LOW_PC = reform(data[2,*])
  TIME_MIN_LOW_PC = reform(data[3,*])
  TIME_SEC_LOW_PC = reform(data[4,*])
  TIME_MSEC_LOW_PC = reform(data[5,*])
  DECIMAL_DAY_LOW_PC = reform(data[6,*])
  OUTBOARD_B_J2000_X_LOW_PC = reform(data[7,*])
  OUTBOARD_B_J2000_Y_LOW_PC = reform(data[8,*])
  OUTBOARD_B_J2000_Z_LOW_PC = reform(data[9,*])
  OUTBOARD_B_J2000_RANGE_LOW_PC = reform(data[10,*])
  SC_POSITION_X_LOW_PC = reform(data[11,*])
  SC_POSITION_Y_LOW_PC = reform(data[12,*])
  SC_POSITION_Z_LOW_PC = reform(data[13,*])
  OUTBOARD_RMS_X_LOW_PC = reform(data[14,*])
  OUTBOARD_RMS_Y_LOW_PC = reform(data[15,*])
  OUTBOARD_RMS_Z_LOW_PC = reform(data[16,*])
  OUTBOARD_RMS_RANGE_LOW_PC = reform(data[17,*])
  OUTBOARD_BSC_PAYLOAD_X_LOW_PC = reform(data[18,*])
  OUTBOARD_BSC_PAYLOAD_Y_LOW_PC = reform(data[19,*])
  OUTBOARD_BSC_PAYLOAD_Z_LOW_PC = reform(data[20,*])
  OUTBOARD_BSC_PAYLOAD_RANGE_LOW_PC = reform(data[21,*])
  OUTBOARD_BD_PAYLOAD_X_LOW_PC = reform(data[22,*])
  OUTBOARD_BD_PAYLOAD_Y_LOW_PC = reform(data[23,*])
  OUTBOARD_BD_PAYLOAD_Z_LOW_PC = reform(data[24,*])
  OUTBOARD_BD_PAYLOAD_RANGE_LOW_PC = reform(data[25,*])
  SA_NEGY_CURRENT_LOW_PC = reform(data[26,*])
  SA_POSY_CURRENT_LOW_PC = reform(data[27,*])
  SA_OUTPUT_CURRENT_LOW_PC = reform(data[28,*])
  colNames_LOW_PC = colNames
  cmdLine_LOW_PC = cmdLine
  unitNames_LOW_PC = unitNames
  titleLine_LOW_PC = titleLine



end