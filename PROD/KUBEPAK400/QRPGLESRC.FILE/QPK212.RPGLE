    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *--------------------------------------------------------------
      **PROGRAM NAME-------- QPK212
      **SYSTEM-------------- TGMS SOW SCHEDULT PROMPT SCREEN
      **DESCRIPTION--------- THIS PROGRAM PROMPTS FOR REPORT
      **                     OPTIONS AND VALIDATES FIELDS ENTERED.
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 12/10/98 GD  INCLUDE SOW DATE ONLY
      * 12/21/01 EFD ADD LOGIC FOR NEW SOW LINE PROGRAMS
      *
     FFMPRCL    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FQPK212FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
    ?D/COPY QFunctDefn,$_Dates
    ?D/COPY QFunctDefn,$Monday
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
     D                UDS
     D  LUSER                  1     10
     D  LDATE                 11     16  0
     D  LPOST                 17     17
     D  LREM                  18     18
     D  LIDATE                19     19
     D  LCNAME                31     60
     D  LFRPC                 61     62
     D  LTOPC                 63     64
     D  LDORS                 65     65
     D  LQUERY                66     66  0
     D  LLABEL                67     67
     D  LPRTQY                68     68
     D  LNEWSOW               69     69
     D  LCANCL               133    133
      *
     D V_Fields_DS     DS
     D VIDATE                                                                   This Date Only (1A)
     D VFRPC                                                                    From PC (2A)
     D VTOPC                                                                    To PC   (2A)
     D VPOST                                                                    Post Items (1A)
     D VREM                                                                     Remove Posted Flag1A
     D VDORS                                                                    Det. or Sum. (1A)
     D VPRTQY                                                                   Print Queries (1A)
     D VQUERY                                                                   1=prd 2=upd 3=recap
     D VLABEL                                                                   Print Labels (1A)
     D NEWSOW                                                                   Run SL File Bld (1A)
     D V_Fields                      12A   OverLay(V_Fields_DS)

     D Monday          S               D

     D ThisWeek        S              6S 0
     D LastWeek        S              6S 0
     D NextWeek        S              6S 0
      *
      * VALIDATE RESPONSES ON PROMPT SCREEN A
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     0             CNT               1 0
     C                   Z-ADD     01            VCO               2 0
     C     VCO           CHAIN     FMCOMP                             92
     C                   MOVE      *BLANKS       LCANCL
     C                   MOVEL     MCNAME        LCNAME
      *
     C                   MOVEL     *BLANKS       VPOST
     C                   MOVEL     *BLANKS       VREM
     C                   MOVEL     *BLANKS       VDORS
     C                   Z-ADD     0             VQUERY
     C                   MOVEL     *BLANKS       VLABEL
     C                   MOVEL     *BLANKS       VFRPC
     C                   MOVEL     *BLANKS       VTOPC
     C                   MOVEL     *BLANKS       VIDATE
     C                   MOVE      *BLANKS       NEWSOW
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C   99              Z-ADD     0             CNT
     C                   SETOFF                                       102021
     C                   SETOFF                                       222599
     C                   SETOFF                                       304050
     C                   SETOFF                                       607090
     C                   SETOFF                                       626465
     C                   SETOFF                                       6671
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP

     C                   Eval      Monday   = $Monday($Date(0):'SAT')
     C                   Eval      ThisWeek = $MDYdate(Monday)
     C                   Eval      LastWeek = $MDYdate($AddDate(Monday:-7))
     C                   Eval      NextWeek = $MDYdate($AddDate(Monday:+7))

     C                   Select
      *              // Production
     C                   When      Option  = 1                                  Next Week Clear
