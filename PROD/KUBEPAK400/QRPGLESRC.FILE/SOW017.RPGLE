    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

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
      **PROGRAM NAME-------- SOW017
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SOWLINE OPERATIONS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  2/16/02 EFD REM OUT CALL TO SOWCLRCL
      *  2/27/02 EFD PUT BACK CALL TO SOWCLRCL
      *
     FSOW017FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     F                                     SFILE(JOBSFL:RECN1)
     FFCALEN    IF   E           K DISK
     F                                     RENAME(RCALEN:CALENI)
     FFCALEX    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFMINVT    UF   E           K DISK
     FFSOWSCHD  IF   E           K DISK
     F                                     RENAME(RSOWSCH:SOWSCD)
     FFSOWSCHJ  UF   E           K DISK
     FFTRAYJDR  UF   E           K DISK
     F                                     RENAME(RTRAYR:TRAYJD)
RPADDFKPITMWHS  UF   E           K DISK
RPADDFKPHIST    O  A E           K DISK
     FFTRAYR    UF   E           K DISK
      *
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(10) CTDATA PERRCD(1)             Messages
      * NEXT JOB NUMBER ARRAY DURING SELECTION
     D REC             S              5  0 DIM(99)                              RECORD NUMBERS
      * NEXT JOB NUMBER ARRAY DURING SOWING
     D JOB             S              4  0 DIM(600)                             JOB NUMBERS
     D QTY             S              6  0 DIM(600)                             QUANTITIES
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
     D  SOWLN                  1      1  0                                      ARC380
     D  LFILE                 11     20
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  RPRTR                134    143

      *? Fields
    ?D FmMenu          S               N   Inz(*Off)                             Overruns from menu?
    ?D ClockedIn       S               N
    ?D TrackTime       S               N
     D  SownByUser     S              9S 0                                      ?Sown By Key
     D  PlusTray       S              4P 0                                      ?Plus Tray
     D  AttTimestamp   S               Z


      *? Function Prototypes
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$isHere
      ******************
      * CHECK FOR USER *
      ******************
     C     USERID        IFNE      'LINE04'
     C     USERID        ANDNE     'JOHNS'
     C     USERID        ANDNE     'DEBBIE'
     C     USERID        ANDNE     'ROBM'
     C     USERID        ANDNE     'RENE'
WJB  C*    USERID        ANDNE     'FRAN'                                       No longer here
WJB  C     USERID        ANDNE     'MIKE'                                       Michael Lopez
     C     USERID        ANDNE     'KELLEIGH'
WJB  C     USERID        ANDNE     'BILLB'                                      ADD BILL BEHR TOO
WJB  C     USERID        ANDNE     'ROBJR'
WJB  C     USERID        ANDNE     'BILL'                                       ADD BILL S. TOO
WJB  C     USERID        ANDNE     'DONNAP'
     C                   WRITE     SCRNE
     C                   READ      SCRNE                                  90
     C                   GOTO      END
     C                   END
WJB  C     USERID        IFEQ      'LINE04'
WJB  C                   MOVE      'L4'          LPRTR
WJB  C                   ENDIF
WJB  C                   IF        %Subst(USERID:1:4) = 'LINE'
WJB  C                   Eval      TrackTime = *On
WJB  C                   EndIF
     C**                   MOVELUSERID    TST6    6
     C**                   MOVE TST6      SOWLIN
     C                   Z-ADD     SOWLN         SOWLIN
     C                   Z-ADD     0             ENDLAB            4 0
     C                   EXSR      CLOCKSR
     C     RSTART        TAG
      * GET SCREEN A
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       102030
     C                   SETOFF                                       215051
     C                   SETOFF                                       404145
     C                   SETOFF                                       48  99
     C                   SETOFF                                       525354
     C   KC
     CANN77              GOTO      END
     C   KC
     CAN 77              DO
     C                   SETON                                        78
     C                   GOTO      NXTA
     C                   ENDDO
      *
      * CHECK FOR SOW DATE
     C     SOWDAT        IFGT      0
     C     SOWDAT        CHAIN     FCALEN                             40
     C   40              DO
     C                   SETON                                        99
     C                   Z-ADD     0             SOWCYM
     C                   Z-ADD     0             YEAR
     C                   Z-ADD     0             WEEK
     C                   GOTO      NXTA
     C                   ENDDO                                                  40 DO
     C     CL#Y          IFNE      1
     C                   SETON                                        404199
     C                   GOTO      NXTA
     C                   END                                                    CL#Y><1
     C                   MOVEL     CLCENT        YEAR
     C                   MOVE      CLYEAR        YEAR
     C                   Z-ADD     CLWEEK        WEEK
     C                   Z-ADD     CLCYMD        SOWCYM
     C                   END                                                    SOWDAT>0
      * SEE IF WEEK NUMBER ENTERED
     C     SOWDAT        IFLE      0
     C     YEAR          ANDGT     0
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
     C                   MOVEL     YEAR          CLCENT
     C                   MOVE      YEAR          CLYEAR
     C                   Z-ADD     WEEK          CLWEEK
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             45
     C   45              DO
     C                   SETON                                        99
     C                   Z-ADD     0             SOWCYM
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        SOWDAT
     C                   Z-ADD     CLCYMD        SOWCYM            7 0
     C                   END                                                    SOWDAT=0
     C                   MOVEL     CLCENT        YEAR
     C                   MOVE      CLYEAR        YEAR
      * CHECK SIZE
     C     SIZE          IFGT      *BLANKS
     C                   MOVEL     SIZE          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       SIZE
     C                   MOVEL     SZCODE        SIZE
     C                   GOTO      NXTA
     C                   ENDIF
     C     SIZE          CHAIN     FMSIZE                             20
     C   20              GOTO      NXTA
     C                   END                                                    SIZE>"  "
      ** SIZE MUST BE ENTERED IF ITEM ENTERED
     C     SIZE          IFLE      *BLANKS
     C     SITEM         ANDGT     *BLANKS
     C                   SETON                                        2022
     C                   GOTO      NXTA
     C                   END
      * CHECK ITEM
     C     SITEM         IFGT      *BLANKS
     C                   MOVEL     SITEM         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     SITEM:2       IMLOOK
     C                   MOVE      *BLANKS       IMWHSE
     C                   MOVEL     SIZE          IMSIZE
     C                   MOVE      *BLANKS       SHPFR
     C                   CALL      'LKITAL'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        SITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   GOTO      NXTA
     C                   ENDIF
     C                   MOVEL     SITEM         SOITEM
     C                   MOVEL     SIZE          SOSIZE
