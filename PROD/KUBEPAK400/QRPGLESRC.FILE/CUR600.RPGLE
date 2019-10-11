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
      *PROGRAM NAME--------- CUR600
      *APPLICATION---------- CUTTING REQUIREMENTS
      *DESCRIPTION---------- 105 TRAY UNAVAILABLE REPORT
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/15/01 EFD SHIFT REPORT 1 POS TO LEFT.
      * 11/17/02 EFD CHANGE FROM 84 TO 105 TRAYS.
      *  1/09/03 CAB CHANGES RIGHT HAND MARGIN PRINTING TO FIT ON 8 1/2 X 11
      *
      *
     FFCUT600   IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCUTLOT   IF   E           K DISK
     FCUR600    O    F  120        PRINTER OFLIND(*INOF)
WJB  FFMVEND    IF   E           K DISK
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
     D                UDS
      ** SEQUENCE  A=ALPHA  N=NUMERIC
     D  RPTSEQ                 1      1
      ** BEGIN READY DATE
     D  BEGDAT                 2      7  0
WJB  D  BEGDAT@                2      7
      ** END READY DATE
     D  ENDDAT                 8     13  0
WJB  D  ENDDAT@                8     13
      ** BEGIN READY DATE CYMD
     D  BEGCYM                14     20  0
WJB  D  BEGCYM@               14     20
      ** ENDING READY DATE CYMD
     D  ENDCYM                21     27  0
WJB  D  ENDCYM@               21     27
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
WJB
WJB  D  Vendor         S                   Like(IMVEND)
      *
      ***********************
      ** START HERE        **
      ***********************
WJB  C     Vendor        SetLL     FCUT600
     C     NXT           TAG
WJB  C*                  READ      CUR600QF                               90
WJB  C     Vendor        READe     FCUT600                                90
     C   90              GOTO      END
     C     BEGCYM        IFGT      0
     C     OIRVDT        ANDLT     BEGCYM
     C                   GOTO      NXT
     C                   END
     C     ENDCYM        IFGT      0
     C     OIRVDT        ANDGT     ENDCYM
     C                   GOTO      NXT
     C                   END
     C     OIITEM        IFNE      OITEM
     C     OISOW         ORNE      OSOW
     C     OITEM         IFGT      *BLANKS
     C   60              EXCEPT    TOT
     C                   END
     C     LOTKEY        KLIST
WJB  C                   KFLD                    Vendor
WJB  C                   KFLD                    OIITEM
WJB  C                   KFLD                    OISIZE
     C                   KFLD                    OISOW
     C                   SETOFF                                       61
     C     LOTKEY        CHAIN     FCUTLOT                            60
     C   60              DO
     C                   Z-ADD     0             CLQTOH
     C                   Z-ADD     0             CLQTOO
     C                   Z-ADD     0             CLQTSL
     C                   Z-ADD     0             AVAIL
     C                   Z-ADD     0             SHORT
     C                   SETON                                        61
     C                   ENDDO                                                  60  DO
     C  N60              DO
     C     CLQTOH        ADD       CLQTOO        AVAIL             7 0
     C     CLQTSL        IFGT      AVAIL
     C                   SETON                                        60
     C     CLQTSL        SUB       AVAIL         SHORT             7 0
     C                   END
     C                   ENDDO                                                  N60  DO
     C                   MOVEL     OIITEM        OITEM            12
     C                   Z-ADD     OISOW         OSOW              7 0
     C     MINKEY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C   60              DO
     C     MINKEY        CHAIN     FMINVT                             66
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C                   EXCEPT    ITEM
     C                   ENDDO                                                  60  DO
     C                   Z-ADD     0             TOTORD            7 0
     C                   END
      ** IF 60 ON THERE IS A PROBLEM
     C  N60              GOTO      NXT
     C                   Z-ADD     OIQORD        QTYORD            7 0
     C                   ADD       QTYORD        TOTORD
     C                   Z-ADD     OISOW         ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SOWDAT            6 0
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C                   EXCEPT    ORDER
     C                   GOTO      NXT
      *
     C     END           TAG
     C   60              EXCEPT    TOT
     C                   SETON                                        LR
      **
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
WJB  C     BEGDAT@       IFeq      ' '
WJB  C                   Eval      BEGDAT = *Zero
WJB  C                   EndIf
WJB  C     ENDDAT@       IFeq      ' '
WJB  C                   Eval      ENDDAT = *Zero
WJB  C                   EndIf
WJB  C     BEGCYM@       IFeq      ' '
WJB  C                   Eval      BEGCYM = *Zero
WJB  C                   EndIf
WJB  C     ENDCYM@       IFeq      ' '
WJB  C                   Eval      ENDCYM = *Zero
WJB  C                   EndIf
      ** SET UP REPORT
