      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      **PROGRAM NAME-------- CUC330
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- REPRINT ORDERS TO P.C. PROMPT
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FCUC330FM  CF   E             WORKSTN
     FFCUTORDN  IF   E           K DISK
WJB  FFMVEND    IF   E           K DISK
      *
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  ORDER                  1      6  0                                      ARC380
     D  UPDAT                  7      7                                         ARC380
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133                                         ARC380
      *
WJB  D  Vendor         S                   Like(VMVEND)
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     0             ORDNO
     C                   MOVE      *BLANKS       LCANCL
     C                   SETOFF                                       10
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** F KEYS
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
     C   KD              DO
     C                   EXSR      GetORD
     C                   If        COORD# = 0
     C                   SETON                                        58
     C                   GoTo      NxtA
     C                   EndIf
     C                   ENDDO
     C                   SETOFF                                       10
     C     ORDNO         IFLE      0
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
WJB  C     VendOrd#      KList
WJB  C                   KFld                    Vendor
WJB  C                   KFld                    ORDNO
WJB  C*    ORDNO         CHAIN     FCUTORDN                           10
WJB  C     VendOrd#      CHAIN     FCUTORDN                           10
     C   10              GOTO      NXTA
      ** IF HERE ALL OK
     C                   Z-ADD     ORDNO         ORDER
     C     END           TAG
     C                   SETON                                        LR
      ********************
      **   GET ORDER    **
      ********************
     C     GETORD        BEGSR
WJB  C                   Eval      COORD# = *Zeros
WJB  C                   Call      'CUR355'
WJB  C                   Parm                    Vendor
WJB  C                   Parm                    COORD#
WJB  C                   If        COORD# <> 0
WJB  C                   Eval      *In10 = *Off
WJB  C                   Eval      ORDNO = COORD#
WJB  C                   EndIf
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
WJB  C     *Entry        PList
WJB  C                   Parm                    Vendor
WJB  C     Vendor        Chain     FMVEND
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVEL     'Y'           UPDAT
     C                   Z-ADD     0             ORDER
      ** GET PRINT PARMS
     C                   MOVEL     'P1      '    LPRTR
     C                   MOVEL     '*NAR'        LFORM
     C                   Z-ADD     1             LCOPY
     C                   MOVEL     'N'           LJOBQ
     C                   MOVEL     '*NO  '       LHOLD
     C                   MOVEL     '*NO  '       LSAVE
     C                   MOVE      *BLANKS       LCANCL
     C                   ENDSR
