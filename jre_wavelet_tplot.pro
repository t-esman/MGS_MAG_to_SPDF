;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Purpose;
;;;;;;;;;
;
;
;
;;;;;;;;;;;;;;;;;
;Required Inputs;
;;;;;;;;;;;;;;;;;
;
;inputx
;inputy
;rate
;i
;;;;;;;;;;;;;;;;;
;Optional Inputs;
;;;;;;;;;;;;;;;;;
;
;Takes any keyword that plot takes.
;
;;;;;;;;;;;;;;;;;;
;Optional Outputs;
;;;;;;;;;;;;;;;;;;
;
;
;
;;;;;;;;;;
;Examples;
;;;;;;;;;;
;
;
;
;;;;;;;
;Usage;
;;;;;;;
;
;
;;;;;;;;;;;;;;
;Dependencies;
;;;;;;;;;;;;;;
;
;
;
;;;;;;;;;;;;;;
;Known Issues;
;;;;;;;;;;;;;;
;
;
;
;;;;;;;;;;;;
;To-do list;
;;;;;;;;;;;;
;
; *Update documentation
; *Fix keywords to deal with entered values of zero
; *Add option to add overplot line (e.g. for gyrofrequencies)
; *Add a way to auto figure out datarate
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
;01Jun2015 JRE First version based on jre_waveletplot.pro
;05Jun2015 JRE Updated ytitle and prompts
;2018 TME Added wavelet_number keyword for plotting multiple (3) wavelets at once
;2018 TME added gyrofrequency lines, no option offered (he, h, and o)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


