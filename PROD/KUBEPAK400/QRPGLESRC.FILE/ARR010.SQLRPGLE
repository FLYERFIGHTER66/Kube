     H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      *PROGRAM NAME-------- ARR010
      *APPLICATION--------- MASTER FILES
      *DESCRIPTION--------- MAINTAIN RECORDS IN CUSTOMER FILE
      *
      *
      //--------------------------------------------------------------------
      *            CHANGE--DATE-------DESCRIPTION
      *  4/28/00 EFD ADD LOGIC TO SEARCH AND VERIFY CUSTOMER TYPE.
      *  5/26/00 EFD ADD LOGIC REUSE LOWEST CUSTOMER NUMBER
      *  5/05/15 WJB Change tax exempt default based on CMBABB
      *
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   10/25/18   S.Uthaya     Added F5=Refresh function Key in SCRNB
      * SUD02   12/06/18   S.Uthaya     Replaced F8 Function Key in SCRNH with
      *                                 New Logic-SHR010 Program will be Called
      *                                 for this function key
      *         02/11/19   S.Uthaya     Added Shipto Master file
      * SUD03   06/19/19   S.Uthaya     Added Logic back to BIR100 Directly
      //--------------------------------------------------------------------
     FFMCUST    UF A E           K DISK
     FFMCUSTC   IF   F  640     6AIDISK    KEYLOC(2)
     FFCUSTCOM  UF A E           K DISK
SUD02FFSHIPTOL0 UF A E           K Disk
     FFARHST    UF A E           K DISK
     FFSYSCTL   IF   E           K DISK
     FFMSLSM    IF   E           K DISK
     FFMCTYP    IF   E           K DISK
     FFMTAXF    IF   E           K DISK
     FFPHYTO    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMTERR    IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FFMSTAT    IF   E           K DISK
     FFMSVIA    IF   E           K DISK
     FFARCTL    UF   E           K DISK
     FFNXTCUST  UF   E           K DISK
     FFCMDIR    UF A E           K DISK
     FFMCDEF    IF   E           K DISK
     FFMORLH    IF   E           K DISK
     FFUZONE    IF   E           K DISK
     FFMCRED    IF   E           K DISK
     FFMROUT    IF   E           K DISK
WBADDFFAUTCC    IF   E           K DISK
EFD  FFARHIST   IF   E           K DISK
EFD  FFMZIPSZC  IF   E           K DISK
EFD  FFPLGPCX   UF A E           K DISK
     FARR010FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     D MSG             S             20    DIM(5) CTDATA PERRCD(1)
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
SUD02 *
  |  D  Job                  244    253
  |  D  Rundate              276    281S 0
  |  D  Runtime              282    287S 0
  |  D  Pgm                  334    343
SUD02 *
     D                UDS
     D  LCO                    1      2  0
     D  LNLOOK                 3      3
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     D  LCUST                172    177  0

     D  MAILNAME       S            512

      /Free
         dcl-s Destination varChar(256);
         dcl-pr #TAXINQ_NY extpgm ;
         end-pr ;

         dcl-pr #TAXINQ_PA extpgm ;
           Zip5 char(5) const ;
         end-pr ;
         dcl-s Restart_C ind;

SUD02 *?Procedure Prototype Declaration : *Entry
  |     Dcl-Pr SHR010 ExtPgm;
  |        PDs Like(ShiPtoDs);
  |     End-Pr;
  |   *
  |   *?ShipTo Data Structure :
  |     Dcl-Ds ShipToDs Qualified;
  |        Number Packed(6:0);
  |        Seq#   Packed(3:0);
  |        Name   Char(30);
  |        CName  Char(30);
  |        Adr1   Char(30);
  |        Adr2   Char(30);
  |        Adr3   Char(30);
  |        Adr4   Char(30);
  |        City   Char(18);
  |        State  Char(2);
  |        Zip    Char(9);
  |        Phone  Packed(10:0);
  |        TaxE   Char(1);
  |        TaxJ   Char(3);
  |        Pgm    Char(10);
  |     End-Ds;
  |   *
SUD03   Dcl-S WkFlag  Char(1)   Inz('N');
  |     Dcl-S WkSeq#  Packed(3) Inz;
SUD02 /End-Free

      *? Function Prototypes
    ?D/COPY QFunctDefn,$isNote
    ?D/COPY QFunctDefn,$Notes
    ?D*COPY QFunctDefn,$Command
    ?D/COPY QFunctDefn,QCMDEXC

     IFMCUSTC   NS
     I*    STATUS
     I                                  1    1  CKSTAT
     I                                279  280  CKTMCD
     I                                288  291 2CKTRDC
     I                                462  462  CKPORQ
     I                                531  531  CKJOBR
     I                                621  625  CKBABB
      *
SUD03 /Free
  |        If LCUST <> *Zeros;
  |           WkFlag = 'Y';
  |        Endif;
SUD03 /End-Free
     C                   READ      FSYSCTL                                90
     C     ZZTYPE        IFEQ      'D'
     C                   SETON                                        77
     C                   ENDIF
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
      * PROGRAM MAINLINE
      *
     C     RSTRTA        TAG
     C                   UNLOCK    FMCUST
     C                   UNLOCK    FARCTL
     C                   UNLOCK    FARHST
     C                   UNLOCK    FCMDIR
     C                   UNLOCK    FCUSTCOM
     C                   EXSR      CLRIT
     C                   IF        LCUST <> 0
     C                   EVAL      VACT = 'C'
     C                   EVAL      VCUST = LCUST
     C                   EVAL      LCUST = 0
     C                   Goto      Skip1st
     C                   ENDIF
SUD03C* If Its called from BIR100
  |  C                   IF        WkFlag = 'Y'
  |  C                   SETON                                        LR
  |  C                   GOTO      END
SUD03C                   ENDIF
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       09
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       161718
     C                   SETOFF                                       193650
     C                   SETOFF                                       707148
     C                   SETOFF                                       909192
     C                   SETOFF                                       259899
     C                   READ      SCRNA                                  90
     C     Skip1st       TAG
      *
     C   07              GOTO      NXTA
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C     VACT          OREQ      'R'
     C     VACT          OREQ      'I'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C   10              GOTO      NXTA
     C     VACTOK        TAG
      *
     C     VCUST         IFEQ      0
     C     VALPHA        ANDGT     *BLANKS
     C                   MOVEL     VALPHA        CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C     VACT          IFNE      'A'
     C                   MOVEL     CMCUST        VCUST
     C                   ENDIF
     C                   GOTO      NXTA
     C                   ENDIF
      *
      *  TELEPHONE # SEARCH
      *
     C     VCUST         IFEQ      0
     C     VALPHA        ANDEQ     *BLANKS
     C     VTELE         ANDGT     *BLANKS
     C                   MOVEL     VTELE         CMPHON           10 0
     C                   CALL      'LKTELE'
     C                   PARM                    CMPHON
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       VTELE
     C                   Z-ADD     CMCUST        VCUST
     C*                    MOVELCMNAME    VNAME
     C                   GOTO      NXTA
     C                   ENDIF
      *
      *  ZIP CODE # SEARCH
      *
     C     VCUST         IFEQ      0
     C     VALPHA        ANDEQ     *BLANKS
     C     VTELE         ANDEQ     *BLANKS
     C     VZIP          ANDGT     *BLANKS
     C                   MOVEL     VZIP          CMZIP
     C                   CALL      'LKZIP'
     C                   PARM                    CMZIP
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       VZIP
     C                   Z-ADD     CMCUST        VCUST
     C*                    MOVELCMNAME    VNAME
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TEST CUSTOMER NUMBER ON ADD
      *
     C     VACT          IFEQ      'A'
     C     VCUST         ANDGT     0
     C                   SETON                                        0914
     C   09              GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
      ** CHECK IF ANY OLD NUMBERS OPEN
     C                   Z-ADD     0             NXCUST
     C     NXCUST        SETLL     FNXTCUST
     C                   READ      FNXTCUST                               97
     C  N97              DO
     C                   DELETE    RNXTCUST
     C                   GOTO      NOCTL
     C                   ENDDO
     C                   Z-ADD     0             COKEY             2 0
     C     COKEY         CHAIN     FARCTL                             97
     C     ACNCUS        IFEQ      0
     C                   Z-ADD     1             ACNCUS
     C                   ENDIF
     C                   Z-ADD     ACNCUS        NXCUST
     C                   ADD       1             ACNCUS            6 0
     C                   UPDATE    RARCTL
     C     NOCTL         TAG
     C                   Z-ADD     NXCUST        CMCUST
     C                   Z-ADD     NXCUST        HSCUST
     C                   Z-ADD     NXCUST        CCUST
     C                   Exsr      LODCOM
     C                   GOTO      GETSUM
     C                   ENDIF
      *
      * BOTH FIELDS BLANK ON OTHER THAN ADD
      *
     C     VACT          IFNE      'A'
     C     VCUST         ANDEQ     0
     C     VALPHA        ANDEQ     *BLANKS
     C                   SETON                                        1114
     C   11              GOTO      NXTA
     C                   ENDIF
      *
      * ENTRIES IN BOTH FIELDS
      *
     C     VCUST         IFGT      0
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        1714
     C   17              GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C*          SCUST     ANDEQ'Y'
     C                   MOVEL     VCUST         CMCUST            6 0
     C     KEY6          KLIST
     C                   KFLD                    CMCUST
     C     KEY6          CHAIN(N)  FMCUST                             90
     C  N90              SETON                                        1214
     C   12              GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C                   MOVEL     VCUST         CMCUST            6 0
     C     KEY6          CHAIN     FMCUST                             90
     C   90              SETON                                        3614
     C   36              GOTO      NXTA
     C                   EXSR      LODCUS
     C                   ENDIF
      *
     C     VACT          IFNE      'R'
     C     CMSTAT        ANDEQ     'D'
     C                   SETON                                        1437
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'R'
     C     CMSTAT        ANDNE     'D'
     C                   SETON                                        1415
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C     CMARB$        ANDNE     0
     C                   SETON                                        1416
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C     CMVOPO        ANDNE     0
     C                   SETON                                        1471
     C   71              GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        7050
     C                   ENDIF
