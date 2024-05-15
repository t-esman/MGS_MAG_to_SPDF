pro jre_plot, $
   x1, y1, xtitle1=xtitle1,ytitle1=ytitle1,startsub1=startsub1,endsub1=endsub1,$
   x2, y2, xtitle2=xtitle2,ytitle2=ytitle2,startsub2=startsub2,endsub2=endsub2,$
   x3, y3, xtitle3=xtitle3,ytitle3=ytitle3,startsub3=startsub3,endsub3=endsub3,$
   x4, y4, xtitle4=xtitle4,ytitle4=ytitle4,startsub4=startsub4,endsub4=endsub4,$
   x5, y5, xtitle5=xtitle5,ytitle5=ytitle5,startsub5=startsub5,endsub5=endsub5,$
   x6, y6, xtitle6=xtitle6,ytitle6=ytitle6,startsub6=startsub6,endsub6=endsub6,$
   x7, y7, xtitle7=xtitle7,ytitle7=ytitle7,startsub7=startsub7,endsub7=endsub7,$
   x8, y8, xtitle8=xtitle8,ytitle8=ytitle8,startsub8=startsub8,endsub8=endsub8,$
   rstart=rstart, rend=rend, label1=label1, mag=mag, $
   onetime=onetime, zeroline=zeroline, savedir=savedir, $
   command=command, standardwin=standardwin, _extra=extra_keywords
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Purpose;
;;;;;;;;;
;
; Plot up to 8 time series on a window and be able to zoom and scroll through
; them.
; 
;;;;;;;;;;;;;;;;;
;Required Inputs;
;;;;;;;;;;;;;;;;;
;
; x1, y1 = Time series array of data (y1) and its accompanying x axis array (x1).
;          Note that x1 and y1 must have the same number of elements.
;
;;;;;;;;;;;;;;;;;
;Optional Inputs;
;;;;;;;;;;;;;;;;;
;
; x2-x8, y2-y8 = Matched sets of time series arrays like x1 and x2.
;                Note that each set must have the same numbers of elements but
;                that each set can have its own independent size, span, and rate.
;                
; xtitle1-8, ytitle1-8 = String labels for each of the input arrays.
; 
; label1 = Time series that matches x1 that can be used as an additional label,
;         i.e. on the plot title. For example if x1 is decimal day, then 
;         label1 might be UTC. This label will be appended as a second x 
;         tickmark label. Label1 needs to have exactly the same number
;         of elements as x1. Note that at the moment only the first time
;         series accepts a label and will have the dual tickmarks.
;  
; rstart, rend = Starting subscripts for x1, y1 pair. Use this if you want to
;                start the plot someplace other than at the beginning and end.
;                You could use a previously saved pair of subscripts (e.g.
;                startsub1 and endsub1). 
; 
; mag = Use /mag to have all ytitles set to 'nT'
; 
; onetime= Use /onetime to only have it cycle once and then quit
; 
; zeroline = Adds a dashed line at zero. Note that it is not compatible with 'm'.
; 
; command = String of a single letter that represents what should be done the first time
;           through the main loop. If used with the /onetime then this would be the only
;           command executed. For example command='f' would move forward. 
; 
; _extra = Inputs that are accepted by the plot procedure that you want to pass to all
;          panels. 
;
; savedir = Directory where you'd like .pngs saved of plots. Defaults to current
;           working directory.
;           
; standardwin = Set this keyword to have IDL use its standard sized window instead
;               of the comparitively large window jre_plot uses by default.
;
;;;;;;;;;;;;;;;;;;           
;Optional Outputs;
;;;;;;;;;;;;;;;;;;
;
; startsub1-8 = Starting subscripts of the x1-8, y1-8 sets as displayed when
;               when you quit the procedure.
;               
; endsub1-8 = End subscripts of the displayed plots when you quit.
; 
;;;;;;;;;; 
;Examples;
;;;;;;;;;;
;
; Note: Additional examples can be found in jre_plot_examples.pro
; 
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;Making some data to test;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
; You can load your own data but here's how to make some fake data:
; 
; n=10000               ;number of datapoints
; deltat=0.01            ;time interval between data - could be seconds
; alpha=5.
; ampsignal=10.
; ampnoise=10.
; bx=ampsignal*cos(alpha * (2.*!PI) * deltat * findgen(n)) + ampnoise*randomn(seed, n)
; dday=findgen(n)*deltat
; n=100
; deltat=1.
; density=ampsignal*cos(alpha * (2.*!PI) * deltat * findgen(n)) + ampnoise*randomn(seed, n)
; ddayden=findgen(n)*deltat
; 
; ;;;;;;;;;;;;;;;;;
; #1: Super simple;
; ;;;;;;;;;;;;;;;;;
; jre_plot, dday, bx
; 
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; #2: Times series with different cadences;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; jre_plot, dday, bx, ddayden, density, ytitle1='Bx (nT)', ytitle2='Density'
; 
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; #3: Picking an interval and then doing something with it with other code;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;The key is getting the subscripts out of selected interval to pass to your
; ; other code.
; jre_plot, dday, bx, startsub1=s1, endsub1=e1
; 
; ;User scrolls, picks an interal and then hits done to return to the command line.
; plot, dday[s1:e1], bx[s1:e1]
; bxnew=bx[s1:e1]*10. ;or any other more sosphicated analysis.
; ddaynew=dday[s1:e1]
; plot, ddaynew, bxnew
; 
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; #4 Resuming where you left off;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; jre_plot, dday, bx, startsub1=s1, endsub1=e1
; ;User does zooming, etc. and then quits.
; jre_plot, dday, bx, rstart=s1, rend=e1 ;Plot starts back where you left off.
; 
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; #5 Using label so you could add something like UTC to the tick labels;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; utc=dday ;obviously you'd actually want to calculate UTC
; jre_plot, dday, bx, /mag, label1=utc
; 
;;;;;;; 
;Usage; 
;;;;;;;
;
;'Type a single letter in the command window (no return needed).'
;'b = Move (b)ackward in the time series at the current zoom level.'
;'f = Move (f)orward in the time series at the current zoom level.'
;'m = Set the y-range of the plots (m)anually instead of letting IDL auto-range.'
;'o = Zoom (o)ut by one zoom level.'
;'p = Save the current (p)lot.'
;'q = (q)uit.'
;'r = (R)eset the zoom level.'
;'t = (T)ype the subscripts of the array to be displayed (e.g. set the zoom range manually).'
;'u = (U)ndo the last zoom or scroll forward or backward.'
;'x = Write to the IDL console the (x) variable value where clicked.'
;'z = (Z)oom in by clicking twice on the plot window.'
;
;;;;;;;;;;;;;;
;Dependencies;
;;;;;;;;;;;;;;
; 
; cgSnapshot.pro  : Saves plot window.
;   cgErrormsg.pro : Required for cgSnapshot.pro
;   cgRootname.pro : Required for csSnapshot.pro
; jre_plotpanel.pro: Does multi-lined tickmarks (e.g. decimal day and UTC).
;
;;;;;;;;;;;;;;
;Known Issues; 
;;;;;;;;;;;;;;
;
;
;;;;;;;;;;;;
;To-do list; 
;;;;;;;;;;;;
;
; *Update examples
; 
;Possible additions:
; *Add labels to panels beyond first one
; *Add zeroline oplot to the 'm' plotting
; 
;;;;;;;;; 
;Authors; 
;;;;;;;;;
; 
;Jared.R.Espley@nasa.gov 
; 
;;;;;;;;; 
;Version; 
;;;;;;;;;
;
;2.1  JRE: Stripped analysis tools out to keep jre_plot streamlined.
;          Changed stopping key to q to match mvn_mag_itplot.
;          Removed wait commands for old 8.2 IDL bug.
;          Removed label2 so back to just one panel with a label and made a
;            note to add additional labels properly if useful in a
;            future release.
;          Add label and extra keyword to 'm' plotting section.
;          Added standardwin keyword.
;2.0  JRE: Hacked to use label2 keyword to second panel second tick
;1.9  JRE: Added command keyword
;1.8  JRE: Changed to use jre_plotpanel (so multi-lined tickmarks available)
;1.7  JRE: Add auto-filename save and savedir keyword
;1.6  JRE: Updated to use jre_waveletplot.pro
;1.51 JRE: Fixed bug for oldstartsub for rstart with 'u' on first run
;1.5  JRE: Added _extras keyword
;1.4  JRE: Added /zeroline keyword.
;1.3  JRE: Adding the /onetime keyword.
;1.2  JRE: Use cgSnapshot instead of TVread for saving screencapture plots. This
;          allows the screencapture to work on my Windows 7 machine, on Gauss, 
;          and on Gina's Mac OS10 machine.
;1.12 JRE: Updated to default saving a png instead a of jpg
;1.11 JRE: Fixed typo in ytitle8
;1.1  JRE: Updated documentation.
;1.0  JRE: First release.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Help the user if they enter no keywords
keywordcheck=n_params()
if keywordcheck LE 0 then begin
  print, 'Wrong number of arguements. See source code documentation.'
  stop
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Initialization of variables;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

