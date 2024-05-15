;SPLITORB (IDL)
;Judd D. Bowman
;C. David Brown
;Washington University
;November 1999
;
;This IDL procedure splits a multiple-orbit MOLA PEDR file
;into single-orbit PEDR files.  For each orbit found in the
;input file, the procedure will first attempt to locate an
;existing PEDR file and append PEDRs to this file.  If an
;existing PEDR file is not located, the procedure will create
;a new PEDR file.  The input file should not be in the output
;directory because the procedure will attempt to append orbits
;onto the end of the input file.  This procedure has been
;tested in PC and UNIX operating systems.
;
;Inputs:
;
;INPUT_FILE -- The full path of the multiple-orbit MOLA PEDR
;input file.
;
;OUTPUT_DIRECTORY -- The full path of the directory in which
;the procedure will write single-orbit PEDR files.  End the
;path with the appropriate character for your operating system.
;On a PC: 'C:\temp\pedrs\single\'
;On Unix: '/home/user/pedrs/single/'
;
;VERBOSE -- (Optional) Set this keyword to have the procedure
;display its progress in the standard log window as it executes.
;
;LOWERCASE -- (Optional) Set this keyword to force the output
;file name to lower case letters.  Otherwise, the output file
;name will have the case indicated in the header of the input
;file.  This keyword is superceded by the UPPERCASE keyword.
;
;UPPERCASE -- (Optional) Set this keyword to force the output
;file name to upper case letters.  Otherwise, the output file
;name will have the case indicated in the header of the input
;file.  This keyword supercedes the LOWERCASE keyword.


pro splitorb, $
	input_file, $
	output_directory, $
	verbose=verbose, $
	lowercase=lowercase, $
	uppercase=uppercase

	;Declare variables
	file_hdr = bytarr(7760)
	file_pedr = bytarr(776)
	ptr_file_name = long(0)
 ptr_product_id = long(0)
	ptr_orbit_number = long(0)
	orbit_number = long(0)
	new_orbit_number = long(0)
	output_open = long(0)
	output_exists = long(0)
	output_file = ''
	orbit_string = ''
	input_unit = long(0)
	output_unit = long(0)

	;Open the input_file
	openr, input_unit, input_file, /get_lun

	;Update the log
	if keyword_set(verbose) then print, 'Input File: ' + input_file

	;Read the input_file header into file_hdr
	readu, input_unit, file_hdr

	;Determine the pointers into file_hdr
	ptr_file_name = strpos(file_hdr, 'FILE_NAME = ')
	ptr_product_id = strpos(file_hdr, 'PRODUCT_ID = ')
	ptr_orbit_number = strpos(file_hdr, 'ORBIT_NUMBER = ')

	;Pull out the pedrs for each orbit
	while not eof(input_unit) do begin

		;Read the next pedr from the input_file
		readu, input_unit, file_pedr

		;Determine the orbit number of the pedr
		new_orbit_number = long(file_pedr[11]) $
			+ long(256) * (long(file_pedr[10]) $
			+ long(256) * long(file_pedr[9]))

		;Compare orbit numbers
		if new_orbit_number gt orbit_number then begin

			;Replace the orbit_number with the new_orbit_number
			orbit_number = new_orbit_number

			;Convert the orbit_number to a string
			orbit_string = string(format='(I5.5)', orbit_number)

			;Replace the 'FILE_NAME' in the file_hdr
			file_hdr[ptr_file_name + 15] = byte(orbit_string)

			;Replace the 'PRODUCT ID' in the file_hdr
			file_hdr[ptr_product_id + 19] = byte(orbit_string)

			;Replace the 'ORBIT_NUBMER' in the file_hdr
			file_hdr[ptr_orbit_number + 15] = byte(orbit_string)

			;Get the entire output_file_name
			output_file = strmid(file_hdr, ptr_file_name + 13, 10)

			;Force the output file string to the desired case
			if keyword_set(lowercase) then output_file = strlowcase(output_file)
			if keyword_set(uppercase) then output_file = strupcase(output_file)

			;Close the last output file (if one is open)
			if output_open eq 1 then free_lun, output_unit
			output_open = 0

			;Check if the new output_file already exists
			result = findfile(output_directory + output_file, count=output_exists)

			;The output file exists so open it for appending orbits to the end
			if output_exists gt 0 then begin

				;Open the existing output_file
				openu, output_unit, output_directory $
					+ output_file, /get_lun
				output_open = 1

				;Move the file pointer to the end of the file
				output_unit_state = fstat(output_unit)
				point_lun, output_unit, output_unit_state.size

				;Update the log
				if keyword_set(verbose) then print, 'Output File (Exists): ' $
					+ output_directory + output_file

			;The output file does not exist so create it and write the header
			endif else begin

				;Open the new output_file
				openw, output_unit, output_directory $
					+ output_file, /get_lun
				output_open = 1

				;Write the file_hdr to the new output_file
				writeu, output_unit, file_hdr

				;Update the log
				if keyword_set(verbose) then print, 'Output File (New): ' $
					+ output_directory + output_file

			endelse

		endif

		;Write the pedr to the output_file
		writeu, output_unit, file_pedr

	endwhile

	;Close the last output file (if one is open)
	if output_open eq 1 then free_lun, output_unit
	output_open = 0

	;Close the input_file
	free_lun, input_unit

	;Update the log
	if keyword_set(verbose) then print, 'Done.'

end
