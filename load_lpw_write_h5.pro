;PLEASE RUN THIS WHILE IN THE h5 DIRECTORY OR ADJUST DIRECTORIES WITHIN CODE
;THE MAVEN PFP INSTALL SETUP A DIRECTORY AND I DON'T WANT TO MESS IT UP 
;SO I AM NOT CHANGING ANYTHING :)

pro load_lpw_write_h5
;day 0 is oct 10, 2014
for day=1089,1119 do begin
  print, day
  case 1 of
    (day ge 0) and (day le 21): begin
      year='2014'
      month='10'
      dd=strtrim(string(day+10),2)
    end
    (day ge 22) and (day le 51): begin
      year='2014'
      month='11'
      dd=strtrim(string(day-21),2)
      if day-21 lt 10 then begin
          dd='0'+strtrim(string(day-21),2)
      endif
    end
    (day ge 52) and (day le 82): begin
      year='2014'
      month='12'
      dd=strtrim(string(day-51),2)
      if day-51 lt 10 then begin
        dd='0'+dd
      endif
     end
     (day ge 83) and (day le 113): begin
       year='2015'
       month='01'
       dd=strtrim(string(day-82),2)
       if day-82 lt 10 then begin
        dd='0'+dd
       endif
      end
      
      (day ge 114) and (day le 141): begin
        year='2015'
        month='02'
        dd=strtrim(string(day-113),2)
        if day-113 lt 10 then begin
          dd='0'+dd
        endif
      end
      
      
      (day ge 142) and (day le 172): begin
        year='2015'
        month='03'
        dd=strtrim(string(day-141),2)
        if day-141 lt 10 then begin
          dd='0'+dd
        endif
      end
      (day ge 173) and (day le 202): begin
        year='2015'
        month='04'
        dd=strtrim(string(day-172),2)
        if day-172 lt 10 then begin
          dd='0'+dd
        endif
      end
      (day ge 203) and (day le 233): begin
        year='2015'
        month='05'
        dd=strtrim(string(day-202),2)
        if day-202 lt 10 then begin
          dd='0'+dd
        endif
      end
      (day ge 234) and (day le 263): begin
        year='2015'
        month='06'
        dd=strtrim(string(day-233),2)
        if day-233 lt 10 then begin
          dd='0'+dd
        endif
      end
      (day ge 264) and (day le 294): begin
        year='2015'
        month='07'
        dd=strtrim(string(day-263),2)
        if day-263 lt 10 then begin
          dd='0'+dd
        endif
      end   
      (day ge 295) and (day le 324): begin
        year='2015'
        month='08'
        dd=strtrim(string(day-294),2)
        if day-294 lt 10 then begin
          dd='0'+dd
        endif
        end
        (day ge 325) and (day le 355): begin
          year='2015'
          month='09'
          dd=strtrim(string(day-324),2)
          if day-324 lt 10 then begin
            dd='0'+dd
          endif
          end
          (day ge 356) and (day le 386): begin
            year='2015'
            month='10'
            dd=strtrim(string(day-355),2)
            if day-355 lt 10 then begin
              dd='0'+dd
     
            endif
            end
            (day ge 387) and (day le 416): begin
              year='2015'
              month='11'
              dd=strtrim(string(day-386),2)
              if day-386 lt 10 then begin
                dd='0'+dd
                endif
                end
                (day ge 417) and (day le 447): begin
                  year='2015'
                  month='12'
                  dd=strtrim(string(day- 416),2)
                  if day-416 lt 10 then begin
                    dd='0'+dd
                    endif
                    end
                    (day ge 448) and (day le 478): begin
                      year='2016'
                      month='01'
                      dd=strtrim(string(day- 447),2)
                      if day-447 lt 10 then begin
                        dd='0'+dd
                        endif
                        end
                        (day ge 479) and (day le 507): begin
                          year='2016'
                          month='02'
                          dd=strtrim(string(day- 478),2)
                          if day-478 lt 10 then begin
                            dd='0'+dd
                            endif
                            end
                            (day ge 508) and (day le 538): begin
                              year='2016'
                              month='03'
                              dd=strtrim(string(day-507),2)
                              if day-507 lt 10 then begin
                                dd='0'+dd
                             
                              endif
             end
             (day ge 539) and (day le 568): begin
         year='2016'
         month='04'
         dd=strtrim(string(day-538),2)
         if day-538 lt 10 then begin
          dd='0'+dd
         endif
         end
         (day ge 569) and (day le 599): begin
          year='2016'
          month='05'
          dd=strtrim(string(day-568),2)
          if day-568 lt 10 then begin
            dd='0'+dd
            
          endif
      end
      (day ge 600) and (day le 629): begin
        year='2016'
        month='06'
        dd=strtrim(string(day-599),2)
        if day-599 lt 10 then begin
          dd='0'+dd
        endif
        end
      (day ge 630) and (day le 660): begin
        year='2016'
        month='07'
        dd=strtrim(string(day-629),2)
        if day-629 lt 10 then begin
          dd='0'+dd
        endif
        end
        (day ge 661) and (day le 691): begin
          year='2016'
          month='08'
          dd=strtrim(string(day-660),2)
          if day-660 lt 10 then begin
            dd='0'+dd
          endif
          end
          (day ge 692) and (day le 721): begin
            year='2016'
            month='09'
            dd=strtrim(string(day-691),2)
            if day-691 lt 10 then begin
              dd='0'+dd
            endif
      end
      (day ge 722) and (day le 752): begin
        year='2016'
        month='10'
        dd=strtrim(string(day-721),2)
        if day-721 lt 10 then begin
          dd='0'+dd
        endif
      end
      (day ge 753) and (day le 782): begin
        year='2016'
        month='11'
        dd=strtrim(string(day-752),2)
        if day-752 lt 10 then begin
          dd='0'+dd
        endif
      end
      (day ge 783) and (day le 813): begin
      year='2016'
      month='12'
      dd=strtrim(string(day-782),2)
      if day-782 lt 10 then begin
        dd='0'+dd
      endif
    end
    (day ge 814) and (day le 844): begin
      year='2017'
      month='01'
      dd=strtrim(string(day-813),2)
      if day-813 lt 10 then begin
        dd='0'+dd
      endif
    end
    (day ge 845) and (day le 874): begin
      year='2017'
      month='02'
      dd=strtrim(string(day-844),2)
      if day-844 lt 10 then begin
        dd='0'+dd
      endif
    end
    (day ge 875) and (day le 905): begin
      year='2017'
      month='03'
      dd=strtrim(string(day-874),2)
      if day-874 lt 10 then begin
        dd='0'+dd
      endif
    end
    (day ge 906) and (day le 935): begin
      year='2017'
      month='04'
      dd=strtrim(string(day-905),2)
      if day-905 lt 10 then begin
        dd='0'+dd
      endif
    end
    (day ge 936) and (day le 966): begin
      year='2017'
      month='05'
      dd=strtrim(string(day-935),2)
      if day-935 lt 10 then begin
        dd='0'+dd
      endif
    end
    (day ge 967) and (day le 996): begin
      year='2017'
      month='06'
      dd=strtrim(string(day-966),2)
      if day-966 lt 10 then begin
        dd='0'+dd
      endif
    end
        (day ge 997) and (day le 1027): begin
      year='2017'
      month='07'
      dd=strtrim(string(day-996),2)
      if day-996 lt 10 then begin dd='0'+dd
      endif
      end
      
      
      (day ge 1028) and (day le 1057): begin
        year='2017'
        month='08'
        dd=strtrim(string(day-1027),2)
        if day-1027 lt 10 then begin dd='0'+dd
        endif
        end
        
        (day ge 1058) and (day le 1088): begin
          year='2017'
          month='09'
          dd=strtrim(string(day-1057),2)
          if day-1057 lt 10 then begin dd='0'+dd
          endif
          end
          
          (day ge 1089) and (day le 1119):begin
          year='2017'
          month='10'
          dd=strtrim(string(day-1088),2)
          if day-1088 lt 10 then begin dd='0'+dd
          endif
          end
          
          (day ge 1120) and (day le 1149): begin
          year='2017'
          month='11'
          dd=strtrim(string(day-1118),2)
          if day-1119 lt 10 then begin dd='0'+dd
          endif
          end
          
          (day ge 1150) and (day le 1180): begin
          year='2017'
          month='12'
          dd=strtrim(string(day-1149),2)
          if day-1149 lt 10 then begin dd='0'+dd
          endif
          end
          
          
  endcase
  
  lookupdate=year+'-'+month+'-'+dd
