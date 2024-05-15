pro maven_decom_v7b, data_file=data_file, data_directory=data_directory, $
  spacecraft=spacecraft, high=high

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;MAVEN_DECOM_V7
;Parses the MAVEN MAG telmetry packets
;Author: Jared Espley, Jared.Espley@nasa.gov
;
;;;;;;;;;;
;Keywords;
;;;;;;;;;;
;
;data_file = String variable of the filename to be decommed. If left blank then it
;              defaults to 'misg_inst_msg.dat'.
;              
;data_directory = String variable of the directory where the file is. Note that you
;                   typically have to add a '\' to the end if copying and pasting
;                   the path from a Windows Explorer window.
;                   
;/high = Decomms 256 Hz sampling mode data.
;
;/spacecraft = Decomms data with the 14 byte header that comes with data that is
;               recorded by the flight software.
;
;;;;;;;;;;;;;;;
;Example Usage;
;;;;;;;;;;;;;;;
;
;Step 1: Compile the procedure

  ;.compile maven_decom_7.pro

;Step 2: Execute the procedure.  At the end an IDL save file with all the telmetry
;        packets is produced.  In future versions, an ASCII file could be printed.
        
  ;maven_decom_v7, data_file='APID_30_timingTest5.dat', $
  ;   data_directory='C:\Research\MAVEN\MAVEN_Data\MV_EM_1\17Aug11_PF Integration\', $
  ;   /spacecraft

  ;maven_decom_v7, $
  ; data_directory='C:\Research\MAVEN\MAVEN_Data\MV_EM2\20120223_095113_EM2 HeaterOn Noise 256Hz\', $
  ; /high

;Step 3: Restore the save file so you can do things to it. Note the .sav extension.
;
  ;input_directory='C:\Research\MAVEN\MAVEN_Data\MV_EM_1\17Aug11_PF Integration\'
  ;restore, filename=input_directory+'APID_30_timingTest5.dat.sav'
  ;plot, mag_bsci_x

;;;;;;;
;Notes;
;;;;;;;

;Note: The EM1 (which as of 24Aug11 is out at SSL) has the analog words reversed.
; e.g. MAG_XTEST is actually MAG_M5VADC.  This was fixed in EM2 and flight builds. 

;Note: These telemetry item labels match what is in the GSEOS .ctm file. They
; are derived from the MAVEN MAG user guide but have relabeled items when there
; are individual data items within one word (e.g. instead of MAG_DIG_HK07 we
; have the 8 bits for MAG_CNT_LLE and 8 bits for MAG_CNT_ULE). 

;NB: The data coming out of the MAVEN MAG is big endian (most significant byte
; written first) whereas most PCs and MACs are little endian. The software is
; set to deal with being used on either type of machine but has had the most
; usage on my Windows XP, Intel-chip machine.      

;;;;;;;;;;;;;;;;;
;Used procedures;
;;;;;;;;;;;;;;;;;
; bittest.pro
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;History and Changes notes;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
; v7b: Updated comments and default data_file keyword
; v7: Now handles 256 Hz mode data, so three data types.
; v6: Changed the code logic to do parsing in place as arrays instead of for
;     loops
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;
;Switch data types;
;;;;;;;;;;;;;;;;;;;

;Note: This is the place in the logic where we will need to set up code
; branches to deal with multiple data types (e.g. science data, engineering,
; etc.).  At the moment we have only "raw", aka straight out of the MISG, aka
; the silver box, "spacecraft" which means the flight software header and
; footer have been added, and "High" which is 256Hz mode. 

if keyword_set(spacecraft) then mode='SC' else $
  if keyword_set(high) then     mode='High' else $
                                mode='Normal'

;;;;;;;;;;;;;;
;File loading;
;;;;;;;;;;;;;;

if keyword_set(data_directory) NE 1 then $
  data_directory='../../../../Volumes/Tesman_WD/TerrestrialSchumann/';'C:\Research\MAVEN\MAVEN_Data\MV_EM2\6Jul2011_EM2_Linearity\'

if keyword_set(data_file) NE 1 then $
  data_file='misg_inst_msg.dat'
  
input_file=data_directory+data_file+'.bin'
openr,lun,input_file,/get_lun

;;;;;;;;;;;;;;;;;;;;;;;
;Finding the file size;
;;;;;;;;;;;;;;;;;;;;;;;

;Note: There are 262 (131 words) bytes in normal MAG packets.  If 
; the spacecraft header has been included there are an additional 14 bytes 
; for a total of 276. In the 256 Hz mode, there are 1606 bytes.

if mode EQ 'Normal' then begin
  bytecount=262
  rate=32
endif
if mode EQ 'SC' then begin
  bytecount=276
  rate=32
