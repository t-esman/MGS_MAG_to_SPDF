;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Purpose:
;Create h5 files out of MGS mag .sts files - CURRENTLY ONLY GOES TO .SAV
;Processes ARE performed on the data
;These include:
;
;Translating Doy/hour/min/sec/msec to unix time
;
;Author:
; teresa.esman@nasa.gov
;
; Last edited: 11/3/2022
;
;FROM 2014:
;The MGS data comes in a few different forms:

;- detail, high time resolution
;- payload data
;- sunstate data
;
;Within the folder detail_pl_ss you will find:
;Based on the date of the data acquisition the data files can
;be found in folders: ab1, ab2, spo1, spo2 for m97 and m98
;
;
;- low time resolution
;- sunstate data (not included, since high time res is provided)
;- planetocentric data
;
;Based on the date of the data acquisition the data files can
;be found in folders: ab1, ab2, spo1, spo2 for m97 and m98
;for later dates: map1 through map8 and then...
;
;SEE TME_MGSCOMP.PRO, which brings mgs _detail.sts, _ss.sts,
;and _pc.sts files together, but 2022 TME is slightly confused
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro mgs_to_h5

  init_dir = 'Users/tesman/Desktop/TESMAN/MGS/Data'
  ;For a given day, establish the directory and filename
  ;as the default file setup has multiple different files
  ;depending on year/day
  for day=1,773 do begin   
    print,day
    case 1 of
      (day ge 1) and (day le 9): begin
        dirdet='\detail_pl_ss\ab1\'
        dirlow='\ab1\'
        fnstem='m98d00'+strtrim(string(day),2)
      end
      (day ge 10) and (day le 50): begin
        dirdet='\detail_pl_ss\ab1\'
        dirlow='\ab1\'
        fnstem='m98d0'+strtrim(string(day),2)
      end
      (day ge 51) and (day le 85): begin
        dirdet=''
        dirlow=''
        fnstem=''
      end
      (day ge 86) and (day le 99): begin
        dirdet='\detail_pl_ss\spo1\'
        dirlow='\spo1\'
        fnstem='m98d0'+strtrim(string(day),2)
      end

      (day ge 100) and (day le 119): begin
        dirdet='\detail_pl_ss\spo1\'
        dirlow='\spo1\'
        fnstem='m98d'+strtrim(string(day),2)
      end
      (day ge 120) and (day le 146): begin
        dirdet=''
        dirlow=''
        fnstem=''
      end
      (day ge 147) and (day le 260): begin
        dirdet='\detail_pl_ss\spo2\'
        dirlow='\spo2\'
        fnstem='m98d'+strtrim(string(day),2)
      end
      (day ge 261) and (day le 268): begin
        diredet=''
        dirlow=''
        fnstem=''
      end
      (day ge 269) and (day le 365): begin
        dirdet='\detail_pl_ss\ab2\'
        dirlow='\ab2\'
        fnstem='m98d'+strtrim(string(day),2)
      end
      (day ge 366) and (day le 474): begin
        dirdet='\detail_pl_ss\ab1\'
        dirlow='\ab1\'
        fnstem='m97d'+strtrim(string(day-109),2)
      end
      (day ge 475) and (day le 507):begin;626): begin
        dirdet='\detail_pl_ss\map1\'
        dirlow='\map1\'
        fnstem='m99d0'+strtrim(string(day-408),2)
      end
      (day ge 508) and (day le 560):begin
        dirdet='\detail_pl_ss\map1\'
        dirlow='\map1\'
        fnstem='m99d'+strtrim(string(day-408),2)
      end
      (day ge 561) and (day le 644): begin
        dirdet='\detail_pl_ss\map2\'
        dirlow='\map2\'
        fnstem='m99d'+strtrim(string(day-408),2)
      end
      (day ge 645) and (day le 728):begin
        dirdet='\detail_pl_ss\map3\'
        dirlow='\map3\'
        fnstem='m99d'+strtrim(string(day-408),2)
      end
      (day ge 729) and (day le 773):begin
        dirdet='\detail_pl_ss\map4\'
        dirlow='\map4\'
        fnstem='m99d'+strtrim(string(day-408),2)
      end
      (day ge 774) and (day le 782):begin
        dirdet='\detail_pl_ss\map4\'
        dirlow='\map4\'
        fnstem='m00d00'+strtrim(string(day-773),2)
      end
      (day ge 783) and (day le 812):begin
        dirdet='\detail_pl_ss\map4\'
        dirlow='\map4\'
        fnstem='m00d0'+strtrim(string(day-773),2)
      end

      (day ge 813) and (day le 872):begin
        dirdet='\detail_pl_ss\map5\'
        dirlow='\map5\'
        fnstem='m00d0'+strtrim(string(day-773),2)
      end
      (day ge 873) and (day le 896):begin
        dirdet='\detail_pl_ss\map5\'
        dirlow='\map5\'
        fnstem='m00d'+strtrim(string(day-773),2)
      end

      (day ge 897) and (day le 980):begin
        dirdet='\detail_pl_ss\map6\'
        dirlow='\map6\'
        fnstem='m00d'+strtrim(string(day-773),2)
      end

      (day ge 981) and (day le 1064):begin
        dirdet='\detail_pl_ss\map7\'
        dirlow='\map7\'
        fnstem='m00d'+strtrim(string(day-773),2)
      end
      (day ge 1065) and (day le 1139):begin
        dirdet='\detail_pl_ss\map8\'
        dirlow='\map8\'
        fnstem='m00d'+strtrim(string(day-773),2)
      end
      (day ge 1140) and (day le 1148):begin
        dirdet='\detail_pl_ss\map8\'
        dirlow='\map8\'
        fnstem='m01d00'+strtrim(string(day-1139),2)
      end
      (day ge 1149) and (day le 1170):begin
        dirdet='\detail_pl_ss\map8\'
        dirlow='\map8\'
        fnstem='m01d0'+strtrim(string(day-1139),2)
      end
    endcase

    fnh=init_dir+dirdet+fnstem+'_detail.sts'
    fnlss=init_dir+dirlow+fnstem+'_ss.sts'
    fnlpc=init_dir+dirlow+fnstem+'_pc.sts'
    print,fnh
    ;Make sure that the file exists
    t=file_search(fnh)
    if t eq '' then begin
      print, 'File not found. Continuing to next day'
      continue
    endif
