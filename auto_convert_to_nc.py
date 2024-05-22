#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Feb 20 13:03:46 2023
Note (May 1 2023): Remember Jonathon sent an email before EGU
and see if I should be making these files with/without fixing the fillval issue. 
Also Jeff suggested using a different branch of pysat for the fillval issue, but
I'm not really sure what that means and I think the last time I checked the branch
was gone, so maybe just update pysat?
Also 2006 High res data is missing. Emailed PDS. 
@author: tesman

m99d068 doesn't have the alt_high variable- it has alt_low... is this kernel related? or?

m99d080 breaks - not for not having alt_high, but this is a known kernel issue day. 



m99d080 should not have pc information 

This is questionable... I was having some issues keeping track of days that day
When I load the .sav file, m99d080 or 03/21/1999 has alt_high and pc variables
When I ran this code with time_resolution = 'low', for m99d080 I got an error
saying that there was no 'alt_high'.

There is no planetocentric low resolution data for m99d080. 

So for the high resolution, is it keeping the previous day data? No. 

The compilation files are separated by date only. 
The files should have high and low resolution data when available. 
The files should have ss and pc and pl data when available. 

The error i got about sc position was about array size, which supports the 
idea that old data is being kept in unoccupied variables. For some reason this
is happening for high resolution and now low resolution. 


np.size(data['sc_position_x_low_pc'])
Out  [23]: 77328

np.size(data['sc_position_x_low_ss'])
Out  [24]: 77248

np.size(data['alt_high'])
Out  [27]: 1853952

?????????????????????????????

previous day

np.size(data['alt_high'])
Out  [36]: 1968000

np.size(data['sc_position_x_low_ss'])
Out  [37]: 82000

np.size(data['sc_position_x_low_pc'])
Out  [38]: 82000



"""

import pysat
#import ops_mgs
#from pysat.utils import registry
import os
import numpy as np
from datetime import datetime 

time_resolution = 'high'
#registry.register_by_module(ops_mgs.instruments)

mgs = pysat.Instrument(platform= 'mgs',name = 'mag',
                       directory_format = '/Volumes/EsmanData/COMPILATION_FILES/', 
                       file_format = 'm{year:02d}d{day:03d}.sav', labels = {'units':('UNITS',str), 'name':('CATDESC',str), 
                                                     'notes':('VAR_NOTES',str),
                                                     'desc':('FIELDNAM',str),
                                                     'min_val':('VALIDMIN',np.float64),
                                                     'max_val':('VALIDMAX',np.float64)})

# Use meta translation table to include SPDF preferred format
# Note that multiple names are output for compliance with pysat.
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




"""
some issues

The first and second day m97d257 and m97d258 have weird sine wave looking data (even in the idl .sav files)
unknown if in the original .sts files

Other days appear to be exactly the same in the .nc4 files, but different in .sav files. Except for 
m97d257 and m97d258? 
Haven't looked at all the days....

Is there a reason it's loading and saving the same day? or changing the data in some way?'

are we running into none type and so the last day gets saved??? but data is nonetype so why would it save data? 
also why is it not printing the warning about no data? 




so if there isn't pc data.... you can still get altitude right? because of ss? I mean that's where altitude 
comes from anyway.... MSO
so why was there an issue with alt_high not existing? 
the alt_high not existing is happening with 99d067 (but i think it happened before???) but maybe that was 
also 067



unrelated to this code: maven on spdf is not in SPASE


10/03/2023
So sounds like i have to check m99d067 and m99d080
Well m99d067 doesn't exist IN HIGH RES. m99d067 exists in 
LOW RES PC and LOW RES SS, so this is why it doesn't have alt_high. 
But the .nc high res file has high res data? How?
3/8/1999
The .sav file is small compared to the other files. Makes sense
Cannot make the m99d067 save again? Is this in PREMAP??? YES IT IS. THIS IS THE SOLUTION FOR THE m99d067 ISSUE. 

Now check m99d080:
    So m99d080 high resolution map data exists. 
    3/21/1999
    Again a .nc file exists, but the code doesn't run. THE SOLUTION TO THIS PROBLEM IS ME USING RANGE INCORRECTLY
    m99d080 IS FINE, IT JUST DOESNT HAVE PC DATA

THE ISSUE NOW (10/3/2023) is m03d308 non-mono:
The 1601 file is the one with the non-monotonically increasing data. what is the date for this? 
The date is m03d308, 11/4/2003
So Jacob suggested maybe the load_mag for .sts files is making up dates or something similar because of 
column or header issues, but this issue is happening with the pysat part of the data, which means it is being
opened by readsav and not the load_mag. So it seems like either the file actually has non-mono data and/or readsav is 
also making up dates? 
But I can't open the original file because it's .sts
  Loaded data is not monotonically increasing.  To continue to use data,set inst.strict_time_flag=False before loading data
  I think I just save it non-mono and ... ask jared to open? 

"""
for i in range(1612, len(mgs.files.files)):
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
            #mgs_m0_mag_low_19970914_v01
            save_file = '/Users/tesman/Desktop/TESMAN/NPP_WORK/MGS/netcdf4/HIGHRES/MGS_MAG_high_{}'.format((''.join((str(year_convert),month,day,'_v01.nc4'))))
        else:
            save_file = '/Users/tesman/Desktop/TESMAN/NPP_WORK/MGS/netcdf4/FULLWORD/MGS_MAG_low_{}'.format((''.join((str(year_convert),month,day,'_v01.nc4'))))
        
        if os.path.exists(save_file):
            os.remove(save_file)
        modeType = 'w'

        if mgs.empty:
            print('Warning: No data has been loaded.')
        pysat.utils.io.inst_to_netcdf(mgs, save_file, mode = modeType, epoch_name = 'time', meta_translation = meta_dict)

        print(i)
        