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
      **PROGRAM NAME-------- NCR410P
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT PUT DOWN REPORT FOR UN FILLED ORDERS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/22/02 EFD DO NOT PRINT READY BAY ORDERS.
      *  4/05/02 ADD CHANGE UPDATE TO PRINTED TO NCR401P.
      *
     FNPUTORDI  UF   E           K DISK
     FNPTORDC   UF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFIORDR    IF   E           K DISK
     FFCALENCY  IF   E           K DISK
     FNCR410    O    F  120        PRINTER OFLIND(*INOF)
      *
      *
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
      *   LDA        *
      ****************
     D                UDS
     D  RUNST                  1      1
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  VOUT                 131    131  0
     D  LCANCL               133    133

     D  ItemKey        S                   Like(ITEM)
      ***********************
      ** CALL PARMS        **
      ***********************
     C     *ENTRY        PLIST
     C                   PARM                    STRDAT            7 0
     C                   PARM                    SMASTER           2 0
     C                   PARM                    ITEM             12
     C                   PARM                    SIZE              3
      ***********************
      ** START HERE        **
      ***********************
wjb  C                   If        %Subst(ITEM:12:1) = 'P'
wjb  C                   Eval      *In92   = *On
wjb  C                   Eval      ITEMKey = %Subst(ITEM:1:11) + ' '
wjb  C                   Else
wjb  C                   Eval      ITEMKey = ITEM
wjb  C                   Eval      *In92   = *Off
wjb  C                   EndIf
     C     ITMKEY        KLIST
     C                   KFLD                    ITEMKey
     C                   KFLD                    SIZE
     C     ITMKEY        CHAIN     FMINVT                             91
     C   91              GOTO      END
     C     LOCKEY        KLIST
     C                   KFLD                    STRDAT
     C                   KFLD                    SMASTER
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C     LOCKEY        CHAIN     NPTORDC                            66
     C     LOCKEY        SETLL     NPUTORDI
     C     NXT           TAG
     C     LOCKEY        READE     NPUTORDI                               90
     C   90              GOTO      END
      ** IF READY BAY ORDER DO NOT PRINT
     C     PDRDYB        IFEQ      'Y'
     C                   GOTO      NXT
     C                   END
     C     PTPRTD        IFEQ      'Y'
     C                   SETON                                        55
     C                   ELSE
     C                   SETOFF                                       55
     C                   END
     C     PDORD#        CHAIN     FHORDR                             90
     C     ORDKEY        KLIST
     C                   KFLD                    PDORD#
     C                   KFLD                    PDSEQ#
     C                   MOVEL     OHNAME        NAME             25
     C     ORDKEY        CHAIN     FIORDR                             91
     C     ITMKEY        CHAIN     FMINVT                             91
     C                   Z-ADD     PDQORD        QTYORD            6 0
     C                   ADD       PDQORD        TOTQTY            6 0
     C     PDQORD        SUB       PDQSCH        NEED              6 0
     C                   ADD       NEED          TOTNED            6 0
      ** IF LOT CONTROL BLANK OUT STA
     C     PDLOTC        IFEQ      'Y'
     C                   MOVE      *BLANKS       OHSTA
     C                   END
     C                   MOVE      PDLOC         LOCAT             6
     C   OF              EXCEPT    HEAD
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   MOVEL     'Y'           PDPRTD
     C                   UPDATE    RPUTORD
     C                   GOTO      NXT
      ** END PROG
     C     END           TAG
     C                   MOVEL     'Y'           PTPRTD
     C  N66              UPDATE    RPTORDC
     C     TOTQTY        IFGT      0
     C   OF              EXCEPT    HEAD
     C                   EXCEPT    TOTL
     C                   END
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     STRDAT        CHAIN     FCALENCY                           90
     C                   SETON                                        OF
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************  PRINT CONTROL NUMBER ABOVE CLIP
     ONCR410    E            HEAD           1 03
     O                                           78 'Control Number:'
     O                       PTCNTR        1     84
      ** skip to allow clipboard use
     O          E            HEAD           1 12
     O                                            6 'NCR410'
     O                                           21 'Requested by:'
     O                       USERID              32
     O                                           54 'Location Worksheet for'
     O                                           62 'Master:'
     O                       SMASTER       Z     65
     O                       PAGE          Z     90
     O                                           84 'Page:'
     O          E            HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           32 'Item:'
     O                       IMITEM              45
     O                       IMSIZE              42
     O                       IMDES1              73
     O                                           82 'Time:'
     O                       TIMOD               90 '  :  :  '
     O          E            HEAD           1
     O               92                          24 '* *  P A R T I A L  * *'
     O               55                          55 '****** Re-Print ******'
     O          E            HEAD           1
     O                                           14 '--Order---'
     O                                           43 'Ship Week:'
     O                                           66 '--Quantity--'
     O                       CLDATE        Y     52
     O          E            HEAD           0
     O                                           10 'Req. Date'
     O                                           14 'Lin'
     O                                           21 'Number'
     O                                           28 'Cust #'
     O                                           33 'Name'
     O                                           60 'Ordered'
     O*                                          66 'Need'
     O                                           67 'Short'
     O                                           72 'STA'
     O                                           77 'B/O'
     O                                           83 'Loc.'
     O          E            HEAD           1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O                                           83 '___'
     O          EF           DETL           1
     O                       OIDTRQ        Y     10
     O                       PDSEQ#        4     14
     O                       PDORD#        4     21
     O                       OHCUST        4     28
     O**                       OHNAME    59
     O                       NAME                54
     O                       QTYORD        4     60
     O                       NEED          4     66
     O                       OHSTA               72
     O                       OIPRBO              76
     O                       LOCAT               83
     O*                                 110 '_____________'
     O                                           96 '____________'
     O          EF           TOTL           1
     O                                           60 '======'
     O                                           67 '======'
     O          EF           TOTL           1
     O                                           50 'Total Quantity=========>'
     O                       TOTQTY        1     60
     O                       TOTNED        1     67
     O          E            TOTL           1 61
     O                                           18 'Extra Cart________'
     O                                           37 'Pick-Up___________'
     O                                           56 'Total_____________'
     O                                           75 'Master Qty________'
     O                                           94 'Diff.+/-__________'
