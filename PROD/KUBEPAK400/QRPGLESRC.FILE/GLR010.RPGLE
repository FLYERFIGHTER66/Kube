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
      *PROGRAM NAME-------- GLR010
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- CHART OF ACCOUNTS MAINTENANCE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 6/29/00 EFD01 CHANGE DELETE LOGIC
      *
      *
     FGLR010FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMGLCH    UF A E           K DISK
     FFGLBAL    IF   E           K DISK
      *
     D GLT             S             11  2 DIM(13)                              THIS YEAR BAL
     D GLL             S             11  2 DIM(13)                              LAST YEAR BAL
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
     D  USERID               254    261
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
     D  LCANCL               133    133
      *
     IRGLBAL
     I              GLT01                       GLT(1)
     I              GLT02                       GLT(2)
     I              GLT03                       GLT(3)
     I              GLT04                       GLT(4)
     I              GLT05                       GLT(5)
     I              GLT06                       GLT(6)
     I              GLT07                       GLT(7)
     I              GLT08                       GLT(8)
     I              GLT09                       GLT(9)
     I              GLT10                       GLT(10)
     I              GLT11                       GLT(11)
     I              GLT12                       GLT(12)
     I              GLT13                       GLT(13)
     I              GLL01                       GLL(1)
     I              GLL02                       GLL(2)
     I              GLL03                       GLL(3)
     I              GLL04                       GLL(4)
     I              GLL05                       GLL(5)
     I              GLL06                       GLL(6)
     I              GLL07                       GLL(7)
     I              GLL08                       GLL(8)
     I              GLL09                       GLL(9)
     I              GLL10                       GLL(10)
     I              GLL11                       GLL(11)
     I              GLL12                       GLL(12)
     I              GLL13                       GLL(13)
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     LCO           VCO               2 0
     C                   UNLOCK    FMGLCH
      *
     C     RSTRTA        TAG
     C                   Z-ADD     0             VGL
     C                   Z-ADD     0             VDEPT
     C                   MOVEL     *BLANKS       GCDESC
     C                   MOVEL     *BLANKS       GCLOOK
     C                   Z-ADD     0             GCGLNO
     C                   Z-ADD     0             GCCOMP
     C                   Z-ADD     0             GCATYP
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       202122
     C                   SETOFF                                       239045
     C                   SETOFF                                       169577
     C                   READ      SCRNA                                  90
      *
     C   KM              CALL      'GLC110CL'
     C   KC
     COR KM
     COR KG              GOTO      END
      *
     C     VALPHA        IFGT      *BLANKS
     C     VGL           ANDEQ     *ZEROS
     C                   Z-ADD     VCO           GCCOMP
     C                   MOVEL     VALPHA        GCLOOK
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    GCCOMP
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       GCLOOK
      *
     C     VACT          IFNE      'A'
     C                   MOVEL     GCGLNO        VGL
     C                   MOVE      GCGLNO        VDEPT
     C                   ENDIF
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
     C   10              GOTO      NXTA
     C     VACTOK        TAG
      *
     C     VGL           IFLE      0                                                        K
     C     VALPHA        ANDEQ     *BLANKS                                                  K
     C                   SETON                                        2021
     C   21              GOTO      NXTA
     C                   ENDIF
      *
     C     VGL           IFEQ      0                                                        K
     C     VDEPT         ANDGT     0                                                        K
     C                   SETON                                        2021
     C   21              GOTO      NXTA
     C                   ENDIF
      *
     C                   MOVEL     VDEPT         DEPT              4
     C     VGL           IFGT      0                                                        K
     C     DEPT          ANDEQ     *BLANKS                                                  K
     C                   Z-ADD     0             VDEPT
     C                   ENDIF
      *
     C                   Z-ADD     LCO           GCCOMP
     C                   MOVE      VDEPT         GCGLNO
     C                   MOVEL     VGL           GCGLNO
     C     GKEY          KLIST
     C                   KFLD                    GCCOMP
     C                   KFLD                    GCGLNO
     C     GKEY          CHAIN     FMGLCH                             90
      *
     C  N90VACT          IFEQ      'A'
     C                   SETON                                        2022
     C   22              GOTO      NXTA
     C                   ENDIF
      *
     C   90VACT          IFNE      'A'
     C                   SETON                                        2023
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   MOVEL     VGL           GLNO              8 0
     C                   MOVE      VDEPT         GLNO
     C     BALKEY        KLIST
     C                   KFLD                    VCO
     C                   KFLD                    GLNO
     C     BALKEY        CHAIN     FGLBAL                             95
