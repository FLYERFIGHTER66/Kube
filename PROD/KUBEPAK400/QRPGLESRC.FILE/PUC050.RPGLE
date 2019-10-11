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
      **PROGRAM NAME-------- PUC050
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TRUCK SCHEDULE
      **PROGRAMMER---------- EFD
      **APPLICATION--------- TRUCK SCHEDULE SELECTION SCREEN
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FPUC050FM  CF   E             WORKSTN
     FFCALEN    IF   E           K DISK
     FFPUSTAT   IF   E           K DISK
     FFPUUCKS   UF   E           K DISK
     FFPUUCKO   UF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:ICALEN)
     FFCALENCY  IF   E           K DISK
     F                                     RENAME(RCALEN:YCALEN)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LCO                    1      2  0                                      ARC380
     D  BEGDT                  3      8  0                                      ARC380
     D  ENDDT                  9     14  0                                      ARC380
     D  YEAR                  15     18  0                                      ARC380
     D  WEEK                  19     20  0                                      ARC380
     D  CANCEL               133    133                                         ARC380
      ***********************
      ** START OR RESTART  **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     1             LCO
     C                   Z-ADD     0             BEGDT
     C                   Z-ADD     0             ENDDT
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                       989955
     C                   MOVE      'N'           SHOWCT
      ** DISPLAY SCREEN
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           CANCEL
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
      ** CHECK CART CHART Y/N
     C     SHOWCT        IFNE      'Y'
     C     SHOWCT        ANDNE     'N'
     C                   SETON                                        22  99
     C                   GOTO      NXTA
     C                   ENDIF
     C     SHOWCT        IFEQ      'Y'
     C                   MOVE      *ON           *INU1
     C                   ELSE
     C                   MOVE      *OFF          *INU1
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
     C     CL#Y          IFNE      1
     C                   SETON                                        101199    9
     C                   GOTO      NXTA
     C                   END
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
     C                   Z-ADD     FRMDAT        BEGDT
     C                   Z-ADD     BEGDT         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        BEGCYM            7 0
     C     BEGCYM        CHAIN     FPUSTAT                            90
     C  N90              DO
     C     STTRNR        IFNE      'Y'
     C     NXTAE         TAG
     C                   WRITE     SCRNAE
     C                   READ      SCRNAE                                 90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           CANCEL
     C                   GOTO      END
     C                   ENDDO
     C  NKJ              GOTO      NXTAE
     C                   EXSR      CLRTRK
     C                   ELSE                                                   STTRNR<>Y
     C     NXTAE2        TAG
     C                   WRITE     SCRNAE2
     C                   READ      SCRNAE2                                90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           CANCEL
     C                   GOTO      END
     C                   ENDDO
     C                   GOTO      NXTAE2
     C                   END                                                    STTRNR<>Y
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           CANCEL
     C                   GOTO      END
     C                   ENDDO
     C  NKJ              GOTO      NXTAE
     C                   ENDDO
      *** SEE WHERE WE ARE
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   END
      ** GET ENDING DATES
     C                   Z-ADD     BEGYY         ENDYY             4 0
     C                   Z-ADD     BEGWW         ENDWW             2 0
     C                   MOVEL     BEGYY         CLCENT
     C                   MOVE      BEGYY         CLYEAR
     C                   Z-ADD     7             CL#Y
     C     CALKEY        CHAIN     FCALEX                             92
     C                   Z-ADD     CLDATE        ENDDT
     C                   GOTO      END
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** CLEAR FILES       **
      ***********************
     C     CLRTRK        BEGSR
     C     BEGCYM        SETLL     FPUUCKS
     C     NXTC1         TAG
     C     BEGCYM        READE     FPUUCKS                                90
     C  N90              DO
     C                   DELETE    RPUUCKS
     C                   GOTO      NXTC1
     C                   ENDDO
     C     BEGCYM        SETLL     FPUUCKO
     C     NXTC2         TAG
     C     BEGCYM        READE     FPUUCKO                                90
     C  N90              DO
     C                   DELETE    RPUUCKO
     C                   GOTO      NXTC2
     C                   ENDDO
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##CYMD        CHAIN     FCALENCY                           10
     C                   MOVEL     CLCENT        CYEAR
     C                   MOVE      CLYEAR        CYEAR
     C                   Z-ADD     CLWEEK        CWEEK
     C   10              SETOFF                                       10
     C                   ENDSR
