      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      **PROGRAM NAME-------- CSR020
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- ASSIGN CUSTOMER OPTIONS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCSTOPT  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFCUSOPT   UF A E           K DISK
     FCSR020FM  CF   E             WORKSTN
     F                                     SFILE(CUSSFL:RECNO)
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
     D  LCUST                  1      6  0                                      ARC380
      ** PARMS
     C     *ENTRY        PLIST
     C                   PARM                    CUSTN             6
      ** SEE IF FROM A CALLING PROGRAM
     C                   MOVEL     CUSTN         CUSTNO
     C     CUSTNO        IFGT      000000
     C     CUSTNO        CHAIN     FMCUST                             91
     C   91              GOTO      END
     C                   MOVEL     'Y'           CALLED            1
     C                   GOTO      RSTRTB
     C                   ELSE
     C                   MOVEL     'N'           CALLED
     C                   END
      ** RESTART CLEAR FIELDS
     C     RSTART        TAG
     C                   Z-ADD     0             CUSTNO
     C                   MOVE      *BLANKS       ALPHA
     C                   SETOFF                                       10
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              GOTO      END
     C                   SETOFF                                       10
      ** SEE IF ALPHA
     C     CUSTNO        IFLE      0
     C     ALPHA         ANDGT     *BLANKS
     C                   MOVEL     ALPHA         CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       ALPHA
     C                   Z-ADD     CMCUST        CUSTNO
     C     CUSTNO        IFLE      0
     C                   GOTO      NXTA
     C                   ENDIF
     C                   ENDIF
     C     CUSTNO        IFLE      0
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
     C     CUSTNO        CHAIN     FMCUST                             10
     C   10              GOTO      NXTA
      ** BUILD SUBFILE
     C     RSTRTB        TAG
     C                   EXSR      BLDSFL
     C                   SETOFF                                       9899
     C     NXTFMT        TAG
     C   99              SETOFF                                       98
     C                   EXFMT     CUSCTL
      ** CHECK F KEYS
     C   KF              DO
     C     CALLED        IFEQ      'Y'
     C                   GOTO      END
     C                   ELSE
     C                   GOTO      RSTART
     C                   END
     C                   ENDDO
     C   KC
     COR KG              GOTO      END
      ** CHECK SUBFILE
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTFMT
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTFMT
     C                   ENDDO
     C  NKD              GOTO      NXTFMT
      ** OUTPUT THE RECORDS
     C                   EXSR      PUTSFL
      ** NOW SEE WHERE TO GO
     C     CALLED        IFEQ      'Y'
     C                   GOTO      END
     C                   END
     C                   GOTO      RSTART
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     CUSCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C     CMCUST        SETLL     FCUSOPT
     C     NXTBLD        TAG
     C     CMCUST        READE     FCUSOPT                                90
     C   90              GOTO      ENDBLD
     C     COCODE        CHAIN     FMCSTOPT                           20
     C                   MOVEL     COCODE        CODE
     C                   MOVEL     COALLO        ALLO
     C                   Z-ADD     COBEGD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         FRMDAT
     C                   Z-ADD     COENDD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TODAT
     C                   ADD       1             RECNO
     C                   SETON                                        21
     C                   WRITE     CUSSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C     RECNO         ADD       10            LSTREC            5 0
     C                   MOVE      *BLANKS       CODE
     C                   MOVE      *BLANKS       ALLO
     C                   MOVE      *BLANKS       OPDESC
     C                   MOVE      *BLANKS       ACTN
     C                   Z-ADD     0             FRMDAT
     C                   Z-ADD     0             TODAT
     C                   SETOFF                                       21
     C     RECNO         DOUGT     LSTREC
     C                   ADD       1             RECNO
     C                   WRITE     CUSSFL
     C                   ENDDO
     C                   ENDSR
      ***********************
      ** CHECK SUB FILE    **
      ***********************
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       112226
     C                   SETOFF                                       313233
     C                   SETOFF                                       36  99
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     CUSSFL                             90
     C   90              GOTO      NXTCHK
     C                   SETOFF                                       102025
     C                   SETOFF                                       3035
      ** CHECK ACTION
     C     ACTN          IFNE      ' '
     C     ACTN          ANDNE     'D'
     C                   SETON                                        101199
     C                   END
      ** CHECK CODE
     C                   MOVEL     CODE          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C     9             SUBST     CODE:2        OPDESC
     C                   CALL      'LKCOPT'
     C                   PARM                    OPDESC
     C                   PARM                    OPCODE
     C                   MOVE      *BLANKS       CODE
     C                   MOVEL     OPCODE        CODE
     C                   END
     C     CODE          IFGT      *BLANKS
     C     CODE          CHAIN     FMCSTOPT                           20
     C   20              SETON                                        2299
     C   20              MOVE      *BLANKS       OPDESC
     C                   ELSE
     C                   MOVE      *BLANKS       OPDESC
     C                   MOVE      *BLANKS       ALLO
     C                   Z-ADD     0             FRMDAT
     C                   Z-ADD     0             TODAT
     C                   GOTO      NXTCHK
     C                   END
      ** CHECK ALLOWED
     C     ALLO          IFNE      'Y'
     C     ALLO          ANDNE     'N'
     C                   SETON                                        252699
     C                   END
      ** CHECK FROM DATE
     C     FRMDAT        IFGT      0
     C                   Z-ADD     FRMDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        303199
     C                   END
     C                   Z-ADD     ##CYMD        TSTFRM            7 0
     C                   ELSE
     C                   Z-ADD     0             TSTFRM
     C                   END                                                    FRMDAT > 0
     C     TODAT         IFGT      0
     C                   Z-ADD     TODAT         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        353699
     C                   Z-ADD     9999999       ##CYMD
     C                   END
     C                   Z-ADD     ##CYMD        TSTTO             7 0
     C                   ELSE
     C                   Z-ADD     0             TSTTO
     C                   END                                                    TODAT > 0
      ** SEE IF DATE REQUIRED
     C     OPDATR        IFEQ      'Y'
     C     TSTFRM        ANDLE     0
     C                   SETON                                        303299
     C                   END
     C     OPDATR        IFEQ      'Y'
     C     TSTTO         ANDLE     0
     C                   SETON                                        353299
     C                   END
      ** FROM LESS THAN TO
     C     TSTFRM        IFGT      TSTTO
     C                   SETON                                        303335
     C                   SETON                                        99
     C                   END
      *PROTECT OLD CODE FIELD
     C     COCODE        IFGT      *BLANKS
     C                   SETON                                        21
     C                   ELSE
     C                   SETOFF                                       21
     C                   END
     C                   UPDATE    CUSSFL
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C                   ENDSR
      ***********************
      **   PUT SUB FILE    **
      ***********************
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     CUSSFL                             90
     C   90              GOTO      NXTPUT
     C     CODE          IFLE      *BLANKS
     C                   GOTO      NXTPUT
     C                   END
      ** SEE IF RECORD EXISTS
     C     COCODE        IFGT      *BLANKS
     C     OPTKEY        KLIST
     C                   KFLD                    CMCUST
     C                   KFLD                    COCODE
     C     OPTKEY        CHAIN     FCUSOPT                            57
     C     ACTN          IFEQ      'D'
     C  N57              DELETE    RCUSOPT
     C                   GOTO      NXTPUT
     C                   END
     C  N57              DO
     C                   MOVEL     CMLOOK        COLOOK
     C                   MOVEL     ALLO          COALLO
     C                   MOVEL     'A'           COSTAT
     C                   Z-ADD     TSTFRM        COBEGD
     C                   Z-ADD     TSTTO         COENDD
     C                   UPDATE    RCUSOPT
     C                   GOTO      NXTPUT
     C                   ENDDO
     C                   END                                                    COCODE > " "
     C                   MOVEL     CODE          COCODE
     C     OPTKEY        CHAIN     FCUSOPT                            57
     C                   MOVEL     CMLOOK        COLOOK
     C                   MOVEL     ALLO          COALLO
     C                   MOVEL     'A'           COSTAT
     C                   Z-ADD     TSTFRM        COBEGD
     C                   Z-ADD     TSTTO         COENDD
     C                   Z-ADD     CMCUST        COCUST
     C  N57              UPDATE    RCUSOPT
     C   57              WRITE     RCUSOPT
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
