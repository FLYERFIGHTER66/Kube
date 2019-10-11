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
      *PROGRAM NAME         ARR140
      *SYSTEM-              MASTER FILES
      *APPLICATION-         CUSTOMER NAME AND ADDRESS DIRECTORY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCUSTAL  IF   E           K DISK
     FFARHST    IF   E           K DISK
     FFCUSTCOM  IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FARR140    O    F  120        PRINTER OFLIND(*INOF)
      *
     D #CU             S             32    DIM(6)
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
      *
     IRMCUST
     I              CMNAME                      #WCUS1
     I              CMADD2                      #WCUS2
     I              CMADD3                      #WCUS3
     I              CMADD4                      #WCUS4
     I              CMCITY                      #WCUSC
     I              CMSTST                      #WCUSS
     I              CMZIP                       #WCUSZ
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FMCORG                             88
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FMCUSTAL                               90
     C   90              GOTO      END
      *
     C     CMCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     CMCUST        CHAIN     FARHST                             77
     C   77              Z-ADD     0             HSFAX
      *
     C                   Z-ADD     01            CCSEQ             2 0
     C                   Z-ADD     CMCUST        CCUST             6 0
     C     KEY8          KLIST
     C                   KFLD                    CCUST
     C                   KFLD                    CCSEQ
     C     KEY8          CHAIN     FCUSTCOM                           78
     C   78              MOVEL     *BLANKS       CCEML
     C   78              MOVEL     *BLANKS       CCURL
      *
     C                   EXSR      #CUS
      *
     C                   SETOFF                                       313233
     C     X             IFEQ      9
     C                   EXCEPT    HDG
     C                   Z-ADD     0             X
     C                   ENDIF
      *
     C                   EXCEPT    DETL
     C                   ADD       1             X                 2 0
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      ***********
      * #CUS    *
      ***********
      *
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE CUSTOMER
      *  ADDRESS.  WORK FIELDS ARE DEFINED AS:
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
     C     #CUS          BEGSR
      *
     C                   MOVE      *BLANKS       #CU
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WCUS1        #CU(#X)
     C                   ADD       1             #X
     C     #WCUS2        COMP      *BLANKS                            929291
     C   91              GOTO      #CUD1
     C                   MOVEL     #WCUS2        #CU(#X)
     C                   ADD       1             #X
     C     #CUD1         TAG
     C     #WCUS3        COMP      *BLANKS                            929291
     C   91              GOTO      #CUD2
     C                   MOVEL     #WCUS3        #CU(#X)
     C                   ADD       1             #X
     C     #CUD2         TAG
     C     #WCUS4        COMP      *BLANKS                            929291
     C   91              GOTO      #CUD3
     C                   MOVEL     #WCUS4        #CU(#X)
     C                   ADD       1             #X
     C     #CUD3         TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WCUSC        CAT       #WCUSS:1      WORK1
     C                   MOVEL     #WCUSZ        WORK3
     C                   MOVE      #WCUSZ        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #CU(#X)
     C                   ADD       1             #X
     C                   MOVEL     CMCOUN        #CU(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *
     OARR140    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          1    120
     O                                          116 'Page'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           59 'Customer Name and'
     O                                           77 'Address Directory'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       #CU(1)              32
     O                                           45 'Telephone:'
     O                       CMPHON              58 '   -   -    '
     O                       CMPHO2              72 '   -   -    '
     O                                           86 'Cust #:'
     O                       CMCUST        Z     93
     O          E            DETL           1
     O                       #CU(2)              32
     O                                           45 'Fax:'
     O                       HSFAX               58 '   -   -    '
     O                                           86 'Email:'
     O                       CCEML              120
     O          E            DETL           1
     O                       #CU(3)              32
     O                                           45 'Contact:'
     O                       CMCNME              76
     O                                           86 'A/R Name:'
     O                       CMCNAM             117
     O          E            DETL           1
     O                       #CU(4)              32
     O                                           45 'URL:'
     O                       CCURL               96
     O          E            DETL           1
     O                       #CU(5)              32
     O          E            DETL           2
     O                       #CU(6)              32
