      *%*******************************************************************
      *%                                                                 **
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- Inventory                                       **
      *%                                                               ?**
      *********************************************************************
      *                                                                   *
      * Program?- INV001R                                                *
      *                                                                   *
      * Purpose?- Product Class Selection Program                        *
      *                                                                   *
      *   Date  ?Programmer    ? Comment                             ? *
      *  08/12/03  R. Piasecki      Program Created                       *
      *                                                                   *
      *********************************************************************
     FSECUSER   IF   E           K DISK
     FFMPRCL    UF   E           K DISK
     FFMPRCLL1  IF   E           K DISK
     F                                     RENAME(RMPRCL:ITCNM)
     F                                     INFDS(INFDS1)
     FFMINVTPC  IF   E           K DISK
     FINV001S   CF   E             WORKSTN
     F                                     SFILE(S1DATA:S1RRN)
     F                                     SFILE(S2DATA:S2RRN)
     F                                     INFDS(INFDS3)
      ********************************************************************
      * ?Tables & arrays                                                ?*
      ********************************************************************
     D OTX             S             15    DIM(3) CTDATA PERRCD(1)
     D OPT             S              1    DIM(3)
      ********************************************************************
      * ?File Information Data Structure                                ?*
      ********************************************************************
     D INFDS1          DS
     D  $1RRN#               397    400B 0
     D INFDS2          DS
     D  $2RRN#               397    400B 0
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
      ********************************************************************
      * ?Breakdown of message data                                      ?*
      ********************************************************************
     D                 DS                  INZ
     D  $#MSGD                 1     80
     D  #MPITM                 1      3P 0
      *****************************************************************
      * ?Define Program Constants                                   ? *
      *****************************************************************
     D YES             C                   CONST('YES')
     D NO              C                   CONST('NO ')
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
     C*          *IN12     OREQ *ON
     C                   MOVE      YES           ENDPGM            3
      *
      *? F1 - Cursor Help                                 ?
     C     *IN01         WHENEQ    '1'
     C                   EXSR      SRCHLP
      *
      *?  F6 - Add new Class
     C     *IN06         WHENEQ    '1'
     C                   MOVE      C1RCID        #PPRD#            2
     C                   CALL      'INV002R '                           69
     C                   PARM                    #PPRD#
     C                   PARM      'A'           #PACTN            1
     C     #PPRD#        IFNE      *BLANKS
     C                   MOVE      #PPRD#        C1RCID
     C                   EXSR      LOADSF
     C                   END
      *
      *? Position to requested -- change in CHAIN/NAME    ?
     C     *IN28         WHENEQ    *ON
      *
      * ?If first position of description is "?", set scan flag         ?*
     C                   MOVE      'N'           WKSCAN            1
     C                   MOVEL     C1NAME        CKSCAN            1
     C                   MOVE      C1NAME        CKDESC           29
     C     CKSCAN        IFEQ      '?'
     C     CKDESC        ANDNE     *BLANKS
     C                   MOVE      'Y'           WKSCAN
     C     ' '           CHECKR    CKDESC        I                 2 0
     C                   ENDIF
      *
      *? Should SFL be Ordered By CLASS# and NAME or NAME    Only       ?
      *? Remains the same if Both are Blanks.
     C     C1RCID        IFEQ      *ZERO
     C     C1NAME        ANDNE     *BLANKS
     C     WKSCAN        ANDEQ     'N'
     C                   MOVE      YES           NMFLAG
     C                   ELSE
     C                   MOVE      NO            NMFLAG
     C                   ENDIF
     C                   EXSR      LOADSF
      *
      *    ?Postioned Past EOF, Load Prior Page if Not BOF
     C     S1RRN         IFEQ      *ZEROS
     C     $$BOF         IFNE      *ON
     C                   EXSR      BACKSF
     C                   ELSE
      *    ?ELSE  Subfile Empty Write One Blank SFL Record (ND PR)
     C                   MOVE      'INV0021'     $#MSID                         ?Message Id   ?
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
      *? Process SFL Input               ?
     C     $$LOAD        WHENEQ    '1'
     C                   EXSR      READSF
     C                   MOVE      'INV0021'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
      *? No Records Loaded to SFL
     C                   OTHER
     C                   Z-ADD     1             ##RRNO
     C                   MOVE      'SR00009'     $#MSID                         ?Message Id   ?
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
      * ?LOADSF - Load the Customer Master Display                      ?*
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
     C                   MOVEL     C1RCID        SVITC#
     C                   MOVEL     C1NAME        SVNAME
      *
      *? Set File Position                                ?             ?
     C                   SELECT
     C     *IN28         WHENEQ    *OFF
     C                   MOVE      *LOVAL        PCPRCL
     C                   MOVE      *LOVAL        PCDESC
     C     WKSCAN        WHENEQ    'Y'
     C                   MOVEL     C1RCID        PCPRCL
     C                   MOVE      *LOVAL        PCDESC
     C                   OTHER
     C                   MOVEL     C1RCID        PCPRCL
     C                   MOVEL     C1NAME        PCDESC
     C                   ENDSL
      *
      *? Check for BOF                                    ?             ?
     C                   SELECT
     C     NMFLAG        WHENEQ    YES
     C     ICKEY2        SETLL     ITCNM
     C                   READPE    ITCNM                                  66
     C     WKSCAN        WHENEQ    'N'
     C     ICKEY         SETLL     RMPRCL
     C                   READPE    RMPRCL                                 66
     C     WKSCAN        WHENEQ    'Y'
     C     ICKEY         SETLL     RMPRCL
     C                   EXSR      $READP
     C                   ENDSL
      *
     C     *IN66         IFEQ      *ON
     C                   MOVE      *ON           $$BOF             1
     C                   ENDIF
      *
      *? Reposition after BOF Check                       ?             ?
     C                   SELECT
     C     *IN28         WHENEQ    *OFF
     C                   MOVE      *LOVAL        PCPRCL
     C                   MOVE      *LOVAL        PCDESC
     C     WKSCAN        WHENEQ    'Y'
     C                   MOVEL     C1RCID        PCPRCL
     C                   MOVE      *LOVAL        PCDESC
     C                   OTHER
     C                   MOVEL     C1RCID        PCPRCL
     C                   MOVEL     C1NAME        PCDESC
     C                   ENDSL
      *
     C     NMFLAG        IFEQ      YES
     C     ICKEY2        SETLL     ITCNM
     C                   ELSE
     C     ICKEY         SETLL     RMPRCL
     C                   END
      *
     C                   CLEAR                   C1RCID
     C     WKSCAN        IFNE      'Y'
     C                   CLEAR                   C1NAME
     C                   ENDIF
     C                   MOVE      *OFF          $EXLOD            1
     C                   MOVE      *OFF          $EOF              1
     C                   MOVE      *ON           *IN81
      *
      *? Read Loop                                        ?             ?
      *
     C     $EXLOD        DOUEQ     *ON
      *
     C                   SELECT
     C     NMFLAG        WHENEQ    YES
     C                   READ      ITCNM                                  66
     C     WKSCAN        WHENNE    'Y'
     C                   READ      RMPRCL                                 66
     C     WKSCAN        WHENEQ    'Y'
     C                   EXSR      $READ
     C                   ENDSL
      *
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
     C                   MOVE      'INV0021'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   ELSE
      *
      *? If no records loaded                             ?
      *
     C                   MOVE      *OFF          $$LOAD            1
     C                   EXSR      BLNKSF
     C                   MOVE      'SR00009'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   END
      *
     CSR                 ENDSR
      ********************************************************************
      * ?LOAD## - Load the ITEM CLASS  Display                          ?*
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
      *
     C     $EXLOD        DOUEQ     *ON
      *
     C                   SELECT
     C     NMFLAG        WHENEQ    YES
     C                   READ      ITCNM                                  66
     C     WKSCAN        WHENNE    'Y'
     C                   READ      RMPRCL                                 66
     C     WKSCAN        WHENEQ    'Y'
     C                   EXSR      $READ
     C                   ENDSL
      *
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
      *****************************************************************
      * ?MOV@S1 - Move File Fields to SFL Dispaly Output Fields     ? *
      *****************************************************************
     CSR   MOV@S1        BEGSR
      *
      *
      * ?Customer Master File Fields.                    ?
      *
     C                   MOVEL     PCPRCL        S1RCID
     C                   MOVEL     PCDESC        S1NAME
     C                   Z-ADD     PCSDTF        S1FROM
     C                   MOVEL     PCSDTT        S1TO
      *
     CSR                 ENDSR
      *****************************************************************
      * ?BACKSF - Roll Back File One Page of SFL Records            ? *
      *****************************************************************
     CSR   BACKSF        BEGSR
      *
      *? Restore Saved Position to Fields from last SFL Load            ?
      *
     C                   MOVE      SVITC#        C1RCID
     C                   MOVE      SVNAME        C1NAME
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
     C                   MOVE      C1RCID        PCPRCL
     C                   MOVE      C1NAME        PCDESC
      *
     C     NMFLAG        IFEQ      YES
     C     ICKEY2        SETLL     ITCNM
     C                   ELSE
     C     ICKEY         SETLL     RMPRCL
     C                   ENDIF
      *
     C     1             DO        ##ROLL
      *
     C                   SELECT
     C     NMFLAG        WHENEQ    YES
     C                   READP     ITCNM                                  66
     C     WKSCAN        WHENNE    'Y'
     C                   READP     RMPRCL                                 66
     C     WKSCAN        WHENEQ    'Y'
     C                   EXSR      $READP
     C                   ENDSL
      *
     C     *IN66         IFEQ      *ON
