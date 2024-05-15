n=1000               ;number of datapoints
deltat=0.01            ;time interval between data - could be seconds

;;;;;;;;;;;;;;;;;;;;;
;Input array options;
;;;;;;;;;;;;;;;;;;;;;

;Uncomment and/or change these as you want to experiment and recompile and rerun

;#1: Plain sine wave
;alpha=0.1             ;time constant -- effectively gives Hz of signal
;amplitude=50.          ;amplitude of fluctuations
;input=amplitude*cos(alpha * (2.*!PI) * deltat * findgen(n))

;#2: Plain sine wave then flat
;alpha=0.4             ;time constant -- effectively gives Hz of signal
;amplitude=20.          ;amplitude of fluctuations
;input1=amplitude*cos(alpha * (2.*!PI) * deltat * findgen(n/2))
;input=[input1, fltarr(n/2)] 

;#3: Two sines waves with same amplitude but different frequencies
;alpha=2.             ;time constant -- effectively gives Hz of signal
;alpha2=0.05             ;time constant -- effectively gives Hz of signal;;
;amplitude=10.          ;amplitude of fluctuations
;input=amplitude*cos(alpha * (2.*!PI) * deltat * findgen(n))+$
;  amplitude*cos(alpha2 * (2.*!PI) * deltat * findgen(n))

;#4 Random noise with sinusoid -- good for testing noise floor calculations.
alpha=0.5
ampsignal=10.
ampnoise=1.
input=ampsignal*cos(alpha * (2.*!PI) * deltat * findgen(n)) + ampnoise*randomn(seed, n)

;;#5 Sinusoid with set frequency with noise about frequency 
;alpha=5.+0.05*randomn(seed,n)
;amplitude=10.
;input=fltarr(n)
;for i=0L, n-1L do begin
;  input[i]=amplitude*cos(alpha[i] * (2.*!PI) * deltat * i)
;endfor

;#6 Two sinusoids with set frequency with noise about frequency
;alpha=5.+0.04*randomn(seed,n)
;alpha2=0.5+0.04*randomn(seed,n)
;amplitude=100.
;input=fltarr(n)
;for i=0L, n-1L do begin
;  input[i]=amplitude*cos(alpha[i] * (2.*!PI) * deltat * i) + $
;           amplitude*cos(alpha2[i] * (2.*!PI) * deltat * i)
;endfor

;#7: Two sines waves with the same amplitude and different freqs and noise
;alpha=2.             ;time constant -- effectively gives Hz of signal
;alpha2=0.05             ;time constant -- effectively gives Hz of signal;
;amplitude=10.          ;amplitude of fluctuations
;ampnoise=5.
;input=amplitude*cos(alpha * (2.*!PI) * deltat * findgen(n))+$
;  amplitude*cos(alpha2 * (2.*!PI) * deltat * findgen(n))+ $
;  ampnoise*randomn(seed, n)

;#8: Two sines waves with different frequencies and amplitudes
;alpha=2.             ;time constant -- effectively gives Hz of signal
;alpha2=0.05             ;time constant -- effectively gives Hz of signal;;
;amplitude1=50.          ;amplitude of fluctuations
;amplitude2=5.
;input=amplitude1*cos(alpha * (2.*!PI) * deltat * findgen(n))+$
;  amplitude2*cos(alpha2 * (2.*!PI) * deltat * findgen(n))

;;;;;;;;;;;;
;Time array;
;;;;;;;;;;;;

t=findgen(n)*deltat   

;;;;;;;;;;;;;;;;;;
;Time series plot;
;;;;;;;;;;;;;;;;;;

!p.multi=0
window, 0, xsize=1600, ysize=500

;Times series
plot, t, input, ytitle='Amplitude', xtitle='Time'

;;;;;
;FFT;
;;;;;

jre_ffttest, input, 1./deltat, 0, freqlist, spectra, inputtime=t

;FFT plot
!p.multi=[0,2,1]
window, 1, xsize=1600, ysize=500
freqlower=1e-3 ; in Hz
freqhigher=1e2 ; in Hz
spectralower=1e-2 
spectrahigher=1e3 
plot, freqlist, spectra, /ylog, /xlog, ytitle='Spectra',xtitle='Hz',xstyle=1,$
  xrange=[freqlower, freqhigher], yrange=[spectralower,spectrahigher], $
  title='Max Spectra = '+strtrim(string(max(spectra)),2);, psym=2

;;;;;;;;;
;Wavelet;
;;;;;;;;;
  
jre_waveletplot_test, t, input, 1./deltat, spectralow=2, spectrahigh=20, /psd

;;;;;;;;
;FFT_PS;
;;;;;;;;

f=fft_powerspectrum(input, deltat, freq=freq)

window, 2
plot, freq, sqrt(f), /xlog, /ylog, xrange=[freqlower, freqhigher], $
  yrange=[spectralower, spectrahigher], psym=2, title='Max Spectra = '+strtrim(string(max(sqrt(f))),2)

;Testing Trevor's code
;spectra2=fftinput*conj(fftinput)
;X = (FINDGEN((num- 1)/2) + 1)
;t=findgen(num)*delta
;fft_freqs = [0.0, X, num/2, -num/2 + X]/(num*t[1])


end