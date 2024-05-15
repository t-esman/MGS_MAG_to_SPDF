;+
; NAME:
; read_cdf_file
; A simple CDF reader that is generic and should be able to read most cdf files
;
; CALLING SEQUENCE:
;  read_cdf_file, filename
;
; INPUTS:
;   filename - A fully qualified filename (including directory path) pointing to a cdf file
;
; OPTIONAL INPUTS:
;  none
;
; KEYWORD PARAMETERS:
;  none
;
; OUTPUTS:
; The output is an IDL structure containing the contents of the CDF file
;
; EXAMPLE:
;   a = Read_cdf_file("/spgmaven/data/sci/euv/l2/2015/06/mvn_euv_l2_bands_20150623_v04_r01.cdf")
;
;
; PROCEDURE:
;
; MODIFICATION HISTORY:
;  11/2015 BDT Original file creation
;
;
;
;-

FUNCTION Getglobal, id

  CDF_CONTROL, Id, GET_NUMATTRS = numAttrs
  GlobalAttributes = STRARR(numAttrs[0])
  FOR attrNum = 0, numAttrs[0]-1 DO BEGIN
    CDF_ATTINQ, Id, attrNum, attName, Scope, MaxEntry
    Result = CDF_ATTEXISTS( Id, attName, attrNum )
    IF result EQ 0 THEN BEGIN
      attId = CDF_ATTNUM(Id, attName)
      ;     CDF_ATTGET, Id, attName, CDF_ATTNUM(Id, attId), Value
      CDF_ATTGET, Id, attName, 0, Value
    ENDIF ELSE BEGIN
      CDF_ATTGET, Id, attName, attrNum, Value
    ENDELSE
    PRINT, attName +  ", " +  STRING(value[0])
    GlobalAttributes[attrNum] += attName +  ": " +  STRING(value[0])
  ENDFOR
  RETURN, GlobalAttributes
END

FUNCTION Getattr, id, inq, varID

  FOR attrNum = 0, inq.natts-1 DO BEGIN
    ; Read the variable attribute
    CDF_ATTGET_ENTRY, id, attrNum, varID, attType, value, $
      status, /ZVARIABLE, CDF_TYPE=cdfType, $
      ATTRIBUTE_NAME=attName
    IF STATUS NE 1 THEN CONTINUE
    PRINT, attName +  ", " +  cdfType + ", " +  STRING(value[0])
    IF SIZE( varAttributes, /TYPE ) EQ 0 THEN BEGIN
      varAttributes = [ attName +  ", " +  cdfType + ", " +  STRING(value[0]) ]
    ENDIF ELSE BEGIN
      varAttributes = [ attName +  ", " +  cdfType + ", " +  STRING(value[0]), varAttributes ]
    ENDELSE
  ENDFOR
  RETURN, varAttributes
END

FUNCTION Read_cdf_file, cdf_file

  fileID = CDF_OPEN(cdf_file, /READONLY)
  genInfo = CDF_INQUIRE(fileID)
  GlobalAttributes = Getglobal( fileID )

  ; Walk through all of the zVariables
  IF genInfo.nzvars LE 0 THEN RETURN, CREATE_STRUCT( "Global_ATT", GlobalAttributes )

  FOR varNum = 0, genInfo.nzvars-1 DO BEGIN
    varInfo = CDF_VARINQ( fileID, varNum, /ZVARIABLE)
    varName = REFORM(varInfo.Name)
    CDF_CONTROL, fileID, GET_VAR_INFO = varInfoCont, VARIABLE = varName, /ZVARIABLE

    IF varInfoCont.MAXREC GT 0 THEN BEGIN
      CDF_VARGET, fileID, VarName, varD, REC_COUNT=varInfoCont.MAXREC, /ZVARIABLE
    ENDIF ELSE BEGIN
      CDF_VARGET, fileID, VarName, varD, /ZVARIABLE
    ENDELSE

    varData = REFORM( varD )
    IF varNum EQ 0 THEN BEGIN
      theStruct = CREATE_STRUCT( varName, varData )
    ENDIF ELSE BEGIN
      theStruct = CREATE_STRUCT( varName, varData, theStruct )
    ENDELSE

    counter = 0L
    FOR attrNum = 0, genInfo.natts-1 DO BEGIN
      ; Read the variable attribute
      CDF_ATTGET_ENTRY, fileID, attrNum, varNum, attType, value, $
        status, /ZVARIABLE, CDF_TYPE=cdfType, $
        ATTRIBUTE_NAME=attName
      IF STATUS NE 1 THEN CONTINUE
      IF counter EQ 0 THEN BEGIN
        struct_name = varName + '_ATT'
        aTTStruct = CREATE_STRUCT( attName, value)
      ENDIF ELSE BEGIN
        aTTStruct = CREATE_STRUCT( attName, value, attStruct )
      ENDELSE
      counter ++
    ENDFOR
    theStruct = CREATE_STRUCT( theStruct, struct_name, aTTStruct )
    aTTStruct = 0
  ENDFOR

  CDF_CLOSE, fileID
  theStruct = CREATE_STRUCT( 'Global_Att', GlobalAttributes, theStruct )
  RETURN, theStruct
END