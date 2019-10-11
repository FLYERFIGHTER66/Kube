**free
  Ctl-Opt  debug option(*NODEBUGIO : *SRCSTMT );
  Ctl-Opt  dftactgrp(*no) actgrp(*caller) DatFmt(*USA);
  Ctl-Opt  thread(*serialize) BndDir('*LIBL/KPFUNCTION');
      //??:````````````````````````````````````````````````````````````:?
      //??:     Insert Lines / Resequence Orders                       :?
      //??:............................................................:?
      //? :````````````````````````````````````````````````````````````:
      //? : Created:  Mar. 2005            ? Kube-Pak Corporation ?    :
      //? :      by:  William J. Behr                                  :
      //? : Refactored: Nov. 2017          ? Kube-Pak Corporation ?    :
      //? :      by:  William J. Behr                                  :
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Program Description                                     ?:
      //? :   This program provides the ability to insert new lines   ?:
      //? : into an existing order.  The calling program must pass    ?:
      //? : the Order Number, where to start, and number of lines.    ?:
      //? :............................................................:
  dcl-pr BIR104              extpgm('BIR104');
    order                    zoned(6:0) const;
    startLine                zoned(3:0) const;
    insert                   zoned(3:0) const;
  end-pr;
  dcl-pi BIR104;
    order                    zoned(6:0) const;
    startLine                zoned(3:0) const;
    insert                   zoned(3:0) const;
  end-pi;

  Exec SQL // FIORDR (OISEQ#)
    update FIORDR set oiseq#= (oiseq# + :Insert)
    where oiord#= :order and oiseq# between :startLine and (900 - :Insert)
    order by oiseq# desc;

  Exec SQL // FIORDR (OILIST)
    update FIORDR set oilist= (int(oilist) + :Insert)
    where oiord#= :order
      and OILIST <> ''
      and int(TRANSLATE(trim(OILIST), '00123456789', ' 0123456789'))
             between :startLine and (900 - :Insert)
    order by oilist desc;

  Exec SQL // FIOROY
    update FIOROY set orseq#= (orseq# + :Insert)
    where orord#= :order and orseq# between :startLine and (900 - :Insert)
    order by orseq# desc ;

  Exec SQL // FIORDRWK
    update FIORDRWK set oiseq#= (oiseq# + :Insert)
    where oiord#= :order and oiseq# between :startLine and (900 - :Insert)
    order by oiseq# desc ;

  Exec SQL // FIORESOWRO
    update FIORESOWRO set oiseq#= (oiseq# + :Insert)
    where oiord#= :order and oiseq# between :startLine and (900 - :Insert)
    order by oiseq# desc ;

  Exec SQL // FIORESOW
    update FIORESOW set oiseq#= (oiseq# + :Insert)
    where oiord#= :order and oiseq# between :startLine and (900 - :Insert)
    order by oiseq# desc ;

  Exec SQL // FIORDRPART
    update FIORDRPART set oiseq#= (oiseq# + :Insert)
    where oiord#= :order and oiseq# between :startLine and (900 - :Insert)
    order by oiseq# desc ;

  Exec SQL // FALITEM
    update FALITEM set aioseq= (aioseq + :Insert)
    where aiord#= :order and aioseq between :startLine and (900 - :Insert)
    order by aioseq desc ;

  Exec SQL // FIORDRCUST
    update FIORDRCUST set oiseq#= (oiseq# + :Insert)
    where oiord#= :order and oiseq# between :startLine and (900 - :Insert)
    order by oiseq# desc ;

  Exec SQL // FIORDW (added 11/21/2017 because we started using wiseqp)
    update FIORDW set wiseqp= (wiseqp + :Insert)
    where wiord#= :order and wiseqp between :startLine and (900 - :Insert)
    order by wiseqp desc ;

  //  (the following files added 11/21/2017 for B2B web services )
  Exec SQL // WSCODTLPF
    update WSCODTLPF set CDORDLIN= (CDORDLIN + :Insert)
    where CDORDNO= :order and CDORDLIN between :startLine and (900 - :Insert)
    order by CDORDLIN desc ;

  Exec SQL // WSORCHCPF
    update WSORCHCPF set OCORDLIN= (OCORDLIN + :Insert)
    where OCORDNO= :order and OCORDLIN between :startLine and (900 - :Insert)
    order by OCORDLIN desc ;

  Exec SQL // WSPODTLPF
    update WSPODTLPF set PDORDLIN= (PDORDLIN + :Insert)
    where PDORDNO= :order and PDORDLIN between :startLine and (900 - :Insert)
    order by PDORDLIN desc ;

  Exec SQL // FIORDRB2BC
    update FIORDRB2BC set B2BSEQ# = (B2BSEQ# + :Insert)
    where B2BORD# = :order and B2BSEQ# between :startLine and (900 - :Insert)
    order by B2BSEQ# desc ;

  Exec SQL // WSERREXPPF
    update WSERREXPPF set ERORDLIN = (ERORDLIN + :Insert)
    where ERORDNO = :order and ERORDLIN between :startLine and (900 - :Insert)
    order by ERORDLIN desc ;


  *InLR = *On;
  return;

