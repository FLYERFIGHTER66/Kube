      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- SCR020
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- GET WEEK DATES LOADED INTO LDA
      *
      * TO GET PRINTER INFO FSCCTL HAS PRINTERS SELECTED BY USE
      * O=ORDER VERIFY/FULFILLMENT PROGRAMS
      * R=READY BAY PROGRAMS
      * B=BAR CODE PROGRAMS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFCALEN    IF   E           K DISK
     F                                     RENAME(RCALEN:CALEND)
     FFCALEX    IF   E           K DISK
     FNSCCTL    IF   E           K DISK
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
     D  CRMDY                  1      6  0                                      ARC380
     D  CRCYMD                 7     13  0                                      ARC380
     D  CRYEAR                14     17  0                                      ARC380
     D  CRWEEK                18     19  0                                      ARC380
     D  NXMDY                 20     25  0                                      ARC380
     D  NXCYMD                26     32  0                                      ARC380
     D  NXYEAR                33     36  0                                      ARC380
     D  NXWEEK                37     38  0                                      ARC380
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LTYPE                256    256
      **************************
      * GET CURRENT WEEK DATES *
      **************************
     C                   Z-ADD     0             CRMDY                                         ARC38
     C                   Z-ADD     0             CRCYMD                                        ARC38
     C                   Z-ADD     0             CRYEAR                                        ARC38
     C                   Z-ADD     0             CRWEEK                                        ARC38
     C                   Z-ADD     0             NXMDY                                         ARC38
     C                   Z-ADD     0             NXCYMD                                        ARC38
     C                   Z-ADD     0             NXYEAR                                        ARC38
     C                   Z-ADD     0             NXWEEK                                        ARC38
     C                   MOVE      *BLANKS       LCANCL
     C                   MOVE      *BLANKS       SZDEPT
     C     SZDEPT        CHAIN     nSCCTL                             90
      ** DEFAULT TO ORDER PRINTER
     C                   MOVEL     SZOPRT        LPRTR
     C     LTYPE         IFEQ      'B'
     C                   MOVEL     SZLPRT        LPRTR
     C                   END
     C     LTYPE         IFEQ      'R'
     C                   MOVEL     SZRPRT        LPRTR
     C                   END
     C                   MOVEL     '*NAR'        LFORM
     C                   Z-ADD     1             LCOPY
     C                   MOVEL     'N'           LJOBQ
     C                   MOVEL     '*NO'         LHOLD
     C                   MOVEL     '*NO'         LSAVE
      ** IF NO DATES CANCEL
     C     TDATE         CHAIN     FCALEN                             90
     C   90              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             90
     C                   Z-ADD     CLDATE        CRMDY
     C                   Z-ADD     CLCYMD        CRCYMD
     C                   MOVEL     CLCENT        CRYEAR
     C                   MOVE      CLYEAR        CRYEAR
     C                   Z-ADD     CLWEEK        CRWEEK
      ***********************
      * GET NEXT WEEK DATES *
      ***********************
     C     CLWEEK        ADD       1             WEEK              2 0
     C     WEEK          IFLE      52
     C                   Z-ADD     WEEK          CLWEEK
     C                   ELSE
     C     WEEK          IFGT      53
     C                   Z-ADD     1             CLWEEK
     C                   ELSE
     C                   Z-ADD     WEEK          CLWEEK
     C     CALKEY        CHAIN     FCALEX                             90
     C   90              Z-ADD     1             CLWEEK
     C                   END
     C                   END
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             90
     C                   Z-ADD     CLDATE        NXMDY
     C                   Z-ADD     CLCYMD        NXCYMD
     C                   MOVEL     CLCENT        NXYEAR
     C                   MOVE      CLYEAR        NXYEAR
     C                   Z-ADD     CLWEEK        NXWEEK
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
