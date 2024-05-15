pro sep_load

timespan,'2014-09-22/00:00:00',6
mvn_sep_load

;get ion flux data
get_data,  'mvn_SEP1F_ion_flux', data = ion_1F
get_data,  'mvn_SEP2F_ion_flux', data = ion_2F
get_data,  'mvn_SEP1R_ion_flux', data = ion_1R
get_data,  'mvn_SEP2R_ion_flux', data = ion_2R

ion_energies = mean(ion_1f.v, dimension=1, /nan)
nen = n_elements (ion_energies)

;make tplot variables for ion energy flux
store_data,'mvn_SEP1F_ion_eflux', data = {x: ion_1f.x, y: ion_1f.y*ion_1f.v, v:ion_energies}
store_data,'mvn_SEP1R_ion_eflux', data = {x: ion_1r.x, y: ion_1r.y*ion_1r.v, v:ion_energies}
store_data,'mvn_SEP2F_ion_eflux', data = {x: ion_2f.x, y: ion_2f.y*ion_2f.v, v:ion_energies}
store_data,'mvn_SEP2R_ion_eflux', data = {x: ion_2r.x, y: ion_2r.y*ion_2r.v, v:ion_energies}
store_data,'com_SEP_Ion', data={x:ion_1f.x, y:(ion_1f.y*ion_1f.v + ion_1r.y*ion_1r.v + $
  ion_2f.y*ion_2f.v + ion_2f.y*ion_2r.v), v:ion_energies}

;get electron flux data
get_data,  'mvn_SEP1F_elec_flux', data = electron_1F
get_data,  'mvn_SEP2F_elec_flux', data = electron_2F
get_data,  'mvn_SEP1R_elec_flux', data = electron_1R
get_data,  'mvn_SEP2R_elec_flux', data = electron_2R

;make tplot variables for electron energy flux
electron_energies = reform (electron_1f.v [0,*])
store_data,'mvn_SEP1F_electron_eflux', $
  data = {x: electron_1f.x, y: electron_1f.y*electron_1f.v, v:electron_energies}
store_data,'mvn_SEP1R_electron_eflux', $
  data = {x: electron_1r.x, y: electron_1r.y*electron_1r.v, v:electron_energies}
store_data,'mvn_SEP2F_electron_eflux', $
  data = {x: electron_2f.x, y: electron_2f.y*electron_2f.v, v:electron_energies}
store_data,'mvn_SEP2R_electron_eflux', $
  data = {x: electron_2r.x, y: electron_2r.y*electron_2r.v, v:electron_energies}
store_data,'com_SEP_Electron', data={x:electron_1f.x, y:(electron_1f.y*electron_1f.v + $
  electron_1r.y*electron_1r.v + $
  electron_2f.y*electron_2f.v + $
  electron_2f.y*electron_2r.v), v:electron_energies}

;set the plots to spectrum with logarithmic Y and Z (color) axes
options,'mvn_SEP*eflux', 'spec', 1
options,'mvn_SEP*eflux', 'ylog', 1
options,'mvn_SEP*eflux', 'zlog', 1
options,'com_SEP_Ion', 'spec' , 1
options,'com_SEP_Ion', 'ylog' , 1
options,'com_SEP_Ion', 'zlog' , 1
options,'com_SEP_Electron', 'spec' , 1
options,'com_SEP_Electron', 'ylog' , 1
options,'com_SEP_Electron', 'zlog' , 1

;make y-axis titles
options,'mvn_SEP1F_ion_eflux','ytitle', '1F ions, !C keV'
options,'mvn_SEP1F_ion_eflux','ytitle', '1F ions, !C keV'
options,'mvn_SEP1R_ion_eflux','ytitle', '1R ions, !C keV'
options,'mvn_SEP2R_ion_eflux','ytitle', '2R ions, !C keV'
options,'com_SEP_Ion', 'ytitle', 'Tot. ions, !C keV'
options,'mvn_SEP1F_electron_eflux','ytitle', '1F elec,!C keV'
options,'mvn_SEP2F_electron_eflux','ytitle', '2F elec,!C keV'
options,'mvn_SEP1R_electron_eflux','ytitle', '1R elec,!C keV'
options,'mvn_SEP2R_electron_eflux','ytitle', '2R elec,!C keV'
options,'com_SEP_Electron', 'ytitle', 'Tot. elec, !C keV'

;z-axis title & limits
options,'mvn_SEP*eflux', 'ztitle', 'Diff Eflux, !c keV/cm2/s/sr/keV'
zlim, 'mvn_SEP*_eflux', 1e1,2e5, 1
ylim, 'mvn_SEP*ion_eflux', 7,1e4, 1
ylim, 'mvn_SEP*electron_eflux', 7,4e2, 1

options, 'com_SEP_Ion', 'ztitle', 'Diff Eflux, !c keV/cm2/s/sr/keV'
zlim, 'com_SEP_Ion', 1e1,2e5, 1
ylim, 'com_SEP_Ion', 7,1e4, 1

options, 'com_SEP_Electron', 'ztitle', 'Diff Eflux, !c keV/cm2/s/sr/keV'
zlim, 'com_SEP_Electron', 1e1,2e5, 1
ylim, 'com_SEP_Electron', 7,4e2, 1

;make a tplot variable for both attenuators
store_data, 'Attenuator', data = ['mvn_SEP1attenuator_state', 'mvn_SEP2attenuator_state']
options, 'Attenuator', 'colors',[70, 221]
ylim, 'Attenuator', 0.5, 2.5
options, 'Attenuator', 'labels',['SEP1', 'SEP2']
options, 'Attenuator', 'labflag',1
options, 'Attenuator', 'panel_size', 0.5

;make tplot variables for ion energy flux in both SEP instruments
store_data,'com_SEP1_Ion', data={x:ion_1f.x, y:(ion_1f.y*ion_1f.v + ion_1r.y*ion_1r.v), v:ion_energies}
store_data,'com_SEP2_Ion', data={x:ion_2f.x, y:(ion_2f.y*ion_2f.v + ion_2f.y*ion_2r.v), v:ion_energies}


;set the plots to spectrum with logarithmic Y and Z (color) axes
options,'com_SEP1_Ion', 'spec' , 1
options,'com_SEP1_Ion', 'ylog' , 1
options,'com_SEP1_Ion', 'zlog' , 1
options,'com_SEP2_Ion', 'spec' , 1
options,'com_SEP2_Ion', 'ylog' , 1
options,'com_SEP2_Ion', 'zlog' , 1
options,'com_SEP1_Ion', 'panel_size', 0.5
options,'com_SEP2_Ion', 'panel_size', 0.5

;make y-axis titles
options,'com_SEP1_Ion', 'ytitle', 'Tot. ions [keV] !C SEP 1'
options,'com_SEP2_Ion', 'ytitle', 'Tot. ions [keV] !C SEP 2'

;z-axis title & limits
options, 'com_SEP1_Ion', 'ztitle', 'Diff Eflux, !c keV/cm2/s/sr/keV'
zlim, 'com_SEP1_Ion', 1e1,2e5, 1
ylim, 'com_SEP1_Ion', 7,1e4, 1
options, 'com_SEP2_Ion', 'ztitle', 'Diff Eflux, !c keV/cm2/s/sr/keV'
zlim, 'com_SEP2_Ion', 1e1,2e5, 1
ylim, 'com_SEP2_Ion', 7,1e4, 1
tplot_save,filename='sep_distant'
end