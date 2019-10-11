      *--------------------------------------------------------------
      *
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- SDC360R
      **PROGRAMMER---------- Rich Piasecki
      **APPLICATION--------- ITEM COST/PRICE REPORT PROMPT
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FSDR360S   CF   E             WORKSTN
     F                                     INFDS(INFDS3)
     FFMSIZE    IF   E           K DISK
      *
0010 D DD              S              2  0 DIM(12) CTDATA PERRCD(12)            DATE EDIT        NWD
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
     D  ##PGM            *PROC
     D  ##PARM           *PARMS
     D  ##PERR                91    169
     D  ##JOB                244    253
     D  ##USER               254    263
     D  ##JOBN               264    269
     D  ##JBDT               276    281  0
     D  ##JBTM               282    287  0
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *
      ********************************************************************
      * ?Define From & To Dates                                         ?*
      ********************************************************************
     D                 DS
     D  FDATE                  1      8  0 INZ(0)
     D  FYYYY                  1      4  0 INZ(0)
     D  FMONTH                 5      6  0 INZ(0)
     D  FDAY                   7      8  0 INZ(0)
     D  TODAT                  9     16  0 INZ(0)
     D  TYYYY                  9     12  0 INZ(0)
     D  TMONTH                13     14  0 INZ(0)
     D  TDAY                  15     16  0 INZ(0)
      *    LDA       *
      ****************
     D                UDS
WJB  D  LDADTA                 1    164
     D  LCO                    1      2  0
     D  ALPHA                  3     17
     D  SIZE                  18     20
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LFRDT                134    141  0
     D  LTODT                142    149  0
     D  LSORT                150    150
WJB  D*  RETAIN THESE FOR REDISPLAY
WJB  D  VOUT                 151    151  0
WJB  D  S1FRDT               152    157  0
WJB  D  S1TODT               158    163  0
WJB  D  S1SORT               164    164
WJB  D  IncludeKP            165    165
      ********************************************************************
      * ?File Information Data Structure                                ?*
      ********************************************************************
     D INFDS3          DS
      *   Display File name (internal RPG name)
     D  $3FILN           *FILE
      *   Record format ID for last record input
     D  $3RCDF           *RECORD
      *   AID byte: identifies which function key was pressed:
     D  $3AID                369    369
      *   Current Cursor row and column (Binary)
     D  $3CURP               370    371B 0
      *    Low Relative Record # on SFLPAG
     D*                                   B 378 3790PAGRRN
      *    Relative Record # of Last Changed Record in SFLRCD
     D  $3RRN#               397    400B 0
      *****************************************************************
      * ?Define Program Constants                                   ? *
      *****************************************************************
     D YES             C                   CONST('YES')
      *
      ********************************************************************
      ******************  Program Main Line?  ***************************
      ********************************************************************
      ********************************************************************
      *
      *? Program Main Loop                                ?             ?
      *
Do   C     ENDPGM        DOWNE     YES
|     *
|     *? Write Cmd Key, Msgsfl                            ?
|     *
|    C                   WRITE     MSGCTL
|    C                   EXFMT     SCRNA
|     *
|     *? Reset Cursor Position                            ?             ?
      *
|    C                   Z-ADD     *ZERO         ##ROW
|    C                   Z-ADD     *ZERO         ##COL
|     *
|     *? Clear indicators and flags                       ?
|     *
     C                   MOVEA     '00'          *IN(10)
     C                   MOVEA     '000'         *IN(13)
     C                   MOVEA     '00000'       *IN(50)
|    C                   MOVE      *BLANKS       ERROR             3
|     *
|     *? Clear Messages                                   ?
|     *
|    C                   MOVE      'C'           $#MSFN            1
|    C                   EXSR      SRMSGF
|    C                   MOVE      'S'           $#MSFN            1
|     *? SELECT WHEN:
|Sl  C                   SELECT
||    *
||    *? F1 - Cursor Help                                 ?
||    *
||1  C     *IN01         WHENEQ    *ON
||   C                   EXSR      SRCHLP
|     *
      *
