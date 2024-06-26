These are files used in the process of creating netCDF files of .sts Mars Global Surveyor Magnetometer data from PDS. Additions are made to the data files (e.g., altitude). Some of the code is in IDL and some is in Python. The development of the code was initially started in 2014, but then the idea of bringing the data to SPDF was started in 2022. This is why the code is separated the way that it is. 
The IDL code focuses on bringing the .sts files to a .sav file with added altitude and time products. The Python code focuses on adding magnetic field magnitude and spacecraft position, while switching file format to netCDFs compatible with SPDF and Pysat. Meta is also added with this code.
Coding and project advice was given by J. Klenzing, A. J. Halford, and J. Espley.
Initial work was done as part of (and follow-up to) a 2014 summer internship at NASA GSFC. T. Esman then became a NASA Postdoctoral Fellow (ORAU) at NASA GSFC in 2022. 
DOI: 10.5281/zenodo.11264417