endif
if mode EQ 'High' then begin
  bytecount=1606
  rate=256
endif

file_info=fstat(lun)
num_packets=(file_info.size)/bytecount

;num_packets=1

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Reading the total data in;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

buff={rawbinary:bytarr(bytecount, num_packets)}
readu, lun, buff
input=buff.rawbinary

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Extracting individual telemtry item;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Message ID
MAG_MSG_ID=strtrim(string(input[0,*],'(z)'),2)+$
             strtrim(string(input[1,*],'(z)'),2)

;Synch words
MAG_SYNC=strtrim(string(input[2,*],'(z)'),2)+$
           strtrim(string(input[3,*],'(z)'),2)+$
           strtrim(string(input[4,*],'(z)'),2)+$
           strtrim(string(input[5,*],'(z)'),2)
           
;Decom ID
MAG_DECOMID=strtrim(string(input[6,*],'(z)'),2)

;Command counter
;Byte array
MAG_CMDCNT=reform(input[7,*])

;Frame counter
;Unsigned 16 bit integer array
MAG_FRM_CNT=swap_endian(fix(reform(input[8:9,*]), 0, num_packets,  $
                        type=12), /SWAP_IF_LITTLE_ENDIAN)
                        
;Time F0, F1, F2, F3
; 4 words
;NB: In the first verion of the FPGA (which is in EM#1) time words F1 and F3
  ;were switched incorrectly
MAG_TIME_F0=swap_endian(fix(reform(input[10:11,*]), 0, num_packets,  $
                        type=12), /SWAP_IF_LITTLE_ENDIAN)
MAG_TIME_F1=swap_endian(fix(reform(input[12:13,*]), 0, num_packets,  $
                        type=12), /SWAP_IF_LITTLE_ENDIAN)
MAG_TIME_F2=swap_endian(fix(reform(input[14:15,*]), 0, num_packets,  $
                        type=12), /SWAP_IF_LITTLE_ENDIAN)
MAG_TIME_F3=swap_endian(fix(reform(input[16:17,*]), 0, num_packets,  $
                        type=12), /SWAP_IF_LITTLE_ENDIAN)
             
;Mag status                        
MAG_FPGA_VER=(bittest(reform(input[18,*]),8)*32) + $
             (bittest(reform(input[18,*]),7)*16) + $
             (bittest(reform(input[18,*]),6)*8) + $
             (bittest(reform(input[18,*]),5)*4) + $
             (bittest(reform(input[18,*]),4)*2) + $
             (bittest(reform(input[18,*]),3))                        
                        
MAG_PCBNUM=(bittest(reform(input[18,*]),2)*8) + $
           (bittest(reform(input[18,*]),1)*4) + $
           (bittest(reform(input[19,*]),8)*2) + $
           (bittest(reform(input[19,*]),7)) 
           
MAG_DRIVE=(bittest(reform(input[19,*]),6)*2) + $
          (bittest(reform(input[19,*]),5))
          
MAG_CAL=(bittest(reform(input[19,*]),4))

MAG_RANGE=(bittest(reform(input[19,*]),3))

MAG_RNGSTAT=(bittest(reform(input[19,*]),2)*2) + $
            (bittest(reform(input[19,*]),1)) 
            
;Analog housekeeping
; 16 words
; All signed integers

MAG_XTEST=swap_endian(fix(reform(input[20:21,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)
MAG_YTEST=swap_endian(fix(reform(input[22:23,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)
MAG_ZTEST=swap_endian(fix(reform(input[24:25,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)
MAG_RTEST=swap_endian(fix(reform(input[26:27,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)
MAG_VCALMON=swap_endian(fix(reform(input[28:29,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)
MAG_P82VMON=swap_endian(fix(reform(input[30:31,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)
MAG_M82VMON=swap_endian(fix(reform(input[32:33,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)
MAG_SNSRTEMP=swap_endian(fix(reform(input[34:35,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)
MAG_PCBTEMP=swap_endian(fix(reform(input[36:37,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)
MAG_P13VMON=swap_endian(fix(reform(input[38:39,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)
MAG_M13VMON=swap_endian(fix(reform(input[40:41,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)
MAG_P114VREF=swap_endian(fix(reform(input[42:43,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)
MAG_P25VDIG=swap_endian(fix(reform(input[44:45,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)
MAG_P33VDIG=swap_endian(fix(reform(input[46:47,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)
MAG_P5VADC=swap_endian(fix(reform(input[48:49,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)
MAG_M5VADC=swap_endian(fix(reform(input[50:51,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)
                        
;Digital housekeeping
  ; 8 words
;Mostly byte arrays
MAG_TESTBUS=(bittest(reform(input[52,*]),8)*8) + $
            (bittest(reform(input[52,*]),7)*4) + $
            (bittest(reform(input[52,*]),6)*2) + $
            (bittest(reform(input[52,*]),5))
            
MAG_DIGXTRA=(bittest(reform(input[52,*]),4)*8) + $
            (bittest(reform(input[52,*]),3)*4) + $
            (bittest(reform(input[52,*]),2)*2) + $
            (bittest(reform(input[52,*]),1))
            
MAG_RGUPDAT=(bittest(reform(input[53,*]),8))
MAG_DIGPPS=(bittest(reform(input[53,*]),7))
MAG_TIMEHI=(bittest(reform(input[53,*]),6))
MAG_TIMEMID=(bittest(reform(input[53,*]),5))
MAG_TIMELOW=(bittest(reform(input[53,*]),4))
MAG_CMDRCD=(bittest(reform(input[53,*]),3))
MAG_PARERR=(bittest(reform(input[53,*]),2))
MAG_STOPERR=(bittest(reform(input[53,*]),1))

;Signed integer
MAG_DIGHK01=swap_endian(fix(reform(input[54:55,*]), 0, num_packets,  $
                        type=2), /SWAP_IF_LITTLE_ENDIAN)

;Command Reject Counter
MAG_CMDRJCT=reform(input[56,*])
;Last Command Op code
MAG_LSTRJCT=reform(input[57,*])
MAG_R0_HI=reform(input[58,*])
MAG_R1_LO=reform(input[59,*])
MAG_R1_HI=reform(input[60,*])                        
MAG_R3_LO=reform(input[61,*])
MAG_LLE=reform(input[62,*])
MAG_ULE=reform(input[63,*])
MAG_NUMPKT=reform(input[64,*])
MAG_CNT_PKT=reform(input[65,*])
MAG_CNT_ULE=reform(input[66,*])
MAG_CNT_LLE=reform(input[67,*])

;Making subscripts for the mag science vectors since they rotate through the
; axes.  Two bytes per mag science vector hence each axis comes back every 6
; subscripts and there are datarate * 2 subscripts per axis.
subs=intarr(rate*2)
i=0
for j=0, (n_elements(subs)/2)-1 do begin
  subs[i]=68+(j*6)
  subs[i+1]=69+(j*6)
  i=i+2
endfor

MAG_BSCI_X=swap_endian(fix(input[subs,*],0, num_packets*rate, type=2),$
            /swap_if_little_endian)
MAG_BSCI_Y=swap_endian(fix(input[subs+2,*],0, num_packets*rate, type=2),$
            /swap_if_little_endian) 
MAG_BSCI_Z=swap_endian(fix(input[subs+4,*],0, num_packets*rate, type=2),$
            /swap_if_little_endian)

;MAG_CHKSUM
MAG_CHKSUM=swap_endian(fix(reform(input[bytecount-2:bytecount-1,*]), 0, $
                      num_packets, type=12), /SWAP_IF_LITTLE_ENDIAN)

;stop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Saving IDL save file of all variables;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
input_file=data_directory+data_file
save, MAG_MSG_ID, MAG_SYNC, MAG_DECOMID, MAG_CMDCNT, MAG_FRM_CNT, MAG_TIME_F0,$
      MAG_TIME_F1, MAG_TIME_F2, MAG_TIME_F3, MAG_FPGA_VER, MAG_PCBNUM, $
      MAG_DRIVE, MAG_CAL, MAG_RANGE, MAG_RNGSTAT, MAG_XTEST, MAG_YTEST, $ 
      MAG_ZTEST, MAG_RTEST, MAG_VCALMON, MAG_P82VMON, MAG_M82VMON, $
      MAG_SNSRTEMP, MAG_PCBTEMP, MAG_P13VMON, MAG_M13VMON, MAG_P114VREF, $
      MAG_P25VDIG, MAG_P33VDIG, MAG_P5VADC, MAG_M5VADC, MAG_TESTBUS, $
      MAG_DIGXTRA, MAG_RGUPDAT, MAG_DIGPPS, MAG_TIMEHI, MAG_TIMEMID, $
      MAG_TIMELOW, MAG_CMDRCD, MAG_PARERR, MAG_STOPERR, MAG_DIGHK01, $
      MAG_CMDRJCT, MAG_LSTRJCT, MAG_R0_HI, MAG_R1_LO, MAG_R1_HI, MAG_R3_LO, $
      MAG_LLE, MAG_ULE, MAG_NUMPKT, MAG_CNT_PKT, MAG_CNT_ULE, MAG_CNT_LLE, $
      MAG_BSCI_X, MAG_BSCI_Y, MAG_BSCI_Z, MAG_CHKSUM, filename=input_file+'.sav'

end







                                                                                   