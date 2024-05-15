pro low_alt_FullDataset_inspection,total_hours,night_hours,day_hours,term_hours,sza_value,layer_hours,events_by_layer

;layer0_count=0
;layer1_count = 0
;layer2_count = 0
;layer3_count = 0
;layer4_count = 0
;layer5_count = 0
;layer6_count = 0
;layer7_count = 0

night_count=0
term_count=0
day_count=0
total_count=0
sza_value=[]

count = []
totalcount=[]
for j=2014,2019 do begin
  

for i = 1,12 do begin
  
  year=strtrim(string(j),2)
  
  if i lt 10 then begin
        month='0'+strtrim(string(i),2)
      endif else begin
        month=strtrim(string(i),2)
      endelse
      
      fileloc='../../../../Volumes/ExtremeSSD/MAVEN/LowAlt/lt_200/'+year+'/mvn_mag_l2_lt_200_full_'+year+month+'_pl.sav'

      if file_exist(fileloc) then begin
      
      
 restore,filename=fileloc



;Day vs Night vs Term

night = where(sza * (180./!pi) gt 110)
term = where(sza * (180./!pi) le 110 and sza * (180./!pi) ge 80)
day = where(sza * (180./!pi) lt 80)

;Layer0_0   = where(altitude lt 130)
;Layer1_130 = where(altitude lt 140 and altitude ge 130)
;Layer2_140 = where(altitude lt 150 and altitude ge 140)
;Layer3_150 = where(altitude lt 160 and altitude ge 150)
;Layer4_160 = where(altitude lt 170 and altitude ge 160)
;Layer5_170 = where(altitude lt 180 and altitude ge 170)
;Layer6_180 = where(altitude lt 190 and altitude ge 180)
;Layer7_190 = where(altitude lt 200 and altitude ge 190)

;
;sza_value = [sza_value,sza]
;Layer0_count = Layer0_count + N_ELEMENTS(Layer0_0)
;Layer1_count = Layer1_count + N_ELEMENTS(Layer1_130)
;Layer2_count = Layer2_count + N_ELEMENTS(Layer2_140)
;Layer3_count = Layer3_count + N_ELEMENTs(Layer3_150)
;Layer4_count = Layer4_count + N_ELEMENTS(Layer4_160)
;Layer5_count = Layer5_count + N_ELEMENTS(Layer5_170)
;Layer6_count = Layer6_count + N_ELEMENTS(Layer6_180)
;Layer7_count = Layer7_count + N_ELEMENTS(Layer7_190)
;
;
;count = N_ELEMENTS(BMAG)
;totalcount = [totalcount,count]

;
night_count=night_count+N_ELEMENTS(night)
term_count=term_count+N_ELEMENTS(term)
day_count=day_count+N_ELEMENTS(day)
total_count=total_count+N_ELEMENTS(sza)
endif
endfor
endfor
timegoal = total(total_count)
print,timegoal/32./60./60.
;print,'Layer 0 - 0 -130'
;print,Layer0_count/32./60./60.
;print,'Layer 1 - 130-140'
;print,Layer1_count/32./60./60.
;print,'Layer 2 - 140-150'
;print,Layer2_count/32./60./60.
;print,'Layer 3 - 150-160'
;print,Layer3_count/32./60./60.
;print,'Layer 4 - 160-170'
;print,Layer4_count/32./60./60.
;print,'Layer 5 - 170-180'
;print,Layer5_count/32./60./60.
;print,'Layer 6 - 180-190'
;print,Layer6_count/32./60./60.
;print,'Layer 7 - 190-200'
;print,Layer7_count/32./60./60.
;print,'total'
;print,(layer0_count+layer1_count+layer2_count+layer3_count+layer4_count+layer5_count+layer6_count+layer7_count)/32./60./60.
;
;
;layer_hours = [Layer0_count/32./60./60.,Layer1_count/32./60./60.,Layer2_count/32./60./60.,Layer3_count/32./60./60.,Layer4_count/32./60./60.,Layer5_count/32./60./60.,Layer6_count/32./60./60.,Layer7_count/32./60./60.]
;events_by_layer = [0, 2.,14.,10.,10.,6.,4.,6.]
;
;


print,'Night Hours'
night_hours=night_count/32./60./60.
print,night_hours
print,'Term Hours'
term_hours=term_count/32./60./60.
print,term_hours
print,'Day Hours'
day_hours=day_count/32./60./60.
print,day_hours
print,'Total Hours'
total_hours=total_count/32./60./60.
print,total_hours
;save,filename='lowalt_datadistribution.sav',night_hours,term_hours,day_hours,total_hours
;p=errorplot(events_by_layer/52./(layer_hours/1124.35),layers,yerror,sym='*',linestyle=6)
end