WJB  C     BEGDAT        IFLE      0
     C                   SETON                                        50
     C                   ELSE
     C                   SETOFF                                       50
     C                   END
     C     RPTSEQ        IFEQ      'A'
     C                   SETON                                        51
     C                   ELSE
     C                   SETOFF                                       51
     C                   END
     C                   SETON                                        OF
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OCUR600    E            HEAD           1 03
     O                                            6 'CUR600'
     O                                           24 'Requested by:'
     O                       USERID              35
WJB01O*                                          60 '105 Tray Un-Available'
WJB01O*                                          67 'Report'
WJB01O                                           65 'Tray Un-Available Report'
CAB  O***                      PAGE  Z   84
CAB  O                       PAGE          Z     82
     O                                           80 'Page:'
     O          E            HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           40 'For Ready Date:'
     O              N50      BEGDAT        Y     49
     O              N50                          59 '- Thru -'
     O              N50      ENDDAT        Y     68
     O               50                          58 '*** All Dates ***'
     O                                           75 'Time:'
CAB  O***                      TIMOD     84 '  :  :  '
CAB  O                       TIMOD               82 '  :  :  '
     O          E            HEAD           2
     O                                           41 'Report Sequence:'
     O               51                          57 'By Alpha Search'
     O              N51                          56 'By Item Number'
     O          E            HEAD           0
     O                                            4 'Item'
     O                                           20 'Description'
     O                                           48 'Confirm'
     O                                           57 'Ordered'
     O                                           66 'Total'
CAB  O                                           74 'CustOrd'
CAB  O                                           83 'Short'
     O          E            HEAD           1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
CAB  O***                                85 '____ '
CAB  O                                           83 '____ '
     O          EF           ITEM           1
     O                       IMITEM              12
     O                       IMDES1              39
     O              N61      CLQTOH        4     48
     O              N61      CLQTOO        4     57
     O              N61      AVAIL         4     66
CAB  O***             N61      CLQTSL4   75
CAB  O              N61      CLQTSL        4     74
CAB  O***             N61      SHORT 4   84
CAB  O              N61      SHORT         4     83
     O               61                          76 '*** No Lot Available ***'
     O          EF           ITEM           0
     O                                            6 'Order#'
     O                                           13 'Cust#'
     O                                           21 'Ship To'
     O                                           53 'Sow Date'
     O                                           62 'Req.Date'
     O                                           71 'Qty. Ord'
     O          EF           ITEM           1
     O                                            6 '______'
     O                                           13 '_____'
     O                                           21 '_______'
     O                                           53 '________'
     O                                           62 '________'
     O                                           71 '________'
     O          EF           ORDER          1
     O                       OIORD#        4      6
     O                       OHCUST        4     13
     O                       OHNAME              44
     O                       SOWDAT        Y     53
     O                       OIDTRQ        Y     62
     O                       QTYORD        4     71
     O          EF           TOT            1
     O                                           71 '________'
     O          EF           TOT         1  1
     O                                           62 'Total ordered =========>'
     O                       TOTORD        4     71
