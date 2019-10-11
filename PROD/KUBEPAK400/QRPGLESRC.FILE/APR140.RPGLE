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
      *PROGRAM NAME         APR140
      *SYSTEM-              ACCOUNTS PAYABLE
      *APPLICATION-         VENDOR NAME AND ADDRESS DIRECTORY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMVENDAL  IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFVENDCM   IF   E           K DISK
     FAPR140    O    F  120        PRINTER OFLIND(*INOF)
      *
     D #VE             S             32    DIM(6)
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
     IRMVEND
     I              VMNAME                      #WVEN1
     I              VMADD2                      #WVEN2
     I              VMADD3                      #WVEN3
     I              VMADD4                      #WVEN4
     I              VMCITY                      #WVENC
     I              VMSTST                      #WVENS
     I              VMZIPD                      #WVENZ
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FMCORG                             88
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FMVENDAL                               90
     C   90              GOTO      END
      *
     C     VMCONM        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VMVEND        CHAIN     FVENDCM                            77
     C                   MOVEL     VMEML         EMAIL            33
     C                   MOVEL     VMURL         URL              50
      *
     C   77              MOVEL     *BLANKS       EMAIL
     C   77              MOVEL     *BLANKS       URL
      *
     C                   EXSR      #VEN
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
      * #VEN    *
      ***********
      *
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE VENDOR
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
     C     #VEN          BEGSR
      *
     C                   MOVE      *BLANKS       #VE
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WVEN1        #VE(#X)
     C                   ADD       1             #X
     C     #WVEN2        COMP      *BLANKS                            929291
     C   91              GOTO      #VED1
     C                   MOVEL     #WVEN2        #VE(#X)
     C                   ADD       1             #X
     C     #VED1         TAG
     C     #WVEN3        COMP      *BLANKS                            929291
     C   91              GOTO      #VED2
     C                   MOVEL     #WVEN3        #VE(#X)
     C                   ADD       1             #X
     C     #VED2         TAG
     C     #WVEN4        COMP      *BLANKS                            929291
     C   91              GOTO      #VED3
     C                   MOVEL     #WVEN4        #VE(#X)
     C                   ADD       1             #X
     C     #VED3         TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WVENC        CAT       #WVENS:1      WORK1
     C                   MOVEL     #WVENZ        WORK3
     C                   MOVE      #WVENZ        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #VE(#X)
     C                   ADD       1             #X
     C                   MOVEL     VMCOUN        #VE(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *
     OAPR140    E            HDG            1 03
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
     O                                           59 'Vendor Name and'
     O                                           77 'Address Directory'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       #VE(1)              32
     O                                           45 'Telephone:'
     O                       VMPHON              58 '   -   -    '
     O                                           76 'Vend #:'
     O                       VMVEND        Z     83
     O          E            DETL           1
     O                       #VE(2)              32
     O                                           45 'Fax:'
     O                       VMFAX               58 '   -   -    '
     O                                           76 'Email:'
     O                       EMAIL              110
     O          E            DETL           1
     O                       #VE(3)              32
     O                                           45 'Contact:'
     O                       VMVCON              76
     O          E            DETL           1
     O                       #VE(4)              32
     O                                           45 'URL:'
     O                       URL                 96
     O          E            DETL           1
     O                       #VE(5)              32
     O          E            DETL           2
     O                       #VE(6)              32
