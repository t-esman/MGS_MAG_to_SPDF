pro gyrocollision

 echrg = 1.602E-19;C
 v=400000 ;m/s
   amu = 1.67E-27; kg
   m=amu
   B=1e-8 ;T
   r_m=3.39*10e6 ;m

gyroradius = (m*v)/(echrg*B)
 
  me = 9.11E-31; kg
  mop = 16*1.66E-27; kg
  mo2p = 32*1.66E-27; kg

  qm_ele = echrg/me;
  qm_op = echrg/mop;
  qm_o2p = echrg/mo2p;

mag_layer = 1e-7 ; T

wele = 1e-9 * qm_ele * mag_layer
print,wele

;  wele_z = 1.E-9 * qm_ele * mag_layers(3,:);
;  wele_y = 1.E-9 * qm_ele * mag_layers(2,:);
;  wele_x = 1.E-9 * qm_ele * mag_layers(1,:);
;  wele_m = 1.E-9 * qm_ele * mag_layers(4,:);
;  wele_h = 1.E-9 * qm_ele * mag_layers(5,:);

wop = 1e-9*qm_op*mag_layer
print,wop
;  wop_z = 1.E-9 * qm_op * mag_layers(3,:);
;  wop_y = 1.E-9 * qm_op * mag_layers(2,:);
;  wop_x = 1.E-9 * qm_op * mag_layers(1,:);
;  wop_m = 1.E-9 * qm_op * mag_layers(4,:);
;  wop_h = 1.E-9 * qm_op * mag_layers(5,:);
wo2p = 1e-0*qm_o2p*mag_layer
print,wo2p
;  wo2p_z = 1.E-9 * qm_o2p * mag_layers(3,:);
;  wo2p_y = 1.E-9 * qm_o2p * mag_layers(2,:);
;  wo2p_x = 1.E-9 * qm_o2p * mag_layers(1,:);
;  wo2p_m = 1.E-9 * qm_o2p * mag_layers(4,:);
;  wo2p_h = 1.E-9 * qm_o2p * mag_layers(5,:);

  ; Calculate collision frequencies

  polCO2 = 2.6E-24;
  polO = 0.77E-24;
  amu = 1.66E-24; g
  mCO2 = 44.0;
  mOP = 16.0;
  mO2P = 32.0;
  mO = 16.0;

 rmOPCO2 = amu/(1/mCO2 + 1/mOP);
;   nuOPCO2 = 3.33E-9*sqrt(polCO2/rmOPCO2)*(mCO2/(mCO2+mOP))*denCO2;
; nuOPO = (3.67E-11*sqrt(tmp)*(1.0-0.064*log10(tmp)).^2)*denO; need ngims
;  nuOP = nuOPCO2 + nuOPO;
;
  rmO2PCO2 = amu/(1/mCO2 + 1/mO2P);
;  nuO2PCO2 = 3.33E-9*sqrt(polCO2/rmO2PCO2)*(mCO2/(mCO2+mO2P))*denCO2;
  rmO2PO = amu/(1/mO + 1/mO2P);
;  nuO2PO = (3.33E-9*sqrt(polO/rmO2PO)*mO/(mO+mO2P))*denO;
;  nuO2P = nuO2PCO2 + nuO2PO;
end