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
      **PROGRAM NAME-------- CUR220
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT CUTTING NEEDS REPORT SHORTAGE
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
     FCUR220    O    F   80        PRINTER OFLIND(*INOF)
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
WJB
WJB  D  Vendor         S                   Like(IMVEND)
WJB  D  SavCLVEND      S                   Like(CLVEND)
WJB  D  VMNAMEin       S                   Like(VMNAME)
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
WJB  C* N90CLVEND        Comp      Vendor                             9090
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
     C     NEED          IFLT      1
     C                   GOTO      NXT
     C                   END
     C     MINKEY        KLIST
     C                   KFLD                    CLITEM
     C                   KFLD                    CLSIZE
     C     MINKEY        CHAIN     FMINVT                             91
     C   91              MOVEL     MSG(1)        IMDES1

WJB01 *   get number of cells per flat
WJB01C*                  If        IMFRSZ = *Blanks
WJB01C*                  Eval      IMFRSZ = '105'
WJB01C*                  EndIf
WJB01C*                  If        IMFRSZ <> '105' and
WJB01C*                            IMFRSZ <> '48'
WJB01C*                  Eval      SZCELL = 105
WJB01C*                  Else
WJB01C     CLSIZE        Chain     FMSIZE
WJB01C                   If        not %Found(FMSIZE)
WJB01C*                  Eval      SZCELL = 105
WJB01C                   Eval      SZSALE = 105
WJB01C                   EndIf
WJB01C*                  EndIf

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
WJB01C*    NEED          DIV       SZCELL        TRAYND            5 0
WJB01C     NEED          DIV       SZSALE        TRAYND            5 0
     C                   If        CLVEND <> SavCLVEND
     C     CLVEND        CHAIN     FMVEND
     C                   EXCEPT    VEND
     C                   Eval      SavCLVEND = CLVEND
     C                   EndIf
     C                   EXCEPT    DETL
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
     OCUR220    E            HEAD           1 03
     O                                            6 'CUR220'
     O                                           21 'Requested by:'
     O                       USERID              32
WJB  O                                           54 'Cutting Shortage'
WJB  O                                           61 ' Report'
     O                       PAGE          Z     80
     O                                           76 'Page:'
     O          E            HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           45 'For Sow Date:'
     O              N55      BEGDAT        Y     54
     O               55      SOWDAT        Y     54
     O              N55                          64 'and Later'
     O               55                          64 'Only.    '
     O                       TIMOD               80 '  :  :  '
     O          E            HEAD           2
     O                                           13 'Report Only:'
     O                       RPTONL              15
     O                                           35 'Show All:'
     O                       RPTONL              37
     O                       SEQ                 65
     O          E            HEAD           1
WJB  O                       Vendor               6
WJB  O                       VMNAMEin            38
     O                                           73 '----Cutting Quantity----'
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
     O                                           74 'Short'                      77
     O                                           80 'Trays'                      84
     O          E            HEAD           1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O          E            VEND        1  0
     O                       VMNAME              30
     O          E            VEND        0  1
     O                       VMNAME              30
     O          EF           DETL           1
     O                       CLITEM              12
     O                                           05 '-'
     O                       CLSIZE              08
     O                       IMDES1              39
     O                       TRAYND        1     80
     O                       NEED          1     74
     O                       CLQTOO        L     68
     O                       CLQTOH        L     62
     O                       CLQTSL        L     55
     O                       SOWMDY        Y     47
     O          E            TOTL           1
     O                                           54 '======'
     O                                           61 '======'
     O                                           67 '======'
     O                                           74 '======'
     O                                           80 '====='
     O          E            TOTL           1
     O                                           39 'Report Totals =======>'
     O                       TOTSL         L     55
     O                       TOTOO         L     68
     O                       TOTTR         1     80
     O          E            TOTL           1
     O                       TOTOH         L     62
     O                       TOTND         1     74
** Messages
No Item Number Found                           1
Alphabetic Sequence                            2
Numeric Sequence                               3
