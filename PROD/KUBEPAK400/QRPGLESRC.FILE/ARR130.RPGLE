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
      *PROGRAM NAME-------- ARR130
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- SALESPERSON MASTER FILE LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMSLSM    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMTERR    IF   E           K DISK
     FARR130    O    F  132        PRINTER OFLIND(*INOF)
      *
     D #SL             S             32    DIM(6)
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
     IRMSLSM
     I              SMNAME                      #WSLS1
     I              SMADD2                      #WSLS2
     I              SMADD3                      #WSLS3
     I              SMADD4                      #WSLS4
     I              SMCITY                      #WSLSC
     I              SMSTST                      #WSLSS
     I              SMZIP                       #WSLSZ
      *
     C   OF              SETON                                        OF
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     00            KEY               2 0
     C     KEY           CHAIN     FMCORG                             90
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       90
     C                   READ      FMSLSM                                 90
     C   90              GOTO      END
      *
      * CHECK FOR DELETED RECORD
      *
     C     SMSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
      * GET TERRITORY NAME
      *
     C     SMTERR        CHAIN     FMTERR                             51
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXSR      GETSLS
     C                   EXCEPT    DETL
     C                   ADD       1             CNT               2 0
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      ***********
      * #SLS    *
      ***********
      *
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE
      *  SALESPERSON ADDRESS.  WORK FIELDS ARE DEFINED AS:
      *
      *                 WORK  = CITY,STATE,ZIP(9 DIGIT)
      *                 WORK1 = CITY, STATE
      *                 WORK2 = ZIP CODE(XXXXX-XXXX)
      *                 WORK3 = STANDARD ZIP CODE(XXXXX)
      *                 WORK4 = ADDITIONAL ZIP CODE(-XXXX)
      *
      *  THE SUBROUTINE REQUIRES MOVING NAME AND ADDRESS INFORMATION TO
      *  BE CONDENSED TO A DATA STRUCTURE
      *
     C     GETSLS        BEGSR
      *
     C                   MOVE      *BLANKS       #SL
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WSLS1        #SL(#X)
     C                   ADD       1             #X
     C     #WSLS2        COMP      *BLANKS                            929291
     C   91              GOTO      #VED1
     C                   MOVEL     #WSLS2        #SL(#X)
     C                   ADD       1             #X
     C     #VED1         TAG
     C     #WSLS3        COMP      *BLANKS                            929291
     C   91              GOTO      #VED2
     C                   MOVEL     #WSLS3        #SL(#X)
     C                   ADD       1             #X
     C     #VED2         TAG
     C     #WSLS4        COMP      *BLANKS                            929291
     C   91              GOTO      #VED3
     C                   MOVEL     #WSLS4        #SL(#X)
     C                   ADD       1             #X
     C     #VED3         TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WSLSC        CAT       #WSLSS:1      WORK1
     C                   MOVEL     #WSLSZ        WORK3
     C                   MOVE      #WSLSZ        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SL(#X)
     C                   ADD       1             #X
     C                   SETOFF                                       919293
     C                   ENDSR
      *
     OARR130    E            HDG            1 03
     O                       PROGID              10
     O                       RGNAMC              55
     O                       PAGE          1     80
     O                                           77 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           38 'Salesperson'
     O                                           53 'Master Listing'
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            1
     O                                           13 'Requested by:'
     O                       USERID              24
     O          E            HDG            1
     O                                           52 'Telephone/'
     O          E            HDG            1
     O                                           50 '  Fax  '
     O          E            HDG            1
     O                                            6 'Code'
     O                                           21 'Name/Address'
     O                                           51 'Territory'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           82 '__________'
     O          EF           DETL        1  1
     O                       SMSLSM               5
     O                       #SL(1)              39
     O                       SMPHON              52 '   -   -    '
     O                                           74 'Commission %  ='
     O                       SMCOMM        4     80
     O          E            DETL           1
     O                       #SL(2)              39
     O                       SMFAX               52 '   -   -    '
     O                                           74 'Outside Agent ='
     O                       SMAGNT              78
     O          E            DETL           1
     O                       #SL(3)              39
     O                       SMTERR              42
     O                                           44 '-'
     O              N51      TEDESC              75
     O               51                          70 '*Territory Not on File*'
     O          E            DETL           1
     O                       #SL(4)              39
     O                                           46 'EMail:'
     O                       SMEML               80
     O          E            DETL           1
     O                       #SL(5)              39
