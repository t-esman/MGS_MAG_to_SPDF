# -*- coding: utf-8 -*-
"""Module for the MGS instrument.
Properties
----------
platform
    'mgs'
name
    'mag'
#inst_id
 #   'pl','ss','pc'
#tag
#    '','map','premap'
"""

import datetime as dt
import functools
import os
import warnings
import pysat
from pysat.instruments.methods import general as mm_gen
from pysat.instruments.methods import testing as mm_test
import xarray as xr
from ops_mgs.instruments.methods import mgs_mag_meta as mm_mgs
from scipy.io import readsav
import numpy as np
import pandas as pd
# ----------------------------------------------------------------------------
# Instrument attributes

platform = 'mgs'
name = 'mag'
time_resolution = 'high'
#Dictionary keyed by tag with a string description of that dataset
#details in the description might switch to meta later, just keeping track
#default with no tag chosen is Level 1, full mission

tags = {'': 'Level 1 data and ancillary data from the entire mission, dates 1997-09-12 through 2006-11-02',
        'map': 'Level 1 and calibrated time-ordered data and ancillary data from the Mapping phase and all Extended mission phases, dates 1999-03-09 through 2006-11-02.',
        'premap': 'Level 1 and calibrated time-ordered data ancillary data from the Premapping mission period, dates 1997-09-12 through 1999-03-09.'}
     
#Dictionary keyed by inst_id with a list of supported tags for each key. This is coordinate systems: sun-state, payload, and planetocentric.

inst_ids = {'': ['map','premap',''],
            'ss': ['map','premap',''],
            'pl': ['map','premap',''],
            'pc': ['','map','premap']}
pandas_format = False

# Custom Instrument properties
directory_format = os.path.join('{platform}', '{name}', '{tag}')

_test_dates = {id: {'premap': dt.datetime(1998, 1, 9)} for id in inst_ids.keys()}
_test_download = {id: {'premap': False} for id in inst_ids.keys()}


def init(self):
    """Initialize the Instrument object with instrument specific values.
    Runs once upon instantiation.
    Parameters
    -----------
    self : pysat.Instrument
        Instrument class object
    """

    pysat.logger.info(mm_mgs.ackn_str)
    self.acknowledgements = mm_mgs.ackn_str
    self.references = "https://mgs-mager.gsfc.nasa.gov"

    return


