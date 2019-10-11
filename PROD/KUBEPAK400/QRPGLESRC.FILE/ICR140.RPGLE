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
      *PROGRAM NAME-------- ICR140
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- SIZE CODES MASTER LISTING
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMSIZE    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFSYSCTL   IF   E           K DISK
     FICR140    O    F   80        PRINTER OFLIND(*INOF)
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
      *
     C                   READ      FSYSCTL                                90
     C     ZZTYPE        IFEQ      'G'
     C                   SETON                                        01
     C                   ELSE
     C                   SETON                                        02
     C                   ENDIF
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   MOVEL     '00'          MCCOMP
     C     CKEY          KLIST
     C                   KFLD                    MCCOMP
     C     CKEY          CHAIN(N)  FMCOMP                             90
     C     MCPRCO        CHAIN     FMCORG                             90
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       90
     C                   READ      FMSIZE                                 90
     C   90              GOTO      END
      *
      *    CHECK FOR DELETED RECORD
      *
     C     SZSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *                                                                   GLR110
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OICR140    E            HDG            1 03
     O                       PROGID              10
     O                                           20 'Reqd By:'
     O                       USERID              31
     O                       RGNAMC              55
     O                       PAGE          1     80
     O                                           77 'Page'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           50 'Size Codes Listing'
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            1
     O                                           33 'Square'
     O                                           45 '# Items'
     O               01                          57 '# Cells'
     O               01                          69 'Saleable'
     O          E            HDG            1
     O                                            4 'Code'
     O                                           20 'Description'
     O                                           32 'Feet'
     O                                           46 'Per Carton'
     O               01                          57 'Per Flat'
     O               01                          69 'Cells/Flat'
     O               01                          80 '# of Tags'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           80 '________'
     O          EF           DETL           2
     O                       SZCODE               4
     O                       SZDESC              19
     O                       SZCUBF        1     32
     O                       SZPERC        Z     45
     O               01      SZCELL        Z     55
     O               01      SZSALE        Z     67
     O               01      SZTAGS        Z     77
