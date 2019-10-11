      *----------------------------------------------------------      ----
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDE      RED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXC      EPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *       EFD ENTERPRISES INC.  215-643-5352
      *
      *----------------------------------------------------------      ----
      *PROGRAM NAME-------- BIR015
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- ENTER/UPDATE C/M REASON CODES
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FBIR015FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFCMREAS   UF A E           K DISK
     FFARCTL    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFGLDF     IF   E           K DISK
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(2) CTDATA PERRCD(1)
      *
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
     D  LCO                    1      2  0
     D  LLIST                  3      3
     D  LCANCL               133    133
      *
     C     RSTRT         TAG
     C                   EXSR      CLRIT
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102021
     C                   SETOFF                                       222324
     C                   SETOFF                                       8898
      *
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
      *
     C                   MOVEL     VREAS         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      VREAS         TST2              2
     C                   MOVE      *BLANKS       CRREAS
     C                   MOVEL     TST2          CRREAS
     C                   CALL      'LKREAS'
     C                   PARM                    VCO
     C                   PARM                    CRREAS
     C                   PARM                    CRDESC           30
     C                   MOVEL     *BLANKS       VREAS
     C                   MOVEL     CRREAS        VREAS
     C                   SETON                                        99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C   10              GOTO      NXTA
     C     VACTOK        TAG
      *
      * MUST HAVE REASON CODE
      *
     C     VREAS         IFEQ      *BLANKS
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * VALIDATE REASON
      *
     C     CKEY          CHAIN     FCMREAS                            96
      *
     C     VACT          IFEQ      'A'
     C  N96              SETON                                        2022
     C   22              GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C   96              SETON                                        2023
     C   23              GOTO      NXTA
     C                   ENDIF
      *
      * CHECK FOR RESERVED CODES
      *
     C     VACT          IFEQ      'D'
     C     VREAS         ANDEQ     'TAX'
     C                   SETON                                        2024
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C     VREAS         ANDEQ     'DLV'
     C                   SETON                                        2024
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        88
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C                   MOVE      *BLANKS       CRDESC
     C                   Z-ADD     0             CRGLNO
     C                   Z-ADD     0             CRCUR$
     C                   Z-ADD     0             CRPRI$
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       1020
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRT
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODEL
     C                   ENDIF
      *
     C   KX              GOTO      NODEL
     C                   GOTO      RSTRT
      *
     C     NODEL         TAG
      *
     C   KB              DO
     C                   MOVEL     *BLANKS       GCLOOK
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    VCO
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   Z-ADD     GCGLNO        CRGLNO
     C                   GOTO      NXTB
     C                   ENDDO
      *
      * TEST DESCRIPTION
      *
     C     CRDESC        IFEQ      *BLANKS
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     CRDESC        IFNE      ODESC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     CRDESC        ODESC            30
      *
      * VALIDATE G/L NUMBER
      *
     C     ACGL          IFEQ      'Y'
     C     GKEY          KLIST
     C                   KFLD                    VCO
     C                   KFLD                    CRGLNO
     C   77GKEY          CHAIN     FMGLCH                             96
     C   96              SETON                                        20
     C   20              GOTO      NXTB
     C                   ENDIF
      *
     C     CRGLNO        IFNE      OGLNO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     CRGLNO        OGLNO             8 0
      *
     C  N88CNT           IFGT      1
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C                   EXSR      OUTREC
     C                   GOTO      RSTRT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      **********
      * OUTREC *
      **********
     C     OUTREC        BEGSR
     C                   MOVEL     VREAS         CRREAS
     C                   Z-ADD     LCO           CRCOMP
     C     VACT          IFEQ      'A'
     C                   WRITE     RCMREAS
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RCMREAS
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RCMREAS
     C                   ENDIF
     C                   ENDSR
      *
      **********
      * CLRIT  *
      **********
     C     CLRIT         BEGSR
     C                   SETOFF                                       99
     C                   MOVE      *BLANKS       VACT
     C                   MOVE      *BLANKS       VREAS
     C                   MOVE      *BLANKS       CRDESC
     C                   Z-ADD     *ZEROS        CRGLNO
     C                   ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN(N)  FARCTL                             90
     C  N90ACGL          IFEQ      'Y'
     C                   SETON                                        77
     C                   ENDIF
     C   90              SETOFF                                       77
      *
     C                   Z-ADD     LCO           VCO               2 0
      *
     C                   MOVEL     LCO           GDCOMP
     C                   MOVEL     '01'          GDTYPE
     C     KEY4          KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GDTYPE
     C     KEY4          CHAIN     FGLDF                              90
      *
     C     CKEY          KLIST
     C                   KFLD                    LCO
     C                   KFLD                    VREAS
     C                   MOVEL     'TAX'         VREAS
     C     CKEY          CHAIN(N)  FCMREAS                            90
     C   90              DO
     C                   Z-ADD     LCO           CRCOMP
     C                   MOVEL     'TAX'         CRREAS
     C                   Z-ADD     GDSTTX        CRGLNO
     C                   Z-ADD     0             CRCUR$
     C                   Z-ADD     0             CRPRI$
     C                   MOVEL     MSG(1)        CRDESC
     C                   WRITE     RCMREAS
     C                   ENDDO
     C                   MOVEL     'DLV'         VREAS
     C     CKEY          CHAIN(N)  FCMREAS                            90
     C   90              DO
     C                   MOVEL     'DLV'         CRREAS
     C                   Z-ADD     LCO           CRCOMP
     C                   Z-ADD     GDFRGT        CRGLNO
     C                   Z-ADD     0             CRCUR$
     C                   Z-ADD     0             CRPRI$
     C                   MOVEL     MSG(2)        CRDESC
     C                   WRITE     RCMREAS
     C                   ENDDO
     C                   ENDSR
      *
** Message array
Sales Tax Adjustment
Freight Charge Credit
