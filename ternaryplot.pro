pro TernaryPlot, x, y, z, $
  _EXTRA=extra

  ; write warnings for x, y not being within 0-1 and adding to more than 1
  ; first check if z exists or not
  n_x = n_elements(x)
  n_y = n_elements(y)
  n_z = n_elements(z)

  if n_z eq 0 then begin
    print, 'z not present, assumed to be = 1-x-y'
    z=1-x-y
    n_z = n_elements(z)
  endif

  ; check if x, y, z, all same # of elements
  if (n_x ne n_y) or (n_x ne n_z) or (n_x ne n_z) then $
    Message, 'x, y, z must have same number of elements'

  ; check if all sum to one
  tot = x+y+z
  if total(tot gt 1) ge 1 then $
    print, 'warning: at least one element adds to >1 '
  if total(tot lt 1) ge 1 then $
    print, 'warning: at least one element adds to <1 '


  x_new = y + z/2
  y_new = SQRT(3)/2*z
  vertices_x= [0.0, 0.5, 1, 0]
  vertices_y= [0.0, SQRT(3)/2, 0, 0]

  cgPlot, x_new, y_new, xRange=[0,1], yRange=[0, SQRT(3)/2], yStyle=1, _EXTRA=extra
  cgPlot, vertices_x, vertices_y, psym=-3, /overplot

end