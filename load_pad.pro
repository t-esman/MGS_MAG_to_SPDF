pro load_PAD,tp1,tp2

;tp1, tp2 = start and stop UNIX times between which you want PADs
mvn_swe_load_l2, /spec, /pad   ;load data
mvn_swe_sumplot, eph=0, /loadonly   ;put into tplot, without the ephemeris info

mvn_swe_addmag  ;add MAG (for PADs)

;The following line will output PADs into the the tplot variable 'mvn_swe_pad_resample'. The second and third lines are code that will re-save this into a unique tplot variable (in this case, the name includes the energy range used to create the PADs). This way you can re-run the PAD code for multiple energy ranges, and save those outputs into unique tplot variables so that they aren't overwritten each time. I use the default settings as below, and just modify erange each time.

mvn_swe_pad_resample, [tp1, tp2], nbins=128., erange=[0., 100.], /norm, /mask, /silent, pstyle=2
get_data, 'mvn_swe_pad_resample', data=dds, dlimit=dls, limit=lls
store_data, 'PAD_0_100', data=dds, dlimit=dls, limit=lls
end

;mvn_mag_itplot, ['PAD_0_100','mvn_sta_c0_E','mvn_sta_c6_M','mvn_swis_en_eflux','swe_a4', 'mvn_lpw_w_spec_act_l2','mvn_lpw_w_spec_pas_l2','mvn_lpw_lp_ne_l2','mvn_lpw_lp_te_l2', 'mvn_B_mso_x', 'mvn_B_mso_y', 'mvn_B_mso_z', 'mvn_B_mso_mag']