pro jre_wavelet_tplot, inputx, inputy, rate, wavelet_number=wavelet_number,$
  freqlow=freqlow, freqhigh=freqhigh, spectralow=spectralow, $
  spectrahigh=spectrahigh, psdnorm=psdnorm, Kolnorm=Kolnorm, raw=raw, $
  tsytitle=tsytitle, tsxtitle=tsxtitle, wavetitle=wavetitle, dj=dj, $
  interactive=interactive, winnum=winnum, inafteronce=inafteronce,$
  _extra=extra_keywords, rw_check=rw_check,mf_rot=mf_rot
   trangeCur = timerange(/current)
   print,trangeCur
   ylog=0
  if keyword_set(rw_check) then begin
    if rw_check eq 'y' then rw = 'y'
    if rw_check eq 'n' then rw = 'n'
  endif else begin
    rw = 'n'
  endelse
  if ~keyword_set(mf_rot) then mf_rot = 'n'
  turnoncycfreq='n'
  firsttime='y'
  secondtime='y'
  thirdtime='y'
  fourthtime='y'
  repeatcycle='n'
  ylog = 1
  repeat begin

    if keyword_set(interactive) then begin

      read, dj, prompt='Spacing between scales (dj)? (current:'+strtrim(string(dj),2)+'): '
      if keyword_set(wmother) EQ 0 then wmother=''
      read, wmotherchoice, prompt='Wavelet basis mother function?'+$
        ' 1=Morlet, 2=Paul, 3=Dog'+' (current:'+wmother+'): '
      if wmotherchoice EQ 1 then wmother='Morlet'
      if wmotherchoice EQ 2 then wmother='Paul'
      if wmotherchoice EQ 3 then wmother='Dog'
      if keyword_set(wparam) EQ 0 then wparam=6
      read, wparam, prompt='Wavelet basis parameter (see wavelet.pro header)? (current:'+$
        strtrim(string(wparam),2)+'): '


      normquery=''
      read, normquery, prompt='Power normalization scheme (none, psd, kol)? '
      if normquery EQ '' or normquery EQ 'none' or normquery EQ 'n' then begin
        psdnorm=0
        Kolnorm=0
      endif
      if normquery EQ 'psd' then begin
        psdnorm=1
        Kolnorm=0
      endif
      if normquery EQ 'kol' then begin
        psdnorm=0
        Kolnorm=0
      endif

    endif ;end interactive

    if keyword_set(inafteronce) then interactive=1
    if keyword_set(freqlow) EQ 0 then freqlow=0.001
    if keyword_set(freqhigh) EQ 0 then freqhigh=16.
    if keyword_set(spectralow) EQ 0 then spectralow=-3.
    if keyword_set(spectrahigh) EQ 0 then spectrahigh=0.
    if keyword_set(wavetitle) EQ 0 then wavetitle=''
    if keyword_set(winnum) EQ 0 then winnum=1
    if keyword_set(dj) EQ 0 then begin
      if n_elements(inputy) LT 1e5 then dj=0.125
      if n_elements(inputy) GE 1e5 and n_elements(inputy) LT 1e6 then dj=0.25
      if n_elements(inputy) GE 1e6 and n_elements(inputy) LT 5e6 then dj=0.5
      if n_elements(inputy) GE 5e6 then dj=2.
    endif
    if keyword_set(wmother) EQ 0 then wmother='Morlet'
    if keyword_set(wparam) EQ 0 then wparam=6

    ;Actual wavelet transform.
    wave=wavelet(inputy, 1./rate, period=period, dj=dj, /pad, mother=wmother, $
      param=wparam, _extra=extra_keywords)

    ;Raw wavelet spectra: no normalization to make spectral densities
    if keyword_set(raw) then $
      wavespectra=abs(wave)
    ;Default normalization and into log scale
    if keyword_set(psdnorm) EQ 0 and keyword_set(Kolnorm) EQ 0 and keyword_set(raw) EQ 0 then $
      wavespectra=alog10(abs(wave)^2)
    ;Normalization to wavelet power spectral density (PSD)
    if keyword_set(psdnorm) then $
      wavespectra=alog10((abs(wave)^2)/(replicate(1.,n_elements(inputy))#period))
    ;Normalization to Kolomgorov turbulence (i.e. solar wind-like)
    if keyword_set(Kolnorm) then $
      wavespectra=alog10((abs(wave)^2)/(replicate(1.,n_elements(inputy))#$
      (0.0003*(1./period)^(-5./3.))))
    ; in theory takes out the turbulence
    ; power is nt^2/Hz because of the normalization

    if isa(wavelet_number) then begin
      thick_number =2
      if wavelet_number eq 0 then begin
        store_data,'Wavelet', data={x:inputx, y:wavespectra,v:1/period},$
          dlim={spec:1,ystyle:1,no_interp:1}

        ylim, 'Wavelet', freqlow, freqhigh, y
        zlim, 'Wavelet', spectralow, spectrahigh, 0
        options, 'Wavelet', ztitle='Log spectral power', ytitle='Freq. (Hz)'


if keyword_set(mf_rot) then get_data, 'mvn_B_mso_mag', data=data, alim=alim, dlim=dlim $
  else get_data, 'mvn_B_mag', data=data, alim=alim, dlim=dlim
        get_data,'mvn_B_mso_mag',data=data

        if turnoncycfreq eq 'y' then begin
        tplot_rename,'Wavelet','Wavelet_cyc'
        if rw eq 'y' then begin
          store_data, 'Wavelet', data=['Wavelet_cyc','cycFreq','ocycFreq','hecycFreq','rw1','rw2'];,'cycFreqHigh','cycFreqLow']
        endif else begin
          store_data, 'Wavelet', data=['Wavelet_cyc','cycFreq'];,'ocycFreq','hecycFreq'];,'cycFreqHigh','cycFreqLow']

        endelse
        endif
        options, 'Wavelet', ytitle='Freq. [Hz] z'
        
        mf_rot = 'n'
        if mf_rot eq 'y' then options,'Wavelet', ytitle='Freq. Para'
        options, 'Wavelet', yrange=[freqlow, freqhigh]

      endif
      if wavelet_number eq 1 then begin
        ylog=0
        store_data,'2Wavelet', data={x:inputx, y:wavespectra,v:1/period},$
          dlim={spec:1,ystyle:1,no_interp:1}
        ; freqlow=-1.0
        ; freqhigh=1.5
        ylim, '2Wavelet', freqlow, freqhigh, ylog
        zlim, '2Wavelet', spectralow, spectrahigh, 0
        options, '2Wavelet', ztitle='Log spectral power', ytitle='Freq. (Hz)'

         if keyword_set(mf_rot) then get_data, 'mvn_B_mso_mag', data=data, alim=alim, dlim=dlim $
  else get_data, 'mvn_B_mag', data=data, alim=alim, dlim=dlim
       get_data,'mvn_B_mso_mag',data=data,alim=alim,dlim=dlim

         if turnoncycfreq eq 'y' then begin
        tplot_rename,'2Wavelet','2Wavelet_cyc'
        if rw eq 'y' then begin
          store_data, '2Wavelet', data=['2Wavelet_cyc','2cycFreq','2ocycFreq','2hecycFreq','rw1','rw2'];,'cycFreqHigh','cycFreqLow']
        endif else begin
          store_data, '2Wavelet', data=['2Wavelet_cyc','2cycFreq'];,'2ocycFreq','2hecycFreq'];,'cycFreqHigh','cycFreqLow']
        endelse
        endif
        options, '2Wavelet', ytitle='Freq. [Hz] y'
        if mf_rot eq 'y' then options,'2Wavelet', ytitle='Freq. Transverse'
        options, '2Wavelet', yrange=[freqlow, freqhigh]

      endif
      if wavelet_number eq 2 then begin
        ylog =0
        store_data,'3Wavelet', data={x:inputx, y:wavespectra,v:1/period},$
          dlim={spec:1,ystyle:1,no_interp:1}
        ;freqlow=-1.5
        ;freqhigh=1.5
        ylim, '3Wavelet', freqlow, freqhigh, ylog
        zlim, '3Wavelet', spectralow, spectrahigh, 0
        options, '3Wavelet', ztitle='Log spectral power', ytitle='Freq. (Hz)'

