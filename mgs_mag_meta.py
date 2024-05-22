# -*- coding: utf-8 -*-
"""Provides metadata specific routines for MGS MAG data.
author: Teresa (Tracy) Esman, teresa.esman@nasa.gov
NASA Postdoctoral Fellow at NASA GSFC
"""
import datetime as dt
import numpy as np
import pysat

ackn_str = ' '.join(('Much of the information provided in this meta data originates from',
                     'text files provided at: https://pds-ppi.igpp.ucla.edu/search/?sc=Mars%20Global%20Surveyor&i=MAG',
                     'within the CATALOG folder and the AAREADME.txt files. ',
                     'The development of the netCDF files was supported by the NASA',
                     'Postdoctoral Program Fellowship awarded to Teresa Esman in 2022. ',
                     'The success of the MGS MAG project is',
                     'owed to, among others, the people listed here: https://mars.nasa.gov/mgs/people/. ',
                     'Addtional information on the MAG dataset can be found at:',
                     'https://mgs-mager.gsfc.nasa.gov/status.html. '
                     'Documentation on MGS MAG data on the PDS has been maintained by',
                     'J.E.P. Connerney, Mark Sharlow, D. Kazden, J. Springborn, and B. Semenov, among',
                     'others. ',
                     'Teresa Esman, now a NPP Fellow at NASA Goddard Space Flight Center,',
                     'compiled MGS MAG low resolution and high resolution',
                     'data products, translated time to unix time, and performed the ',
                     'calculation and interpolation (to high resolution) of the altitude',
                     'data product.'))

def scrub_MGS(data,return_datetime_for_header,time_resolution):
    """Make data labels and epoch compatible with SPASE and pysat.
    Parameters
    ----------
    data : pandas.Dataframe()
        Metadata object containing the default metadata loaded from the sav files.
    Returns
    -------
    data : pandas.Datafram()
        Replacement data object with compatible variable names and epoch.
    """
    # Rename data variables
    
    new_low_key_dict = {'alt_low':'altitude', 'decimal_day_low':'decimal_day',   'outboard_bd_payload_range_low_ss':'dynamic_b_pl_range',
                     'outboard_bd_payload_x_low_ss':'dynamic_bx_lpl',
                     'outboard_bd_payload_y_low_ss':'dynamic_by_lpl','outboard_bd_payload_z_low_ss':'dynamic_bz_lpl',
                     'outboard_bsc_payload_range_low_ss':'static_b_pl_range',
                     'outboard_bsc_payload_x_low_ss':'static_bx_lpl', 'outboard_bsc_payload_y_low_ss':'static_by_lpl',
                     'outboard_bsc_payload_z_low_ss':'static_bz_lpl',
                     'outboard_b_j2000_range_low_pc':'b_range_lpc', 'outboard_b_j2000_range_low_ss':'b_range_lss', 'outboard_b_j2000_x_low_pc':'bx_lpc',
                     'outboard_b_j2000_x_low_ss':'bx_lss',  'outboard_b_j2000_y_low_pc':'by_lpc',
                     'outboard_b_j2000_y_low_ss':'by_lss', 'outboard_b_j2000_z_low_pc':'bz_lpc', 
                     'outboard_b_j2000_z_low_ss':'bz_lss','outboard_rms_range_low_pc':'rms_range_lpc', 'outboard_rms_range_low_ss':'rms_range_lss',
                     'outboard_rms_x_low_pc':'rms_x_lpc',  'outboard_rms_x_low_ss':'rms_x_lss', 
                     'outboard_rms_y_low_pc':'rms_y_lpc', 'outboard_rms_y_low_ss':'rms_y_lss',
                     'outboard_rms_z_low_pc':'rms_z_lpc','outboard_rms_z_low_ss':'rms_z_lss',  
                     'sa_negy_current_low_ss':'sa_neg_y_low',  'sa_output_current_low_ss':'sa_total_low', 
                     'sa_posy_current_low_ss':'sa_plus_y_low',  'sc_position_x_low_pc':'sc_pos_x_lpc', 
                     'sc_position_x_low_ss':'sc_pos_x_lss', 'sc_position_y_low_pc':'sc_pos_y_lpc',
                     'sc_position_y_low_ss':'sc_pos_y_lss', 'sc_position_z_low_pc':'sc_pos_z_lpc',
                     'sc_position_z_low_ss':'sc_pos_z_lss', 'time_doy_low':'doy', 'time_hour_low':'hour', 'time_min_low':'minute',
                     'time_msec_low':'msec',  'time_sec_low':'seconds', 'time_year_low':'year', 'unix_time_low':'unix_time'}   
    
    MISSINGKERNEL_new_low_key_dict = {'alt_low':'altitude', 'decimal_day_low':'decimal_day',   'outboard_bd_payload_range_low_ss':'dynamic_b_pl_range', 
                     'outboard_bd_payload_x_low_ss':'dynamic_bx_lpl',
                     'outboard_bd_payload_y_low_ss':'dynamic_by_lpl','outboard_bd_payload_z_low_ss':'dynamic_bz_lpl', 
                      'outboard_bsc_payload_range_low_ss':'static_b_pl_range',
                     'outboard_bsc_payload_x_low_ss':'static_bx_lpl', 'outboard_bsc_payload_y_low_ss':'static_by_lpl', 
                     'outboard_bsc_payload_z_low_ss':'static_bz_lpl',
                     'outboard_b_j2000_range_low_ss':'b_range_lss',
                     'outboard_b_j2000_x_low_ss':'bx_lss', 'outboard_b_j2000_y_low_ss':'by_lss',
                     'outboard_b_j2000_z_low_ss':'bz_lss','outboard_rms_range_low_ss':'rms_range_lss',
                     'outboard_rms_x_low_ss':'rms_x_lss',  'outboard_rms_y_low_ss':'rms_y_lss',
                     'outboard_rms_z_low_ss':'rms_z_lss',  'sa_negy_current_low_ss':'sa_neg_y_low',  'sa_output_current_low_ss':'sa_total_low',
                     'sa_posy_current_low_ss':'sa_plus_y_low', 'sc_position_x_low_ss':'sc_pos_x_lss',
                     'sc_position_y_low_ss':'sc_pos_y_lss',
                     'sc_position_z_low_ss':'sc_pos_z_lss', 'time_doy_low':'doy', 'time_hour_low':'hour', 'time_min_low':'minute',
                     'time_msec_low':'msec',  'time_sec_low':'seconds', 'time_year_low':'year', 'unix_time_low':'unix_time'}
    
    new_high_key_dict = {'alt_high':'altitude','decimal_day_high':'decimal_day','outboard_b_j2000_range_high_pl_ss':'b_range_hss', 
                         'outboard_b_j2000_x_high_pl_ss':'bx_hss', 'outboard_b_j2000_y_high_pl_ss':'by_hss', 'outboard_b_j2000_z_high_pl_ss':'bz_hss',
                         'outboard_b_payload_range_high_pl_ss':'b_range_high_pl', 'outboard_b_payload_x_high_pl_ss':'bx_high_pl', 
                         'outboard_b_payload_y_high_pl_ss':'by_high_pl', 'outboard_b_payload_z_high_pl_ss':'bz_high_pl', 'time_doy_high':'doy',
                         'time_hour_high':'hour', 'time_min_high':'minute', 'time_msec_high':'msec', 'time_sec_high':'seconds',
                         'time_year_high_pl_ss':'year','unix_time_high':'unix_time'}       

    if time_resolution == 'low':
        try:
            data = data.rename(new_low_key_dict)
        except:
            data = data.rename(MISSINGKERNEL_new_low_key_dict)
        MAG = data['bx_lss'].values**2+data['by_lss'].values**2+data['bz_lss'].values**2
    else:
        data = data.rename(new_high_key_dict)
        MAG = data['bx_hss'].values**2+data['by_hss'].values**2+data['bz_hss'].values**2
  
    return_datetime_for_header = data.time[0]
    data['magnitude'] = (('time'), MAG)

    return data, return_datetime_for_header
    
