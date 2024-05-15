pro create_b_mag
get_data,'mvn_B_full',data=data
store_data,'mvn_B_mag',data={x:data.x,y:sqrt(data.y[*,0]^2+data.y[*,1]^2+data.y[*,2]^2)}
split_vec,'mvn_B_full'

options,'mvn_B_full_x',ytitle='B!Dx!N [nT]'
options,'mvn_B_full_y',ytitle='B!Dy!N [nT]'
options,'mvn_B_full_z',ytitle='B!Dz!N [nT]'

options,'dec_jan_x',ytitle='x FFT Power [nT]'
options,'dec_jan_y',ytitle='y FFT Power [nT]'
options,'dec_jan_z',ytitle='z FFT Power [nT]'
end