EFD01C   95              GOTO      NOCHK                                                    NCE
     C  N95GLSTAT        IFEQ      'D'                                                      NCE
     C                   GOTO      NOCHK
     C                   ENDIF
     C                   EXSR      TSTBAL
     C   45              SETON                                        20
     C   45              GOTO      NXTA                                                     LAN
     C     NOCHK         TAG
     C                   ENDIF
      *
      * IF ADD CLEAR B SCREEN FIELDS
      *
     C     VACT          IFEQ      'A'
     C                   MOVE      *BLANKS       GCDESC
     C                   Z-ADD     0             GCATYP
     C                   MOVE      *BLANKS       GCLOOK
     C                   MOVEL     'N'           GCCONF
     C                   END
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        77
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       202122
     C                   SETOFF                                       303234
     C                   SETOFF                                       369899
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRTA
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODEL
     C                   ENDIF
      *
     C   KX              GOTO      NODEL
     C                   GOTO      RSTRTA
      *
     C     NODEL         TAG
      *
     C     GCDESC        IFEQ      *BLANKS
     C                   SETON                                        30
     C   30              GOTO      RSTRTB
     C                   ENDIF
      *
     C     GCDESC        IFNE      ODESC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     GCDESC        ODESC            30
      *
     C     GCATYP        IFEQ      *ZEROS
     C     GCATYP        ORGT      5
     C                   SETON                                        32
     C   32              GOTO      RSTRTB
     C                   ENDIF
      *
     C     GCATYP        IFNE      OATYP
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     GCATYP        OATYP             1 0
      *
     C     GCLOOK        IFEQ      *BLANKS
     C                   SETON                                        34
     C   34              GOTO      RSTRTB
     C                   ENDIF
      *
     C     GCLOOK        IFNE      OLOOK
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     GCLOOK        OLOOK            15
      *
     C     GCCONF        IFNE      'Y'
     C     GCCONF        ANDNE     'N'
     C                   SETON                                        36
     C   36              GOTO      RSTRTB
     C                   ENDIF
      *
     C     GCCONF        IFNE      OCONF
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     GCCONF        OCONF             1
      *
     C  N77CNT           IFGE      1
     C                   SETON                                        98
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   MOVEL     'A'           GCSTAT
     C                   MOVEL     USERID        GCUSER
     C                   Z-ADD     TIMOD         GCTIME
     C                   Z-ADD     TDATE         GCDTLA
      *
     C     VACT          IFEQ      'A'
     C                   WRITE     RMGLCH
     C                   GOTO      END
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RMGLCH
     C                   GOTO      END
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RMGLCH
     C                   GOTO      END
     C                   ENDIF
      *
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KM
     COR KG              SETON                                        LR
      *
      * CHECK ALL 13 GLBAL BUCKETS BEFORE ALLOWING DELETION.
      *
     C     TSTBAL        BEGSR
     C                   XFOOT     GLT           TOTCUR           13 2
     C                   XFOOT     GLL           TOTLST           13 2
     C     TOTCUR        IFNE      0
EFD01C     TOTLST        ORNE      0
EFD01C     GLBALT        ORNE      0
EFD01C     GLBALL        ORNE      0
     C*          TOTLST    ANDNE0
     C*          GLBALT    ANDNE0
     C*          GLBALL    ANDNE0
     C                   SETON                                        45
     C                   GOTO      ENDTST
     C                   ENDIF
     C     ENDTST        ENDSR
      *
