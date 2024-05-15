;+
; PROCEDURE:
;       enepa2vv
; PURPOSE:
;       interpolates irregularly-gridded (ene,pa) data 
;       to regularly-gridded (vpara,vperp) data
; CALLING SEQUENCE:
;       enepa2vv, data, energy, pa, newdata, vpara, vperp
; INPUTS:
;       data: data values to be interpolated (energy,pa)
;       energy: energies of the data points in eV
;       pa: pitch angles of the data points in deg
;       newdata: named variable to return the interpolated data
;       vpara: named variable to return the parallel velocities in km/s
;       vperp: named variable to return the perpendicular velocities in km/s
; KEYWORDS:
;       erange: energy range to be used (Def: all)
;       resolution: resolution of the mesh in perp direction (Def: 51)
;       mass: mass of the spieces in eV/(km/s)^2 (Def: electron 5.6856591e-6)
;       smooth: width of the smoothing window (Def: no smoothing)
;       mirror_vperp: add -Vperp for display
;       dat_plot: returns irregular data
; CREATED BY:
;       Yuki Harada on 2014-08-05
;-

pro enepa2vv, data, energy, pa, newdata, vpara, vperp, erange=erange, resolution=resolution, mass=mass, smooth=smooth, mirror_vperp=mirror_vperp, dat_plot=dat_plot, noqhull=noqhull

if not keyword_set(resolution) then resolution = 51
if resolution mod 2 eq 0 then resolution = resolution + 1
if not keyword_set(mass) then mass = 5.6856591e-6
if not keyword_set(erange) then erange = [min(energy),max(energy)]

vx = sqrt(2*energy/mass)*cos(pa*!dtor)
vy = sqrt(2*energy/mass)*sin(pa*!dtor)

xrange = [-sqrt(2*max(erange)/mass),sqrt(2*max(erange)/mass)]
xspacing = (xrange[1]-xrange[0])/(resolution-1)/2.
if keyword_set(mirror_vperp) then begin
   yrange = [-1,1]*sqrt(2*max(erange)/mass)
   yspacing = (yrange[1]-yrange[0])/(resolution-1)/2.
endif else begin
   yrange = [0,sqrt(2*max(erange)/mass)]
   yspacing = (yrange[1]-yrange[0])/(resolution-1)
endelse

;- reject NAN and INF
w = where( finite(data) and finite(vx) and finite(vy) , nw )
if nw eq 0 then begin
   dprint,'No finite data'
   return
endif
vx2 = vx[w]
vy2 = vy[w]
data2 = data[w]

if keyword_set(mirror_vperp) then begin
   vx2 = [ vx2, vx2 ]
   vy2 = [ vy2, -vy2 ]
   data2 = [ data2, data2 ]
endif

dat_plot = {vx:vx2,vy:vy2,data:data2}


;- triangulate
;- qhull generally performs better than triangulate (cf. spd_slice2d_2di.pro)
qhull, vx2, vy2, tr , /delaunay 
if keyword_set(noqhull) then triangulate, vx2, vy2, tr, b ;- obsolete

newdata = trigrid( vx2, vy2, data2, tr, [xspacing,yspacing], $
                   [ xrange[0], yrange[0], xrange[1], yrange[1] ], $
                   xgrid=vpara, ygrid=vperp )

if keyword_set(smooth) then newdata = smooth(newdata,smooth,/nan)

Npara = n_elements(vpara) ;101
Nperp = n_elements(vperp) ;51
vpara = rebin(vpara,Npara,Nperp)
vperp = transpose(rebin(vperp,Nperp,Npara))
idx_0 = where( (vpara^2+vperp^2)*mass/2. lt erange[0] $
               or (vpara^2+vperp^2)*mass/2. gt erange[1], idx_0_cnt)
if idx_0_cnt gt 0 then newdata[idx_0] = 0.

return

end
