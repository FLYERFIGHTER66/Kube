      *%*******************************************************************
      *%                                                                 **
      *%  ?                     ?                                        **
      *%  ?                     ?                                        **
      *%                        ?                                        **
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?-                                                 **
      *%                                                  ?              **
      *%                                                                 **
      *%  ?                     ?                                        **
      *%  ?                     ?                                        **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- KP0010                                                 *
      *                                                                   *
      * Purpose?- Inventory P/O Maintenance Selection                    *
      *                                                                   *
      *   Date  ?Programmer    ? Comment                             ? *
      *  08/22/03  R. Piasecki      Program Created                       *
      *                                                                   *
      *********************************************************************
     FPOCNTL    UF   E           K DISK
     FSECUSER   IF   E           K DISK
     FKPPOHD    UF   E           K DISK
      * Logicals over all statuses
     FKPPOHDL1  IF   E           K DISK
     F                                     RENAME(DGHDR:HDRL1)
     FKPPOHDL2  IF   E           K DISK
     F                                     RENAME(DGHDR:HDRL2)
     FKPPOHDL3  IF   E           K DISK
     F                                     RENAME(DGHDR:HDRL3)
     FKPPOHDL5  IF   E           K DISK
     F                                     RENAME(DGHDR:HDRL5)
      * Logicals over open status only
     FKPPOHDO1  IF   E           K DISK
     F                                     RENAME(DGHDR:HDRO1)
     FKPPOHDO2  IF   E           K DISK
     F                                     RENAME(DGHDR:HDRO2)
     FKPPOHDO3  IF   E           K DISK
     F                                     RENAME(DGHDR:HDRO3)
      * Logicals over history status only
     FKPPOHDH1  IF   E           K DISK
     F                                     RENAME(DGHDR:HDRH1)
     FKPPOHDH2  IF   E           K DISK
     F                                     RENAME(DGHDR:HDRH2)
     FKPPOHDH3  IF   E           K DISK
     F                                     RENAME(DGHDR:HDRH3)
     FFMVEND    IF   E           K DISK
     FKPPODT    UF   E           K DISK
     FKPPORC    IF   E           K DISK
     FPRTTABL   IF   E           K DISK
      *
     FKP0010S   CF   E             WORKSTN
     F                                     SFILE(S1DATA:S1RRN)
     F                                     SFILE(S2DATA:S2RRN)
     F                                     INFDS(INFDS3)
      ********************************************************************
      * ?Tables & arrays                                                ?*
      ********************************************************************
     D OTX             S             15    DIM(9) CTDATA PERRCD(1)
     D OPT             S              1    DIM(9)
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
     D  PAGRRN               378    379B 0
      *    Relative Record # of Last Changed Record in SFLRCD
     D  $3RRN#               397    400B 0
      *
      ********************************************************************
      * ?Program Status Data Structure                                  ?*
      ********************************************************************
     D                SDS
     D  ##PGM            *PROC
     D  ##PARM           *PARMS
     D  ##PERR                91    169
     D  ##JOB                244    253
     D  ##USER               254    263
     D  ##JOBN               264    269
     D  ##JBDT               276    281  0
     D  ##JBTM               282    287  0
      ********************************************************************
      * ?Breakdown of due date                                          ?*
      ********************************************************************
     D                 DS                  INZ
     D  M1DUDT                 1      6  0
     D  M1DUMM                 1      2  0
     D  M1DUDD                 3      4  0
     D  M1DUYY                 5      6  0
     D                 DS                  INZ
     D  DSDATE                 1      6  0
     D  DSMM                   1      2  0
     D  DSDD                   3      4  0
     D  DSYY                   5      6  0
      ********************************************************************
      * ?Security options                                               ?*
      ********************************************************************
     D                 DS
     D  UF                     1     20
     D                                     DIM(20)
     D  USFL01                 1      1
     D  USFL02                 2      2
     D  USFL03                 3      3
     D  USFL04                 4      4
     D  USFL05                 5      5
     D  USFL06                 6      6
     D  USFL07                 7      7
     D  USFL08                 8      8
     D  USFL09                 9      9
     D  USFL10                10     10
     D  USFL11                11     11
     D  USFL12                12     12
     D  USFL13                13     13
     D  USFL14                14     14
     D  USFL15                15     15
     D  USFL16                16     16
     D  USFL17                17     17
     D  USFL18                18     18
     D  USFL19                19     19
     D  USFL20                20     20
      *****************************************************************
      * ?Define Program Constants                                   ? *
      *****************************************************************
     D YES             C                   CONST('YES')
     D NO              C                   CONST('NO ')
     D DFTVAL          C                   CONST('*DEFAULT  ')
     D SERS            C                   CONST('SERLSTATUS')
     D NONE            C                   CONST('*NONE')
     D @CF11A          C                   CONST('F11=All statuses')
     D @CF11H          C                   CONST('F11=History only')
     D @CF11O          C                   CONST('F11=Open only   ')
     D @CUNDA          C                   CONST('         All P/O''s')
     D @CUNDH          C                   CONST('History P/O''s only')
     D @CUNDO          C                   CONST('   Open P/O''s only')
     D @CSTSO          C                   CONST('Open')
     D @CSTSH          C                   CONST('Hist')
     D @CSTSU          C                   CONST('????')
     D @CINVJ          C                   CONST('*** Invalid Jobber N-
     D                                     umber ***')
     D BYPO            C                   CONST('P')
     D BYVNDR          C                   CONST('J')
     D BYDUDT          C                   CONST('D')
     D OPEN            C                   CONST('O')
     D HIST            C                   CONST('H')
     D ALL             C                   CONST('A')
      *
      ********************************************************************
      ********************************************************************
      ******************  Program Main Line?  ***************************
      ********************************************************************
      ********************************************************************
      *
      *? Program Main Loop                                ?             ?
      *
     C     ENDPGM        DOWNE     YES
      *
      *? Write Cmd Key, Msgsfl                            ?
      *
     C                   WRITE     CFKY01
     C                   WRITE     MSGCTL
     C                   EXFMT     S1CNTL
     C                   MOVE      ##SFLM        *IN83
      *
      *? Move 1st RRN for Current SFL Page to ##RRNO      ?             ?
      *
     C                   Z-ADD     PAGRRN        ##RRNO
      *
      *? Reset Cursor Position                            ?             ?
      *
     C                   Z-ADD     *ZERO         ##ROW
     C                   Z-ADD     *ZERO         ##COL
      *
      *? Clear Error indicators and flags                       ?
      *
     C                   MOVEA     '00000000'    *IN(31)                        CLR *IN31-38
     C                   MOVEA     '00000000'    *IN(39)                        CLR *IN39-46
     C                   MOVEA     '00000000'    *IN(47)                        CLR *IN47-54
     C                   MOVE      *BLANKS       ERROR             3
      *
      *? Clear Messages                                   ?
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN
      *
      * ?SFL Input Selection                          ?
      *
     C                   SELECT
      *
      * ?F3 or F12 pressed                                ?
     C     *IN03         WHENEQ    *ON
     C     *IN12         OREQ      *ON
     C                   MOVE      YES           ENDPGM            3
      *
      * ?F4 pressed                                ?
     C     *IN04         WHENEQ    *ON
     C                   EXSR      $PRMPT
     C     M1VNDR        IFNE      *ZEROS
     C                   MOVE      'J'           WKSORT
     C                   MOVE      *ON           *IN28
     C                   EXSR      LOADSF
      *
      *    ?Postioned Past EOF, Load Prior Page if Not BOF
     C     S1RRN         IFEQ      *ZEROS
     C     $$BOF         IFNE      *ON
     C                   EXSR      BACKSF
     C                   ELSE
      *    ?ELSE  Subfile Empty Write One Blank SFL Record (ND PR)
     C                   MOVE      'KP00101'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   EXSR      BLNKSF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * ?F8 pressed - Print P/O's                  ?
     C     *IN08         WHENEQ    *ON
     C                   EXSR      $CKPRT
     C                   SELECT
     C     WKPRT         WHENEQ    'N'
     C                   MOVE      'KP00102'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   OTHER
     C                   CALL      'KP0014R'
     C                   PARM      ' '           #PPRNT            1
     C     #PPRNT        IFEQ      'Y'
     C                   MOVE      'KP00103'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   EXSR      LOADSF
     C                   ELSE
     C                   MOVE      'KP00104'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   ENDIF
     C                   ENDSL
      *
      *
      *? F1 - Cursor Help                                 ?
     C     *IN01         WHENEQ    '1'
     C                   EXSR      SRCHLP
      *
      *?  F6 - Add new PURCHASE ORDER
     C     *IN06         WHENEQ    '1'
     C     999999        CHAIN     POCNTL                             13
     C                   MOVE      DGPOYR        #YRKEY            2
     C                   MOVE      DGNXPO        #POKEY            6
     C                   ADD       1             DGNXPO
     C                   UPDATE    POCNTLR
     C                   CALL      'KP0011R '                           69
     C                   PARM                    #YRKEY
     C                   PARM                    #POKEY
     C                   PARM      'A'           #MODE
     C     #YRKEY        IFNE      *BLANKS
     C                   MOVE      #YRKEY        S1YR#             2 0
     C                   MOVE      #POKEY        S1PO#             6 0
     C                   EXSR      LOADSF
     C                   END
      *
      *?  F11 - Toggle status displayed
     C     *IN11         WHENEQ    '1'
     C                   SELECT
     C     WKOST         WHENEQ    OPEN
     C                   MOVE      HIST          WKOST
     C                   MOVEL     @CF11A        C1F11
     C                   MOVE      @CUNDH        UNDER
     C     WKOST         WHENEQ    HIST
     C                   MOVE      ALL           WKOST
     C                   MOVEL     @CF11O        C1F11
     C                   MOVE      @CUNDA        UNDER
     C     WKOST         WHENEQ    ALL
     C                   MOVE      OPEN          WKOST
     C                   MOVEL     @CF11H        C1F11
     C                   MOVE      @CUNDO        UNDER
     C                   ENDSL
     C                   EXSR      LOADSF
      *
      *? Position to requested -- change in P/O
     C     *IN28         WHENEQ    *ON
      *
      *? Test position to fields to determine which file to read        ?
      *?
     C                   SELECT
     C     M1POYR        WHENNE    *ZERO
     C                   MOVE      'P'           WKSORT            1
     C     M1VNDR        WHENNE    *ZERO
     C                   MOVE      'J'           WKSORT
     C     M1DUDT        WHENNE    *ZERO
     C                   MOVE      'D'           WKSORT
     C                   ENDSL
     C                   EXSR      LOADSF
      *
      *    ?Postioned Past EOF, Load Prior Page if Not BOF
     C     S1RRN         IFEQ      *ZEROS
     C     $$BOF         IFNE      *ON
     C                   EXSR      BACKSF
     C                   ELSE
      *    ?ELSE  Subfile Empty Write One Blank SFL Record (ND PR)
     C                   MOVE      'KP00101'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   EXSR      BLNKSF
     C                   ENDIF
     C                   ENDIF
      *
      * ?RollDown                                         ?
     C     *IN27         WHENEQ    *ON
     C     $$BOF         IFEQ      *ON
     C                   Z-ADD     1             ##RRNO
     C                   MOVE      'SR00001'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   ELSE
      *??If No Errors Found in READSF Execute Roll Back
     C                   EXSR      READSF
     C     ERROR         IFNE      YES
     C                   EXSR      BACKSF
     C                   ENDIF
     C                   ENDIF
      *
      * ?Rollup                                           ?
     C     *IN26         WHENEQ    *ON
     C     $EOF          IFEQ      *OFF
     C                   EXSR      LOAD##
     C                   ELSE
     C                   MOVE      'SR00002'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   END
      *
      *? Process SFL Input               ?
     C     $$LOAD        WHENEQ    '1'
     C                   EXSR      READSF
     C***                  MOVE 'SR00101' $#MSID           ?Message Id   ?
     C***                  EXSR SRMSGF
      *
      *? No Records Loaded to SFL
     C                   OTHER
     C                   Z-ADD     1             ##RRNO
     C                   MOVE      'SF00101'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
      *
     C                   ENDSL
      *
     C                   ENDDO
      *
      *? End the program                                  ?             ?
      *
     C                   MOVE      '1'           *INLR
      *
      ********************************************************************
      ********************************************************************
      ********************  End Main Line?  *****************************
      ********************************************************************
      ********************************************************************
      *
      ********************************************************************
      * ?LOADSF - Load the PO Master Display                            ?*
      ********************************************************************
     CSR   LOADSF        BEGSR
      *
      *? Set Roll Forward by Load Factor set in *INZSR                  ?
      *
     C     #SFLPG        MULT      ##LOAD        ##ROLL
      *
      *? Clear the subfile                                ?             ?
      *
     C                   MOVE      *ON           *IN80
     C                   Z-ADD     *ZERO         S1RRN             5 0
     C                   Z-ADD     *ZERO         MXRRN             5 0
     C                   WRITE     S1CNTL
     C                   MOVE      *OFF          *IN80
     C                   MOVE      *OFF          *IN96
     C                   MOVE      *OFF          $$LOAD            1
     C                   MOVE      *OFF          $$BOF             1
     C                   MOVE      *OFF          *IN81
      *
      *? Save Position To Values for Roll Back Routine?             ?
     C                   MOVEL     M1POYR        SVPOYR
     C                   MOVEL     M1DGPO        SVDGPO
     C                   MOVEL     M1VNDR        SVVNDR
     C                   MOVEL     M1DUDT        SVDUDT
      *
      *? Set File Position                                ?             ?
     C     *IN28         IFEQ      *OFF
     C                   MOVE      *LOVAL        DGPOYR
     C                   MOVE      *LOVAL        DGDGPO
     C                   MOVE      *LOVAL        DGVNDR
     C                   MOVE      *LOVAL        DGPODC
     C                   MOVE      *LOVAL        DGPODY
     C                   MOVE      *LOVAL        DGPODM
     C                   MOVE      *LOVAL        DGPODD
     C                   ELSE
     C                   SELECT
     C     M1POYR        WHENNE    *ZEROS
     C     M1DGPO        ORNE      *ZEROS
     C                   MOVEL     M1POYR        DGPOYR
     C                   MOVEL     M1DGPO        DGDGPO
     C                   MOVE      BYPO          WKSORT            1
     C     M1VNDR        WHENNE    *ZEROS
     C                   MOVEL     M1VNDR        DGVNDR
     C                   MOVE      BYVNDR        WKSORT
     C     M1DUDT        WHENNE    *ZEROS
     C                   MOVEL     M1DUYY        DGPODY
     C                   MOVEL     M1DUMM        DGPODM
     C                   MOVEL     M1DUDD        DGPODD
     C     M1DUYY        IFGT      95
     C                   Z-ADD     19            DGPODC
     C                   ELSE
     C                   Z-ADD     20            DGPODC
     C                   ENDIF
     C                   MOVE      BYDUDT        WKSORT
     C                   ENDSL
     C                   ENDIF
      *
      *? Check for BOF                                    ?             ?
     C                   EXSR      $SETLL
     C                   EXSR      $READP
     C     *IN66         IFEQ      *ON
     C                   MOVE      *ON           $$BOF             1
     C                   ENDIF
      *
      *? Reposition after BOF Check                       ?             ?
     C     *IN28         IFEQ      *OFF
     C                   MOVE      *LOVAL        DGPOYR
     C                   MOVE      *LOVAL        DGDGPO
     C                   MOVE      *LOVAL        DGVNDR
     C                   MOVE      *LOVAL        DGPODC
     C                   MOVE      *LOVAL        DGPODY
     C                   MOVE      *LOVAL        DGPODM
     C                   MOVE      *LOVAL        DGPODD
     C                   ELSE
     C                   SELECT
     C     M1POYR        WHENNE    *ZEROS
     C     M1DGPO        ORNE      *ZEROS
     C                   MOVEL     M1POYR        DGPOYR
     C                   MOVEL     M1DGPO        DGDGPO
     C                   MOVE      BYPO          WKSORT            1
     C     M1VNDR        WHENNE    *ZEROS
     C                   MOVEL     M1VNDR        DGVNDR
     C                   MOVE      BYVNDR        WKSORT
     C     M1DUDT        WHENNE    *ZEROS
     C                   MOVEL     M1DUYY        DGPODY
     C                   MOVEL     M1DUMM        DGPODM
     C                   MOVEL     M1DUDD        DGPODD
     C     M1DUYY        IFGT      95
     C                   Z-ADD     19            DGPODC
     C                   ELSE
     C                   Z-ADD     20            DGPODC
     C                   ENDIF
     C                   MOVE      BYDUDT        WKSORT
     C                   ENDSL
     C                   ENDIF
     C                   EXSR      $SETLL
      *
     C                   CLEAR                   M1POYR
     C                   CLEAR                   M1DGPO
     C                   CLEAR                   M1VNDR
     C                   CLEAR                   M1DUDT
     C                   MOVE      *OFF          $EXLOD            1
     C                   MOVE      *OFF          $EOF              1
     C                   MOVE      *ON           *IN81
      *
      *? Read Loop                                        ?             ?
      *
     C     $EXLOD        DOUEQ     *ON
     C                   EXSR      $READ
     C     *IN66         IFEQ      *ON
     C                   MOVE      *ON           $EOF              1
     C                   MOVE      *ON           $EXLOD            1
     C                   MOVE      *OFF          *IN81
     C                   ELSE
      *
      *? Initialize SFL Record Field Values               ?
     C                   EXSR      MOV@S1
      *
     C                   MOVE      *BLANK        S1SEL
      *
     C                   ADD       1             S1RRN
     C                   WRITE     S1DATA
     C     S1RRN         IFEQ      ##ROLL
     C                   MOVE      *ON           $EXLOD
     C                   END
      *
     C                   END
     C                   END
      *
      *? If records loaded                                ?             ?
      *
     C     S1RRN         IFGT      *ZERO
     C                   Z-ADD     1             ##RRNO
     C                   Z-ADD     S1RRN         MXRRN
     C                   MOVE      *ON           $$LOAD            1
     C                   MOVE      'KP00101'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   ELSE
      *
      *? If no records loaded                             ?
      *
     C                   MOVE      *OFF          $$LOAD            1
     C                   EXSR      BLNKSF
     C                   MOVE      'KP00102'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   END
      *
     CSR                 ENDSR
      ********************************************************************
      * ?LOAD## - Load the P/O  Master Display                          ?*
      ********************************************************************
     CSR   LOAD##        BEGSR
      *
      *? Set Roll to SFLPAG * Roll Forward Factor                       ?
      *
     C     #SFLPG        MULT      ##FWRL        ##ROLL
      *
      *? Read Loop                                        ?             ?
      *
     C                   MOVE      *OFF          $EXLOD            1
     C                   MOVE      *OFF          $EOF
     C                   MOVE      *ON           *IN81
     C                   Z-ADD     *ZEROS        $COUNT            5 0
     C                   Z-ADD     MXRRN         S1RRN
     C     $EXLOD        DOUEQ     *ON
     C                   EXSR      $READ
     C     *IN66         IFEQ      *ON
     C                   MOVE      *ON           $EOF              1
     C                   MOVE      *ON           $EXLOD            1
     C                   MOVE      *OFF          *IN81
     C                   ELSE
      *
      *? Initialize SFL Record Field Values               ?
     C                   EXSR      MOV@S1
     C                   MOVE      *BLANK        S1SEL
      *
      *
      *? Write subfile record                             ?
     C                   ADD       1             S1RRN
     C                   ADD       1             $COUNT            5 0
     C                   WRITE     S1DATA
     C     $COUNT        IFEQ      ##ROLL
     C                   MOVE      *ON           $EXLOD
     C                   END
      *
     C                   END
     C                   END
      *
      *? If records loaded                                ?             ?
      *
     C     $COUNT        IFGT      *ZERO
     C                   Z-ADD     S1RRN         ##RRNO
     C                   Z-ADD     S1RRN         MXRRN
     C                   ELSE
      *
      *? If no records loaded                             ?
      *
     C                   END
      *
     CSR                 ENDSR
      ********************************************************************
      * ?$SETLL - Sets file pointer for file currently being read       ?*
      ********************************************************************
     CSR   $SETLL        BEGSR
      *
     C                   SELECT
      *
      * ?Sort=By PO number, Status=ALL
     C     WKSORT        WHENEQ    BYPO
     C     WKOST         ANDEQ     ALL
     C     POKEY         SETLL     DGHDR
      *
      * ?Sort=By PO number, Status=OPEN
     C     WKSORT        WHENEQ    BYPO
     C     WKOST         ANDEQ     OPEN
     C     POKEY         SETLL     HDRO1
      *
      * ?Sort=By PO number, Status=HIST
     C     WKSORT        WHENEQ    BYPO
     C     WKOST         ANDEQ     HIST
     C     POKEY         SETLL     HDRH1
      *
      * ?Sort=By Jobber number, Status=ALL
     C     WKSORT        WHENEQ    BYVNDR
     C     WKOST         ANDEQ     ALL
     C     DGKEY         SETLL     HDRL2
      *
      * ?Sort=By Jobber number, Status=OPEN
     C     WKSORT        WHENEQ    BYVNDR
     C     WKOST         ANDEQ     OPEN
     C     DGKEY         SETLL     HDRO2
      *
      * ?Sort=By Jobber number, Status=HIST
     C     WKSORT        WHENEQ    BYVNDR
     C     WKOST         ANDEQ     HIST
     C     DGKEY         SETLL     HDRH2
      *
      * ?Sort=By Due Date, Status=ALL
     C     WKSORT        WHENEQ    BYDUDT
     C     WKOST         ANDEQ     ALL
     C     DDKEY         SETLL     HDRL3
      *
      * ?Sort=By Due Date, Status=OPEN
     C     WKSORT        WHENEQ    BYDUDT
     C     WKOST         ANDEQ     OPEN
     C     DDKEY         SETLL     HDRO3
      *
      * ?Sort=By Due Date, Status=HIST
     C     WKSORT        WHENEQ    BYDUDT
     C     WKOST         ANDEQ     HIST
     C     DDKEY         SETLL     HDRH3
      *
     C                   ENDSL
      *
     C                   ENDSR
      ********************************************************************
      * ?$READP - Performs read prior on file currently being read      ?*
      ********************************************************************
     CSR   $READP        BEGSR
      *
     C                   CLEAR                   *IN66
      *
     C                   SELECT
      *
      * ?Sort=By PO number, Status=ALL
     C     WKSORT        WHENEQ    BYPO
     C     WKOST         ANDEQ     ALL
     C                   READP(N)  DGHDR                                  66
      *
      * ?Sort=By PO number, Status=OPEN
     C     WKSORT        WHENEQ    BYPO
     C     WKOST         ANDEQ     OPEN
     C                   READP     HDRO1                                  66
      *
      * ?Sort=By PO number, Status=HIST
     C     WKSORT        WHENEQ    BYPO
     C     WKOST         ANDEQ     HIST
     C                   READP     HDRH1                                  66
      *
      * ?Sort=By Jobber number, Status=ALL
     C     WKSORT        WHENEQ    BYVNDR
     C     WKOST         ANDEQ     ALL
     C                   READP     HDRL2                                  66
      *
      * ?Sort=By Jobber number, Status=OPEN
     C     WKSORT        WHENEQ    BYVNDR
     C     WKOST         ANDEQ     OPEN
     C                   READP     HDRO2                                  66
      *
      * ?Sort=By Jobber number, Status=HIST
     C     WKSORT        WHENEQ    BYVNDR
     C     WKOST         ANDEQ     HIST
     C                   READP     HDRH2                                  66
      *
      * ?Sort=By Due Date, Status=ALL
     C     WKSORT        WHENEQ    BYDUDT
     C     WKOST         ANDEQ     ALL
     C                   READP     HDRL3                                  66
      *
      * ?Sort=By Due Date, Status=OPEN
     C     WKSORT        WHENEQ    BYDUDT
     C     WKOST         ANDEQ     OPEN
     C                   READP     HDRO3                                  66
      *
      * ?Sort=By Due Date, Status=HIST
     C     WKSORT        WHENEQ    BYDUDT
     C     WKOST         ANDEQ     HIST
     C                   READP     HDRH3                                  66
      *
     C                   ENDSL
      *
     C                   ENDSR
      ********************************************************************
      * ?$READ - Performs read on file currently being read             ?*
      ********************************************************************
     CSR   $READ         BEGSR
      *
     C                   CLEAR                   *IN66
      *
     C                   SELECT
      *
      * ?Sort=By PO number, Status=ALL
     C     WKSORT        WHENEQ    BYPO
     C     WKOST         ANDEQ     ALL
     C                   READ(N)   DGHDR                                  66
      *
      * ?Sort=By PO number, Status=OPEN
     C     WKSORT        WHENEQ    BYPO
     C     WKOST         ANDEQ     OPEN
     C                   READ      HDRO1                                  66
      *
      * ?Sort=By PO number, Status=HIST
     C     WKSORT        WHENEQ    BYPO
     C     WKOST         ANDEQ     HIST
     C                   READ      HDRH1                                  66
      *
      * ?Sort=By Jobber number, Status=ALL
     C     WKSORT        WHENEQ    BYVNDR
     C     WKOST         ANDEQ     ALL
     C                   READ      HDRL2                                  66
      *
      * ?Sort=By Jobber number, Status=OPEN
     C     WKSORT        WHENEQ    BYVNDR
     C     WKOST         ANDEQ     OPEN
     C                   READ      HDRO2                                  66
      *
      * ?Sort=By Jobber number, Status=HIST
     C     WKSORT        WHENEQ    BYVNDR
     C     WKOST         ANDEQ     HIST
     C                   READ      HDRH2                                  66
      *
      * ?Sort=By Due Date, Status=ALL
     C     WKSORT        WHENEQ    BYDUDT
     C     WKOST         ANDEQ     ALL
     C                   READ      HDRL3                                  66
      *
      * ?Sort=By Due Date, Status=OPEN
     C     WKSORT        WHENEQ    BYDUDT
     C     WKOST         ANDEQ     OPEN
     C                   READ      HDRO3                                  66
      *
      * ?Sort=By Due Date, Status=HIST
     C     WKSORT        WHENEQ    BYDUDT
     C     WKOST         ANDEQ     HIST
     C                   READ      HDRH3                                  66
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      * ?MOV@S1 - Move File Fields to SFL Display Output Fields     ? *
      *****************************************************************
     CSR   MOV@S1        BEGSR
      *
      *
      * ?P/O Master File Fields.                    ?
      *
     C                   MOVE      DGPOYR        S1YR#
     C                   MOVE      DGDGPO        S1PO#
     C                   MOVE      DGRCID        S1RCID            2
     C                   MOVEL     DGVNDR        S1VNDR
     C                   MOVE      DGPODY        S1DATE
     C                   MOVEL     DGPODM        WKMMDD            4 0
     C                   MOVE      DGPODD        WKMMDD
     C                   MOVEL     WKMMDD        S1DATE
     C                   MOVEL     DGUSER        S1ENT
     C                   MOVEL     DGPRTF        S1PRTF
      *
     C                   SELECT
     C     DGOST         WHENEQ    'O'
     C                   MOVEL     @CSTSO        S1STAT
     C     DGOST         WHENEQ    'H'
     C                   MOVEL     @CSTSH        S1STAT
     C                   OTHER
     C                   MOVEL     @CSTSU        S1STAT
     C                   ENDSL
      *
      * ?Get jobber name
      *
     C                   CLEAR                   *IN99
     C*                    Z-ADD001       CORP#
     C                   Z-ADD     DGVNDR        PVEND#            6 0
     C     VMKEY         CHAIN     RMVEND                             99
     C     *IN99         IFEQ      '0'
     C                   MOVEL     VMNAME        S1NAME
     C                   ELSE
     C                   MOVEL     @CINVJ        S1NAME
     C                   ENDIF
      *
     CSR                 ENDSR
      *****************************************************************
      * ?BACKSF - Roll Back File One Page of SFL Records            ? *
      *****************************************************************
     CSR   BACKSF        BEGSR
      *
      *? Restore Saved Position to Fields from last SFL Load            ?
      *
     C                   SELECT
     C     WKSORT        WHENEQ    BYPO
     C                   MOVE      SVPOYR        M1POYR
     C                   MOVE      SVDGPO        M1DGPO
     C     WKSORT        WHENEQ    BYVNDR
     C                   MOVE      SVVNDR        M1VNDR
     C     WKSORT        WHENEQ    BYDUDT
     C                   MOVE      SVDUDT        M1DUDT
     C                   ENDSL
      *
      *? Set Roll Factor Based on Current SFL Mode  (Fold/Drop)         ?
      *
     C     ##SFLM        IFEQ      *OFF
     C                   Z-ADD     #SFLPG        ##ROLL                         SFL Drop Mode
     C                   ELSE
      *? Set Roll to SFLPAG * Roll Forward Factor                       ?
     C     #SFLPG        MULT      ##FWRL        ##ROLL                         SFL Fold Mode
     C                   END
      *
     C                   SELECT
     C     WKSORT        WHENEQ    BYPO
     C                   MOVE      M1POYR        DGPOYR
     C                   MOVE      M1DGPO        DGDGPO
     C     WKSORT        WHENEQ    BYVNDR
     C                   MOVE      M1VNDR        DGVNDR
     C     WKSORT        WHENEQ    BYDUDT
     C                   MOVE      M1DUYY        DGPODY
     C                   MOVE      M1DUMM        DGPODM
     C                   MOVE      M1DUDD        DGPODD
     C     DGPODY        IFGT      95
     C                   Z-ADD     19            DGPODC
     C                   ELSE
     C                   Z-ADD     20            DGPODC
     C                   ENDIF
     C                   ENDSL
      *
     C                   EXSR      $SETLL
      *
     C     1             DO        ##ROLL
     C                   EXSR      $READP
     C     *IN66         IFEQ      *ON
     C                   SELECT
     C     WKSORT        WHENEQ    'P'
     C                   MOVE      *LOVAL        DGPOYR
     C                   MOVE      *LOVAL        DGDGPO
     C     WKSORT        WHENEQ    'J'
     C                   MOVE      *LOVAL        DGVNDR
     C     WKSORT        WHENEQ    'D'
     C                   MOVE      *LOVAL        DGPODC
     C                   MOVE      *LOVAL        DGPODY
     C                   MOVE      *LOVAL        DGPODM
     C                   MOVE      *LOVAL        DGPODD
     C                   ENDSL
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   SELECT
     C     WKSORT        WHENEQ    BYPO
     C                   MOVE      DGPOYR        M1POYR
     C                   MOVE      DGDGPO        M1DGPO
     C     WKSORT        WHENEQ    BYVNDR
     C                   MOVE      DGVNDR        M1VNDR
     C     WKSORT        WHENEQ    BYDUDT
     C                   MOVE      DGPODY        M1DUDT
     C                   MOVEL     DGPODM        WKMMDD
     C                   MOVE      DGPODD        WKMMDD
     C                   MOVEL     WKMMDD        M1DUDT
     C                   ENDSL
     C                   MOVE      *ON           *IN28
     C                   EXSR      LOADSF
      *
     CSR                 ENDSR
      ********************************************************************
      * ?READSF - Read the subfile -- check for subfile selections and  ?*
      * ?         check for change to sequence number                   ?*
      ********************************************************************
     CSR   READSF        BEGSR
      *
      *? Check and process delete requests                ?             ?
      *
     C                   MOVE      *OFF          $$RLOD            1
     C                   EXSR      SRDEL
      *
      *? Set loop -- read all changed subfile records     ?             ?
      *
B001 C     *IN66         DOUEQ     *ON
     C                   READC     S1DATA                                 66
B002 C     *IN66         IFEQ      *OFF
      *
      *? If Subfile option entered                        ?
      *
B003 C     S1SEL         IFNE      *BLANK
     C                   Z-ADD     S1RRN         ##RRNO
      *
      *? Check option entered against valid options array
      *
     C                   EXSR      $SSOPT
      *
B004 C                   SELECT
      *
      *? Selection not valid for P/O type selected        ?
      *
     C     SSFLG2        WHENEQ    'N'
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN39
     C                   MOVE      *OFF          $$RLOD
     C                   MOVE      'SS99998'     $#MSID                         ?Message Id   ?
     C     S1SEL         CAT(P)    S1RCID:0      $#MSGD
     C                   EXSR      SRMSGF
     C                   MOVE      YES           ERROR
      *
      *? Selection 2 - Change P/O                         ?
      *
     C     S1SEL         WHENEQ    '2'
     C     SSFLG1        ANDEQ     *BLANK
     C                   MOVE      S1YR#         #YRKEY
     C                   MOVE      S1PO#         #POKEY
     C                   CALL      'KP0011R '                           69
     C                   PARM                    #YRKEY
     C                   PARM                    #POKEY
     C                   PARM      'U'           #MODE             1
     C                   SELECT
     C     #YRKEY        WHENEQ    'XX'                                         F3=EXIT
     C                   MOVE      *ON           *IN66
     C     #YRKEY        WHENNE    *BLANKS
     C                   MOVE      #YRKEY        M1POYR
     C                   MOVE      #POKEY        M1DGPO
     C                   MOVE      *ON           $$RLGD            1
     C                   ENDSL
     C                   CLEAR                   S1SEL
      *
      *? Selection 5 - Inquire P/O                         ?
      *
     C     S1SEL         WHENEQ    '5'
     C     SSFLG1        ANDEQ     *BLANK
     C                   MOVE      S1YR#         #YRKEY
     C                   MOVE      S1PO#         #POKEY
     C                   CALL      'KP0017R '                           69
     C                   PARM                    #YRKEY
     C                   PARM                    #POKEY
     C                   SELECT
     C     #YRKEY        WHENEQ    'XX'                                         F3=EXIT
     C                   MOVE      *ON           *IN66
     C     #YRKEY        WHENNE    *BLANKS
     C                   MOVE      #YRKEY        M1POYR
     C                   MOVE      #POKEY        M1DGPO
     C                   MOVE      *ON           $$RLOD            1
     C                   ENDSL
     C                   CLEAR                   S1SEL
      *
      *? Selection 6 - Receiving                        ?
      *
     C     S1SEL         WHENEQ    '6'
     C     SSFLG1        ANDEQ     *BLANK
     C                   MOVE      S1YR#         #YRKEY
     C                   MOVE      S1PO#         #POKEY
      *
      *? Determine Where to Print P/O's or Receivings                   ?
      *
     C                   MOVE      *BLANKS       S1OUTQ
     C                   MOVE      *BLANKS       S1RDTE
     C                   MOVE      *ON           *IN73
     C     *IN73         DOWEQ     *ON
     C                   EXFMT     PRTOUTQ
     C                   MOVE      *OFF          *IN74                                        ?
     C                   MOVE      *OFF          *IN70                                        ?
      *****
      * ?Received date must be Valid                                    ?*
      *****
     C                   Z-ADD     S1RDTE        DSDATE
     C                   EXSR      $CKDTE
     C     WKDERR        IFEQ      'Y'
     C                   MOVE      'YES'         ERROR
     C                   MOVE      'KP00112'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVE      *ON           *IN70
     C                   ITER
     C                   ENDIF
      *****
      * ?Printer Code Must be Valid                                     ?*
      *****
||    *
||1  C     S1OUTQ        IFEQ      '?'
||   C                   EXSR      $PPRMT
     C                   EXFMT     PRTOUTQ
||If C                   END
      *
||1  C     S1OUTQ        CHAIN     PRTTABL                            74
||1  C     *IN74         IFEQ      *ON
     C                   ITER
     C                   ENDIF
      *
     C     S1OUTQ        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN74                          ?Inactive     ?
     C                   ITER
     C                   ENDIF
     C                   MOVE      *OFF          *IN73
     C                   MOVEL     S1OUTQ        OUTQ             10
     C     S1RDTE        MULT      10000.01      YYMMDD            6 0
     C                   MOVE      YYMMDD        RDATE             6
     C                   ENDDO
     C                   CALL      'KP0013C '                           69
     C                   PARM                    #YRKEY
     C                   PARM                    #POKEY
     C                   PARM                    RDATE
     C                   PARM                    OUTQ
     C                   SELECT
     C     #YRKEY        WHENEQ    'XX'                                         F3=EXIT
     C                   MOVE      *ON           *IN66
     C     #YRKEY        WHENNE    *BLANKS
     C                   MOVE      #YRKEY        M1POYR
     C                   MOVE      #POKEY        M1DGPO
     C                   ENDSL
     C                   MOVE      *ON           $$RLOD            1
     C                   CLEAR                   S1SEL
      *
      *? Selection 7 - Change print flag                ?
      *
     C     S1SEL         WHENEQ    '7'
     C     SSFLG1        ANDEQ     *BLANK
      *
     C                   SELECT
     C     S1PRTF        WHENEQ    'N'
     C     S1PRTF        OREQ      'A'
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN39
     C                   MOVE      *OFF          $$RLOD
     C                   MOVE      'KP00105'     $#MSID                         ?Message Id   ?
     C                   MOVEL     S1PRTF        $#MSGD                         ?Message data?
     C                   EXSR      SRMSGF
     C                   MOVE      YES           ERROR             3
      *
     C     S1PRTF        WHENEQ    ' '
     C                   MOVE      S1YR#         DGPOYR
     C                   MOVE      S1PO#         DGDGPO
     C                   CLEAR                   *IN99
     C     POKEY         CHAIN     DGHDR                              99
     C                   MOVE      'R'           DGPRTF
     C                   UPDATE    DGHDR
     C                   CLEAR                   S1SEL
     C                   MOVE      'R'           S1PRTF
      *
     C     S1PRTF        WHENEQ    'R'
     C                   MOVE      S1YR#         DGPOYR
     C                   MOVE      S1PO#         DGDGPO
     C                   CLEAR                   *IN99
     C     POKEY         CHAIN     DGHDR                              99
     C                   MOVE      ' '           DGPRTF
     C                   UPDATE    DGHDR
     C                   CLEAR                   S1SEL
     C                   MOVE      ' '           S1PRTF
      *
     C                   ENDSL
      *
      *? Selection 9 - Close P/O
      *
     C     S1SEL         WHENEQ    '9'
     C     SSFLG1        ANDEQ     *BLANK
     C                   MOVE      S1YR#         #YRKEY
     C                   MOVE      S1PO#         #POKEY
     C                   CALL      'KP0018R '                           69
     C                   PARM                    #YRKEY
     C                   PARM                    #POKEY
     C                   SELECT
     C     #YRKEY        WHENEQ    'XX'                                         F3=EXIT
     C                   MOVE      *ON           *IN66
     C     #YRKEY        WHENNE    *BLANKS
     C                   MOVE      #YRKEY        M1POYR
     C                   MOVE      #POKEY        M1DGPO
     C                   ENDSL
     C                   MOVE      *ON           $$RLOD            1
     C                   CLEAR                   S1SEL
      *
      *? Invalid Option entered                           ?
      *
     C                   OTHER
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN39
     C                   MOVE      *OFF          $$RLOD
     C                   MOVE      'KP00003'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      YES           ERROR             3
     C                   CLEAR                   M1POYR
     C                   CLEAR                   M1DGPO
     C                   CLEAR                   M1VNDR
     C                   CLEAR                   M1DUDT
      *
E004 C                   ENDSL
E003 C                   ENDIF
      *
      *? Reset Indicators and Update subfile              ?
      *
     C                   UPDATE    S1DATA
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN39
     C     ERROR         IFEQ      YES
     C                   LEAVE                                                   END LOOP
     C                   END
      *
E002 C                   ENDIF
E001 C                   ENDDO
      *
     C     $$RLOD        IFEQ      *ON
     C                   MOVE      *ON           *IN28
     C                   EXSR      LOADSF
     C                   END
      *
     CSR                 ENDSR
      ********************************************************************
      * ?SRDEL  - Check for Delete option and process                   ?*
      ********************************************************************
     CSR   SRDEL         BEGSR
      *
      *?   Clear delete error flag                        ?             ?
      *
     C                   CLEAR                   WKDLER
      *
      *?   Clear the subfile                              ?             ?
      *
     C                   MOVE      *ON           *IN82
     C                   Z-ADD     *ZERO         S2RRN             5 0
     C                   WRITE     S2CNTL
     C                   CLEAR                   S2DATA
     C                   MOVE      *OFF          *IN82
      *
      *? Set loop -- read all changeG subfile records     ?             ?
      *
B001 C     *IN66         DOUEQ     '1'
     C                   READC     S1DATA                                 66
B002 C     *IN66         IFEQ      *OFF
      *
      *? Set Subfile Next Change                          ?             ?
      *
     C                   MOVE      *ON           *IN39
      *
      *? Check option entered against valid options array
      *
     C                   EXSR      $SSOPT
      *
      *? Selection 4 - Delete                             ?             ?
      *
B003 C     S1SEL         IFEQ      '4'
     C     SSFLG1        ANDEQ     *BLANK
     C*          SSFLG2    ANDEQ*BLANK
      *
      *? Check for receipts; if found, can not delete                   ?
      *
     C                   CLEAR                   *IN99
     C     S1KEY         SETLL     DGREC                                  99
B004 C     *IN99         IFEQ      *ON
     C                   MOVE      'KP00106'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      'Y'           WKDLER            1
     C                   ELSE
     C                   ADD       1             S2RRN
     C                   WRITE     S2DATA
     C                   CLEAR                   S1SEL
     C                   MOVE      *OFF          *IN39
E004 C                   ENDIF
E003 C                   END
      *
      *? Update Subfile 1                                 ?             ?
      *
     C                   UPDATE    S1DATA
E002 C                   END
E001 C                   END
      *
      *? If valid delete requested - process              ?             ?
      *
     C     S2RRN         IFGT      *ZEROS
     C     WKDLER        ANDEQ     *BLANK
     C                   Z-ADD     1             #2RRNO
      *
      *? Save number of records                           ?             ?
      *
     C                   Z-ADD     S2RRN         $2RRN             5 0
      *
      *? Delete message                                   ?             ?
      *
     C                   MOVE      'SR00004'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
      *
      *? Display the screen                               ?             ?
      *
     C                   WRITE     CFKY02
     C                   WRITE     MSGCTL
     C                   EXFMT     S2CNTL
      *
      *? Process each subfile record                      ?             ?
      *
     C     *IN12         IFEQ      *OFF
     C     1             DO        $2RRN         $$RRN             5 0
     C     $$RRN         CHAIN     S2DATA                             66
     C     *IN66         IFEQ      *OFF
     C                   MOVE      *ON           $$RLOD
     C                   MOVE      S1YR#         DGPOYR
     C                   MOVE      S1PO#         DGDGPO
     C     POKEY         CHAIN     DGHDR                              67
     C     *IN67         IFEQ      *OFF
     C                   DELETE    DGHDR
      *? Delete detail records                                          ?
     C                   CLEAR                   *IN68
     C     POKEY         SETLL     DGDTL
     C     POKEY         READE     DGDTL                                  68
     C     *IN68         DOWEQ     '0'
     C                   DELETE    DGDTL
     C     POKEY         READE     DGDTL                                  68
     C                   ENDDO
      *
     C                   END
     C                   END
     C                   END       1
     C                   END
      *
      *? Clear Messages                                   ?             ?
      *
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
     C                   END
      *
     CSR                 ENDSR
      ********************************************************************
      * ?BLNKSF - Clear the subfile and write one blank record          ?*
      ********************************************************************
     CSR   BLNKSF        BEGSR
      *
      * ?Clear Subfile Fields                             ?
      *
     C                   CLEAR                   S1DATA
      *
      *? Clear the subfile                                ?             ?
      *
     C                   MOVE      *ON           *IN80
     C                   Z-ADD     *ZERO         S1RRN             5 0
     C                   Z-ADD     1             ##RRNO
     C                   WRITE     S1CNTL
      *
      *? Write a blank, non-display record                ?             ?
      *
     C                   MOVE      *ON           *IN96
     C                   ADD       1             S1RRN
     C                   WRITE     S1DATA
     C                   MOVE      *OFF          *IN80
     C                   MOVE      *OFF          *IN96
      *
     CSR                 ENDSR
      *****************************************************************
      * ?$PRMPT - Handles F4 prompt function                       ? *
      *****************************************************************
     CSR   $PRMPT        BEGSR
      *
     C                   SELECT
      *
      *? Jobber Number
      *
     C     ##RCD         WHENEQ    'S1CNTL'
     C     ##FLD         ANDEQ     'M1VNDR'
     C                   MOVE      *BLANKS       @PVNDR            6
     C                   CALL      'VMIQ01R'
     C                   PARM                    @PVNDR
     C     @PVNDR        IFNE      *BLANKS
     C                   MOVEL     @PVNDR        M1VNDR
     C                   ENDIF
      *
     C                   OTHER
     C                   MOVE      YES           ERROR             3
     C                   MOVE      'XA10001'     $#MSID
     C                   EXSR      SRMSGF
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      * ?$CKDTE - Edit check any date                               ? *
      *****************************************************************
     CSR   $CKDTE        BEGSR
      *
      *?Clear error flag
      *
     C                   CLEAR                   WKDERR
      *
      *?Check for leap year
      *
     C     DSYY          DIV       4             CKLPYR            2 0
     C     CKLPYR        MULT      4             CKYY              2 0
      *
      *?Day must not be zero
      *
     C     DSDD          IFEQ      00
     C                   MOVE      'Y'           WKDERR            1
     C                   ELSE
      *
      *?Check for valid month/day
      *
     C                   SELECT
      *
      *?Jan, Mar, May, Jul, Aug, Oct, or Dec
      *
     C     DSMM          WHENEQ    01
     C     DSMM          OREQ      03
     C     DSMM          OREQ      05
     C     DSMM          OREQ      07
     C     DSMM          OREQ      08
     C     DSMM          OREQ      10
     C     DSMM          OREQ      12
     C     DSDD          IFGT      31
     C                   MOVE      'Y'           WKDERR
     C                   ENDIF
      *
      *?Feb & leap year
      *
     C     DSMM          WHENEQ    02
     C     DSYY          ANDEQ     CKYY
     C     DSDD          IFGT      29
     C                   MOVE      'Y'           WKDERR
     C                   ENDIF
      *
      *?Feb but not leap year
      *
     C     DSMM          WHENEQ    02
     C     DSYY          ANDNE     CKYY
     C     DSDD          IFGT      28
     C                   MOVE      'Y'           WKDERR
     C                   ENDIF
      *
      *?Apr, Jun, Sep, Nov
      *
     C     DSMM          WHENEQ    04
     C     DSMM          OREQ      06
     C     DSMM          OREQ      09
     C     DSMM          OREQ      11
     C     DSDD          IFGT      30
     C                   MOVE      'Y'           WKDERR
     C                   ENDIF
      *
      *?Any other month is invalid
      *
     C                   OTHER
     C                   MOVE      'Y'           WKDERR
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      * ?SRMSGF - Clear or send messages to Pgm msg queue               ?*
      ********************************************************************
     CSR   SRMSGF        BEGSR
      *
      *? Define Parameter List - define variables         ?
      *
     C     PLMSGF        PLIST
     C                   PARM                    $#PGMQ           10            Pgm Msg Queue
     C                   PARM                    $#MSGF           10            Message File
     C                   PARM                    $#MSGL           10            Library
     C                   PARM                    $#MSID            7            Message Id
     C                   PARM                    $#MSGD           80            Message Data
     C                   PARM                    $#MSKY            4            Message Key
     C                   PARM                    $#MSFN            1            Send or Clear
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
      * ?$SSPGM - Handles program security checking function        ? *
      *****************************************************************
     CSR   $SSPGM        BEGSR
      *
      *? Check for User ID in security file                             ?
      *
     C                   MOVEL     'INVPO'       USSYS
     C                   MOVEL     ##USER        USUSID
     C     USKEY         CHAIN     USERR                              99
      *
      *? If User ID found, check for option other than "N" or blank.    ?
      *?                                                                ?
     C     *IN99         IFEQ      '0'
     C                   DO        20            X                 2 0
     C     UF(X)         IFNE      'N'
     C     UF(X)         ANDNE     *BLANK
     C                   MOVE      'Y'           SECOK             1
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
      *? If User ID not found, or found & all "N" or blank,             ?
      *? issue error message and return.                                ?
      *
     C     *IN99         IFEQ      '1'
     C     SECOK         ORNE      'Y'
     C                   MOVE      'N'           #ESEC
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDIF
      *
      *? If passed security check, build valid options array            ?
      *? & valid options text for screen.                               ?
      *
      *
      *? Add records?                                                   ?
      *
     C     USFL01        IFNE      'N'
     C     USFL01        ANDNE     *BLANK
     C                   MOVE      *ON           *IN61
     C                   ENDIF
      *
      *? Change records?                                                ?
      *
     C     USFL02        IFNE      'N'
     C     USFL02        ANDNE     *BLANK
     C                   MOVEL     OTX(1)        WKOPT             1
     C                   ADD       1             O                 1 0
     C                   MOVE      WKOPT         OPT(O)
     C                   MOVEL     OTX(1)        WKOPTN           20
     C                   MOVEL     WKOPTN        C1OPTN
     C                   ENDIF
      *
      *? Delete records?                                                ?
      *
     C     USFL03        IFNE      'N'
     C     USFL03        ANDNE     *BLANK
     C                   MOVEL     OTX(2)        WKOPT
     C                   ADD       1             O
     C                   MOVE      WKOPT         OPT(O)
     C                   MOVEL     OTX(2)        WKOPTN
     C     C1OPTN        IFEQ      *BLANKS
     C                   MOVEL     WKOPTN        C1OPTN
     C                   ELSE
     C                   CAT       WKOPTN:2      C1OPTN
     C                   ENDIF
     C                   ENDIF
      *
      *? Inquiry allowed?                                               ?
      *
     C     USFL04        IFNE      'N'
     C     USFL04        ANDNE     *BLANK
     C                   MOVEL     OTX(3)        WKOPT
     C                   ADD       1             O
     C                   MOVE      WKOPT         OPT(O)
     C                   MOVEL     OTX(3)        WKOPTN
     C     C1OPTN        IFEQ      *BLANKS
     C                   MOVEL     WKOPTN        C1OPTN
     C                   ELSE
     C                   CAT       WKOPTN:2      C1OPTN
     C                   ENDIF
     C                   ENDIF
      *
      *? Receiving allowed?                                             ?
      *
     C     USFL05        IFNE      'N'
     C     USFL05        ANDNE     *BLANK
     C                   MOVEL     OTX(4)        WKOPT
     C                   ADD       1             O
     C                   MOVE      WKOPT         OPT(O)
     C                   MOVEL     OTX(4)        WKOPTN
     C     C1OPTN        IFEQ      *BLANKS
     C                   MOVEL     WKOPTN        C1OPTN
     C                   ELSE
     C                   CAT       WKOPTN:2      C1OPTN
     C                   ENDIF
     C                   ENDIF
      *
      *? Reprints allowed?                                              ?
      *
     C     USFL06        IFNE      'N'
     C     USFL06        ANDNE     *BLANK
     C                   MOVE      *ON           *IN62
     C                   MOVEL     OTX(5)        WKOPT
     C                   ADD       1             O
     C                   MOVE      WKOPT         OPT(O)
     C                   MOVEL     OTX(5)        WKOPTN
     C     C1OPTN        IFEQ      *BLANKS
     C                   MOVEL     WKOPTN        C1OPTN
     C                   ELSE
     C                   CAT       WKOPTN:2      C1OPTN
     C                   ENDIF
     C                   ENDIF
      *
      *? Close allowed?                                                 ?
      *
     C     USFL08        IFNE      'N'
     C     USFL08        ANDNE     *BLANK
     C                   MOVEL     OTX(6)        WKOPT
     C                   ADD       1             O
     C                   MOVE      WKOPT         OPT(O)
     C                   MOVEL     OTX(6)        WKOPTN
     C     C1OPTN        IFEQ      *BLANKS
     C                   MOVEL     WKOPTN        C1OPTN
     C                   ELSE
     C                   CAT       WKOPTN:2      C1OPTN
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * ?$SSOPT - Handles selection security checking function      ? *
      *****************************************************************
     CSR   $SSOPT        BEGSR
      *
      *? Check option entered against valid options array
      *
     C                   CLEAR                   SSFLG1
     C*                    CLEARSSFLG2
      *
      *? Does option exist in array?
      *
     C                   Z-ADD     1             XX                1 0
     C     S1SEL         LOOKUP    OPT(XX)                                91
      *
      *? If not in array, set security flag 1 = N.
      *
     C     *IN91         IFEQ      '0'
     C                   MOVE      'N'           SSFLG1            1
     C*                    ELSE
      *
      *? If in array, check for valid P/O type for function performed
      *
     C     S1SEL         IFEQ      '2'
     C     USFL02        ANDEQ     'N'
     C     S1RCID        ANDEQ     'IM'
     C*          S1SEL     OREQ '2'
     C*          USFL02    ANDEQ'J'
     C*          S1RCID    ANDEQ'RM'
      *
     C     S1SEL         OREQ      '4'
     C     USFL03        ANDEQ     'N'
     C     S1RCID        ANDEQ     'IM'
     C*          S1SEL     OREQ '4'
     C*          USFL03    ANDEQ'J'
     C*          S1RCID    ANDEQ'RM'
      *
     C     S1SEL         OREQ      '5'
     C     USFL04        ANDEQ     'N'
     C     S1RCID        ANDEQ     'IM'
     C*          S1SEL     OREQ '5'
     C*          USFL04    ANDEQ'J'
     C*          S1RCID    ANDEQ'RM'
      *
     C     S1SEL         OREQ      '6'
     C     USFL05        ANDEQ     'N'
     C     S1RCID        ANDEQ     'IM'
     C*          S1SEL     OREQ '6'
     C*          USFL05    ANDEQ'J'
     C*          S1RCID    ANDEQ'RM'
      *
     C     S1SEL         OREQ      '7'
     C     USFL06        ANDEQ     'N'
     C     S1RCID        ANDEQ     'IM'
     C*          S1SEL     OREQ '7'
     C*          USFL06    ANDEQ'J'
     C*          S1RCID    ANDEQ'RM'
      *
     C     S1SEL         OREQ      '9'
     C     USFL08        ANDEQ     'N'
     C     S1RCID        ANDEQ     'IM'
     C*          S1SEL     OREQ '9'
     C*          USFL08    ANDEQ'J'
     C*          S1RCID    ANDEQ'RM'
      *
      *? If invalid P/O type, set security flag 2 = N.
      *
     C                   MOVE      'N'           SSFLG2            1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      *?$CKPRT - Checks for P/O's selected to print                     ?*
      ********************************************************************
     C     $CKPRT        BEGSR
      *
      *? Check if any P/O's are ready to print.
      *
     C                   CLEAR                   WKPRT
     C     *LOVAL        SETLL     HDRL1
     C                   READ      HDRL1                                  99
     C     *IN99         IFEQ      '1'
     C*                    MOVE 'N'       WKPRT   1
     C                   MOVE      ' '           WKPRT             1
     C                   ENDIF
      *
      *? If any P/O's are found to print, check for specific type of
      *? P/O if USFL06 is not "Y" (Yes).
      *
     C     WKPRT         IFEQ      *BLANK
     C     USFL06        ANDNE     'Y'
      *
     C                   SELECT
     C     USFL06        WHENEQ    'Y'
     C     *LOVAL        SETLL     HDRL5
     C                   READ      HDRL5                                  99
     C                   ENDSL
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      USFL06        WKPRT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      * ?       Program Initialization and Housekeeping                 ?*
      ********************************************************************
     CSR   *INZSR        BEGSR
      *
      * Define *ENTRY plist?
     C     *ENTRY        PLIST
     C                   PARM                    #ESEC             1
      *
      * Define *LIKE Fields ?
      *
     C     *LIKE         DEFINE    #SFLPG        ##ROLL
     C     *LIKE         DEFINE    #SFLPG        ##FWRL
     C     *LIKE         DEFINE    #SFLPG        ##LOAD
     C     *LIKE         DEFINE    M1POYR        SVPOYR
     C     *LIKE         DEFINE    M1DGPO        SVDGPO
     C     *LIKE         DEFINE    M1VNDR        SVVNDR
     C     *LIKE         DEFINE    M1DUDT        SVDUDT
      *
      * Define Key Lists ?
      *
      *
      * ?KLIST for Security file by User ID
      *
     C     USKEY         KLIST
     C                   KFLD                    USSYS
     C                   KFLD                    USUSID
      *
      * ?KLIST for PO's by PO number
      *
     C     POKEY         KLIST
     C                   KFLD                    DGPOYR
     C                   KFLD                    DGDGPO
      *
     C     S1KEY         KLIST
     C                   KFLD                    S1YR#
     C                   KFLD                    S1PO#
      *
      * ?KLIST for PO's by Jobber Number
      *
     C     DGKEY         KLIST
     C                   KFLD                    DGVNDR
      *
      * ?KLIST for PO's by Due Date
      *
     C     DDKEY         KLIST
     C                   KFLD                    DGPODC
     C                   KFLD                    DGPODY
     C                   KFLD                    DGPODM
     C                   KFLD                    DGPODD
      *
      * ?KLIST for FMVEND
      *
     C     VMKEY         KLIST
     C*                    KFLD           CORP#
     C                   KFLD                    PVEND#
      *
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
      *? Check security                                                 ?
      *
     C                   EXSR      $SSPGM
      *
      *? Initial subfile load                             ?             ?
      *
     C                   MOVE      *OFF          $$LOAD            1
      *
      *?Set initial subfile mode - Fold/Truncate  ECT...           *OFF/*ON
     C                   MOVE      *ON           *IN30                                      /Trnc.
     C                   MOVE      *ON           *IN83                          SFLMODE Fold/Trnc.
     C                   MOVE      *IN83         ##SFLM
      *
      *?Set  SFL PAGE Size and SFL Size
      *?#FWRL - Multiple Page Size by # of Pages to LOAD on ROLL FWD/BACK
      *?#LOAD - Multiple Page Size by # of Pages to LOAD on POSITION TO
.    C                   Z-ADD     6             #SFLPG            4 0          SFLPAG(7) Folded Siz
.    C                   Z-ADD     2             ##FWRL                         SFL Roll Forward 14
.    C                   Z-ADD     4             ##LOAD                         SFL Load 28 Records
      *
      *? Initialize status option, sort flag, & F11 text              ?        ?
     C                   MOVE      OPEN          WKOST             1
     C                   MOVE      BYPO          WKSORT            1
     C                   MOVEL     @CF11H        C1F11
     C                   MOVE      @CUNDO        UNDER
      *
      *? Initial Sub File Load.                                  ?             ?
     C                   MOVE      NO            NMFLAG            3
     C                   EXSR      LOADSF
      *
     CSR                 ENDSR
      *****************************************************************
      * ?$PPRMT - Handles F4 prompt function                       ? *
      *****************************************************************
     CSR   $PPRMT        BEGSR
      *
     C                   SELECT
      *
      *? Printer ID
      *
     C     ##RCD         WHENEQ    'S1DATA'
     C     S1OUTQ        ANDEQ     '?'
     C                   CLEAR                   @PELM#
     C                   MOVE      'I'           INQ               1
     C                   CALL      'PRTTABLR'
     C                   PARM                    @PELM#           10
     C                   PARM                    INQ
     C     @PELM#        IFNE      *BLANKS
     C                   MOVEL     @PELM#        S1OUTQ
     C                   ENDIF
      *
     C*                    OTHER
     C*                    MOVE *ON       *IN74
     C                   ENDSL
      *
     C                   ENDSR
** OTX - Valid options
2=Change
4=Delete
5=Inquire
6=Receive
7=Reprint
9=Close