def load(fnames, tag=None, inst_id=None):
    """Load MGS data into `` and `pysat.Meta` objects.
    This routine is called as needed by pysat. It is not intended
    for direct user interaction.
    Parameters
    ----------
    fnames : array-like
        iterable of filename strings, full path, to data files to be loaded.
        This input is nominally provided by pysat itself.
    tag : string
        tag name used to identify particular data set to be loaded.
        This input is nominally provided by pysat itself.
    inst_id : string
        Satellite ID used to identify particular data set to be loaded.
        This input is nominally provided by pysat itself.
    Returns
    -------
    data : pds.DataFrame
        A pandas DataFrame with data prepared for the pysat.Instrument
    meta : pysat.Meta
        Metadata formatted for a pysat.Instrument object.
    Note
    ----
    Any additional keyword arguments passed to pysat.Instrument
    upon instantiation are passed along to this routine.
    Examples
    --------
    ::
        inst = pysat.Instrument('icon', 'ivm', inst_id='a', tag='')
        inst.load(2020, 1)
    """

    data = readsav(fnames[0])
    
    
    low_res_shape = np.shape(data['alt_low'])[0]
    
    
    if time_resolution == 'high':
        high_res_shape = np.shape(data['alt_high'])[0]
        array_size = high_res_shape
        time_high = np.array([(dt.datetime(int(data['time_year_high_pl_ss'][i]), 1, 1, int(data['time_hour_high'][i]), int(data['time_min_high'][i]), 
                                  int(data['time_sec_high'][i]),int(data['time_msec_high'][i])) + dt.timedelta(int(data['time_doy_high'][i]) - 1) ) for i in range(len(data['time_year_high_pl_ss']))])
        pdata = pd.DataFrame(index = time_high)
        
        #Edits to bring spacecraft position to high resolution
        high_time_interp = data['unix_time_high']
        low_time_interp = data['unix_time_low']
        sc_position_x_mso = np.interp(high_time_interp,low_time_interp,data['sc_position_x_low_ss'])
        sc_position_y_mso = np.interp(high_time_interp, low_time_interp, data['sc_position_y_low_ss'])
        sc_position_z_mso = np.interp(high_time_interp, low_time_interp, data['sc_position_z_low_ss'])
        try:
            sc_position_x_pc = np.interp(high_time_interp,low_time_interp,data['sc_position_x_low_pc'])
            sc_position_y_pc = np.interp(high_time_interp,low_time_interp,data['sc_position_y_low_pc'])
            sc_position_z_pc = np.interp(high_time_interp,low_time_interp,data['sc_position_z_low_pc'])
        except:
            print('There are missing kernels, which results in missing planetocentric data.')
            pass
        
        pdata['sc_position_x_ss'] = sc_position_x_mso
        pdata['sc_position_y_ss'] = sc_position_y_mso
        pdata['sc_position_z_ss'] = sc_position_z_mso
        
        try:
            pdata['sc_position_x_pc'] = sc_position_x_pc
            pdata['sc_position_y_pc'] = sc_position_y_pc
            pdata['sc_position_z_pc'] = sc_position_z_pc
        except:
            pass
        for key in data.keys(): #why do I do this? this only happens in low
            try:
                if len(data[key]) == array_size:
                    pdata[key] = data[key]
            except TypeError: 
                pass
        DeleteList = []
    else: 
        
        array_size = low_res_shape
        time_low = np.array([(dt.datetime(int(data['time_year_low'][i]), 1, 1, int(data['time_hour_low'][i]), int(data['time_min_low'][i]),
                                 int(data['time_sec_low'][i]),int(data['time_msec_low'][i])) + dt.timedelta(int(data['time_doy_low'][i]) - 1) ) for i in range(len(data['time_year_low']))])
        pdata = pd.DataFrame(index = time_low)
        DeleteList = ['outboard_bd_payload_x_low_pc','outboard_bd_payload_y_low_pc','outboard_bd_payload_range_low_pc',
        'outboard_bd_payload_z_low_pc','outboard_bsc_payload_range_low_pc','outboard_bsc_payload_x_low_pc','outboard_bsc_payload_y_low_pc',
        'outboard_bsc_payload_z_low_pc','sa_negy_current_low_pc','sa_posy_current_low_pc']
    
    for key in data.keys(): #why do I do this? this only happens in low
        try:
            if len(data[key]) == array_size:
                pdata[key] = data[key]
        except TypeError: 
            pass
        
    xdata = xr.Dataset(pdata)
    xdata = xdata.rename(dim_0 = 'time')
    try: 
        xdata = xdata.drop(DeleteList)
    except:
        pass
    
    return_datetime_for_header = dt.datetime.now()
    data = mm_mgs.scrub_MGS(xdata,return_datetime_for_header,time_resolution)
    inst_id = 'all'
    # Add meta here

    header_data = mm_mgs.generate_header(inst_id, return_datetime_for_header,time_resolution)
    meta = mm_mgs.generate_metadata(header_data,time_resolution) #header_data is used here!
    data = data[0]
    return data, meta 


# ----------------------------------------------------------------------------
# Instrument functions
#
# Use the default CDAWeb and pysat methods
# I CHANGED THIS PART BECAUSE IT HAD year:4d
# Set the list_files routine
datestr = '{year:02d}'
secdate = '{doy:03d}'#{month:02d}{day:02d}'
fname = 'm{datestr}d{secdate}.{suffix}'
#fname = 'mgs.{datestr}.vid-{inst_id}.{tag}.v{{version:01d}}.{suffix}'


suffix = {'': 'sav', 'map': 'sav','premap':'sav'}
supported_tags = {}
for inst_id in inst_ids:
    supported_tags[inst_id] = {}
    for tag in tags:
        supported_tags[inst_id][tag] = fname.format(datestr=datestr, tag=tag,
                                                    inst_id=inst_id,
                                                    suffix=suffix[tag],
                                                    secdate = secdate)
list_files = functools.partial(mm_gen.list_files,
                               supported_tags=supported_tags,two_digit_year_break = 40)

# TODO(#3): replace these lines with functional download routines below
def download(date_array, tag, inst_id, data_path=None, **kwargs):
    """Download data (placeholder). Doesn't do anything.
    Parameters
    ----------
    date_array : array-like
        List of datetimes to download data for. The sequence of dates need not
        be contiguous.
    tag : str
        Tag identifier used for particular dataset. This input is provided by
        pysat.
    inst_id : str
        Instrument ID string identifier used for particular dataset. This input
        is provided by pysat.
    data_path : str or NoneType
        Path to directory to download data to. (default=None)
    **kwargs : dict
        Additional keywords supplied by user when invoking the download
        routine attached to a pysat.Instrument object are passed to this
        routine via kwargs.
    Note
    ----
    This routine is invoked by pysat and is not intended for direct use by
    the end user.
    """

    warnings.warn('Not implemented yet. See Issue #3')
    return


clean = functools.partial(mm_test.clean)