RPCHGC     MINKEY        CHAIN(N)  FMINVT                             21
     C   21              GOTO      NXTA
     C                   ENDIF                                                  SITEM>"  "
      *
     C     SHOALL        IFNE      'O'
     C     SHOALL        ANDNE     'A'
     C                   SETON                                        3099
     C                   GOTO      NXTA
     C                   ENDIF
      * BUILD SUB FILE
     C     RSTRTB        TAG
     C     ENDLAB        IFGT      0
     C                   WRITE     SCRNL
     C                   READ      SCRNL                                  90
     C   KE              DO
     C                   Z-ADD     0             ENDLAB
     C                   GOTO      RSTRTB
     C                   ENDDO                                                  KE  DO
     C                   GOTO      RSTART
     C                   END                                                    ENDLAB>0
     C                   EXSR      BLDSFL
     C     NXTSFL        TAG
     C     PAGE#         IFLE      0
     C     HLDREC        IFGT      0
     C                   Z-ADD     HLDREC        PAGE#
     C                   ELSE
     C                   Z-ADD     1             PAGE#
     C                   ENDIF
     C                   ENDIF
     C                   EXFMT     RECCTL
      ** CHECK F KEYS
     C   KC
     CANN77              GOTO      END
     C   KF              GOTO      RSTART
      ** F2 SHOW DETAIL
     C   KB              DO
     C     LINE          CHAIN     RECSFL                             91
     C   91              GOTO      NXTSFL
     C                   EXSR      DSPDET
     C                   GOTO      NXTSFL
     C                   ENDDO
      ** F5 GET NEW START LINE
     C   KE              DO
     C                   EXSR      GETNEW
     C                   GOTO      NXTSFL
     C                   ENDDO
      ** F07 Fixing Inq.
     C   KG              DO
     C                   Call      'FXG042'
     C                   GOTO      NXTSFL
     C                   ENDDO
      ** F08 Can/ReAct Job
     C   KH              DO
     C                   Call      'SOW300CL'
     C                   GOTO      NXTSFL
     C                   ENDDO
      ** F9 Print "To Sow" Amount
     C   KI              DO
     C     LINE          CHAIN     RECSFL                             91
     C   91              GOTO      NXTSFL
     C                   Eval      SEQ = TOSOW
     C  N91              UPDATE    RECSFL
     C                   GOTO      CHKSFL_TAG
     C                   ENDDO
      ** F10 Print Over-Run Labels
     C   KJ              DO
     C                   Call      'SOW500CL'
     C                   Parm                    FmMenu
     C                   GOTO      NXTSFL
     C                   ENDDO
      ** F11 REPRINT SELECTED
     C   KK              DO
     C                   CALL      'SOW110CL'
     C                   GOTO      NXTSFL
     C                   ENDDO                                                  KK  DO
      ** CHECK FOR NEXT NUMBERS
     C     CHKSFL_TAG    TAG
     C                   EXSR      CHKSFL
      ** SHOW JOB SUBFILE
     C     NXJOBF        TAG
     C                   EXSR      BLDJOB
      ** IF NO RECORDS GO BACK TO RECSFL
     C     RECN1         IFLE      0
     C                   GOTO      RSTRTB
     C                   END
     C*                  EXFMT     JOBCTL
     C                   Write     JOBCTL
      ** CHECK IF JOB CLOSED
     C                   EXSR      CHKJOB
     C     TOTQTY        IFLE      0
     C                   GOTO      RSTRTB
     C                   END
      ** TEMP RETURN
     C                   GOTO      NXJOBF
      *
      *END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     RECCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             PAGE#
     C     SOWCYM        SETLL     FSOWSCHD
     C     SHOALL        IFEQ      'O'
     C                   MOVEL     MSG(1)        SHODES
     C                   ELSE
     C                   MOVEL     MSG(2)        SHODES
     C                   END
     C     NXTBLD        TAG
     C     SOWCYM        READE     FSOWSCHD                               90
     C   90              GOTO      ENDBLD
      ** ONLY SHOW OPEN JOBS
     C     SHOALL        IFEQ      'O'
     C*    SOSTAT        ANDNE     'A'
     C     SOSOWQ        ANDGE     SOSOWT                                        SOWN >= TO SOW
     C                   GOTO      NXTBLD
     C                   END
      ** DON'T SHOW LINE 8
     C     SOLINE        IFEQ      8
     C                   GOTO      NXTBLD
     C                   END
      ** ONLY SELECTED SIZE?
     C     SIZE          IFGT      *BLANKS
     C     SOSIZE        ANDNE     SIZE
     C                   GOTO      NXTBLD
     C                   END
      ** ONLY CUTTINGS
     C     SOTRYC        IFNE      *BLANKS
     C     SOTRYC        andNE     'E'
     C     SOTRYC        andNE     'L'
     C     SOTPSW        ORNE      'R'
     C     SOTPSW        ANDNE     'G'
     C     SOTPSW        ANDNE     'T'
     C                   GOTO      NXTBLD
     C                   END
      ** PROTECT OTHER SOW LINES NOT USED 12/20/01 LEFT FOR FUTURE USE
     C*          SOLINE    IFGT 0
     C*          SOLINE    ANDNESOWLIN
     C*                    GOTO NXTBLD
     C*                    END
      ** GET READY DATE
     C                   Z-ADD     SORDYD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         READYD
      ** GET DESCRIPTION
     C     MINKEY        KLIST
     C                   KFLD                    SOITEM
     C                   KFLD                    SOSIZE
