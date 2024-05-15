print,'startup start'

!PATH=!PATH+':'+expand_path('+\Users\tesman\Documents\IDL\Tplot\')

setenv,'ROOT_DATA_DIR=\Users\tesman\Documents\MAVEN';Tesman_WD/MAVEN/'
setenv,'MAVENPFP_USER_PASS=tesman:tesman_pfp'
dlm_register,'\Users\tesman\Documents\IDL\SPICE\icy\lib\icy.dlm'
;loadct,39
@'qualcolors'
init_devices
loadcv,78
;device, true=24, decompose=0, retain=2
;loadcsvcolorbar,13; 87
;!p.background = qualcolors.white
;;!p.color=qualcolors.black
;
;tplot_options, 'bottom',qualcolors.bottom_c+1 
;tplot_options, 'top',qualcolors.top_c

print,'end startup'