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
      *PROGRAM NAME-------- APR110
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- VENDOR MASTER LISTING BY VENDOR ALPHA
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMVENDAL  IF   E           K DISK
     FFVENDCM   IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FAPR110    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LSEQ                   3      3  0
     D  LBVEND                 4      9  0
     D  LEVEND                10     15  0
     D  LBALPH                16     30
     D  LEALPH                31     45
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
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
     C                   Z-ADD     0             CNT
      *
      * RANGE OF VENDOR ALPHA
      *
     C     LBALPH        IFGT      *BLANKS
     C                   SETON                                        61
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCORG                             88
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                           88
     C                   READ      FMVENDAL                               90
     C   90              GOTO      END
      *
     C   61VMLOOK        IFLT      LBALPH
     C     VMLOOK        ORGT      LEALPH
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VMTXID        IFGT      *BLANKS
     C     VMTXCD        COMP      'F'                                    40
     C     VMTXCD        COMP      'S'                                    42
     C                   END
      *
     C                   MOVEL     VMTXID        TXID              9 0
      *
      * CHAIN TO CONTROL FILE - TERMS - TO GET TERMS INFORMATION
      *
     C                   MOVEL     VMTMCD        KEYT              2
     C     KEYT          CHAIN     FMTERM                             98
      *
     C                   EXSR      #VEN
      *
     C     VMWIRE        IFNE      'Y'
     C                   MOVEL     'N'           VMWIRE
     C                   ENDIF
      *
     C     VMMSG         IFGT      *BLANKS
     C                   SETON                                        88
     C                   ENDIF
      *
     C     CNT           IFGT      7
     C                   EXCEPT    HDG
     C                   Z-ADD     0             CNT
     C                   ENDIF
      *
     C                   EXCEPT    DETL
     C                   SETON                                        78
     C                   ADD       1             CNT               2 0
      *
     C     VMVEND        CHAIN     FVENDCM                            92
     C   92              GOTO      NOCOM
     C                   EXCEPT    DETLA
     C     NOCOM         TAG
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C  N78              EXCEPT    TLR
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
     OAPR110    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           70 'Vendor Master Listing'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O               61                          49 'Vendor Alpha: '
     O               61      LBALPH              65
     O               61                          67 '-'
     O               61      LEALPH              83
     O          E            HDG            1
     O                                            7 '#/Alpha'
     O                                           14 'Type'
     O                                           30 'Name / Address'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL        1  1
     O                       VMVEND        Z      6
     O                       VMTYPE              12
     O                       #VE(1)              46
     O                                           52 'Tel #:'
     O                       VMPHON              71 '   -   -    '
     O                                           81 'Terms:'
     O                       VMTMCD              84
     O                       TCDESC             116
     O          E            DETL           1
     O                       VMLOOK              15
     O                       #VE(2)              46
     O                                           52 'Fax #:'
     O                       VMFAX               71 '   -   -    '
     O                                           83 'Contact:'
     O                       VMVCON             116
     O          E            DETL           1
     O                       #VE(3)              46
     O                                           55 'G/L Acct:'
     O                       VMGLAC              71 '    -    '
     O                                           82 'Tax ID:'
     O               40      TXID                94 '  -       '
     O               42      TXID                94 '   -  -    '
     O                                          101 'Type:'
     O                       VMTXCD             103
     O                                          115 '1099 Flag:'
     O                       VMFLAG             118
     O          E            DETL           1
     O                       #VE(4)              46
     O                                           57 'Cred Limit:'
     O                       VMCRLM        1     71
     O                                           95 'Mult Vouchers/Check:'
     O                       VMMVPC              98
     O          E            DETL           1
     O                       #VE(5)              46
     O                                           55 'Ck Dupls:'
     O                       VMCDUP              71
     O                                           94 'Summary Check Stub:'
     O                       VMSUMM              98
     O          E            DETL           1
     O                       #VE(6)              46
     O               88                          11 'Ck Message:'
     O                       VMMSG               72
     O                                           89 'Wire Transfer:'
     O                       VMWIRE              98
     O          E            DETLA          1
     O                                            6 'EMail:'
     O                       VMEML               40
     O                                           50 'URL:'
     O                       VMURL              106
     O          E            TLR            1
     O              N78                          59 '** No Vendors Found That'
     O              N78                          79 'Meet Selections ***'