; Load the high time resolution payload and sun-state data
    tme_pl_ss_sts_dataload,fnh,TIME_DOY_HIGH,TIME_HOUR_HIGH,TIME_MIN_HIGH,$
      TIME_SEC_HIGH,TIME_MSEC_HIGH,TIME_YEAR_HIGH_PL_SS,DECIMAL_DAY_HIGH,$ 
      OUTBOARD_B_J2000_RANGE_HIGH_PL_SS, OUTBOARD_B_J2000_X_HIGH_PL_SS, $
      OUTBOARD_B_J2000_Y_HIGH_PL_SS,OUTBOARD_B_J2000_Z_HIGH_PL_SS, OUTBOARD_B_PAYLOAD_RANGE_HIGH_PL_SS,$
      OUTBOARD_B_PAYLOAD_X_HIGH_PL_SS,OUTBOARD_B_PAYLOAD_Y_HIGH_PL_SS,$
      OUTBOARD_B_PAYLOAD_Z_HIGH_PL_SS,colNames_HIGH,cmdLine_HIGH,unitNames_HIGH,titleLine
; Load the low time resolution sunstate data and position data
    tme_ss_low_sts_dataload,fnlss,TIME_DOY_LOW,TIME_HOUR_LOW,TIME_MIN_LOW,$
      TIME_SEC_LOW,TIME_MSEC_LOW,TIME_YEAR_LOW,DECIMAL_DAY_LOW, $
      OUTBOARD_B_J2000_X_LOW_SS, OUTBOARD_B_J2000_Y_LOW_SS,OUTBOARD_B_J2000_Z_LOW_SS, $
      OUTBOARD_B_J2000_RANGE_LOW_SS, SC_POSITION_X_LOW_SS, SC_POSITION_Y_LOW_SS, $
      SC_POSITION_Z_LOW_SS, OUTBOARD_RMS_X_LOW_SS, OUTBOARD_RMS_Y_LOW_SS, $
      OUTBOARD_RMS_Z_LOW_SS, OUTBOARD_RMS_RANGE_LOW_SS, OUTBOARD_BSC_PAYLOAD_X_LOW_SS, $
      OUTBOARD_BSC_PAYLOAD_Y_LOW_SS, OUTBOARD_BSC_PAYLOAD_Z_LOW_SS, OUTBOARD_BSC_PAYLOAD_RANGE_LOW_SS,$
      OUTBOARD_BD_PAYLOAD_X_LOW_SS,OUTBOARD_BD_PAYLOAD_Y_LOW_SS,OUTBOARD_BD_PAYLOAD_Z_LOW_SS,$
      OUTBOARD_BD_PAYLOAD_RANGE_LOW_SS,SA_NEGY_CURRENT_LOW_SS,SA_POSY_CURRENT_LOW_SS,SA_OUTPUT_CURRENT_LOW_SS,$
      colNames_LOW,cmdLine_LOW_SS,unitNames_LOW
