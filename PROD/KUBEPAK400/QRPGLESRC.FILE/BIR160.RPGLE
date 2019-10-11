      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
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
      *PROGRAM NAME-------- BIR160
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- PROD CLASS/CUSTOMER TYPE PRICE MASTER LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMPCLS    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMCTYP    IF   E           K DISK
     FBIR160    O    F  120        PRINTER OFLIND(*INOF)
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
      *
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
     C                   READ      FMPCLS                                 90
     C   90              GOTO      END
      *
     C     PCSTAT        IFEQ      'D'                                                      ?
     C                   GOTO      NXT
     C                   ENDIF
      *
      * GET PRODUCT CLASS DESCRIPTION
      *
     C     PCPCL2        CHAIN     FMPRCL                             88
      *
      * GET CUSTOMER TYPE DESCRIPTION
      *
     C                   MOVE      PCCTYP        CTKEY             4
     C     PCCTYP        CHAIN     FMCTYP                             88
      *
     C     PCPQN3        IFGT      0
     C                   SETON                                        23
     C                   ENDIF
     C     PCPQN4        IFGT      0
     C                   SETON                                        24
     C                   ENDIF
     C     PCPQN5        IFGT      0
     C                   SETON                                        25
     C                   ENDIF
     C     PCPQN6        IFGT      0
     C                   SETON                                        26
     C                   ENDIF
     C     PCPQN7        IFGT      0
     C                   SETON                                        27
     C                   ENDIF
     C     PCPQN8        IFGT      0
     C                   SETON                                        28
     C                   ENDIF
     C     PCPQN9        IFGT      0
     C                   SETON                                        29
     C                   ENDIF
     C     PCPQN0        IFGT      0
     C                   SETON                                        30
     C                   ENDIF
     C                   EXCEPT    P1
     C   23              EXCEPT    P3
     C   24              EXCEPT    P4
     C   25              EXCEPT    P5
     C   26              EXCEPT    P6
     C   27              EXCEPT    P7
     C   28              EXCEPT    P8
     C   29              EXCEPT    P9
     C   30              EXCEPT    P10
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OBIR160    E            HDG            1 03
     O                       PROGID              10
     O                                           25 'Requested by:'
     O                       USERID              36
     O                       RGNAMC              75
     O                                          114 'Page:'
     O                       PAGE          1    120
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           62 'Product Class/Customer '
     O                                           80 'Type Price Listing'
     O                       TIMOD              120 '  :  :  '
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
     O          E            P1          1  1
     O                                           17 'Product Class 2..'
     O                       PCPCL2              20
     O                       PCDESC         B    51
     O                                           61 'Level 1.'
     O                       PCPQN1        4     75
     O                       PCPCT1        4     85
     O                       PCPC$1        M    100
     O          E            P1             1
     O                                           17 'Customer Type....'
     O                       PCCTYP              20
     O                       CTDESC         B    51
     O                                           61 'Level 2.'
     O                       PCPQN2        4     75
     O                       PCPCT2        4     85
     O                       PCPC$2        M    100
     O          E            P3             1
     O                                           61 'Level 3.'
     O                       PCPQN3        4     75
     O                       PCPCT3        4     85
     O                       PCPC$3        M    100
     O          E            P4             1
     O                                           61 'Level 4.'
     O                       PCPQN4        4     75
     O                       PCPCT4        4     85
     O                       PCPC$4        M    100
     O          E            P5             1
     O                                           61 'Level 5.'
     O                       PCPQN5        4     75
     O                       PCPCT5        4     85
     O                       PCPC$5        M    100
     O          E            P6             1
     O                                           61 'Level 6.'
     O                       PCPQN6        4     75
     O                       PCPCT6        4     85
     O                       PCPC$6        M    100
     O          E            P7             1
     O                                           61 'Level 7.'
     O                       PCPQN7        4     75
     O                       PCPCT7        4     85
     O                       PCPC$7        M    100
     O          E            P8             1
     O                                           61 'Level 8.'
     O                       PCPQN8        4     75
     O                       PCPCT8        4     85
     O                       PCPC$8        M    100
     O          E            P9             1
     O                                           61 'Level 9.'
     O                       PCPQN9        4     75
     O                       PCPCT9        4     85
     O                       PCPC$9        M    100
     O          E            P10            1
     O                                           62 'Level 10.'
     O                       PCPQN0        4     75
     O                       PCPCT0        4     85
     O                       PCPC$0        M    100
