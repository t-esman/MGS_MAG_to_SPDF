pro loadLowAltCSV,data,date,length,altitude,latitude,longitude,coneangle,LPWdensbefore,LPWdensafter,LPWdensMAXduring,LPWtempbefore,LPWtempafter,LPWtempMAXduring,SZA

  testfile='/Users/tesman/Dropbox/IDL/LowAltCode/LowAltCompiledCSV.csv'
  data = READ_CSV(testfile, HEADER=SedHeader, $
    N_TABLE_HEADER=1, TABLE_HEADER=SedTableHeader)

date = data.field03(0:51)
length = data.field06(0:51)
altitude = data.field07(0:51)
latitude = data.field08(0:51)
longitude = data.field09(0:51)
coneangle = data.field10(0:51)
LPWdensbefore = data.field16(0:51)
LPWdensMAXduring = data.field17(0:51)
LPWdensafter = data.field18(0:51)
LPWtempbefore = data.field20(0:51)
LPWtempMAXduring = data.field21(0:51)
LPWtempafter = data.field22(0:51)
SZA = data.field28(0:51)
end