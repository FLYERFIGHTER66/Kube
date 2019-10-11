     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
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
      **PROGRAM NAME-------- SOW500
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT UNSCHEDULED LABELS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FSOW500FM  CF   E             WORKSTN
     FFTRAY     IF   E           K DISK
     FFTRAYR    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCALEN    IF   E           K DISK
     FFJOBNM    UF   E           K DISK
     FFSOWSCH   O  A E           K DISK
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
     D  SOWLIN               144    144  0
     D  SOWCYM               145    151  0
     D  JOB#                 152    155  0
     D  FmMenu               156    156N

      *? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date

      *****************
      ** START HERE  **
      *****************
WJB  C                   If        FmMenu
WJB  C                   Eval      *In40 = *Off
WJB  C                   Else
WJB  C                   Eval      *In40 = *On
WJB  C                   EndIf
     C     RSTART        TAG
     C                   SETOFF                                       101112
     C                   SETOFF                                       203013
     C                   Eval      CopyTag = *Zero
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
WJB  C                   Eval      *In13 = *Off
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
     C                   SETOFF                                       101112
     C                   SETOFF                                       2030
WJB  C   KH              DO
WJB  C                   If        *In40
WJB  C                   Eval      *In40 = *Off
WJB  C                   Else
WJB  C                   Eval      *In40 = *On
WJB  C                   EndIf
WJB  C                   GOTO      RSTART
WJB  C                   EndDo
WJB  C                   If        *In40                                         Copy Tag !!!
WJB  C     CopyTag       Chain     FTRAY                                         Copy Tag !!!
WJB  C     CopyTag       Chain     FTRAYR                                        Copy Tag !!!
WJB  C                   If        not %Found(FTRAY) and
WJB  C                             not %Found(FTRAYR)
WJB  C                   Eval      *In13 = *On
WJB  C                   GOTO      RSTART
WJB  C                   Else
WJB  C                   Eval      *In40 = *Off
WJB  C                   Eval      ITEM = TRITEM
WJB  C                   Eval      SIZE = TRSIZE
WJB  C                   Eval      READYD = $MDYDate($Date(TRCRDT))
WJB  C                   EndIf
WJB  C                   EndIf
      ** CHECK ITEM
     C     1             SUBST     ITEM:1        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     ITEM:2        IMLOOK
     C                   MOVEL     SIZE          IMSIZE
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
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   GOTO      NXTA
     C                   ENDIF
     C     MINKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C     MINKEY        CHAIN     FMINVT                             20
     C   20              GOTO      NXTA
      ** CHECK DATE
     C     READYD        IFLE      0
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   END
     C     READYD        CHAIN     FCALEN                             10
     C   10              SETON                                        11
     C   10              GOTO      NXTA
      ** MUST BE MONDAY
     C     CL#Y          IFNE      1
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     CLCYMD        RDCYMD            7 0
      ** IF HERE ALL OK
      * GET SOW DATE
     C                   CALL      'GETGERM'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    RDCYMD
     C                   PARM                    NISOW             7 0
     C                   Z-ADD     NISOW         ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SOWDAT            6 0
     C                   Z-ADD     0             NUMLAB
     C                   SETOFF                                       102071
     C                   SETOFF                                         9899
     C                   Z-ADD     0             OLAB              4 0
     C                   MOVEL     LPRTR         OPRTR            10
     C     NXTB          TAG
     C   99              SETOFF                                           98
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
     C   71              GOTO      NXTB
     C                   SETOFF                                       1020
     C                   SETOFF                                           99
      ** CHECK NUMBER OF LABELS
     C     NUMLAB        IFLE      0
     C                   SETON                                        1099
     C                   GOTO      NXTB
     C                   END
      ** CHECK PRINTER
     C     LPRTR         IFLE      *BLANKS
     C                   SETON                                        2099
     C                   GOTO      NXTB
     C                   END
      ** CHECK FOR CHANGES
     C     NUMLAB        IFNE      OLAB
     C     LPRTR         ORNE      OPRTR
     C                   Z-ADD     NUMLAB        OLAB
     C                   MOVEL     LPRTR         OPRTR
     C                   SETOFF                                       98
     C                   END
      ** REDISPLAY
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   END
      ** IF HERE CREATE JOB AND PRINT LABELS
     C     SOWDAT        CHAIN     FCALEN                             90
     C                   Z-ADD     CLCYMD        SOWCYM            7 0
     C                   Z-ADD     CLWEEK        SOWWEK            2 0
     C                   MOVEL     CLCENT        SOWYER            4 0
     C                   MOVE      CLYEAR        SOWYER
     C     NUMKEY        KLIST
     C                   KFLD                    SOWYER
     C                   KFLD                    SOWWEK
     C     NUMKEY        CHAIN     FJOBNM                             71
      ** IF WEEK NOT CREATED DO NOT ALLOW ENTRY
     C   71              GOTO      NXTB
     C                   Z-ADD     JNJOB#        SOJOB#
     C                   ADD       1             JNJOB#
     C  N71              UPDATE    RJOBNM
     C                   MOVEL     'C'           SOSTAT
     C                   Z-ADD     SOWCYM        SOSOWD
     C                   Z-ADD     SOWCYM        SOASOW
     C                   Z-ADD     RDCYMD        SORDYD
     C                   MOVEL     IMITEM        SOITEM
     C                   MOVEL     IMSIZE        SOSIZE
     C                   MOVEL     IMLOOK        SOLOOK
     C                   Z-ADD     8             SOLINE
     C                   Z-ADD     IM#SED        SO#SED
     C                   MOVEL     IMTRYC        SOTRYC
     C                   MOVEL     IMALTP        SOALTP
     C                   MOVE      IMMSCX        SOMSCX
     C                   MOVE      IMTPSW        SOTPSW
     C                   MOVE      IMLOC         SOLOC
     C                   Z-ADD     NUMLAB        SOORDQ
     C                   Z-ADD     NUMLAB        SOSOWT
     C                   Z-ADD     NUMLAB        SOSOWL
     C                   Z-ADD     0             SOSOWQ
     C                   TIME                    SOTIME
     C                   MOVEL     USERID        SOUSER
     C                   Z-ADD     TDATE         SODTLA
     C                   WRITE     RSOWSCH
      ** PRINT LABELS
     C                   Z-ADD     SOJOB#        JOB#              4 0
     C                   Z-ADD     8             SOWLIN            1 0
WJB  C                   MOVEL     'P'           LCANCL
WJB  C                   GOTO      END
WJB  C*                    CALL 'SOW100CL'
WJB  C*                    PARM           SOWLIN
WJB  C*                    PARM           SOWCYM
WJB  C*                    PARM           JOB#
     C                   GOTO      RSTART
      *** END JOB
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
