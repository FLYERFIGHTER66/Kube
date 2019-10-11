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
      **PROGRAM NAME-------- CUR200
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT CUTTING NEEDS REPORT
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/15/01 EFD SHIFT REPORT 1 POS TO LEFT.
      *
     FFCALEN    IF   E           K DISK
     F                                     RENAME(RCALEN:CALENI)
     FFCALEX    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCUTLOT   IF   E           K DISK
     F                                     RENAME(RCUTLOT:CUTLOT)
     FFCUTLOTS  IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFCUTNEED  O  A E           K DISK
     FCUR200    O    F   80        PRINTER OFLIND(*INOF)
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
      ****************
      * START HERE   *
      ****************
     C                   MOVE      *BLANKS       CLITEM
     C                   MOVE      *BLANKS       CLLOOK
WJB  C     VendItem      KList
WJB  C                   KFld                    Vendor
WJB  C                   KFld                    CLITEM
WJB  C     VendDate      KList
WJB  C                   KFld                    Vendor
WJB  C                   KFld                    BEGSCY
WJB  C     VendItem      SETLL     FCUTLOT
WJB  C     VendDate      SETLL     FCUTLOTS
      ** READ NEXT RECORD
     C     NXT           TAG
     C     RPTSEQ        IFEQ      'A'
WJB  C     Vendor        READe     FCUTLOTS                               90
     C                   MOVEL     MSG(2)        SEQ              20
     C                   ELSE
WJB  C     Vendor        READe     FCUTLOT                                90
     C                   MOVEL     MSG(3)        SEQ              20
     C                   END
     C   90              GOTO      END
     C     CLSOWD        IFLT      BEGSCY
     C                   GOTO      NXT
     C                   END
      ** IF SOW DATE ENTERED ONLY USE THAT SOW DATE
     C     SOWCYM        IFGT      0
     C     CLSOWD        ANDNE     SOWCYM
     C                   GOTO      NXT
     C                   END
      ** CALCULATE NEED
     C                   Z-add     0             NEED
     C                   If        CLQTOH + CLQTOO < CLQTSL
     C                             and CLQTSL > 0
     C                   Z-ADD     CLQTSL        QTYORD
     C                   SUB       CLQTOH        QTYORD
     C                   SUB       CLQTOO        QTYORD
     C                   Z-ADD     0             QTYNED
      ** ROUND (NEED) TO NXT 100
     C                   CALL      'CUR010'
     C                   PARM                    QTYORD            7 0
     C                   PARM                    QTYNED            7 0
     C                   Z-Add     QTYNED        NEED              7 0
     C                   Else
     C     SHOALL        IFEQ      'N'
     C                   GOTO      NXT
     C                   ENDIF
     C                   ENDIF
      ** SEE IF WE NEED
     C     SHOALL        IFEQ      'N'
     C     NEED          ANDLE     0
     C                   GOTO      NXT
     C                   END
     C     MINKEY        KLIST
     C                   KFLD                    CLITEM
     C                   KFLD                    CLSIZE
     C     MINKEY        CHAIN     FMINVT                             91
     C   91              MOVEL     MSG(1)        IMDES1
      ** IF HERE PRINT
     C     NEED          COMP      0                                  101211
     C   12NEED          IFGT      -100
     C                   SETOFF                                       12
     C                   END
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
      *  Space Between Weeks
     C                   If        SOWMDY <> LastSOWMDY
     C   93              Eval      *In92 = *On
     C                   Eval      *In93 = *On
     C                   Z-Add     SOWMDY        LastSOWMDY        6 0
     C                   Else
     C                   Eval      *In92 = *Off
     C                   EndIf

     C     NEED          DIV       100           TRAYND            5 0
     C                   EXCEPT    DETL
     C                   ADD       CLQTSL        TOTSL             8 0
     C                   ADD       CLQTOH        TOTOH             8 0
     C                   ADD       CLQTOO        TOTOO             8 0
     C   10              ADD       NEED          TOTND             8 0
     C   10              ADD       TRAYND        TOTTR             8 0
      ** DO WE NEED FILE
     C     RPTONL        IFEQ      'N'
     C     NEED          ANDGT     0
     C                   EXSR      PUTFIL
     C                   END
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
      ** BUILD FILE        **
      ***********************
     C     PUTFIL        BEGSR
     C                   CLEAR                   RCUTNEED
     C                   MOVEL     'A'           CNSTAT
     C                   Z-ADD     RPTCYM        CNRYMD
     C                   MOVEL     CLITEM        CNITEM