RPCHGC     MINKEY        CHAIN(N)  FMINVT                             88
     C   88              MOVEL     MSG(3)        DESC
     C  N88              MOVEL     IMDES1        DESC
     C                   Z-ADD     SOSCHD        SEQ
     C                   Z-ADD     SOJOB#        JOB#
     C                   MOVEL     SOITEM        ITEM
     C                   Z-ADD     SOORDQ        SOLD
     C                   Z-ADD     SOSOWQ        QSOWN
      ** SEARCH SPECIFIED ???
     C                   If        SEARCH <> *Blanks  and
     C                             %Scan(%Trim(Search):DESC) = 0 and
     C                             %Scan(%Trim(Search):ITEM) = 0
     C                   GOTO      NXTBLD
     C                   END
     C                   If        IMSIZE <> LastSIZE
     C     IMSIZE        Chain     FMSIZE
     C                   Move      SZCODE        LastSIZE          3
     C                   EndIf
     C                   Eval      CUTS = %Int(SZSALE * SOSOWT)
     C                   Eval      TotCUTS = TotCUTS + CUTS
      ** ------------------------
     C     SOSOWT        SUB       QSOWN         TOSOW
     C*    SOSTAT        IFNE      'A'
     C*                  Z-ADD     0             TOSOW
     C*                  END
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C     PAGE#         IFLE      0
      ** START SIZE ONLY
     C     SITEM         IFLE      *BLANKS
     C     IMSIZE        ANDEQ     SIZE
     C                   Z-ADD     RECNO         PAGE#
     C                   ENDIF
      ** START SIZE AND ITEM
     C     SITEM         IFGT      *BLANKS
     C     SITEM         ANDEQ     IMITEM
     C     IMSIZE        ANDEQ     SIZE
     C                   Z-ADD     RECNO         PAGE#
     C                   ENDIF
     C                   ENDIF                                                  PAGE#=0
     C                   GOTO      NXTBLD
      ** END BUILD
     C     ENDBLD        TAG
     C                   Z-ADD     0             JOB#
     C                   Z-ADD     0             SO#SED
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       IMSIZE
     C                   MOVE      *BLANKS       IMALTP
     C                   MOVE      *BLANKS       SOTRYC
     C                   MOVEL     MSG(4)        DESC
     C                   Z-ADD     TotCUTS       CUTS
     C                   Move      *Blanks       IMMSCX
     C                   Z-ADD     0             SOLD
     C                   Z-ADD     0             QSOWN
     C                   Z-ADD     0             READYD
     C                   Z-ADD     0             TOSOW
     C                   Z-ADD     0             SEQ
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   Z-ADD     *Zero         TotCUTS           7 0
      ** SEE IF CANCEL ALLOWED
     C                   XFOOT     QTY           TOTQTY
     C     TOTQTY        IFGT      0
     C                   SETON                                        77
     C                   ELSE
     C                   SETOFF                                       77
     C                   END
     C     LSTREC        IFLT      HLDREC
     C                   Z-ADD     0             HLDREC
     C                   END
     C                   ENDSR
      *
      ***********************
      ** CHECK SUB FILE    **
      ***********************
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             REC                            CLEAR ARRAY
      ** GET THE NEXT JOB NUMBER ARRAY
     C                   Z-ADD     0             J                 4 0
     C     NXTJCK        TAG
     C                   ADD       1             J
     C     JOB(J)        IFLE      0
     C                   Z-ADD     J             JNXT              4 0
     C                   ELSE
     C                   GOTO      NXTJCK
     C                   END
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     RECSFL                             91
     C   91              GOTO      NXTCHK
     C     SEQ           IFLE      0
     C                   GOTO      NXTCHK
     C                   END
     C                   Z-ADD     RECNO         HLDREC            5 0
     C     REC(SEQ)      IFLE      0
     C                   Z-ADD     SEQ           R                 3 0
     C                   GOTO      SEQOK
     C                   END                                                    REC,SEQ=0
     C     NXTCHQ        TAG
     C                   ADD       1             SEQ
     C     SEQ           IFLE      99
     C     REC(SEQ)      IFLE      0
     C                   Z-ADD     SEQ           R
     C                   GOTO      SEQOK
     C                   END                                                    REC,SEQ=0
     C                   GOTO      NXTCHQ
     C                   ELSE
     C                   GOTO      NXTCHK
     C                   END                                                    SEQ<=99
     C     SEQOK         TAG
     C                   Z-ADD     RECNO         REC(R)