EFD  C   70              DO
     C     VCUST         SETLL     FARHIST                            94
     C     VCUST         READE     FARHIST                                94
     C   94              GOTO      CKHIST
     C                   SETON                                        1425
     C   25              GOTO      NXTA
EFD  C     CKHIST        TAG
EFD  C                   ENDDO
      *
      * VALIDATE COMPANY
      *
     C     GETSUM        TAG
     C                   Z-ADD     LCO           CMCOMP
      *
      * GET A/R SUMMARY RECORD
      *
     C     VACT          IFNE      'A'
     C                   Z-ADD     VCUST         HSCUST            6 0
     C     KEY6AR        KLIST
     C                   KFLD                    HSCUST
     C     KEY6AR        CHAIN     FARHST                             95
     C  N95              EXSR      LODARH
     C                   ENDIF
      *
      * GET CUSTOMER COMMENTS RECORD
      *
WJB  C*    VACT          IFNE      'A'
     C                   Z-ADD     01            CCSEQ             2 0
     C                   Z-ADD     VCUST         CCUST             6 0
     C     KEY8          KLIST
     C                   KFLD                    CCUST
     C                   KFLD                    CCSEQ
     C     KEY8          CHAIN     FCUSTCOM                           92
WJB  C   92              EXSR      WRTCOM
     C  N92              EXSR      LODCOM
WJB  C*                  ENDIF
      *
     C     ENDA          TAG
      *
      * LOAD MODE FOR OUTPUT
      *
     C     VACT          IFEQ      'A'
     C                   MOVEL     MSG(1)        VMODE            10
     C                   MOVEL     *BLANKS       CMNAME
     C                   MOVEL     *BLANKS       CMLOOK
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   MOVEL     MSG(2)        VMODE
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   MOVEL     MSG(3)        VMODE
     C                   SETON                                        50
     C                   ENDIF
     C     VACT          IFEQ      'R'
     C                   MOVEL     MSG(4)        VMODE
     C                   SETON                                        50
     C                   ENDIF
     C     VACT          IFEQ      'I'
     C                   MOVEL     MSG(5)        VMODE
     C                   SETON                                        50
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C                   EXSR      GETDEF
     C                   Z-ADD     CMCUST        CMARCU
     C                   Z-ADD     CMCUST        CMSACU
     C                   Z-ADD     CMCUST        CMBLCU
     C                   ENDIF
      *
      * GET SHIP VIA DESCRIPTION
      *
     C                   EXSR      SVSR
      *
     C                   Eval      KEYVAL = *Blanks
     C                   MoveL     CMCUST        KEYVAL           25
     C                   Eval      LASTCUST = CMCUST
     C     RSTRTB        TAG
     C                   Eval      *In69 = $isNote('FMCUST':KEYVAL)
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       202122
     C                   SETOFF                                       232425
     C                   SETOFF                                       262728
     C                   SETOFF                                       293031
     C                   SETOFF                                       344041
     C                   SETOFF                                       723942
     C                   SETOFF                                       474849
     C                   SETOFF                                       909899
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
SUD01 /Free
  |          If *InKE = *On;
  |             Chain CMCUST FMCUST;    //WJB 11/07/2018
  |             Exsr  LODCUS;
  |             Exsr  LODCOM;
  |   /End-Free
  |  C                   GOTO      RSTRTB
  |   /Free
  |          Endif;
