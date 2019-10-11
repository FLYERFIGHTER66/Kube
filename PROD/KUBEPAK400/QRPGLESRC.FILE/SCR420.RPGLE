    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
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
      **PROGRAM NAME-------- SCR420
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- INQUIRY INTO UNFILLED ORDERS FROM CART
      *                      SCANNERS AND PRINT SHEETS.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  4/05/02 ADD CHANGE UPDATE TO PRINTED TO SCR401P.
      *
     FFPTORDC   IF   E           K DISK
     FFPUTORDS  IF   E           K DISK
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
     D  RUNST                  1      1
     D  STRDAT                 4     10  0
     D  PLDATE                11     16  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  VOUT                 131    131  0
     D  LCANCL               133    133
     D  UDSMASTER           1023   1024  0
      *  PRINT PROGRAM 'SCR410CL2'
     D PRINT           C                   CONST('SCR410CL2')
      ***********************
      ** START HERE        **
      ***********************
     C                   Z-ADD     STRDAT        SHPCYM            7 0
     C     SHIPKEY       KList
     C                   KFld                    SHPCYM
     C                   KFld                    UDSMASTER
     C     SHIPKEY       SETLL     FPUTORDS
     C     NXT           TAG
     C     SHIPKEY       READE     FPUTORDS                               90
     C   90              GOTO      END
     C     PDITEM        IFNE      IMITEM
     C     PDSIZE        ORNE      IMSIZE
     C     PITMKY        KLIST
     C                   KFLD                    SHPCYM
     C                   KFLD                    UDSMASTER
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C     PITMKY        CHAIN     FPTORDC                            91
     C  N91PTPRTD        IFNE      'Y'
     C     QORD          ANDGT     QSCH
     C*                    MOVEL'Y'       PTPRTD
     C* N91                UPDATRPTORDC
     C                   CALL      PRINT
     C                   PARM                    SHPCYM
     C                   PARM                    UDSMASTER
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   ELSE
     C**                   UNLCKFPTORDC
     C                   END
     C                   MOVEL     PDITEM        IMITEM           12
     C                   MOVEL     PDSIZE        IMSIZE            3
     C                   Z-ADD     0             QORD              9 0
     C                   Z-ADD     0             QSCH              9 0
     C                   END
     C                   ADD       PDQORD        QORD
     C                   ADD       PDQSCH        QSCH
     C                   GOTO      NXT
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
