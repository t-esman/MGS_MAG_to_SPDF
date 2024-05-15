pro mva_calc, magdata, mvadata, evalues, e_vec

; AUTHOR:  G A DIBRACCIO

; INPUTS
; magdata - magnetic field data to be analyzed with MVA. A structure including the following
;       data should be used: time,bx,by,bz
; in the structure, time is....
;
; OUTPUTS
; mva_mag - a structure of the resulting MVA results including the following elements:
;           b1, b2, b3, e1, e2, e3, vec1, vec2, vec3
;
;
; DEPENDENCIES:
; None
; 
; EXAMPLE OF USAGE:
; mag_temp={bx:999.,by:999.,bz:999.,index:999}
; magdata=replicate(mag_temp,n)
; mva_calc, magdata, mva_mag
;
; VERSION:
; 1.0 11/14/12  GAD: Created

;-----------------------------------------------------------------------------------              







;;  CREATE A MATRIX OF BX, BY, BZ COMPONENTS IN THE CHOSEN INTERVAL, IN MSO COORDINATES
b_matrix = [[magdata.bx],[magdata.by],[magdata.bz]]
cov_m = correlate(transpose(b_matrix), /covariance)

;;  SOLVE FOR EIGENVALUES AND EIGENVECTORS OF COVARIANCE MATRIX
TRIRED, cov_m, lambda, E   
TRIQL, lambda, E, cov_m 
;PRINT, lambda
eigenvectors=cov_m
;print, eigenvectors

;;  FIND MINIMUM EIGENVALUE AND ASSOCIATED EIGENVECTOR
index1 = where(lambda eq min(abs(lambda)))
lambda1 = lambda[index1]

;;  FIND THE INTERMEDIATE EIGENVALUE AND ASSOCIATED EIGENVECTOR
index2 = where(lambda ne min(abs(lambda)) and lambda ne max(abs(lambda)))
lambda2 = lambda[index2]

;;  FIND MAXIMUM EIGENVALUE AND ASSOCIATED EIGENVECTOR
index3 = where(lambda eq max(abs(lambda)))
lambda3 = lambda[index3]

;;  CALCULATE RATIOS OF LAMBDAS (MAX TO INTERMEDIATE AND INTERMEDIATE TO MIN)
lam2_1 = lambda2/lambda1
lam3_2 = lambda3/lambda2


;;  CREATE TRANSFORMATION MATRIX FROM EIGENVECTORS IN ORDER TO TRANSFORM COORDINATE SYSTEM
;;  FROM MSO INTO MVA COORDINATES (B1, B2, B3). **NOTICE NEGATIVE INTERMEDIATE EIGENVECTOR**
mva_trans = [[eigenvectors[*,index1]], [-eigenvectors[*,index2]], [eigenvectors[*,index3]]]

b_mva = b_matrix # mva_trans

mvadata_temp = {b1:999.,b2:999.,b3:999.}
mvadata = replicate(mvadata_temp, n_elements(magdata.bx))
evalues = {e1:999.,e2:999.,e3:999.}
e_vec = {vec1:fltarr(3),vec2:fltarr(3),vec3:fltarr(3)}

mvadata[*].b1 = b_mva[*,0]
mvadata[*].b2 = b_mva[*,1]
mvadata[*].b3 = b_mva[*,2]
evalues.e1=lambda1
evalues.e2=lambda2
evalues.e3=lambda3
e_vec[*].vec1=eigenvectors[*,index1]
e_vec[*].vec2=-eigenvectors[*,index2]
e_vec[*].vec3=eigenvectors[*,index3]

;print, 'e2/e1 = ',strtrim(lam2_1,2)
;print, 'e3/e2 = ', strtrim(lam3_2,2)
;print, 'B1 = ', strtrim(mva.vec1,2)
;print, 'B2 = ', strtrim(mva.vec2,2)
;print, 'B3 = ', strtrim(mva.vec3,2)


;return























  
                    
                                                 
;;;  PLOT THE BZ COMPONENT OF THE INTERVAL TO CHECK THAT THE BOUNDARY CROSSING IS INCLUDED
;;p=plot(magdata[magdata.index].time, magdata[magdata.index].bz)
;
;;;  CREATE A MATRIX OF BX, BY, BZ COMPONENTS IN THE CHOSEN INTERVAL, IN MSO COORDINATES
;;b_matrix = [[magdata.bx],[magdata.by],[magdata.bz]]
;b_matrix = [[magdata[magdata.index].bx],[magdata[magdata.index].by],[magdata[magdata.index].bz]]
;cov_m = correlate(transpose(b_matrix), /covariance)
;
;;;  SOLVE FOR EIGENVALUES AND EIGENVECTORS OF COVARIANCE MATRIX
;TRIRED, cov_m, lambda, E   
;TRIQL, lambda, E, cov_m 
;;PRINT, lambda
;eigenvectors=cov_m
;;print, eigenvectors
;
;;;  FIND MINIMUM EIGENVALUE AND ASSOCIATED EIGENVECTOR
;index1 = where(lambda eq min(abs(lambda)))
;lambda1 = lambda[index1]
;
;;;  FIND THE INTERMEDIATE EIGENVALUE AND ASSOCIATED EIGENVECTOR
;index2 = where(lambda ne min(abs(lambda)) and lambda ne max(abs(lambda)))
;lambda2 = lambda[index2]
;
;;;  FIND MAXIMUM EIGENVALUE AND ASSOCIATED EIGENVECTOR
;index3 = where(lambda eq max(abs(lambda)))
;lambda3 = lambda[index3]
;
;;;  CALCULATE RATIOS OF LAMBDAS (MAX TO INTERMEDIATE AND INTERMEDIATE TO MIN)
;lam2_1 = lambda2/lambda1
;lam3_2 = lambda3/lambda2
;
;
;;;  CREATE TRANSFORMATION MATRIX FROM EIGENVECTORS IN ORDER TO TRANSFORM COORDINATE SYSTEM
;;;  FROM MSO INTO MVA COORDINATES (B1, B2, B3). **NOTICE NEGATIVE INTERMEDIATE EIGENVECTOR**
;mva_trans = [[eigenvectors[*,index1]], [-eigenvectors[*,index2]], [eigenvectors[*,index3]]]
;
;b_mva = b_matrix # mva_trans
;
;mvadata = {b1:fltarr(n_elements(magdata.time)),b2:fltarr(n_elements(magdata.time)),b3:fltarr(n_elements(magdata.time)),e1:999.,e2:999.,e3:999.,$
;        vec1:fltarr(3),vec2:fltarr(3),vec3:fltarr(3)}
;
;mvadata[*].b1 = b_mva[*,0]
;mvadata[*].b2 = b_mva[*,1]
;mvadata[*].b3 = b_mva[*,2]
;mvadata.e1=lambda1
;mvadata.e2=lambda2
;mvadata.e3=lambda3
;mvadata[*].vec1=eigenvectors[*,index1]
;mvadata[*].vec2=-eigenvectors[*,index2]
;mvadata[*].vec3=eigenvectors[*,index3]
;
;;print, 'e2/e1 = ',strtrim(lam2_1,2)
;;print, 'e3/e2 = ', strtrim(lam3_2,2)
;;print, 'B1 = ', strtrim(mva.vec1,2)
;;print, 'B2 = ', strtrim(mva.vec2,2)
;;print, 'B3 = ', strtrim(mva.vec3,2)
;
;
;return


end