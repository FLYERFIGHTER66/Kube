**Free
  CTL-OPT
    DftActGrp(*no)
    DatFmt(*usa);

  DCL-PI WSXUPSVIA;
    DCL-PARM Library      char(10) Const;  // Specify Library to populate
  END-PI;

  DCL-S Command varchar(2000) Inz;
  DCL-S MaxID     zoned(7:0);

  Exec SQL SET OPTION COMMIT = *NONE,
                   CloSqlCsr = *EndMod;

  // Tell *SYSOPR that the UPload is executing
  Exec SQL
    CALL  QSYS2/QCMDEXC(
      'SNDMSG MSG(''UPLOADING XREFSVIA to Lib:'||trim(:Library)||''') TOUSR(*SYSOPR)');

  // Set the appropriate Library
  Exec SQL
    CALL  QSYS2/QCMDEXC('CHGCURLIB ' || trim(:Library) || '') ;

  // Clean UP any old UPload stuff
  Exec SQL
    DROP TABLE XREFSVIAUP;

  Command =  'XLPARSE2/XLSTABLE  XLS(''/KUBE PAK/XLSIMPORT/XREF/export_XREFSVIA.xlsx'') ' +
             'FILE(' + %trim(Library) +'/XREFSVIAUP) CRTFILE(*YES) HLINES(1)';
  Exec SQL CALL QSYS2/QCMDEXC(:Command);

  // Create the work file and insert the UPloaded data
  Exec SQL  // Clear old Values from file for uploaded SVIA
    delete from XREFSVIA where int(XRPVDID)||XRFORKEY in
             (select int(FLD4)||FLD5 from XREFSVIAUP);
  Exec SQL  // Insert new values into XREFSVIA
    INSERT INTO  XREFSVIA
     (TABLECROSSREFERENCED, PROVIDEDBYNAME, PROVIDEDBYTYPE, PROVIDEDBYID,
      FOREIGNKEYVALUE, DESCRIPTION, LOCALKEYVALUE, CREATED_TS, CREATED_BY)
     (SELECT FLD1, FLD2, FLD3, int(trim(FLD4)), FLD5, FLD6, FLD7,
      current timestamp, current user FROM XREFSVIAUP);

  *InLR = *On;
  return;