WJB  C                   GOTO      NXTCHK
     C     ENDCHK        TAG
      ** END READ SUBFILE
      ** GET NEXT JOBS FROM REC ARRAY
     C                   Z-ADD     0             R
     C     NXTR          TAG
     C                   ADD       1             R
     C     R             IFGT      99
     C                   GOTO      ENDR
     C                   END
     C     REC(R)        IFLE      0
     C                   GOTO      NXTR
     C                   END
      *** IF HERE WE NEED TO PRINT LABELS AND UPDATE
     C     REC(R)        CHAIN     RECSFL                             91
     C     SOJKEY        CHAIN     FSOWSCHJ                           90
      ** CHECK IF OTHER SOW LINE SELECTED
     C*    SOSTAT        IFNE      'A'
     C*    TOSOW         ORLE      0
     C     TOSOW         IFLE      0
     C                   GOTO      NXTR
     C                   END
     C*                  ADD       TOSOW         SOSOWL
     C                   ADD       SEQ           SOSOWL
     C                   Z-ADD     SOWLIN        SOLINE
     C                   Z-ADD     TDATEC        SOASOW
     C                   MOVEL     'S'           SOSTAT
     C                   TIME                    SOTIME
     C                   Z-ADD     TDATE         SODTLA
     C  N90              UPDATE    RSOWSCH
      ** BUILD JOB ARRAY
     C                   Z-ADD     JNXT          J
     C                   Z-ADD     SOJOB#        JOB(J)
     C                   Z-ADD     SEQ           QTY(J)
     C                   ADD       1             JNXT
      ** LABEL PRINT
     C                   Z-ADD     SOJOB#        JOB#              4 0
     C                   CALL      'SOW102CL'
     C                   PARM                    SOWLIN
     C                   PARM                    SOWCYM
     C                   PARM                    JOB#
     C                   PARM      SEQ           PLABELS           4 0
     C                   GOTO      NXTR
     C     ENDR          TAG
     C                   ENDSR
      ***********************
      ** BUILD JOB FILE    **
      ***********************
     C     BLDJOB        BEGSR
     C                   SETON                                        80
     C                   WRITE     JOBCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECN1             5 0
     C                   Z-ADD     0             J
     C     NXTJOB        TAG
     C                   ADD       1             J
     C     J             IFGT      500
     C                   GOTO      ENDJOB
     C                   END
     C     JOB(J)        IFLE      0
     C                   GOTO      NXTJOB
     C                   END
      ** PUT OUT RECORD
     C                   Z-ADD     SOWCYM        SOSOWD
     C                   Z-ADD     JOB(J)        SOJOB#
     C     SOJKEY        CHAIN(N)  FSOWSCHJ                           90
RPCHGC     MINKEY        CHAIN(N)  FMINVT                             90
WJB  C     SOSIZE        CHAIN     FMSIZE                             20
WJB  C                   Z-ADD     IM#SED        JB#SPC                          SEEDS PER CELL
WJB  C                   Z-ADD     SZCELL        JB#CPT                          CELLS PER TRAY
     C                   MOVEL     IMITEM        ITEM
     C                   Z-ADD     QTY(J)        TOSOW
      ** GET READY DATE
     C                   Z-ADD     SORDYD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         READYD
     C                   MOVE      *BLANKS       STAT
     C                   MOVE      'C'           STAT
     C                   ADD       1             RECN1
     C                   WRITE     JOBSFL
     C                   GOTO      NXTJOB
     C     ENDJOB        TAG
     C                   Z-ADD     RECN1         LSTRC1            5 0
     C                   XFOOT     QTY           TOTQTY
     C     TOTQTY        SUB       QTY(1)        TOTQT1            7 0
     C     TOTQT1        IFLE      10
     C     ENDLAB        ANDEQ     0
     C     USERID        ANDNE     'LINE03'
     C                   SETON                                        55
     C                   ELSE
     C                   SETOFF                                       55
     C                   END
     C     TOTQTY        IFGT      0
     C                   SETON                                        77
     C                   ELSE
     C                   SETOFF                                       77
     C                   END
     C                   ENDSR
      ***********************
      ** CHECK JOB SFILE   **
      ***********************
     C     CHKJOB        BEGSR
     C                   SETOFF                                       79
     C                   Z-ADD     0             RECN1
     C                   Z-ADD     0             NUMCOM            5 0
     C                   MOVEL     'C'           OSTAT             1
     C     NXCJOB        TAG
     C                   ADD       1             RECN1
     C     RECN1         IFGT      LSTRC1
     C                   GOTO      ENCJOB
     C                   END
     C     RECN1         CHAIN     JOBSFL                             90
     C   90              GOTO      NXCJOB
     C     STAT          IFNE      'C'
     C                   MOVE      *BLANKS       OSTAT
     C                   GOTO      NXCJOB
     C                   END
     C     STAT          IFEQ      'C'
     C     OSTAT         ANDNE     'C'
     C                   SETON                                        79
     C                   GOTO      NOJOB
     C                   END
     C     SOJKEY        CHAIN     FSOWSCHJ                           90
WJB  C                   If        SOSTAT <> 'C' and TrackTime
     C                   Z-Add     QTY(J)        PLUSTRAY
     C                   Time                    AttTimestamp
