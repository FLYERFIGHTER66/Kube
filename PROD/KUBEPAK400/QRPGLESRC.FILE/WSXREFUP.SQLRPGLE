**Free
  CTL-OPT
    DftActGrp(*no)
    DatFmt(*usa);

  DCL-PI WSXREFUP;
    DCL-PARM fileToUpload char(10) Const;  // Specify file to upload
    DCL-PARM Library      char(10) Const;  // Specify Library to populate
  END-PI;

  DCL-S Command varchar(2000) Inz;
  DCL-S MaxID     zoned(7:0);

  Exec SQL SET OPTION COMMIT = *NONE,
                   CloSqlCsr = *EndMod;

  // Tell *SYSOPR that the upload is executing
  Exec SQL
    CALL  QSYS2/QCMDEXC(
      'SNDMSG MSG(''UPLOADING FILE:'||trim(:Library)||'/'
         ||trim(:fileToUpload)||''') TOUSR(*SYSOPR)');

  // Set the appropriate Library
  Exec SQL
    CALL  QSYS2/QCMDEXC('CHGCURLIB ' || trim(:Library) || '') ;

  // Clean up any old stuff
  Exec SQL
    DROP TABLE QTEMP/XREFUPLOAD;

  // Get the new upload file
  Command =  'XLPARSE2/XLSTABLE  XLS(''/KUBE PAK/XLSIMPORT/XREF/export_'  +
              %trim(fileToUpload) +  '.xlsx'') ' +
            ' FILE(QTEMP/XREFUPLOAD) CRTFILE(*YES) HLINES(1)';
  Exec SQL CALL QSYS2/QCMDEXC(:Command);


  // Create the work file and insert the uploaded data
  Select;

    // XREFCUST - FMCUST - Customer Master Cross Reference
    when fileToUpload =    'XREFCUST';
      Exec SQL DROP TABLE   XREFCUSTUP;
      Exec SQL Create Table XREFCUSTUP like XREFCUST;
      Exec SQL delete from xrefcust where int(XRPVDID)||XRFORKEY in
                 (select int(FLD4)||FLD5 from qtemp.xrefupload);
      Exec SQL INSERT INTO  XREFCUST
         (TABLECROSSREFERENCED, PROVIDEDBYNAME,
          PROVIDEDBYTYPE, PROVIDEDBYID, FOREIGNKEYVALUE, DESCRIPTION,
          LOCALKEYVALUE, CREATED_TS, CREATED_BY)
         (SELECT FLD1, FLD2, FLD3, int(trim(FLD4)), FLD5, FLD6, FLD7,
          current timestamp, current user
          FROM qtemp.xrefupload)    ;

    // XREFINVT - FMINVT - Inverntory Master Cross Reference
    when fileToUpload =    'XREFINVT';
      Exec SQL DROP TABLE   XREFINVTUP;
      Exec SQL Create Table XREFINVTUP like XREFINVT;
      Exec SQL delete from  xrefinvt where int(XRPVDID)||XRFORKEY in
                 (select int(FLD4)||FLD5 from qtemp.xrefupload);
      Exec SQL  INSERT INTO XREFINVT
         (TABLECROSSREFERENCED, PROVIDEDBYNAME,
          PROVIDEDBYTYPE, PROVIDEDBYID, FOREIGNKEYVALUE, DESCRIPTION,
          LOCALKEYVALUE, localItemNumber,	localItemSize,
          CREATED_TS, CREATED_BY)
         (SELECT FLD1, FLD2, FLD3, int(trim(FLD4)), FLD5, FLD6, FLD7, FLD8,
          FLD9, current timestamp, current user
          FROM qtemp.xrefupload)    ;

    // XREFSVIA - FMSVIA - Ship Via Master Cross Reference
    when fileToUpload =    'XREFSVIA';
      Exec SQL DROP TABLE   XREFSVIAUP;
      Exec SQL Create Table XREFSVIAUP like XREFSVIA;
      Exec SQL Create or Replace Table qtemp/xrefsvia like xrefsvia;
      Exec SQL INSERT INTO  XREFSVIA
         (TABLECROSSREFERENCED, PROVIDEDBYNAME,
          PROVIDEDBYTYPE, PROVIDEDBYID, FOREIGNKEYVALUE, DESCRIPTION,
          LOCALKEYVALUE, CREATED_TS, CREATED_BY)
         (SELECT FLD1, FLD2, FLD3, int(trim(FLD4)), FLD5, FLD6, FLD7,
          current timestamp, current user
          FROM qtemp.xrefupload)    ;

    // XREFSVIO - FMSVIO - Ship Via Master Cross Reference (Outbound)
    when fileToUpload =    'XREFSVIO';
      Exec SQL DROP TABLE   XREFSVIOUP;
      Exec SQL Create Table XREFSVIOUP like XREFSVIO;
      Exec SQL Create or Replace Table qtemp/xrefsvio like xrefsvio;
      Exec SQL INSERT INTO  XREFSVIO
         (TABLECROSSREFERENCED, PROVIDEDBYNAME,
          PROVIDEDBYTYPE, PROVIDEDBYID, FOREIGNKEYVALUE, DESCRIPTION,
          LOCALKEYVALUE, CREATED_TS, CREATED_BY)
         (SELECT FLD1, FLD2, FLD3, int(trim(FLD4)), FLD5, FLD6, FLD7,
          current timestamp, current user
          FROM qtemp.xrefupload)    ;
  EndSl;


  *InLR = *On;
  return;