numtotal1=n_elements(x1)
numtotal2=n_elements(x2)
numtotal3=n_elements(x3)
numtotal4=n_elements(x4)
numtotal5=n_elements(x5)
numtotal6=n_elements(x6)
numtotal7=n_elements(x7)
numtotal8=n_elements(x8)

;Initial values of subscripts
if keyword_set(rstart) then startsub1=rstart else startsub1=0L
oldstartsub=startsub1
if keyword_set(rend) then endsub1=rend else endsub1=numtotal1-1L
oldendsub=endsub1

!p.multi=0
if keyword_set(x2) then !p.multi=[0,1,2]
if keyword_set(x3) then !p.multi=[0,1,3]
if keyword_set(x4) then !p.multi=[0,1,4]
if keyword_set(x5) then !p.multi=[0,1,5]
if keyword_set(x6) then !p.multi=[0,1,6]
if keyword_set(x7) then !p.multi=[0,1,7]
if keyword_set(x8) then !p.multi=[0,1,8]

if keyword_set(mag) then begin
  if keyword_set(ytitle1) NE 1 then ytitle1='nT'
  if keyword_set(ytitle2) NE 1 then ytitle2='nT'
  if keyword_set(ytitle3) NE 1 then ytitle3='nT'
  if keyword_set(ytitle4) NE 1 then ytitle4='nT'
  if keyword_set(ytitle5) NE 1 then ytitle5='nT'
  if keyword_set(ytitle6) NE 1 then ytitle6='nT'
  if keyword_set(ytitle7) NE 1 then ytitle7='nT'
  if keyword_set(ytitle8) NE 1 then ytitle8='nT'   