WJB ?C*                  Call      '#ADDUSRTRY'
WJB ?C*                  Parm      File#         EMFILE            6 0
WJB ?C*                  Parm                    PLUSTRAY
WJB ?C*                  Parm      'L'           OperType          1
WJB ?C*                  Parm                    AttTimestamp
WJB  C                   EndIf
     C                   ADD       QTY(J)        SOSOWQ
     C                   If        SOSOWQ >= SOSOWT
     C                   MOVEL     'C'           SOSTAT
     C                   EndIf
     C  N90              UPDATE    RSOWSCH
      ** UPDATE BAR CODES
     C                   Z-ADD     0             JOB(J)
     C                   Z-ADD     0             QTY(J)
     C                   ADD       1             NUMCOM
     C                   GOTO      NXCJOB
     C     ENCJOB        TAG
      ** NOW REARRANGE JOB ARRAY
     C                   XFOOT     QTY           TOTQTY
     C     TOTQTY        IFLE      0
     C                   GOTO      NOJOB
     C                   END
     C     NUMCOM        IFNE      0
     C                   Z-ADD     1             TO                4 0
     C                   Z-ADD     2             FR                4 0
     C     NXTT          TAG
     C     JOB(TO)       IFLE      0
     C     NXTFR         TAG
     C     JOB(FR)       IFGT      0
     C                   Z-ADD     JOB(FR)       JOB(TO)
     C                   Z-ADD     QTY(FR)       QTY(TO)
     C                   Z-ADD     0             JOB(FR)
     C                   Z-ADD     0             QTY(FR)
     C                   ELSE
     C                   ADD       1             FR
     C     FR            IFLE      500
     C                   GOTO      NXTFR
     C                   END                                                    FR<500
     C                   END                                                    JOB,FR>0
     C                   END                                                    JOB,TO<=0
     C                   ADD       1             TO
     C                   ADD       1             FR
     C     FR            IFLT      500
     C                   GOTO      NXTT
     C                   END
     C                   END                                                    NUMCOM>0
     C                   XFOOT     QTY           TOTQTY
     C     TOTQTY        SUB       QTY(1)        TOTQT1
     C     TOTQT1        IFLE      10
     C     ENDLAB        ANDEQ     0
     C     USERID        ANDNE     'LINE03'
     C                   SETON                                        55
     C                   ELSE
     C                   SETOFF                                       55
     C                   END
     C     NOJOB         ENDSR
      ***********************
      ** DISPLAY DETAILS   **
      ***********************
     C     DSPDET        BEGSR
     C     SOJKEY        KLIST
     C                   KFLD                    SOSOWD
     C                   KFLD                    SOJOB#
     C     SOJKEY        CHAIN(N)  FSOWSCHJ                           90
RPCHGC     MINKEY        CHAIN(N)  FMINVT                             90
     C     IMSIZE        CHAIN     FMSIZE                             90
     C     IM#SED        MULT      SZCELL        SEDTOT
     C                   MULT      SOSOWT        SEDTOT
     C     SOTRYC        IFEQ      'D'
     C                   MOVEL     'Drum'        SEDER
     C                   END
     C     SOTRYC        IFEQ      'R'
     C                   MOVEL     'Recp'        SEDER
     C                   END
     C                   Z-ADD     0             ACTDAT
     C     SOASOW        IFGT      0
     C                   Z-ADD     SOASOW        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFNE      'Y'
     C                   Z-ADD     ##MDY         ACTDAT
     C                   END
     C                   END
      ** GET STATUS
     C                   MOVE      *BLANKS       STATDS
     C     SOSTAT        IFEQ      'A'
     C                   MOVEL     MSG(5)        STATDS
     C                   END
     C     SOSTAT        IFEQ      'C'
     C                   MOVEL     MSG(6)        STATDS
     C                   END
     C     SOSTAT        IFEQ      'D'
     C                   MOVEL     MSG(7)        STATDS
     C                   END
     C     SOSTAT        IFEQ      'S'
     C                   MOVEL     MSG(8)        STATDS
     C                   END
      ** GET BEG AND END TAG NUMBER.
     C                   Z-ADD     99999999      HIGHNM
     C     TRYJD         SETLL     FTRAYJDR
     C                   Z-ADD     0             FSTTAG
     C                   Z-ADD     0             LSTTAG
     C     NXTTRY        TAG
     C     SOJKEY        READE(N)  FTRAYJDR                               91
     C   91              GOTO      ENDTRY
     C     LSTTAG        IFLE      0
     C                   Z-ADD     TRTAG#        LSTTAG
     C                   END
     C                   Z-ADD     TRTAG#        FSTTAG
     C                   GOTO      NXTTRY
     C     ENDTRY        TAG
     C     SOSOWT        SUB       SOORDQ        FIXERS
     C     SOSOWT        SUB       SOSOWQ        LEFT
     C                   WRITE     SCRND
     C                   READ      SCRND                                  90
     C                   ENDSR
      *
      ***********************
      ** GET CANCEL OPTION **
      ***********************
     C     GETCAN        BEGSR
     C                   Z-ADD     1             RECN1
     C                   Z-ADD     0             OPTION
     C                   Z-ADD     0             BEGTAG
     C                   Z-ADD     0             ENDTAG
     C     RECN1         CHAIN     JOBSFL                             90
     C   90              GOTO      ENDCNC
     C     SOJKEY        CHAIN(N)  FSOWSCHJ                           90