SUD01 /End-Free
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
     C   02              GOTO      RSTRTA
      *
      * F1 = GOTO PRIMARY CONTACT SCREEN
      *
     C   KA              GOTO      RSTRTE
      *
      * CHECK FOR NOTES REQUEST
      *
     C                   If        NOTES = 1 or NOTES = 2
     C                   CallP     $Notes('FMCUST':KEYVAL)
     C                   GOTO      RSTRTB
     C                   EndIf
      *
      * CHECK FOR ZIP REQUEST
      *
     C                   If        CHECKZIP = 1
     C                   Call      'ZIP4'
     C                   Parm                    CMADD2
     C                   Parm                    CMCITY
     C                   Parm                    CMSTST
     C                   GOTO      RSTRTB
     C                   EndIf
      * TEST CUSTOMER NAME
      *
     C     CMNAME        IFEQ      *BLANKS
     C                   SETON                                        20
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMNAME        IFNE      ONAME
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMNAME        ONAME            30
      *
     C     VLOOK         IFEQ      *BLANKS
     C                   SETON                                        21
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
EFD  C     VLOOK         IFNE      OLOOK
EFD  C     VACT          ANDEQ     'C'
EFD  C                   MOVEL     'Y'           LNLOOK
EFD  C                   ENDIF
      *
     C     VLOOK         IFNE      OLOOK
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VLOOK         OLOOK            15
      *
     C     CMADD2        IFNE      OADD2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMADD2        OADD2            30
      *
     C     CMADD3        IFNE      OADD3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMADD3        OADD3            30
      *
     C     CMADD4        IFNE      OADD4
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMADD4        OADD4            30
      *
     C     CMCITY        IFNE      OCITY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMCITY        OCITY            18
      *
      * TEST FOR STATE CODE VALID IF ENTERED
      *
     C                   MOVEL     CMSTST        STCODE
     C                   MOVEL     CMSTST        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   CALL      'LKSTAT'
     C                   PARM                    STCODE
     C                   PARM                    STNAME           30
     C                   MOVEL     *BLANKS       CMSTST
     C                   MOVEL     STCODE        CMSTST
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMSTST        CHAIN(N)  FMSTAT                             34
     C   34              SETON                                        22
     C   22              GOTO      RSTRTB
      *
     C     CMSTST        IFNE      OSTST
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMSTST        OSTST             2
      *
     C     CMZIP         IFNE      OZIP
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMZIP         OZIP              9
      *
     C     CMCNME        IFNE      OCNME
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMCNME        OCNME            30
      *
     C     CMPHON        IFNE      OPHON
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     CMPHON        OPHON            10 0
      *
     C     CMPHO2        IFNE      OPHO2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     CMPHO2        OPHO2            10 0
      *
     C     HSFAX         IFNE      OFAX
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     HSFAX         OFAX             10 0
      *
      * TEST A/R CUSTOMER NUMBER
      *
     C     CMARCU        IFEQ      0
     C                   SETON                                        23
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMARCU        IFEQ      999999
     C                   Z-ADD     CMCUST        BSCUST            6 0
     C                   MOVEL     CMNAME        BSNAME           30
     C                   MOVEL     CMLOOK        BSLOOK           15
     C                   MOVEL     *BLANKS       CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     CMCUST        CMARCU
     C                   Z-ADD     BSCUST        CMCUST
     C                   MOVEL     BSNAME        CMNAME
     C                   MOVEL     BSLOOK        CMLOOK
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMARCU        IFNE      CMCUST
     C     CMARCU        CHAIN     FMCUSTC                            90
     C  N90CKSTAT        COMP      'A'                                9090
     C   90              SETON                                        23
     C   23              GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMARCU        IFNE      OARCU
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     CMARCU        OARCU             6 0
      *
      * TEST SALESPERSON CODE
      *
     C     CMSLSM        IFEQ      *BLANKS
     C                   SETON                                        24
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      * SALESPERSON  LOOKUP
      *
     C                   MOVEL     CMSLSM        TSLSM             1
     C     TSLSM         IFEQ      '?'
     C     TSLSM         OREQ      '/'
     C                   MOVEL     CMSLSM        SMSLSM            2
     C                   CALL      'LKSALE'
     C                   PARM                    SMSLSM
     C                   PARM                    SMNAME           30
     C                   MOVEL     *BLANKS       CMSLSM
     C                   MOVEL     SMSLSM        CMSLSM
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   MOVEL     CMSLSM        SMSLSM            2
     C     KEY2          KLIST
     C                   KFLD                    SMSLSM
     C     KEY2          CHAIN(N)  FMSLSM                             90
     C   90              SETON                                        24
     C   24              GOTO      RSTRTB
      *
     C     CMSLSM        IFNE      OSLSM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMSLSM        OSLSM             2
      *
      * TEST CUSTOMER TYPE
      *
     C     CMCTYP        IFEQ      *BLANKS
     C                   SETON                                        25
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      * CUSTOMER TYPE LOOKUP
      *
     C                   MOVEL     CMCTYP        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       CTTYPE
     C                   CALL      'LKTYPE'
     C                   PARM                    CTTYPE
     C                   PARM                    CTDESC
     C                   MOVEL     *BLANKS       CMCTYP
     C                   MOVEL     CTTYPE        CMCTYP
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMCTYP        CHAIN(N)  FMCTYP                             25
     C   25              GOTO      RSTRTB
      *
     C     CMCTYP        IFNE      OTYPE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMCTYP        OTYPE             2
      *
      * TEST S/A CUSTOMER NUMBER
      *
     C     CMSACU        IFEQ      0
     C                   SETON                                        26
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMSACU        IFEQ      999999
     C                   Z-ADD     CMCUST        BSCUST            6 0
     C                   MOVEL     CMNAME        BSNAME           30
     C                   MOVEL     CMLOOK        BSLOOK           15
     C                   MOVEL     *BLANKS       CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     CMCUST        CMSACU
     C                   Z-ADD     BSCUST        CMCUST
     C                   MOVEL     BSNAME        CMNAME
     C                   MOVEL     BSLOOK        CMLOOK
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMSACU        IFNE      CMCUST
     C     CMSACU        CHAIN     FMCUSTC                            90
     C  N90CKSTAT        COMP      'A'                                9090
     C   90              SETON                                        26
     C   26              GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMSACU        IFNE      OSACU
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     CMSACU        OSACU             6 0
      *
      * TEST FOR VALID TERRITORY
      *
     C                   MOVEL     CMTERR        TTERR             1
     C     TTERR         IFEQ      '?'
     C     TTERR         OREQ      '/'
     C                   MOVEL     CMTERR        TETERR            2
     C                   CALL      'LKTERR'
     C                   PARM                    TETERR
     C                   PARM                    TEDESC           30
     C                   MOVEL     *BLANKS       CMTERR
     C                   MOVEL     TETERR        CMTERR
     C                   MOVEL     TEDESC        TENAME           30
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMTERR        IFEQ      *BLANKS
     C                   SETON                                        27
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   MOVEL     CMTERR        TETERR            2
     C     KEYT          KLIST
     C                   KFLD                    TETERR
     C     KEYT          CHAIN(N)  FMTERR                             90
     C   90              SETON                                        27
     C   27              GOTO      RSTRTB
      *
     C     CMTERR        IFNE      OTERR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMTERR        OTERR             2
      *
      * VALIDATE ORDER LIST NUMBER
      *
     C                   MOVEL     CMORLS        TORLS             1
     C     TORLS         IFEQ      '?'
     C     TORLS         OREQ      '/'
     C                   MOVEL     CMORLS        OLLIST            6
     C                   CALL      'LKORLS'
     C                   PARM                    OLLIST
     C                   PARM                    OLDESC           30
     C                   MOVEL     *BLANKS       CMORLS
     C                   MOVEL     OLLIST        CMORLS
     C                   MOVEL     OLDESC        VDESC            30
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMORLS        IFGT      *BLANKS
     C     CMORLS        CHAIN(N)  FMORLH                             41
     C   41              SETON                                        40
     C   40              GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMORLS        IFNE      OORLS
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMORLS        OORLS             6
      *
      * TEST BILLING CUSTOMER NUMBER
      *
     C     CMBLCU        IFEQ      0
     C                   SETON                                        29
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMBLCU        IFEQ      999999
     C                   Z-ADD     CMCUST        BSCUST            6 0
     C                   MOVEL     CMNAME        BSNAME           30
     C                   MOVEL     CMLOOK        BSLOOK           15
     C                   MOVEL     *BLANKS       CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   Z-ADD     CMCUST        CMBLCU
     C                   Z-ADD     BSCUST        CMCUST
     C                   MOVEL     BSNAME        CMNAME
     C                   MOVEL     BSLOOK        CMLOOK
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMBLCU        IFNE      CMCUST
     C     CMBLCU        CHAIN     FMCUSTC                            90
     C  N90CKSTAT        COMP      'A'                                9090
     C   90              SETON                                        29
     C   29              GOTO      RSTRTB
     C                   SETON                                        81
     C                   ELSE
     C                   SETOFF                                       81
     C                   ENDIF
      *
     C     CMBLCU        IFNE      OBLCU
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMBLCU        OBLCU             6 0
      *
      * MOVE BILL TO CUSTOMER TERMS AND TRADE DISCOUNT INTO NEW CUSTOME
      *
     C   81              MOVEL     CKTMCD        CMTMCD
     C   81              MOVEL     CKTMCD        VTRMCD
     C   81              Z-ADD     CKTRDC        CMTRDC
      *
     C     CMCOMM        IFNE      OCOMM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     CMCOMM        OCOMM             4 2
      *
     C     CMJOBR        IFEQ      'Y'
     C     CMBABB        ANDEQ     *BLANKS
     C                   SETON                                        4948
     C   49              GOTO      RSTRTB
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C     CMBABB        IFEQ      *BLANKS
     C                   EVAL      CMTXST = 'N'
     C                   ELSE
     C                   EVAL      CMTXST = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C     CMJOBR        IFEQ      'N'
     C     CKBABB        ANDGT     *BLANKS
     C     CKJOBR        ANDEQ     'Y'
     C                   MOVEL     CKBABB        CMBABB
     C*                    SETON                     45
     C*  47                GOTO RSTRTB
     C                   ENDIF
      *
     C*          CMBLCU    IFNE CMCUST
     C*          CKJOBR    ANDEQ'Y'
     C*                    MOVELCKBABB    CMBABB
     C*                    ELSE
     C*                    MOVEL*BLANKS   CMBABB
     C*                    ENDIF
     C     CMJOBR        IFNE      OJOBR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMJOBR        OJOBR             1
      *
      * TEST CUSTOMER ITEM X-REF NUMBER
      *
     C     CMIREF        IFEQ      999999
     C                   Z-ADD     CMCUST        BSCUST            6 0
     C                   MOVEL     CMNAME        BSNAME           30
     C                   MOVEL     CMLOOK        BSLOOK           15
     C                   MOVEL     *BLANKS       CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     CMCUST        CMIREF
     C                   Z-ADD     BSCUST        CMCUST
     C                   MOVEL     BSNAME        CMNAME
     C                   MOVEL     BSLOOK        CMLOOK
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMIREF        IFGT      0
     C     CMIREF        CHAIN     FMCUSTC                            90
     C  N90CKSTAT        COMP      'A'                                9090
     C   90              SETON                                        30
     C   30              GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMIREF        IFNE      OIREF
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMIREF        OIREF             6 0
      *
     C     CMPORQ        IFNE      'Y'
     C     CMPORQ        ANDNE     'N'
     C     CMPORQ        ANDNE     *BLANKS
     C                   SETON                                        39
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMPORQ        IFEQ      *BLANKS
     C                   MOVEL     'N'           CMPORQ
     C                   ENDIF
      *
     C     CMBLCU        IFNE      CMCUST
     C     CKPORQ        ANDEQ     'Y'
     C     CMPORQ        ANDNE     'Y'
     C                   SETON                                        42
     C   42              GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMPORQ        IFNE      OPORQ
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMPORQ        OPORQ             1
      *
     C     CCCOM1        IFNE      OCOM1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CCCOM1        OCOM1            30
      *
     C     CCCOM2        IFNE      OCOM2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CCCOM2        OCOM2            30
      *
     C     CCCOM1        IFGT      *BLANKS
     C     CCCOM2        ORGT      *BLANKS
     C                   SETON                                        72
     C                   ENDIF
      *
     C     CNT           IFGT      0
     C     VACT          ANDNE     'I'
     C                   SETON                                        98
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   GOTO      UPADD
     C                   ENDIF
      *
      * GET TERMS DESCRIPTION
      *
     C     VACT          IFNE      'A'
     C                   MOVEL     CMTMCD        VTRMCD
     C     VTRMCD        CHAIN(N)  FMTERM                             34
     C* N34                MOVELTCDESC    TERMD  30
     C                   ENDIF
     C     CMCUST        Chain     FPLGPCX
     C                   If        %Found(FPLGPCX)
     C                   Eval      OVRPCD = 'Y'
     C                   Eval      OVRREA = PXXREA
     C                   Else
     C                   Eval      OVRPCD = 'N'
     C                   Eval      OVRREA = *Blanks
     C                   EndIf
      *
     C     RSTRTC        TAG
      *
      * GET FREIGHT ZONE DESCRIPTION
      *
     C     VACT          IFNE      'A'
     C                   Z-ADD     01            FUCONO
     C                   MOVEL     CMUPSZ        FZONE
     C     KEYUP         CHAIN(N)  FUZONE
     C                   If        not %Found(FUZONE)
     C                   Eval      FUDESC = 'Freight Zone Invalid'
     C                   EndIf
     C                   ENDIF
     C                   If        CMTXJU = *Blanks
     C                   Eval      CMTXJU = CMSTST
     C                   EndIf
     C                   Eval      ZMZIP  = %int(%Subst(%Trim(CMZIP):1:5))
     C                   Eval      ZMMILE = *Zero
     C     ZMZIP         Chain     FMZIPSZC

     C                   WRITE     SCRNC
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       515253
     C                   SETOFF                                       545556
     C                   SETOFF                                       575859
     C                   SETOFF                                       606162
     C                   SETOFF                                       636465
     C                   SETOFF                                       737438
     C                   SETOFF                                       333235
     C                   SETOFF                                       933843
     C                   SETOFF                                       909899
     C                   SETOFF                                       404142
     C                   SETOFF                                       71
     C                   READ      SCRNC                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
     C   KB              GOTO      RSTRTB
     C   02              GOTO      RSTRTB
     C   KE              DO
     C                   MOVEL     CMRTE1        VRTE1
     C                   MOVEL     CMRTE2        VRTE2
     C                   MOVEL     CMRTE3        VRTE3
     C                   MOVEL     CMRTE4        VRTE4
     C                   MOVEL     CMRTE5        VRTE5
     C                   MOVEL     CMRTE6        VRTE6
     C                   MOVEL     CMRTE7        VRTE7
     C     CMRTE1        CHAIN     FMROUT                             90
     C  N90              MOVEL     RTDESC        RT1
     C     CMRTE2        CHAIN     FMROUT                             90
     C  N90              MOVEL     RTDESC        RT2
     C     CMRTE3        CHAIN     FMROUT                             90
     C  N90              MOVEL     RTDESC        RT3
     C     CMRTE4        CHAIN     FMROUT                             90
     C  N90              MOVEL     RTDESC        RT4
     C     CMRTE5        CHAIN     FMROUT                             90
     C  N90              MOVEL     RTDESC        RT5
     C     CMRTE6        CHAIN     FMROUT                             90
     C  N90              MOVEL     RTDESC        RT6
     C     CMRTE7        CHAIN     FMROUT                             90
     C  N90              MOVEL     RTDESC        RT7
     C                   GOTO      RSTRTF
     C                   ENDDO
      *
     C     CMPRCD        IFEQ      0
     C     CMPRCD        ORGT      5
     C                   SETON                                        54
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMPRCD        IFNE      OPRCD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMPRCD        OPRCD             1 0
      *
     C     CMCUST        Chain     FPLGPCX
     C                   If        OVRPCD = 'Y'
     C                   Eval      PXXPC = CMPRCD
     C                   Eval      PXXREA = OVRREA
     C                   If        %Found(FPLGPCX)
     C                   Update    RPLGPCX
     C                   Else
     C                   Eval      PXCUST = CMCUST
     C                   Write     RPLGPCX
     C                   EndIf
     C                   Else
     C                   If        %Found(FPLGPCX)
     C                   Delete    RPLGPCX
     C                   EndIf
     C                   EndIf
      *
     C     CMCTCD        IFNE      'Y'
     C     CMCTCD        ANDNE     'N'
     C                   SETON                                        51
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
      /Free
         // Check the Tax Jurisdiction

         Restart_C = *off;
         If CMTXST = 'N';
           Select;
             When CMTXJU = 'NY';
               CallP #TAXINQ_NY();
               Restart_C = *on;
             When CMTXJU = 'PA';
               CallP #TAXINQ_PA(%subst(%trim(CMZIP):1:5));
               Restart_C = *on;
           ENDSL;
         ENDIF;

      /End-Free
     C                   if        Restart_C = *On
     C*                  SETON                                        58
     C*                  GOTO      RSTRTC
     C                   endif

     C     CMCTCD        IFNE      'Y'
     C     CMCTCD        ANDNE     'N'
     C                   SETON                                        51
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     GGLMILES      IFEQ      1
      /Free
        Destination =
          %trim(CMNAME)+'+'+
          %trim(CMADD2)+'+'+
          %trim(CMADD3)+'+'+
          %trim(CMCITY)+'+'+
          %trim(CMSTST)+'+'+
          %trim(CMZIP);
        Destination = %ScanRpl('  ': ' ': Destination);
        Destination = %ScanRpl(' ': '+': Destination);
        Exec SQL // Get Google Miles
          set :GGMILE = milesfkp( trim(:Destination) );
        GGUPSZ = *Blanks;
        If GGMILE > 0;
          Exec SQL // Get Freight Zone
            select 'FZ: ' || FZONE
            into :GGUPSZ
            from FUZONEZ
  |             where :GGMILE
  |         between fufmmi and futomi
            fetch first row only;
        EndIf;
      /End-Free
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     ZIPMILES      IFEQ      1
     C                   Eval      ZMZIP = %Int(%Subst(%Trim(CMZIP):1:5))
     C                   Eval      ZMZIP@ = %subst(%EditW(ZMZIP+0:'0     '):2:5)
     C                   Call      'GETMILES'
     C                   Parm                    ZMZIP@            5
     C                   Parm                    ZMMILE
     C                   Parm      'Y'           Force             1
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     TAXBTN        IFEQ      1
     C                   Call      'TAX'
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMCTCD        IFNE      OCTCD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMCTCD        OCTCD             1
      *
     C     CMBOOK        IFNE      'Y'
     C     CMBOOK        ANDNE     'N'
     C                   SETON                                        52
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMBOOK        IFNE      OBOOK
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMBOOK        OBOOK             1
      *
     C     CMQDIS        IFNE      'Y'
     C     CMQDIS        ANDNE     'N'
     C                   SETON                                        53
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMFILL        IFNE      'NT'
     C     CMFILL        ANDNE     *BLANKS
     C                   SETON                                        71
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMQDIS        IFNE      OQDIS
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMQDIS        OQDIS             1
      *
     C     CMTRDC        IFNE      OTRDC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     CMTRDC        OTRDC             4 2
      *
     C     CMFILL        IFNE      OFILL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMFILL        OFILL             2
      *
      *
     C     CMSHIN        IFNE      OSHIN
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMSHIN        OSHIN            30
      *
     C     CMUPSZ        IFEQ      '?'
     C     CMUPSZ        OREQ      '/'
     C                   MOVEL     CMUPSZ        FZONE             1
     C                   CALL      'LKFRTZ'
     C                   PARM                    FZONE
     C                   PARM                    FUDESC           20
     C                   MOVEL     *BLANKS       CMUPSZ
     C                   MOVEL     FZONE         CMUPSZ
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMUPSZ        IFEQ      *BLANKS
     C                   GOTO      NOUPSZ
     C                   ENDIF
     C                   Z-ADD     01            FUCONO
     C                   MOVEL     CMUPSZ        FZONE
     C     KEYUP         KLIST
     C                   KFLD                    FUCONO
     C                   KFLD                    FZONE
     C     KEYUP         CHAIN     FUZONE                             93
     C   93              SETON                                        43
     C   43              GOTO      RSTRTC
      *
     C     NOUPSZ        TAG
      *
     C     CMUPSZ        IFNE      OUPSZ
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMUPSZ        OUPSZ             1
      *
     C     CMSPIN        IFNE      OSPIN
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMSPIN        OSPIN            30
      *
     C     CMPHYT        IFEQ      *BLANKS
     C                   GOTO      NOPHYT
     C                   ENDIF
      *
     C     CMPHYT        IFLT      STPHYT
     C                   SETON                                        3235
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     KEY1          KLIST
     C                   KFLD                    CMPHYT
     C     KEY1          CHAIN(N)  FPHYTO                             3335
     C   33              GOTO      RSTRTC
      *
     C     CMPHYT        IFNE      OPHYT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMPHYT        OPHYT             1
     C     NOPHYT        TAG
      *
      *  SHIP VIA LOOKUP
      *
     C                   MOVEL     CMSVCD        TSVCD             1
     C     TSVCD         IFEQ      '?'
     C     TSVCD         OREQ      '/'
     C                   MOVEL     CMSVCD        SVCODE            2
     C                   CALL      'LKSVIA'
     C                   PARM                    SVCODE
     C                   PARM                    SVDESC           30
     C                   MOVEL     *BLANKS       CMSVCD
     C                   MOVEL     SVCODE        CMSVCD
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMSVCD        IFEQ      *BLANKS
     C                   SETON                                        73
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C                   EXSR      SVSR
     C   97              SETON                                        74
     C   74              GOTO      RSTRTC
      *
     C     CMSVCD        IFNE      OSVCD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMSVCD        OSVCD             2
      *
      * VALIDATE DEFAULT SHIP FROM LOCATION
      *
     C                   MOVEL     CMSHFR        TSHFR             1
     C     TSHFR         IFEQ      '?'
     C     TSHFR         OREQ      '/'
     C                   MOVEL     CMSHFR        WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       CMSHFR
     C                   MOVEL     WHWHSE        CMSHFR
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMSHFR        IFEQ      *BLANKS
     C                   GOTO      NOSHFR
     C                   ENDIF
     C     KEYW          KLIST
     C                   KFLD                    CMSHFR
     C     KEYW          CHAIN(N)  FMWHSE                             93
     C   93              SETON                                        38
     C   38              GOTO      RSTRTC
      *
     C     CMSHFR        IFNE      OSHFR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMSHFR        OSHFR             3
     C     NOSHFR        TAG
      *
     C     CMTXST        IFNE      'Y'
     C     CMTXST        ANDNE     'N'
     C                   SETON                                        56
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMTXST        IFNE      OTXST
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMTXST        OTXST             1
      *
     C     1             SUBST     CMTXJU:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     CMTXJU        TXTXJU            3
     C                   CALL      'LKTAXJ'
     C                   PARM                    TXTXJU
     C                   PARM                    TXJUNM           30
     C                   MOVEL     *BLANKS       CMTXJU
     C                   MOVEL     TXTXJU        CMTXJU
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMTXJU        IFEQ      *BLANKS
     C                   SETON                                        58
     C                   GOTO      RSTRTC
     C                   ELSE
     C                   MOVEL     CMTXJU        TXTXJU            3
     C     KEY3          KLIST
     C                   KFLD                    TXTXJU
     C     KEY3          CHAIN(N)  FMTAXF                             90
     C   90              SETON                                        58
     C   58              GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMTXJU        IFNE      OTXJU
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMTXJU        OTXJU             3
      *
      *  TERMS CODE LOOKUP
      *
     C                   MOVEL     VTRMCD        TRMCD             1
     C     TRMCD         IFEQ      '?'
     C     TRMCD         OREQ      '/'
     C                   MOVEL     VTRMCD        TCTERM            2
     C                   CALL      'LKTERM'
     C                   PARM                    TCTERM
     C                   PARM                    TCDESC           30
     C                   MOVEL     *BLANKS       VTRMCD
     C                   MOVEL     TCTERM        VTRMCD
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
      * TEST FOR TERMS CODE VALID IF ENTERED
      *
     C     VTRMCD        IFEQ      *BLANKS
     C                   SETON                                        57
     C                   GOTO      RSTRTC
     C                   ELSE
     C     VTRMCD        CHAIN(N)  FMTERM                             34
     C   34              SETON                                        57
     C   57              GOTO      RSTRTC
     C                   ENDIF
      *
     C     VTRMCD        IFNE      OTMCD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VTRMCD        OTMCD             2
      *
     C     CMCRL$        IFNE      OCRL$
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     CMCRL$        OCRL$             9 2
      *
     C     CMCNAM        IFNE      OCNAM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMCNAM        OCNAM            30
      *
     C     CMARCD        IFNE      'O'
     C     CMARCD        ANDNE     'B'
     C                   SETON                                        6140
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     LCO           CHAIN(N)  FARCTL                             90
     C     ACSTTP        IFEQ      3
     C                   GOTO      NOSTCK
     C                   ENDIF
      *
     C     ACSTTP        IFEQ      1
     C     CMARCD        ANDEQ     'B'
     C                   SETON                                        6141
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     ACSTTP        IFEQ      2
     C     CMARCD        ANDEQ     'O'
     C                   SETON                                        6142
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     NOSTCK        TAG
      *
     C     CMARCD        IFNE      OARCD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMARCD        OARCD             1
      *
     C     CMAPLC        IFNE      'Y'
     C     CMAPLC        ANDNE     'N'
     C     CMAPLC        ANDNE     'B'
     C                   SETON                                        62
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMAPLC        IFNE      OAPLC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMAPLC        OAPLC             1
      *
     C     CMSMCD        IFEQ      0
     C     CMSMCD        ORGT      9
     C                   SETON                                        60
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMSMCD        IFNE      OSMCD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMSMCD        OSMCD             1 0
      *
     C     CMCODF        IFNE      'C'
     C     CMCODF        ANDNE     'K'
     C     CMCODF        ANDNE     'N'
     C                   SETON                                        64
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMCODF        IFNE      OCOD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMCODF        OCOD              1
      *
     C     CMCOPY        IFEQ      0
     C     CMCOPY        ORGT      3
     C                   SETON                                        59
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMCOPY        IFNE      OCOPY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMCOPY        OCOPY             1 0
      *
     C     CMDSHF        IFNE      'Y'
     C     CMDSHF        ANDNE     'N'
     C                   SETON                                        63
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMDSHF        IFNE      ODSHF
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMDSHF        ODSHF             1
      *
     C     CMACK         IFNE      'Y'
     C     CMACK         ANDNE     'N'
     C                   SETON                                        65
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     CMACK         IFNE      OACK
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMACK         OACK              1
      *
     C     CNT           IFGT      0
     C     VACT          ANDNE     'I'
     C                   SETON                                        98
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C                   SETOFF                                       05
     C     RSTRTD        TAG
     C                   Z-ADD     0             CRYRMM
