**Free
  CTL-OPT
    DftActGrp(*no)
    DatFmt(*usa);

  DCL-PI WSXUPINVT;
    DCL-PARM Library      char(10) Const;  // Specify Library to populate
  END-PI;

  DCL-S Command varchar(2000) Inz;
  DCL-S MaxID     zoned(7:0);

  Exec SQL SET OPTION COMMIT = *NONE,
                   CloSqlCsr = *EndMod;

  // Tell *SYSOPR that the UPload is executing
  Exec SQL
    CALL  QSYS2/QCMDEXC(
      'SNDMSG MSG(''UPLOADING XREFINVT to Lib:'||trim(:Library)||''') TOUSR(*SYSOPR)');

  // Set the appropriate Library
  Exec SQL
    CALL  QSYS2/QCMDEXC('CHGCURLIB ' || trim(:Library) || '') ;

  // Clean UP any old UPload stuff
  Exec SQL
    DROP TABLE XREFINVTUP;

  Command =  'XLPARSE2/XLSTABLE  XLS(''/KUBE PAK/XLSIMPORT/XREF/export_XREFINVT.xlsx'') ' +
             'FILE(' + %trim(Library) +'/XREFINVTUP) CRTFILE(*YES) HLINES(1)';
  Exec SQL CALL QSYS2/QCMDEXC(:Command);

  // Create the work file and insert the UPloaded data
  Exec SQL  // Delete old versions of uploaded Foregn Key Values
    delete from XREFINVT where trim(XRPVDTP)||int(XRPVDID)||trim(XRFORKEY) in
      (select trim(FLD3)||int(FLD4)||trim(FLD5) from XREFINVTUP);
  Exec SQL  // Delete old versions of uploaded Local Key Values
    delete from XREFINVT where trim(XRPVDTP)||int(XRPVDID)||trim(XRLCLKEY) in
      (select trim(FLD3)||int(FLD4)||trim(FLD7) from XREFINVTUP);

  Exec SQL  // Insert new records into XREFINVT
    INSERT INTO  XREFINVT
      (TABLECROSSREFERENCED, PROVIDEDBYNAME, PROVIDEDBYTYPE, PROVIDEDBYID, FOREIGNKEYVALUE,
       DESCRIPTION, LOCALKEYVALUE, LOCALITEMNUMBER, LOCALITEMSIZE, CREATED_TS, CREATED_BY)
      (SELECT FLD1, trim(FLD2), FLD3, int(trim(FLD4)), trim(FLD5), trim(FLD6), char(trim(FLD7)),
        FLD8, FLD9, current timestamp, current user FROM XREFINVTUP)    ;

  *InLR = *On;
  return;