def generate_header(inst_id, time,time_resolution):
    """Generate the meta header info.
    Parameters
    ----------
    inst_id : str
        The VID of the associated dataset.
    epoch : dt.datetime
        The epoch of the datafile.  Corresponds to the first data point.
    Returns
    -------
    header : dict
        A dictionary compatible with the pysat.meta_header format.  Top-level
        metadata for the file.
--------------------------------------------------------------------
    
    """
    
    month = time.month
    year = time.year
    day = time.day
    
    if month < 10:
        month = '0'+str(month)
    else:
        month = str(month)
    if day < 10:
        day = '0'+str(month)
    else:
        day = str(day)
        
    header = {'Project': 'MEX>Mars Exploration Program',
              'Source_name': 'MGS>Mars Global Surveyor',
              'Discipline': 'Space Physics>Magnetospheric Science, Ionospheric Science',
              'Data_type': 'M0>Modified Data 0', 
              'Descriptor': 'MAG>Magnetometer',
              'Data_version': '1',
              'Logical_file_id': 'MGS_MAG_'+time_resolution+'_'+str(year)+month+day+'_v01.nc', 
              'PI_name': 'M. Acuna',
              'PI_affiliation': 'NASA/GSFC',
              'TEXT': ' '.join(('The Mars Global Surveyor magnetic field instrument consists of dual,',      
                                'triaxial fluxgate magnetometers, capable of measuring fields between',      
                                '+/- 4 nT and +/- 65536 nT. Automated range switching allows the',           
                                'instrument to maintain maximum digital resolution over a wide',             
                                'range of field strengths.',                                                                                                             
                                'The text of this instrument description has been abstracted from the  ',    
                                'instrument paper:',                                                                                                                  
                                ' Acuna, M. A., J. E. P. Connerney, P. Wasilewski, R. P. Lin,   ',          
                                ' K. A. Anderson, C. W. Carlson, J. McFadden, D. W. Curtis, H. Reme,',      
                                ' A. Cros, J. L. Medale, J. A. Sauvaud, C. d\'Uston, S. J. Bauer,',    
                                ' P. Cloutier, M. Mayhew, and N. F. Ness, Mars Observer Magnetic ',  
                                ' Fields Investigation, J. Geophys. Res., 97, 7799-7814, 1992. ')),
              'Instrument_type': 'Magnetic Fields (space)',
              'Mission_group': 'Mars Global Surveyor (MGS)',
              'Logical_source': 'MGS_MAG',
              'Logical_source_description':'Mars Global Surveyor Magnetometer Modified Data',
              'DOI':'10.17189/1519752, 10.17189/1519753, 10.17189/1519754,10.17189/1519755',
              'Time_resolution': '8, 16, and 32 samples/second', 
              'Generated_by': ' '.join(('.sav files generated by Teresa Esman using data in .STS files',
                                        'downloaded via the NASA PDS. netCDF files generated by',
                                        'Teresa Esman NPP Fellow at NASA GSFC.')),
              'Generation_date': dt.datetime.today().strftime('%Y-%m-%d'),
              'Acknowledgement': ackn_str,
              'TITLE': 'Mars Global Surveyor MAG Data',
              'LINK_TEXT': 'MGS MAG magnetic field .STS files from 1997-09-12 through 2006-11-02 are avalible at ',
              'LINK_TITLE': 'MGS MAG',
              'HTTP_LINK': 'https://pds-ppi.igpp.ucla.edu/search/?sc=Mars%20Global%20Surveyor&i=MAG'}

    return header

