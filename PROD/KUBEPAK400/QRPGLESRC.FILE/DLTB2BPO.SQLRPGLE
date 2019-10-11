**free

  Ctl-Opt  debug option(*NODEBUGIO : *SRCSTMT )
    dftactgrp(*no) actgrp(*caller) DatFmt(*USA)
    thread(*serialize);

  dcl-pr DLTB2BPO               extpgm('DLTB2BPO');
    BRKORID                     char(10) const; // Broker PO
    FRORID                      char(30) const; // From Org ID
  end-pr;
  dcl-pi DLTB2BPO;
    BRKORID                     char(10) const; // Broker PO
    FRORID                      char(30) const; // From Org ID
  END-PI;

  dcl-s DELETE_PO char(10) INZ('DontDelete');
  dcl-s BROKER char(30) INZ(*blanks);

  Exec SQL SET OPTION   COMMIT     = *NONE,
                        CloSqlCsr  = *EndMod;

  If BRKORID <> *Blank;

    DELETE_PO = BRKORID;

    If FRORID = *Blank;
      Exec SQL Select DISTINCT PHFRORID into :BROKER from WSPOHDRPF
                         where PHBRKORID = DELETE_PO Fetch First Row Only;
     else;
      BROKER = FRORID;
    ENDIF;

    //======== D E L E T E    B 2 B    F I L E S  =========--

    Exec SQL delete from WSPOHDRPF  where PHBRKORID = :DELETE_PO
                                      and (PHFRORID  = :BROKER or :BROKER = ' ');
    Exec SQL delete from WSPODTLPF  where PDBRKORID = :DELETE_PO
                                      and (PDFRORID  = :BROKER or :BROKER = ' ');
    Exec SQL delete from WSCOHDRPF  where CHBRKORID = :DELETE_PO
                                      and (CHFRORID  = :BROKER or :BROKER = ' ');
    Exec SQL delete from WSCODTLPF  where CDBRKORID = :DELETE_PO
                                      and (CDFRORID  = :BROKER or :BROKER = ' ');
    Exec SQL delete from WSERREXPPF where ERBRKORID = :DELETE_PO
                                      and (ERBRKNAM  = :BROKER or :BROKER = ' ');
    Exec SQL delete from WSORCHCPF  where OCBRKORID = :DELETE_PO
                                      and (OCFRORID  = :BROKER or :BROKER = ' ');
  ENDIF;

  //Exec SQL SET BROKER = '';
  //Exec SQL SET DELETE_PO = 'Do Not Delete';

  *InLR = *Off;
  Return;