WJB  C                   MOVEL     CLVEND        CNVEND
     C                   MOVEL     CLSIZE        CNSIZE
     C                   Z-ADD     CLSOWD        CNSOWD
     C                   MOVEL     CLLOOK        CNLOOK
     C                   Z-ADD     CLQTSL        CNQTSL
     C                   Z-ADD     NEED          CNQTND
     C                   WRITE     RCUTNEED
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
WJB  C     *Entry        PList
WJB  C                   Parm                    Vendor
WJB  C     Vendor        Chain     FMVEND
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
     OCUR200    E            HEAD           1 03
     O                                            6 'CUR200'
     O                                           21 'Requested by:'
     O                       USERID              32
     O                                           54 'Cutting Requirement'
     O                                           62 's Report'
     O                       PAGE          Z     80
     O                                           76 'Page:'
     O          E            HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           47 'For Sow Date:'
     O              N55      BEGDAT        Y     56
     O               55      SOWDAT        Y     56
     O              N55                          66 'and Later'
     O               55                          66 'Only.    '
     O                       TIMOD               80 '  :  :  '
     O          E            HEAD           2
     O                                           13 'Report Only:'
     O                       RPTONL              15
     O                                           35 'Show All:'
     O                       SHOALL              37
     O                       SEQ                 65
     O          E            HEAD           1
     O                       Vendor               6
     O                       VMNAME              38
     O                                           71 '----Cutting Quantity----'
     O          E            HEAD           1
     O                                            4 'Item'
     O                                           55 'Cust.'                     53
     O                                           62 'Vend'                      61
     O                                           69 'Vend'                      69
     O                                           76 'Our'                       77
     O                                           80 'No.'                       84
     O          E            HEAD           0
     O                                            8 '/Size'
     O                                           20 'Description'               17
     O                                           48 'Sow Date'                  45
     O                                           55 'Ord.'                      53
     O                                           62 'Conf.'                     61
     O                                           69 'Ord.'                      69
     O                                           76 'Need'                      77
     O                                           80 'TRY'                       84
     O          E            HEAD           1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O          EF   92      DETL           1
     O                                           48 '--------'
     O          EF           DETL           1
     O                       CLITEM              12
     O                                            5 '-'
     O                       CLSIZE               8
     O                       IMDES1              39                             36
     O               10      TRAYND        1     80                             84
     O               10      NEED          1     76                             77
     O              N10 12                       80 '** Over **'
     O                       CLQTOO        M     69                             69
     O                       CLQTOH        M     62                             61
     O                       CLQTSL        M     55                             53
     O                       SOWMDY        Y     48                             45
     O          E            TOTL           1
     O                                           55 '======'                    53
     O                                           62 '======'                    61
     O                                           69 '======'                    69
     O                                           76 '======'                    77
     O                                           80 '====='                     84
     O          E            TOTL           1
     O                                           39 'Report Totals =======>'
     O                       TOTSL         M     55                             53
     O                       TOTOO         M     69                             69
     O                       TOTTR         M     80                             84
     O          E            TOTL           1
     O                       TOTOH         1     62                             61
     O                       TOTND         1     76                             77
** Messages
No Item Number Found                           1
Alphabetic Sequence                            2
Numeric Sequence                               3
