;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Purpose:
; tme_mgsrate finds the rate (samples/sec) and finds the intervals at 
; which the data was taken at a specified rate
; Inputs:
; rate_limit - number to limit the rate by
; dday - decimal day time of the data
; ineq - how you want to limit the rate (e.g. ge, lt)
; 
;Returns: time series of the rate
;
;Author: Teresa Esman
;teresa.esman@nasa.gov,tme4ze@virginia.edu
;
;last edited:11/9/2022
;8/1/14
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function tme_determine_sample_rate,rate_limit,dday,ineq
;location and rate
;stem=strcompress('_rate'+ineq+strtrim(string(rate_limit),2),/remove_all)
;if keyword_set(rate_limit1) eq 1 then stem=strcompress('_rate'+ineq+strtrim(string(rate_limit1),2)+strtrim(string(rate_limit),2),/remove_all)

n_elem=size(dday,/N_ELEMENTS)

;rate=dblarr(n_elem-1)

 ;find the rate
 rate=(1d)/((24d)*(3600d)*(dday[1:-1]-dday[0:-2])) ;find the rate

case 1 of ;find where the altitude is under specified conditions
;
(ineq eq 'le'):begin
  r=where(rate le rate_limit,tct)       
end
;  
  (ineq eq 'lt'):begin
  r=where(rate lt rate_limit,tct)
  end
  
  (ineq eq 'gt'):begin
  r=where(rate gt rate_limit,tct)
  end
  
  (ineq eq 'eq'):begin
   r=where(rate eq rate_limit,tct)
   end
   
   (ineq eq 'ge'):begin
   r=where(rate ge rate_limit,tct)
   end
   (ineq eq 'ne'):begin
   r=where(rate ne rate_limit,tct)
   end
   (ineq eq 'gt and lt'):begin
   r=where(rate gt rate_limit1 and rate lt rate_limit,tct)
   end
   (ineq eq 'lt and gt'):begin
   r=where(rate lt rate_limit1 and rate gt rate_limit,tct)
   end
   (ineq eq 'ge and le'):begin
   r=where(rate ge rate_limit1 and rate le rate_limit,tct)
   end
   (ineq eq 'le and ge'):begin
   r=where(rate le rate_limit1 and rate ge rate_limit,tct)
   end
   (ineq eq 'le and gt'):begin
   r=where(rate le rate_limit1 and rate gt rate_limit,tct)
   end
   (ineq eq 'lt and ge'):begin
   r=where(rate lt rate_limit1 and rate ge rate_limit,tct)
   end
endcase

if tct eq 0 then begin ;check if there is no altitude under the given conditions
print,'There are no data point at 32 samples/sec'   
endif

return,r
end