||    *
||    *? F12 - Previous - end program no update           ?
||    *
||3  C     *IN12         WHENEQ    *ON
||   C                   MOVE      YES           ENDPGM            3
     C                   MOVE      'X'           LCANCL
||   C                   LEAVE
||    *
||    *? If change on screen -- reset confirm             ?
||    *
||O  C                   OTHER
     C                   MOVE      *BLANKS       LCANCL
||If C     *IN28         IFEQ      *ON
|||  C                   MOVE      *OFF          $$CNFR            1
||If C                   END
||    *
||    *? Read SCREEN01 and check for "?", Validity.       ?
||    *
||   C                   EXSR      $EDT01
||    *
||If C     ERROR         IFEQ      YES
|||  C                   MOVE      *OFF          $$CNFR
||X  C                   ELSE
|||   *
|||IfC     $$CNFR        IFEQ      *OFF
|||| C                   MOVE      *ON           $$CNFR
|||| C                   MOVE      'SR00006'     $#MSID                         ?Message Id   ?
|||| C                   EXSR      SRMSGF
|||X C                   ELSE
||||  *
||    *? Process
||    *
|||| C                   EXSR      MOV@TO
||   C                   MOVE      YES           ENDPGM            3
     C                   ENDIF
     C                   ENDIF
||    *
|Sl  C                   ENDSL
Do   C                   ENDDO
      *
      *? End the program                                  ?             ?
      *
     C                   MOVE      *ON           *INLR
      *
      ***************************************************************
      *? Edit Screen                                   ?            *   ?
      ***************************************************************
     C     $EDT01        BEGSR
      ** Validate Size Code
     C     1             SUBST     SIZE:1        VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
||   C                   EXSR      $PRMPT
     C                   ENDIF
      *
     C     SIZE          IFGT      *BLANKS
     C     SIZE          CHAIN     FMSIZE                             10
     C     *IN10         IFEQ      *ON
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'SDC3601'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
     C                   ENDIF
      * Printer cannot be blank
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   MOVE      *ON           *IN50
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'SDC3602'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
      *
      * Forms cannot be blank
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   MOVE      *ON           *IN51
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'SDC3603'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
      *
      * Number of copies cannot be Zero
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   MOVE      *ON           *IN52
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'SDC3604'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
      *
      * Jobq option must be Y or N
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   MOVE      *ON           *IN53
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'SDC3605'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
      *
      * Output type must be 1, 2, or 3
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   MOVE      *ON           *IN54
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'SDC3606'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
      *****
VS02  *? FROM DATE VALIDATION                                  ?
      *****
0051 C     S1FRDT        MULT      10000.01      YYMMDD            6 0                         NORDT
0051 C                   Z-ADD     YYMMDD        FDATE                                         NORDT
0051 C                   MOVEL     20            FDATE                                         NORDT
0051 C     FMONTH        IFLT      01                                                          NORDT
0052 C     FMONTH        ORGT      12                                                          NORDT
     C                   MOVE      YES           ERROR
0062 C                   MOVE      *ON           *IN13                                         NORDT
0054 C                   MOVE      'DATE101'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
0056 C*                                                                   NORDTE
0057 C                   MOVE      FMONTH        CMO               2 0                         NORDT
0058 C                   MOVE      FDAY          CDA               2 0                         NORDT
0059 C                   MOVE      FYYYY         CKYR              4 0                         NORDT
0059 C                   MOVEL     FYYYY         CENT              2 0                         NORDT
0060 C                   EXSR      EDITDT                                                      NORDT
     C     *IN50         IFEQ      *ON
     C                   MOVE      YES           ERROR
0061 C                   MOVEL     'DATE102'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
0062 C                   MOVE      *ON           *IN13                                         NORDT
     C                   GOTO      ##EN01
     C                   ENDIF
0056 C*                                                                   NORDTE
0065 C     CKYR          IFLT      1998                                                        NORDT
0066 C     CENT          ORGT      20                                                          NORDT
     C                   MOVE      YES           ERROR
