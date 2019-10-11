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
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR180
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- CUSTOMER TYPE PRICING LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMCCLT    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMCTYP    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FBIR180    O    F  120        PRINTER OFLIND(*INOF)
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
     C                   Z-ADD     00            KEY               2 0
     C     KEY           CHAIN     FMCORG                             88
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FMCCLT                                 90
     C   90              GOTO      END
      *
     C     CLSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
      * GET CUSTOMER NAME
      *
     C     CLCUST        CHAIN     FMCUST                             20
      *
      * GET PRODUCT CLASS DESCRIPTION
      *
     C     CLPC2         CHAIN     FMPRCL                             85
      *
      * GET CUSTOMER TYPE DESCRIPTION
      *
     C     CLCTYP        CHAIN     FMCTYP                             88
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OBIR180    E            HDG            1 03
     O                       PROGID              10
     O                                           25 'Requested by:'
     O                       USERID              36
     O                       RGNAMC              75
     O                       PAGE          1    120
     O                                          117 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     20
     O                                           64 'Customer Type Pricing'
     O                                           72 'Listing'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           13 'Customer'
     O                                           60 'Product Class Two'
     O                                           92 'Customer Type'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL           1
     O                       CLCUST        Z      6
     O                       CMNAME              37
     O                       CLPC2               41
     O                       PCDESC              73
     O                       CLCTYP              77
     O                       CTDESC             109
