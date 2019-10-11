    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- SOW550
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CORRECT MISSED BAR CODES FROM SOW LINE.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFBADTR    UF   E           K DISK
     FFTRAY     UF   E           K DISK
     FFSOWSCHJ  UF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFSOWNBY   UF A E           K DISK
     FSOW550FM  CF   E             WORKSTN
     F                                     SFILE(BADSFL:RECNO)
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(5) CTDATA PERRCD(1)              MESSAGES
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
      *
     D  AttTimestamp   S                   Like(SBATTT)
    ?D  StartTag#      S              8S 0
    ?D  EndTag#        S              8S 0
     D  MinusTray      S              4P 0 Inz(-1)                              ?Minus One Tray
     D  PlusTray       S              4P 0 Inz(+1)                              ?Plus One Tray
     D  SowType        S                   Like(SBSOWT)                         ?Sow Type

      *? Function Prototypes
    ?D/COPY QFunctDefn,$SeedSown
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$isHere
      ****************
      * START HERE   *
      ****************
     C     USERID        IFEQ      'LINE01'
     C                   Z-ADD     1             LINE#
WJB  C                   Eval      SowType = 'D'
WJB  C                   Eval      OperType = 'S'
     C                   GOTO      SOWOK
     C                   END
     C     USERID        IFEQ      'LINE02'
     C                   Z-ADD     2             LINE#
WJB  C                   Eval      SowType = 'D'
WJB  C                   Eval      OperType = 'S'
     C                   GOTO      SOWOK
     C                   END
     C     USERID        IFEQ      'LINE03'
     C                   Z-ADD     3             LINE#
WJB  C                   Eval      SowType = 'R'
WJB  C                   Eval      OperType = 'R'
     C                   GOTO      SOWOK
     C                   END
     C     RSTART        TAG
     C                   Z-ADD     0             LINE#
     C                   SETOFF                                       10  99
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   SETOFF                                       101199
      ** CHECK LINE NUMBER
     C     LINE#         IFLT      1
     C     LINE#         ORGT      3
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
     C                   If            not $isHere(TimeCard:'S')                 Drum Sow
     C                             and not $isHere(TimeCard:'R')                 Recip
     C                   SETON                                        11
     C                   GOTO      NXTA
     C                   END
      ** COME HERE IF SOW LINE OK
     C     SOWOK         TAG
      ** SEE IF ERRORS
     C                   Z-ADD     LINE#         LINE              1 0
     C                   Z-ADD     0             NUMERR            7 0
     C                   CALL      'SOW540'
     C                   PARM                    LINE
     C                   PARM                    NUMERR
     C     NUMERR        IFLE      0
     C                   SETON                                        99
     C                   GOTO      NXTA
     C                   END
      ** BUILD SUB FILE
     C                   MOVEA     '0'           *IN
     C     NXTFMT        TAG
     C                   EXSR      BLDSFL
     C     NXEFMT        TAG
     C                   EXFMT     BADCTL
     C                   SETOFF                                       10
      ** CHECK F KEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C     TAG#          IFGT      0
     C                   EXSR      CHKBAR
     C   10              GOTO      NXEFMT
     C                   GOTO      NXTFMT
     C                   END
     C                   EXSR      CHKSFL
     C                   GOTO      NXTFMT
      ** END JOB
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   SETOFF                                       10
     C                   SETON                                        80
     C                   WRITE     BADCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             BTTAG#
     C     BTTAG#        SETLL     FBADTR
     C     NXTBLD        TAG
     C                   READ(N)   FBADTR                                 90
     C   90              GOTO      ENDBLD
     C     BTLIN#        IFNE      LINE#
     C                   GOTO      NXTBLD
     C                   END
     C                   MOVEL     BTITEM        ITEM
     C                   Z-ADD     BTSCYM        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SOWDAT
     C     MINKEY        KLIST
     C                   KFLD                    BTITEM
     C                   KFLD                    BTSIZE
     C     MINKEY        CHAIN     FMINVT                             90
     C                   ADD       1             RECNO
     C                   WRITE     BADSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     0             BTTAG#
     C                   Z-ADD     0             TAG#
     C                   Z-ADD     0             BTJOB#
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       BTSIZE
     C                   Z-ADD     0             SOWDAT
     C                   MOVE      *BLANKS       IMDES1
     C                   MOVEL     MSG(1)        IMDES1
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   WRITE     BADSFL
     C                   ENDSR
      ***********************
      ** CHECK SUB FILE    **
      ***********************
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     BADSFL                             91
     C   91              GOTO      NXTCHK
     C     ACTION        IFEQ      'C'
     C                   Eval      Tag# = BTTAG#
     C                   EXSR      CHKBAR
     C                   Eval      Action = ' '
     C                   END
     C     ACTION        IFEQ      'R'
     C                   CALL      'SOW110CL'
     C                   GOTO      NXTCHK
     C                   END
     C     ACTION        IFEQ      'D'
     C     BTTAG#        CHAIN     FTRAY                              92
     C  N92              DELETE    RTRAY
     C     BTTAG#        CHAIN     FBADTR                             92
     C  N92              DELETE    RBADTR
     C     SOWKEY        KLIST
     C                   KFLD                    BTSCYM
     C                   KFLD                    BTJOB#
     C     SOWKEY        CHAIN     FSOWSCHJ                           92
     C  N92              DO
     C                   SUB       1             SOSOWL
     C                   MOVEL     'A'           SOSTAT
     C                   UPDATE    RSOWSCH
     C                   ENDDO                                                  N92  DO
     C                   END
     C                   GOTO      NXTCHK
     C     ENDCHK        ENDSR
      ***********************
      ** CHECK BAR CODE    **
      ***********************
     C     CHKBAR        BEGSR
     C                   SETOFF                                       10
     C     TAG#          CHAIN     FBADTR                             10
     C  N10              DO
     C     BTLIN#        IFNE      LINE#
     C                   SETON                                        10
     C                   ENDIF                                                  BTLINE#><LIN
     C                   ENDDO                                                  N10 DO
     C   10              GOTO      ENDBAR
      ** IF HERE TAG OK
     C     TAG#          CHAIN     FTRAY                              20
     C                   MOVE      *BLANKS       TRREAS
     C                   MOVEL     'A'           TRSTAT
     C                   MOVEL     USERID        TRUSER
     C                   Z-ADD     TDATE         TRDTLA
     C                   Z-ADD     TIMOD         TRTIME
     C  N20              UPDATE    RTRAY
     C  N10              DELETE    RBADTR
     C     SOWKEY        CHAIN     FSOWSCHJ                           92
     C  N92              DO
     C                   ADD       1             SOSOWQ
     C     SOSOWQ        IFGE      SOSOWT
     C                   MOVEL     'C'           SOSTAT
     C                   ELSE
     C                   MOVEL     'A'           SOSTAT
     C                   END
     C                   UPDATE    RSOWSCH
     C                   ENDDO                                                  N92  DO