0067 C                   MOVE      *ON           *IN13                                         NORDT
0068 C                   MOVEL     'DATE103'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
0069 C                   ENDIF                                                                 NORDT
      *****
VS02  *? TO DATE VALIDATION                                  ?
      *****
0051 C     S1TODT        MULT      10000.01      YYMMDD            6 0                         NORDT
0051 C                   Z-ADD     YYMMDD        TODAT                                         NORDT
0051 C                   MOVEL     20            TODAT                                         NORDT
0051 C     TMONTH        IFLT      01                                                          NORDT
0052 C     TMONTH        ORGT      12                                                          NORDT
     C                   MOVE      YES           ERROR
0062 C                   MOVE      *ON           *IN14                                         NORDT
0054 C                   MOVE      'DATE104'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
0056 C*                                                                   NORDTE
0057 C                   MOVE      TMONTH        CMO               2 0                         NORDT
0058 C                   MOVE      TDAY          CDA               2 0                         NORDT
0059 C                   MOVE      TYYYY         CKYR              4 0                         NORDT
0059 C                   MOVEL     TYYYY         CENT              2 0                         NORDT
0060 C                   EXSR      EDITDT                                                      NORDT
     C     *IN50         IFEQ      *ON
     C                   MOVE      YES           ERROR
0061 C                   MOVEL     'DATE105'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
0062 C                   MOVE      *ON           *IN14                                         NORDT
     C                   GOTO      ##EN01
     C                   ENDIF
0056 C*                                                                   NORDTE
0065 C     CKYR          IFLT      1998                                                        NORDT
0066 C     CENT          ORGT      20                                                          NORDT
     C                   MOVE      YES           ERROR
0067 C                   MOVE      *ON           *IN14                                         NORDT
0068 C                   MOVEL     'DATE106'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
0069 C                   ENDIF                                                                 NORDT
      *****
VS02  *? FROM DATE MUST BE LESS THAN TO DATE                 ?
      *****
0051 C     FDATE         IFGT      TODAT                                                       NORDT
     C                   MOVEA     '11'          *IN(13)
     C                   MOVE      YES           ERROR
0054 C                   MOVEL     'DATE107'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
0069 C                   ENDIF                                                                 NORDT
      *
      * Sort Sequence code must be  S  or  P
     C     S1SORT        IFNE      'S'
     C     S1SORT        ANDNE     'P'
WJB  C     S1SORT        ANDNE     'Q'
     C                   MOVE      *ON           *IN15
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'SDC3607'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
      *
     C     ##EN01        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    #FDATE            8
     C                   PARM                    #TDATE            8
     C                   PARM                    #SORT             1
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
      *
      *? Initialize values for message subfile            ?             ?
      *
     C                   MOVE      ##PGM         $#PGMQ           10            ?Pgm Msg Queue?
     C                   MOVEL     'KPMSGF'      $#MSGF           10            ?Msg File N/A ?
     C                   MOVEL     '*LIBL'       $#MSGL           10            ?Library  N/A ?
      *
      *? Clear Message Subfile -- set function to send    ?             ?
      *
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
      *
WJB  C     LDADTA        IFEQ      *BLANKS
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     *ZERO         S1FRDT
     C                   Z-ADD     *ZERO         S1TODT
     C                   MOVE      *BLANKS       ALPHA
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       LCANCL
     C                   MOVEL     'XERPRT01'    LPRTR
      *
     C                   MOVEL     '*NAR'        LFORM
     C                   MOVEL     'N'           LJOBQ
     C                   Z-ADD     01            LCOPY
     C                   Z-ADD     1             VOUT
      *
