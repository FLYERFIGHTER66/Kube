      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC  1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       E F D ENTERPRISES,INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- APR725
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- YEAR-END PROCESSING 1099 EDIT LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFV1099    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFAPCTL    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FAPR725    O    F  120        PRINTER OFLIND(*INOF)
      *
     D MSG             S             16    DIM(9) CTDATA PERRCD(1)              MESSAGES
     D #SL             S             32    DIM(5)
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
     D                UDS
     D  LCO                    1      2  0
     D  LYEAR                  3      6  0
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
     IRMCORG
     I              RGNAME                      #WSLD1
     I              RGADR1                      #WSLD2
     I              RGADR2                      #WSLD3
     I              RGADR3                      #WSLD4
     I              RGCITY                      #WSLCT
     I              RGSTST                      #WSLST
     I              RGZIP                       #WSLZP
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FMCORG                             97
     C                   EXSR      #ORG
     C     LCO           CHAIN     FAPCTL                             97
      *
     C                   EXCEPT    HDG
     C                   EXCEPT    HDG1
     C                   EXCEPT    HDG2
      *
     C     NXTA          TAG
     C                   SETOFF                                       404277
     C                   SETOFF                                       7678
     C                   READ      FV1099                                 90
     C   90              GOTO      END
      *
     C     YMCONO        IFNE      LCO
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     YMYEAR        IFNE      LYEAR
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     YMVEND        CHAIN     FMVEND                             91
      *
     C     VMFLAG        IFEQ      4
     C                   SETON                                        77
     C                   GOTO      NOCHK
     C                   ENDIF
      *
     C     VMFLAG        IFEQ      0
     C                   MOVEL     'No '         PT1099            3
     C                   GOTO      NOINT
     C                   ENDIF
      *
     C     VMFLAG        IFEQ      9
     C                   GOTO      INT
     C                   ENDIF
      *
     C     YMPAID        IFGT      AZMIS$
     C                   MOVEL     'Yes'         PT1099            3
     C                   SETON                                        20
     C                   GOTO      NOINT
     C                   ENDIF
     C     YMPAID        IFLE      AZMIS$
     C                   MOVEL     'No '         PT1099            3
     C                   GOTO      NOINT
     C                   ENDIF
      *
     C     INT           TAG
     C     VMFLAG        IFEQ      9
     C     YMPAID        ANDGT     AZINT$
     C                   MOVEL     'Yes'         PT1099            3
     C                   SETON                                        20
     C                   ELSE
     C                   MOVEL     'No '         PT1099            3
     C                   ENDIF
     C     NOINT         TAG
      *
     C     VMFLAG        IFNE      0
     C     VMTXID        ANDEQ     *BLANKS
     C                   SETON                                        76
     C                   ENDIF
      *
     C   20VMTXID        IFNE      'F'
     C     VMTXID        ANDNE     'S'
     C                   SETON                                        78
     C                   ENDIF
      *
     C     VMTXCD        IFEQ      'F'
     C                   SETON                                        40
     C                   ENDIF
     C     VMTXCD        IFEQ      'S'
     C                   SETON                                        42
     C                   ENDIF
      *
     C                   MOVEL     VMTXID        TXID              9 0
     C     NOCHK         TAG
      *
     C     VMFLAG        IFEQ      1
     C                   MOVEL     MSG(1)        TYPE             16
     C                   ENDIF
     C     VMFLAG        IFEQ      2
     C                   MOVEL     MSG(2)        TYPE             16
     C                   ENDIF
     C     VMFLAG        IFEQ      3
     C                   MOVEL     MSG(3)        TYPE             16
     C                   ENDIF
     C     VMFLAG        IFEQ      4
     C                   MOVEL     MSG(4)        TYPE             16
     C                   ENDIF
     C     VMFLAG        IFEQ      5
     C                   MOVEL     MSG(5)        TYPE             16
     C                   ENDIF
     C     VMFLAG        IFEQ      6
     C                   MOVEL     MSG(6)        TYPE             16
     C                   ENDIF
     C     VMFLAG        IFEQ      7
     C                   MOVEL     MSG(7)        TYPE             16
     C                   ENDIF
     C     VMFLAG        IFEQ      8
     C                   MOVEL     MSG(8)        TYPE             16
     C                   ENDIF
     C     VMFLAG        IFEQ      9
     C                   MOVEL     MSG(9)        TYPE             16
     C                   ENDIF
      *
     C   OF              DO
     C   OF              EXCEPT    HDG
     C   OF              EXCEPT    HDG2
     C                   ENDDO
      *
     C                   EXCEPT    DETL
     C                   GOTO      NXTA
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      ***********
      * #ORG    *
      ***********
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE COMPANY
      *  FILE.  WORK FIELDS ARE DEFINED AS:
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
     C     #ORG          BEGSR
      *
     C                   MOVE      *BLANKS       #SL
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WSLD1        #SL(#X)
     C                   ADD       1             #X
     C     #WSLD2        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD1
     C                   MOVEL     #WSLD2        #SL(#X)
     C                   ADD       1             #X
     C     #SLD1         TAG
     C     #WSLD3        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD2
     C                   MOVEL     #WSLD3        #SL(#X)
     C                   ADD       1             #X
     C     #SLD2         TAG
     C     #WSLD4        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD3
     C                   MOVEL     #WSLD4        #SL(#X)
     C                   ADD       1             #X
     C     #SLD3         TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WSLCT        CAT       #WSLST:1      WORK1
     C                   MOVEL     #WSLZP        WORK3
     C                   MOVE      #WSLZP        WORK4
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
     C                   SETOFF                                       919293
     C                   ENDSR
      *
     OAPR725    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           68 '1099 Edit Listing For'
     O                       LYEAR               73
     O                       TIMOD              120 '  :  :  '
     O          E            HDG1           1
     O                                           12 'For Company:'
     O                       #SL(1)              45
     O          E            HDG1           1
     O                       #SL(2)              45
     O          E            HDG1           1
     O                       #SL(3)              45
     O          E            HDG1           1
     O                       #SL(4)              45
     O          E            HDG1           1
     O                       #SL(5)              45
     O          E            HDG1           1
     O                       RGTXID              23 '  -       '
     O          E            HDG2           0
     O                                           10 'Vendor'
     O                                           20 'Name'
     O                                           45 '1099'
     O                                           59 'Amount Paid'
     O                                           70 'Tax I.D.'
     O                                           76 'Type'
     O                                           81 'Code'
     O                                          104 'Error'
     O          E            HDG2           2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       YMVEND        Z     10
     O                       VMNAME              41
     O                       PT1099              45
     O                       YMPAID        J     60
     O               40      TXID                72 '  -       '
     O               42      TXID                73 '   -  -    '
     O                       VMTXCD              75
     O                       VMFLAG              80
     O                       TYPE           B    97
     O               91                         120 'Invalid Vendor Number  '
     O               76 20                      120 'Invalid Tax I.D. Number'
     O               77 20                      120 'Invalid 1099 Code      '
**
Rents
Royalties
Prizes/Awards
Invalid Type
Fishing Boat
Medical Payments
Non-Employee
Dividends
Interest
