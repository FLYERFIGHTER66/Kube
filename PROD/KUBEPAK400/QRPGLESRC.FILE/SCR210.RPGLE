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
      **PROGRAM NAME-------- SCR210
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- MANUAL INPUT FOR GREENHOUSE CART ENTRY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FSCR210FM  CF   E             WORKSTN
     FFCALEN    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCARTST   O  A E           K DISK
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
     D  CRMDY                  1      6  0                                      ARC380
     D  CRCYMD                 7     13  0                                      ARC380
     D  CRYEAR                14     17  0                                      ARC380
     D  CRWEEK                18     19  0                                      ARC380
     D  NXMDY                 20     25  0                                      ARC380
     D  NXCYMD                26     32  0                                      ARC380
     D  NXYEAR                33     36  0                                      ARC380
     D  NXWEEK                37     38  0                                      ARC380
     D  LCANCL               133    133                                         ARC380
      ***********************
     D  ItemKey        S                   Like(ITEM)
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
      ** IF WEDNESDAY OR LATER USE NEXT WEEK ELSE USE THIS WEEK
     C     TODAY         IFGE      3
     C                   Z-ADD     NXMDY         SHPDAT
     C                   ELSE
     C                   Z-ADD     CRMDY         SHPDAT
     C                   END
      ** WRITE SCRNA
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG  DO
      ** CHECK INPUT
     C                   SETOFF                                       101112
     C                   SETOFF                                       202122
     C                   SETOFF                                       2324
     C     SHPDAT        IFLE      0
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   END
     C     SHPDAT        CHAIN     FCALEN                             10
     C   10              DO
     C                   SETON                                        11
     C                   GOTO      NXTA
     C                   ENDDO                                                  10  DO
     C     CL#Y          IFNE      1
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     CLCYMD        SHPCYM            7 0
     C                   SETOFF                                       5556
      ** WRITE SCRNA1
     C     RSTRT1        TAG
     C                   Z-ADD     0             CARTNO
     C                   Z-ADD     0             QTY
     C                   MOVE      *BLANKS       IMDES1
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   SETOFF                                       202110
     C                   SETOFF                                       303132
     C                   SETOFF                                         9899
     C     NXTA1         TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA1
     C                   READ      SCRNA1                                 90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG  DO
     C                   SETOFF                                       202110
     C                   SETOFF                                       303132
     C                   SETOFF                                           99
      ** NOW CHECK CART NUMBER
     C     CARTNO        IFLE      0
     C                   SETON                                        202199
     C                   GOTO      NXTA1
     C                   END
      * CHECK FOR SEARCH
     C     1             SUBST     ITEM:1        VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     ITEM:2        IMLOOK
     C                   MOVEL     SIZE          IMSIZE
     C                   CALL      'LKITAL'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   GOTO      NXTA1
     C                   ENDIF
      * CHECK IF ITEM VALID
     C                   If        %SubSt(ITEM:12:1) = 'P'
     C                   Eval      ItemKey = %Subst(ITEM:1:11) + ' '
     C                   Else
     C                   Eval      ItemKey = ITEM
     C                   EndIF
     C     ITMKEY        KLIST
     C                   KFLD                    ITEMKey
     C                   KFLD                    SIZE
     C     ITMKEY        CHAIN     FMINVT                             10
     C   10              DO
     C                   SETON                                        99
     C                   GOTO      NXTA1
     C                   ENDDO                                                  10  DO
      * CHECK QUANTITY
     C     QTY           IFLE      0
     C                   SETON                                        303199
     C                   GOTO      NXTA1
     C                   END
      *
     C     QTY           IFGT      70
     C                   SETON                                        303299
     C                   GOTO      NXTA1
     C                   END
      * SHOW VERIFY SCREEN
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA1
     C                   END
      *
      ** NOW BUILD CART RECORDS
     C                   Z-ADD     0             OUT               2 0
      ** IF THERE UPDATE
     C     NXTOUT        TAG
     C                   CLEAR                   RCARTS
     C                   Z-ADD     CARTNO        CTCART
     C                   MOVEL     'A'           CTSTAT
     C                   Z-ADD     99999999      CTTAG#
     C                   MOVEL     ITEM          CTITEM
     C                   MOVEL     SIZE          CTSIZE
     C                   Z-ADD     SHPCYM        CTSHDT
     C                   WRITE     RCARTS
     C                   ADD       1             OUT
     C     OUT           IFLT      QTY
     C                   GOTO      NXTOUT
     C                   END
      **  PRINT
     C                   Z-ADD     0             CONTRL            6 0
     C                   CALL      'SCR230CL'
     C                   PARM                    CARTNO
     C                   PARM                    SHPCYM
     C                   PARM                    CONTRL
     C                   GOTO      RSTRT1
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
     C     TDATE         CHAIN     FCALEN                             90
     C                   Z-ADD     CL#Y          TODAY             1 0
     C                   MOVE      *BLANKS       LCANCL
     C                   ENDSR
