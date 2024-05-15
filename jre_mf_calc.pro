pro jre_mf_calc, $;
    bx, by, bz, $ ;inputs
    bpar, bt, bn, btran, rotang ;outputs
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Purpose;
;;;;;;;;;
;
;Transform vector magnetic fields (e.g. in MSO, SS, or PC coordinates) into
; coordinate system that is oriented along the mean field direction of the 
; input magnetic arrays.
;
;;;;;;;;;;;;;;;;;
;Required Inputs;
;;;;;;;;;;;;;;;;;
;
;bx, by, bz = vectors that are the same length
;
;;;;;;;;;;;;;;;;;
;Optional Inputs;
;;;;;;;;;;;;;;;;;
;
;None
;
;;;;;;;;;
;Outputs;
;;;;;;;;;
;
;bpar = array of magnetic field measurements parallel to mean field direction
;bt = array of magnetic field measurements perpendicular to bpar and with no bx
;bn = array of mangetic field measurements perpendicular to bpar and bt
;btran = array of magnetic field measurements perpendicular to mean field direction = transverse
;rotang = array of the angles between bn and bt. A negative slope of this time
;          series indicates a LH rotation and a postive slope RH rotation.
;          See figure 3a of Cloutier et al., GRL, 1999 for an example of this
;          usage.
;
;;;;;;;;;;;;;;
;Dependencies;
;;;;;;;;;;;;;;
;
;None.
;
;;;;;;;;;;;;;;
;Known Issues;
;;;;;;;;;;;;;;
;
;None.
;
;;;;;;;;;
;Authors;
;;;;;;;;;
;
;JRE: Jared.R.Espley@nasa.gov
;
;;;;;;;;;
;Version;
;;;;;;;;;
;
;1.0 JRE: First version based on mf_calc.pro from Analyze.pro from JRE's thesis
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

     
num=n_elements(bx) 
avebx=total(bx)/float(num)
aveby=total(by)/float(num)
avebz=total(bz)/float(num)
avemag=total(sqrt(bx^2+by^2+bz^2))/float(num)

dbx=bx-avebx
dby=by-aveby
dbz=bz-avebz

;See 27Jun02 and 9Jul02 in Espley grad lab book 1
; and notes from Espley Onenote July 2018
bpar=(dbz*avebz+dby*aveby+dbx*avebx)/avemag
bt=(dbz*aveby-dby*avebz)/avemag
bn=(-dby*avebx*aveby-dbz*avebx*avebz+dbx*(aveby^2+avebz^2))/(avemag^2)

btran=sqrt(bt^2+bn^2)
rotang=atan(bn,bt)
rotang=rotang*360/(2*!pi)

end
