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
      *PROGRAM NAME-------- GLR210
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- REVERSING JOURNAL ENTRIES
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FGLR210FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFGLREV    UF A E           K DISK
     FFMGLCH    IF   E           K DISK
     FFGLCTL    UF   E           K DISK
     FFMAPER    IF   E           K DISK
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
      *
     C     RSTART        TAG
     C                   SETOFF                                       11
     C                   SETOFF                                       313233
     C                   SETOFF                                       409899
     C                   Z-ADD     TDATE         ACDT
     C                   Z-ADD     0             JENM
     C                   Z-ADD     0             JENMO             6 0
     C                   MOVEL     *BLANKS       JEPR
     C                   MOVEL     *BLANKS       JEPRO             2
     C                   MOVE      'RV'          JESF
     C                   MOVE      'RV'          JESFO             2
     C                   MOVE      *BLANKS       JEDS
     C                   MOVE      '0'           *IN
      *
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   SETOFF                                       103025
     C                   SETOFF                                       202122
     C                   SETOFF                                       404142
     C                   SETOFF                                       99
     C                   READ      SCRNA                                  90
      * FUNCTION KEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
      *
      * ACTION CODE
      *
     C     ACTION        IFNE      'A'
     C     ACTION        ANDNE     'C'
     C     ACTION        ANDNE     'D'
     C                   SETON                                        10  99
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * JOURNAL NUMBER
     C     JENM          IFLE      0
     C                   SETON                                        20  99
     C                   GOTO      NXTA
     C                   END
      *
     C     GWRKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    JEPR
     C                   KFLD                    JENM
     C                   KFLD                    JESF
     C     JEPR          IFNE      JEPRO
     C     JENM          ORNE      JENMO
     C     JESF          ORNE      JESFO
     C     GWRKEY        CHAIN     FGLREV                             77
      *
     C     GWPOST        IFEQ      'Y'
     C                   SETON                                        77
     C                   ENDIF
      *
     C   77ACTION        IFNE      'A'
     C                   SETON                                        202199
     C                   GOTO      NXTA
     C                   END
      *
     C  N77ACTION        IFEQ      'A'
     C                   SETON                                        202299
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     JENM          JENMO
     C                   MOVEL     JEPR          JEPRO
     C                   MOVEL     JESF          JESFO
     C  N77              DO
     C                   MOVEL     GWJEDS        JEDS
     C                   Z-ADD     GWACDT        ACDT
     C                   ENDDO
     C                   END
      *
      * DESCRIPTION
      *
     C     JEDS          IFLE      *BLANKS
     C                   SETON                                        30  99
     C                   GOTO      NXTA
     C                   END
      *
      * ACCOUNTING PERIOD DATE
      *
     C     ACDT          IFLE      0
     C                   SETON                                        40  99
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     ACDT          ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        40  99
     C                   GOTO      NXTA
     C                   END
     C     ##CYMD        IFLT      TSTBEG
     C                   SETON                                        404299
     C                   GOTO      NXTA
     C                   END
     C     ##CYMD        IFGT      TSTEND
     C                   SETON                                        414099
     C                   GOTO      NXTA
     C                   END
      *
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   END
      *
     C                   Z-ADD     ACDT          TRNDAT            6 0
     C                   Z-ADD     LCO           CONO              2 0
     C                   Z-ADD     0             ACTPER            2 0
     C                   Z-ADD     0             BEGDAT            6 0
     C                   Z-ADD     0             ENDDAT            6 0
     C                   Z-ADD     0             BGCYMD            7 0
     C                   Z-ADD     0             ENCYMD            7 0
     C                   Z-ADD     0             ERR               1 0
     C                   CALL      'GETAPER'
     C                   PARM                    CONO
     C                   PARM                    ACTPER
     C                   PARM                    BEGDAT
     C                   PARM                    ENDDAT
     C                   PARM                    BGCYMD
     C                   PARM                    ENCYMD
     C                   PARM                    TRNDAT
     C                   PARM                    ERR
      *
     C                   EXSR      BLDSFL
      *
      * DISPLAY SUB FILE
      *
     C     NXTSFL        TAG
     C   99              SETOFF                                       98
     C                   EXFMT     RECCTL
      * F KEYS
     C   KF              GOTO      RSTART
     C   KB              DO
     C                   EXSR      GETGL
     C                   SETOFF                                       11
     C                   SETOFF                                       313233
     C                   SETOFF                                       40  99
     C                   GOTO      NXTSFL
     C                   ENDDO
     C   KE              DO
     C                   EXSR      BLDMOR
     C                   GOTO      NXTSFL
     C                   ENDDO
      ** ACCEPT IF OUT OF BALANCE ONLY
     C   KK              DO
     C                   EXSR      PUTSFL
     C                   GOTO      RSTART
     C                   ENDDO
      ** CHECK FOR ZERO BALANCE
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTSFL
     C   KA              DO
     C                   EXSR      PUTSFL
     C                   GOTO      RSTART
     C                   ENDDO
     C                   GOTO      NXTSFL
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** GET G/L NUMBER    **
      ***********************
     C     GETGL         BEGSR
     C     LINE          CHAIN     RECSFL                             90
     C   90              GOTO      ENDGET
     C                   Z-ADD     LCO           GCCOMP
     C                   MOVE      *BLANKS       GCLOOK
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    GCCOMP
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   MOVEL     *BLANKS       GCLOOK
     C     GCGLNO        IFLE      0
     C                   GOTO      ENDGET
     C                   END
     C     GLKEY         KLIST
     C                   KFLD                    GCCOMP
     C                   KFLD                    GCGLNO
     C     GLKEY         CHAIN     FMGLCH                             90
     C   90              GOTO      ENDGET
     C                   Z-ADD     GCGLNO        GLNO
     C                   MOVEL     GCDESC        DESC
     C                   UPDATE    RECSFL
     C     ENDGET        TAG
     C                   ENDSR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     RECCTL
     C                   SETOFF                                       80  98
     C                   SETOFF                                       103099
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             TOTDEB
     C                   Z-ADD     0             TOTCRD
     C                   Z-ADD     0             TOTBAL
     C                   Z-ADD     0             GWSEQ#
     C     GWRKEY        SETLL     FGLREV
     C     NXTBLD        TAG
     C     GWRKEY        READE     FGLREV                                 90
     C   90              GOTO      ENDBLD
     C     GWPOST        IFEQ      'Y'
     C                   GOTO      NXTBLD
     C                   ENDIF
     C                   Z-ADD     GWGLAC        GLNO
     C     GW$AMT        IFGE      0
     C                   Z-ADD     GW$AMT        DEBIT
     C                   Z-ADD     0             CREDIT
     C                   ELSE
     C                   Z-SUB     GW$AMT        CREDIT
     C                   Z-ADD     0             DEBIT
     C                   END
     C                   ADD       DEBIT         TOTDEB
     C                   ADD       CREDIT        TOTCRD
     C                   MOVEL     GWDDES        DESC
     C                   ADD       1             RECNO
     C     GLBKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GLNO
     C     GLBKEY        CHAIN     FMGLCH                             90
     C                   MOVEL     GCDESC        ODESC
     C                   WRITE     RECSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     GWSEQ#        LSTSEQ            3 0
     C     RECNO         ADD       50            TSTREC            5 0
     C                   Z-ADD     0             DEBIT
     C                   Z-ADD     0             CREDIT
     C                   Z-ADD     0             GLNO
     C                   Z-ADD     0             GWSEQ#
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       ODESC
     C     NXTBD1        TAG
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C     RECNO         IFLT      TSTREC
     C                   GOTO      NXTBD1
     C                   END
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ENDSR
      ***********************
      ** BUILD MORE RECS   **
      ***********************
     C     BLDMOR        BEGSR
     C     LSTREC        ADD       50            TSTREC            5 0
     C                   Z-ADD     0             DEBIT
     C                   Z-ADD     0             CREDIT
     C                   Z-ADD     0             GLNO
     C                   Z-ADD     0             GWSEQ#
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       ODESC
     C     NXTMOR        TAG
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C     RECNO         IFLT      TSTREC
     C                   GOTO      NXTMOR
     C                   END
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ENDSR
      ***********************
      ** CHECK SUB FILE    **
      ***********************
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             TOTDEB
     C                   Z-ADD     0             TOTCRD
     C                   Z-ADD     0             TOTBAL
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       11
     C                   SETOFF                                       313233
     C                   SETOFF                                       40  99
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTCHK
     C                   SETOFF                                       1030
     C     GLNO          IFLE      0
     C                   Z-ADD     0             DEBIT
     C                   Z-ADD     0             CREDIT
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       ODESC
     C                   GOTO      NCGL
     C                   END
     C     GLCKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GLNO
     C     GLCKEY        CHAIN     FMGLCH                             90
     C   90              SETON                                        101199
     C   90              MOVE      *BLANKS       GCDESC
     C     DEBIT         IFNE      0
     C     CREDIT        ANDNE     0
     C                   SETON                                        303299
     C                   END
     C     DEBIT         IFEQ      0
     C     CREDIT        ANDEQ     0
     C                   SETON                                        303199
     C                   END
     C     DEBIT         IFLT      0
     C     CREDIT        ORLT      0
     C                   SETON                                        303399
     C                   END
     C     DESC          IFEQ      ODESC
     C                   MOVEL     GCDESC        DESC
     C                   MOVEL     GCDESC        ODESC
     C                   END
     C                   ADD       DEBIT         TOTDEB
     C                   ADD       CREDIT        TOTCRD
      ** NO GL NUMBER ENTERED
     C     NCGL          TAG
     C                   UPDATE    RECSFL
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C     TOTDEB        SUB       TOTCRD        TOTBAL
     C     TOTBAL        IFNE      0
     C                   SETON                                        4099
     C                   END
     C  N99              SETON                                        98
     C                   ENDSR
      **********************
      **  PUT SUB FILE    **
      **********************
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTPUT
     C                   SETOFF                                       1030
     C     GWRKYD        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    JEPRO
     C                   KFLD                    JENMO
     C                   KFLD                    JESFO
     C                   KFLD                    GWSEQ#
     C     GWRKYD        CHAIN     FGLREV                             88
     C     GLNO          IFLE      0
     C     GWSEQ#        IFGT      0
     C  N88              DELETE    RGLREV
     C                   END                                                    GWSEQ#>0
     C                   GOTO      NXTPUT
     C                   END                                                    GLNO=0
      * IF HERE GOOD RECORD
     C     GWSEQ#        IFLE      0
     C                   ADD       1             LSTSEQ
     C                   Z-ADD     LSTSEQ        GWSEQ#
     C                   END
     C     DEBIT         IFGT      0
     C                   Z-ADD     DEBIT         GW$AMT
     C                   ELSE
     C                   Z-SUB     CREDIT        GW$AMT
     C                   END
     C                   Z-ADD     LCO           GWCOMP
     C                   MOVEL     JEPR          GWJEPR
     C                   Z-ADD     JENM          GWJENM
     C                   MOVEL     JESF          GWJESF
     C                   MOVEL     JEDS          GWJEDS
     C                   Z-ADD     ACDT          GWACDT
     C                   MOVEL     DESC          GWDDES
     C                   MOVEL     'A'           GWSTAT
     C                   Z-ADD     TDATE         GWJEDT
     C                   Z-ADD     GLNO          GWGLAC
     C                   MOVE      *BLANKS       GWJETP
     C                   MOVE      *BLANKS       GWSHFR
     C                   MOVE      *BLANKS       GWPOST
     C                   Z-ADD     ACTPER        GWPERD
     C                   MOVEL     'J/E'         GWSRCE
     C                   Z-ADD     TDATE         GWDTLA
     C                   Z-ADD     TIMOD         GWTIME
     C                   MOVEL     USERID        GWUSER
     C  N88              UPDATE    RGLREV
     C   88              WRITE     RGLREV
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
      *
     C     LCO           CHAIN     FGLCTL                             91
     C                   MOVEL     'N'           GZOKRV
     C  N90              UPDATE    RGLCTL
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
     C     LCO           CHAIN(N)  FGLCTL                             90
     C     LCO           CHAIN(N)  FMAPER                             90
     C                   Z-ADD     ACFSST        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        TSTBEG            7 0
     C     ACMPCN        IFEQ      'M'
     C                   Z-ADD     ACEN12        ##MDY
     C                   END
     C     ACEN13        IFGT      0
     C                   Z-ADD     ACEN13        ##MDY
     C                   ELSE
     C                   Z-ADD     ACEN12        ##MDY
     C                   END
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        TSTEND            7 0
      *
     C                   ENDSR
