      *%*******************************************************************
      *%                                                                 **
      *%  ?                     ?                                        **
      *%  ?                     ?                                        **
      *%                        ?                                        **
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- Table File Element Master Maintenance           **
      *%                                                                 **
      *%  ?                     ?                                        **
      *%  ?                     ?                                        **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- XATABLE                                                *
      *                                                                   *
      * Purpose?- Table File Element Maintenance Selection               *
      *                                                                   *
      *   Date  ?Programmer    ? Comment                             ? *
      *   5/16/03  R. Piasecki      Program Created                       *
      *                                                                   *
      *********************************************************************
     FXATABL    UF   E           K DISK
     FXATABLSD  IF   E           K DISK
     F                                     RENAME(TBMASTR:MASTKS)
     FXATABE1   IF   E           K DISK
     F                                     RENAME(TBMASTR:MASTKY)
     F                                     INFDS(INFDS1)
     FXATABES   CF   E             WORKSTN
     F                                     SFILE(S1DATA:S1RRN)
     F                                     SFILE(S2DATA:S2RRN)
     F                                     INFDS(INFDS3)
      ********************************************************************
      * ?Tables & Arrays                                                ?*
      ********************************************************************
     D OPT             S              9    DIM(2) CTDATA PERRCD(1)
     D VOP             S              1    DIM(9)
     D OTX             S             70    DIM(2) CTDATA PERRCD(1)
      ********************************************************************
      * ?File Information Data Structure                                ?*
      ********************************************************************
     D INFDS1          DS
     D  $1RRN#               397    400B 0
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
      *****************************************************************
      * ?Define Program Constants                                   ? *
      *****************************************************************
     D YES             C                   CONST('YES')
     D NO              C                   CONST('NO ')
     D DFTVAL          C                   CONST('*DEFAULT  ')
     D SERS            C                   CONST('SERLSTATUS')
     D NONE            C                   CONST('*NONE')
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
     C*
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
      * ?F11 pressed                                ?
     C     *IN11         WHENEQ    *ON
     C                   If        *In71 = *On
     C                   Eval      *In71 = *Off
     C                   Else
     C                   Eval      *In71 = *On
     C                   EndIf
     C                   Clear                   SVTBNO
     C                   Clear                   SVTBSD
     C                   CLEAR                   TBC6
     C                   CLEAR                   TBC6SD
     C                   EXSR      LOADSF
      *
      * ?F3 or F12 pressed                                ?
     C     *IN03         WHENEQ    *ON
     C     *IN12         OREQ      *ON
     C                   MOVE      YES           ENDPGM            3
      *
      *? F1 - Cursor Help                                 ?
     C     *IN01         WHENEQ    '1'
     C                   EXSR      SRCHLP
      *
      *?  F6 - Add new Record
     C     *IN06         WHENEQ    '1'
     C                   MOVEL(P)  TABELM        #ETAB#            8
     C                   MOVE      '00'          #KEY#             2
     C                   CALL      'XATABLE1'                           69
     C                   PARM                    #ETAB#
     C                   PARM                    #KEYP#
     C     #ETAB#        IFNE      *BLANKS
     C                   MOVEL     #ETAB#        TABELM
     C                   MOVE      #ETAB#        TBC6
     C     #ETAB#        IFEQ      'BR'
     C                   MOVE      *ON           *IN75
     C                   ENDIF
     C                   EXSR      LOADSF
     C                   END
      *
      *
      *    ?Postioned Past EOF, Load Prior Page if Not BOF
     C     S1RRN         IFEQ      *ZEROS
     C     $$BOF         IFNE      *ON
     C                   EXSR      BACKSF
     C                   ELSE
      *    ?ELSE  Subfile Empty Write One Blank SFL Record (ND PR)
     C                   MOVE      'TBE1001'     $#MSID                         ?Message Id   ?
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
     C*                    MOVE 'SF00101' $#MSID           ?Message Id   ?
     C*                    EXSR SRMSGF
      *
      *? No Records Loaded to SFL
     C                   OTHER
     C                   Z-ADD     1             ##RRNO
     C                   MOVE      'SF00102'     $#MSID                         ?Message Id   ?
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
      * ?LOADSF - Load the RECORD File Master Display                   ?*
      ********************************************************************
     CSR   LOADSF        BEGSR
      *
      *? Set Roll Forward by Load Factor set in *INZSR                  ?
      *
     C*          #SFLPG    MULT ##LOAD    ##ROLL
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
     C                   MOVEL     TBC6          SVTBNO
     C                   MOVEL     TBC6SD        SVTBSD
      *
      *
      *? Check for BOF                                    ?             ?
     C   71TBKEY         SETLL     XATABE1
     C  N71TBKEYsd       SETLL     XATABLSD
     C   71TABELM        READPE    XATABE1                                66
     C  N71TABELM        READPE    XATABLSD                               66
     C   71TBKEY         SETLL     XATABE1
     C  N71TBKEYsd       SETLL     XATABLSD
      *
     C                   CLEAR                   TBC6
     C                   CLEAR                   TBC6SD
     C                   MOVE      *OFF          $EXLOD            1
     C                   MOVE      *OFF          $EOF              1
     C                   MOVE      *ON           *IN81
      *
      *? Read Loop                                        ?             ?
      *
     C     $EXLOD        DOUEQ     *ON
     C   71TABELM        READE     XATABE1                                66
     C  N71TABELM        READE     XATABLSD                               66
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
     C     S1RRN         IFEQ      26
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
     C                   MOVE      'TBE1001'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   ELSE
      *
      *? If no records loaded                             ?
      *
     C                   MOVE      *OFF          $$LOAD            1
     C                   EXSR      BLNKSF
     C                   MOVE      'TBE1002'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   END
      *
     CSR                 ENDSR
      ********************************************************************
      * ?LOAD## - Load the Element Master Display                       ?*
      ********************************************************************
     CSR   LOAD##        BEGSR
      *
      *? Set Roll to SFLPAG * Roll Forward Factor                       ?
      *
     C*          #SFLPG    MULT ##FWRL    ##ROLL
      *
      *? Read Loop                                        ?             ?
     C                   CLEAR                   WRKFLG
      *
     C                   MOVE      *OFF          $EXLOD            1
     C                   MOVE      *OFF          $EOF
     C                   MOVE      *ON           *IN81
     C                   Z-ADD     *ZEROS        $COUNT            5 0
     C                   Z-ADD     MXRRN         S1RRN
     C     $EXLOD        DOUEQ     *ON
     C   71TABELM        READE     XATABE1                                66
     C  N71TABELM        READE     XATABLSD                               66
     C     *IN66         IFEQ      *ON
     C                   MOVE      *ON           $EOF              1
     C                   MOVE      *ON           $EXLOD            1
     C                   MOVE      *OFF          *IN81
     C     WRKFLG        IFEQ      *BLANKS
     C                   MOVE      'Y'           WRKFLG            1
     C                   MOVEL     TBC6          SVTBNO
     C                   MOVEL     TBC6SD        SVTBSD
     C                   ENDIF
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
     C     $COUNT        IFEQ      13
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
      * ?MOV@S1 - Move File Fields to SFL Display Output Fields     ? *
      *****************************************************************
     CSR   MOV@S1        BEGSR
      *
      *
      * ?Record Master File Fields.                    ?
      *
     C                   MOVEL     TBC6          S1ELM#
     C                   MOVEL     TBSHRT        S1ANAM
     C                   MOVEL     TBLONG        S1NAME
     C   75              MOVEL     TBBROK        S1BROK
      *
     CSR                 ENDSR
      *****************************************************************
      * ?BACKSF - Roll Back File One Page of SFL Records            ? *
      *****************************************************************
     CSR   BACKSF        BEGSR
      *
      *? Restore Saved Position to Fields from last SFL Load            ?
      *
     C                   MOVE      SVTBNO        TBC6
     C                   MOVE      SVTBSD        TBC6SD
     C   71TBKEY         SETLL     XATABE1
     C  N71TBKEYSD       SETLL     XATABLSD
      *
     C     1             DO        13
     C   71TABELM        READPE    XATABE1                                66
     C  N71TABELM        READPE    XATABLSD                               66
     C                   ENDDO
     C     *IN66         IFEQ      *ON
