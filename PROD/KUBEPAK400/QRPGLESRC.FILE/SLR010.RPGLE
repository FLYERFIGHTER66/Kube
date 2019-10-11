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
      **PROGRAM NAME-------- SLR010
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SOW LINE SELECTIONS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FSLR010FM  CF   E             WORKSTN
     FFCALEN    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:ICALEN)
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
     D  SOWLN#                 1      2  0                                      ARC380
     D  LCANCL               133    133                                         ARC380
      ***********************
      ** START OR RESTART  **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     0             FRMDAT
     C                   Z-ADD     0             BEGYY
     C                   Z-ADD     0             BEGWW
     C                   MOVE      *BLANKS       LCANCL
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                       9899
      ** DISPLAY SCREEN
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                         99
      ** CHECK INPUT
      **
      ** CHECK DATE
     C     FRMDAT        IFLE      0
     C     BEGYY         ANDLE     0
     C     BEGWW         ANDLE     0
     C                   SETON                                        10  99
     C                   GOTO      NXTA
     C                   ENDIF
      **
     C     FRMDAT        IFGT      0
     C                   Z-ADD     FRMDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1099
     C                   GOTO      NXTA
     C                   END
     C     FRMDAT        CHAIN     FCALEN                             92
     C                   MOVEL     CLCENT        BEGYY
     C                   MOVE      CLYEAR        BEGYY
     C                   Z-ADD     CLWEEK        BEGWW
     C                   ELSE                                                   FRMDAT > 0
     C                   MOVEL     BEGYY         CLCENT
     C                   MOVE      BEGYY         CLYEAR
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    BEGWW
     C                   KFLD                    CL#Y
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             92
     C   92              DO
     C                   SETON                                        2099
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        FRMDAT
     C                   END                                                    FRMDAT > 0
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
     C                   MOVEL     CLCENT        TYEAR
     C                   MOVE      CLYEAR        TYEAR
     C                   Z-ADD     CLWEEK        TWEEK
     C                   ENDSR
