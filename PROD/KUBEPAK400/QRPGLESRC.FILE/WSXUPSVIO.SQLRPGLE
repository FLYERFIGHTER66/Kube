**Free
  CTL-OPT
    DftActGrp(*no)
    DatFmt(*usa);

  DCL-PI WSXUPSVIO;
    DCL-PARM Library      char(10) Const;  // Specify Library to populate
  END-PI;

  DCL-S Command varchar(2000) Inz;
  DCL-S MaxID     zoned(7:0);

  Exec SQL SET OPTION COMMIT = *NONE,
                   CloSqlCsr = *EndMod;

  // Tell *SYSOPR that the UPload is executing
  Exec SQL
    CALL  QSYS2/QCMDEXC(
      'SNDMSG MSG(''UPLOADING XREFSVIO to Lib:'||trim(:Library)||''') TOUSR(*SYSOPR)');

  // Set the appropriate Library
  Exec SQL
    CALL  QSYS2/QCMDEXC('CHGCURLIB ' || trim(:Library) || '') ;

  // Clean UP any old UPload stuff
  Exec SQL
    DROP TABLE XREFSVIOUP;

  Command =  'XLPARSE2/XLSTABLE  XLS(''/KUBE PAK/XLSIMPORT/XREF/export_XREFSVIO.xlsx'') ' +
             'FILE(' + %trim(Library) +'/XREFSVIOUP) CRTFILE(*YES) HLINES(1)';
  Exec SQL CALL QSYS2/QCMDEXC(:Command);

  // Create the work file and insert the UPloaded data
  Exec SQL  // Clear old Values from file for uploaded SVIO
    delete from XREFSVIO where int(XRPVDID)||XRFORKEY in
             (select int(FLD4)||FLD5 from XREFSVIOUP);
  Exec SQL  // Insert new values into XREFSVIO
    INSERT INTO  XREFSVIO
     (TABLECROSSREFERENCED, PROVIDEDBYNAME, PROVIDEDBYTYPE, PROVIDEDBYID,
      FOREIGNKEYVALUE, DESCRIPTION, LOCALKEYVALUE, CREATED_TS, CREATED_BY)
     (SELECT trim(FLD1, trim(FLD2, trim(FLD3, int(trim(FLD4)), trim(FLD5, trim(FLD6, trim(FLD7,
      current timestamp, current user FROM XREFSVIOUP);

  *InLR = *On;
  return;
