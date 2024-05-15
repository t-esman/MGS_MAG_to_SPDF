;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Purpose:
; Filtering a time series so that only certain frequency components
; contribute to it. The function is really just a wrapper to the IDL
; digital filter with some keywords to make using it easier.
;
;Required Inputs:
; input = time series data that you want to filter.
;
;Optional Inputs:
; samplerate = Sample rate of the input time series in samples per second. If 
;              not given as keyword then user is prompted to enter.
; low = Frequencies below this are filtered out. To be given in Hz. Defaults 
;       to zero.
; high = Frequencies above this are filtered out. To be given in Hz. Defaults
;       to the Nyquist frequency (half the sampling rate).
;
; gibbs = From the IDL digital_filter documentation: "The filter power relative
;          to the Gibbs phenomenon wiggles in decibels. 50 is a good choice."
;
; nterms = Number of terms in the digital filter. Affects the spectral sharpness
;          of the frequency of components of the filtered time series but the
;          general characteristics of the results are (amplitude, locations, 
;          etc.) fairly consistent regardless of choice here provided your
;          choice is reasonable. Reasonable choices are more than 50 and less
;          than 10% of the total length of the input time series. 
;          
;Output:
; output = Filtered time series with the same length as the input.
;
;Example Usage:
; This example has data with a sampling rate of 8 samples/sec and would give
; only the time series components that are between 0.3 and 0.7 Hz.
;
; filtered_data=jre_filter(input_data, samplerate=8, low=0.3, high=0.7)
;
;This example removes a 60 Hz line.
;
; bzmaven_no60=jre_filter(bzmaven, samplerate=256, low=60.5, high=59.5)
;
;
;Dependencies:
; None
; 
;Author:
; Jared.Espley@nasa.gov
; 
;Changes:
; 9May2014 JRE: First version.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function jre_filter, input, samplerate=samplerate, low=low, high=high, $
  gibbs=gibbs, nterms=nterms

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Setting defaults if keywords were not entered;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if keyword_set(samplerate) NE 1 then begin
  read, samplerate, prompt='Please enter the sampling rate in samples/sec:'
endif

if keyword_set(high) NE 1 then high=samplerate/2. ;i.e. lowpass

if keyword_set(low) NE 1 then low=0. ;i.e. highpass

if keyword_set(gibbs) NE 1 then gibbs=50 ;use default

if keyword_set(nterms) NE 1 then nterms=n_elements(input)/50L ;use default

;;;;;;;;;;;;;;
;Calculations;
;;;;;;;;;;;;;;

Nyquist=Samplerate/2. 

;Making the filter
filter_coeffs=digital_filter(low/Nyquist, high/Nyquist, gibbs, nterms)
  
;Applying the filter to input time series  
output=convol(input, filter_coeffs)

return, output
  
end