WBADDC     USERID        CHAIN(N)  FAUTCC                             06
WBADDC*  06              Z-ADD     HSCRC#        LAST4
     C                   If        CCST3 = ' '
     C                   Eval      CCST3 = 'N'
     C                   EndIf
     C                   If        CCCRED = ' '
     C                   Eval      CCCRED = 'N'
     C                   EndIf
     C*                  Eval      HSBANK3 = %char(HSBANK)
     C*                  Eval      HSBANK3 = %Subst(%trim('000'+%char(HSBANK)):
     C*                              %len(%trim(%char(HSBANK)))+1:3)
     C                   WRITE     SCRND
     C                   SETOFF                                       809899
     C                   SETOFF                                       081011
     C                   SETOFF                                       151617
     C                   Z-ADD     0             CNT               2 0
     C                   READ      SCRND                                  90
     C*                  Eval      HSBANK = %Int(HSBANK3)
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
     C   KK              SETON                                        05
     C   KK              goto      rstrtd
     C   KI              Call      'WSPCI005'
     C                   Parm                    VCUST
     C   KI              GOTO      rstrtd
     C   KJ              Call      'WSPCI004'
     C                   Parm                    VCUST
     C                   Parm      '  '          Stat04            2
     C   KJ              GOTO      rstrtd
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
SUD02C*  KH              GOTO      RSTRTH
  |   /Free
  |
  |   *? // On F8 = ShipTo/Directions Function Key
  |      If *InKH = *On;                                                        // If  SUD02
  |         ShipToDs.Number = CMCUST;
  |         ShipToDs.Seq#   = 0;
  |         ShipToDs.Name   = CMNAME;
  |         ShipToDs.CName  = CMCNAM;
  |         ShipToDs.Adr1   = CMADD2;
  |         ShipToDs.Adr2   = CMADD3;
  |         ShipToDs.Adr3   = CMADD4;
  |         ShipToDs.Adr4   = *Blanks;
  |         ShipToDs.City   = CMCITY;
  |         ShipToDs.State  = CMSTST;
  |         ShipToDs.Zip    = CMZIP;
  |         ShipToDs.Phone  = CMPHON;
  |         ShipToDs.TaxE   = CMTXST;
  |         ShipToDs.TaxJ   = CMTXJU;
  |         ShipToDs.Pgm    = Pgm;
  |         SHR010(ShipToDs);
  |   /End-Free
  |  C                   GOTO      RSTRTD
  |  C                   Endif                                                  // Endif SUD02