RPCHGC     MINKEY        CHAIN(N)  FMINVT                             90
     C     SOSOWT        SUB       SOORDQ        FIXERS
     C     SOSOWT        SUB       SOSOWQ        LEFT
     C                   EXSR      GETTAG
     C     NXTCNC        TAG
     C                   WRITE     SCRNCN
     C                   READ      SCRNCN                                 90
     C   KF              DO
     C                   Z-ADD     0             OPTION
     C                   GOTO      ENDCNC
     C                   ENDDO                                                  KF  DO
     C                   SETOFF                                       10
     C     OPTION        IFNE      1
     C     OPTION        ANDNE     2
     C                   SETON                                        10
     C                   GOTO      NXTCNC
     C                   END
     C     ENDCNC        ENDSR
      *
      ***********************
      ** CANCEL OPTION ONE **
      ***********************
     C     CAN1          BEGSR
     C                   SETOFF                                       101198
     C                   Z-ADD     0             TAG#
     C     NXTCN1        TAG
     C   10              SETOFF                                       98
     C                   WRITE     SCRNCN1
     C                   READ      SCRNCN1                                90
     C   KF              DO
     C                   Z-ADD     0             OPTION
     C                   GOTO      ENDCN1
     C                   ENDDO
     C                   SETOFF                                       1011
     C     TAG#          IFGT      0
     C     TAG#          IFLT      BEGTAG
     C     TAG#          ORGT      ENDTAG
     C                   SETON                                        10
     C                   GOTO      NXTCN1
     C                   END
     C     TAG#          IFEQ      ENDTAG
     C                   SETON                                        1011
     C                   GOTO      NXTCN1
     C                   END
     C                   END                                                    TAG#>0
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTCN1
     C                   ENDDO                                                  N98  DO
     C  NKJ              GOTO      NXTCN1
      ** IF HERE NEED TO UPDATE RECORDS
      ** DELETE EXISTING TAGS GET TO FIRST DEL TAG
     C     TAG#          IFGT      0
     C     TAG#          ADD       1             BEGTAG
     C                   END
      ** IF TAG# = 0 DELETE ALL
     C                   EXSR      DELTAG
      ** UPDATE JOB FILE
     C     SOJKEY        CHAIN     FSOWSCHJ                           90
     C                   MOVEL     'A'           SOSTAT
     C                   SUB       NUMDEL        SOSOWL
     C     QTY(1)        SUB       NUMDEL        OKTAGS            6 0
     C     OKTAGS        IFGT      0
     C                   ADD       OKTAGS        SOSOWQ
     C                   END
     C  N90              UPDATE    RSOWSCH
      ** GET RID OF UNWAQNTED LABELS
     C                   WRITE     SCRNCLR1
     C                   READ      SCRNCLR1                               90
      ** CLEAR JOB,1 ALREADY DONE
     C                   Z-ADD     0             JOB(1)
     C                   Z-ADD     0             QTY(1)
     C                   Z-ADD     2             J
      ** NOW MOVE ALL JOBS UP
     C                   Z-ADD     1             TO                4 0
     C                   Z-ADD     2             FR                4 0
     C     NXCNT         TAG
     C     JOB(TO)       IFLE      0
     C     NXCNF         TAG
     C     JOB(FR)       IFGT      0
     C                   Z-ADD     JOB(FR)       JOB(TO)
     C                   Z-ADD     QTY(FR)       QTY(TO)
     C                   Z-ADD     0             JOB(FR)
     C                   Z-ADD     0             QTY(FR)
     C                   ELSE
     C                   ADD       1             FR
     C     FR            IFLE      500
     C                   GOTO      NXCNF
     C                   END                                                    FR<500
     C                   END                                                    JOB,FR>0
     C                   END                                                    JOB,TO<=0
     C                   ADD       1             TO
     C                   ADD       1             FR
     C     FR            IFLT      500
     C                   GOTO      NXCNT
     C                   END
     C     ENDCN1        ENDSR
      *
      ***********************
      ** CANCEL OPTION TWO **
      ***********************
     C     CAN2          BEGSR
     C                   SETOFF                                       101198
     C                   Z-ADD     0             TAG#
     C     NXTCN2        TAG
     C   10              SETOFF                                       98
     C                   WRITE     SCRNCN2
     C                   READ      SCRNCN2                                90
     C   KF              DO
     C                   Z-ADD     0             OPTION
     C                   GOTO      ENDCN2
     C                   ENDDO
     C                   SETOFF                                       1011
     C     TAG#          IFGT      0
     C     TAG#          IFLT      BEGTAG
     C     TAG#          ORGT      ENDTAG
     C                   SETON                                        10
     C                   GOTO      NXTCN2
     C                   END
     C     TAG#          IFEQ      ENDTAG
     C                   SETON                                        1011
     C                   GOTO      NXTCN2
     C                   END
     C                   END                                                    TAG#>0
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTCN2
     C                   ENDDO                                                  N98  DO
     C  NKJ              GOTO      NXTCN2
      ** IF HERE NEED TO UPDATE RECORDS
      ** DELETE EXISTING TAGS GET TO FIRST DEL TAG
     C     TAG#          IFGT      0
     C     TAG#          ADD       1             BEGTAG
     C                   END
      ** IF TAG# = 0 DELETE ALL
     C                   EXSR      DELTAG
      ** UPDATE JOB FILE
     C     SOJKEY        CHAIN     FSOWSCHJ                           90
     C                   MOVEL     'A'           SOSTAT
     C                   SUB       NUMDEL        SOSOWL
     C     QTY(1)        SUB       NUMDEL        OKTAGS            6 0
     C     OKTAGS        IFGT      0
     C                   ADD       OKTAGS        SOSOWQ
     C                   END
     C  N90              UPDATE    RSOWSCH
      ** CLEAR THE OUTQ
     C                   CALL      'SOWCLRCL'
      ** GET PRINTER TURNED OFF
     C                   WRITE     SCRNCLR
     C                   READ      SCRNCLR                                90
      ** CLEAR JOB,1 ALREADY DONE
     C                   Z-ADD     0             JOB(1)
     C                   Z-ADD     0             QTY(1)
     C                   Z-ADD     2             J
      ** GET REST OF JOBS JOB,1 ALREADY DONE
     C     NXCN2J        TAG
     C     JOB(J)        IFGT      0
     C                   Z-ADD     JOB(J)        SOJOB#
     C                   Z-ADD     QTY(J)        LEFT
     C                   EXSR      GETTAG
     C                   EXSR      DELTAG
      ** UPDATE RECORD
     C                   Z-ADD     JOB(J)        SOJOB#
     C     SOJKEY        CHAIN     FSOWSCHJ                           90
     C                   MOVEL     'A'           SOSTAT
     C                   SUB       NUMDEL        SOSOWL
     C  N90              UPDATE    RSOWSCH
     C                   ADD       1             J
     C     J             IFLE      600
     C                   GOTO      NXCN2J
     C                   END                                                    J<=600
     C                   END                                                    JOB,J>0000
      ** CLEAR ALL SELECTED JOBS
     C                   Z-ADD     0             JOB
     C                   Z-ADD     0             QTY
     C     ENDCN2        ENDSR
      *
      ***********************
      ** DELETE TAGS SUBR  **
      ***********************
     C     DELTAG        BEGSR
      ** 02/01/02 DO NOT DELETE ONLY MARK WITH D
     C                   Z-ADD     0             NUMDEL            6 0
     C     BEGTAG        SETLL     FTRAYR
     C     NXTDEL        TAG
     C                   READ      FTRAYR                                 90
     C   90              GOTO      ENDDEL
     C     TRTAG#        IFLE      ENDTAG
     C                   MOVEL     'D'           TRSTAT
     C                   MOVEL     'SLC'         TRREAS
     C                   UPDATE    RTRAYR
     C                   ADD       1             NUMDEL
     C                   GOTO      NXTDEL
     C                   END
     C                   UNLOCK    FTRAYR
     C     ENDDEL        ENDSR
      *
      ***********************
      ** GET NEW START LINE *
      ***********************
     C     GETNEW        BEGSR
     C                   SETOFF                                       2021
     C                   Z-ADD     0             PAGE#
      * GET SCREEN A
     C     NXTNEW        TAG
     C                   WRITE     SCRNAR
     C                   READ      SCRNAR                                 90
     C                   SETOFF                                       202122
     C   KF              GOTO      ENDNW1
      * CHECK SIZE
     C     SIZE          IFGT      *BLANKS
     C                   MOVEL     SIZE          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       SIZE
     C                   MOVEL     SZCODE        SIZE
     C                   GOTO      NXTNEW
     C                   ENDIF
     C     SIZE          CHAIN     FMSIZE                             20
     C   20              GOTO      NXTNEW
     C                   END                                                    SIZE>"  "
      ** SIZE MUST BE ENTERED IF ITEM ENTERED
     C     SIZE          IFLE      *BLANKS
     C     SITEM         ANDGT     *BLANKS
     C                   SETON                                        2022
     C                   GOTO      NXTNEW
     C                   END
      * CHECK ITEM
     C     SITEM         IFGT      *BLANKS
     C                   MOVEL     SITEM         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     SITEM:2       IMLOOK
     C                   MOVE      *BLANKS       IMWHSE
     C                   MOVEL     SIZE          IMSIZE
     C                   MOVE      *BLANKS       SHPFR
     C                   CALL      'LKITAL'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        SITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   GOTO      NXTNEW
     C                   ENDIF
     C                   MOVEL     SITEM         SOITEM
     C                   MOVEL     SIZE          SOSIZE
