**free
  Ctl-Opt  debug option(*NODEBUGIO : *SRCSTMT );
  Ctl-Opt  dftactgrp(*no) actgrp(*caller) DatFmt(*USA);
  Ctl-Opt  thread(*serialize);

  // This program set the Order Change Eligable Flag for all open orders

  dcl-pr UPDORDCHGO          extpgm('UPDORDCHGO');
    thisOrder Packed(6:0);
  end-pr;
  dcl-pi UPDORDCHGO;
    thisOrder Packed(6:0);
  end-pi;

  dcl-s cutOffDate7 zoned(7:0);

  cutOffDate7 = %int(%Char(%Date() + %days(8):*CYMD0));

  Exec SQL
    update  WSORCHCPF
    set     OCORFLG = 'N'
    where   OCORDNO||'|'||OCORDLIN in
    ( Select  OIORD#||'|'||OISEQ#
      from    FIORDR
      where   OIORD# = :thisOrder
        and ( OISTAT = 'D'
         or   OIPOST = 'Y'
         or   OIRVDT < :cutOffDate7 ));

  Return ;
