**free
       Ctl-Opt DftActGrp(*No)
               Option(*SrcStmt : *NoDebugIO)
               Debug(*Yes)
               BndDir('*LIBL/KPFUNCTION')
               DatFmt(*Usa);

       Dcl-Pi WSTEST002;
       End-Pi;

       /include QFunctFree,PSDS

       // Begin Logic
       AfterOrder();          //WJB03
       *InLr = *On;
       Return;

      //--------------------------------------------------------------------
      //              .-------------------------.
      //              : AfterOrder Subprocedure :
      //              '-------------------------'
      //--------------------------------------------------------------------

       dcl-proc AfterOrder;
       /include QFunctFree,$PrintPick
       /include QFunctFree,$Comment

         dcl-s isReadyBay ind inz(*off);
         dcl-s isTruck    ind inz(*off);
         dcl-s RBSHIPVIACODE char(2);
         dcl-s #PRTPICK02 char(10);
         dcl-s #PRTBILL char(10);
         dcl-s OHORD# packed(6:0) inz(263379);
         dcl-s OHSHPC char(2) inz('01');


         Reset isReadyBay;
         Exec SQL  // Determine if order is ready bay
           SELECT  '1'
           INTO   :isReadyBay
           FROM    FALITEM
           WHERE   AIGLOC = 'R'
             and   AIORD# = :OHORD#;

         If isReadyBay;

           If OHSHPC = '01';
             isTruck = *On;
           ENDIF;

           Exec SQL // Do not allow changes to RB orders
             INSERT INTO WSORCHCPF   (
             SELECT
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
             'WS00052' as OCORMSGID,
             'Ready Bay Orders are not eligible for change.' as OCORMSGD,
             OCCRTDAT,
             OCCRTTIM,
             OCCRTUSR,
             OCCRTJOB,
             OCCRTPGM,
             OCUPDDAT,
             OCUPDTIM,
             OCUPDUSR,
             OCUPDJOB,
             OCUPDPGM

             FROM
             WSORCHCPF

             WHERE OCORDNO = :OHORD#
               and OCORDNO not in (SELECT OCORDNO
                                   FROM   WSORCHCPF
                                   WHERE  OCORDNO = :OHORD#
                                     and  OCPOSEQ = 0)
             Fetch First Row Only );

           Exec SQL // Change ALL RB lines to 'N'
             UPDATE WSORCHCPF
                SET OCORFLG = 'N'
              WHERE OCORDNO = :OHORD#;

              RBSHIPVIACODE = OHSHPC;
           Exec SQL // Get RB SVIA Code
             SELECT READYBAYSHIPVIACODE
               INTO :RBSHIPVIACODE
               FROM frbsvia
              WHERE ORIGINALSHIPVIACODE = :OHSHPC
              Fetch First Row Only;

           Exec SQL // Update SVIA on Order Header
             UPDATE FHORDR
             SET    OHSHPC = :RBSHIPVIACODE
             WHERE OHORD# = :OHORD#;

           Exec SQL // Update SVIA on Order Detail
             UPDATE FIORDR
             SET    OISHPC = :RBSHIPVIACODE
             WHERE OIORD# = :OHORD#;

           Exec SQL // Get Pick Printer #2
             SELECT  DPPRTR
               INTO :#PRTPICK02
               FROM  DFTPRTPF
              WHERE  DPNAME = '#PRTPICK02'
              Fetch First Row Only ;

           $Comment(OHORD#);

           $PrintPick(OHORD#:'P6':'002':'*NO');
           $PrintPick(OHORD#:'P6':'001':'*NO');

           If isTruck;
             Exec SQL // Get Bill S. Printer
               SELECT  DPPRTR
                 INTO :#PRTBILL
                 FROM  DFTPRTPF
                WHERE  DPNAME = 'BILL'
               Fetch First Row Only ;
             $PrintPick(OHORD#:'P6':'001':'*NO');
           ENDIF;   // If isTruck
         ENDIF;   // If isReadyBay

       END-PROC;

