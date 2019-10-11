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
      *PROGRAM NAME-------- BIR122
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- PRODUCT CLASS MASTER LISTING
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMPRCL    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFSYSCTL   IF   E           K DISK
     FBIR122    O    F   80        PRINTER OFLIND(*INOF)
      *
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
      *
     D                UDS
     D  LCO                    1      2  0
     D  LLIST                  3      3
     D  LCANCL               133    133
      *
     C                   READ      FSYSCTL                                90
     C     ZZTYPE        IFEQ      'G'
     C                   SETON                                        77
     C                   ENDIF
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN(N)  FMCORG                             90
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       901011
     C                   READ      FMPRCL                                 90
     C   90              GOTO      END
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OBIR122    E            HDG            1 03
     O                       PROGID              10
     O                       RGNAMC              55
     O                       PAGE          1     80
     O                                           77 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           50 'Product Class Master Li'
     O                                           53 'st '
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            1
     O                                           13 'Requested by:'
     O                       USERID              24
     O          E            HDG            1
     O                                            3 'Pr'
     O                                           38 'Vol'
     O                                           42 'Sum'
     O                                           67 '* Order of Desc Print *'
     O               77                          80 '-Available-'
     O          E            HDG            1
     O                                            3 'Cl'
     O                                           15 'Description'
     O                                           38 'Dsc'
     O                                           42 'Inv'
     O                                           66 '  Inv    Pickslip  Repor'
     O                                           68 'ts'
     O               77                          80 ' From   To '
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           80 '________'
     O          EF           DETL           1
     O                       PCPRCL               2
     O                       PCDESC              33
     O                       PCEVD               37
     O                       PCSUMF              41
     O                       PCPRI1              45
     O                       PCPRI2              46
     O                       PCPRI3              47
     O                       PCPRI4              48
     O                       PCPRP1              54
     O                       PCPRP2              55
     O                       PCPRP3              56
     O                       PCPRP4              57
     O                       PCPRR1              63
     O                       PCPRR2              64
     O                       PCPRR3              65
     O                       PCPRR4              66
     O               77      PCSDTF              73 '  /  '
     O               77      PCSDTT              80 '  /  '