.    C                   MOVE      *LOVAL        PCPRCL
.    C                   MOVE      *LOVAL        PCDESC
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
.    C                   MOVE      PCPRCL        C1RCID
.    C                   MOVE      PCDESC        C1NAME
.    C                   MOVE      *ON           *IN28
     C                   EXSR      LOADSF
      *
     CSR                 ENDSR
      ********************************************************************
      * ?$READP - Performs read prior on file currently being read      ?*
      ********************************************************************
     CSR   $READP        BEGSR
      *
      * ?Initialize read loop                                           ?*
     C                   CLEAR                   *IN66
     C                   MOVE      'Y'           WKREAD            1
      *
      * ?Read as long as read flag stays on                             ?*
     C     WKREAD        DOWEQ     'Y'
     C     PCPRCL        READPE    RMPRCL                                 66
      *                                                                 ?*
      * ?If beginning of file, or scan flag is not set, leave loop.     ?*
      * ?If scan flag is set, check description for scan value.         ?*
      *
     C                   SELECT
      *
     C     *IN66         WHENEQ    '1'
     C     WKSCAN        ORNE      'Y'
     C                   MOVE      'N'           WKREAD
      *
     C     WKSCAN        WHENEQ    'Y'
     C     CKDESC:I      SCAN      PCDESC        III               2 0
     C     III           IFNE      0
     C                   MOVE      'N'           WKREAD
     C                   ENDIF
      *
     C                   ENDSL
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
      * ?$READ - Performs read on file currently being read             ?*
      ********************************************************************
     CSR   $READ         BEGSR
      *
      * ?Initialize read loop                                           ?*
     C                   CLEAR                   *IN66
     C                   MOVE      'Y'           WKREAD            1
      *
      * ?Read as long as read flag stays on                             ?*
     C     WKREAD        DOWEQ     'Y'
     C                   READ      RMPRCL                                 66
      *                                                                 ?*
      * ?If end of file, or scan flag is not set, leave loop.           ?*
      * ?If scan flag is set, check description for scan value.         ?*
      *
     C                   SELECT
      *
     C     *IN66         WHENEQ    '1'
     C     WKSCAN        ORNE      'Y'
     C                   MOVE      'N'           WKREAD
      *
     C     WKSCAN        WHENEQ    'Y'
     C     CKDESC:I      SCAN      PCDESC        III               2 0
     C     III           IFNE      0
     C                   MOVE      'N'           WKREAD
     C                   ENDIF
      *
     C                   ENDSL
     C                   ENDDO
      *
     C                   ENDSR
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
      *
     C     S1SEL         WHENEQ    '2'
     C     SSFLG1        ANDEQ     *BLANK
     C                   MOVE      S1RCID        #PPRD#            2
     C                   MOVE      *OFF          EOJ               1
     C                   CALL      'INV002R '                           69
     C                   PARM                    #PPRD#
     C                   PARM      'U'           #PACTN            1
     C     EOJ           IFEQ      *ON                                          F3=EXIT
     C                   MOVE      *ON           *INLR
     C                   MOVE      YES           ENDPGM
     C                   LEAVE
     C                   ENDIF
     C     #PPRD#        IFEQ      '  '                                         F3=EXIT
     C                   MOVE      *ON           *IN66
     C                   END
     C     #PPRD#        IFNE      *BLANKS
     C                   MOVE      #PPRD#        C1RCID
     C                   MOVE      *ON           $$RLOD            1
     C                   END
     C                   CLEAR                   S1SEL
      *
      *
      *? Selection 5 - Inquire
      *
     C     S1SEL         WHENEQ    '5'
     C     SSFLG1        ANDEQ     *BLANK
     C                   MOVE      S1RCID        #PPRD#            2
     C                   CALL      'INV002R '                           69
     C                   PARM                    #PPRD#
     C                   PARM      'I'           #PACTN            1
     C     #PPRD#        IFEQ      '  '                                         F3=EXIT
     C                   MOVE      *ON           *IN66
     C                   END
     C     #PPRD#        IFNE      *BLANKS
     C                   MOVE      #PPRD#        C1RCID
     C                   MOVE      *ON           $$RLOD            1
     C                   END
     C                   CLEAR                   S1SEL
      *
      *? Invalid Option entered                           ?
      *
     C                   OTHER
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN39
     C                   MOVE      *OFF          $$RLOD
     C                   MOVE      'SR00003'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      YES           ERROR             3
     C                   CLEAR                   C1RCID
     C     WKSCAN        IFNE      'Y'
     C                   CLEAR                   C1NAME
     C                   ENDIF
      *
