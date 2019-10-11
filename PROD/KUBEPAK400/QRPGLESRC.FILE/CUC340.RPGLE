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
      **PROGRAM NAME-------- CUC340
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- TRANSFER ORDERS TO P.C. PROMPT
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FCUC340FM  CF   E             WORKSTN
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
     D  LCANCL               133    133                                         ARC380

WJB  D  Vendor         S                   Like(VMVEND)
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   EXSR      GETNXT
     C     NXTORD        IFLE      0
     C                   SETON                                        22
     C                   ELSE
     C                   SETOFF                                       22
     C                   END
     C                   Z-ADD     NXTORD        ORDNO
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
     C                   SETOFF                                       10
     C     ORDNO         IFLE      0
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
WJB  C*    ORDNO         CHAIN     FCUTORDN                           10
WJB  C     VendOrd#      CHAIN     FCUTORDN                           10
     C   10              GOTO      NXTA
      ** IF HERE ALL OK
     C     ORDNO         IFEQ      NXTORD
     C                   MOVEL     'Y'           UPDAT
     C                   ELSE
     C                   MOVEL     'N'           UPDAT
     C                   END
     C                   Z-ADD     ORDNO         ORDER
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** GET NEXT ORDER    **
      ***********************
     C     GETNXT        BEGSR
     C                   Z-ADD     0             NXTORD
     C     VendOrd#      KList
     C                   KFld                    Vendor
     C                   KFld                    NXTORD
WJB  C*    NXTORD        SETLL     FCUTORDN
WJB  C     VendOrd#      SETLL     FCUTORDN
     C     NXTGET        TAG
WJB  C*                  READ      FCUTORDN                               91
WJB  C     Vendor        READe     FCUTORDN                               91
     C   91              GOTO      ENDGET
WJB  C                   If        COVEND <> Vendor
WJB  C                   Goto      ENDGET
WJB  C                   EndIf
     C     COTRAN        IFNE      'Y'
     C                   Z-ADD     COORD#        NXTORD
     C                   GOTO      ENDGET
     C                   END
     C                   GOTO      NXTGET
     C     ENDGET        ENDSR
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
     C                   ENDSR
