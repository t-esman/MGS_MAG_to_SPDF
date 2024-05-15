pro swea_lpw_new_results
updown_ratio_PAD_50_200 = [$
0.253,$
0.172,$
0.257,$
0.223,$
0.349,$
0.0939,$
0.189,$
1.5060,$
0.1830,$
0.1090,$
0.2660,$
0.1930,$
0.7480,$
0.8470,$
0.3880,$
0.1910,$
0.1650,$
0.2170,$
0.6720,$
0.4390,$
0.5380,$
2.7330,$
0.1380,$
1.1610,$
0.3480,$
1.3290,$
0.2500,$
0.2280,$
0.3270,$
0.4540,$
0.2110,$
0.8830,$
0.7740,$
0.2590,$
0.1840,$
0.3040,$
0.5260,$
0.4580,$
0.7940,$
0.9380,$
0.2180,$
0.4920,$
0.4420,$
0.2620,$
0.6830,$
0.1380,$
0.1260,$
0.1950,$
0.1790,$
0.0900,$
0.131,$
0.2990]



terminator_ratio=[$
  0.4420,$
0.4540,$
0.2620,$
0.349,$
1.5060,$
0.1830,$
0.1090,$
0.5380,$
0.0939,$
0.189,$
0.1380,$
0.4580,$
2.7330]

night_ratio= [$
0.7940,$
0.2990,$
0.6830,$
0.2110,$
0.4390,$
0.8830,$
0.131,$
0.172,$
0.7740,$
0.9380,$
0.2590,$
0.253,$
0.3040,$
0.5260,$
0.1840,$
0.1380,$
0.1930,$
0.0900,$
0.3880,$
0.7480,$
0.8470,$
0.1790,$
0.4920,$
0.1910,$
0.1950,$
0.1650,$
0.2170,$
0.1260,$
0.6720]

day_ratio=[$
  1.161, 0.266,0.218,0.327,0.228,0.223,0.348,1.3290,0.25,0.257]


;5 seconds aka one LPW data
;pre_percent_ne=[$
;1037.56,$
;294.23,$
;86.26,$
;5536.88,$
;2312.8,$
;20.45,$
;1037.56,$
;112.9,$
;123.11,$
;25.55,$
;87.14,$
;100.12,$
;101.95,$
;-74.02,$
;1778.5,$
;138.81,$
;13435,$
;5914.8,$
;3795.59,$
;32.59,$
;14863,$
;65.49,$
;-29.87,$
;125.6,$
;1041.6,$
;53659668,$
;124.84,$
;122.7,$
;-20.21,$
;936.16,$
;193.37,$
;333.7,$
;-57.9,$
;93.54,$
;149.99,$
;312.42,$
;-84.23,$
;-76.9,$
;206.1,$
;-80.89,$
;-17.76,$
;4931.6172,$
;2333.4]
;5 seconds (aka one LPW data)
;post_percent_ne = [$
;-71.4227,-94.25,-63.45,-97.36,-89.28,-96.26,-26.71,-71.42,-48.3,$
;18.65,-34.88,-44.35,-77.9,23.58,16.65,-86.57,-90.49,116.41,-98.93,$
;-73.89,-0.77,18.9,57.84,-31.27,-49,-93.68,-98.61,-74.79,-90.99,$
;-12.75,-96.78,-48.41,-94.72,46.38,-65.59,-86.15,-92.42,-34.35,121.73,-96.78,-25.45,-82.36,-97.18,-63.4]


;20 seconds before and after
pre_percent_ne=[$
1020.15,$
114.53,$
67.18,$
5876,$
5758.68,$
82.14,$
3820.13,$
225.12,$
157.52,$
-27.09,$
82.86,$
207.14,$
-3.42,$
74.37,$
884.72,$
181.68,$
13435,$
1616.12,$
522.48,$
34.08,$
97,$
57.84,$
8.29,$
170.66,$
610.4,$
871337.88,$
195.19,$
143.9,$
-64.42,$
3717.65,$
227.3,$
417.93,$
358.35,$
-49,$
110.17,$
107.61,$
687.93,$
130.11,$
-58.32,$
533.07,$
199.14,$
-28.9,$
14013,$
1732.88]



post_percent_ne=[$
-79.27,$
-95.92,$
-74.29,$
-98.11,$
-79.23,$
-97.13,$
-27.56,$
-95.33,$
-69.44,$
12.22,$
-12.9,$
-48.4,$
-50.5,$
-24.8,$
-88.32,$
-96.22,$
-97.23,$
52.17,$
-94.75,$
-100.,$
-64.23,$
2.07,$
50.17,$
137.4,$
-50.25,$
-0.75,$
-84.59,$
-97.39,$
-91.3,$
-96.25,$
20.33,$
-94.3,$
-9.02,$
-95.81,$
-99.92,$
-2.01,$
-22.39,$
-81.04,$
-84.61,$
-94.15,$
-17.3,$
-98.28,$
-96.5,$
-93.2,$
-97.79,$
-83.02]








