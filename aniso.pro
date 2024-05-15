;+
; PROCEDURE:
;       aniso
; PURPOSE:
;       calculates pitch angle anisotropy as a function of vpara 
;       as well as whistler growth rate [cf. Kennel & Petschek, 1966]
; CALLING SEQUENCE:
;       aniso, df, vpara, vperp, dens, Babs, A_vpara, gr_fce, f_fce, rdf
; INPUTS:
;       df: distribution function as a function of
;           regularly-gridded vpara and vperp
;       vpara: parallel velocities of the data points
;       vperp: perpendicular velocities of the data points
;       dens: density in cm-3 required for the growth rate calculation
;       Babs: |B| in nT required for the growth rate calculation
;       avpara: named variable to return the anisotropy
;       gr_fce: named variable to return the growth rate/fce for
;               whistler mode as a function of f_fce
;       f_fce: named variable to return the frequency/fce for gr_fce
;       rdf: named variable to return the reduced distribution function
; KEYWORDS:
;       
; CREATED BY:
;       Yuki Harada on 2014-08-07
;-

pro aniso, df, vpara, vperp, dens, Babs, A_vpara, gr_fce, f_fce, rdf, vg=vg, gr_len=gr_len


Npara = n_elements(vpara[*,0])
Nperp = n_elements(vperp[0,*])
dvpara = vpara[1,0] - vpara[0,0]
dvperp = vperp[0,1] - vperp[0,0]
dfdvpara = fltarr(Npara,Nperp)
dfdvperp = fltarr(Npara,Nperp)

dfdvpara[indgen(Npara-2)+1,*] = $
   ( df[indgen(Npara-2)+2,*] - df[indgen(Npara-2),*] )/2./dvpara
dfdvpara[0,*] = (df[1,*] - df[0,*])/dvpara
dfdvpara[Npara-1,*] = (df[Npara-1,*] - df[Npara-2,*])/dvpara

dfdvperp[*,indgen(Nperp-2)+1] = $
   ( df[*,indgen(Nperp-2)+2] - df[*,indgen(Nperp-2)] )/2./dvperp
dfdvperp[*,0] = (df[*,1] - df[*,0])/dvperp
dfdvperp[*,Nperp-1] = (df[*,Nperp-1] - df[*,Nperp-2])/dvperp

A_vpara = total(( vpara*dfdvperp - vperp*dfdvpara )*vperp^2/vpara*dvperp, 2) $
          /total(2.*df*vperp*dvperp, 2)

rdf = 2.*!pi*total(df*vperp,2)*dvperp ;- reduced df
yeta_vpara = abs(vpara[*,0]) * rdf / dens ;- fraction of resonant electrons
vae = Babs*1.e-9/sqrt(4.e-7*!pi*dens*1.e6*9.1093897e-31)/1.e3 ;- e Alfven vel
f_fce_s = (findgen(1001))/1000. ;- find resonant frequencies for vparas
f_fce = f_fce_s[value_locate( (1-f_fce_s)^1.5/f_fce_s^0.5,abs(vpara[*,0]/vae))]
gr_fce = !pi*yeta_vpara*(1-f_fce)^2*( A_vpara - 1./(1./f_fce-1.) )
;;; This should be interpreted as gamma/omega_ce ... YH on 2022-05-26

gr_hz = gr_fce * 28.*Babs
vg = (1-f_fce)^1.5 / f_fce^.5 * vae
gr_len = vg/2./!pi/gr_hz ;- characteristic e‐folding scale of the linear convective growth

;;; Note: E = E0 exp(-i*omega_r*t)*exp(gamma*t)
;;;       omega = omega_r + i*gamma
;;;       amplitude e-folding time is 1/gamma, where gammma is in rad/s
;;;       power ratio: dB = 1/( 20*alog10(exp(1)) ) Np


return

end
