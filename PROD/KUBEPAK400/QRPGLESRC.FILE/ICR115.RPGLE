      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      *PROGRAM NAME-------- ICR115
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- ITEM LONG DESCRIPTION MASTER FILE LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFIADD     IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FICR115    O    F   80        PRINTER OFLIND(*INOF)
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   MOVEL     '00'          CKEY              2 0
     C     CKEY          CHAIN(N)  FMCOMP                             90
     C     MCPRCO        CHAIN     FMCORG                             90
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       9040
     C                   READ      FIADD                                  90
     C   90              GOTO      END
      *
     C     KEY12         KLIST
     C                   KFLD                    IAITEM
     C     KEY12         CHAIN     FMINVT                             50
     C                   MOVE      IMDES1        DESA             30
     C                   MOVE      IMDES2        DESB             30
     C     DESA          CAT       DESB:1        DES1             40
     C                   MOVE      IMDES3        DESC             30
     C                   MOVE      IMDES4        DESD             30
     C     DESC          CAT       DESD:1        DES2             30
     C     DES1          CAT       DES2:1        DESP             60
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
      *
     C                   EXCEPT    DETL
     C     IADES2        IFGT      *BLANKS
     C                   EXCEPT    DETL2
     C                   ENDIF
     C     IADES3        IFGT      *BLANKS
     C                   EXCEPT    DETL3
     C                   ENDIF
     C     IADES4        IFGT      *BLANKS
     C                   EXCEPT    DETL4
     C                   ENDIF
     C     IADES5        IFGT      *BLANKS
     C                   EXCEPT    DETL5
     C                   ENDIF
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OICR115    E            HDG            1 03
     O                       PROGID              10
     O                       RGNAMC              55
     O                       PAGE          1     80
     O                                           77 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           50 'Item Long Description Li'
     O                                           52 'st'
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            2
     O                                           13 'Requested by:'
     O                       USERID              24
     O          E            HDG            0
     O                                            4 'Item'
     O                                           30 'Description'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           80 '________'
     O          E            DETL           1
     O                       IAITEM              12
     O                       DESP                79
     O          E            DETL           1
     O                       IADES1              69
     O          E            DETL2          1
     O                       IADES2              69
     O          E            DETL3          1
     O                       IADES3              69
     O          E            DETL4          1
     O                       IADES4              69
     O          E            DETL5          1
     O                       IADES5              69