SUD02C

     C   KB              GOTO      RSTRTC
     C   02              GOTO      RSTRTC
      *
     C     1             SUBST     HSCRCD:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     HSCRCD        CCCODE
     C                   CALL      'LKCRED'
     C                   PARM                    CCCODE
     C                   PARM                    CCDESC
     C                   MOVEL     *BLANKS       HSCRCD
     C                   MOVEL     CCCODE        HSCRCD
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
      * CHECK FOR NOTES REQUEST
      *
     C                   If        VIEWST3 = 1
     C*                  Eval      $CMD_Command = 'ST3 '+%Char(CMCUST)
     C*                  ExSr      $Command
      /Free
         QCmdExc('ST3 '+%Char(CMCUST):%Len('ST3 '+%Char(CMCUST)));
      /End-Free
     C                   GOTO      RSTRTD
     C                   EndIf
      *
     C                   If        VIEWST3 = 2
     C                   Call      'SCANDOC'
     C                   GOTO      RSTRTD
     C                   EndIf
      *
     C     HSCRCD        IFEQ      *BLANKS
     C                   GOTO      NOCRCD
     C                   ENDIF
      *
     C     HSCRCD        CHAIN     FMCRED                             10
     C   10              SETON                                        11
     C   11              GOTO      RSTRTD
      *
     C     HSCRC#        IFEQ      0
     C                   SETON                                        15
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     HSCRDT        IFEQ      LCRDT
     C                   GOTO      NOCRCD
     C                   ENDIF
      *
     C     HSCRDT        IFEQ      0
     C                   SETON                                        0816
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C                   MOVEL     HSCRDT        CRMTH             2 0
     C                   MOVE      HSCRDT        CRYR              2 0
      *
     C     CRMTH         IFLT      1
     C     CRMTH         ORGT      12
     C                   SETON                                        0816
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C                   MOVE      TDATE         TDYY              2 0
     C                   MOVEL     TDATE         TDMM              2 0
     C     TDYY          IFGT      70
     C                   MOVEL     19            TDYEAR            4 0
     C                   ELSE
     C                   MOVEL     20            TDYEAR            4 0
     C                   ENDIF
     C                   MOVE      TDYY          TDYEAR
     C                   MOVEL     TDYEAR        TDYYMM            6 0
     C                   MOVE      TDMM          TDYYMM
     C     CRYR          IFGT      70
     C                   MOVEL     19            CRYEAR            4 0
     C                   ELSE
     C                   MOVEL     20            CRYEAR            4 0
     C                   ENDIF
     C                   MOVE      CRYR          CRYEAR
     C                   MOVEL     CRYEAR        CRYRMM            6 0
     C                   MOVE      CRMTH         CRYRMM
      *
     C     CRYRMM        IFLT      TDYYMM
     C                   SETON                                        0817
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     NOCRCD        TAG
      *
     C     HSINCL        IFNE      'Y'
     C     HSINCL        ANDNE     'N'
     C                   SETON                                        80
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     HSINCL        IFNE      OINCL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     HSINCL        OINCL             1
      *
     C     CNT           IFGT      0
     C     VACT          ANDNE     'I'
     C                   SETON                                        98
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C                   GOTO      UPADD
      *
     C     RSTRTE        TAG
      /Free
         EMAIL  = *Blanks;
         EMNAME = *Blanks;
         MAILNAME = *Blanks;
         Exec SQL  // Get Default CUS email name and Address from FMEMAIL
           Select  EMAIL||EMNAME
           into   :MAILNAME
           From    FMEMAIL
           Where   EMACCT = :VCUST
             and   EMACTT = 'C'
             and   EMCODE = 'CUS';
         EMAIL  = %subst(MAILNAME:1:61);
         EMNAME = %subst(MAILNAME:257:30);
      /End-Free
     C                   WRITE     SCRNE
     C                   SETOFF                                       98
     C                   Z-ADD     0             CNT               2 0
     C                   READ      SCRNE                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
     C   KK              EXSR      EMAILSR
     C   KK              GOTO      RSTRTE
      *
     C     CMPTTL        IFNE      OPTTL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMPTTL        OPTTL             8
      *
     C     CMFNAM        IFNE      OFNAM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMFNAM        OFNAM            12
      *
     C     CMLNAM        IFNE      OLNAM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMLNAM        OLNAM            20
      *
     C     CMBTTL        IFNE      OBTTL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMBTTL        OBTTL            30
      *
     C     CNT           IFGT      0
     C     VACT          ANDNE     'I'
     C                   SETON                                        98
     C                   GOTO      RSTRTE
     C                   ENDIF
      *
     C                   GOTO      RSTRTB
      *
     C     RSTRTF        TAG
     C                   WRITE     SCRNF
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       1698
     C                   Z-ADD     0             CNT               2 0
     C                   READ      SCRNF                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
      *
     C     1             SUBST     VRTE1:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VRTE1         VROUTE            2
     C                   EXSR      RTESR
     C                   MOVEL     VROUTE        VRTE1
     C                   MOVEL     RDESC         RT1
     C                   GOTO      RSTRTF
     C                   ENDIF
      *
     C     VRTE1         IFGT      *BLANKS
     C     VRTE1         CHAIN     FMROUT                             90
     C   90              SETON                                        10
     C   90              GOTO      RSTRTF
     C                   MOVEL     RTDESC        RT1
     C                   ENDIF
     C                   MOVEL     VRTE1         CMRTE1
      *
     C     1             SUBST     VRTE2:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VRTE2         VROUTE            2
     C                   EXSR      RTESR
     C                   MOVEL     VROUTE        VRTE2
     C                   MOVEL     RDESC         RT2
     C                   GOTO      RSTRTF
     C                   ENDIF
      *
     C     VRTE2         IFGT      *BLANKS
     C     VRTE2         CHAIN     FMROUT                             90
     C   90              SETON                                        11
     C   90              GOTO      RSTRTF
     C                   MOVEL     RTDESC        RT2
     C                   ENDIF
     C                   MOVEL     VRTE2         CMRTE2
      *
     C     1             SUBST     VRTE3:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VRTE3         VROUTE            2
     C                   EXSR      RTESR
     C                   MOVEL     VROUTE        VRTE3
     C                   MOVEL     RDESC         RT3
     C                   GOTO      RSTRTF
     C                   ENDIF
      *
     C     VRTE3         IFGT      *BLANKS
     C     VRTE3         CHAIN     FMROUT                             90
     C   90              SETON                                        12
     C   90              GOTO      RSTRTF
     C                   MOVEL     RTDESC        RT3
     C                   ENDIF
     C                   MOVEL     VRTE3         CMRTE3
      *
     C     1             SUBST     VRTE4:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VRTE4         VROUTE            2
     C                   EXSR      RTESR
     C                   MOVEL     VROUTE        VRTE4
     C                   MOVEL     RDESC         RT4
     C                   GOTO      RSTRTF
     C                   ENDIF
      *
     C     VRTE4         IFGT      *BLANKS
     C     VRTE4         CHAIN     FMROUT                             90
     C   90              SETON                                        13
     C   90              GOTO      RSTRTF
     C                   MOVEL     RTDESC        RT4
     C                   ENDIF
     C                   MOVEL     VRTE4         CMRTE4
      *
     C     1             SUBST     VRTE5:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VRTE5         VROUTE            2
     C                   EXSR      RTESR
     C                   MOVEL     VROUTE        VRTE5
     C                   MOVEL     RDESC         RT5
     C                   GOTO      RSTRTF
     C                   ENDIF
      *
     C     VRTE5         IFGT      *BLANKS
     C     VRTE5         CHAIN     FMROUT                             90
     C   90              SETON                                        14
     C   90              GOTO      RSTRTF
     C                   MOVEL     RTDESC        RT5
     C                   ENDIF
     C                   MOVEL     VRTE5         CMRTE5
      *
     C     1             SUBST     VRTE6:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VRTE6         VROUTE            2
     C                   EXSR      RTESR
     C                   MOVEL     VROUTE        VRTE6
     C                   MOVEL     RDESC         RT6
     C                   GOTO      RSTRTF
     C                   ENDIF
      *
     C     VRTE6         IFGT      *BLANKS
     C     VRTE6         CHAIN     FMROUT                             90
     C   90              SETON                                        15
     C   90              GOTO      RSTRTF
     C                   MOVEL     RTDESC        RT6
     C                   ENDIF
     C                   MOVEL     VRTE6         CMRTE6
      *
     C     1             SUBST     VRTE7:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VRTE7         VROUTE            2
     C                   EXSR      RTESR
     C                   MOVEL     VROUTE        VRTE7
     C                   MOVEL     RDESC         RT7
     C                   GOTO      RSTRTF
     C                   ENDIF
      *
     C     VRTE7         IFGT      *BLANKS
     C     VRTE7         CHAIN     FMROUT                             90
     C   90              SETON                                        16
     C   90              GOTO      RSTRTF
     C                   MOVEL     RTDESC        RT7
     C                   ENDIF
     C                   MOVEL     VRTE7         CMRTE7
      *
     C     CMRTE1        IFNE      ORTE1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMRTE1        ORTE1             2
      *
     C     CMRTE2        IFNE      ORTE2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMRTE2        ORTE2             2
      *
     C     CMRTE3        IFNE      ORTE3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMRTE3        ORTE3             2
      *
     C     CMRTE4        IFNE      ORTE4
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMRTE4        ORTE4             2
      *
     C     CMRTE5        IFNE      ORTE5
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMRTE5        ORTE5             2
      *
     C     CMRTE6        IFNE      ORTE6
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMRTE6        ORTE6             2
      *
     C     CMRTE7        IFNE      ORTE7
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMRTE7        ORTE7             2
      *
     C     CMSTP1        IFNE      OSTP1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMSTP1        OSTP1             3 0
      *
     C     CMSTP2        IFNE      OSTP2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMSTP2        OSTP2             3 0
      *
     C     CMSTP3        IFNE      OSTP3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMSTP3        OSTP3             3 0
      *
     C     CMSTP4        IFNE      OSTP4
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMSTP4        OSTP4             3 0
      *
     C     CMSTP5        IFNE      OSTP5
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMSTP5        OSTP5             3 0
      *
     C     CMSTP6        IFNE      OSTP6
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMSTP6        OSTP6             3 0
      *
     C     CMSTP7        IFNE      OSTP7
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CMSTP7        OSTP7             3 0
      *
     C     CNT           IFGT      0
     C     VACT          ANDNE     'I'
     C                   SETON                                        98
     C                   GOTO      RSTRTF
     C                   ENDIF
      *
     C                   GOTO      RSTRTC
