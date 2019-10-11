    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      **PROGRAM NAME-------- CUR210
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT CUTTING NEEDS REPORT
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/15/01 EFD SHIFT REPORT 1 POS TO LEFT.
      *
      *
     FFCALEN    IF   E           K DISK
     F                                     RENAME(RCALEN:CALENI)
     FFCALEX    IF   E           K DISK
     FFMINVT    IF   E           K DISK
WJB01FFMSIZE    IF   E           K DISK
     FFCUTLOT   IF   E           K DISK
     F                                     RENAME(RCUTLOT:CUTLOT)
     FFCUTLOTA  IF   E           K DISK
     FFCUTNEED  O    E           K DISK
     FCUR210    O    F   80        PRINTER OFLIND(*INOF)
WJB  FFMVEND    IF   E           K DISK
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(5) CTDATA PERRCD(1)              MESSAGES
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
      ****************
      * LDA          *
      ****************
     D                UDS
      ** REPORT ONLY  Y/N
     D  RPTONL                 1      1
      ** SEQUENCE  A=ALPHA  N=NUMERIC
     D  RPTSEQ                 2      2
      ** SHOW ALL Y/N
     D  SHOALL                 3      3
      ** SOW DATE MDY
     D  SOWDAT                 4      9  0
      ** SOW DATE CYMD
     D  SOWCYM                10     16  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  CANORD               172    172
WJB
WJB  D  Vendor         S                   Like(IMVEND)
WJB  D  SavCLVEND      S                   Like(CLVEND)
WJB  D  VMNAMEin       S                   Like(VMNAME)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7


      ****************
      * START HERE   *
      ****************
     C                   MOVE      *BLANKS       CLITEM
     C                   MOVE      *BLANKS       CLLOOK
WJB  C     VendItem      KList
WJB  C                   KFld                    Vendor
WJB  C                   KFld                    CLITEM
WJB  C     VendLook      KList
WJB  C                   KFld                    Vendor
WJB  C                   KFld                    CLLOOK
     C                   If        CANORD = 'Y'
     C                   Eval      *In40 = *On
     C                   Else
     C                   Eval      *In40 = *Off
     C                   EndIf
WJB  C*    CLITEM        SETLL     FCUTLOT
WJB  C     VendItem      SETLL     FCUTLOT
WJB  C*    CLLOOK        SETLL     FCUTLOTA
WJB  C     VendLook      SETLL     FCUTLOTA
      ** READ NEXT RECORD
     C     NXT           TAG
     C     RPTSEQ        IFEQ      'A'
     C                   READ      FCUTLOTA                               90
     C                   MOVEL     MSG(2)        SEQ              20
     C                   ELSE
     C                   READ      FCUTLOT                                90
     C                   MOVEL     MSG(3)        SEQ              20
     C                   END
     C                   If        Vendor <> CLVEND and
     C                             Vendor <> *Zero
     C                             or *In90
     C                   Goto      End
     C                   EndIf
     C* N90CLVEND        Comp      Vendor                             9090
     C*  90              GOTO      END
     C     CLSOWD        IFLT      BEGSCY
     C                   GOTO      NXT
     C                   END
      ** IF SOW DATE ENTERED ONLY USE THAT SOW DATE
     C     SOWCYM        IFGT      0
     C     CLSOWD        ANDNE     SOWCYM
     C                   GOTO      NXT
     C                   END
      ** ROUND TO NXT 100
     C                   Z-ADD     CLQTSL        QTYORD
     C                   Z-ADD     0             QTYNED
     C                   CALL      'CUR010'
     C                   PARM                    QTYORD            7 0
     C                   PARM                    QTYNED            7 0
     C     QTYNED        SUB       CLQTOH        NEED              7 0
     C                   SUB       CLQTOO        NEED              7 0
      ** SEE IF WE NEED
     C*    NEED          IFGE      -100
     C     NEED          IFGT      -100
     C                   GOTO      NXT
     C                   END
     C                   Mult      -1            NEED
     C     MINKEY        KLIST
     C                   KFLD                    CLITEM
     C                   KFLD                    CLSIZE
     C     MINKEY        CHAIN     FMINVT                             91
     C   91              MOVEL     MSG(1)        IMDES1

WJB01 *   get number of cells per flat
WJB01C     CLSIZE        Chain     FMSIZE
WJB01C                   If        not %Found(FMSIZE) or SZSALE = *Zero
WJB01C                   Eval      SZSALE = 100
WJB01C                   EndIf

      ** IF HERE PRINT
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF DO
      ** GET SOW DATE INTO MDY
     C                   Z-ADD     CLSOWD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SOWMDY            6 0
