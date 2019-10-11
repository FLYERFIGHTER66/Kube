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
      **PROGRAM NAME-------- PIR050
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- BUILD POINTESTTIA INVENTORY FILE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMINVTSZ  IF   E           K DISK
     FFPOIITM   UF A E           K DISK
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
     D  PROGID                 1     10                                         PROGRAM NAME
     D  RLIBR                 81     90                                         RUN LIBRARY
     D  USERID               254    263                                         USER I.D.
     D  SLIBR                314    323                                         SOURCE LIBRARY
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LYEAR                  1      4  0                                      ARC380
     D  LCANCL               133    133                                         ARC380
      ****************
      * START HERE   *
      ****************
     C                   MOVEL     'CUT'         SIZEC             3
     C                   Z-ADD     LYEAR         YEAR              4 0
     C     SIZEC         SETLL     FMINVTSZ
     C     NXT           TAG
     C     SIZEC         READE     FMINVTSZ                               90
     C   90              GOTO      END                                                         ARC38
     C                   MOVEL     IMLOOK        TST3              3
     C                   If        IMSTAT <> 'A'
     C                   Goto      Nxt
     C                   EndIf
     C     TST3          IFEQ      'POI'
     C     ITMKEY        KLIST
     C                   KFLD                    YEAR
     C                   KFLD                    IMITEM
     C     ITMKEY        CHAIN     FPOIITM                            88
     C   88              DO
     C                   CLEAR                   RPOIITM
     C                   Z-ADD     YEAR          PIYEAR
     C                   MOVEL     IMITEM        PIITEM
     C                   MOVEL     IMLOOK        PILOOK
     C                   Z-ADD     TDATE         PIDTLA
     C                   Z-ADD     TIMOD         PITIME
     C                   MOVEL     USERID        PIUSER
     C                   WRITE     RPOIITM
     C                   ENDDO                                                  88 DO
     C                   END                                                    TST3=POI
     C                   GOTO      NXT
     C     END           TAG
      /Free
       Exec SQL  //  Remove Invalid Items from FPOIITM for specified year
          Delete
          FROM    FPOIITM
          WHERE   PIYEAR=:YEAR
            and   PIITEM not in
                  ( SELECT  imitem
                    FROM    fminvt
                    WHERE   imstat = 'A'
                      and   imsize = 'CUT'
                      and   imlook like 'POI:%' );
      /End-Free
      ** END PROGRAM
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
