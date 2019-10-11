**free
Ctl-Opt  debug option(*NODEBUGIO : *SRCSTMT )
         dftactgrp(*no) actgrp(*caller)
         DatFmt(*USA)
         BndDir('*LIBL/KPFUNCTION')
         ALWNULL(*InputOnly)
         thread(*serialize);

/include QFunctDefn,@CopyRight

dcl-f FMORLS usage(*output);
dcl-pr ORLBLDCUS extpgm;
END-PR;

// Program Status Data Structure : PSDS
Dcl-Ds Pgmstatus PSDS;
  Job     Char(10) Pos(244);
  User    Char(10) Pos(254);
  Rundate Zoned(6) Pos(276);
  Runtime Zoned(6) Pos(282);
  Pgm     Char(10) Pos(334);
End-Ds;

dcl-s EndOfFile ind;
dcl-s RecordCount zoned(4:0);

ClearCUSNOW();
OpenData();
DOU *INLR = *ON;
  ReadWriteData();
  *InLR = EndOfFile;
ENDDO;
CloseData();
Return;

//----------------------------------------------------------------
//  Clear CUSNOW of previous entries
//----------------------------------------------------------------
dcl-proc ClearCUSNOW;
    exec sql Delete FMORLS where OLLIST = 'CUSNOW';
end-proc;

//----------------------------------------------------------------
// Run SQL to select Data (CUSNNOW)        :
//----------------------------------------------------------------
dcl-proc OpenData;

  exec sql
    DECLARE   C1 cursor for

      select 'A', 'CUSNOW', IMITEM, IMSIZE, IMWHSE, 1, IMLOOK, IMPCL1, ' ', ' '
      from fminvt
      where imsize = '253' and imqtoh > 0
      order by imlook

    For Read only;

    exec sql Close C1;
    exec sql Open C1;

end-proc;

//----------------------------------------------------------------
//  Close the SQL recordset
//----------------------------------------------------------------
dcl-proc CloseData;
    exec sql Close C1;
end-proc;

//----------------------------------------------------------------
//  Read Data from FMINVT / Write FMORLS
//----------------------------------------------------------------
dcl-proc ReadWriteData;
  //  Read Sow Schedule Records for Selected Week
  exec sql
  Fetch C1 into :olstat,:ollist,:olitem,:olsize, :olwhse,
                :olseq#, :ollook, :olpcl1, :olnote, :olrdyc;

  If SQLSTT = '02000';
    EndOfFile = *On;
  Else;
    EndOfFile = *Off;
    RecordCount = RecordCount + 1;
    olseq# = RecordCount;
    write RMORLS;
  EndIf;

end-proc;
