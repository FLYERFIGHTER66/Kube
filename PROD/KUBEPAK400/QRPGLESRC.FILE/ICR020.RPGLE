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
      *PROGRAM NAME-------- ICR020
      *APPLICATION--------- MASTER FILES
      *DESCRIPTION--------- MAINTAIN RECORDS IN LOCATION FILE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMWHSE    UF A E           K DISK
     FFOECTL    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMINVTLC  IF   E           K DISK
     FICR020FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     C                   Z-ADD     0             COMP              2 0
     C     COMP          CHAIN     FOECTL                             90
     C                   Z-ADD     OCPRCO        WHCOMP
      *
     C     RSTRTA        TAG
     C                   EXSR      CLRIT
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101620
     C                   SETOFF                                       212223
     C                   SETOFF                                       7724
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
      *
      * LOOKUP LOCATION
      *
     C     1             SUBST     VWHSE:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     *BLANKS       WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       VWHSE
     C                   MOVEL     WHWHSE        VWHSE
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C     VACT          OREQ      'I'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C     VACTOK        TAG
      *
      * TEST LOCATION CODE
      *
     C                   MOVEL     VWHSE         WHWHSE            3
     C     WHWHSE        CHAIN     FMWHSE                             90        90 NO REC
     C                   MOVEL     WHDESC        ODESC            30
      *
     C  N90VACT          IFEQ      'A'
     C                   SETON                                        2022
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C   90VACT          IFNE      'A'
     C                   SETON                                        2024
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C     WHWHSE        CHAIN     FMINVTLC                           91
     C  N91              SETON                                        2023
     C   23              GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        16
     C                   ENDIF
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
     C     VACT          IFEQ      'I'
     C                   MOVEL     MSG(4)        VMODE
     C                   ENDIF
      *
     C     VACT          IFEQ      'I'
     C                   SETON                                          77
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       103098
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
     C   KX              DELETE    RMWHSE
     C                   GOTO      RSTRTA
      *
     C     NODEL         TAG
      *
      * TEST DESCRIPTION
      *
     C     WHDESC        IFEQ      *BLANKS
     C                   SETON                                        10
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     WHDESC        IFNE      ODESC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     WHDESC        ODESC            30
      *
     C     WHCOMP        IFEQ      0
     C                   SETON                                        30
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     WHCOMP        CHAIN     FMCORG                             90
     C   90              SETON                                        30
     C   30              GOTO      RSTRTB
      *
     C     WHCOMP        IFNE      OCOMP
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     WHCOMP        OCOMP             2 0
      *
     C     WHGLDP        IFNE      OGLDP
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     WHGLDP        OGLDP             4 0
      *
     C     VACT          IFEQ      'I'
     C                   GOTO      ENDB
     C                   ENDIF
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      * UPDATE LOCATION MASTER FILE ON DISK
      *
     C                   MOVEL     'A'           WHSTAT
     C                   MOVEL     USERID        WHUSER
     C                   Z-ADD     TIMOD         WHTIME
     C                   Z-ADD     TDATE         WHDTLA
      *
     C     VACT          IFEQ      'A'
     C                   WRITE     RMWHSE
     C                   GOTO      ENDB
     C                   ENDIF
     C                   UPDATE    RMWHSE
     C     ENDB          TAG
     C                   EXSR      CLRIT
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C                   SETON                                        LR
      *
      *  CLRIT - THIS SUBROUTINE PROCESSES RESTART AND UPDATE OPTIONS
      *
     C     CLRIT         BEGSR
     C                   MOVE      *BLANKS       VWHSE
     C                   MOVE      *BLANKS       WHDESC
     C*                    Z-ADD0         WHCOMP
     C                   Z-ADD     0             WHGLDP
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