SUD02 * Screen Removed from the Screen(Replaced By ShipTo Screen)
  |  C*    RSTRTH        TAG
  |  C*    CMCUST        CHAIN     FCMDIR                             94
  |  C*  94              DO
  |  C*                  MOVE      *BLANKS       CMCOR1
  |  C*                  MOVE      *BLANKS       CMCOR2
  |  C*                  MOVE      *BLANKS       CMDR01
  |  C*                  MOVE      *BLANKS       CMDR02
  |  C*                  MOVE      *BLANKS       CMDR03
  |  C*                  MOVE      *BLANKS       CMDR04
  |  C*                  MOVE      *BLANKS       CMDR05
  |  C*                  MOVE      *BLANKS       CMDR06
  |  C*                  MOVE      *BLANKS       CMDR07
  |  C*                  MOVE      *BLANKS       CMDR08
  |  C*                  MOVE      *BLANKS       CMDR09
  |  C*                  MOVE      *BLANKS       CMDR10
  |  C*                  MOVE      *BLANKS       CMDR11
  |  C*                  ENDDO
  |   *
  |  C*                  WRITE     SCRNH
  |  C*                  Z-ADD     0             CNT               2 0
  |  C*                  READ      SCRNH                                  90
  |   *
  |  C*  KC
  |  C*OR KG              SETON                                        LR
  |  C*   KC
  |  C*OR KG              GOTO      END
  |   *
  |  C*                  MOVEL     'A'           CMSTAT
  |  C*  94CMCOR1        IFGT      *BLANKS
  |  C*    CMCOR2        ORGT      *BLANKS
  |  C*    CMDR01        ORGT      *BLANKS
  |  C*    CMDR02        ORGT      *BLANKS
  |  C*    CMDR03        ORGT      *BLANKS
  |  C*    CMDR04        ORGT      *BLANKS
  |  C*    CMDR05        ORGT      *BLANKS
  |  C*    CMDR06        ORGT      *BLANKS
  |  C*    CMDR07        ORGT      *BLANKS
  |  C*    CMDR08        ORGT      *BLANKS
  |  C*    CMDR09        ORGT      *BLANKS
  |  C*    CMDR10        ORGT      *BLANKS
  |  C*    CMDR11        ORGT      *BLANKS
  |  C*                  WRITE     RCMDIR
  |  C*                  ENDIF
  |  C* N94              UPDATE    RCMDIR
  |   *
SUD02C*                  GOTO      RSTRTD
      *
      * UPDATE CUSTOMER MASTER FILE ON DISK
      *
     C     UPADD         TAG
     C                   MOVEL     VLOOK         CMLOOK
     C                   MOVEL     VTRMCD        CMTMCD
     C                   Z-ADD     TDATE         CMDTLA
     C                   MOVEL     USERID        CMUSER
     C                   Z-ADD     TIMOD         CMTIME
     C     VACT          IFEQ      'I'
     C                   GOTO      ENDALL
     C                   ENDIF
     C     VACT          IFEQ      'A'
     C                   MOVEL     'Y'           CMNCUS
     C                   MOVEL     'A'           CMSTAT
     C                   MOVEL     'A'           HSSTAT
     C                   MOVEL     'A'           CCSTAT
     C                   WRITE     RMCUST
     C                   WRITE     RARHST
     C* N95                UPDATRARHST
     C   72              WRITE     RCUSTCOM
     C                   GOTO      ENDALL
     C                   ENDIF
     C     VACT          IFEQ      'R'
     C                   MOVEL     'A'           CMSTAT
     C                   MOVEL     'A'           HSSTAT
     C                   MOVEL     'A'           CCSTAT
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   MOVEL     'D'           CMSTAT
     C                   MOVEL     'D'           HSSTAT
     C                   MOVEL     'D'           CCSTAT
     C                   ENDIF
     C     VACT          IFNE      'A'
     C                   UPDATE    RMCUST
     C                   UPDATE    RARHST
     C  N92              UPDATE    RCUSTCOM
     C   92              WRITE     RCUSTCOM
SUD02C                   Exsr      WriteUpdRec
     C                   ENDIF
     C     ENDALL        TAG
     C                   EXSR      CLRIT
     C                   GOTO      RSTRTA
      *
     C     END           TAG
      *
      *********
      * RTESR
      *********
    ?C*COPY QFunctDefn,$CommandSR
     C     EMAILSR       BEGSR
     C                   CALL      'EMCMNT'
     C                   PARM                    VCUST
     C                   PARM                    VRRN              9 0
     C                   PARM      '1'           VUPDATE           1
     C                   EndSR

     C     RTESR         BEGSR
     C                   MOVEL     VROUTE        RTCODE            2
     C                   CALL      'LKRTE'
     C                   PARM                    RTCODE
     C                   PARM                    RTDESC           30
     C                   MOVEL     *BLANKS       VROUTE
     C                   MOVEL     RTCODE        VROUTE
     C                   MOVEL     RTDESC        RDESC            30
     C                   ENDSR
      *
      * CLRIT - THIS SUBROUTINE PROCESSES RESTART AND UPDATE OPTIONS
      *
     C     CLRIT         BEGSR
     C                   MOVE      *BLANKS       VCUST
