**free
  Ctl-Opt  debug option(*NODEBUGIO : *SRCSTMT );
  Ctl-Opt  dftactgrp(*no) actgrp(*caller) DatFmt(*USA);
  Ctl-Opt  thread(*serialize);

  // This program set the Order Change Eligable Flag for all open orders

  dcl-pr UPDORDCHG           extpgm('UPDORDCHG');
  end-pr;
  dcl-pi UPDORDCHG;
  end-pi;

  Exec SQL  // Line status code = "D"
    update  WSORCHCPF
    set     OCORFLG = 'N'
    ,       OCORMSGD = 'Line status code = "D"'
    ,       OCUPDDAT = varchar_format( current date, 'MMDDYY')
    ,       OCUPDTIM = varchar_format( current timestamp, 'HHMMSS')
    ,       OCUPDUSR = current user
    ,       OCUPDJOB =
       substring(QSYS2.JOB_NAME,(LOCATE_IN_STRING(QSYS2.JOB_NAME,'/',8)+1),10)
    ,       OCUPDPGM = 'UPDORDCHG'
    where   OCORFLG <> 'N'
      and      OCORDNO||'|'||OCORDLIN in
              ( Select  OIORD#||'|'||OISEQ#
                from    FIORDR join FCALEN_ALL on OIRVDT = CYMD7
                where OISTAT = 'D' );

  Exec SQL  // Line posted to production
    update  WSORCHCPF
    set     OCORFLG = 'N'
    ,       OCORMSGD = 'Line posted to production'
    ,       OCUPDDAT = varchar_format( current date, 'MMDDYY')
    ,       OCUPDTIM = varchar_format( current timestamp, 'HHMMSS')
    ,       OCUPDUSR = current user
    ,       OCUPDJOB =
       substring(QSYS2.JOB_NAME,(LOCATE_IN_STRING(QSYS2.JOB_NAME,'/',8)+1),10)
    ,       OCUPDPGM = 'UPDORDCHG'
    where   OCORFLG <> 'N'
      and      OCORDNO||'|'||OCORDLIN in
              ( Select  OIORD#||'|'||OISEQ#
                from    FIORDR join FCALEN_ALL on OIRVDT = CYMD7
                where ( OIPOST = 'Y' and OIRVDT <> 9999999 ) );

  Exec SQL  // Line is past Sow Date
    update  WSORCHCPF
    set     OCORFLG = 'N'
    ,       OCORMSGD = 'Line is past Sow Date'
    ,       OCUPDDAT = varchar_format( current date, 'MMDDYY')
    ,       OCUPDTIM = varchar_format( current timestamp, 'HHMMSS')
    ,       OCUPDUSR = current user
    ,       OCUPDJOB =
       substring(QSYS2.JOB_NAME,(LOCATE_IN_STRING(QSYS2.JOB_NAME,'/',8)+1),10)
    ,       OCUPDPGM = 'UPDORDCHG'
    where   OCORFLG <> 'N'
      and      OCORDNO||'|'||OCORDLIN in
              ( Select  OIORD#||'|'||OISEQ#
                from    FIORDR join FCALEN_ALL on OIRVDT = CYMD7
                where  sowDate(OIITEM,OISIZE,DATEFLD) < NEXT_SOW_DATE_SEED );

  Exec SQL  // Line is too close to ship date
    update  WSORCHCPF
    set     OCORFLG = 'N'
    ,       OCORMSGD = 'Line is too close to ship date'
    ,       OCUPDDAT = varchar_format( current date, 'MMDDYY')
    ,       OCUPDTIM = varchar_format( current timestamp, 'HHMMSS')
    ,       OCUPDUSR = current user
    ,       OCUPDJOB =
       substring(QSYS2.JOB_NAME,(LOCATE_IN_STRING(QSYS2.JOB_NAME,'/',8)+1),10)
    ,       OCUPDPGM = 'UPDORDCHG'
    where   OCORFLG <> 'N'
      and      OCORDNO||'|'||OCORDLIN in
              ( Select  OIORD#||'|'||OISEQ#
                from    FIORDR join FCALEN_ALL on OIRVDT = CYMD7
                where DATEFLD < current date + 8 days );

  Exec SQL // Do not allow changes to orders shipping soon (8 days)
     INSERT INTO WSORCHCPF   (
      SELECT DISTINCT
      OCFRORID,
      OCBRKORID,
      0 as OCPOSEQ,
      OCBRKSLD,
      OCBRKSHP,
      OCCUST,
      OCORDNO,
      0 as OCORDLIN,
      0 as OCBRKLNE,
      ' ' as OCBRKMAT,
      ' ' as OCITEM,
      ' ' as OCIMSZE,
      'N' as OCORFLG,
      'WS00051   ' as OCORMSGID,
      'Change Ineligible: Sow/Ship cutoff inside 8 days.' as OCORMSGD,
      OCCRTDAT ,
      OCCRTTIM ,
      current user as OCCRTUSR,
      substring(QSYS2.JOB_NAME,(LOCATE_IN_STRING(QSYS2.JOB_NAME,'/',8)+1),10)
      as OCCRTJOB,
      'UPDORDCHG' as OCCRTPGM,
      0,
      0,
      ' ',
      ' ',
      ' '

      FROM
      WSORCHCPF

      WHERE OCORDNO in     (Select DISTINCT OHORD#
                            from   FHORDR, FCALEN_ALL, WSORCHCPF
                            where  OHORD# = OCORDNO
                              and  OHDTRY = CYMD7
                              and  OHSTAT = 'A'
                              and  DATEFLD < current date + 8 days
                              and  DATEFLD > current date - 7 days)
        and OCORDNO not in (SELECT existing.OCORDNO
                            FROM   WSORCHCPF as existing
                            WHERE  existing.OCPOSEQ = 0)
                             );

  Return ;
