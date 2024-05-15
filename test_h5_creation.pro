pro test_h5_creation

  grey_scale = byte(bindgen(256)##(bytarr(3)+1b))
  palette = {_TYPE:'Attribute', _DATA:grey_scale}
  dataset = {_NAME:'Hanning', _TYPE:'Dataset', $
    _DATA:hanning(100,200), PALETTE:palette}
  H5_CREATE, 'myfile.h5', dataset
  ;can't create file??
  ;h5f_create doesn't exist ? not supported by this version?? 
  ;cdf_exists() returns 0 
 ; In the second case an HDF5 file is read using H5_PARSE, modifications are made to the structure and the resulting structure is written to a new file. For example, to change the palette in the example file created above so that the colors are reversed:

;  result = H5_PARSE('myfile.h5', /READ_DATA)
;  newpalette = reverse(result.hanning.palette._data, 2)
;  result.hanning.palette._data = newpalette
;  H5_CREATE, 'myNEWfile.h5', result

end