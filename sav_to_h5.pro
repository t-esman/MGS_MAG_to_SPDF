pro sav_to_h5

  filename='/Users/tesman/Desktop/MAVEN/rse/currentedp20171031.sav'
  
  restore,filename

  datastruct=create_struct('altmola',ALL_EDP.ALTITUDEMOLA,'areolat3550',ALL_EDP.AREOCENTRICLAT3550,'bendangle',ALL_EDP.BENDINGANGLEDOWN,'bspfilename',ALL_EDP.BSPFILENAME,'downlinkant',ALL_EDP.DOWNLINKANTENNA,'downlinkband',ALL_EDP.DOWNLINKBAND,'ertdatetime',ALL_EDP.ERTDATETIME,'ertdoy',ALL_EDP.ERTDOY,'ertsec',ALL_EDP.ERTSEC,'ertyear',ALL_EDP.ERTYEAR,'impactparamavg',ALL_EDP.IMPACTPARAMAVERAGE,'impactparamdown',ALL_EDP.IMPACTPARAMDOWN,'ls3550',ALL_EDP.LS3550,'nelec',ALL_EDP.NELEC,'nxflag',ALL_EDP.NXFLAG,'occareolat',ALL_EDP.OCCAREOCENTRICLAT,'occareolon',ALL_EDP.OCCAREOCENTRICLON,'occfresid',ALL_EDP.OCCFRESID,'occfresidadj',ALL_EDP.OCCFRESIDADJ,'occls',ALL_EDP.OCCLS,'occltst',ALL_EDP.OCCLTST,'occsza',ALL_EDP.OCCSZA,'occtime',ALL_EDP.OCCTIME,'radius',ALL_EDP.RADIUS,'refractivitydown',ALL_EDP.REFRACTIVITYDOWN,'snelec',ALL_EDP.SNELEC,'sza3550',ALL_EDP.SZA3550,'uplinkant',ALL_EDP.UPLINKANTENNA,'uplinkband',ALL_EDP.UPLINKBAND,'utctime3550',ALL_EDP.UTCTIME3550)
  ;Create the h5 file
  filename='maven_rose.h5'
  fileid=H5F_CREATE(filename)


  datatypeID=H5T_IDL_CREATE(datastruct)


  dataspaceID=H5S_CREATE_SIMPLE(1)

  datasetID=H5D_CREATE(fileID,'ROSE',datatypeID,dataspaceID)

  H5D_WRITE,datasetID,datastruct

  H5F_CLOSE,fileID

end