.    C                   MOVE      *LOVAL        TBC6
     C                   ELSE
.    C                   MOVEL     TABELM        TBC6
     C                   ENDIF
      *
.    C                   MOVE      *ON           *IN28
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
     C     *IN66         DOUEQ     *ON
     C                   READC     S1DATA                                 66
     C     *IN66         IFEQ      *OFF
      *
      *? If Subfile option entered                        ?
      *
     C     S1SEL         IFNE      *BLANK
     C                   Z-ADD     S1RRN         ##RRNO
     C                   CLEAR                   *IN91
     C     S1SEL         LOOKUP    VOP                                    91
      *
      *? Selection 1 - Select                            ?
      *
     C                   SELECT
     C     S1SEL         WHENEQ    '1'
     C     *IN91         ANDEQ     *ON
     C                   MOVE      S1ELM#        #EELM#
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
      *? Selection 2 - Change Table Element Master Record?
      *
     C     S1SEL         WHENEQ    '2'
     C     *IN91         ANDEQ     *ON
     C     TABELM        CAT(P)    S1ELM#:0      #ETAB#            8
     C                   CALL      'XATABLE1'                           69
     C                   PARM                    #ETAB#
     C                   PARM                    #KEYP#
     C     #ETAB#        IFEQ      'XXXXXXXX'                                    F3=EXIT
     C                   MOVE      *ON           *IN66
     C                   END
     C     #ETAB#        IFNE      *BLANKS
     C                   MOVEL     #ETAB#        TABELM
     C                   MOVE      #ETAB#        TBC6
     C                   MOVE      *ON           $$RLOD            1
     C                   END
     C     TABELM        IFEQ      'BR'
     C                   MOVE      *ON           *IN75
     C                   ENDIF
     C                   CLEAR                   S1SEL
      *
      *? Invalid Option entered                           ?
      *
     C                   OTHER
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN39
     C                   MOVE      *OFF          $$RLOD
     C                   MOVE      'DW00003'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      YES           ERROR             3
     C                   ENDSL
     C                   END
      *
      *? Reset Indicators and Update subfile              ?
      *
     C                   UPDATE    S1DATA
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN39
     C     ERROR         IFEQ      YES
     C                   LEAVE                                                   END LOOP
     C                   END
     C                   END
     C                   END
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
     C     TABID         IFEQ      'BR'
     C                   MOVE      *ON           *IN75
     C                   ENDIF
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
      *? Selection 4 - Delete                             ?             ?
      *
     C     S1SEL         LOOKUP    VOP                                    91
     C     S1SEL         IFEQ      '4'
     C     *IN91         ANDEQ     *ON
     C                   ADD       1             S2RRN
     C                   WRITE     S2DATA
     C                   CLEAR                   S1SEL
     C                   MOVE      *OFF          *IN39
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
      *
      *? Delete Table Element Record                     ?              ?
     C     TABELM        CAT(P)    S1ELM#        FKEY              8
     C     FKEY          CHAIN     TBMASTR                            67
     C     *IN67         IFEQ      *OFF
     C                   DELETE    TBMASTR
     C                   END
     C                   END
     C                   END
     C                   END
      *
      *
      *? Clear Messages                                   ?             ?
      *
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
     C                   END
      *
     C                   MOVE      SVTBNO        TBC6
     C                   MOVE      SVTBSD        TBC6SD
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
      ********************************************************************
      * ?       Program Initialization and Housekeeping                 ?*
      ********************************************************************
     CSR   *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    TABID             2
     C                   PARM                    #KEYP#            2
     C                   PARM                    #EELM#            6

      *?Set Default Sort...   *In71 *On = Sort By Code;  *In71 *Off = Sort by Short Description
     C                   Eval      *In71 = *On

     C                   If           TABID = 'JC'
     C                             or TABID = 'TE'
     C                             or TABID = 'JC'                               Add more TABID here
     C                   Eval      *In71 = *Off
     C                   EndIf

     C                   MOVE      TABID         TABELM            2
     C     'TB'          CAT(P)    TABELM:0      TBIDKY            8
     C     TABID         IFEQ      'BR'
     C                   MOVE      *ON           *IN75
     C                   ENDIF
      *
      *?If program called with 3 *ENTRY parm, allow select
      *
     C     ##PARM        IFGT      2
     C                   Z-ADD     1             O#                1 0
     C                   ELSE
     C                   Z-ADD     2             O#
     C                   ENDIF
      *
      *?Set valid options & options text
      *
     C                   MOVEA     OPT(O#)       VOP
     C                   MOVE      OTX(O#)       C1OPTN
      *
      * Define *LIKE Fields ?
      *
     C     *LIKE         DEFINE    #SFLPG        ##ROLL
     C     *LIKE         DEFINE    #SFLPG        ##FWRL
     C     *LIKE         DEFINE    #SFLPG        ##LOAD
     C     *LIKE         DEFINE    TABELM        SVGRP#
     C     *LIKE         DEFINE    TBC6          SVTBNO
     C     *LIKE         DEFINE    TBC6SD        SVTBSD
      *
      * Define Key Lists ?
      *
      * ?KLIST for file - XATABLPF Library - *LIBL     ?
      * ?LF - by MAST ID/SEQ                         ?
      * ?                                                  ?
      *
     C     TBKEY         KLIST
     C                   KFLD                    TABELM
     C                   KFLD                    TBC6
      *
     C     TBKEYSD       KLIST
     C                   KFLD                    TABELM
     C                   KFLD                    TBC6SD           15
      *
     C     TABLE         KLIST
     C                   KFLD                    TABID
      * ?Chain to get Table Heading & Center it for Screen?
     C     TBIDKY        CHAIN(N)  XATABL                             69
     C                   MOVEL(P)  TBLONG        T1NAME
     C     ' '           CHECKR    T1NAME        P                 3 0
     C     40            SUB       P             P
     C                   DIV       2             P
     C     ' '           CAT(P)    T1NAME:P      T1NAME
     C                   MOVE      TBKEYP        #KEYP#
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
      *? Initial subfile load                             ?             ?
      *
     C                   MOVE      *OFF          $$LOAD            1
      *
      *?Set initial subfile mode - Fold/Truncate  ECT...           *OFF/*ON
     C                   MOVE      *ON           *IN83                          SFLMODE Fold/Trnc.
     C                   MOVE      *IN83         ##SFLM
      *
      *?Set  SFL PAGE Size and SFL Size
      *?#FWRL - Multiple Page Size by # of Pages to LOAD on ROLL FWD/BACK
      *?#LOAD - Multiple Page Size by # of Pages to LOAD on POSITION TO
.    C                   Z-ADD     7             #SFLPG            4 0          SFLPAG(7) Folded Siz
.    C                   Z-ADD     2             ##FWRL                         SFL Roll Forward 14
.    C                   Z-ADD     4             ##LOAD                         SFL Load 24 Records
      *
      *? Initial Sub File Load.                                  ?             ?
     C                   EXSR      LOADSF
      *
     CSR                 ENDSR
** OPT - options
1
24
** OTX - options text
1=Select
2=Change   4=Delete
