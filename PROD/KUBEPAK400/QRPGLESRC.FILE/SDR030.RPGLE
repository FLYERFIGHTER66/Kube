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
      **PROGRAM NAME-------- SDR030
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- ENTER/UPDATE FIXED COSTS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FSDR030FM  CF   E             WORKSTN
     F                                     SFILE(CSTSFL:RECNO)
     FFMSIZE    IF   E           K DISK
     FFSOWTYP   IF   E           K DISK
     FFTCOST    UF A E           K DISK
     FFOCOST    UF A E           K DISK
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
      * START HERE   *
      ****************
     C     RSTART        TAG
     C                   UNLOCK    FTCOST                                                      ARC38
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       TSOW
     C                   MOVE      '0'           *IN
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              GOTO      END
      ** CKECK SIZE CODE
     C                   SETOFF                                       1020
     C                   MOVEL     SIZE          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       SZCODE
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       SIZE
     C                   MOVEL     SZCODE        SIZE
     C                   GOTO      NXTA
     C                   ENDIF
     C     SIZE          CHAIN     FMSIZE                             10
     C   10              GOTO      NXTA
      ** CHECK SOW TYPE CODE
     C     TSOW          IFEQ      '?'
     C     TSOW          OREQ      '/'
     C                   MOVEL     TSOW          STCODE
     C                   CALL      'LKSOWT'
     C                   PARM                    STCODE
     C                   PARM                    STDESC
     C                   MOVEL     *BLANKS       TSOW
     C                   MOVEL     STCODE        TSOW
     C                   GOTO      NXTA
     C                   ENDIF
     C     TSOW          IFGT      *BLANKS
     C     TSOW          CHAIN     FSOWTYP                            20
     C   20              GOTO      NXTA
     C                   END
      ** BUILD SUB FILE
     C     RSTRTB        TAG
     C                   EXSR      BLDSFL
     C                   SETOFF                                       9899
     C     NXTSFL        TAG
     C                   EXFMT     CSTCTL
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
      ** CHECK ENTRIES
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTSFL
      ** IF NOT 98 SETON AND REDISPLAY
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTSFL
     C                   END
      ** IF NOT F4 REDISPLAY
     C  NKD              GOTO      NXTSFL
      ** UPDATE THE FILE
     C                   EXSR      PUTSFL
     C                   GOTO      RSTART
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             LSTSEQ            3 0
     C                   Z-ADD     0             TOTCST
     C                   SETON                                        80
     C                   WRITE     CSTCTL
     C                   SETOFF                                       80
     C                   SETOFF                                       101120
     C                   SETOFF                                       213031
     C                   SETOFF                                       4041
     C     CSTKEY        KLIST
     C                   KFLD                    ITEM             12
     C                   KFLD                    SIZE
     C                   KFLD                    TSOW
     C                   MOVE      *BLANKS       ITEM
     C                   Eval      TOCOST = 0
