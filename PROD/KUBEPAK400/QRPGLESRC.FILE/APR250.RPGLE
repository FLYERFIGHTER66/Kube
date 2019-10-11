      *--------------------------------------------------------------
      *
      *   COPYRIGHT EFD ENTERPRISES, INC.     1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *****************************************************************
      *PROGRAM NAME-------- APR250
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- RECONCILE A/P CHECKS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  6/28/02 EFD DO NOT DISPLAY CHECKS DATED AFTER STATEMENT DATE.
      *
     FAPR250FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFAPREC    UF   E           K DISK
     FFMVEND    IF   E           K DISK
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
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     LCO           VCO               2 0
     C                   MOVEL     'N'           VRECON
     C                   MOVEL     'N'           ENTCHK
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       102030
     C                   SETOFF                                           77
     C   KC
     COR KG              DO
     C                   MOVE      'X'           LCANCL
     C                   GOTO      ENDP
     C                   ENDDO
      *
     C                   Z-ADD     VDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        VDATEC            7 0
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VRECON        IFNE      'Y'
     C     VRECON        ANDNE     'N'
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     ENTCHK        IFNE      'Y'
     C     ENTCHK        ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VRECON        IFEQ      'N'
     C                   SETON                                        77
     C                   ENDIF
      * ENTER CHECK NUMBER AND AMOUNT
     C     ENTCHK        IFEQ      'Y'
     C                   EXSR      GETCHK
     C   LR              GOTO      ENDP
     C                   GOTO      NXTA
     C                   END
      *
     C     RSTRT         TAG
     C                   EXSR      BLDSFL
     C     NXTSFL        TAG
     C                   EXFMT     RECCTL
     C   KF              GOTO      NXTA
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTSFL
     C   KA              DO
     C                   EXSR      PUTSFL
     C                   GOTO      NXTA
     C                   ENDDO
     C  NKA              GOTO      NXTSFL
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
      ***********
      * BLDSFL
      ***********
     C     BLDSFL        BEGSR
     C                   SETOFF                                       1030
     C     VCO           SETLL     FAPREC
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVEL     ' '           CODE
      *
     C     NXTBLD        TAG
     C                   SETOFF                                       90
     C     VCO           READE     FAPREC                                 90
     C   90              GOTO      ENDBLD
      *
     C   77AKCKRC        IFEQ      'Y'
     C                   GOTO      NXTBLD
     C                   ENDIF
      * NO CHECKS PAST STATEMENT DATE
     C                   Z-ADD     AKCKDT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##CYMD        IFGT      VDATEC
     C                   GOTO      NXTBLD
     C                   ENDIF
      *
     C     AKCKRC        IFEQ      'Y'
     C                   MOVEL     'X'           CODE
     C                   ELSE
     C                   MOVEL     ' '           CODE
     C                   ENDIF
      *
     C     AK$NET        IFEQ      0
     C                   GOTO      NXTBLD
     C                   ENDIF
      *
     C     AKCTYP        IFEQ      '5'
     C     AKCTYP        OREQ      'V'
     C                   GOTO      NXTBLD
     C                   ENDIF
      *
     C                   Z-ADD     AKCHEK        CHECK
     C                   Z-ADD     AKVEND        VEND
     C     AKVEND        CHAIN     FMVEND                             90
     C  N90              MOVEL     VMNAME        NAME
     C                   Z-ADD     AKCKDT        CDATE
     C                   Z-ADD     AK$NET        CAMT
     C                   ADD       1             RECNO
     C     RECNO         IFGT      5000
     C                   GOTO      ENDBLD
     C                   ENDIF
     C                   WRITE     RECSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ENDSR
      *
      ***********
      * CHKSFL
      ***********
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       303199
     C     NXTCHK        TAG
     C                   SETOFF                                       3031
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   ENDIF
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTCHK
      *
     C     CODE          IFEQ      *BLANKS
     C     CHECK         ANDEQ     0
     C                   MOVE      *BLANKS       NAME
     C                   Z-ADD     0             VEND
     C                   Z-ADD     0             CDATE
     C                   Z-ADD     0             CAMT
     C                   GOTO      NXTCHK
     C                   ENDIF
      *
     C     CODE          IFNE      ' '
     C     CODE          ANDNE     'X'
     C                   SETON                                        303199
     C                   ENDIF
      *
     C                   UPDATE    RECSFL
     C                   GOTO      NXTCHK
      *
     C     ENDCHK        TAG
     C                   ENDSR
      ***********
      * PUTSFL
      ***********
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTPUT        TAG
     C                   SETOFF                                       88
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   ENDIF
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTPUT
      *
     C     CODE          IFEQ      'X'
     C                   SETON                                        88
     C                   ENDIF
      *
     C     RECKEY        KLIST
     C                   KFLD                    VCO
     C                   KFLD                    CHECK
     C     RECKEY        CHAIN     FAPREC                             90
     C   88              Z-ADD     VDATE         AKDTRC
     C   88              MOVEL     'Y'           AKCKRC
     C   88              MOVEL     'D'           AKSTAT
     C  N88              Z-ADD     0             AKDTRC
     C  N88              MOVEL     ' '           AKCKRC
     C  N88              MOVEL     'A'           AKSTAT
     C                   UPDATE    RAPREC
      *
     C                   GOTO      NXTPUT
      *
     C     ENDPUT        ENDSR
      ***********
      * GETCHK
      ***********
     C     GETCHK        BEGSR
     C                   SETOFF                                       101120
     C                   SETOFF                                         9899
     C     NXTB          TAG
     C   89              SETOFF                                       88
     C   89
     CAN 20              WRITE     DUMMY
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C                   SETOFF                                       101120
     C                   SETOFF                                         8889
     C                   SETOFF                                       1214
     C   KC
     COR KG              DO
     C                   SETON                                        LR
     C                   GOTO      ENDGET
     C                   ENDDO
     C   KF              GOTO      ENDGET
     C     RECKY         KLIST
     C                   KFLD                    VCO
     C                   KFLD                    CHECK#
     C     RECKY         CHAIN     FAPREC                             10
     C   10              SETON                                        1289      EFD
     C   12              GOTO      NXTB                                         EFD
      *
     C  N10AKCKRC        IFEQ      'Y'
     C                   SETON                                        101489
     C                   GOTO      NXTB
     C                   END
      *
     C  N10AK$NET        IFNE      AMOUNT
     C                   SETON                                        20  89
     C                   GOTO      NXTB
     C                   END
      * MARK CHECK AS RECONCILED
     C                   Z-ADD     VDATE         AKDTRC
     C                   MOVEL     'Y'           AKCKRC
     C                   MOVEL     'D'           AKSTAT
     C                   UPDATE    RAPREC
     C                   Z-ADD     AKCHEK        LSTCHK
     C     AKVEND        CHAIN     FMVEND                             92
     C   92              MOVE      *BLANKS       LSTNAM
     C  N92              MOVEL     VMNAME        LSTNAM
     C                   Z-ADD     AK$NET        LSTAMT                         EFD AMT>NET
     C                   SETON                                        88
     C                   Z-ADD     0             CHECK#
     C                   Z-ADD     0             AMOUNT
     C                   GOTO      NXTB
      *
     C     ENDGET        TAG
     C                   UNLOCK    FAPREC
     C                   ENDSR
      *