EFD  C                   MOVE      *BLANKS       VLOOK
     C                   MOVE      *BLANKS       CMSTAT
     C                   Z-ADD     0             CMCUST
     C                   MOVE      *BLANKS       CMCTYP
     C                   MOVE      *BLANKS       CMNAME
     C                   MOVE      *BLANKS       CMADD2
     C                   MOVE      *BLANKS       CMADD3
     C                   MOVE      *BLANKS       CMADD4
     C                   MOVE      *BLANKS       CMCITY
     C                   MOVE      *BLANKS       CMSTST
     C                   MOVE      *BLANKS       CMZIP
     C                   MOVE      *BLANKS       CMCOUN
     C                   MOVE      *BLANKS       CMSLSM
     C                   MOVE      *BLANKS       CMTERR
     C                   Z-ADD     0             CMPHON
     C                   MOVE      *BLANKS       CMCNAM
     C                   MOVE      *BLANKS       CMPTTL
     C                   MOVE      *BLANKS       CMFNAM
     C                   MOVE      *BLANKS       CMLNAM
     C                   MOVE      *BLANKS       CMBTTL
     C                   Z-ADD     0             CMCRL$
     C                   MOVEL     *BLANKS       CMTMCD
     C                   MOVE      *BLANKS       CMCODF
     C                   Z-ADD     0             CMPRCD
     C                   MOVEL     *BLANKS       CMQDIS
     C                   MOVE      *BLANKS       CMARCD
     C                   MOVE      *BLANKS       CMBOOK
     C                   Z-ADD     0             CMSMCD
     C                   MOVE      *BLANKS       CMAPLC
     C                   Z-ADD     0             CMTRDC
     C                   MOVE      *BLANKS       CMNCUS
     C                   MOVE      *BLANKS       CMCTCD
     C                   Z-ADD     0             CMCOMM
     C                   MOVE      *BLANKS       CMSHIN
     C                   MOVE      *BLANKS       CMSPIN
     C                   MOVE      *BLANKS       CMTXST
     C                   MOVE      *BLANKS       CMTXJU
     C                   MOVE      *BLANKS       CMFETD
     C                   Z-ADD     0             CMOCUR
     C                   Z-ADD     0             CMOYTD
     C                   Z-ADD     0             CMDTLO
     C                   Z-ADD     0             CMVOPO
     C                   Z-ADD     0             CMCSL$
     C                   Z-ADD     0             CMYSL$
     C                   Z-ADD     0             CMDTLS
     C                   Z-ADD     0             CMCCS$
     C                   Z-ADD     0             CMYCS$
     C                   Z-ADD     0             CMARB$
     C                   Z-ADD     0             CMDTLP
     C                   MOVE      *BLANKS       CMLOOK
     C                   Z-ADD     0             CMDTLA
     C                   Z-ADD     0             CMTIME
     C                   MOVE      *BLANKS       CMUSER
     C                   Z-ADD     0             CMCOMP
     C                   MOVE      *BLANKS       CMSHFR
     C                   MOVE      *BLANKS       CMPORQ
     C                   MOVE      *BLANKS       CMTXID
     C                   MOVE      *BLANKS       CMUPSZ
     C                   MOVE      *BLANKS       CMRTE1
     C                   MOVE      *BLANKS       CMRTE2
     C                   MOVE      *BLANKS       CMRTE3
     C                   MOVE      *BLANKS       CMRTE4
     C                   MOVE      *BLANKS       CMRTE5
     C                   MOVE      *BLANKS       CMRTE6
     C                   MOVE      *BLANKS       CMRTE7
     C                   MOVE      *BLANKS       RT1
     C                   MOVE      *BLANKS       RT2
     C                   MOVE      *BLANKS       RT3
     C                   MOVE      *BLANKS       RT4
     C                   MOVE      *BLANKS       RT5
     C                   MOVE      *BLANKS       RT6
     C                   MOVE      *BLANKS       RT7
     C                   MOVE      *BLANKS       VRTE1
     C                   MOVE      *BLANKS       VRTE2
     C                   MOVE      *BLANKS       VRTE3
     C                   MOVE      *BLANKS       VRTE4
     C                   MOVE      *BLANKS       VRTE5
     C                   MOVE      *BLANKS       VRTE6
     C                   MOVE      *BLANKS       VRTE7
     C                   Z-ADD     0             CMSTP1
     C                   Z-ADD     0             CMSTP2
     C                   Z-ADD     0             CMSTP3
     C                   Z-ADD     0             CMSTP4
     C                   Z-ADD     0             CMSTP5
     C                   Z-ADD     0             CMSTP6
     C                   Z-ADD     0             CMSTP7
     C                   Z-ADD     0             CMARCU
     C                   Z-ADD     0             CMSACU
     C                   Z-ADD     0             CMBLCU
     C                   Z-ADD     0             CMCOPY
     C                   MOVEL     *BLANKS       CMJOBR
     C                   MOVEL     *BLANKS       CMORLS
     C                   MOVEL     *BLANKS       CMDSHF
     C                   Z-ADD     0             CMCOPY
     C                   Z-ADD     0             CMCUR$
     C                   Z-ADD     0             CMAR1$
     C                   Z-ADD     0             CMAR2$
     C                   Z-ADD     0             CMAR3$
     C                   Z-ADD     0             CMAR4$
     C                   Z-ADD     0             CMFUT$
     C                   Z-ADD     0             CMIREF
     C                   MOVE      *BLANKS       CMCNME
     C                   Z-ADD     0             CMPHO2
     C                   MOVE      *BLANKS       CMBABB
     C                   MOVE      *BLANKS       CMPHYT
     C                   MOVE      *BLANKS       CMSVCD
     C                   MOVE      *BLANKS       CMFILL
      *
     C                   MOVE      *BLANKS       HSSRCE
     C                   MOVE      *BLANKS       HSSIC#
     C                   MOVE      *BLANKS       HSBDRT
     C                   Z-ADD     0             HSSIZE
     C                   Z-ADD     0             HS#EMP
     C                   Z-ADD     0             HSFNDT
     C                   MOVE      *BLANKS       HSAUDT
     C                   MOVE      *BLANKS       HSCOM1
     C                   MOVE      *BLANKS       HSCOM2
     C                   MOVE      *BLANKS       HSCOM3
     C                   Z-ADD     0             HSDTFS
     C                   Z-ADD     0             HSDTLS
     C                   Z-ADD     0             HSAMLS
     C                   Z-ADD     0             HSDTLP
     C                   Z-ADD     0             HSAMLP
     C                   Z-ADD     0             HSHARB
     C                   Z-ADD     0             HSDTAR
     C                   Z-ADD     0             HS#INV
     C                   Z-ADD     0             HS#ORD
     C                   Z-ADD     0             HS#CRM
     C                   Z-ADD     0             HSAVOR
     C                   Z-ADD     0             HSTMDL
     C                   Z-ADD     0             HSAVDY
     C                   Z-ADD     0             HS#PAY
     C                   Z-ADD     0             HSFAX
     C                   MOVEL     *BLANKS       HSCRCD
     C                   Z-ADD     0             HSCRC#
     C                   MOVEL     'Y'           HSINCL
     C                   Z-ADD     0             HSCRDT
     C                   Z-ADD     0             HSBANK
      *
     C                   MOVE      *BLANKS       CKBABB
     C                   MOVE      *BLANKS       CCCOM1
     C                   MOVE      *BLANKS       CCCOM2
     C*                  CLEAR                   SCRNA
     C*                  CLEAR                   SCRNB
     C*                  CLEAR                   SCRNC
     C*                  CLEAR                   SCRND
     C*                  CLEAR                   SCRNE
     C*                  CLEAR                   SCRNF
     C*                  CLEAR                   SCRNH
     C*                  CLEAR                   RCMDIR
     C*                  CLEAR                   RMCUST
     C*                  CLEAR                   RARHST
     C*                  CLEAR                   RCUSTCOM
     C                   Z-ADD     0             COKEY             2 0
     C     COKEY         CHAIN(N)  FARCTL                             97
     C                   ENDSR
      *
      *  LODCUS - LOAD FIELDS INTO OLD FIELDS
      *
     C     LODCUS        BEGSR
     C                   MOVEL     CMLOOK        OLOOK            15
     C                   MOVEL     CMLOOK        VLOOK            15
     C                   MOVEL     CMNAME        ONAME            30
     C                   MOVEL     CMADD2        OADD2            30
     C                   MOVEL     CMADD3        OADD3            30
     C                   MOVEL     CMADD4        OADD4            30
     C                   MOVEL     CMCITY        OCITY            18
     C                   MOVEL     CMSTST        OSTST             2
     C                   MOVEL     CMCNME        OCNME            30
     C                   MOVEL     CMZIP         OZIP              9
     C                   Z-ADD     CMPHON        OPHON            10 0
     C                   Z-ADD     CMPHO2        OPHO2            10 0
     C                   Z-ADD     HSFAX         OFAX             10 0
     C                   Z-ADD     CMARCU        OARCU             6 0
     C                   MOVEL     CMSLSM        OSLSM             2
     C                   MOVEL     CMCTYP        OTYPE             2
     C                   Z-ADD     CMSACU        OSACU             6 0
     C                   MOVEL     CMTERR        OTERR             2
     C                   MOVEL     CMORLS        OORLS
     C                   Z-ADD     CMBLCU        OBLCU             6 0
     C                   Z-ADD     CMCOMM        OCOMM             4 2
     C                   MOVEL     CMJOBR        OJOBR             1
     C                   MOVEL     CMPORQ        OPORQ             1
     C                   Z-ADD     CMIREF        OIREF             6 0
     C                   MOVEL     CMPRCD        OPRCD             1 0
     C                   MOVEL     CMCTCD        OCTCD             1
     C                   MOVEL     CMBOOK        OBOOK             1
     C                   Z-ADD     CMTRDC        OTRDC             4 2
     C                   MOVEL     CMQDIS        OQDIS             1
     C                   MOVEL     CMSHIN        OSHIN            30
     C                   MOVEL     CMUPSZ        OUPSZ             1
     C                   MOVEL     CMSPIN        OSPIN            30
     C                   MOVEL     CMSVCD        OSVCD             2
     C                   MOVEL     CMTXST        OTXST             1
     C                   MOVEL     CMTXJU        OTXJU             3
     C                   MOVEL     CMTMCD        OTMCD             2
     C                   Z-ADD     CMCRL$        OCRL$             9 2
     C                   MOVEL     CMCNAM        OCNAM            30
     C                   MOVEL     CMARCD        OARCD             1
     C                   MOVEL     CMAPLC        OAPLC             1
     C                   MOVEL     CMSMCD        OSMCD             1 0
     C                   MOVEL     CMCODF        OCOD              1
     C                   MOVEL     CMCOPY        OCOPY             1 0
     C                   MOVEL     CMDSHF        ODSHF             1
     C                   MOVEL     CMACK         OACK              1
     C                   MOVEL     CMPTTL        OPTTL             8
     C                   MOVEL     CMFNAM        OFNAM            12
     C                   MOVEL     CMBTTL        OBTTL            30
     C                   MOVEL     CMLNAM        OLNAM            20
     C                   ENDSR
      *
      *  LODARH - LOAD FIELDS INTO OLD FIELDS FROM ARHST
      *
     C     LODARH        BEGSR
     C                   MOVEL     HSINCL        OINCL             1
     C                   Z-ADD     HSCRDT        LCRDT             4 0
     C                   ENDSR
      *
      * WRTCOM - Write initial FCUSTCOM record
      *
     C     WRTCOM        BEGSR
     C                   Eval      CCSTAT = 'A'
     C                   Eval      CCCOM1 = *Blanks
     C                   Eval      CCCOM2 = *Blanks
     C                   Eval      CCEML  = *Blanks
     C                   Eval      CCURL  = *Blanks
     C                   Eval      CCST3  = 'N'
     C                   Eval      CCCRED = 'N'
     C   92              Write     RCUSTCOM
     C  N92              Update    RCUSTCOM
     C     KEY8          CHAIN     FCUSTCOM                           92
     C                   ENDSR
      *
      * LODCOM - LOAD FIELDS INTO OLD FIELDS FROM CUSTCOM
      *
     C     LODCOM        BEGSR
     C     VACT          IFNE      'A'
     C                   MOVEL     CCCOM1        OCOM1            30
     C                   MOVEL     CCCOM2        OCOM2            30
     C                   Else
     C                   clear                   RCUSTCOM
     C     KEY8          CHAIN     FCUSTCOM                           92
     C                   ExSr      WRTCOM
     C                   EndIf
     C                   ENDSR
      *
      * GETDEF - THIS SUBROUTINE GETS DEFAULT DATA FROM MCDEF ON ADD
      *
     C     GETDEF        BEGSR
     C     LCO           CHAIN(N)  FMCDEF                             98
      *  Screen B
     C                   MOVEL     CDSLSM        CMSLSM
     C                   MOVE      CDTERR        CMTERR
     C                   Z-ADD     CDCOMM        CMCOMM
     C                   MOVE      'N'           CMPORQ