E004 C                   ENDSL
      *
      *? Reset Indicators and Update subfile              ?
      *
     C                   UPDATE    S1DATA
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN39
     C     ERROR         IFEQ      YES
     C                   LEAVE                                                   END LOOP
E004 C                   ENDIF
E003 C                   ENDIF
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
      *?   Clear the subfile                              ?             ?
      *
     C                   MOVE      *ON           *IN82
     C                   Z-ADD     *ZERO         S2RRN             5 0
     C                   WRITE     S2CNTL
     C                   CLEAR                   S2DATA
     C                   MOVE      *OFF          *IN82
      *
      *? Set loop -- read all changed subfile records     ?             ?
      *
     C     *IN66         DOUEQ     '1'
     C                   READC     S1DATA                                 66
     C     *IN66         IFEQ      *OFF
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
     C     S1SEL         IFEQ      '4'
     C     SSFLG1        ANDEQ     *BLANK
     C     SSFLG2        ANDEQ     *BLANK
     C                   MOVE      S1RCID        PCPRCL
     C                   EXSR      CHKINV
     C     ERROR         IFNE      YES
     C     ICKEY         CHAIN     RMPRCL                             67
     C                   ADD       1             S2RRN
     C                   WRITE     S2DATA
     C                   CLEAR                   S1SEL
     C                   MOVE      *OFF          *IN39
     C                   ENDIF
     C                   END
      *
      *? Update Subfile 1                                 ?             ?
      *
     C                   UPDATE    S1DATA
     C                   END
     C                   END
      *
      *? If valid delete requested - process              ?             ?
      *
     C     S2RRN         IFGT      *ZEROS
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
     C                   MOVE      S1RCID        PCPRCL
     C     ICKEY         CHAIN     RMPRCL                             67
     C     *IN67         IFEQ      *OFF
     C                   DELETE    RMPRCL
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
     C                   MOVEL     'PRDCLAS'     USSYS
      *
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
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDIF
      *
      *? If passed security check, build valid options array            ?
      *? & valid options text for screen.                               ?
      *
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
     C                   CAT       WKOPTN:3      C1OPTN
     C                   ENDIF
     C                   ENDIF
      *
      *? Inquiry?                                                       ?
      *
     C     USFL04        IFNE      'N'
     C     USFL04        ANDNE     *BLANK
     C                   MOVEL     OTX(3)        WKOPT             1
     C                   ADD       1             O                 1 0
     C                   MOVE      WKOPT         OPT(O)
     C                   MOVEL     OTX(3)        WKOPTN           20
     C     C1OPTN        IFEQ      *BLANKS
     C                   MOVEL     WKOPTN        C1OPTN
     C                   ELSE
     C                   CAT       WKOPTN:1      C1OPTN
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      * ?$SSOPT - Handles selection security checking function      ? *
      *****************************************************************
     CSR   $SSOPT        BEGSR
      *
      *? Check option entered against valid options array
      *
     C                   CLEAR                   SSFLG1
     C                   CLEAR                   SSFLG2
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
     C                   MOVE      ' '           SSFLG2            1
     C                   ELSE
      *
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * ?CHKINV - Check Item Master for records with Product Class  ? *
      * ?being deleted                                              ? *
      *****************************************************************
     CSR   CHKINV        BEGSR
      *
      *? Does Product class exists in any item?
      *
     C     ICKEY         CHAIN     FMINVTPC                           75
     C     *IN75         IFEQ      *OFF
     C                   MOVE      'INV0011'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      YES           ERROR
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      * ?       Program Initialization and Housekeeping                 ?*
      ********************************************************************
     CSR   *INZSR        BEGSR
      *
      *
      * Define *LIKE Fields ?
      *
     C     *LIKE         DEFINE    #SFLPG        ##ROLL
     C     *LIKE         DEFINE    #SFLPG        ##FWRL
     C     *LIKE         DEFINE    #SFLPG        ##LOAD
     C     *LIKE         DEFINE    C1RCID        SVITC#
     C     *LIKE         DEFINE    C1NAME        SVNAME
      *
      * Define Key Lists ?
      *
      * ?KLIST for Security file by User ID
      *
     C     USKEY         KLIST
     C                   KFLD                    USSYS
     C                   KFLD                    USUSID
      *
      * ?KLIST for file - PRPRODPF Library - *LIBL     ?
      * ?LF - by CLASS                               ?
      * ?D+W ITEM CLASS Master                               ?
      *
      *
     C     ICKEY         KLIST
     C                   KFLD                    PCPRCL
      * ?KLIST for file - DGCLASL1    Library - *LIBL     ?
      * ?LF - by NAME,ITEM CLASS                ?
     C     ICKEY2        KLIST
     C                   KFLD                    C1NAME
      *
      * ?KLIST for file - FMINVT   Library - *LIBL     ?
      * ?PRODUCT MASTER FILE                         ?
      *
      *
     C*          PRKEY     KLIST
     C*                    KFLD           ICDKEY
      *
     C                   MOVE      *ON           *IN75
     C*                    MOVE 'A'       PCSTAT
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
      *?Set initial subfile mode - Fold/Truncate  ETC...           *OFF/*ON
     C                   MOVE      *OFF          $$LOAD            1
     C                   MOVE      *ON           *IN83                          SFLMODE Fold/Trnc.
     C                   MOVE      *IN83         ##SFLM
      *
      *?Set  SFL PAGE Size and SFL Size
      *?#FWRL - Multiple Page Size by # of Pages to LOAD on ROLL FWD/BACK
      *?#LOAD - Multiple Page Size by # of Pages to LOAD on POSITION TO
.    C                   Z-ADD     7             #SFLPG            4 0          SFLPAG(7) Folded Siz
.    C                   Z-ADD     2             ##FWRL                         SFL Roll Forward 14
.    C                   Z-ADD     4             ##LOAD                         SFL Load 28 Records
      *
      *? Initial Sub File Load.                                  ?             ?
     C                   MOVE      NO            NMFLAG            3
     C                   MOVE      NO            WKSCAN
     C                   EXSR      LOADSF
      *
     CSR                 ENDSR
** OTX - Valid options
2=Change
4=Delete
5=Inquire