endif

if n_elements(label1) EQ 0L then begin
  labelpresent='n'
  label1=strarr(n_elements(x1))
endif else labelpresent='y'

domanualy=''
quitnow=0
if keyword_set(standardwin) then window, 0
if keyword_set(standardwin) NE 1 then begin
  windowsize=get_screen_size() 
  window, 0, xsize=windowsize[0]-0.1*windowsize[0], ysize=windowsize[1]-0.2*windowsize[1]
endif
!p.charsize=2.0
device, decompose=0 ;needed to make Windows colors right
loadct, 39
!p.background=255
!p.color=0

;;;;;;;;;;;
;Main loop;
;;;;;;;;;;;

firstcommanddone=''
if n_elements(command) EQ 0 then dozoom='' else dozoom=command
repeat begin

  ;;;;;;;;;;;;;;
  ;Error checks;
  ;;;;;;;;;;;;;;
  
  ;Error check: check for start subscript after end subscript
  if startsub1 GE endsub1 then begin
    startsub1=oldstartsub
    endsub1=oldendsub
    print, 'Starting point after ending point. Reusing previous values.'
  endif
  
  ;Error check: Don't try to have the subinterval go beyond the original
  if endsub1 GT numtotal1-1L or startsub1 LT 0L then begin
    endsub1=oldendsub
    startsub1=oldstartsub
    print, 'Invalid starting or ending points. Reusing previous values.'
  endif
  ;if startsub LT 0L then startsub1=0L

  ;;;;;;;;;;;;;;;;;;
  ;Plotting Section;
  ;;;;;;;;;;;;;;;;;;
  
  ;Set the window focus back to zero in case you've done an e.g. spectral plot
  ; in another window.
  wset, 0
  
  ;Adding inputted extra variable (e.g. UTC time) to the plot as title
  title=''
  if labelpresent EQ 'y' then begin
    if numtotal1 NE n_elements(label1) then $
      print, 'Warning label variable length not equal to xvar1 length.'+$
        'Label not likely to be correct.'
    title=strtrim(string(label1[startsub1]),2)+' to '+strtrim(string(label1[endsub1]),2)
  endif

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Figure out where the subscripts of the xvariables line up;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if keyword_set(x2) then begin
    startsub2=where(x2 GE x1[startsub1])
    startsub2=startsub2[0]
    endsub2=where(x2 GE x1[endsub1])
    endsub2=endsub2[0]
    if endsub2 EQ -1L then endsub2=numtotal2-1L
  endif
  if keyword_set(x3) then begin
    startsub3=where(x3 GE x1[startsub1])
    startsub3=startsub3[0]
    endsub3=where(x3 GE x1[endsub1])
    endsub3=endsub3[0]
    if endsub3 EQ -1L then endsub3=numtotal3-1L
  endif
  if keyword_set(x4) then begin
    startsub4=where(x4 GE x1[startsub1])
    startsub4=startsub4[0]
    endsub4=where(x4 GE x1[endsub1])
    endsub4=endsub4[0]
    if endsub4 EQ -1L then endsub4=numtotal4-1L
  endif
  if keyword_set(x5) then begin
    startsub5=where(x5 GE x1[startsub1])
    startsub5=startsub5[0]
    endsub5=where(x5 GE x1[endsub1])
    endsub5=endsub5[0]
    if endsub5 EQ -1L then endsub5=numtotal5-1L
  endif
  if keyword_set(x6) then begin
    startsub6=where(x6 GE x1[startsub1])
    startsub6=startsub6[0]
    endsub6=where(x6 GE x1[endsub1])
    endsub6=endsub6[0]
    if endsub6 EQ -1L then endsub6=numtotal6-1L
  endif
  if keyword_set(x7) then begin
    startsub7=where(x7 GE x1[startsub1])
    startsub7=startsub7[0]
    endsub7=where(x7 GE x1[endsub1])
    endsub7=endsub7[0]
    if endsub7 EQ -1L then endsub7=numtotal7-1L
  endif
  if keyword_set(x8) then begin
    startsub8=where(x8 GE x1[startsub1])
    startsub8=startsub8[0]
    endsub8=where(x8 GE x1[endsub1])
    endsub8=endsub8[0]
    if endsub8 EQ -1L then endsub8=numtotal8-1L
  endif
  
  ;;;;;;;;;;;;;;;;;;;;;;;;
  ;Figure out plot ranges;
  ;;;;;;;;;;;;;;;;;;;;;;;;
  
  ;We use the xrange1 and xrange2 to set the plot range for all panels so we
  ; need figure out which of of the xvariables has the widest span.
  
  xrange1=x1[startsub1] & xrange2=x1[endsub1]  
  if keyword_set(x2) then begin
    xrange1=min([x1[startsub1], x2[startsub2]])
    xrange2=max([x1[endsub1], x2[endsub2]])
  endif  
  if keyword_set(x3) then begin
    xrange1=min([x1[startsub1], x2[startsub2], x3[startsub3]])
    xrange2=max([x1[endsub1], x2[endsub2], x3[endsub3]])
  endif  
  if keyword_set(x4) then begin
    xrange1=min([x1[startsub1], x2[startsub2], x3[startsub3], x4[startsub4]])
    xrange2=max([x1[endsub1], x2[endsub2], x3[endsub3], x4[endsub4]])
  endif  
  if keyword_set(x5) then begin
    xrange1=min([x1[startsub1], x2[startsub2], x3[startsub3], x4[startsub4], $
                 x5[startsub5]])
    xrange2=max([x1[endsub1], x2[endsub2], x3[endsub3], x4[endsub4], $
                 x5[endsub5]])
  endif  
  if keyword_set(x6) then begin
    xrange1=min([x1[startsub1], x2[startsub2], x3[startsub3], x4[startsub4], $
                 x5[startsub5], x6[startsub6]])
    xrange2=max([x1[endsub1], x2[endsub2], x3[endsub3], x4[endsub4], $
                 x5[endsub5], x6[endsub6]])
  endif  
  if keyword_set(x7) then begin
    xrange1=min([x1[startsub1], x2[startsub2], x3[startsub3], x4[startsub4], $
                 x5[startsub5], x6[startsub6], x7[startsub7]])
    xrange2=max([x1[endsub1], x2[endsub2], x3[endsub3], x4[endsub4], $
                 x5[endsub5], x6[endsub6], x7[endsub7]])
  endif 
  if keyword_set(x8) then begin
    xrange1=min([x1[startsub1], x2[startsub2], x3[startsub3], x4[startsub4], $
                 x5[startsub5], x6[startsub6], x7[startsub7], x8[startsub8]])
    xrange2=max([x1[endsub1], x2[endsub2], x3[endsub3], x4[endsub4], $
                 x5[endsub5], x6[endsub6], x7[endsub7], x8[endsub8]])
  endif
 
  ;;;;;;;;;;;;;;;;;
  ;Actual Plotting;
  ;;;;;;;;;;;;;;;;;
 
  ;Let IDL set the yranges and do all the plot panels
  if domanualy EQ '' then begin
    
    jre_plotpanel, x1[startsub1:endsub1], y1[startsub1:endsub1], $
       label1[startsub1:endsub1], xstyle=1, xtitle=xtitle1, ytitle=ytitle1, $
       /ynozero, xrange=[xrange1, xrange2], title=title, _extra=extra_keywords, $
       winnum=0
    if keyword_set(zeroline) then oplot, x1[startsub1:endsub1], $
      fltarr(endsub1-startsub1), linestyle=1

    if keyword_set(x2) then begin $
      jre_plotpanel, x2[startsub2:endsub2], y2[startsub2:endsub2], xstyle=1, xtitle=xtitle2, $
        ytitle=ytitle2, /ynozero, xrange=[xrange1, xrange2], $
      _extra=extra_keywords, winnum=0
      if keyword_set(zeroline) then oplot, x2[startsub2:endsub2], $
        fltarr(endsub2-startsub2), linestyle=1
    endif
  
    if keyword_set(x3) then begin $
      jre_plotpanel, x3[startsub3:endsub3], y3[startsub3:endsub3], xstyle=1, xtitle=xtitle3, $
        ytitle=ytitle3, /ynozero, xrange=[xrange1, xrange2], $
      _extra=extra_keywords, winnum=0
      if keyword_set(zeroline) then oplot, x3[startsub3:endsub3], $
        fltarr(endsub3-startsub3), linestyle=1
     endif
          
    if keyword_set(x4) then begin $
      jre_plotpanel, x4[startsub4:endsub4], y4[startsub4:endsub4], xstyle=1, xtitle=xtitle4, $
        ytitle=ytitle4, /ynozero, xrange=[xrange1, xrange2], $
      _extra=extra_keywords, winnum=0
      if keyword_set(zeroline) then oplot, x4[startsub4:endsub4], $
        fltarr(endsub4-startsub4), linestyle=1
    endif
    
    if keyword_set(x5) then begin $
      jre_plotpanel, x5[startsub5:endsub5], y5[startsub5:endsub5], xstyle=1, xtitle=xtitle5, $
        ytitle=ytitle5, /ynozero, xrange=[xrange1, xrange2], $
      _extra=extra_keywords, winnum=0
      if keyword_set(zeroline) then oplot, x5[startsub5:endsub5], $
        fltarr(endsub5-startsub5), linestyle=1
    endif
    
    if keyword_set(x6) then begin $
      jre_plotpanel, x6[startsub6:endsub6], y6[startsub6:endsub6], xstyle=1, xtitle=xtitle6, $
        ytitle=ytitle6, /ynozero, xrange=[xrange1, xrange2], $
      _extra=extra_keywords, winnum=0
      if keyword_set(zeroline) then oplot, x6[startsub6:endsub6], $
        fltarr(endsub6-startsub6), linestyle=1
    endif
    
    if keyword_set(x7) then begin $
      jre_plotpanel, x7[startsub7:endsub7], y7[startsub7:endsub7], xstyle=1, xtitle=xtitle7, $
        ytitle=ytitle7, /ynozero, xrange=[xrange1, xrange2], $
      _extra=extra_keywords, winnum=0
      if keyword_set(zeroline) then oplot, x7[startsub7:endsub7], $
        fltarr(endsub7-startsub7), linestyle=1
     endif
    
    if keyword_set(x8) then begin $
      jre_plotpanel, x8[startsub8:endsub8], y8[startsub8:endsub8], xstyle=1, xtitle=xtitle8, $
        ytitle=ytitle8, /ynozero, xrange=[xrange1, xrange2], $
      _extra=extra_keywords, winnum=0    
      if keyword_set(zeroline) then oplot, x8[startsub8:endsub8], $
        fltarr(endsub8-startsub8), linestyle=1
     endif
   
  endif ;end doing plots with autoranging

  ;Manually setting the yrange for all panels
  if domanualy EQ 'y' then begin
    jre_plotpanel, x1[startsub1:endsub1], y1[startsub1:endsub1], label1[startsub1:endsub1], $
      xstyle=1, xtitle=xtitle1, _extra=extra_keywords, $
      ytitle=ytitle1, /ynozero, xrange=[xrange1, xrange2], title=title, $
      ystyle=1, yrange=[mean(y1[startsub1:endsub1])-halfrange, $
      mean(y1[startsub1:endsub1])+halfrange]
    if keyword_set(x2) then $
      plot, x2[startsub2:endsub2], y2[startsub2:endsub2], xstyle=1, xtitle=xtitle2, $
      ytitle=ytitle2, /ynozero, xrange=[xrange1, xrange2], _extra=extra_keywords, $
      ystyle=1, yrange=[mean(y2[startsub2:endsub2])-halfrange, $
      mean(y2[startsub2:endsub2])+halfrange]
    if keyword_set(x3) then $
      plot, x3[startsub3:endsub3], y3[startsub3:endsub3], xstyle=1, xtitle=xtitle3, $
      ytitle=ytitle3, /ynozero, xrange=[xrange1, xrange2], _extra=extra_keywords, $
      ystyle=1, yrange=[mean(y3[startsub3:endsub3])-halfrange, $
      mean(y3[startsub3:endsub3])+halfrange]
    if keyword_set(x4) then $
      plot, x4[startsub4:endsub4], y4[startsub4:endsub4], xstyle=1, xtitle=xtitle4, $
      ytitle=ytitle4, /ynozero, xrange=[xrange1, xrange2], _extra=extra_keywords, $
      ystyle=1, yrange=[mean(y4[startsub4:endsub4])-halfrange, $
      mean(y4[startsub4:endsub4])+halfrange]
    if keyword_set(x5) then $
      plot, x5[startsub5:endsub5], y5[startsub5:endsub5], xstyle=1, xtitle=xtitle5, $
      ytitle=ytitle5, /ynozero, xrange=[xrange1, xrange2], _extra=extra_keywords, $
      ystyle=1, yrange=[mean(y5[startsub5:endsub5])-halfrange, $
      mean(y5[startsub5:endsub5])+halfrange]
    if keyword_set(x6) then $
      plot, x6[startsub6:endsub6], y6[startsub6:endsub6], xstyle=1, xtitle=xtitle6, $
      ytitle=ytitle6, /ynozero, xrange=[xrange1, xrange2], _extra=extra_keywords, $
      ystyle=1, yrange=[mean(y6[startsub6:endsub6])-halfrange, $
      mean(y6[startsub6:endsub6])+halfrange]
    if keyword_set(x7) then $
      plot, x7[startsub7:endsub7], y7[startsub7:endsub7], xstyle=1, xtitle=xtitle7, $
      ytitle=ytitle7, /ynozero, xrange=[xrange1, xrange2], _extra=extra_keywords, $
      ystyle=1, yrange=[mean(y7[startsub7:endsub7])-halfrange, $
      mean(y7[startsub7:endsub7])+halfrange]
    if keyword_set(x8) then $
      plot, x8[startsub8:endsub8], y8[startsub8:endsub8], xstyle=1, xtitle=xtitle8, $
      ytitle=ytitle8, /ynozero, xrange=[xrange1, xrange2], _extra=extra_keywords, $
      ystyle=1, yrange=[mean(y8[startsub8:endsub8])-halfrange, $
      mean(y8[startsub8:endsub8])+halfrange]
  endif ;end doing plots with autoranging

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Options (in alphabetical order);
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  if n_elements(command) EQ 0 or firstcommanddone EQ 'y' then begin
    print, 'Type a letter. Basic options: (z)oom in, (o)ut zoom, (u)ndo last, (f)orward, (b)ack, (r)eset, (q)uit'
    print, 'Hit h for help and to see other options.'
    if quitnow EQ 1 then dozoom='q' else dozoom=get_kbrd()
    print, dozoom
  endif
  firstcommanddone='y'

  ;Scrolling backward through data
  if dozoom EQ 'b' then begin
    oldstartsub=startsub1
    oldendsub=endsub1
    startsub1=startsub1-(endsub1-startsub1)
    endsub1=oldstartsub
  endif
  
  ;Scrolling forward through data
  if dozoom EQ 'f' then begin
    oldstartsub=startsub1
    oldendsub=endsub1
    startsub1=endsub1
    endsub1=endsub1+(endsub1-oldstartsub)
  endif

  ;Getting help
  if dozoom EQ 'h' then begin
    print, 'Type a single letter in the command window (no return needed).'
    print, 'The results will cause changes in whichever plot window is active.'
    print, 'b = Move (b)ackward in the time series at the current zoom level.'
    print, 'f = Move (f)orward in the time series at the current zoom level.'
    print, 'm = Set the y-range of the plots (m)anually instead of letting IDL auto-range.'
    print, 'o = Zoom (o)ut by one zoom level.'
    print, 'p = Save the current (p)lot.'
    print, 'q = (q)uit.'
    print, 'r = (R)eset the zoom level.'
    print, 't = (T)ype the subscripts of the array to be displayed (e.g. set the zoom range manually).'
    print, 'u = (U)ndo the last zoom or scroll forward or backward.'
    print, 'x = Write to the IDL console the (x) variable value where clicked.'
    print, 'z = (Z)oom in by clicking twice on the plot window.'
  endif
  
  ;Manually setting the yranges of the plots
  if dozoom EQ 'm' then begin
    print, 'Enter the fixed total y-axis range desired. The plot will center on the mean and have the total width'
    print, 'entered but will not auto-range as per the IDL default. Enter 0 to let it go back to auto-ranging.'
    read, prompt='', halfrange
    halfrange=halfrange/2.
    if halfrange NE 0 then domanualy='y'
    if halfrange EQ 0 then domanualy=''
  endif
  
  ;Zoom out
  if dozoom EQ 'o' then begin
    oldstartsub=startsub1
    oldendsub=endsub1
    difference=endsub1-startsub1
    startsub1=startsub1-(difference/2.)
    endsub1=endsub1+(difference/2.)
  endif

  ;Saving the current plot
  if dozoom EQ 'p' then begin
    tagPlot = ''
    ;read, tagPlot, PROMPT='Enter descriptive tag for file, if desired: '
    savename='doy'+strtrim(string(x1[startsub1], f='(F7.3)'),2)+$
      '-'+strtrim(string(x1[endsub1], f='(F7.3)'),2)+tagPlot
    if keyword_set(savedir) then savename=savedir+'\'+savename
    image=cgSnapshot(/png, wid=0, filename=savename+'.png')
  endif
  
  ;Reset the zoom level
  if dozoom EQ 'r' then begin
    startsub1=0L
    endsub1=numtotal1-1L
  endif
  
  ;Type in the subscripts to chose a subinterval manually
  if dozoom EQ 't' then begin
    oldstartsub=startsub1
    oldendsub=endsub1
    read, prompt='Enter first subscript of interval: ', startsub1
    read, prompt='Enter second subscript of interval: ', endsub1
  endif
  
  ;Undo one zoom level
  if dozoom EQ 'u' then begin
    startsub1=oldstartsub
    endsub1=oldendsub
    dozoom='y'
  endif
  
  ;Reading out label's value at particular location
  if dozoom EQ 'x' then begin
    print, 'Click on the plot to get the x-axis label value for the point.'
    cursor, xpoint, ydata, /data, /up
    xpoint=where(xpoint GT x1)
    xpoint=xpoint[-1]
    if keyword_set(label1) then print, label1[xpoint]
  endif
  
  ;Do the zooming by mouse clicks
  if dozoom EQ 'z' then begin
    oldstartsub=startsub1
    oldendsub=endsub1
    
    print, 'Click on the start and end times on the plot (two clicks)'
    cursor, startsub1, ydata, /data, /up
    
    linecoordsx=[startsub1, startsub1]
    linecoordsy=[-1e6, 1e6]
    startsub1=where(startsub1 GT x1)
    startsub1=startsub1[-1]
    oplot, linecoordsx, linecoordsy, linestyle=1
    
    cursor, endsub1, ydata,  /data, /up
    linecoordsx2=[endsub1, endsub1]
    endsub1=where(endsub1 GT x1)
    endsub1=endsub1[-1]
    oplot, linecoordsx2, linecoordsy, linestyle=1
    
  endif

  if keyword_set(onetime) then quitnow=1

endrep until dozoom EQ 'q' ;end zooming

!p.multi=0
!p.charsize=1.0

end