WJB   *? Post this tray to Lot Inventory
WJB  C                   Call      'ADDLOTINV'
WJB  C                   Parm      TAG#          STARTTAG#
WJB  C                   Parm      TAG#          ENDTAG#
WJB   *? Write the SownBy record.
WJB ?C     TAG#          Chain     FSOWNBY
WJB   * ? If already sown, take credit away from prior sower.
WJB  C                   If        %Found(FSOWNBY)
WJB ?C                   Call      '#ADDUSRTRY'
WJB ?C                   Parm      SBCARD        EMFILE            9 0
WJB ?C                   Parm                    MINUSTRAY
WJB ?C                   Parm                    OperType          1
WJB ?C                   Parm      SBATTT        AttTimestamp
WJB  C                   EndIf
WJB   * ? Credit Sower for producing flat.
WJB  C                   Eval      EMFILE = TimeCard
WJB  C                   Call      '#EMPFILE#'
WJB  C                   Parm                    TimeCard
WJB  C     EMFILE        Parm                    File#             6 0
WJB  C                   Parm                    name             25
WJB  C                   Time                    AttTimestamp
WJB ?C                   Call      '#ADDUSRTRY'
WJB ?C                   Parm      EMFILE        File#
WJB ?C                   Parm                    PLUSTRAY
WJB ?C                   Parm                    OperType
WJB ?C                   Parm                    AttTimestamp
WJB   * ? Write/Update produced by record.
WJB  C                   Eval      SBTAG# = TAG#
WJB  C                   Eval      SBCARD = EMFILE                               Using File# now !!!
WJB  C                   Eval      SBPROG = 'SOW550'
WJB  C                   Eval      SBUSER = $User()
WJB  C                   Eval      SBTIME = $TimeStamp()
WJB  C                   Time                    SBDATE
WJB  C                   Time                    SBSTIM
WJB  C                   Eval      SBSOWT = SowType
WJB  C                   Eval      SBATTT = AttTimestamp
WJB  C                   If        %Found(FSOWNBY)
WJB ?C                   Update    RSOWNBY
WJB  C                   Else
WJB ?C                   Write     RSOWNBY
WJB  C                   EndIf

      ** END CHECK
     C     ENDBAR        TAG
     C                   UNLOCK    FBADTR
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
WJB  C     *ENTRY        PList
WJB  C                   Parm                    TimeCard          8 0
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
** Message array
     *** End of Date ***                            1
