
;;; set time
tsnap = time_double('2015-01-23/01:46:52')
timespan,'2015-01-23'

;;; set up a plot window
;thm_init
!p.charsize = 1.5
window,0,xs=800,ys=600
window,1,xs=800,ys=1000

;;; load data
if total(strlen(tnames('*'))) eq 0 then begin
   mvn_swe_load_l2,/pad,/spec
   mvn_swe_addmag
   mvn_swe_etspec
   mvn_swe_pad_restore
   mvn_lpw_load_l2,'wn',/notplot
endif

get_data,'mvn_B_1sec',btimes,bdata
babs = total(bdata^2,2)^.5
store_data,'babs',btimes,babs

;;; check time series
tplot,['mvn_swe_et_spec_svy','mvn_swe_pad_resample','mvn_lpw_w_n_l2','babs'], $
      trange=tsnap+[-300d,300d],win=0
timebar,tsnap
makepng,'times_aniso',win=0


;;; generates a snapshot
er = [10,1000]                  ;- energy range in eV
smo = 7                         ;- smoothing width
res = 61                        ;- regular grid resolution
thld_rdf = 1e-7                 ;- use only rdf > thld_rdf

vr = (2.*er/5.6856591e-6)^.5    ;- velocity range in km/s

;;; get |B|
babsnow = interp(babs,btimes,tsnap)
;;; get density
get_data,'mvn_lpw_w_n_l2',data=d
w = where(finite(d.y))
densnow = interp(d.y[w],d.x[w],tsnap)

;;; get PAD
pad = mvn_swe_getpad(tsnap,units='df')
ene = pad.energy
pa = pad.pa * !radeg
df = pad.data

enepa2vv,df,ene,pa, newdf, vpara, vperp, $
         smo=smo, erange=er, /mirror,res=res,dat_plot=dat_plot
;;; /mirror keyword adds mirrored datar at v_perp < 0 for a better interpolation near v_perp = 0
w = where(vperp[0,*] gt 0 , nw) ;- use only v_perp > 0
aniso,newdf[*,w],vpara[*,w],vperp[*,w],densnow,babsnow, $ ;- inputs
      A_vpara,gr_fce,f_fce,rdf,gr_len=gr_len                            ;- outputs

;;; replace invalid results by NaNs
w = where(rdf gt thld_rdf, nw)
vparar = [vr[0],max(vpara[w,0])]
wnan = where( abs(vpara[*,0]) lt vparar[0] or abs(vpara[*,0]) gt vparar[1], nwnan )
if nwnan gt 0 then begin
   A_vpara[wnan] = !values.f_nan
   gr_fce[wnan] = !values.f_nan
endif
wnan = where( abs(vpara[*,0]) lt vparar[0], nwnan )
if nwnan gt 0 then rdf[wnan] = !values.f_nan

title = time_string(pad.time)+' -> '+time_string(pad.end_time) $
        +', N='+string(densnow,f='(f5.1)')+', B='+string(babsnow,f='(f4.1)')


wset,1
!p.multi = [0,1,4]
!x.margin = [12,12]
!y.margin = [0,1]
!y.omargin = [4,1]
!p.charsize = 2
;;; e- VDF (v_par, v_perp)
xr = [-1,1] * vr[1]
yr = [0,1] * vr[1]
zr = [1e-17,1e-11]
nlines = 61
levels = 10.^( findgen(nlines)/float(nlines-1) $
               *(alog10(zr[1])-alog10(zr[0])) + alog10(zr[0]) )
col = bytescale(levels,/log,range=zr,bottom=7,top=254)
contour,newdf,vpara,vperp,ticklen=-.01,/fill, $ ;,/iso
        levels=levels,c_col=col, $
        xrange=xr,xstyle=1,xtickformat='(a1)', $
        yrange=yr,ystyle=1,ytitle='v_perp [km/s]', $
        title=title
numolines = 20
olevels = 10.^( findgen(numolines)/float(numolines-1) $
                *(alog10(zr[1])-alog10(zr[0])) + alog10(zr[0]) )
contour,newdf,vpara,vperp,levels=olevels,/over
draw_color_scale,range=zr,br=[7,254],/log, $
                 title='f!de!n [s!u3!n/km!u3!n/cm!u3!n]'

;;; reduced distribution function
plot,vpara[*,0],rdf, $
     xtitle='',xtickformat='(a1)', $
     ytitle='F!de!n [s/km/cm!U3!N]',/ylog,yrange=[1e-7,1e-2]
oplot,-vpara[*,0],rdf,linestyle=1

;;; anisotropy
plot,vpara[*,0],A_vpara, $
     xtitle='',xtickformat='(a1)', $
     ytitle='A',yrange=[-1,max(A_vpara)]
oplot,[-1.e5,1.e5],[0,0],linestyle=1

;;; growth rate
plot,vpara[*,0],gr_fce, $
     xtitle='v_par [km/s]', $
     ytitle='gmma / omega_ce' ,yrange=[-0.002,max(gr_fce)]
oplot,[-1.e5,1.e5],[0,0],linestyle=1

makepng,'snap_aniso'

!p.multi = 0


end