WJB  C* 1/28/17          Move      'Y5061NYSN1NN'V_Fields //Chg Default for Remove Post Flag to 'N'
WJB  C                   Move      'Y5061NNSN1NN'V_Fields
     C                   Eval      VDATE = NextWeek
     C                   When      Option  = 4                                  Next Week Prod.
     C                   Move      'Y5061YNDY1YY'V_Fields
     C                   Eval      VDATE = NextWeek
      *              // Update
     C                   When      Option  = 2                                  Last Week Post
     C                   Move      'N5061YNDN2NN'V_Fields
     C                   Eval      VDATE = LastWeek
     C                   When      Option  = 5                                  This Week Update
     C                   Move      'Y5061YNDY2NY'V_Fields
     C                   Eval      VDATE = ThisWeek
      *              // Recap
     C                   When      Option  = 3                                  This Week Clear
     C                   Move      'Y5061NYSN3NN'V_Fields
     C                   Eval      VDATE = ThisWeek
     C                   When      Option  = 6                                  This Week Recap
     C                   Move      'Y5061YNDY3NN'V_Fields
     C                   Eval      VDATE = ThisWeek
     C                   Other
     C                   Goto      NoOption
     C                   EndSL
     C                   Goto      RSTRTA
      *
     C     NoOption      Tag
     C                   MOVEL     *BLANKS       LCANCL
     C                   MOVEL     VFRPC         LFRPC
     C                   MOVEL     VTOPC         LTOPC
     C                   MOVEL     VPOST         LPOST
     C                   MOVEL     VREM          LREM
     C                   MOVEL     VDORS         LDORS
     C                   Z-ADD     VQUERY        LQUERY
     C                   MOVEL     VPRTQY        LPRTQY
     C                   MOVEL     NEWSOW        LNEWSOW
     C                   MOVEL     VLABEL        LLABEL
     C                   Z-ADD     VDATE         LDATE
     C*                    MOVELVFRPC     LFRPC
     C                   MOVEL     USERID        LUSER
     C                   MOVEL     VIDATE        LIDATE
      *
     C                   Z-ADD     VDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1099
     C                   GOTO      RSTRTA
     C                   END
      *
     C     VIDATE        IFNE      'Y'                                                      Q
     C     VIDATE        ANDNE     'N'
     C                   SETON                                        646599
     C   65              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VFRPC         IFEQ      *BLANKS
     C     VTOPC         ANDEQ     *BLANKS
     C                   GOTO      NOPC
     C                   ENDIF
      *
     C     VFRPC         IFEQ      *BLANKS
     C     VTOPC         ANDGT     *BLANKS
     C                   SETON                                        202199
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     1             SUBST     VFRPC:1       VPC1              1
     C     VPC1          IFEQ      '?'
     C     VPC1          OREQ      '/'
     C                   MOVEL     VFRPC         PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VFRPC
     C                   MOVEL     PCPRCL        VFRPC
     C                   MOVEL     PCDESC        VDESC            30
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     1             SUBST     VTOPC:1       VPC1              1
     C     VPC1          IFEQ      '?'
     C     VPC1          OREQ      '/'
     C                   MOVEL     VFRPC         PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VTOPC
     C                   MOVEL     PCPRCL        VTOPC
     C                   MOVEL     PCDESC        VDESC            30
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VFRPC         IFGT      *BLANKS
     C     VTOPC         ANDEQ     *BLANKS
     C                   MOVEL     VFRPC         VTOPC
     C                   ENDIF
      *
     C     VFRPC         IFGT      VTOPC
     C   96              SETON                                        202299
     C   20              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VFRPC         CHAIN     FMPRCL                             96
     C   96              SETON                                        202299
     C   20              GOTO      RSTRTA
      *
     C     VTOPC         CHAIN     FMPRCL                             96
     C   96              SETON                                        2599
     C   25              GOTO      RSTRTA
      *
     C     NOPC          TAG
      *
     C     VPOST         IFNE      'Y'                                                      Q
     C     VPOST         ANDNE     'N'
     C                   SETON                                        3099
     C   30              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VREM          IFNE      'Y'                                                      Q
     C     VREM          ANDNE     'N'
     C                   SETON                                        4099
     C   40              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VDORS         IFNE      'D'                                                      Q
     C     VDORS         ANDNE     'S'
     C                   SETON                                        5099
     C   50              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VPRTQY        IFNE      'Y'                                                      Q
     C     VPRTQY        ANDNE     'N'
     C                   SETON                                        6299
     C   62              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VPRTQY        IFEQ      'Y'                                                      Q
     C     VIDATE        ANDEQ     'N'
     C                   SETON                                        646699
     C   66              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VPRTQY        IFEQ      'Y'                                                      Q
     C     VQUERY        ANDEQ     0
     C     VQUERY        ORGT      3
     C                   SETON                                        6099
     C   60              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VLABEL        IFNE      'Y'                                                      Q
     C     VLABEL        ANDNE     'N'
     C                   SETON                                        7099
     C   70              GOTO      RSTRTA
     C                   ENDIF
      *
     C     NEWSOW        IFNE      'Y'                                                      Q
     C     NEWSOW        ANDNE     'N'
     C                   SETON                                        7199
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C                   ADD       1             CNT
     C     CNT           IFEQ      1
     C                   SETON                                        98
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
