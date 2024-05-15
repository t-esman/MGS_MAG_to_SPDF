pro mva_error, lambda_1, lambda_2, lambda_3, B1, B2, B3, N, del_b


;+
; PROCEDURE: mva_error.pro
;
; PURPOSE:
;       THIS FUNCTION IS USED TO DETERMINE THE ERROR IN THE MAGNITUDE OF B1 FROM MVA

; KEYWORDS:
;       lambda_1 = value of minimum eigenvalue from MVA
;       lambda_2 = value of intermediate eigenvalue from MVA
;       lambda_3 = value of maximum eigenvalue from MVA
;       B1 = magnitude of B in minimum direction
;       B2 = magnitude of B in intermediate direction
;       B3 = magnitude of B in maximum direction
;       N = number of data points over the interval
;
; CREATED BY:
;       2011-10-11: Gina A DiBraccio
;-


;***************
;
; Main Function
;
;***************

; --------- CALCULATE ANGULAR ERROR ESTIMATES (IN RADIANS) -----------
;  phi_12 denotes the expected angular uncertainty of minimum eigenvector
;  for rotation toward or away from intermediate eigenvector, etc.

phi_12 = sqrt((lambda_1/(N-1)) * ((lambda_1 + lambda_2 - lambda_1)/((lambda_1 - lambda_2)^2.)))
phi_13 = sqrt((lambda_1 / (N - 1)) * ((lambda_1 + lambda_3 - lambda_1)/((lambda_1 - lambda_3)^2.)))
phi_23 = sqrt((lambda_1 / (N - 1)) * ((lambda_2 + lambda_3 - lambda_1)/((lambda_2 - lambda_3)^2.)))

; -------- CALCULATE THE STATISTICAL UNCERTAINTY IN THE COMPONENT OF THE
;          AVERAGE MAGNETIC FIELD ALONG THE MINIMUM EIGENVECTOR DIRECTION (X1) -----------

del_b = sqrt((lambda_1 / (N - 1)) + ((phi_12*b2)^2.) + ((phi_13*b3)^2.))


;return;, del_b

end