; Load the low time resolution planetocentric data and position data
    tme_pc_low_sts_dataload,fnlpc,OUTBOARD_B_J2000_X_LOW_PC, OUTBOARD_B_J2000_Y_LOW_PC,$
      OUTBOARD_B_J2000_Z_LOW_PC, OUTBOARD_B_J2000_RANGE_LOW_PC, SC_POSITION_X_LOW_PC,$
      SC_POSITION_Y_LOW_PC,SC_POSITION_Z_LOW_PC, OUTBOARD_RMS_X_LOW_PC, OUTBOARD_RMS_Y_LOW_PC, $
      OUTBOARD_RMS_Z_LOW_PC, OUTBOARD_RMS_RANGE_LOW_PC, OUTBOARD_BSC_PAYLOAD_X_LOW_PC, $
      OUTBOARD_BSC_PAYLOAD_Y_LOW_PC, OUTBOARD_BSC_PAYLOAD_Z_LOW_PC, OUTBOARD_BSC_PAYLOAD_RANGE_LOW_PC,$
      OUTBOARD_BD_PAYLOAD_X_LOW_PC,OUTBOARD_BD_PAYLOAD_Y_LOW_PC,OUTBOARD_BD_PAYLOAD_Z_LOW_PC,$
      OUTBOARD_BD_PAYLOAD_RANGE_LOW_PC,SA_NEGY_CURRENT_LOW_PC,SA_POSY_CURRENT_LOW_PC,SA_OUTPUT_CURRENT_LOW_PC,$
      cmdLine_LOW_PC
;Switch from 
    unix_time_low = make_array(n_elements(TIME_YEAR_LOW),/DOUBLE)
    for i = 0, n_elements(TIME_YEAR_LOW)-1 do begin
      unix_time_low(i) = dday_to_unix(TIME_YEAR_LOW(i), floor(DECIMAL_DAY_LOW(i)), $
        TIME_HOUR_LOW(i), TIME_MIN_LOW(i),TIME_SEC_LOW(i),TIME_MSEC_LOW(i))
    endfor

    unix_time_high = make_array(n_elements(TIME_YEAR_HIGH_PL_SS),/DOUBLE)
    for i =0, n_elements(TIME_YEAR_HIGH_PL_SS)-1 do begin
      unix_time_high(i) = dday_to_unix(TIME_YEAR_HIGH_PL_SS(i), $
        floor(DECIMAL_DAY_HIGH(i)), TIME_HOUR_HIGH(i), TIME_MIN_HIGH(i), TIME_SEC_HIGH(i),$
        TIME_MSEC_HIGH(i))
    endfor
    ;Why are there multiple points at same time? 
    ;There seems to be a single point that goes back to the start of the day? because this
    ;1 day file has a point from the next day... 
    ;in the 2014 files, why are dday and ddaylow the same size? but the first number is different
    ;what do i do for the 2014 files? why no interpolation? maybe because no unix time?
RADIUS_OF_MARS = 3389.5

  ALT_LOW = sqrt(SC_POSITION_X_LOW_SS^2+SC_POSITION_Y_LOW_SS^2+SC_POSITION_Z_LOW_SS^2)-RADIUS_OF_MARS
ALT_HIGH = interpol(ALT_LOW, UNIX_TIME_LOW, UNIX_TIME_HIGH)

    ;
    ;for i = 0,n_elements(dday)-1 do begin
    ;  time_unix(i) = dday_to_unix,year,dday,hour,minute,second,unix_time
    ;endfor
save,filename='/Users/tesman/Desktop/TESMAN/NPP_WORK/MGS/COMPILATION_FILES/'+fnstem+'.sav'

  endfor


end

;IDL> struct = {name:"coyote", age:25, rascal:1B, salary:200000D, girlfriends:FltArr(546)}
;To write a structure into an HDF5 file, you need to create compound data type. As with all HDF files, we first create a file identifier, since all communication with the file is done via the file identifier.
;
;IDL> filename = 'hdf5testfile.h5'
;IDL> fileID = H5F_CREATE(filename)
;Next, we create a datatype object by supplying the structure as an argument. This will indicate that we wish to create a compound data type, with the types determined from the fields of the structure.
;
;IDL> datatypeID = H5T_IDL_CREATE(struct)
;The next step is to create a simple (or, in this case, not so simple) data space. As an argument, we require the dimensions of the dataspace. In this case, with a single structure variable, the dimension is 1.
;
;IDL> dataspaceID = H5S_CREATE_SIMPLE(1)
;Now we can create the dataset at a specified location, given as the first argument in the function below. The second argument is the name of the dataset in the file, and the third and fourth arguments are the data type identifier and data space identifier, respectively.
;
;IDL> datasetID = H5D_CREATE(fileID, 'mydata', datatypeID, dataspaceID)
;Finally, we can write the structure into the file, and close the file.
;
;IDL> H5D_WRITE, datasetID, struct
;IDL> H5F_CLOSE, fileID
;
;
;It is much easier to read the data out of the file. We simple do this.
;
;IDL> s = H5_PARSE('hdf5testfile.h5', /READ_DATA)
;IDL> HELP, s.mydata._DATA, /STRUCTURE
;** Structure <25c8390>, 5 tags, length=2208, data length=2207, refs=2:
;NAME            STRING    'coyote'
;AGE             INT             25
;RASCAL          BYTE         1
;SALARY          DOUBLE           200000.00
;GIRLFRIENDS     FLOAT     Array[546]