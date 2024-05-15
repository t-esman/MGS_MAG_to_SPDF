;+
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Purpose:
; Perform FFTs of an input data array. Optionally can also do co-added FFTs
; for some fixed window of time across the original, full-length input.
;
;Required Inputs:
; 
; input = Input time series. Note that the FFT requires that the input time
;         series be equally spaced to give accurate results. The code assumes
;         that the user has already checked for this. 
; 
; samplerate = Samples per second. The inverse of the time between adjacent time
;               points.
;               
; fft_avg_int = Length of the window across which to co-add. Setting this to
;               zero does the FFT across the whole interval with no co-adding.
;               
;Outputs:
;
; freqlist = List of the frequency bins produced by the FFT. This ranges from
;            zero frequency to half the sampling rate (the Nyquist frequency).
;           
; spectra = The spectral magntitudes in each frequency bin.
;           
;Optional Input:
;
; inputtime = Time series of time values corresponding to the input time series.
;             If not included then the routine creates a calculated time series
;             based on the sampling rate input and the number of samples. This
;             works if the input time series is continious and has the same
;             sampling rate throughout. Both of these assumptions should generally
;             be true for the FFT to even work so inputting the time via this
;             keyword is probably redundant unless you have some unusual case or
;             are willing to have a FFT with possibly incorrect results if you have
;             a non-continuious time series.
; 
;Example Usage:
;
;#1: This is a basic example. It FFTs the entire input Bx array that has 32 
;       samples/sec.
; jre_fft, bx, 32, 0, bxfreqs, bxspectra
;
;#2: This time we have a co-added interval of 60 seconds.
; jre_fft, bx, 32, 60, bxfreqs, bxspectra
; 
;#3: After either of these previous two examples then we can do some plotting.
; freqlower=1e-3
; freqhigher=1.6e1
; spectralow=1e-4
; spectrahigh=1e-1
; plot, bxfreqs, bxspectra, /ylog, /xlog, ytitle='Spectral Magnitude', xtitle='Hz', $
;   xrange=[freqlower, freqhigher], yrange=[spectralow,spectrahigh], title='Bx', xstyle=1
;
;Dependencies:
; None.
;
;Known Issues, Problems, etc.:
; If the input time series is actually a complex array then the output
; spectra has information at both negative and positive frequencies and
; should be complexly conjugated together instead of simply multiplying
; the positive power by a factor of two. This is not an issue with any
; dataset that I, the original author, would be using.
;
;To do list:
; None (at the moment). 
;
;Author:
; Jared.R.Espley@nasa.gov
;
;Version
;1.2
;
;Changes:
; 27Aug2014 JRE: nint set to 1 if less then 1
; 22Aug2014 JRE: fft_avg_int converted to float
; 3Jun2014  JRE: Updated documentation
; 19May2014 JRE: Updates
; 15Apr2014 JRE: First created from previous code.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-

pro jre_fft, $
  input, samplerate, fft_avg_int, $;inputs
  freqlist, spectra, $;output
  inputtime=inputtime ;optional inputs

fft_avg_int=float(fft_avg_int)

;Time between samples.
delta=1./samplerate

if keyword_set(inputtime) NE 1 then begin
  numtotal=n_elements(input)
  inputtime=findgen(numtotal)*delta
endif

;Doing the case where we don't have any subintervals so we're doing the whole
; input time series
if fft_avg_int EQ 0 then begin
  
  num=n_elements(input)
  
  ;Abs() gives the magnitude of the complex output
  ; This is generally what is reported as spectral amplitude.
  fftinput=abs(fft(input)) 
  
endif

;Doing the case for subintervals of time series to be FFTed, added together, 
; and averaged.

if fft_avg_int NE 0 then begin

  ;how many subintervals are in the input array
  nint=floor(inputtime[-1]/fft_avg_int)
  if nint LE 1L then nint=1L
  
  ;number of points in each subinterval
  if nint EQ 1L then num=n_elements(input) else num=fft_avg_int*samplerate
  
  ;looping through the subintervals
  for i=0L, nint-1L do begin

    ;FFT of subinterval  
    ffttemp=fft(input[i*num:((i+1L)*num)-1L])
  
    ;Adding the FFTs of the subinterval together unless it's the first subinterval
    if i EQ 0L then fftinput=abs(ffttemp) ELSE fftinput=fftinput+abs(ffttemp)

  endfor
  
  ;Averaging by the number of subintervals
  fftinput=fftinput/float(nint)
  
endif

;Preparing the spectra by taking just the positive frequencies and doubling
; their spectral magnitude.
spectra=fftinput[0:num/2]*2.

;Preparing the list of positive frequency bins which goes from 0 to the 
; positive Nyquist frequency. See the IDL FFT documentation. 
freqlist=findgen(num/2+1)/(num*delta)
binwidth= freqlist(1)-freqlist(0)
print,'binwidth: ', binwidth
end