false_pre_ne = pre_percent_ne
for i = 0, n_elements(pre_percent_ne)-1 do begin
  
  if pre_percent_ne(i) gt 490. then begin
    false_pre_ne(i) = 490.
    print,pre_percent_ne(i)
  endif
  ;gt 500
endfor

    H=histbins(post_percent_ne,XBINS,range = [-125, 525],binsize = 50.)
   ; le100 = where(pre_percent_ne le 100.)
    H2=histbins(false_pre_ne,X2BINS,range = [-125, 525], binsize=50.)
 
  data1 = H
  data2 = H2
  b1 = BARPLOT(XBINS,H, PATTERN_ORIENTATION=45, $
    PATTERN_SPACING=6, PATTERN_THICK=2,FILL_COLOR='black',yrange=[0,30],histogram=1, NAME = 'Post-Wave',xrange = [-100,600])
  b2 = BARPLOT(X2BINS,H2, $
     FILL_COLOR='green',/OVERPLOT, PATTERN_ORIENTATION=-45, $
    PATTERN_SPACING=6, PATTERN_THICK=2,yrange=[0,30],histogram = 1, NAME='Pre-Wave')
  ;  leg = LEGEND(TARGET = [b1,b2],/data,/auto_text_color)


;  
;blah2 = where(pre_percent_ne gt 100 and pre_percent_ne lt 1000.)
;  H3=histbins(pre_percent_ne(blah2),X3BINS)
;
;  b3 = BARPLOT(X3BINS,H3, NBARS=1, $
;    FILL_COLOR='gold',$
;    YTITLE='Number of Events', XTITLE='Percent Change', $
;    TITLE = 'Percent gt 100 and lt 1000',xlog = 0,PATTERN_ORIENTATION=45, $
;    PATTERN_SPACING=6, PATTERN_THICK=2,yrange=[0,20])
;;;;    
;   blah3 = where(pre_percent_ne ge 1000.)
;  H4=histbins(pre_percent_ne(blah3),X4BINS,NBINS =1)+1
;  b4 = BARPLOT(X4BINS,H4, NBARS=1, $
;    FILL_COLOR='gold', width =0.8,$
;    YTITLE='Number of Events', XTITLE='Percent Change', $
;    TITLE = 'Percent ge 1e3 and lt 1e4',PATTERN_ORIENTATION=45, $
;    PATTERN_SPACING=6, PATTERN_THICK=2, xstyle=1,yrange=[0,20])
;
;zerozero = where(abs(pre_percent_ne) gt 0.)
;DHFOS = histbins(abs(pre_percent_ne(zerozero)),XXBINS,/log,nbins=20,range=[0.1,1e9])
;bb = BARPLOT(XXBINS, DHFOS, color='green',/xlog,xrange=[0.1,1e9],histogram=1,xtickdir=1)
;
;  b1 = BARPLOT(XBINS,H,color='purple',/overplot,histogram=1,/xlog)
;
; 
;  plot,psym=10, XXBINS, histbins(pre_percent_ne(zerozero),XXBINS,/log)
; 
; 
;   blah3 = where(pre_percent_ne ge 1e4)
;  H4=histbins(pre_percent_ne(blah3),X4BINS)
;  b4 = BARPLOT(X4BINS,H4, NBARS=1, $
;    FILL_COLOR='gold', xrange=[1e4,5e7],$
;    YTITLE='Number of Events', XTITLE='Percent Change', $
;    TITLE = 'Percent ge 1e4',xlog =0, PATTERN_ORIENTATION=45, $
;    PATTERN_SPACING=6, PATTERN_THICK=2,yrange=[0,20])
;    
    
    
    
    
    
    
    
    
    
    
  
  ;  blah2 = where(pre_percent_ne gt 100 and pre_percent_ne lt 1000.)
  ;  


;  H=histbins(NIGHT_RATIO,XBINS,binsize=0.15)
;  H1 = histbins(DAY_RATIO,X2BINS,binsize=0.15)
;  H2=histbins(TERMINATOR_RATIO,X3BINS,binsize=0.15)
;  b = BARPLOT(XBINS,H, NBARS=1, $
;    FILL_COLOR='black',$
;    YTITLE='Number of Events', XTITLE='Ratio', $
;    TITLE = 'Ratio of Upgoing to Downgoing Electrons',xlog = 0,PATTERN_ORIENTATION=45, $
;    PATTERN_SPACING=6, PATTERN_THICK=2,name='night')
;    b1 = barplot(x2bins,h1,fill_color='gold',/overplot,name='day')
;    b2 = barplot(x3bins,h2,fill_color='blue',/overplot,pattern_orientation = -45, pattern_spacing = 6, pattern_thick=2, name='term')
;;    
    
    
    
    ;save, filename='SWEA_LPW_NEW_RESULTS.sav',updown_ratio_PAD_50_200,pre_percent_ne,post_percent_ne
end















