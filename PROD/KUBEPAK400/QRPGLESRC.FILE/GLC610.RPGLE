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
      *PROGRAM NAME-------- GLC610
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- YEAR END PRELIMINARY CLOSE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FGLC610FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFGLDET    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFGLCTL    IF   E           K DISK
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
     D  LCO                    1      2  0                                      GLR360
     D  LLIBR                 88     96
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      * CHECK FOR PREVIOUS CLOSE
      *
      *
     C                   MOVE      *BLANKS       LCANCL
     C     LCO           CHAIN     FGLCTL                             90
     C     GZPRYN        IFEQ      'Y'
     C                   WRITE     SCRNE
     C                   READ      SCRNE                                  90
     C                   MOVE      'X'           LCANCL
     C                   GOTO      ENDP
     C                   ENDIF
     C                   Z-ADD     1             VOUT
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     VOUT          IFEQ      1
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*NO '        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      2
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      3
     C                   MOVEL     '*YES'        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             92
      *
     C                   Z-ADD     ACST01        ##MDY
     C                   MOVE      ##MDY         YR                2 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        BDATE             7 0
      *
     C     ACMPCN        IFEQ      'M'
     C                   Z-ADD     ACEN12        ##MDY
     C                   ELSE
     C                   Z-ADD     ACEN13        ##MDY
     C                   ENDIF
     C                   MOVEL     ##MDY         MTH               2 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        EDATE             7 0
      *
     C     NXT           TAG
     C                   SETOFF                                       50
     C                   READ      FGLDET                                 90
     C   90              GOTO      END
      *
     C     GTPOST        IFEQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     GTAPER        IFEQ      9999
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     GTTDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        GDATE             7 0
      *
     C     GDATE         IFGT      EDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     GDATE         IFLT      BDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     GTPOST        IFNE      'Y'
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C                   MOVE      'X'           LCANCL
     C                   GOTO      ENDP
     C                   ENDIF
      *
     C     END           TAG
      *
      * BUILD LIBRARY FOR YEAR END - USE LDA COMPANY NUMBER
      * LIBRARY NAME='LSTYRGYYCC' YY=LAST 2 DIGITS OF YEAR CC=COMPANY #
     C                   MOVEL     YR            WRK1              4 0
     C                   MOVE      LCO           WRK1
     C                   MOVEL     'LSTYR'       LLIBR
     C                   MOVE      WRK1          LLIBR
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      **
