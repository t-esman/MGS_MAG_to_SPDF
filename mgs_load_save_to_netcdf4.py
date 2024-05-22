# -*- coding: utf-8 -*-
"""
I don't think this is needed? Unconfirmed
Created on Wed Feb 22 13:57:34 2023

@author: tesman
"""
import pysat
from pysat.utils.registry import register
import ops_mgs
register.register_by_module(ops_mgs.instruments)
mgs = pysat.Instrument(platform= 'mgs',name = 'mag',directory_format = '/Users/tesman/Desktop/TESMAN/NPP_WORK/MGS/COMPILATION_FILES_PREMAP/', file_format = 'm{year:2d}d{doy:003d}.sav')
file = 'm98d223.sav'
mgs.load(fname = file)
mgs.data
mgs.data_low = mgs.data.drop(['altitude','decimal_day', 'b_range_hss',
                                 'b_range_high_pl', 'bx_hss','by_hss','bz_hss',
                                 'bx_high_pl','by_high_pl','bz_high_pl','doy',
                                 'hour','minute','seconds','msec','year','unix_time_high',
                                 'time','magnitude'])

mgs.data_high = mgs.data.drop(['altitude_low','day', 'decimal_day_low', 'dynamic_b_pl_range_low', 
                     'dynamic_bx_lpl', 'dynamic_by_lpl','dynamic_bz_lpl', 'static_b_pl_range_low', 
                     'static_bx_lpl', 'static_by_lpl', 'static_bz_lpl',  'b_range_lpc', 'b_range_lss', 
                     'bx_lpc', 'bx_lss', 'by_lpc', 'by_lss', 'bz_lpc', 'bz_lss', 'rms_range_lpc', 
                     'rms_range_lss', 'rms_x_lpc', 'rms_x_lss', 'rms_y_lpc', 'rms_y_lss', 'rms_z_lpc',
                     'rms_z_lss', 'radius_of_mars', 'sa_-y_low', 'sa_total_low', 'sa_+y_low', 
                     'sc_pos_x_lpc', 'sc_pos_x_lss', 'sc_pos_y_lpc', 'sc_pos_y_lss', 'sc_pos_z_lpc', 
                     'sc_pos_z_lss','doy_low','hour_low', 'minute_low', 'msec_low', 'seconds_low', 
                     'year_low', 'unix_time_low'])
