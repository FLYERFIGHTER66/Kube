**free
  Ctl-Opt  debug option(*NODEBUGIO : *SRCSTMT );
  Ctl-Opt  dftactgrp(*no) actgrp(*caller) DatFmt(*USA);
  Ctl-Opt  thread(*serialize);

  // This program will delete XREFINVT records for deleted KP items
  dcl-pr WS_CHGVNAM         extpgm('WS_CHGVNAM');
    CustNo@ char(6);
    NewName char(30);
  end-pr;
  dcl-pi WS_CHGVNAM;
    CustNo@ char(6);
    NewName char(30);
  end-pi;

  dcl-s CustNo packed(6:0);

  //////////////////////////////////////////////////////////////////////////////
  //==========================================================================//
  //|     M A I N     P R O C E D U R E                                      |//
  //==========================================================================//
  //////////////////////////////////////////////////////////////////////////////

  Exec SQL SET OPTION COMMIT = *NONE,
                   CloSqlCsr = *EndMod;

  Exec SQL Set :CustNo = int(:CustNo@);

  Exec SQL
    update FBROKDFT
    set BROKER_VARIABLE_VALUE = :NewName
    where BROKER_VARIABLE = 'ToOrgId'
      and BROKER_NUMBER = trim(:CustNo@);

  Exec SQL
    update XREFINVT
    set PROVIDEDBYNAME = :NewName
    where PROVIDEDBYID = :CustNo;

  Exec SQL
    update XREFCUST
    set PROVIDEDBYNAME = :NewName
    where PROVIDEDBYID = :CustNo;

  Exec SQL
    update XREFSVIA
    set PROVIDEDBYNAME = :NewName
    where PROVIDEDBYID = :CustNo;

  return;

