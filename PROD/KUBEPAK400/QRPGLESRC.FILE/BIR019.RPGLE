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
      *PROGRAM NAME-------- BIR019
      *APPLICATION--------- MASTER FILES
      *DESCRIPTION--------- MAINTAIN RECORDS IN USER FILE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMUSER    UF A E           K DISK
     FFMDEPT    IF   E           K DISK
     FBIR019FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
     D MSG             S              9    DIM(4) CTDATA PERRCD(1)
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
      *
     D                UDS
     D  LLIST                  1      1
     D  LCANCL               133    133
      *
      * PROGRAM MAINLINE
      *
     C     RSTRTA        TAG
     C                   EXSR      CLRIT
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102021
     C                   SETOFF                                       222316
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
      *
      * LOOKUP USER
      *
     C     1             SUBST     VUSER:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VUSER         USUSER
     C                   CALL      'LKUSER'
     C                   PARM                    USUSER           10
     C                   PARM                    USNAME           30
     C                   PARM                    USDEPT            3
     C                   MOVEL     *BLANKS       VUSER
     C                   MOVEL     USUSER        VUSER
     C                   SETON                                        99
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C                   GOTO      NXTA
     C     VACTOK        TAG
      *
      * TEST USER
      *
     C     VUSER         IFEQ      *BLANKS
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VUSER         CHAIN     FMUSER                             90        90 NO REC
      *
     C  N90VACT          IFEQ      'A'
     C                   SETON                                        2022
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C   90VACT          IFNE      'A'
     C                   SETON                                        2023
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        16
     C                   ENDIF
      *
     C  N90              MOVEL     USDEPT        VDEPT
     C                   SETOFF                                       98
      *
     C     ENDA          TAG
      *
      * LOAD MODE FOR OUTPUT
      *
     C     VACT          IFEQ      'A'
     C                   MOVEL     MSG(1)        VMODE
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   MOVEL     MSG(2)        VMODE
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   MOVEL     MSG(3)        VMODE
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       1020
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODEL
     C                   ENDIF
      *
     C  NKX              GOTO      RSTRTA
     C   KX              EXSR      OUTREC
     C   KX              EXSR      CLRIT
     C                   GOTO      RSTRTA
      *
     C     NODEL         TAG
      *
      * TEST DESCRIPTION
      *
     C     USNAME        IFEQ      *BLANKS
     C                   SETON                                        10
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     USNAME        IFNE      ONAME
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     USNAME        ONAME            30
      *
     C     1             SUBST     VDEPT:1       TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     VDEPT         DEDEPT            3
     C                   CALL      'LKDEPT'
     C                   PARM                    DEDEPT
     C                   PARM                    DEDESC           30
     C                   MOVEL     *BLANKS       VDEPT
     C                   MOVEL     DEDEPT        VDEPT
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VDEPT         CHAIN     FMDEPT                             90
     C   90              SETON                                        20
     C   20              GOTO      RSTRTB
      *
     C     VDEPT         IFNE      ODEPT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VDEPT         ODEPT             3
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   EXSR      OUTREC
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C                   SETON                                        LR
      *
      **********
      * OUTREC *
      **********
     C     OUTREC        BEGSR
     C                   MOVEL     VUSER         USUSER
     C                   MOVEL     VDEPT         USDEPT
     C     VACT          IFEQ      'A'
     C                   WRITE     RMUSER
     C                   GOTO      ENDB
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RMUSER
     C                   GOTO      ENDB
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RMUSER
     C                   ENDIF
     C     ENDB          TAG
     C                   EXSR      CLRIT
     C                   ENDSR
      *
      **********
      * CLRIT  *
      **********
      *
     C     CLRIT         BEGSR
     C                   MOVE      *BLANKS       VUSER
     C                   MOVE      *BLANKS       USNAME
     C                   MOVE      *BLANKS       USDEPT
     C                   MOVE      *BLANKS       VDEPT
     C     ECLR          ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
      *
**
  Add
 Change
 Delete
 Inquire
