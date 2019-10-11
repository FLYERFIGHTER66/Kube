    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- SCR230
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT LOCATION SHEETS FOR CARTS  (CALLED)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *  02/21/03   CORRECTED OVERFLOW PROBLEM ON REPORT.  CAB
      *  03/24/03   CORRECTED DELETED RECORD FROM SHOWING ON REPORT. CAB
      *
     FFCARTS    UF   E           K DISK
     FFCART     O  A E           K DISK
     FFCARTCI   IF   E           K DISK
     F                                     RENAME(RCART:CARTCI)
     FFCARTCC   IF   E           K DISK
     F                                     RENAME(RCART:CARTCC)
     FFPUTORDP  UF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFTRAY     IF   E           K DISK
     FFTRAYPS   UF A E           K DISK
     FFTRAYTRN  O    E           K DISK
     FFIORDR    IF   E           K DISK
     FFIORDRPARTUF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCARTCTL  UF A E           K DISK
     FFROTATECUSIF   E           K DISK
     FFALITEM_RTUF A E           K DISK
     FFDLOTRD_S UF A E           K DISK
     FFDLOTALOC UF A E           K DISK
     FFDLOTRD_AVUF A E           K DISK    Rename(RDLOTRD:RDLOTRD_AV)
     FSCR230P   O    E             PRINTER OFLIND(*IN81)
     FSCR230P2  O    E             PRINTER OFLIND(*IN82)
     F*SCR230DP  O    E             PRINTER OFLIND(*IN83)
     FSCR230    O    F  120        PRINTER OFLIND(*INOF)
     FSCR230E   O    F  120        PRINTER OFLIND(*INOV)
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(2) CTDATA PERRCD(1)              MESSAGES
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380

      *? Data Areas
     D ALLOWPARTS      DS                  DTAARA(ALLOWPARTS)
     D  PartsAreOK@                   1A                                        ?Use Partial tray 2
     D  PartsAreOK     S               N                                        ?Fill order for full
     D UseFul4PrtDS    DS                  DTAARA(USEFUL4PRT)
     D  UseFul4Prt@                   1A                                        ?Allow Partial order
     D  UseFul4Prt     S               N                                        ?2 be filled w/ full

      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  VOUT                 131    131  0
     D  LCANCL               133    133

     D  P              S              1A   Inz(*Blanks)
     D  DUP_LIT        S             40A   Inz('Tray was already scanned in thi+
     D                                     s Master')
     D  CTPART         S              1A   Inz(*Blanks)
     D  FirstTime      S               N   Inz(*On)
     D  Dup_Scan       S               N
     D  HasKPRB        S               N   Inz(*Off)
     D  Tags           DS                  Inz
     D  Tag1                               Like(TRTAG#)
     D  Tag2                               Like(TRTAG#)
     D  Tag3                               Like(TRTAG#)
     D  Tag4                               Like(TRTAG#)
     D  Tag5                               Like(TRTAG#)
     D  Tag6                               Like(TRTAG#)
     D  Tag7                               Like(TRTAG#)
     D  Tag8                               Like(TRTAG#)
     D  Tag                                Like(TRTAG#) Dim(8) Overlay(Tags)

     D  Rotate         S               N                                        Rotate Inventory

      *? Function Prototypes
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$_Dates

      ***********************
      ** START HERE        **
      ***********************
      /Free
         Select;
         When MODE = ' ';
           Rotate = *Off;
           ExSr ProcessCart;
         When MODE = 'R';
           Rotate = *On;
           ExSr ProcessCart;
         EndSl;
         *InLR = *On;
      /End-Free

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : ProcessCart                                          :
      // :......................................................:
     C     ProcessCart   BegSR
     C     CARTNO        SETLL     FCARTS
     C                   SETON                                        OV
     C                   Z-ADD     0             CTCSEQ
     C     NXTCRT        TAG
     C     CARTNO        READE     FCARTS                                 90
     C                   Eval      KeyItem = %subst(CTITEM:1:11) + ' '
     C   90              GOTO      ENDCRT
      ** CHECK FOR FUTURE WEEK
     C     CTTAG#        CHAIN     FTRAY                              55
     C  N55              DO
     C     DUPKEY        KLIST
     C                   KFLD                    CTTAG#
     C                   KFLD                    STRDAT
     C                   KFLD                    MASTER
     C     DUPKEY        CHAIN     FTRAYPS
     C                   EVAL      DUP_SCAN = %FOUND(FTRAYPS)
     C     TRCRDT        IFGT      STRCYM
     C     DUP_SCAN      OREQ      *ON
     C   OV              DO
     C                   EXCEPT    EHEAD
     C                   SETOFF                                       OV
     C                   ENDDO                                                  OV DO
     C     MINKEY        CHAIN     FMINVT                             70
     C                   MOVEL     IMITEM        ITEM              5
     C                   MOVEL     IMSIZE        SIZE              3
     C                   Eval      *In40 = DUP_SCAN
     C                   EXCEPT    ERROR
     C                   MOVE      *BLANKS       CTLOC
     C                   MOVEL     'ERROR'       CTLOC
     C                   Z-ADD     0             CTORD#
     C                   Z-ADD     0             CTSEQ#
     C                   MOVE      *BLANKS       CTSTA
     C                   MOVE      *BLANKS       CTLOTC
     C                   MOVE      *BLANKS       CTBORD
     C                   MOVEL     IMLOOK        CTLOOK
     C                   Z-ADD     CONTRL        CTCNTL
     C                   ADD       1             CTCSEQ
     C                   Z-add     Master        CTMAST
     C                   Z-add     STRDAT        CTPSDT
     C                   WRITE     RCART
     C                   DELETE    RCARTS
     C                   Eval      TRTRNU = $User()
     C                   Eval      TRTRNP = 'SCR230'
     C                   Eval      TRTRNT = $TimeStamp()
     C                   Eval      TRTRND = 'Duplcate Tag Scan Rejected by P.S.'
     C                   Write     RTRAYTRN
     C                   GOTO      NXTCRT
     C                   END                                                    TRCRDT>strcy
     C                   ENDDO                                                  N55  DO
      ** GET NEXT ORDER
     C     LOCKEY        KLIST
     C                   KFLD                    STRCYM
     C                   KFLD                    CTMAST
     C                   KFLD                    CTITEM
     C                   KFLD                    CTSIZE
     C     LOCKEY        SETLL     FPUTORDP
     C     NXTLOC        TAG
     C     LOCKEY        READE     FPUTORDP                               91
     C   91              GOTO      ENDLOC
     C     PDQORD        IFLE      PDQSCH
     C     PDRDYB        OREQ      'Y'
     C                   GOTO      NXTLOC
     C                   END
      *  If in Rotate Mode, the Customer cannot be "forbidden" on the FROTATECUS file
     C                   If        ROTATE
      /Free
                         Chain ('T':PDCUST) FROTATECUS;
      /End-Free
     C                   If        %Found(FROTATECUS)
     C                   GOTO      NXTLOC
     C                   EndIf
     C                   EndIf
      ** IF HERE I NEED THIS TRAY
     C                   ExSr      NeedTray
     C                   GOTO      NXTCRT
     C     ENDLOC        TAG
      *  ____________________________________________________________
      *  If no orders found and tray is full, look for partial order
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C                   If        %SubSt(CTITEM:12:1) = ' '
     C                             and UseFul4Prt
     C                             and not Rotate
     C                   Eval      PartItem = %SubSt(CTITEM:1:11) + 'P'
     C     LOCKEY2       KLIST
     C                   KFLD                    STRCYM
     C                   KFLD                    Master
     C                   KFLD                    PartItem         12
     C                   KFLD                    CTSIZE

     C     LOCKEY2       SETLL     FPUTORDP
     C     NXTLOC2       TAG
     C     LOCKEY2       READE     FPUTORDP                               91
     C   91              GOTO      ENDLOC2
     C     PDQORD        IFLE      PDQSCH
     C     PDRDYB        OREQ      'Y'
     C                   GOTO      NXTLOC2
     C                   END

     C                   If        FirstTime or *In81
     C                   Write     CHGHDR
     C                   Write     CHGHDR2
     C                   Eval      FirstTime = *Off
     C                   EndIf
      *  If using full flat....  delete the partial order record
     C                   Z-ADD     PDORD#        CTORD#
     C                   Z-ADD     PDSEQ#        CTSEQ#
     C                   Z-ADD     CTSEQ#        CTSEQ#3           3 0
     C     ORDKEY        Chain     FIORDRPART
     C                   If        %Found(FIORDRPART)
     C                   Delete    RIORDRPART
     C                   EndIf
     C                   Eval      PDITEM = CTITEM
     C                   Write     CHGDET
     C                   Write     CHGDET2
     C*                  GOTO      NeedTray
     C                   ExSr      NeedTray
     C                   GOTO      NXTCRT
     C                   EndIf
     C     ENDLOC2       TAG
      *  ____________________________________________________________
      *  If no orders found and tray is a partial tray
      *  and partials are OK then put part on full order
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C                   If        PartsAreOK and
     C                             %SubSt(CTITEM:12:1) = 'P'
     C                             and not Rotate
     C                   Eval      PartItem = %SubSt(CTITEM:1:11) + ' '

     C     LOCKEY2       SETLL     FPUTORDP
     C     NXTLOC3       TAG
     C     LOCKEY2       READE     FPUTORDP                               91
     C   91              GOTO      ENDLOC3
     C     PDQORD        IFLE      PDQSCH
     C     PDRDYB        OREQ      'Y'
     C                   GOTO      NXTLOC3
     C                   END

     C*                  GOTO      NeedTray
     C                   ExSr      NeedTray
     C                   GOTO      NXTCRT
     C                   EndIf
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C     ENDLOC3       TAG
     C     MINKEY        CHAIN     FMINVT                             70
     C                   Z-ADD     CCCONT        CTCNTL
     C                   MOVE      *BLANKS       CTSTA
     C                   MOVE      *BLANKS       CTLOTC
     C                   MOVE      *BLANKS       CTLOC
     C                   Z-ADD     0             CTORD#
     C                   Z-ADD     0             CTSEQ#
     C                   MOVEL     '99999999'    CTLOC
     C                   MOVEL     IMLOOK        CTLOOK
     C                   ADD       1             CTCSEQ
     C                   Z-add     STRDAT        CTPSDT
     C                   WRITE     RCART
     C                   DELETE    RCARTS
     C                   Eval      TRTRNU = $User()
     C                   Eval      TRTRNP = 'SCR230'
     C                   Eval      TRTRNT = $TimeStamp()
     C                   Eval      TRTRND = 'Tray designated Extra by P.S.'
     C                   Write     RTRAYTRN
     C                   ExSr      WRT_RTRAYPS
     C                   GOTO      NXTCRT
     C     ENDCRT        TAG
      ** NOW PRINT REPORT
     C                   ExSR      PRTONLSR
     C                   EndSr

      *******************
      ** Need Tray Subroutine
      *******************
     C     NEEDTRAY      BegSR
     C*    NeedTray      TAG

     C                   If        Rotate
     C                   ExSr      RotateSR
     C                   EndIf

     C                   MOVEL     PDLOC         CTLOC
     C                   If        PDCUST = 6417
     C                   Eval      CTLOC  = '888888'
     C                   EndIf
     C                   Z-ADD     PDORD#        CTORD#
     C                   Z-ADD     PDSEQ#        CTSEQ#
     C                   Z-ADD     CTSEQ#        CTSEQ#3           3 0
     C     ORDKEY        KLIST
     C                   KFLD                    CTORD#
     C*                  KFLD                    CTSEQ#
     C                   KFLD                    CTSEQ#3
     C     CTORD#        CHAIN     FIORDR                             70
     C     CTORD#        IfNe      *Zero
     C     CTORD#        andLT     990000
     C                   Z-ADD     CTSEQ#        CTSEQ#3           3 0
     C     ORDKEY        SETLL     FIORDRPART
     C                   If        %Equal(FIORDRPART)
     C                   Eval      P = 'P'
     C                   Else
     C                   Eval      P = ' '
     C                   EndIf
     C                   Else
     C     CTTAG#        CHAIN     FTRAY
     C                   If        TRSTAT <> 'A'
     C                   Eval      P = TRSTAT
     C                   Else
     C                   Eval      P = ' '
     C                   EndIf
     C                   EndIf
     C     MINKEY        CHAIN     FMINVT                             70
     C                   MOVE      *BLANKS       CTSTA
     C                   MOVE      *BLANKS       CTLOTC
     C  N70              DO
     C                   MOVEL     OILOTC        CTLOTC
     C                   MOVEL     OISTA         CTSTA
      ** CHECK BACKORDER
     C     OIPRBO        IFEQ      'B'
     C     OIBOLN        OREQ      'B'
     C                   MOVEL     'B'           CTBORD
     C                   ELSE
     C                   MOVE      *BLANKS       CTBORD
     C                   END                                                    OIPRBO=B
     C                   ENDDO                                                  N70  DO
     C     CTSTA         IFNE      'Y'
     C                   MOVEL     'N'           CTSTA
     C                   END
     C                   ADD       1             PDQSCH
     C                   UPDATE    RPUTORD
     C                   Z-ADD     CCCONT        CTCNTL
     C                   ADD       1             CTCSEQ
     C                   MOVEL     IMLOOK        CTLOOK
     C                   Z-add     STRDAT        CTPSDT
     C                   WRITE     RCART
     C                   DELETE    RCARTS
     C                   Eval      TRTRNU = $User()
     C                   Eval      TRTRNP = 'SCR230'
     C                   Eval      TRTRNT = $TimeStamp()
     C                   Eval      TRTRND = 'Tray Assigned to Order ' +
     C                                %editw(CTORD#:'     0')
     C                   Write     RTRAYTRN
     C                   ExSR      WRT_RTRAYPS
     C                   EndSr

      *******************
      ** RotateSR
      *******************
     C     RotateSR      BegSR
      /Free
         // Find an allocation for this order and replace it with an allocation
         // for the Tray in hand.  e.g. Go to the FALITEM record for this Ord#/Seq#
         // and releive the inventory of one peice.  Also change FDLOTRD and FDLOT.
         // Then allocate the tray in hand to the same Ord#/Seq# in FALITEM FDLOTRD and FDLOT

         If PDSEQ# <= 999;
           Chain (PDORD#:PDSEQ#:PDITEM:PDSIZE:PDSHPD) FALITEM_RT;
         EndIf;
         If %Found(FALITEM_RT) and PDSEQ# <= 999;
           Chain (AIITEM:AISIZE:AICRDY:AISOWD:AIGLOC:AICUST) FDLOTRD_S;
           If %Found(FDLOTRD_S);
             Chain (LRITEM:LRSIZE:LRWHSE:LRSOWD:LRCRDY) FDLOTALOC;
             If %Found(FDLOTALOC);
               AIQTOA -= 1;
               AIDTLA  = $MDYDate($Date(0));
               AITIME  = $Now();
               AIUSER  = 'SCR230_R1';
               Update RALITEM;

               LRQTOH -= 1;
               LRQTAL -= 1;
               LRDTLA  = AIDTLA;
               LRTIME  = AITIME;
               LRUSER  = AIUSER;
               Update RDLOTRD;
               //Chain (LRITEM:LRSIZE:LRCRDY:LRSOWD:' ':0) FDLOTRD_S;
               // 3-06-2017  Change to put released into RB Select
               Chain (LRITEM:LRSIZE:LRCRDY:LRSOWD:'S   ':0) FDLOTRD_S;
               LRDTLA  = AIDTLA;
               LRTIME  = AITIME;
               LRUSER  = AIUSER;
               if %Found(FDLOTRD_S);
                 LRQTOH += 1;
                 LRQTAV += 1;
                 Update RDLOTRD;
                else;
                 LRCUST  = 0;
                 LRGLOC  = 'S   ';    // 3-06-2017  Changed to put released into RB Select
                 LRQTOH  = 1;
                 LRQTAV  = 1;
                 LRQTAL  = 0;
                 LRDTLA  = AIDTLA;
                 LRTIME  = AITIME;
                 LRUSER  = AIUSER;
                 Write RDLOTRD;
               endif;

               LDQTAL -= 1;
               LDQTAV += 1;
               LDDTLA  = AIDTLA;
               LDTIME  = AITIME;
               LDUSER  = AIUSER;
               Update RDLOT  ;

               // Now allocate the Tray-in-hand
               LRWHSE = ' ';
               Chain (TRITEM:TRSIZE:LRWHSE:TRSCYM:TRCRDT) FDLOTALOC;
               If %Found(FDLOTALOC);
                 // Find Available Inventory
                 Setll (LDITEM:LDSIZE:LDCRDY:LDSOWD:'R  ') FDLOTRD_AV;
                 ReadE(N) (LDITEM:LDSIZE:LDCRDY:LDSOWD:'R  ') FDLOTRD_AV;
                 DoW not %EOF(FDLOTRD_AV);
                   Chain ('F':LRCUST) FROTATECUS;
                   If LRCUST = *Zero or %Found(FROTATECUS);
                     Chain
                      (LRITEM:LDSIZE:LDCRDY:LDSOWD:LRGLOC:LRCUST) FDLOTRD_S;
                     Leave;
                   EndIf;
                   ReadE(N) (LDITEM:LDSIZE:LDCRDY:LDSOWD:'R  ') FDLOTRD_AV;
                 EndDo;
                 If %Found(FDLOTRD_AV) and not %EOF(FDLOTRD_AV);
                   Chain (PDORD#:PDSEQ#:LRITEM:LRSIZE:TRCRDT) FALITEM_RT;
                   AIDTLA  = $MDYDate($Date(0));
                   AITIME  = $Now();
                   AIUSER  = 'SCR230_R2';

                   If %Found(FALITEM_RT);
                     AIQTOA += 1;
                     Update RALITEM;
                    Else;
                     AIQTOA  = 1;
                     AIORD#  = PDORD#;
                     AIOSEQ  = PDSEQ#;
                     AIITEM  = LRITEM;
                     AISIZE  = LRSIZE;
                     AICRDY  = LRCRDY;
                     AIGLOC  = LRGLOC;
                     AICUST  = LRCUST;
                     Write  RALITEM;
                   EndIf;

                   LRQTAL += 1;
                   LRQTAV -= 1;
                   LRDTLA  = AIDTLA;
                   LRTIME  = AITIME;
                   LRUSER  = AIUSER;
                   Update RDLOTRD;

                   LDQTAL += 1;
                   LDQTAV -= 1;
                   LDDTLA  = AIDTLA;
                   LDTIME  = AITIME;
                   LDUSER  = AIUSER;
                   Update RDLOT  ;
                 EndIf;
               EndIf;
             EndIf;
           EndIf;
         EndIf;
      /End-Free
     C                   EndSr

      *******************
      ** NOW PRINT REPORT
      *******************
     C     PRTONLSR      BegSR
     C     PRTONL        TAG
     C                   SETON                                        OF
     C                   Z-ADD     0             COUNT             3 0
     C                   Z-ADD     0             RBQTY             3 0
     C                   Z-ADD     999999        OLDORD            6 0
     C                   MOVE      *BLANKS       OITEM            12
     C                   MOVE      *BLANKS       OSIZE             3
     C     CRTKEY        KLIST
     C                   KFLD                    STRCYM
     C                   KFLD                    Master
     C                   KFLD                    CARTNO
     C                   KFLD                    CONTRL
     C     CRTKEY        SETLL     FCARTCI
     C     NXTPRT        TAG
     C     CRTKEY        READE     FCARTCI                                90
     C   90              GOTO      ENDPRT
     C                   If        CTLOC  = '888888'
     C                   eval      HasKPRB = *On
     C                   EndIf
     C                   Eval      KeyItem = %subst(CTITEM:1:11) + ' '
     C     CTLOC         IFEQ      'ERROR'
     C     QTY           IFGT      0
     C                   EXCEPT    ITMDTL
     C                   Z-ADD     0             QTY
     C                   MOVE      *BLANKS       OITEM
     C                   END
     C     MINKEY        CHAIN     FMINVT                             70
     C                   MOVEL     IMITEM        ITEM              5
     C                   MOVEL     IMSIZE        SIZE              3
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C                   EXCEPT    ERRDET
     C                   ADD       1             COUNT
     C                   GOTO      NXTPRT
     C                   END
     C     CTORD#        IFNE      OLDORD
WJB  C     CTITEM        ORNE      OITEM
WJB  C*    KeyItem       ORNE      OITEM
     C     CTSIZE        ORNE      OSIZE
     C     OITEM         IFGT      *BLANKS
CAB  C                   EXCEPT    ITMDTL
CAB  C   OF              DO
CAB  C                   EXCEPT    HEAD
     C     OTLOC         IFLT      '999999'
     C                   Eval      *In93 = *Off
CAB  C                   GOTO      PASS
     C                   ELSE
WJB17C     CTLOC         IFEQ      '99999999'
     C                   EXCEPT    RDYDTL
WJB17C                   ELSE
WJB17C                   EXCEPT    ORDDTL
WJB17C                   ENDIF
     C                   Eval      *In93 = *On
     C                   END
CAB  C                   SETOFF                                       OF
CAB  C                   ENDDO                                                  OF  DO
     C                   END                                                    OITEM>" "
     C**
CAB  C     PASS          TAG
     C                   Z-ADD     0             QTY               3 0

     C     CTORD#        IfNe      *Zero
     C     CTORD#        andLT     990000
     C                   Z-ADD     CTSEQ#        CTSEQ#3           3 0
     C     ORDKEY        SETLL     FIORDRPART
     C                   If        %Equal(FIORDRPART)
     C                   Eval      P = 'P'
     C                   Else
     C                   Eval      P = ' '
     C                   EndIf
     C                   Else
     C     CTTAG#        CHAIN     FTRAY
     C                   If        TRSTAT <> 'A'
     C                   Eval      P = TRSTAT
     C                   Else
     C                   Eval      P = ' '
     C                   EndIf
     C                   EndIf

     C**
CAB2 C     CTORD#        IFEQ      0
CAB2 C     CTLOC         ANDEQ     *BLANKS
CAB2 C                   GOTO      BYPASS
CAB2 C                   END
     C**
     C     CTORD#        IFNE      OLDORD
     C     CTORD#        IFGT      0
     C     CTORD#        CHAIN     FHORDR                             71
     C                   Z-ADD     CTORD#        OLDORD            6 0
     C                   MOVE      CTLOC         OTLOC             6
     C                   MOVEL     OHNAME        NAME             20
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C     OHSTA         IFEQ      'Y'
     C                   SETON                                        55
     C                   ELSE
     C                   SETOFF                                       55
     C                   END
     C**  PRINTS THE ORDER DETAIL HERE
     C                   EXCEPT    ORDDTL
     C                   ELSE
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C                   SETOFF                                       55
     C                   EXCEPT    RDYDTL
     C                   Z-ADD     CTORD#        OLDORD
     C                   END                                                    CTORD#=0
     C                   END                                                    CTORD#<>OLDO
     C                   MOVEL     CTITEM        OITEM            12
     C                   MOVE      CTSIZE        OSIZE             3
     C                   MOVE      CTLOC         OTLOC             6
     C     MINKEY        KLIST
WJB  C*                  KFLD                    CTITEM
WJB  C                   KFLD                    KeyItem          12
     C                   KFLD                    CTSIZE
     C     MINKEY        CHAIN     FMINVT                             70
     C                   MOVEL     IMITEM        ITEM              5
     C                   MOVEL     IMSIZE        SIZE              3
     C                   MOVE      *BLANKS       OSTA
     C                   MOVE      *BLANKS       OBORD
     C                   END                                                    ORD/ITM/SIZ
     C                   ADD       1             COUNT
     C                   ADD       1             QTY
     C     CTLOC         IFGE      '999999'
     C                   ADD       1             RBQTY
     C                   END
     C                   MOVEL     CTSTA         OSTA              1
     C                   MOVEL     CTBORD        OBORD             1
CAB2 C     BYPASS        TAG
     C                   GOTO      NXTPRT
     C     ENDPRT        TAG
     C     QTY           IFGT      0
     C                   EXCEPT    ITMDTL
     C                   END
     C     RBQTY         IFGT      0
     C                   EXCEPT    TOTR
     C                   END
     C     COUNT         IFGT      0
     C                   EXCEPT    TOTL
     C                   END
      ** GET SUMMARY
     C                   MOVE      *BLANKS       IMITEM
     C                   Z-ADD     0             QTY
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C                   EXCEPT    SUMHED
     C     CRTKEY        SETLL     FCARTCC
     C     NXTSUM        TAG
     C     CRTKEY        READE     FCARTCC                                90
     C   90              GOTO      ENDSUM
     C                   Eval      KeyItem = %subst(CTITEM:1:11) + ' '
     C                   Eval      CTPART  = %subst(CTITEM:12:1)
     C**
CAB2 C     CTLOC         IFEQ      *BLANKS
CAB2 C     CTORD#        ANDEQ     0
CAB2 C                   GOTO      NXTSUM
CAB2 C                   END
     C**
WJB  C*    CTITEM        IFNE      IMITEM
WJB  C     KeyItem       IFNE      IMITEM
     C     CTSIZE        ORNE      IMSIZE
     C     CTPART        ORNE      P
     C     QTY           IFGT      0
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C                   EXCEPT    ITMSUM
     C                   END                                                    QTY>0
     C     MINKEY        CHAIN     FMINVT                             70
     C                   MOVEL     IMITEM        ITEM              5
     C                   MOVEL     IMSIZE        SIZE              3
     C                   If        %subst(CTITEM:12:1) = 'P'
     C                   Eval      P     = 'P'
     C                   Else
     C                   Eval      P     = *Blanks
     C                   EndIf
     C                   Z-ADD     0             QTY
     C                   END                                                    CTITEM><IMIT
     C                   ADD       1             QTY
     C                   GOTO      NXTSUM
      ** END OF SUMMARY
     C     ENDSUM        TAG
     C     QTY           IFGT      0
     C                   EXCEPT    ITMSUM
CAB2 C                   EXCEPT    TOTQ
     C                   END
CAB2 C                   If        HasKPRB
     C                   ExSr      KPRBORDER
     C                   EndIf
     C                   EndSr
      ***********************
      ** Print Tag Numbers for  KP RB Order
      ***********************
     C     KPRBORDER     BEGSR
     C     CRTKEY        SETLL     FCARTCC
     C     CRTKEY        READE     FCARTCC

     C                   DoW       not %EOF(FCARTCC)
     C                   If        CTLOC = '888888'

     C                   Add       1             TagCount          3 0

     C                   If        TagCount = 1
     C                   Except    KPRBH
     C                   EndIf

     C                   If        %Rem(TagCount:8) = 0
     C                   Eval      Tag(8)                = CTTAG#
     C                   Except    KPRBD
     C                   MoveA     *Zeros        Tag
     C                   Else
     C                   Eval      Tag(%Rem(TagCount:8)) = CTTAG#
     C                   EndIf

     C                   EndIf

     C     CRTKEY        READE     FCARTCC
     C                   EndDo

     C                   If        %Rem(TagCount:8) <> 0
     C                   Except    KPRBD
     C                   EndIf

     C                   ENDSR
      *  :'''''''''''''''''''''''''''''''''''''''''''''''''''':
      *  : WRT_RTRAYPS - WRITE THE PS Tray  Record            :
      *  :....................................................:
     C     WRT_RTRAYPS   BEGSR

     C                   Eval      PSTAG# = TRTAG#
     C                   Eval      PSSHPD = STRDAT
     C                   Eval      PSMAST = MASTER
     C                   Eval      PSCART = CARTNO
     C                   Eval      PSSTAT = TRSTAT
     C                   Eval      PSORD# = CTORD#
     C                   Eval      PSUSER = $USER()
     C                   Eval      PSPROG = 'SCR230'
     C                   Eval      PSTIME = $TimeStamp()
     C                   WRITE     RTRAYPS

     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     CARTNO        CART4             4 0
     C                   Z-ADD     TIMOD         CTTIME
     C                   Z-ADD     TDATE         CTDTLA

      ****************
      *   PARMS      *
      ****************
     C     *ENTRY        PLIST
     C                   PARM                    CARTNO            8 0
     C                   PARM                    STRDAT            7 0
     C                   PARM                    MASTER            2 0
     C                   PARM                    CONTRL            6 0
     C                   PARM                    MODE              1

     C                   In        ALLOWPARTS
     C                   IF        PartsAreOK@ = '1'
     C                   Eval      PartsAreOK = *On
     C                   Else
     C                   Eval      PartsAreOK = *Off
     C                   EndIf

     C                   In        UseFul4PrtDS
     C                   IF        UseFul4Prt@ = '1'
     C                   Eval      UseFul4Prt = *On
     C                   Else
     C                   Eval      UseFul4Prt = *Off
     C                   EndIf

     C                   Z-ADD     STRDAT        STRCYM            7 0
      ** IF CONTROL NUMBER GT 0 THEN REPRINT
     C     CONTRL        IFGT      0
     C*                  GOTO      PRTONL
     C                   ExSR      PRTONLSR
     C                   END
     C     STRCYM        CHAIN     FCARTCTL                           91
     C   91              DO
     C                   Z-ADD     0             CCCONT
     C                   Z-ADD     STRCYM        CCSHPD
     C                   ENDDO
     C                   ADD       1             CCCONT
     C   91              WRITE     RCARTCTL
     C  N91              UPDATE    RCARTCTL
     C                   Z-ADD     CCCONT        CONTRL

     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************  PRINT CONTROL NUMBER ABOVE CLIP
     OSCR230    E            HEAD           1 03
     O                                           68 'Control Number:'
     O                       CONTRL        1     74
      ****************** SKIP ALLOWS FOR CLIPBOARD USE
     O          E            HEAD           1 12
     O                                            6 'SCR230'
     O                                           16 'Scanner:'
     O                       USERID              27
     O**                                 21 'Requested by:'
     O**                       USERID    32
     O                                           50 'Customer Location for'
     O                                           58 'Cart #:'
     O                       CART4         4     62
     O                       PAGE          Z     80
     O                                           77 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           72 'Time:'
     O                       TIMOD               80 '  :  :  '
     O          E            HEAD           1
WJB  O                                           46 'B/O'
CAB  O          E            HEAD           1
WJB  O                                            4 'Loc.'
WJB  O                                           15 'Customer'
WJB  O                                           34 'Order#'
WJB  O                                           41 'Item'
WJB  O                                           47 'STA'
     O                                           61 'Description'
     O                                           80 'Qty.'
     O          E            HEAD           1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
      *===================================================================
     O          EF           ORDDTL      1  0
     O                       OTLOC                6
WJB  O                       NAME                27
WJB  O                       OHORD#        4     34
      *===================================================================
     O          EF           RDYDTL      1  1
     O                       CTLOC                8
     O                       MSG(1)              39
      *===================================================================
     O          EF           ITMDTL         1
     O                       QTY           4     80
WJB  O                       IMDES1              77
WJB  O                       OSTA                46
WJB  O                       OBORD               45
WJB  O                       P                   44
WJB  O                       SIZE                43
WJB  O                       ITEM                40
      *===================================================================
     O          EF           ERRDET      1  1
     O                                            5 'Tag#:'
     O                       CTTAG#        4     13
     O                       ITEM                19
     O                       IMDES1              50
     O              N40      MSG(2)              81
     O               40                          77 'Tray already scanned in PS'
      *===================================================================
     O          EF           TOTR           1
     O                                           80 '----'
     O          EF           TOTR           1
     O                                           75 'Total Ready Bay =====>'
     O                       RBQTY         2     80
      *===================================================================
     O          EF           TOTL        1  1
     O                                           70 'Total trays==========>'
     O                       COUNT         2     80
      *===================================================================
     O          EF           SUMHED      1  1
     O                                           40 '--------Summary---------'
     O          EF           SUMHED         0
     O                                           50 'Qty.'
     O                                           28 'Description'
     O                                           15 'Size'
     O                                            9 'Item'
     O          EF           SUMHED         1
     O                                           20 '     _______________'
     O                                           40 '____________________'
     O                                           50 '__________'
      *===================================================================
     O          EF           ITMSUM         1
     O                       QTY           4     50
     O                       IMDES1              46
     O                       IMSIZE              15
     O                       ITEM                10
     O                       P                   11
      *===================================================================
CAB2 O          EF           TOTQ        1  1
CAB2 O                                           25 'Total trays==========>'
CAB2 O                       COUNT         2     38
      *===================================================================
     O          EF           KPRBH          1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O          EF           KPRBH          1
     O                                           20 '  The following tray'
     O                                           20 'The following trays '
     O                                           40 'are from the KP Read'
     O                                           60 'y Bay Order and need'
     O                                           80 ' to go to Ready Bay '
      *===================================================================
     O          EF           KPRBD          1
     O                       TAG1          4      8
     O                       TAG2          4     18
     O                       TAG3          4     28
     O                       TAG4          4     38
     O                       TAG5          4     48
     O                       TAG6          4     58
     O                       TAG7          4     68
     O                       TAG8          4     78
      ******************
      * ERROR REPORT   *
      ******************
     OSCR230E   E            EHEAD          1 03
     O                                           68 'Control Number:'
     O                       CONTRL        1     74
     O          E            EHEAD          1
     O                                            7 'SCR230E'
     O                                           16 'Scanner:'
     O                       USERID              27
     O                                           50 'Customer Location for'
     O                                           58 'Cart #:'
     O                       CART4         4     62
     O                       PAGE          Z     80
     O                                           77 'Page:'
     O          E            EHEAD          2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           45 'Error List'
     O                                           72 'Time:'
     O                       TIMOD               80 '  :  :  '
     O          E            EHEAD          0
     O                                            5 'Item '
     O                                            9 'Size'
     O                                           21 'Description'
     O                                           80 'Ready Date'
     O          E            EHEAD          1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
      *===================================================================
     O          E            ERROR          1
     O                                           12 'Tag Number:'
     O                       CTTAG#        4     20
     O          E            ERROR          1
     O                       ITEM                 5
     O                       CTSIZE               9
     O                       IMDES1              40
     O              N40      MSG(2)              71
     O              N40      TRCRDT              80 ' -  /  /  '
     O               40      DUP_LIT             80
** Messages
Extra Tray ******                          1
Tray is for a Future Week:                 2