if keyword_set(mf_rot) then get_data, 'mvn_B_mso_mag', data=data, alim=alim, dlim=dlim $
  else get_data, 'mvn_B_mag', data=data, alim=alim, dlim=dlim
      get_data,'mvn_B_mso_mag',data=data,alim=alim,dlim=dlim
      ;  bmag=data.y
       ; w_pc = 0.015*bmag;make_array(n_elements(bmag),value=0.015*bmag)
      ;  w_oc = 0.00096*bmag;make_array(n_elements(bmag),value=0.00096*bmag)
      ;  w_he = 0.0038*bmag;make_array(n_elements(bmag),value=0.0038*bmag)
     ;  store_data, '3hecycFreq',data={x:data.x, y:w_he}
       ; store_data, '3cycFreq', data={x:data.x, y:w_pc}
     ;   store_data, '3ocycFreq', data={x:data.x, y:w_oc}
     ;   options,'3hecycFreq',color=3,linestyle=0,thick=thick_number
    ;    options, '3cycFreq', color=3,linestyle=0,thick=thick_number
    ;    options, '3ocycFreq', color = 3, linestyle=0,thick=thick_number

    ;    options,'rw1',color=5,linestyle=0,thick=thick_number
    ;    options,'rw2',color=5,linestyle=0,thick=thick_number
         if turnoncycfreq eq 'y' then begin
        tplot_rename,'3Wavelet','3Wavelet_cyc'
        if rw eq 'y' then begin
          store_data, '3Wavelet', data=['3Wavelet_cyc','3cycFreq','3ocycFreq','3hecycFreq','rw1','rw2'];,'cycFreqHigh','cycFreqLow']
        endif else begin
          store_data, '3Wavelet', data=['3Wavelet_cyc','3cycFreq'];,'cycFreqHigh','cycFreqLow']
        endelse
        endif
        options, '3Wavelet', ytitle='Freq. [Hz] x'
        options, '3Wavelet', yrange=[freqlow, freqhigh]

      endif
      if wavelet_number eq 3 then begin
        store_data,'4Wavelet', data={x:inputx, y:wavespectra,v:1/period},$
          dlim={spec:1,ystyle:1,no_interp:1}
        ; freqlow=-1.0
        ; freqhigh=1.5
        ylim, '4Wavelet', freqlow, freqhigh, ylog
        zlim, '4Wavelet', spectralow, spectrahigh, 0
        options, '4Wavelet', ztitle='Log spectral power', ytitle='Freq. (Hz)'

        if keyword_set(mf_rot) then get_data, 'mvn_B_mso_mag', data=data, alim=alim, dlim=dlim $
        else get_data, 'mvn_B_mag', data=data, alim=alim, dlim=dlim
        get_data,'mvn_B_mso_mag',data=data,alim=alim,dlim=dlim

        bmag=data.y

        w_pc = 0.015*bmag

        store_data, '4cycFreq', data={x:data.x, y:w_pc}

        options, '2cycFreq', color=3,linestyle=0,thick=thick_number

        if turnoncycfreq eq 'y' then begin
          tplot_rename,'4Wavelet','4Wavelet_cyc'

            store_data, '4Wavelet', data=['4Wavelet_cyc','4cycFreq'];,'cycFreqHigh','cycFreqLow']
        endif
        options, '4Wavelet', ytitle='Freq. [Hz] TRANSVERSE'
        options, '4Wavelet', yrange=[freqlow, freqhigh]

      endif
    endif else begin


      store_data,'Wavelet', data={x:inputx, y:wavespectra,v:1/period},$
        dlim={spec:1,ystyle:1,no_interp:1}
      ylim, 'Wavelet', freqlow, freqhigh, ylog
      zlim, 'Wavelet', spectralow, spectrahigh, 0
      options, 'Wavelet', ztitle='Log spectral power', ytitle='Freq. (Hz) test'

    endelse

    ;could add wavelet plot to panel
    out = tnames('*', /tplot)
    for i=0, n_elements(out)-1 do begin
      if out(i) eq 'Wavelet' then firsttime='n'
      if out(i) eq '2Wavelet' then secondtime='n'
      if out(i) eq '3Wavelet' then thirdtime='n'
      if out(i) eq '4Wavelet' then fourthtime='n'
    endfor


    if firsttime EQ 'y' then begin
      tplot, 'Wavelet', /add
      print,'first wavelet'
    endif else begin
      if secondtime EQ 'y' then begin
        tplot, '2Wavelet', add_var=1
        secondtime='n'
        print,'second wavelet'
      endif else begin
        if thirdtime EQ 'y' then begin
          tplot,'3Wavelet', add_var = 1
          thirdtime='n'
          print,'third wavelet'
        endif else begin
          if fourthtime EQ 'y' then begin
            tplot,'4Wavelet',add_var =1
            fourthtime='n'
            print,'fourth wavelet'
            endif else begin
          tplot
        endelse
      endelse
    endelse
    endelse

    firsttime='n'

    if keyword_set(interactive) then begin
       print,'Skipping adjustment of parameters.'
   ;   print,'Adjustment of parameters? (y/n) '
      ;temp_prompt=get_kbrd()
       temp_prompt='n'
      if temp_prompt EQ 'y' then repeatcycle='y' else repeatcycle='n'
    endif

  endrep until repeatcycle EQ 'n'
  ; store_data,delete=['Wavelet_cyc','cycFreq','ocycFreq','hecycFreq']
  ; store_data,delete=['3Wavelet_cyc','3cycFreq','3ocycFreq','3hecycFreq']
  ; store_data,delete=['2Wavelet_cyc','2cycFreq','2ocycFreq','2hecycFreq']
;
;if rate lt 30 then begin
;blah_start = where(data.x gt trangecur(0)-0.3 and data.x lt trangecur(0)+0.3)
;blah_end = where(data.x gt trangecur(1)-0.3 and data.x lt trangecur(0)+0.3)
;
;if blah_start eq -1 then begin
;  blah_start = where(data.x gt trangecur(0)-0.7 and data.x lt trangecur(0)+0.7)
;endif
;if blah_start(0) eq -1 then begin
;  blah_start = where(data.x gt trangecur(0)-0.9 and data.x lt trangecur(0)+0.9)
;endif
;if blah_end eq -1 then begin
;  blah_end = where(data.x gt trangecur(1)-0.7 and data.x lt trangecur(1)+0.7)
;endif
;if blah_end(0) eq -1 then begin
;  blah_end = where(data.x gt trangecur(1)-0.9 and data.x lt trangecur(1)+0.9)
;endif

;blah_start=blah_start(0)
;blah_end=blah_end(0)
;print,blah_start
;print,blah_end
;  w_pc1 = 0.015*bmag(blah_start:blah_end)
;print,mean(w_pc1,/nan)
;endif
end