def generate_metadata(header_data,time_resolution):
    """Generate metadata object for reach l1b data compatible with SPASE and pysat.
    Parameters
    ----------
    header_data : dict
        A dictionary compatible with the pysat.meta_header format.  Required to
        properly initialize metadata.
    Returns
    -------
    metadata : pandas.Dataframe()
        Contains data compatible with SPASE standards to initialize pysat.Meta.
    """
    
    if time_resolution == 'high':
    
        meta = pysat.Meta(header_data=header_data)
        meta['sc_position_x_ss'] = {meta.labels.name: 'Spacecraft Position x in MSO coordinates.',
                                    meta.labels.min_val: -50843,
                                    meta.labels.max_val: 50843,
                                    meta.labels.units: 'km',
                                    meta.labels.desc:'Spacecraft Position x (MSO) [km]'}
        
        meta['sc_position_y_ss']= {meta.labels.name: 'Spacecraft Position y in MSO coordinates.',
                                    meta.labels.min_val: -50843,
                                    meta.labels.max_val: 50843,
                                    meta.labels.units: 'km',
                                    meta.labels.desc: 'Spacecraft Position y (MSO) [km]'}
        
        meta['sc_position_z_ss']= {meta.labels.name: 'Spacecraft Position z in MSO coordinates.',
                                    meta.labels.min_val: -50843,
                                    meta.labels.max_val: 50843,
                                    meta.labels.units: 'km',
                                    meta.labels.desc: 'Spacecraft Position z (MSO) [km]'}
        
        meta['sc_position_x_pc']= {meta.labels.name: 'Spacecraft Position x in planetocentric coordinates.',
                                    meta.labels.min_val: -50843,
                                    meta.labels.max_val: 50843,
                                    meta.labels.units: 'km',
                                    meta.labels.desc: 'Spacecraft Position x (planetocentric) [km]'}
        
        meta['sc_position_y_pc']= {meta.labels.name: 'Spacecraft Position y in planetocentric coordinates.',
                                    meta.labels.min_val: -50843,
                                    meta.labels.max_val: 50843,
                                    meta.labels.units: 'km',
                                    meta.labels.desc: 'Spacecraft Position y (planetocentric) [km]'}
        
        meta['sc_position_z_pc']= {meta.labels.name: 'Spacecraft Position z in planetocentric coordinates.',
                                    meta.labels.min_val: -50843,
                                    meta.labels.max_val: 50843,
                                    meta.labels.units: 'km',
                                    meta.labels.desc:'Spacecraft Position z (planetocentric) [km]'}
        
        meta['altitude'] = {meta.labels.name: 'Altitude',
                   meta.labels.units: 'km',
                   meta.labels.notes: 'High Resolution. Interpolated from low resolution (which uses the radius of Mars = 3389.5 km)',
                   meta.labels.min_val: 100,
                   meta.labels.max_val: 48000,
                   meta.labels.desc: 'Altitude [km]'}
        
        meta['magnitude'] = {meta.labels.name: 'Magnetic Field Magnitude',
                   meta.labels.units: 'nT',
                   meta.labels.min_val: 0,
                   meta.labels.max_val: 2500,
                   meta.labels.notes: 'Magnitude calculated via the square root of the sum of the squares.',
                   meta.labels.desc: 'Magnetic Field Magnitude [nT]'}

        meta['decimal_day'] = {meta.labels.name: 'Decimal Day',
                       meta.labels.units: 'days',
                       meta.labels.min_val: 0.0,
                       meta.labels.max_val: 367,
                       meta.labels.fill_val: -999,
                       meta.labels.desc: 'Decimal Day'}

        meta['b_range_hss'] = {meta.labels.name: 'Magnetic Field Range Sunstate',
                         meta.labels.units: 'none',
                         meta.labels.notes:'sun-state, ss, or MSO',
                         meta.labels.desc: 'Magnetic Field Range',
                         meta.labels.min_val: -10,
                         meta.labels.max_val: 10}
        
        meta['bx_hss'] = {meta.labels.name: 'Magnetic Field X MSO',
                            meta.labels.notes: 'High resolution in sun-state or MSO coordinates. Outboard.',
                            meta.labels.units: 'nT',
                            meta.labels.min_val: -65536,
                            meta.labels.max_val: 65536,
                            meta.labels.fill_val: np.nan,
                            meta.labels.desc: 'Magnetic Field X [nT]'}
        
        meta['by_hss'] = {meta.labels.name: 'Magnetic Field Y MSO',
                               meta.labels.notes: 'High resolution in sun-state or MSO coordinates. Outboard.',
                                  meta.labels.units: 'nT',
                                  meta.labels.min_val: -65536,
                                  meta.labels.max_val: 65536,
                                  meta.labels.fill_val: np.nan,
                                  meta.labels.desc: 'Magnetic Field Y [nT]'}
        
        meta['bz_hss'] = {meta.labels.name: 'Magnetic Field Z MSO',
                                  meta.labels.units: 'nT',
                               meta.labels.notes: 'High resolution in sun-state or MSO coordinates. Outboard.',
                               meta.labels.min_val: -65536,
                               meta.labels.max_val: 65536,
                               meta.labels.fill_val: np.nan,
                               meta.labels.desc: 'Magnetic Field Z [nT]'}
        
        meta['b_range_high_pl'] = {meta.labels.name: 'Magnetic Field Range Payload',
                                   meta.labels.notes:'High resolution in payload coordinates.',
                      meta.labels.units: 'none',
                      meta.labels.min_val: -10,
                      meta.labels.max_val: 10,
                      meta.labels.desc: 'Magnetic Field Range'}
        
        meta['bx_high_pl'] = {meta.labels.name: 'Magnetic Field X Payload',
                               meta.labels.notes: 'High resolution in payload coordinates. Outboard.',
                           meta.labels.units: 'nT',
                           meta.labels.min_val: -65536,
                           meta.labels.max_val: 65536,
                           meta.labels.fill_val: np.nan,
                           meta.labels.desc: 'Magnetic Field X [nT]'}
        
        meta['by_high_pl'] = {meta.labels.name: 'Magnetic Field Y Payload',
                          meta.labels.notes: 'High resolution in payload coordinates. Outboard.',
                               meta.labels.units: 'nT',
                          meta.labels.min_val: -65536,
                          meta.labels.max_val: 65536,
                          meta.labels.fill_val: np.nan,
                          meta.labels.desc: 'Magnetic Field Y [nT]'}
        
        meta['bz_high_pl'] = {meta.labels.name: 'Magnetic Field Z Payload',
                               meta.labels.notes: 'High resolution in payload coordinates. Outboard.',
                        meta.labels.units: 'nT',
                        meta.labels.min_val: -65536,
                        meta.labels.max_val: 65536,
                        meta.labels.fill_val: np.nan,
                        meta.labels.desc: 'Magnetic Field Z [nT]'}

        meta['doy'] = {meta.labels.name: 'Day of Year',
                       meta.labels.units: 'days',
                       meta.labels.min_val: 0,
                       meta.labels.max_val: 366,
                       meta.labels.desc: 'Day of Year'}
        
        meta['hour'] = {meta.labels.name: 'Hour',
                        meta.labels.units: 'hours',
                        meta.labels.min_val: 0.0,
                        meta.labels.max_val: 23.0,
                        meta.labels.desc: 'Hour'}
        
        meta['minute'] = {meta.labels.name: 'Minute',
                            meta.labels.units: 'minutes',
                            meta.labels.min_val: 0,
                            meta.labels.max_val: 59.0,
                            meta.labels.desc: 'Minute'}
        
        meta['msec'] = {meta.labels.name: 'Millisecond',
                            meta.labels.units: 'msec',
                            meta.labels.min_val: 0,
                            meta.labels.max_val: 999.0,
                            meta.labels.desc: 'Millisecond'}
        
        meta['seconds'] = {meta.labels.name: 'Seconds',
                            meta.labels.units: 'sec',
                            meta.labels.min_val: 0,
                            meta.labels.max_val: 59.0,
                            meta.labels.desc: 'Seconds'}
        
        meta['year'] = {meta.labels.name: 'Year',
                            meta.labels.units: 'years',
                            meta.labels.min_val: 1997,
                            meta.labels.max_val: 2006,
                            meta.labels.desc: 'Year'}
        
        meta['unix_time'] = {meta.labels.name: 'Unix Time',
                            meta.labels.units: 'seconds since Jan. 1, 1970',
                            meta.labels.min_val: 0.0,
                            meta.labels.max_val: 1674845411,
                            meta.labels.desc: 'Unix Time'}
    else:
        meta = pysat.Meta(header_data=header_data)

        meta['magnitude'] = {meta.labels.name: 'Magnetic Field Magnitude',
                             meta.labels.units: 'nT',
                             meta.labels.min_val: 0, 
                             meta.labels.max_val: 2500, 
                             meta.labels.notes: 'Magnitude calculated via the square root of the sum of the squares. Low resolution data.',
                             meta.labels.desc: 'Magnetic Field Magnitude [nT]'}

        meta['altitude'] = {meta.labels.name: 'Altitude',
                    meta.labels.units: 'km',
                    meta.labels.notes:'Low Resolution. Calculated as the radius of Mars (= 3389.5 km) subtracted from the spacecraft position.',
                    meta.labels.min_val: 100,
                    meta.labels.max_val: 48000,
                    meta.labels.desc: 'Altitude [km]'}

        meta['decimal_day'] = {meta.labels.name: 'Decimal Day',
                        meta.labels.notes: 'Low resolution', 
                        meta.labels.units: 'days',
                        meta.labels.min_val: 0.0,
                        meta.labels.max_val: 367.0,
                        meta.labels.desc: 'Decimal Day'}
        
        meta['dynamic_b_pl_range'] = {meta.labels.name: 'Dynamic Range',
                        meta.labels.notes: ' '.join(('Gain range of the instrument at the time of',
                                    'the sample. Sample quantization is gain range dependent.',
                                    'A negative value indicate a detail word (versus fullword) entry.')),
                        meta.labels.units: 'none',
                        meta.labels.min_val: -10,
                        meta.labels.max_val: 10,
                        meta.labels.desc: 'Dynamic Range'}
        
        meta['dynamic_bx_lpl'] = {meta.labels.name: 'Dynamic Spacecraft Field X',
                         meta.labels.notes: ' '.join(('Dynamic spacecraft field in payload ',
                                                      'coordinates (this has been removed from',
                                                      'the measured field to compensate for',
                                                      'spacecraft field); see sc_mod.ker at',
                                                      'https://pds-ppi.igpp.ucla.edu/search/view/?f=yes&id=pds://PPI/MGS-M-MAG-3-MAP1_FULLWORD-RES-MAG-V1.0/GEOMETRY',
                                                      'and https://pds-ppi.igpp.ucla.edu/search/view/?f=yes&id=pds://PPI/MGS-M-MAG-3-PREMAP_FULLWORD-RES-MAG-V1.0/GEOMETRY',
                                                      'Low resolution.')),
                         meta.labels.min_val: -65536.0,
                         meta.labels.max_val: 65536.0,
                         meta.labels.units: 'nT',
                         meta.labels.desc: 'Dynamic Spacecraft Field X [nT]'}
        
        meta['dynamic_by_lpl'] = {meta.labels.name: 'Dynamic Spacecraft Field Y',
                                  meta.labels.units: 'nT',      
                                  meta.labels.notes:' '.join(('Dynamic spacecraft field in payload ',
                                                 'coordinates (this has been removed from',
                                                 'the measured field to compensate for',
                                                 'spacecraft field); see sc_mod.ker at',
                                                 'https://pds-ppi.igpp.ucla.edu/search/view/?f=yes&id=pds://PPI/MGS-M-MAG-3-MAP1_FULLWORD-RES-MAG-V1.0/GEOMETRY',
                                                 'and https://pds-ppi.igpp.ucla.edu/search/view/?f=yes&id=pds://PPI/MGS-M-MAG-3-PREMAP_FULLWORD-RES-MAG-V1.0/GEOMETRY',
                                                 'Low resolution.')),
                                  meta.labels.min_val: -65536.0,
                                  meta.labels.max_val: 65536.0,
                                  meta.labels.desc: 'Dynamic Spacecraft Field Y [nT]'}
        
        meta['dynamic_bz_lpl'] = {meta.labels.name:'Dynamic Spacecraft Field Z',
                                  meta.labels.units: 'nT',
                                  meta.labels.notes: ' '.join(('Dynamic spacecraft field in payload ',
                                                              'coordinates (this has been removed from',
                                                               'the measured field to compensate for',
                                                               'spacecraft field); see sc_mod.ker at',
                                                               'https://pds-ppi.igpp.ucla.edu/search/view/?f=yes&id=pds://PPI/MGS-M-MAG-3-MAP1_FULLWORD-RES-MAG-V1.0/GEOMETRY',
                                                               'and https://pds-ppi.igpp.ucla.edu/search/view/?f=yes&id=pds://PPI/MGS-M-MAG-3-PREMAP_FULLWORD-RES-MAG-V1.0/GEOMETRY',
                                                               'Low resolution.')),
                                  meta.labels.min_val: -65536.0,
                                  meta.labels.max_val: 65536.0,
                                  meta.labels.desc: 'Dynamic Spacecraft Field Z [nT]'}
        
        meta['static_b_pl_range'] = {meta.labels.name:'Static Spacecraft Field Range',
                                     meta.labels.units: 'none',
                                     meta.labels.notes: ' ' .join(('Static spacecraft fields are',
                                      'due to permanent magnetization, for example, magnets',
                                      'or magnetized objects.')),
                                     meta.labels.min_val: -10,
                                     meta.labels.max_val: 10,
                                     meta.labels.desc: 'Static Spacecraft Field Range'}
        
        meta['static_bx_lpl'] = {meta.labels.name: 'Static Spacecraft Field X',
                                 meta.labels.units: 'nT',
                                 meta.labels.notes: ' '.join(('Static spacecraft field in payload X coordinates',
                                                  '(this has been removed from the measured field',
                                                  'to compensate for spacecraft fields); see',
                                                  'sc_mod.ker at',
                                                  'https://pds-ppi.igpp.ucla.edu/search/view/?f=yes&id=pds://PPI/MGS-M-MAG-3-MAP1_FULLWORD-RES-MAG-V1.0/GEOMETRY',
                                                  'and https://pds-ppi.igpp.ucla.edu/search/view/?f=yes&id=pds://PPI/MGS-M-MAG-3-PREMAP_FULLWORD-RES-MAG-V1.0/GEOMETRY',
                                                  'Low resolution.')),
                                 meta.labels.min_val: -65536.0,
                                 meta.labels.max_val: 65536.0,
                                 meta.labels.desc: 'Static Spacecraft Field X [nT]'}
        
        meta['static_by_lpl'] = {meta.labels.name: 'Static Spacecraft Field Y',
                                 meta.labels.units: 'nT',
                                 meta.labels.min_val: -65536.0,
                                 meta.labels.max_val: 65536.0,
                                 meta.labels.desc: 'Static Spacecraft Field Y [nT]'}
        
        meta['static_bz_lpl'] = {meta.labels.name: 'Static Spacecraft Field Z',
                                 meta.labels.units: 'nT',
                                 meta.labels.min_val: -65536.0,
                                 meta.labels.max_val: 65536.0,
                                 meta.labels.desc: 'Static Spacecraft Field Z [nT]'}

        meta['b_range_lpc'] = {meta.labels.name: 'Magnetic Field Range Planetocentric',
                            meta.labels.units: 'none',
                            meta.labels.notes:'Planetocentric, low resolution.',
                            meta.labels.min_val: -10,
                            meta.labels.max_val: 10,
                            meta.labels.desc: 'Magnetic Field Range'}
        
        meta['b_range_lss'] = {meta.labels.name: 'Magnetic Field Range MSO',
                              meta.labels.units: 'none',
                              meta.labels.notes: 'Sun-state, ss, or MSO. Low resolution.',
                              meta.labels.min_val: -10,
                              meta.labels.max_val: 10,
                              meta.labels.desc: 'Magnetic Field Range'}
   
        meta['bx_lpc'] = {meta.labels.name: 'Magnetic Field X Planetocentric',
                          meta.labels.units: 'nT',
                          meta.labels.notes: 'Low resolution in planetocentric coordinates. Outboard.',
                          meta.labels.min_val: -65536,
                          meta.labels.max_val: 65536,
                          meta.labels.fill_val: np.nan,
                          meta.labels.desc: 'B_X [nT]'}
        
        meta['bx_lss'] = {meta.labels.name: 'Magnetic Field X MSO',
                          meta.labels.units: 'Low resolution in sun-state or MSO coordinates. Outboard.',
                            meta.labels.units: 'nT',
                            meta.labels.min_val: -65536,
                            meta.labels.max_val: 65536,
                            meta.labels.fill_val: np.nan,
                            meta.labels.desc: 'B_X [nT]'}
  
        meta['by_lpc'] = {meta.labels.name: 'Magnetic Field Y Planetocentric',
                        meta.labels.notes: 'Low resolution in planetocentric coordinates. Outboard.',
                        meta.labels.units: 'nT',
                        meta.labels.min_val: -65536,
                        meta.labels.max_val: 65536,
                        meta.labels.fill_val: np.nan,
                        meta.labels.desc: 'B_Y [nT]'}
        
        meta['by_lss'] = {meta.labels.name: 'Magnetic Field Y MSO',
                          meta.labels.notes: 'Low resolution in sun-state or MSO coordinates. Outboard.',
                          meta.labels.min_val: -65536,
                          meta.labels.max_val: 65536,
                          meta.labels.fill_val: np.nan,
                          meta.labels.desc: 'B_Y [nT]'}

        meta['bz_lpc'] = {meta.labels.name: 'Magnetic Field Z Planetocentric',
                          meta.labels.notes: 'Low resolution in planetocentric coordinates. Outboard.',
                             meta.labels.units: 'nT',
                             meta.labels.min_val: -65536,
                             meta.labels.max_val: 65536,
                             meta.labels.fill_val: np.nan,
                             meta.labels.desc: 'B_Z [nT]'}
        
        meta['bz_lss'] = {meta.labels.name: 'Magnetic Field Z MSO',
                          meta.labels.notes: 'Low resolution in sun-state or MSO coordinates. Outboard.',
                               meta.labels.units: 'nT',
                               meta.labels.min_val: -65536,
                               meta.labels.max_val: 65536,
                               meta.labels.fill_val: np.nan,
                               meta.labels.desc: 'B_Z [nT]'}

        meta['rms_range_lpc'] = {meta.labels.name: 'RMS Range Planetocentric',
                   meta.labels.units: 'none',
                   meta.labels.notes: 'Low resolution, planetocentric.',
                   meta.labels.min_val: -10,
                   meta.labels.max_val: 10,
                   meta.labels.desc: 'RMS Range'}
        
        meta['rms_range_lss'] = {meta.labels.name: 'RMS Range MSO',
                                meta.labels.notes:'Low resolution, sun-state/ss/MSO',
                                meta.labels.units: 'none',
                                meta.labels.min_val: -10,
                                meta.labels.max_val: 10,
                                meta.labels.desc: 'RMS Range'}
        
        meta['rms_x_lpc'] = {meta.labels.name: 'RMS X Planetocentric',
                    meta.labels.notes: ' '.join(('Root mean square of the outboard delta words (there are 23',
                            'delta words between fullwords, sampled at either 32, 16, or 8 per second depending on',
                            'date rate allocation. Planetocentric, low resolution.')),
                    meta.labels.units: 'nT',
                    meta.labels.min_val: -65536,
                    meta.labels.max_val: 65536,
                    meta.labels.fill_val: np.nan,
                    meta.labels.desc: 'RMS X [nT]'}
        
        meta['rms_x_lss'] = {meta.labels.name: 'RMS X MSO',
                     meta.labels.units: 'nT',
                     meta.labels.min_val: -65536,
                     meta.labels.max_val: 65536,
                     meta.labels.fill_val: np.nan,
                     meta.labels.desc: 'RMS X [nT]'}
        
        meta['rms_y_lpc'] = {meta.labels.name: 'RMS Y Planetocentric',
                        meta.labels.units: 'nT',
                        meta.labels.min_val: -65536,
                        meta.labels.max_val: 65536,
                        meta.labels.fill_val: np.nan,
                        meta.labels.desc: 'RMS Y [nT]'}
    
        meta['rms_y_lss'] = {meta.labels.name: 'RMS Y MSO',
                            meta.labels.notes:'Low resolution, sun-state/ss/MSO',
                        meta.labels.units: 'nT',
                        meta.labels.min_val: -65536,
                        meta.labels.max_val: 65536,
                        meta.labels.fill_val: np.nan,
                        meta.labels.desc: 'RMS Y [nT]'}
        
        meta['rms_z_lpc'] = {meta.labels.name: 'RMS Z Planetocentric',
                            meta.labels.notes:'Low resolution, planetocentric.',
                        meta.labels.units: 'nT',
                        meta.labels.min_val: -65536,
                        meta.labels.max_val: 65536,
                        meta.labels.fill_val: np.nan,
                        meta.labels.desc: 'RMS Z [nT]'}
        
        meta['rms_z_lss'] = {meta.labels.name: 'RMS Z MSO',
                        meta.labels.units: 'nT',
                        meta.labels.notes: 'Low resolution, sun-state/ss/MSO',
                        meta.labels.min_val: -65536,
                        meta.labels.max_val: 65536,
                        meta.labels.fill_val: np.nan,
                        meta.labels.desc: 'RMS Z [nT]'}

   
        meta['sa_neg_y_low'] = {meta.labels.name: 'Solar Array Negative Y Current',
                        meta.labels.notes:' '.join(('Solar array (-Y panel) current from sc engineering data base.',
                                                  'A fill value of',
                                                     '\'-99\' is used when the solar array currents',
                                                     'are negative.\'-999\' is used as a fill value',
                                                     'when the data is not available for the time.')),
                        meta.labels.units: 'mA',
                        meta.labels.min_val: 0,
                        meta.labels.max_val: 30000,
                        meta.labels.fill_val: -999.,
                        meta.labels.desc: 'SA Neg Y Current [mA]'}
        
        meta['sa_total_low'] = {meta.labels.name: 'Total Solar Array Current',
                        meta.labels.units: 'mA',
                           meta.labels.notes:' '.join(('Solar array output current (total) from sc engineering data base.',
                                                'A fill value of',
                                                     '\'-99\' is used when the solar array currents',
                                                     'are negative.\'-999\' is used as a fill value',
                                                     'when the data is not available for the time.')),
                        meta.labels.min_val: 0,
                        meta.labels.max_val: 30000.0,
                        meta.labels.fill_val: -999.,
                        meta.labels.desc: 'Total SA Current [mA]'}
  
        meta['sa_plus_y_low'] = {meta.labels.name: 'Solar Array Positive Y Current',
                        meta.labels.units: 'mA',
                        meta.labels.notes:' '.join(('Solar array (+Y panel) current from sc',
                                                     'engineering data base. A fill value of',
                                                     '\'-99\' is used when the solar array currents',
                                                     'are negative. \'-999\' is used as a fill value',
                                                     'when the data is not available for the time.')),
                        meta.labels.min_val: 0,
                        meta.labels.max_val: 30000.0,
                        meta.labels.fill_val: -999.,
                        meta.labels.desc: 'SA Plus Y Current [mA]'}
    
        meta['sc_pos_x_lpc'] = {meta.labels.name: 'Spacecraft Position X Planetocentric',
                        meta.labels.notes: 'Low resolution in planeocentric coordinates.',
                        meta.labels.units: 'km',
                        meta.labels.min_val: -51000.0,
                        meta.labels.max_val: 51000.0,
                        meta.labels.fill_val: np.nan,
                        meta.labels.desc: 'SC Position X [km]'}
        
        
        meta['sc_pos_x_lss'] = {meta.labels.name: 'Spacecraft Position X MSO',
                                    meta.labels.notes: 'Low resolution in sun-state or MSO coordinates.',
                        meta.labels.units: 'km', 
                        meta.labels.min_val: -51000.0,
                        meta.labels.max_val: 51000.0,
                        meta.labels.fill_val: np.nan,
                        meta.labels.desc: 'SC Position X [km]'}
        
        meta['sc_pos_y_lpc'] = {meta.labels.name: 'Spacecraft Position Y Planetocentric',
                        meta.labels.notes: 'Low resolution in planetocentric coordinates.',
                        meta.labels.units: 'km',
                        meta.labels.min_val: -51000.0,
                        meta.labels.max_val: 51000.0,
                        meta.labels.fill_val: np.nan,
                        meta.labels.desc: 'SC Position Y [km]'}
        
        meta['sc_pos_y_lss'] = {meta.labels.name: 'Spacecraft Position Y MSO',
                                              meta.labels.notes: 'Low resolution in sun-state or MSO coordinates.',
                        meta.labels.units: 'km',
                        meta.labels.min_val: -51000.0,
                        meta.labels.max_val: 51000.0,
                        meta.labels.fill_val: np.nan,
                        meta.labels.desc: 'SC Position Y [km]'}
        
        meta['sc_pos_z_lpc'] = {meta.labels.name: 'Spacecraft Position Z Planetocentric',
                        meta.labels.notes: 'Low resolution in planetocentric coordinates.',
                        meta.labels.units: 'km',
                        meta.labels.min_val: -51000.0,
                        meta.labels.max_val: 51000.0,
                        meta.labels.fill_val: np.nan,
                        meta.labels.desc: 'SC Position Z [km]'}
        
        meta['sc_pos_z_lss'] = {meta.labels.name: 'Spacecraft Position Z MSO',
                       meta.labels.notes: 'Low resolution in sun-state or MSO coordinates.',
                       meta.labels.units: 'km',
                       meta.labels.min_val: -51000.0,
                       meta.labels.max_val: 51000.0,
                       meta.labels.fill_val: np.nan,
                       meta.labels.desc: 'SC Position Z [km]'}


      
        meta['doy'] = {meta.labels.name: 'Day of Year',
                       meta.labels.notes: 'Low resolution',
                       meta.labels.units: 'days',
                       meta.labels.min_val: 0.0,
                       meta.labels.max_val: 90.0,
                       meta.labels.desc: 'Day of Year'}

        meta['hour'] = {meta.labels.name: 'Hour',
                        meta.labels.units: 'hours',
                        meta.labels.notes: 'Low resolution',
                        meta.labels.min_val: 0,
                        meta.labels.max_val: 23,
                        meta.labels.desc: 'Hour'}

        meta['minute'] = {meta.labels.name: 'Minute',
                        meta.labels.units: 'minutes',
                        meta.labels.min_val: 0,
                        meta.labels.max_val: 59.0,
                        meta.labels.desc: 'Minute'}

        meta['msec'] = {meta.labels.name: 'Millisecond',
                        meta.labels.units: 'msec',
                        meta.labels.min_val: 0,
                        meta.labels.max_val: 999.0,
                        meta.labels.desc: 'Millisecond'}

        meta['seconds'] = {meta.labels.name: 'Seconds',
                        meta.labels.units: 'seconds',
                        meta.labels.notes:'Low resolution',
                        meta.labels.min_val: 0,
                        meta.labels.max_val: 59.0,
                        meta.labels.desc: 'Seconds'}

        meta['year'] = {meta.labels.name: 'Year',
                        meta.labels.notes:'Low resolution',
                        meta.labels.units: 'years',
                        meta.labels.min_val: 1997,
                        meta.labels.max_val: 2006,
                        meta.labels.desc: 'Year'}

        meta['unix_time'] = {meta.labels.name: 'Unix Time',
                             meta.labels.notes:'Low resolution.',
                        meta.labels.units: 'seconds since Jan. 1, 1970',
                        meta.labels.min_val: 0.0,
                        meta.labels.max_val: 1674845411,
                        meta.labels.desc: 'Unix Time'}
        
    return meta