WJB  C                   MOVE      *Blanks       CMCTYP
WJB  C                   MoveL     '*NONE'       CMORLS
     C                   MOVE      'N'           CMJOBR
      *  Screen C
     C                   Z-ADD     CDPRCD        CMPRCD
     C                   MOVE      CDCTCD        CMCTCD
     C                   MOVE      CDBOOK        CMBOOK
     C                   MOVE      CDQDIS        CMQDIS
     C                   Z-ADD     CDTRDC        CMTRDC
     C                   MOVE      CDSHIN        CMSHIN
WJB  C                   MOVE      *Blanks       CMSPIN
WJB  C                   MOVE      *Blanks       CMSHFR
     C                   MOVE      CDFRTZ        CMUPSZ
     C                   MOVE      CDTXST        CMTXST
WJB  C                   MOVE      *Blanks       CMTXJU
WJB  C                   MOVE      *Blanks       CMTXID
     C                   MOVEL     CDTMCD        VTRMCD
     C                   Z-ADD     CDCRL$        CMCRL$
WJB  C                   MOVE      *Blanks       CMCNAM
     C                   MOVE      CDARCD        CMARCD
     C                   MOVE      CDAPLC        CMAPLC
     C                   MOVE      CDSMCD        CMSMCD
     C                   Z-ADD     1             CMSMCD
     C                   MOVE      CDCODF        CMCODF
     C                   MOVE      CDCOPY        CMCOPY
     C                   MOVE      CDPDSL        CMDSHF
     C                   MOVE      'Y'           CMACK
      *  Screen D
WJB  C                   MOVE      *Blanks       HSCRCD
WJB  C                   MOVE      *Zeros        HSCRDT
WJB  C                   MOVE      *Zeros        HSCRC#
WJB  C                   MOVE      *Zeros        HSBANK
WJB  C                   MOVE      'N'           CCST3
WJB  C                   MOVE      'N'           CCCRED
     C                   MOVE      'Y'           HSINCL
WJB  C                   MOVE      *Blanks       HSCOM1
WJB  C                   MOVE      *Blanks       HSCOM2
WJB  C                   MOVE      *Blanks       HSCOM3
      *  Screen E
WJB  C                   MOVE      *Blanks       CMPTTL
WJB  C                   MOVE      *Blanks       CMFNAM
WJB  C                   MOVE      *Blanks       CMLNAM
WJB  C                   MOVE      *Blanks       CMBTTL
WJB  C                   MOVE      *Blanks       CCEML
WJB  C                   MOVE      *Blanks       CCURL
      *  Screen H
WJB  C                   MOVE      *Blanks       CMCOR1
WJB  C                   MOVE      *Blanks       CMCOR2
WJB  C                   MOVE      *Blanks       CMDR01
WJB  C                   MOVE      *Blanks       CMDR02
WJB  C                   MOVE      *Blanks       CMDR03
WJB  C                   MOVE      *Blanks       CMDR04
WJB  C                   MOVE      *Blanks       CMDR05
WJB  C                   MOVE      *Blanks       CMDR06
WJB  C                   MOVE      *Blanks       CMDR07
WJB  C                   MOVE      *Blanks       CMDR08
WJB  C                   MOVE      *Blanks       CMDR09
WJB  C                   MOVE      *Blanks       CMDR10
WJB  C                   MOVE      *Blanks       CMDR11
      *  Other
     C                   MOVE      CDSVIA        CMSVCD
     C                   ENDSR
      *
      * GET DEFAULT SHIP VIA INFO
      *
     C     SVSR          BEGSR
     C     CMSVCD        CHAIN     FMSVIA                             97
     C  N97              MOVEL     SVDESC        CMSHPV           30
     C                   ENDSR
SUD02 /Free
  |   //--------------------------------------------------------------------
  |   *?                :------------------------:
  |   *?                : WriteUpdRec Subroutine :
  |   *?                :------------------------:
  |   *
  |   *?Logic : Move Values into File Fields
  |   *?
  |     Begsr WriteUpdRec;
  |
  |   *?   // Move Values based on Flag
  |        WkSeq# = *Zeros;
  |        Chain (CMCUST:WkSeq#) FSHIPTOL0;
  |        If Not %Found;
  |           STCust = CMCust;
  |           STSeq# = WkSeq#;
  |           STName = CMNAME;
  |           STCNam = CMCNME;
  |           STAdr1 = CMADD2;
  |           STAdr2 = CMADD3;
  |           STAdr3 = CMADD4;
  |           STAdr4 = *Blanks;
  |           STCity = CMCITY;
  |           STStSt = CMSTST;
  |           STZip  = CMZIP;
  |           STPhon = CMPHON;
  |           STTxst = CMTXST;
  |           STTxju = CMTXJU;
  |           STCRTDAT = RunDate;
  |           STCRTTIM = RunTime;
  |           STCRTUSR = UserId;
  |           STCRTJOB = Job;
  |           STCRTPGM = Pgm;
  |           Write FSHIPTOR;
  |        Else;
  |           STName = CMNAME;
  |           STCNam = CMCNME;
  |           STAdr1 = CMADD2;
  |           STAdr2 = CMADD3;
  |           STAdr3 = CMADD4;
  |           STAdr4 = *Blanks;
  |           STCity = CMCITY;
  |           STStSt = CMSTST;
  |           STZip  = CMZIP;
  |           STPhon = CMPHON;
  |           STTxst = CMTXST;
  |           STTxju = CMTXJU;
  |           STUPDDAT = RunDate;
  |           STUPDTIM = RunTime;
  |           STUPDUSR = UserId;
  |           STUPDJOB = Job;
  |           STUPDPGM = Pgm;
  |           Update FSHIPTOR %Fields(STName:StCNam:STAdr1:STAdr2:STAdr3:StAdr4
  |                            :STCity:STStst:STZip:StPhon:STTxst:STTxju:
  |                            STUPDDAT:STUPDTIM:STUPDUSR:STUPDJOB:STUPDPGM);
  |        Endif;
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
SUD02 /End-free
**
   Add
  Change
  Delete
Reactivate
 Inquiry