WJB01C*    NEED          DIV       105           TRAYND            5 0
WJB01C*    NEED          DIV       SZCELL        TRAYND            5 0
WJB01C     NEED          DIV       SZSALE        TRAYND            5 0
     C                   If        CLVEND <> SavCLVEND
     C     CLVEND        CHAIN     FMVEND
     C                   EXCEPT    VEND
     C                   Eval      SavCLVEND = CLVEND
     C                   EndIf
     C                   EXCEPT    DETL

     C                   If        CANORD = 'Y'

     C                   Eval      CNVEND = CLVEND
     C                   Eval      CNSTAT = 'A'
     C                   Eval      CNRYMD = $Date7($Date(0))
     C                   Eval      CNITEM = CLITEM
     C                   Eval      CNSIZE = CLSIZE
     C                   Eval      CNUSEC = CLUSEC
     C                   Eval      CNSOWD = CLSOWD
     C                   Eval      CNLOOK = CLLOOK

     C                   Eval      CNQTSL = -TRAYND
     C                   Eval      CNQTND = -Need
     C                   Eval      CNQTSH = *Zero
     C                   Write     RCUTNEED
     C                   EndIf

     C                   ADD       CLQTSL        TOTSL             8 0
     C                   ADD       CLQTOH        TOTOH             8 0
     C                   ADD       CLQTOO        TOTOO             8 0
     C                   ADD       NEED          TOTND             8 0
     C                   ADD       TRAYND        TOTTR             8 0
     C                   GOTO      NXT
      ** END PROGRAM
     C     END           TAG
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF DO
     C                   EXCEPT    TOTL
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
WJB  C     *Entry        PList
WJB  C                   Parm                    Vendor
     C                   If        Vendor <> *Zero
WJB  C     Vendor        Chain     FMVEND
     C                   Eval      VMNAMEin = VMNAME
     C                   Else
     C                   Eval      VMNAMEin = 'All Vendors'
     C                   EndIf
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      ** GET LOWEST SOW DATE (THIS WEEK)
     C     TDATE         CHAIN     FCALEN                             90
     C                   Z-ADD     CLCYMD        RPTCYM            7 0
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             90
     C                   Z-ADD     CLCYMD        BEGSCY            7 0
     C                   Z-ADD     CLDATE        BEGDAT            6 0
     C                   SETON                                        OF
     C     SOWCYM        IFGT      0
     C                   SETON                                        55
     C                   ELSE
     C                   SETOFF                                       55
     C                   END
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OCUR210    E            HEAD           1 03
     O                                            6 'CUR210'                      6
     O                                           21 'Requested by:'              21
     O                       USERID              32                              32
WJB  O              n40                          54 'Cutting Overage'            56
WJB  O              n40                          61 ' Report'                    63
WJB  O               40                          53 'Cancellation Order'         56
WJB  O               40                          62 ' Report'                    63
     O                       PAGE          Z     80                              84
     O                                           76 'Page:'                      80
     O          E            HEAD           1
     O                                            9 'Run Date:'                   9
     O                       TDATE         Y     18                              18
     O                                           45 'For Sow Date:'              47
     O              N55      BEGDAT        Y     54                              56
     O               55      SOWDAT        Y     54                              56
     O              N55                          64 'and Later'                  66
     O               55                          64 'Only.    '                  66
     O                       TIMOD               80 '  :  :  '                   84
     O          E            HEAD           2
     O              n40                          13 'Report Only:'               13
     O               40                          13 'Cancellation'               13
     O              n40      RPTONL              15                              15
     O                                           35 'Show All:'                  35
     O                       RPTONL              37                              37
     O                       SEQ                 65                              65
     O          E            HEAD           1
WJB  O                       Vendor               6                               6
WJB  O                       VMNAMEin            38                              38
     O                                           73 '----Cutting Quantity----'   73
     O          E            HEAD           1
     O                                            4 'Item'                        4
     O                                           54 'Cust.'                      53
     O                                           61 'Vend'                       61
     O                                           67 'Vend'                       69
     O                                           74 'Cuts'                       77
     O          E            HEAD           0
     O                                            8 '/Size'                       4
     O                                           20 'Description'                17
     O                                           47 'Sow Date'                   45
     O                                           54 'Orders'                     53
     O                                           61 'Conf'                       61
     O                                           67 'Ordr'                       69
     O                                           74 'Over'                       77
     O                                           80 'Trays'                      84
     O          E            HEAD           1
     O                                           20 '____________________'       20
     O                                           40 '____________________'       40
     O                                           60 '____________________'       60
     O                                           80 '____________________'       80
     O          E            VEND        1  0
     O                       VMNAME              30
     O          E            VEND        0  1
     O                       VMNAME              30
     O          EF           DETL           1
     O                       CLITEM              12                              12
     O                                           05 '-'
     O                       CLSIZE              08
     O                       IMDES1              39                              36
     O                       TRAYND        1     80                              84
     O                       NEED          1     74                              77
     O                       CLQTOO        L     68                              69
     O                       CLQTOH        L     62                              61
     O                       CLQTSL        L     55                              53
     O                       SOWMDY        Y     47                              45
     O          E            TOTL           1
     O                                           54 '======'                     53
     O                                           61 '======'                     61
     O                                           67 '======'                     69
     O                                           74 '======'                     77
     O                                           80 '====='                      84
     O          E            TOTL           1
     O                                           39 'Report Totals =======>'     39
     O                       TOTSL         L     55                              53
     O                       TOTOO         L     68                              69
     O                       TOTTR         1     80                              84
     O          E            TOTL           1
     O                       TOTOH         L     62                              61
     O                       TOTND         1     74                              77
** Messages
No Item Number Found                           1
Alphabetic Sequence                            2
Numeric Sequence                               3