WJB  C                   ELSE
WJB  C                   MOVE      YES           ERROR
WJB  C                   MOVE      'SDC3608'     $#MSID                                        NORDT
WJB  C                   EXSR      SRMSGF
WJB  C                   ENDIF
     C                   ENDSR
      ********************************************************************
      * ?       Move Screen Fields to LDA                               ?*
      ********************************************************************
     CSR   MOV@TO        BEGSR
     C                   Z-ADD     FDATE         LFRDT
     C                   MOVEL     FDATE         #FDATE
     C                   Z-ADD     TODAT         LTODT
     C                   MOVEL     TODAT         #TDATE
     C                   MOVE      S1SORT        LSORT
     C                   MOVE      S1SORT        #SORT
     C     VOUT          IFEQ      1
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*NO '        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      2
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      3
     C                   MOVEL     '*YES'        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
      * ?SRMSGF - Clear or send messages to Pgm msg queue               ?*
      ********************************************************************
     CSR   SRMSGF        BEGSR
      *
      *? Define Parameter List - define variables         ?
      *
     C     PLMSGF        PLIST
     C                   PARM                    $#PGMQ           10
     C                   PARM                    $#MSGF           10
     C                   PARM                    $#MSGL           10
     C                   PARM                    $#MSID            7
     C                   PARM                    $#MSGD           80
     C                   PARM                    $#MSKY            4
     C                   PARM                    $#MSFN            1
      *
      *? Call Msg processing CL                           ?
      *
     C                   CALL      'XAMSFC'      PLMSGF
      *
     C                   ENDSR
      *****************************************************************
      * ?SRCHLP - Cursor Sensitive Help                             ? *
      * ?                                                           ? *
      * ?         This subroutine will call the program to display  ? *
      * ?         field level help, check for returned values and   ? *
      * ?         move the field value to the screen field.         ? *
      * ?                                                           ? *
      * ?This subroutine was created by the CRTSRCHLP Command       ? *
      * ?                                                           ? *
      *****************************************************************
     CSR   SRCHLP        BEGSR
      *
      * ?Save Indicators                                  ?
      *
     C                   MOVE      *IN66         @@IN66            1
     C                   MOVE      *IN69         @@IN69            1
      *
      * ?Retain Current Cursor Position                   ?
      *
     C     $3CURP        DIV       256           ##ROW
     C                   MVR                     ##COL
      *
      * ?Call Cursor Help Program                         ?
      *
     C                   CALL      'XACHLPC'                            69
     C                   PARM                    ##FLD
     C                   PARM                    $3CURP
     C                   PARM                    ##PGM
     C                   PARM                    ##RCD
      *
      * ?Restore Indicators                               ?
      *
     C                   MOVE      @@IN66        *IN66
     C                   MOVE      @@IN69        *IN69
      *
     CSR                 ENDSR
      *****************************************************************
      * ?$PRMPT - Prompt Subroutine                                 ? *
      *****************************************************************
     CSR   $PRMPT        BEGSR
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       SIZE
     C                   MOVEL     SZCODE        SIZE
     CSR                 ENDSR
0108 C********************************************************************ROYDTE
VS02 C*?EDITDT - EDIT THAT DATES ARE VALID                   ?
0109 C******************************************************************* NORDTE
0110 C*                                                                   NORDTE
0111 C     EDITDT        BEGSR                                                                 NORDT
0112 C*                                                                   NORDTE
0113 C     CKYR          DIV       4             CKLEAP            5 0                         NORDT
0114 C                   MVR                     CKLEAP                                        NORDT
0115 C     CKLEAP        IFEQ      *ZERO                                                       NORDT
0116 C                   Z-ADD     29            DD(2)                                         NORDT
0116 C                   ELSE                                                                  NORDT
0117 C                   Z-ADD     28            DD(2)                                         NORDT
0117 C                   ENDIF                                                                 NORDT
0118 C*                                                                   NORDTE
0119 C     CDA           IFLT      01                                                          NORDT
0120 C     CDA           ORGT      DD(CMO)                                                     NORDT
     C                   MOVE      *ON           *IN50                                         NORDT
     C                   ENDIF                                                                 NORDT
0121 C                   ENDSR                                                                 NORDT
** DD
312831303130313130313031
