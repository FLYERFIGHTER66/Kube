      *%*******************************************************************
      *%                                                                 **
      *%  ?                     ?                                        **
      *%  ?                     ?                                        **
      *%                        ?                                        **
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- Inventory                                       **
      *%                                                  ?              **
      *%                                                                 **
      *%  ?                     ?                                        **
      *%  ?                     ?                                        **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- HG0014                                                 *
      *                                                                   *
      * Purpose?- Hard Goods Purchase Order Print Review                 *
      *                                                                   *
      *    Date  Programmer         Comment                          ? *
      *  4/29/2004 Richard E. Piasecki Program Created                    *
      *                                                                   *
      *********************************************************************
     FSECUSER   IF   E           K DISK
     FHGPOHDL1  UF   E           K DISK
     F                                     RENAME(DGHDR:HDRL1)
     FFMVEND    IF   E           K DISK
      *
     FPRTTABL   IF   E           K DISK
     FHG0014S   CF   E             WORKSTN
     F                                     SFILE(S1DATA:S1RRN)
     F                                     INFDS(INFDS3)
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
      *****************************************************************
      * ?Define Program Constants                                   ? *
      *****************************************************************
     D YES             C                   CONST('YES')
     D NO              C                   CONST('NO ')
     D DFTVAL          C                   CONST('*DEFAULT  ')
     D SERS            C                   CONST('SERLSTATUS')
     D NONE            C                   CONST('*NONE')
     D @CSTSO          C                   CONST('Open')
     D @CSTSH          C                   CONST('Hist')
     D @CSTSU          C                   CONST('????')
     D @CINVJ          C                   CONST('*** Invalid Vendor N-
     D                                     umber ***')
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
      * ?F12 pressed                                ?
     C     *IN12         WHENEQ    *ON
     C                   MOVE      YES           ENDPGM            3
      *
      *
      *? F1 - Cursor Help                                 ?
     C     *IN01         WHENEQ    '1'
     C                   EXSR      SRCHLP
      *
      *? Position to requested -- change in P/O
     C     *IN28         WHENEQ    *ON
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
     C                   EXSR      $PRCSS
     C                   MOVE      'Y'           #EPRNT
     C                   MOVE      YES           ENDPGM
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
     C****       #SFLPG    MULT ##LOAD    ##ROLL
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
      *
      *? Set File Position                                ?             ?
     C     *IN28         IFEQ      *OFF
     C                   MOVE      *LOVAL        DGPOYR
     C                   MOVE      *LOVAL        DGDGPO
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
     C                   ENDIF
     C                   EXSR      $SETLL
      *
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
     C                   ADD       1             S1RRN
     C                   WRITE     S1DATA
     C****       S1RRN     IFEQ ##ROLL
     C****                 MOVE *ON       $EXLOD
     C****                 END
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
     C                   MOVE      'KP00107'     $#MSID                         ?Message Id   ?
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
     C     USFL06        WHENEQ    'Y'
     C     *LOVAL        SETLL     HDRL1
     C                   ENDSL
      *
     C                   ENDSR
      ********************************************************************
      * ?$READP - Performs read prior on file currently being read      ?*
      ********************************************************************
     CSR   $READP        BEGSR
      *
     C                   CLEAR                   *IN66
     C                   SELECT
     C     USFL06        WHENEQ    'Y'
     C                   READP(N)  HDRL1                                  66
     C                   ENDSL
      *
     C                   ENDSR
      ********************************************************************
      * ?$READ - Performs read on file currently being read             ?*
      ********************************************************************
     CSR   $READ         BEGSR
      *
     C                   CLEAR                   *IN66
     C                   SELECT
     C     USFL06        WHENEQ    'Y'
     C                   READ(N)   HDRL1                                  66
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
     C                   MOVE      DGWHSE        S1WHSE
     C                   MOVEL     DGVNDR        S1JOBR
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
     C                   MOVE      DGVNDR        PVEND#            6 0
     C     VMKEY         CHAIN     FMVEND                             99
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
      *
      *? Set Roll Factor Based on Current SFL Mode  (Fold/Drop)         ?
      *
     C     #SFLPG        MULT      ##FWRL        ##ROLL
      *
     C                   EXSR      $SETLL
      *
     C     1             DO        ##ROLL
     C                   EXSR      $READP
     C     *IN66         IFEQ      *ON
     C                   MOVE      *LOVAL        DGPOYR
     C                   MOVE      *LOVAL        DGDGPO
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVE      *ON           *IN28
     C                   EXSR      LOADSF
      *
     CSR                 ENDSR
      ********************************************************************
      * ?$PRCSS - Call the P/O print program for each P/O on screen     ?*
      ********************************************************************
     CSR   $PRCSS        BEGSR
      *
      *? Determine Where to Print P/O's or Receivings                   ?
      *
     C                   MOVE      *BLANKS       S1OUTQ
     C*                    MOVE ' '       WKDERR
     C                   MOVE      *ON           *IN73
     C     *IN73         DOWEQ     *ON
     C                   EXFMT     PRTOUTQ
     C                   MOVE      *OFF          *IN74                                        ?
      *****
      * ?Printer Code Must be Valid                                     ?*
      *****
||    *
||1  C     S1OUTQ        IFEQ      '?'
||   C                   EXSR      $PRMPT
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
     C*          POKEY     CHAINHDRL1                99
     C*          *IN99     IFEQ *OFF
     C*                    MOVEL'20'      DGRDTE
     C*                    MOVE YYMMDD    DGRDTE
     C*                    UPDATHDRL1
     C*                    ENDIF
     C                   ENDDO
      *
      *? Read entire subfile                                            ?
      *
     C                   DO        9999999       RRN               7 0
     C                   CLEAR                   S1PO#
     C     RRN           CHAIN     S1DATA                             66
     C     *IN66         IFEQ      *ON
     C     S1PO#         OREQ      *ZEROS
     C                   LEAVE
     C                   ENDIF
      *
     C                   MOVE      S1YR#         #PYR#             2
     C                   MOVE      S1PO#         #PPO#             6
     C                   CALL      'HG0015C'
     C                   PARM                    #PYR#
     C                   PARM                    #PPO#
     C                   PARM                    S1PRTF
     C                   PARM                    OUTQ
      *
      *? Reset print flag                                               ?
      *
     C     POKEY         CHAIN     HDRL1                              99
     C                   CLEAR                   DGPRTF
     C                   UPDATE    HDRL1
      *
     C                   ENDDO
      *
     C                   ENDSR
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
     C                   MOVEL     'HARDGPO'     USSYS
     C                   MOVEL     ##USER        USUSID
     C     USKEY         CHAIN     USERR                              99
      *
     C                   ENDSR
      ********************************************************************
      * ?       Program Initialization and Housekeeping                 ?*
      ********************************************************************
     CSR   *INZSR        BEGSR
      *
      * *ENTRY Parameter list?
      *
     C     *ENTRY        PLIST
     C                   PARM                    #EPRNT            1
      *
      * Define *LIKE Fields ?
      *
     C     *LIKE         DEFINE    #SFLPG        ##ROLL
     C     *LIKE         DEFINE    #SFLPG        ##FWRL
     C     *LIKE         DEFINE    #SFLPG        ##LOAD
      *
      * Define Key Lists ?
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
     C                   KFLD                    S1YR#
     C                   KFLD                    S1PO#
      *
      * ?KLIST for APMSTP
      *
     C     VMKEY         KLIST
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
      *?Set  SFL PAGE Size and SFL Size
      *?#FWRL - Multiple Page Size by # of Pages to LOAD on ROLL FWD/BACK
      *?#LOAD - Multiple Page Size by # of Pages to LOAD on POSITION TO
.    C                   Z-ADD     6             #SFLPG            4 0          SFLPAG(7) Folded Siz
.    C                   Z-ADD     2             ##FWRL                         SFL Roll Forward 14
.    C                   Z-ADD     4             ##LOAD                         SFL Load 28 Records
      *
      *? Initial Sub File Load.                                  ?             ?
     C                   EXSR      LOADSF
      *
     CSR                 ENDSR
      *****************************************************************
      * ?$PRMPT - Handles F4 prompt function                       ? *
      *****************************************************************
     CSR   $PRMPT        BEGSR
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
      *****************************************************************
