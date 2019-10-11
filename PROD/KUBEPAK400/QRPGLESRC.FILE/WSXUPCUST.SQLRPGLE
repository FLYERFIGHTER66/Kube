**Free
  CTL-OPT
    DftActGrp(*no)
    DatFmt(*usa);

  DCL-PI WSXUPCUST;
    DCL-PARM Library      char(10) Const;  // Specify Library to populate
  END-PI;

  DCL-S Command varchar(2000) Inz;
  DCL-S MaxID     zoned(7:0);

  Exec SQL SET OPTION COMMIT = *NONE,
                   CloSqlCsr = *EndMod;

  // Tell *SYSOPR that the upload is executing
  Exec SQL
    CALL  QSYS2/QCMDEXC(
      'SNDMSG MSG(''UPLOADING XREFCUST to Lib:'||trim(:Library)||''') TOUSR(*SYSOPR)');

  // Set the appropriate Library
  Exec SQL
    CALL  QSYS2/QCMDEXC('CHGCURLIB ' || trim(:Library) || '') ;

  // Clean up any old upload stuff
  Exec SQL
    DROP TABLE XREFCUSTUP;

  Command =  'XLPARSE2/XLSTABLE  XLS(''/KUBE PAK/XLSIMPORT/XREF/export_XREFCUST.xlsx'') ' +
             'FILE(' + %trim(Library) +'/XREFCUSTUP) CRTFILE(*YES) HLINES(1)';
  Exec SQL CALL QSYS2/QCMDEXC(:Command);

  // Create the work file and insert the uploaded data
  Exec SQL // Remove OLD records being updated
    delete from xrefcust where int(XRPVDID)||XRFORKEY in
          (select int(FLD4)||FLD5 from xrefcustup);
  Exec SQL // Insert into XREFCUST
    INSERT INTO  XREFCUST
    (TABLECROSSREFERENCED, PROVIDEDBYNAME,
     PROVIDEDBYTYPE, PROVIDEDBYID, FOREIGNKEYVALUE, DESCRIPTION,
     LOCALKEYVALUE, CREATED_TS, CREATED_BY)
    (SELECT FLD1, FLD2, FLD3, int(trim(FLD4)), FLD5, FLD6, char(int(FLD7)),
     current timestamp, current user FROM xrefcustup);

  *InLR = *On;
  return;
