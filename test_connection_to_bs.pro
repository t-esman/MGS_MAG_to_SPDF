pro test_connection_to_BS
 ; restore,'shocks_mse.sav'
 ;tplot_restore,filename='new_distant.tplot'
 tplot_restore,filename='distant_full_fft.tplot'
restore,filename='ResultYearly/result2014.sav'
store_data,'msox',data={x:result.t,y:result.x}
store_data,'msoy',data={x:result.t,y:result.y}
store_data,'msoz',data={x:result.t,y:result.z}
mvn_mag_itplot,['mvn_B_1sec_MAVEN_MSO_x','mvn_B_1sec_MAVEN_MSO_y','mvn_B_1sec_MAVEN_MSO_z','x','y','z']
end