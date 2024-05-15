pro jre_plotpanel, x1, y, x2, x3, x4, x5, x6, winnum=winnum, $
  _extra=extra_keywords

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Purpose;
;;;;;;;;;
;
;Do plots with multi-lined x-axis tick labels. So for example, one could plot
; Bx vs. decimal day and also have UTC plotted on the x-axis.
;
;;;;;;;;;;;;;;;;;
;Required Inputs;
;;;;;;;;;;;;;;;;;
;
; x1 = Time series data for the x axis of your plot
; y  = Time series data for the y axis of your plot
;
;;;;;;;;;;;;;;;;;
;Optional Inputs;
;;;;;;;;;;;;;;;;;
;
; x2-x6 = Time series data for the additional x axis tickmark labels. Each
;         additional label gets added to a new line.
; winnum = The window you want to plot to. If you don't enter this, IDL uses
;          the next unoccupied plot window (not the last active window since
;          that is actually window 10 since that was used as a dummy window).
; _extra = Any keyword that the normal idl procedure plot takes.
;
;;;;;;;;;;
;Examples;
;;;;;;;;;;
; Makes a plot of bx vs. dday with x ticklabels of dday and utc: 
;  jre_plotpanel, dday, bx, utc
;  
; Same as previous but with inputs using subscripts and specific
; call to plot to window 0:
;  jre_plotpanel, dday[s1:e1], bx[s1:e1], utc[s1:e1], winnum=0
;   
; Makes plots with lots of x ticklabels:
;  jre_plotpanel, dday, bx, utc, xposn, yposn, zposn, alt
;  
; Uses some keywords from plot:
;  jre_plotpanel, dday, bx, utc, /xlog, xrange=[303.4, 303.5], $
;     charsize=2.0
;
;;;;;;;;;;;;;;
;Dependencies;
;;;;;;;;;;;;;;
;
; None.
;
;;;;;;;;;;;;;;
;Known Issues;
;;;;;;;;;;;;;;
;
; *Uses window 10 for initial dummy plotting. If that window's in use it'll
;  get overwritten.
; *Only (and automatically) does plots with xstyle=1 (i.e. full width).
; *With xstyle=1 the last tickmark isn't usually labeled.
;
;;;;;;;;;;;;
;To-do list;
;;;;;;;;;;;;
;
; None.
;
;;;;;;;;
;Author;
;;;;;;;;
;
;Jared.R.Espley@nasa.gov
;
;;;;;;;;;
;Version;
;;;;;;;;;
;
;1.0 JRE: First version.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;initial plot get x1 default tick values
window, 10
plot, x1, y, /nodata, /noerase, xtick_get=x1ticks, xstyle=1, $
  _extra=extra_keywords
wdelete, 10

;make sure the where function works properly
x1=double(x1)

;getting the corresponding index of those tickmark values 
nx1ticks=n_elements(x1ticks)
ticksindex=dblarr(nx1ticks)
for i=0, n_elements(x1ticks)-1 do begin
  temp=where(x1 GE x1ticks[i])
  ;need check for -1
  ticksindex[i]=temp[0]
endfor

;Making the combined tickmarks
if n_elements(x2) NE 0 then $
  combinedticks=strtrim(string(x1ticks),2)+'!C'+$
                strtrim(string(x2[ticksindex]),2)
if n_elements(x3) NE 0 then $
  combinedticks=strtrim(string(x1ticks),2)+'!C'+$
                strtrim(string(x2[ticksindex]),2)+'!C'+$
                strtrim(string(x3[ticksindex]),2)                 
if n_elements(x4) NE 0 then $
  combinedticks=strtrim(string(x1ticks),2)+'!C'+$
                strtrim(string(x2[ticksindex]),2)+'!C'+$
                strtrim(string(x3[ticksindex]),2)+'!C'+$
                strtrim(string(x4[ticksindex]),2)
if n_elements(x5) NE 0 then $
  combinedticks=strtrim(string(x1ticks),2)+'!C'+$
                strtrim(string(x2[ticksindex]),2)+'!C'+$
                strtrim(string(x3[ticksindex]),2)+'!C'+$
                strtrim(string(x4[ticksindex]),2)+'!C'+$
                strtrim(string(x3[ticksindex]),2)
if n_elements(x6) NE 0 then $
  combinedticks=strtrim(string(x1ticks),2)+'!C'+$
                strtrim(string(x2[ticksindex]),2)+'!C'+$
                strtrim(string(x3[ticksindex]),2)+'!C'+$
                strtrim(string(x4[ticksindex]),2)+'!C'+$
                strtrim(string(x5[ticksindex]),2)+'!C'+$
                strtrim(string(x6[ticksindex]),2)

;setting focus to the desired window number if any
if n_elements(winnum) NE 0 then wset, winnum

;doing actual plotting
plot, x1, y, xtickname=combinedticks, _extra=extra_keywords, xstyle=1

end