file='/mvn_lpw_l2_lpnt_'+year+month+dd
  filename='mvn_lpw_l2_lpnt_'+year+month+dd+'.h5'


mvn_lpw_cdf_read,lookupdate,vars='lpnt'

t=file_search('/Users/tesman/Desktop/MAVEN/maven/data/sci/lpw/l2/'+year+'/'+month+file+'_v01_r03.cdf')
if t eq '' then begin
  t2=file_search('/Users/tesman/Desktop/MAVEN/maven/data/sci/lpw/l2/'+year+'/'+month+file+'_v03_r01.cdf')
  if t2 eq '' then begin
      t19=file_search('/Users/tesman/Desktop/MAVEN/maven/data/sci/lpw/l2/'+year+'/'+month+file+'_v07_r02.cdf')
          if t19 eq'' then begin
      t20=file_search('/Users/tesman/Desktop/MAVEN/maven/data/sci/lpw/l2/'+year+'/'+month+file+'_v03_r02.cdf')
  if t20 eq'' then begin
      t21=file_search('/Users/tesman/Desktop/MAVEN/maven/data/sci/lpw/l2/'+year+'/'+month+file+'_v03_r03.cdf')
      if t21 eq'' then begin
      t22=file_search('/Users/tesman/Desktop/MAVEN/maven/data/sci/lpw/l2/'+year+'/'+month+file+'_v03_r04.cdf')                               
                                    
                                  
     if t22 eq '' then begin 
     print,'Continuing to next day'
     continue
     endif
     endif
     endif
     endif
     endif
