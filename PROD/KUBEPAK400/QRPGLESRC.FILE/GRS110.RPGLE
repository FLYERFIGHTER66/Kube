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
      *PROGRAM NAME-------- GRS110
      *SYSTEM-------------- PRODUCTION MASTER FILES
      *APPLICATION--------- PHYTO CODES MASTER LISTING
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFPHYTO    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FGRS110    O    F   80        PRINTER OFLIND(*INOF)
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
     C                   MOVEL     '00'          MCCOMP
     C     CKEY          KLIST
     C                   KFLD                    MCCOMP
     C     CKEY          CHAIN(N)  FMCOMP                             90
     C     MCPRCO        CHAIN     FMCORG                             90
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       90
     C                   READ      FPHYTO                                 90
     C   90              GOTO      END
      *
      * CHECK FOR DELETED RECORD
      *
     C     PHSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OGRS110    E            HDG            1 03
     O                       PROGID              10
     O                       RGNAMC              55
     O                       PAGE          1     80
     O                                           77 'Page'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           50 'Phyto Codes Listing'
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            2
     O                                           13 'Requested by:'
     O                       USERID              24
     O          E            HDG            1
     O                                           11 'Code'
     O                                           27 'Description'
     O                                           57 'Short Desc'
     O                                           65 'Cert'
     O                                           74 'Charge'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           80 '________'
     O          EF           DETL           1
     O                       PHCODE              10
     O                       PHYDES              46
     O                       PHDESS              57
     O                       PHCERT              64
     O                       PHCHRG        1     73