WHT  C                   Eval      Weeks = 5                                    |Default Value
     C     CSTKEY        Chain     FOCOST
     C                   Eval      TOTCST = TOCOST * Weeks
     C                   Eval      GERMPCT= TOGERM
     C                   Eval      OVRHDX = TOCOST * Weeks
     C                   Eval      OVRHD  = TOCOST
     C     CSTKEY        SETLL     FTCOST
     C     NXTBLD        TAG
     C     CSTKEY        READE     FTCOST                                 90
     C   90              GOTO      ENDBLD
     C                   MOVE      *BLANKS       STAT
     C                   MOVEL     TCDESC        DESC
     C                   Z-ADD     TCUCST        UCST
     C                   Z-ADD     TCQTY         QTY
     C     TCQTY         MULT(H)   TCUCST        EXTCST
     C                   ADD       EXTCST        TOTCST
     C                   ADD       1             RECNO
     C                   WRITE     CSTSFL
     C                   ADD       TCSEQ#        LSTSEQ
     C                   GOTO      NXTBLD
      ** AT END PUT OUT 50 BLANK RECORDS
     C     ENDBLD        TAG
     C                   Z-ADD     0             TCSEQ#
     C                   MOVE      *BLANKS       STAT
     C                   MOVE      *BLANKS       DESC
     C                   Z-ADD     0             UCST
     C                   Z-ADD     0             QTY
     C                   Z-ADD     0             EXTCST
     C     RECNO         ADD       50            TSTREC            5 0
     C     RECNO         DOUGT     TSTREC
     C                   ADD       1             RECNO
     C                   WRITE     CSTSFL
     C                   ENDDO
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ENDSR
      ***********************
      ** CHECK SUB FILE    **
      ***********************
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             TOTCST
     C                   SETOFF                                       101120
     C                   SETOFF                                       213031
     C                   SETOFF                                       404199
     C                   Eval      OvrHdX = OvrHd * Weeks
     C                   Eval      TotCst = OvrHdX
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     CSTSFL                             90
     C   90              DO
     C                   GOTO      NXTCHK
     C                   ENDDO
     C                   SETOFF                                       112131
     C                   SETOFF                                       41
      ** CHECK STATUS
     C     STAT          IFNE      'D'
     C     STAT          ANDGT     *BLANKS
     C                   SETON                                        101199
     C                   ENDIF
      ** CHECK DESCRIPTION
     C     DESC          IFLE      *BLANKS
     C     QTY           IFGT      0
     C     UCST          ORGT      0
     C                   SETON                                        202199
     C                   END
     C                   END
      ** CHECK QTY
     C     QTY           IFLE      0
     C     DESC          IFGT      *BLANKS
     C     UCST          ORGT      0
     C                   SETON                                        303199
     C                   END
     C                   END
      ** CHECK QTY
     C     UCST          IFLE      0
     C     DESC          IFGT      *BLANKS
     C     QTY           ORGT      0
     C                   SETON                                        404199
     C                   END
     C                   END
     C     QTY           MULT(H)   UCST          EXTCST
     C                   ADD       EXTCST        TOTCST
     C                   UPDATE    CSTSFL
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C                   ENDSR
      ***********************
      **   PUT SUB FILE    **
      ***********************
     C     PUTSFL        BEGSR

     C                   If        TOCOST <> OVRHD
     C                             or TOGERM <> GERMPCT
     C                   Eval      TOCOST = OVRHD
     C                   Eval      TOGERM = GERMPCT
     C                   Eval      TODTLA = tdate
     C                   Eval      TOTIME = timod
     C                   Eval      TOUSER = userid
     C                   If        %Found(FOCOST)
     C                   Update    ROCOST
     C                   Else
     C                   Eval      TOSTAT = 'A'
     C                   Eval      TOITEM = item
     C                   Eval      TOSIZE = size
     C                   Eval      TOWHSE = whse
     C                   Eval      TOSTYP = tsow
     C                   Write     ROCOST
     C                   EndIf
     C                   EndIf

     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             TOTCST
     C                   SETOFF                                       101120
     C                   SETOFF                                       213031
     C                   SETOFF                                       404199
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     CSTSFL                             90
     C   90              DO
     C                   GOTO      NXTPUT
     C                   ENDDO
     C                   SETOFF                                       112131
     C                   SETOFF                                       41
     C     TCKEY         KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C                   KFLD                    TSOW
     C                   KFLD                    WHSE
     C                   KFLD                    TCSEQ#
     C                   MOVE      *BLANKS       WHSE              3
      ** CHECK STATUS
     C     STAT          IFEQ      'D'
     C     TCSEQ#        ANDGT     0
     C     TCKEY         CHAIN     FTCOST                             71
     C  N71              DELETE    RTCOST
     C                   GOTO      NXTPUT
     C                   ENDIF
      ** CHECK IF RECORD NEEDED
     C     DESC          IFLE      *BLANKS
     C     QTY           ORLE      0
     C     UCST          ORLE      0
     C                   GOTO      NXTPUT
     C                   END
      ** IF HERE OUTPUT RECORD
     C     TCSEQ#        IFGT      0
     C     TCKEY         CHAIN     FTCOST                             71
     C                   ELSE
     C                   CLEAR                   RTCOST
     C                   SETON                                        71
     C                   ADD       1             LSTSEQ
     C                   Z-ADD     LSTSEQ        TCSEQ#
     C                   MOVEL     'A'           TCSTAT
     C                   MOVEL     SIZE          TCSIZE
     C                   MOVEL     TSOW          TCSTYP
     C                   END
     C                   MOVEL     DESC          TCDESC
     C                   Z-ADD     QTY           TCQTY
     C                   Z-ADD     UCST          TCUCST
     C                   Z-ADD     TIMOD         TCTIME
     C                   Z-ADD     TDATE         TCDTLA
     C                   MOVEL     USERID        TCUSER
     C   71              WRITE     RTCOST
     C  N71              UPDATE    RTCOST
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