endif

;Get the data!
get_data,'mvn_lpw_lp_ne_l2',data=dataNe
get_data,'mvn_lpw_lp_te_l2',data=dataTe
get_data,'mvn_lpw_lp_vsc_l2',data=dataVsc
get_data,'mvn_lpw_lp_n_t_l2',data=datan_t

;dataOrb=mvn_orbit_num(time=datan_t.X(*))
dataOrb=CREATE_STRUCT('num',mvn_orbit_num(time=datan_t.X(*)),'tunix_peri',mvn_orbit_num(orbnum=round(mvn_orbit_num(time=datan_t.X(*)))))

;Create the h5 file
;filename='mvn_lpw_l2_lpnt_20150518.h5'
fileid=H5F_CREATE(filename)


datatypeIDNe=H5T_IDL_CREATE(dataNe)
datatypeIDTe=H5T_IDL_CREATE(dataTe)
datatypeIDVsc=H5T_IDL_CREATE(dataVsc)
datatypeIDn_t=H5T_IDL_CREATE(datan_t)
datatypeIDOrb=H5T_IDL_CREATE(dataOrb)

dataspaceID=H5S_CREATE_SIMPLE(1)

datasetIDNe=H5D_CREATE(fileID,'Ne',datatypeIDNe,dataspaceID)
datasetIDTe=H5D_CREATE(fileID,'Te',datatypeIDTe,dataspaceID)
datasetIDVsc=H5D_CREATE(fileID,'Vsc',datatypeIDVsc,dataspaceID)
datasetIDn_t=H5D_CREATE(fileID,'n_t',datatypeIDn_t,dataspaceID)
datasetIDOrb=H5D_CREATE(fileID,'Orb',datatypeIDOrb,dataspaceID)

H5D_WRITE,datasetIDn_t,datan_t
H5D_WRITE,datasetIDNe,dataNe
H5D_WRITE,datasetIDTe,dataTe
H5D_WRITE,datasetIDVsc,dataVsc
H5D_WRITE,datasetIDOrb,dataOrb


H5F_CLOSE,fileID
endfor
end
