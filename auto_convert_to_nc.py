# -*- coding: utf-8 -*-
"""
Created on Mon Feb 20 13:03:46 2023
Last editted: 05/22/2024

@author: Teresa (Tracy) Esman
NASA Postdoctoral Fellow at NASA GSFC

Warnings -
There is no planetocentric low resolution data for m99d080. 
m03d308 (11/04/2003) has non-monotonically increasing data
and has to be re-made (for PDS). 

"""

import pysat
import os
import numpy as np
from datetime import datetime 

time_resolution = 'high'

mgs = pysat.Instrument(platform= 'mgs',name = 'mag',
                       directory_format = '/Volumes/EsmanData/COMPILATION_FILES/', 
                       file_format = 'm{year:02d}d{day:03d}.sav', labels = {'units':('UNITS',str), 'name':('CATDESC',str), 
                                                     'notes':('VAR_NOTES',str),
                                                     'desc':('FIELDNAM',str),
                                                     'min_val':('VALIDMIN',np.float64),
                                                     'max_val':('VALIDMAX',np.float64)})

# Use meta translation table to include SPDF preferred format.
# Note that multiple names are output for compliance with Pysat.
# Using the most generalized form for labels for future compatibility.

meta_dict = {mgs.meta.labels.min_val: ['VALIDMIN'],
             mgs.meta.labels.max_val: ['VALIDMAX'],
             mgs.meta.labels.units: ['UNITS'],
             mgs.meta.labels.name: ['CATDESC'],
             mgs.meta.labels.desc: ['FIELDNAM','LABLAXIS'],
             mgs.meta.labels.notes: ['VAR_NOTES'],
             'Depend_0': ['DEPEND_0'],
             'Format': ['FORMAT'],
             'Monoton': ['MONOTON'],
             'Var_Type': ['VAR_TYPE'],
             'Display_Type':['DISPLAY_TYPE']}

def day_of_year_to_date(day_of_year, year):
    try:
        date_obj = datetime.strptime(f"{year}-{day_of_year}", "%Y-%j")
        return date_obj.month, date_obj.day
    except ValueError:
        raise ValueError("Invalid day of year or year provided.")

def add_str_zero(value):
    if value < 10:
        value = '0'+str(value)
    else:
        value = str(value)
    return value

for i in range(0, len(mgs.files.files)):
        mgs.load(fname = mgs.files.files[i],use_header = True)
        data = mgs.data
        print(mgs.files.files[i])
        year = mgs.files.files[i][1:3]
        doy = mgs.files.files[i][4:7]
        print(doy)
        day_of_year = int(doy)
        
        if int(year) > 40:
            year_convert = int(year) + 1900
        else:
            year_convert = int(year) + 2000
            
        month, day = day_of_year_to_date(day_of_year, year_convert)
        day = add_str_zero(day)
        month = add_str_zero(month)
            
        if time_resolution == 'high':
            #Example file: mgs_m0_mag_low_19970914_v01
            save_file = '/Users/username/foldername/MGS/netcdf4/HIGHRES/MGS_MAG_high_{}'.format((''.join((str(year_convert),month,day,'_v01.nc4'))))
        else:
            save_file = '/Users/username/foldername//MGS/netcdf4/FULLWORD/MGS_MAG_low_{}'.format((''.join((str(year_convert),month,day,'_v01.nc4'))))
        
        if os.path.exists(save_file):
            os.remove(save_file)
        modeType = 'w'

        if mgs.empty:
            print('Warning: No data has been loaded.')
        pysat.utils.io.inst_to_netcdf(mgs, save_file, mode = modeType, epoch_name = 'time', meta_translation = meta_dict)
  