RPCHGC     MINKEY        CHAIN(N)  FMINVT                             21
     C   21              GOTO      NXTNEW
     C                   ENDIF                                                  SITEM>"  "
      ** NOW GET RECORD NUMBER TO START SCREEN
      ** START SIZE ONLY
     C                   Z-ADD     0             RECNO
     C     NXTNW1        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDNW1
     C                   END
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTNW1
     C     SITEM         IFLE      *BLANKS
     C     IMSIZE        ANDEQ     SIZE
     C                   Z-ADD     RECNO         PAGE#
     C                   GOTO      ENDNW1
     C                   ENDIF
      ** START SIZE AND ITEM
     C                   MOVEL     ITEM          IMITEM
     C     SITEM         IFGT      *BLANKS
     C     SITEM         ANDEQ     IMITEM
     C     IMSIZE        ANDEQ     SIZE
     C                   Z-ADD     RECNO         PAGE#
     C                   GOTO      ENDNW1
     C                   ENDIF
     C                   GOTO      NXTNW1
     C     ENDNW1        ENDSR
      *
      ***********************
      ** GET TAGS          **
      ***********************
     C     GETTAG        BEGSR
     C     TRYJD         KLIST
     C                   KFLD                    SOSOWD
     C                   KFLD                    SOJOB#
     C                   KFLD                    HIGHNM
     C                   Z-ADD     99999999      HIGHNM            8 0
     C                   Z-ADD     0             LEFTTS            6 0
     C                   Z-ADD     0             NXTTAG
     C                   Z-ADD     0             BEGTAG
     C                   Z-ADD     0             ENDTAG
      ** GET BEGINING AND ENDING TAG NUMBERS
     C     TRYJD         SETLL     FTRAYJDR
     C                   Z-ADD     0             NXTTAG
     C     NXTGTG        TAG
     C     SOJKEY        READE(N)  FTRAYJDR                               90
     C  N90              DO
      ** CAN NOT BE MORE THAN 1 LESS THAN PREVIOUS OR WAS ANOTHER RUN
     C     TRTAG#        IFNE      NXTTAG
     C     NXTTAG        ANDNE     0
     C                   GOTO      ENDTG
     C                   END
     C     ENDTAG        IFLE      0
     C                   Z-ADD     TRTAG#        ENDTAG
     C                   END
     C                   Z-ADD     TRTAG#        BEGTAG
     C                   ADD       1             LEFTTS
      ** ONLY GET QTY SCHEDULED
     C     LEFTTS        IFGE      LEFT
     C                   GOTO      ENDTG
     C                   END
     C     TRTAG#        SUB       1             NXTTAG            8 0
     C                   GOTO      NXTGTG
     C                   ENDDO                                                  N90  DO
     C     ENDTG         ENDSR
      *
      ***********************
      ** CLOCK IN ROUTINE  **
      ***********************
     C     CLOCKSR       BEGSR
     C                   If        TrackTime
     C                   Eval      *In57 = *Off
     C                   Eval      ClockedIn = $isHere(TimeCard:'L')

     C                   DoU       ClockedIn or *In03

     C                   WRITE     SCRNA
     C                   EXFMT     CLOCKIN
     C                   Call      '#EMPFILE#'
     C                   Parm                    TimeCard
     C                   Parm                    File#             6 0
     C                   Parm                    name             25

     C                   Select

     C                   When      *In03
     C                   Eval      *InLR = *On

     C                   When      TimeCard = 0
     C*                  Do Nothing

     C                   When      not ClockedIn and not *In57
     C                   Eval      *In57 = *On

     C                   When      *In01
     C                   If        File# <> 0
     C                   Call      '#ATTEND'
     C                   Parm                    File#
     C                   Parm      'I'           NewStat           1
     C                   Parm      'L'           NewType           1
     C                   EndIf

     C                   EndSL

     C                   Eval      ClockedIn = $isHere(TimeCard:'L')

     C                   EndDo

     C   LR              Return

     C                   EndIf
     C                   ENDSR
      *
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
     C                   Z-ADD     ##CYMD        TDATEC            7 0
     C     TDATE         CHAIN     FCALEN                             40
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             45
     C                   Z-ADD     CLDATE        SOWDAT
     C                   MOVE      *BLANKS       SIZE
     C                   MOVEL     'O'           SHOALL
