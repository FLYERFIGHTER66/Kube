      *--------------------------------------------------------------
      *
      *  EFD ENTERPRISES INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES   ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- BIR165
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **APPLICATION--------- P.C. DISCOUNT LIST
      **DESCRIPTION--------- LIST ALL P.C. 3 DISCOUNTS INCLUDING
      **                       OVER-RIDE BY DATE.
      **
      *
     FFQDISC    IF   E           K DISK
     FFQDISCO   IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FBIR165    O    F  120        PRINTER OFLIND(*INOF)
      *
      ** DISCOUNT TYPE DESCRIPTION ARRAY
     D MSG             S             35    DIM(5) CTDATA PERRCD(1)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
     C   OF              SETON                                        OF
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   MOVEL     '00'          COMP              2 0
     C     COMP          CHAIN(N)  FMCORG                             90
     C                   SETON                                        8990
     C                   EXCEPT    HDG
      *
     C   OF              EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FQDISC                                 90
     C   90              GOTO      END
      *
     C     QCSTAT        IFEQ      'D'                                                      ?
     C                   GOTO      NXT
     C                   ENDIF
      ** GET DEPARTMENT
     C     QCLOC         CHAIN     FMDEPT                             91
     C   91              MOVEL     MSG(3)        DEDESC
      *
     C                   SETOFF                                       232425
     C                   SETOFF                                       262728
     C                   SETOFF                                       2930
     C     QCPQN3        IFGT      0
     C                   SETON                                        23
     C                   ENDIF
     C     QCPQN4        IFGT      0
     C                   SETON                                        24
     C                   ENDIF
     C     QCPQN5        IFGT      0
     C                   SETON                                        25
     C                   ENDIF
     C     QCPQN6        IFGT      0
     C                   SETON                                        26
     C                   ENDIF
     C     QCPQN7        IFGT      0
     C                   SETON                                        27
     C                   ENDIF
     C     QCPQN8        IFGT      0
     C                   SETON                                        28
     C                   ENDIF
     C     QCPQN9        IFGT      0
     C                   SETON                                        29
     C                   ENDIF
     C     QCPQN0        IFGT      0
     C                   SETON                                        30
     C                   ENDIF
     C                   Z-ADD     QCDTYP        X                 1 0
     C   OF              EXCEPT    HDG
     C                   EXCEPT    P1
     C   OF              EXCEPT    HDG
     C   23              EXCEPT    P3
     C   OF              EXCEPT    HDG
     C   24              EXCEPT    P4
     C   OF              EXCEPT    HDG
     C   25              EXCEPT    P5
     C   OF              EXCEPT    HDG
     C   26              EXCEPT    P6
     C   OF              EXCEPT    HDG
     C   27              EXCEPT    P7
     C   OF              EXCEPT    HDG
     C   28              EXCEPT    P8
     C   OF              EXCEPT    HDG
     C   29              EXCEPT    P9
     C   OF              EXCEPT    HDG
     C   30              EXCEPT    P10
     C   OF              EXCEPT    HDG
     C                   EXCEPT    P11
      * see if any date over-ride
     C                   EXSR      DATOV
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      ******************
      * DATE OVER-RIDE *
      ******************
     C     DATOV         BEGSR
     C     QDKEY         KLIST
     C                   KFLD                    QCLOC
     C                   KFLD                    QCPCL3
     C     QDKEY         CHAIN     FQDISCO                            90
     C   90              GOTO      ENDOV
     C     QCDTCD        IFEQ      'R'
     C                   Z-ADD     5             Y                 2 0
     C                   ELSE
     C                   Z-ADD     4             Y                 2 0
     C                   END
      ** GET DATES INTO MDY
     C                   Z-ADD     QCDTBG        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         FRMDAT            6 0
     C                   Z-ADD     QCDTEN        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TODAT             6 0
      *
     C                   SETOFF                                       232425
     C                   SETOFF                                       262728
     C                   SETOFF                                       2930
     C     QCPQN3        IFGT      0
     C                   SETON                                        23
     C                   ENDIF
     C     QCPQN4        IFGT      0
     C                   SETON                                        24
     C                   ENDIF
     C     QCPQN5        IFGT      0
     C                   SETON                                        25
     C                   ENDIF
     C     QCPQN6        IFGT      0
     C                   SETON                                        26
     C                   ENDIF
     C     QCPQN7        IFGT      0
     C                   SETON                                        27
     C                   ENDIF
     C     QCPQN8        IFGT      0
     C                   SETON                                        28
     C                   ENDIF
     C     QCPQN9        IFGT      0
     C                   SETON                                        29
     C                   ENDIF
     C     QCPQN0        IFGT      0
     C                   SETON                                        30
     C                   ENDIF
     C                   Z-ADD     QCDTYP        X                 1 0
     C   OF              EXCEPT    HDG
     C                   EXCEPT    P0
     C   OF              EXCEPT    HDG
     C                   EXCEPT    P1
     C   OF              EXCEPT    HDG
     C   23              EXCEPT    P3
     C   OF              EXCEPT    HDG
     C   24              EXCEPT    P4
     C   OF              EXCEPT    HDG
     C   25              EXCEPT    P5
     C   OF              EXCEPT    HDG
     C   26              EXCEPT    P6
     C   OF              EXCEPT    HDG
     C   27              EXCEPT    P7
     C   OF              EXCEPT    HDG
     C   28              EXCEPT    P8
     C   OF              EXCEPT    HDG
     C   29              EXCEPT    P9
     C   OF              EXCEPT    HDG
     C   30              EXCEPT    P10
     C   OF              EXCEPT    HDG
     C                   EXCEPT    P11
     C     ENDOV         ENDSR
     OBIR165    E            HDG            1 03
     O                       PROGID              10
     O                       RGNAMC              75
     O                                          114 'Page:'
     O                       PAGE          1    120
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           62 'Product Class 3 Discount'
     O                                           76 '/Price Listing'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           13 'Requested by:'
     O                       USERID              24
     O          E            HDG            1
     O                                           74 'Quantity'
     O                                           85 'Percent'
     O                                          100 'Amount'
     O          E            HDG            0
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           P0          1  1
     O                                           20 'Date Over-Ride From:'
     O                       FRMDAT        Y     29
     O                                           36 '- To -'
     O                       TODAT         Y     45
     O                                           55 'Based On:'
     O                       MSG(Y)              71
     O          EF           P1          1  1
     O                                           17 'Product Class 3..'
     O                       QCPCL3              20
     O                       QCDESC         B    51
     O                                           61 'Level 1.'
     O                       QCPQN1        4     75
     O                       QCPCT1        4     85
     O                       QCPC$1        M    100
     O          EF           P1             1
     O                                           17 'Department.......'
     O                       QCLOC               20
     O                       DEDESC         B    51
     O                                           61 'Level 2.'
     O                       QCPQN2        4     75
     O                       QCPCT2        4     85
     O                       QCPC$2        M    100
     O          EF           P3             1
     O                                           61 'Level 3.'
     O                       QCPQN3        4     75
     O                       QCPCT3        4     85
     O                       QCPC$3        M    100
     O          EF           P4             1
     O                                           61 'Level 4.'
     O                       QCPQN4        4     75
     O                       QCPCT4        4     85
     O                       QCPC$4        M    100
     O          EF           P5             1
     O                                           61 'Level 5.'
     O                       QCPQN5        4     75
     O                       QCPCT5        4     85
     O                       QCPC$5        M    100
     O          EF           P6             1
     O                                           61 'Level 6.'
     O                       QCPQN6        4     75
     O                       QCPCT6        4     85
     O                       QCPC$6        M    100
     O          EF           P7             1
     O                                           61 'Level 7.'
     O                       QCPQN7        4     75
     O                       QCPCT7        4     85
     O                       QCPC$7        M    100
     O          EF           P8             1
     O                                           61 'Level 8.'
     O                       QCPQN8        4     75
     O                       QCPCT8        4     85
     O                       QCPC$8        M    100
     O          EF           P9             1
     O                                           61 'Level 9.'
     O                       QCPQN9        4     75
     O                       QCPCT9        4     85
     O                       QCPC$9        M    100
     O          EF           P10            1
     O                                           62 'Level 10.'
     O                       QCPQN0        4     75
     O                       QCPCT0        4     85
     O                       QCPC$0        M    100
     O          EF           P11            1
     O                       MSG(X)              40
     O                                           65 'Standing Order Price:'
     O                       QCSTDO        2     74
** DESCRIPTION
Discount Applies To Entire order                   1
Discount is on Each line Only                      2
All Departments                                    3
Order Date                                         4
Requested Ship Date                                5
