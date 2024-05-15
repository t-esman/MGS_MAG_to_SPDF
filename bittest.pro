function bittest, input, bit

;Takes an input byte and returns 1 or 0 for a particular bit in the byte.
;  The bits are labeled 1 to 8 with the leftmost (most significant)
;  bit being labeled 8.
;  Note that the first bit position is 1 not 0.

  output=strmid(string(input, format='(B8.8)'), abs(bit-8), 1)
  output=fix(output)
  
  return, output

end