RPADDC     INVKEY        KLIST
RPADDC                   KFLD                    INITEM
RPADDC                   KFLD                    INSIZE
RPADDC                   KFLD                    INWHSE
RPADDC     WHSKEY        KLIST
RPADDC                   KFLD                    INITEM
RPADDC                   KFLD                    INSIZE
RPADDC                   KFLD                    KPWHSE
RPADDC*                    MOVEL'I'       DHTYPE
WBCHGC                   MOVEL     'ISSUE'       DHTYPE
RPADDC                   MOVE      '01'          DHFWHS
RPADDC                   Z-ADD     0             DHTWHS
RPADDC     SOWDAT        MULT      10000.01      DHYMD             6 0
RPADDC                   Z-ADD     DHYMD         DHCYMD
RPADDC                   MOVEL     20            DHCYMD
RPADDC                   MOVE      'SED'         DHPSIZ
RPADDC                   MOVEL     USERID        DHUSER
     C                   ENDSR
RPADD ***********************************
RPADD ** UPDATE INVTENTORY QTY ON HAND **
RPADD ***********************************
RPADDC     UPDINV        BEGSR
RPADDC                   MOVE      'SED'         INSIZE            3
RPADDC                   MOVE      '   '         INWHSE            3
RPADDC                   Z-ADD     1             KPWHSE            2 0
RPADDC                   MOVEL     SOITEM        INITEM           12
RPADDC     INVKEY        CHAIN     FMINVT                             99
RPADDC     *IN99         IFEQ      *OFF
RPADDC** insert new calcs here to reduce inventory
WBADDC                   Z-ADD     QTY(J)        TRAYS             5 0
WBADDC     TRAYS         MULT      JB#CPT        CELLS             6 0
WBADDC     IMMULT        DIV       100           FACTOR            7 6
WBADDC                   ADD       1             FACTOR
WBADDC     CELLS         MULT      JB#SPC        SEEDS             9 0
WBADDC                   MULT      FACTOR        SEEDS             9 0
RPADDC*                    SUB  QTY,J     IMQTOH
WBCHGC                   SUB       SEEDS         IMQTOH
RPADDC*                    ADD  QTY,J     IMISSU
WBCHGC                   ADD       SEEDS         IMISSU
RPADDC                   UPDATE    RMINVT
RPADDC                   ENDIF
RPADDC     WHSKEY        CHAIN     KPITMWHS                           98
RPADDC     *IN98         IFEQ      *OFF
RPADDC*                    SUB  QTY,J     IWQTOH
WBCHGC                   SUB       SEEDS         IWQTOH
RPADDC                   UPDATE    ITMWHSR
RPADDC                   MOVEL     INITEM        DHPITM
RPADDC*                    Z-ADDQTY,J     DHTQTY
WBCHGC                   Z-ADD     SEEDS         DHTQTY
RPADDC                   WRITE     DGHISTR
RPADDC                   ENDIF
     C                   ENDSR
** MESSAGES
Only Open Jobs                              1
All Jobs Open/Sown                          2
Unknown Item                                3
  *** End of Data ***                       4
Open                                        5
Complete                                    6
Deleted                                     7
Scheduled                                   8
