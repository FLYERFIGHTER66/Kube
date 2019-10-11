**free
  Ctl-Opt  debug option(*NODEBUGIO : *SRCSTMT );
  Ctl-Opt  dftactgrp(*no) actgrp(*caller) DatFmt(*USA);
  Ctl-Opt  thread(*serialize);

  // This program will delete XREFINVT records for deleted KP items
  dcl-pr WS_DLTXREF          extpgm('WS_DLTXREF');
  end-pr;
  dcl-pi WS_DLTXREF;
  end-pi;

  //////////////////////////////////////////////////////////////////////////////
  //==========================================================================//
  //|     M A I N     P R O C E D U R E                                      |//
  //==========================================================================//
  //////////////////////////////////////////////////////////////////////////////

  Exec SQL SET OPTION COMMIT = *NONE,
                   CloSqlCsr = *EndMod;

  Exec SQL
    DELETE FROM xrefinvt
      WHERE LOCALITEMNUMBER||LOCALITEMSIZE in
     (Select IMITEM||IMSIZE from FMINVT where IMSTAT = 'D');

  Exec SQL
    DELETE FROM xrefinvt
      WHERE LOCALITEMNUMBER||LOCALITEMSIZE not in
     (Select IMITEM||IMSIZE from FMINVT);

  return;

