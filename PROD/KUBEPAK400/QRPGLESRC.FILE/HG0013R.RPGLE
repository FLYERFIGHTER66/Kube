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
      * Program?- HG0013                                                 *
      *                                                                   *
      * Purpose?- Hard Goods P/O Receipts File Maintenance               *
      *                                                                   *
      *   Date  Programmer    ? Comment                              ? *
      * 4/28/2004 R. Piasecki      Program Created                        *
      *                                                                   *
      *********************************************************************
     FSECUSER   IF   E           K DISK
     FPOCNTL    IF   E           K DISK
     FHGVITM    UF   E           K DISK
     FFMINVT    UF   E           K DISK
     FKPITMWHS  UF A E           K DISK
     FHGPOHD    UF   E           K DISK
     FHGPODT    UF   E           K DISK
     FHGPODTL2  IF   E           K DISK
     F                                     RENAME(DGDTL:DTLL2)
     FKPHIST    O  A E           K DISK
     FHGPORC    O  A E           K DISK
     FHGPORCL1  IF   E           K DISK
     F                                     RENAME(DGREC:RECL1)
     FFMVEND    IF   E           K DISK
     FKPWHOUSE  IF   E           K DISK
     FHG0013WK  UF A E           K DISK
     F*MINSER IF  E           K        DISK
     F*SERIES IF  E           K        DISK
     F*SERPRC IF  E           K        DISK
      *
     FHG0013S   CF   E             WORKSTN
     F                                     SFILE(S1DATA:S1RRN)
     F                                     SFILE(S2DATA:S2RRN)
     F                                     INFDS(INFDS3)
     FHG0013P   O    E             PRINTER OFLIND(*IN88)
      *****************************************************************
      * ?Arrays & tables                                            ? *
      *****************************************************************
     D WKAD            S             35    DIM(4)
     D CADR            S             35    DIM(4)
     D WADR            S             35    DIM(4)
     D JADR            S             35    DIM(4)
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
     D  DGDUDT                 1      6  0
     D  DGPODM                 1      2  0
     D  DGPODD                 3      4  0
     D  DGPODY                 5      6  0
      ********************************************************************
      * ?Breakdown of P/O date                                          ?*
      ********************************************************************
     D*          IDS
     D*                                       1   80WKDATE
     D*                                       1   20DGPOEC
     D*                                       3   40DGPOEY
     D*                                       5   60DGPOEM
     D*                                       7   80DGPOED
      *
     D                 DS
     D  PRENDT                 1      6  0 INZ(0)
     D  DGPOEM                 1      2  0
     D  DGPOED                 3      4  0
     D  DGPOEY                 5      6  0
      ********************************************************************
      * ?Breakdown of message data                                      ?*
      ********************************************************************
     D                 DS                  INZ
     D  $#0122                 1     80
     D*                                   P   1   50$#LOT#
     D  $#POYR                 6      7P 0
     D  $#DGPO                 8     11P 0
      *****************************************************************
      * ?Define Program Constants                                   ? *
      *****************************************************************
     D YES             C                   CONST('YES')
     D NO              C                   CONST('NO ')
     D @CF11A          C                   CONST('F11=Show all items ')
     D @CF11O          C                   CONST('F11=Open items only')
     D @CUNDA          C                   CONST('      All items')
     D @CUNDO          C                   CONST('Open items only')
     D @NOITM          C                   CONST('ITEM NOT ON ITEM MAS-
     D                                     TER')
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
     C                   CLEAR                   *IN30
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
      *? If F3 or F12 not pressed, clear warning flag   ?
     C     *IN03         IFNE      *ON
     C     *IN12         ANDNE     *ON
     C                   CLEAR                   WKWRNG
     C                   ENDIF
      *
      * ?SFL Input Selection                          ?
      *
     C                   SELECT
      *
      * ?F3 or F12 pressed                                ?
     C     *IN03         WHENEQ    *ON
     C     *IN12         OREQ      *ON
      *
      * ?If F3/F12 pressed from change review screen,
      * ?return to entry subfile screen.                               g.
     C     $3RCDF        IFEQ      'S2CNTL'
     C                   EXSR      LOADSF
     C                   CLEAR                   WKWRNG
     C                   ELSE
      *
      * ?If warning already issued, or no entries made in subfile,
      * ?exit program, else issue warning.
     C     WKWRNG        IFEQ      'Y'
     C     WKCHNG        OREQ      *BLANK
     C     *IN03         IFEQ      *ON
     C                   MOVE      'XX'          #EPOYR
     C                   ENDIF
     C                   MOVE      YES           ENDPGM            3
     C                   ELSE
     C                   MOVE      'KP00121'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      'Y'           WKWRNG            1
     C                   ENDIF
     C                   ENDIF
      *
      *
      *? F1 - Cursor Help                                 ?
     C     *IN01         WHENEQ    '1'
     C                   EXSR      SRCHLP
      *
      *? F10 - Confirm update                             ?
     C     *IN10         WHENEQ    '1'
     C                   EXSR      READSF
     C                   CLEAR                   WKCHNG
     C     ERROR         IFNE      YES
     C                   EXSR      $CNFRM
     C                   ENDIF
      *
      *? F11 - Change views                               ?
     C     *IN11         WHENEQ    '1'
     C                   EXSR      READSF
     C     ERROR         IFNE      YES
     C                   EXSR      $SVENT
      *
     C     WKRSTS        IFEQ      'O'
     C                   MOVE      'A'           WKRSTS
     C                   MOVE      @CUNDA        UNDER
     C                   MOVE      @CF11O        CKYF11
     C                   ELSE
     C                   MOVE      'O'           WKRSTS
     C                   MOVE      @CUNDO        UNDER
     C                   MOVE      @CF11A        CKYF11
     C                   ENDIF
      *
     C                   MOVE      *LOVAL        DDLOOK
     C                   MOVE      *LOVAL        DDITEM
     C                   MOVE      '1'           *IN28
     C                   EXSR      LOADSF
     C                   EXSR      $DLENT
      *
     C                   ENDIF
      *
      *
      *? F13 - Open Price, Warehouse, & status for entry. ?
     C     *IN13         WHENEQ    '1'
     C                   EXSR      READSF
     C     ERROR         IFNE      YES
     C     *IN84         IFEQ      '1'
     C                   CLEAR                   *IN84
     C                   ELSE
     C                   MOVE      '1'           *IN84
     C                   ENDIF
      *
     C                   DO        MXRRN         X
     C     X             CHAIN     S1DATA                             68
     C     *IN68         IFEQ      '1'
     C                   LEAVE
     C                   ELSE
     C                   EXSR      $GTSTS
     C     SVLOT#        IFNE      *ZEROS
     C                   MOVE      '1'           *IN85
     C                   ELSE
     C                   CLEAR                   *IN85
     C                   ENDIF
     C                   UPDATE    S1DATA
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
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
     C                   MOVE      'KP00116'     $#MSID                         ?Message Id   ?
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
      *? Process Input               ?
     C     $$LOAD        WHENEQ    '1'
     C                   EXSR      READSF
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
      *
      *? Set File Position                                ?             ?
     C     *IN28         IFEQ      *OFF
     C                   MOVE      *LOVAL        DDLOOK
     C                   MOVE      *LOVAL        DDITEM
     C                   ELSE
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
     C                   MOVE      *LOVAL        DDLOOK
     C                   MOVE      *LOVAL        DDITEM
     C                   ELSE
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
     C                   MOVE      'KP00116'     $#MSID                                       ?
     C                   EXSR      SRMSGF
     C                   ELSE
      *
      *? If no records loaded                             ?
      *
     C                   MOVE      *OFF          $$LOAD            1
     C                   EXSR      BLNKSF
     C                   MOVE      'KP00117'     $#MSID                         ?Message Id   ?
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
     C     WKRSTS        IFEQ      'A'
     C     DTKEY         SETLL     DGDTL
     C                   ELSE
     C     DTKEY         SETLL     DTLL2
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      * ?$READP - Performs read prior on file currently being read      ?*
      ********************************************************************
     CSR   $READP        BEGSR
      *
     C                   CLEAR                   *IN66
     C     WKRSTS        IFEQ      'A'
     C     HDKEY         READPE    DGDTL                                  66
     C                   ELSE
     C     HDKEY         READPE    DTLL2                                  66
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      * ?$READ - Performs read on file currently being read             ?*
      ********************************************************************
     CSR   $READ         BEGSR
      *
     C                   CLEAR                   *IN66
     C     WKRSTS        IFEQ      'A'
     C     HDKEY         READE     DGDTL                                  66
     C                   ELSE
     C     HDKEY         READE     DTLL2                                  66
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * ?MOV@S1 - Move File Fields to SFL Display Output Fields     ? *
      *****************************************************************
     CSR   MOV@S1        BEGSR
      *
     C                   CLEAR                   S1DATA
      *
      * ?P/O Detail File Fields              ?
      *
     C                   MOVEL     DDLOOK        S1LOOK
     C                   MOVEL     DDITEM        S1ITEM
     C                   MOVEL     DDSIZE        S1SIZE
     C                   CLEAR                   S1PQTY
     C                   CLEAR                   S1RCQT
     C                   CLEAR                   S1RCTD
     C*          DGVNDR    IFNE 003850
     C                   Z-ADD     DDPQTY        S1PQTY
     C     DDPQTY        SUB       DDRCQT        S1RCQT
     C                   Z-ADD     DDRCQT        S1RCTD
     C*          DRREC#    IFGT 1
     C*                    Z-ADD0         S1RCQT
     C*                    ENDIF
     C*                    Z-ADDDDWTRC    S1WTTD
     C                   Z-ADD     DDOPRC        S1PRCE
     C                   Z-ADD     DDOPRC        S1OPRC
     C                   MOVEL     DDWHSE        S1WHSE
     C                   MOVE      DDRSTS        S1RSTS
      *
      * ?Get product description
      *
     C                   MOVEL     DDIDS1        S1PRDN
     C                   CLEAR                   *IN39
     C                   MOVEL     DDITEM        DDPITM
     C                   MOVEL     DDSIZE        DDPSIZ
     C     PRKEY         CHAIN(N)  RMINVT                             82
     C     *IN82         IFEQ      '1'
     C                   MOVEL     @NOITM        S1PRDN
     C****                 MOVE YES       ERROR
     C                   MOVE      *ON           *IN39
     C                   ENDIF
     C*                    ENDIF
      *
      * ?Get last price paid
      *
     C                   MOVE      DGVNDR        DIVNDR
     C*                    MOVE DGRCID    DIRCID
     C                   MOVE      S1ITEM        DIPITM
     C                   CLEAR                   DIPPRC
     C                   CLEAR                   *IN99
     C     ITKEY         CHAIN     DGITEMR                            99
     C                   Z-ADD     DIPPRC        S1PRCE
      *
      * ?Check for previous entry if F11 was pressed
      *
     C     *IN11         IFEQ      *ON
     C     WKKEY         CHAIN     DG0013W                            99
     C     *IN99         IFEQ      '0'
     C                   MOVEL     WKLOOK        S1LOOK
     C                   MOVEL     WKITEM        S1ITEM
     C                   MOVE      WKSIZE        S1SIZE
     C                   Z-ADD     WKRCQT        S1RCQT
     C*                    Z-ADDWKWTRC    S1WTRC
     C                   Z-ADD     WKOPRC        S1OPRC
     C                   MOVE      WKOWH         S1OWH
     C                   MOVE      WKOSTS        S1OSTS
     C                   ENDIF
     C                   ENDIF
      *
      * ?Set field protect indicators
      *
     C                   EXSR      $GTSTS
      *
     CSR                 ENDSR
      *****************************************************************
      * ?$GTSTS - Sets field protect indicators based on status     ? *
      *****************************************************************
     CSR   $GTSTS        BEGSR
      *
      * ?Field protect all entry fields if Status = C
SMA   * ?or if item not found
     C                   CLEAR                   *IN82
     C                   CLEAR                   *IN86
     C                   CLEAR                   *IN87
      *
      *
     C     S1RSTS        IFEQ      'C'
     C                   MOVE      '1'           *IN86
     C                   MOVE      '1'           *IN87
     C                   ENDIF
      *
     C     S1PRDN        IFEQ      @NOITM
     C                   MOVE      '1'           *IN86
     C                   MOVE      '1'           *IN87
     C                   MOVE      '1'           *IN82
     C                   ENDIF
      *
     CSR                 ENDSR
      *****************************************************************
      * ?BACKSF - Roll Back File One Page of SFL Records            ? *
      *****************************************************************
     CSR   BACKSF        BEGSR
      *
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
      *
      *? Set loop -- read all changed subfile records     ?             ?
      *
     C     *IN66         DOUEQ     *ON
     C                   READC     S1DATA                                 66
     C     *IN66         IFEQ      *OFF
      *
      *? Set change flag for save warning                               ?
      *
     C                   MOVE      'Y'           WKCHNG            1
      *
      *? Edit changed record
      *
     C                   EXSR      $EDTSF
      *
      *? Reset Field Protect Indicators
      *
     C                   EXSR      $GTSTS
      *
      *? Reset Next Change Indicator and Update subfile              ?
      *
     C                   SELECT
     C     ERROR         WHENNE    YES
     C                   MOVE      *OFF          *IN39
     C                   UPDATE    S1DATA
     C     ERROR         WHENEQ    YES
     C                   MOVE      *ON           *IN39
     C                   UPDATE    S1DATA
     C                   LEAVE                                                   END LOOP
     C                   ENDSL
      *
     C                   ENDIF
     C                   ENDDO
      *
      * ?If no errors, issue message to press F10                       ?*
      *
     C                   SELECT
     C     ERROR         WHENEQ    YES
     C                   MOVE      *ON           *IN30
     C     ERROR         WHENEQ    *BLANKS
     C     WKCHNG        ANDEQ     *BLANK
     C                   MOVE      'SR00012'     $#MSID
     C                   EXSR      SRMSGF
     C     ERROR         WHENEQ    *BLANKS
     C     WKCHNG        ANDEQ     'Y'
     C                   MOVE      'SR00013'     $#MSID
     C                   EXSR      SRMSGF
     C                   ENDSL
      *
     C     $$RLOD        IFEQ      *ON
     C                   MOVE      *ON           *IN28
     C                   EXSR      LOADSF
     C                   ENDIF
      *
     CSR                 ENDSR
      ********************************************************************
      * ?$EDTSF - Edits entry from screen                               ?*
      ********************************************************************
     CSR   $EDTSF        BEGSR
      *
      * ?Verify that Item Number is still valid
      *
B001 C*                    CLEAR*IN82
     C                   MOVEL     S1SIZE        DDPSIZ
     C                   MOVEL     S1ITEM        DDITEM
     C                   MOVEL     S1SIZE        DDSIZE
     C     PRKEY         CHAIN     RMINVT                             82
SMA  C***        *IN82     IFEQ '1'
SMA  C***                  MOVE YES       ERROR
SMA  C***                  ENDIF
      *
      * ?Verify Override Warehouse, if entered
      *
     C     S1OWH         IFNE      *ZERO
     C     S1OWH         CHAIN     WHSE                               35
     C     *IN35         IFEQ      '1'
     C                   MOVE      YES           ERROR
     C                   MOVE      'KP00113'     $#MSID
     C                   EXSR      SRMSGF
     C                   ENDIF
     C                   ENDIF
      *
      * ?Price must be entered before line is manually closed
      *
     C     S1OSTS        IFNE      *BLANK
     C     S1PRCE        ANDEQ     *ZEROS
     C     S1OPRC        ANDEQ     *ZEROS
     C                   MOVE      '1'           *IN36
     C                   MOVE      YES           ERROR
     C                   MOVE      'KP00131'     $#MSID
     C                   EXSR      SRMSGF
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      *?$CNFRM - Fill confirmation screen                               ?*
      ********************************************************************
     CSR   $CNFRM        BEGSR
      *
      *
      *?   Clear F10 indicator                            ?             ?
      *
     C                   CLEAR                   *IN10
      *
      *?   Clear the subfile                              ?             ?
      *
     C                   MOVE      *ON           *IN80
     C                   Z-ADD     *ZERO         S2RRN             5 0
     C                   WRITE     S2CNTL
     C                   CLEAR                   S2DATA
     C                   MOVE      *OFF          *IN80
      *
      *? Set loop -- read all subfile records     ?                     ?
      *
     C                   CLEAR                   *IN68
B001 C                   DO        MXRRN         X
     C     X             CHAIN     S1DATA                             68
B002 C     *IN68         IFEQ      *ON
     C                   LEAVE
     C                   ELSE
      *
      *? Set Subfile Next Change                          ?             ?
      *
     C                   MOVE      *ON           *IN39
      *
      *? If quantity or close flag entered                            ? ?
      *
B003 C     S1RCQT        IFNE      *ZEROS
     C     S1OSTS        ORNE      *BLANK
     C                   ADD       1             S2RRN
      *
      *? Fill price                                                     ?
      *
     C                   SELECT
     C     S1RCQT        WHENEQ    *ZEROS
     C                   CLEAR                   S2PRCE
     C     S1OPRC        WHENNE    *ZEROS
     C                   Z-ADD     S1OPRC        S2PRCE
     C     S1OPRC        WHENEQ    *ZEROS
     C                   Z-ADD     S1PRCE        S2PRCE
     C                   ENDSL
      *
      *? Fill warehouse                                                 ?
      *
     C                   CLEAR                   S2WHSE
     C                   SELECT
     C     S1RCQT        WHENEQ    *ZEROS
     C     S1OWH         WHENNE    *ZERO
     C                   MOVEL     S1OWH         S2WHSE
     C     S1OWH         WHENEQ    *ZERO
     C                   MOVEL     S1WHSE        S2WHSE
     C                   ENDSL
      *
      *? Fill status                                                    ?
      *
     C     S1OSTS        IFNE      *BLANK
     C                   MOVEL     S1OSTS        S2RSTS
     C                   ELSE
     C                   MOVEL     S1RSTS        S2RSTS
     C                   ENDIF
      *
     C                   WRITE     S2DATA
E003 C                   ENDIF
E002 C                   ENDIF
E001 C                   ENDDO
      *
      *
      *? If no entries exist, write blank subfile.                      ?
      *
B001 C     S2RRN         IFEQ      *ZEROS
     C                   EXSR      BLNKS2
     C                   CLEAR                   CKCNT
     C                   ELSE
     C                   Z-ADD     S2RRN         CKCNT
     C                   ENDIF
      *
      *? Display the screen until F3, F10, or F12 pressed               ?
      *
     C     *IN03         DOWEQ     '0'
     C     *IN10         ANDEQ     '0'
     C     *IN12         ANDEQ     '0'
     C                   Z-ADD     1             #2RRNO
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN
     C                   MOVE      'SR00014'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   WRITE     CFKY02
     C                   WRITE     MSGCTL
     C                   EXFMT     S2CNTL
     C                   ENDDO
      *
      *? Process changes & print receiver if F10 pressed.               ?
      *
     C     *IN10         IFEQ      *ON
     C     *IN82         ANDEQ     *OFF
     C                   EXSR      $UPDAT
     C                   MOVE      YES           ENDPGM
     C                   MOVE      'XX'          #EPOYR
     C                   ENDIF
      *
     CSR                 ENDSR
      ********************************************************************
      * ?$UPDAT - Updates all neccessary files                          ?*
      ********************************************************************
     CSR   $UPDAT        BEGSR
      *
      * ?Print the receiver headings.
      *
     C                   EXSR      $PRHDR
      *
      * ?Read thru entire subfile.
      *
B001 C                   DO        MXRRN         X                 7 0
     C                   CLEAR                   *IN68
     C     X             CHAIN     S1DATA                             68
B002 C     *IN68         IFEQ      *ON
     C                   LEAVE
     C                   ELSE
      *
      * ?Process only if any quantity received or status was entered
      *
B003 C     S1RCQT        IFNE      *ZEROS
     C     S1OSTS        ORNE      *BLANK
      *
      * ?Add receipt record if quantity was entered
      *
B004 C     S1RCQT        IFNE      *ZEROS
     C                   Z-ADD     DGPOYR        DRPOYR
     C                   Z-ADD     DGDGPO        DRDGPO
     C                   MOVEL     S1ITEM        DRITEM
     C                   MOVEL     S1LOOK        DRLOOK
     C                   MOVE      S1SIZE        DRSIZE
     C                   MOVEL     'EA '         DRPUOM
     C                   Z-ADD     DGVNDR        DRVNDR
     C                   Z-ADD     S1RCQT        DRRCQT
     C                   MOVE      'O'           DRRSTS
     C     S1OWH         IFNE      *ZERO
     C                   MOVEL     S1OWH         DGWHSE
     C                   ELSE
     C                   MOVEL     S1WHSE        DGWHSE
     C                   ENDIF
     C                   MOVEL     ##USER        DRUSER
      *
     C     UDATE         MULT      10000.01      WKYMD             6 0
     C     WKYMD         IFGT      950000
     C     WKYMD         ADD       19000000      DRRCDT
     C                   ELSE
     C     WKYMD         ADD       20000000      DRRCDT
     C                   ENDIF
      *
     C                   WRITE     DGREC
E004 C                   ENDIF
      *
      * ?Determine how much of receipt quantity should be backed
      * ?out of quantity on order:
      *
     C     S1RCQT        ADD       S1RCTD        CKRCQT                         Total received
      *
     C                   SELECT
     C     S1RCTD        WHENGE    S1PQTY                                       Recvd to date > orde
     C                   CLEAR                   XXRCQT                          no effect
     C     CKRCQT        WHENGT    S1PQTY                                       Total recvd > order
     C     S1OSTS        ORNE      *BLANK                                       or line closed
     C     S1PQTY        SUB       S1RCTD        XXRCQT                          balance of order
     C                   OTHER                                                  Others
     C                   Z-ADD     S1RCQT        XXRCQT                          Entire receipt
     C                   ENDSL
      *
      * ?Update P/O detail record
      *
     C                   MOVE      DGPOYR        DDPOYR
     C                   MOVE      DGDGPO        DDDGPO
     C                   MOVEL     S1LOOK        DDLOOK
     C                   MOVEL     S1ITEM        DDITEM
     C                   MOVE      S1SIZE        DDSIZE
     C                   MOVEL     S1ITEM        DDPITM
     C                   MOVEL     S1ITEM        PROD
     C                   MOVE      S1SIZE        DDPSIZ
     C                   CLEAR                   *IN99
     C     DTKEY         CHAIN     DGDTL                              99
     C     *IN99         IFEQ      '0'
     C                   ADD       S1RCQT        DDRCQT
     C*                    MOVE S1OSTS    DDRSTS
     C     DDRCQT        IFGE      DDPQTY
     C     S1OPRC        ANDNE     *ZEROS
     C     DDRCQT        ORGE      DDPQTY
     C     S1PRCE        ANDNE     *ZEROS
     C     S1OSTS        ORNE      *BLANK
     C                   MOVE      'C'           DDRSTS
     C                   ENDIF
     C                   UPDATE    DGDTL
     C                   ENDIF
      *
      * ?Update ITEM MASTER RECORD
      *
     C                   MOVEL     S1ITEM        DDPITM
     C                   MOVEL     S1ITEM        PROD             12
     C                   MOVE      S1SIZE        DDPSIZ
     C                   CLEAR                   *IN99
     C                   CLEAR                   RECQTY
     C     PRKEY         CHAIN     RMINVT                             99
     C     *IN99         IFEQ      '0'
     C     S1RCQT        MULT      IMLBS#        RECQTY           11 0
     C                   ADD       RECQTY        IMMREC
     C                   ADD       RECQTY        IMQTOH
     C                   SUB       RECQTY        IMQTOO
     C     IMQTOO        IFLT      *ZERO
     C                   CLEAR                   IMQTOO
     C                   ENDIF
     C     S1OSTS        IFEQ      'C'
     C                   CLEAR                   IMQTOO
     C                   ENDIF
     C                   SELECT
     C     S1OPRC        WHENNE    *ZEROS
     C                   Z-ADD     S1OPRC        IMLCST
     C     S1PRCE        WHENNE    *ZEROS
     C                   Z-ADD     S1PRCE        IMLCST
     C                   ENDSL
     C                   UPDATE    RMINVT
     C                   ENDIF
      *
      * ?Update Vendor Item File
      *
     C                   MOVEL     S1ITEM        DDPITM
     C                   MOVEL     S1ITEM        PROD
     C                   MOVE      S1SIZE        DDPSIZ
     C                   CLEAR                   *IN99
     C     ITKEY         CHAIN     DGITEMR                            99
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     DRRCDT        DIDTLO
     C*                    ADD  S1RCQT    IMQTOH
     C*                    ADD  S1RCQT    IMMREC
     C*                    SUB  S1RCQT    IMQTOO
     C                   SELECT
     C     S1OPRC        WHENNE    *ZEROS
     C                   Z-ADD     S1OPRC        DIPPRC
     C     S1PRCE        WHENNE    *ZEROS
     C                   Z-ADD     S1PRCE        DIPPRC
     C                   ENDSL
     C                   UPDATE    DGITEMR
     C                   ENDIF
      *
      * ?Add/update ITEM & ITEM/WAREHOUSE record
      *
B004 C*          DGRCID    IFEQ 'IM'
     C     S1RCQT        IFNE      *ZEROS
     C                   MOVEL     S1ITEM        IWPITM
     C                   MOVEL     S1ITEM        PROD
     C                   MOVE      S1SIZE        IWSIZE
     C     S1OWH         IFNE      *ZERO
     C                   MOVE      S1OWH         IWWHSE
     C                   ELSE
     C                   MOVE      S1WHSE        IWWHSE
     C                   ENDIF
     C     S1OPRC        IFNE      *ZERO
     C                   MOVE      S1OPRC        DHPPRC
     C                   ELSE
     C                   MOVE      S1PRCE        DHPPRC
     C                   ENDIF
     C                   CLEAR                   *IN99
     C     IWHKEY        CHAIN     ITMWHSR                            99
     C     *IN99         IFEQ      '0'
     C*                    ADD  S1RCQT    IWQTOH
     C                   ADD       RECQTY        IWQTOH
     C                   UPDATE    ITMWHSR
     C                   ELSE
     C*                    Z-ADDS1RCQT    IWQTOH
     C                   Z-ADD     RECQTY        IWQTOH
     C                   WRITE     ITMWHSR
     C                   ENDIF
      *
      * ?Add ITEM HISTORY RECORD
      *
B004 C     S1RCQT        IFNE      *ZEROS
     C                   MOVE      DGPOYR        DHPOYR
     C                   MOVE      DGDGPO        DHDGPO
     C                   MOVEL     S1ITEM        DHPITM
     C                   MOVEL     S1ITEM        PROD
     C                   MOVE      S1SIZE        DHPSIZ
     C                   MOVE      IWWHSE        DHTWHS
     C                   MOVE      'R'           DHTRAN
     C                   MOVEL     'PO'          DHTYP            10
     C                   MOVE      'RECEIPT'     DHTYP
     C                   MOVE      DHTYP         DHTYPE
     C*                    Z-ADDS1RCQT    DHTQTY
     C                   Z-ADD     RECQTY        DHTQTY
     C     UDATE         MULT      10000.01      WKYMD             6 0
     C     WKYMD         IFGT      950000
     C     WKYMD         ADD       19000000      DHCYMD
     C                   ELSE
     C     WKYMD         ADD       20000000      DHCYMD
     C                   ENDIF
     C                   WRITE     DGHISTR
E004 C                   ENDIF
      *
      * ?Print P/O detail
      *
     C     S1RCQT        IFNE      *ZEROS
     C**         S1WTRC    IFNE *ZEROS
     C                   EXSR      $PRDTL
     C                   ENDIF
E003 C                   ENDIF
      *
E002 C                   ENDIF
E002 C                   ENDIF
E001 C                   ENDDO
      **************
      * ?Print P/O total
      **************
     C                   WRITE     TOTAL
     C                   CLEAR                   PRPTTL
      * ?
      *
      * ?Read thru all detail records in P/O.
      * ?- If status is "C" for all detail lines, & all detail lines
      * ?  have prices, change header status to "H" (history).
      *
     C                   MOVE      'Y'           WKSTS             1
     C                   CLEAR                   *IN69
     C     HDKEY         SETLL     DGDTL
     C     HDKEY         READE     DGDTL                                  69
     C     *IN69         DOWEQ     '0'
     C     DDRSTS        IFNE      'C'
     C     DDOPRC        OREQ      *ZEROS
     C                   MOVE      'N'           WKSTS
     C                   LEAVE
     C                   ENDIF
     C     HDKEY         READE     DGDTL                                  69
     C                   ENDDO
      *
     C     WKSTS         IFEQ      'Y'
     C                   CLEAR                   *IN99
     C     HDKEY         CHAIN     DGHDR                              99
     C     *IN99         IFEQ      '0'
     C                   MOVE      'H'           DGOST
     C                   UPDATE    DGHDR
     C                   ENDIF
     C                   ENDIF
      *
     C                   CLEAR                   *IN99
     C     HDKEY         CHAIN     DGHDR                              99
     C     *IN99         IFEQ      '0'
     C                   MOVE      RDATE         DGRDTE
     C                   MOVEL     20            DGRDTE
     C                   UPDATE    DGHDR
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
      * ?$PRHDR - Prints the receiver header lines                      ?*
      ********************************************************************
     CSR   $PRHDR        BEGSR
      **************
      * ?Fill header fields
      **************
      * ?P/O year & number
     C                   Z-ADD     DGPOYR        PRPOYR
     C                   Z-ADD     DGDGPO        PRDGPO
      * ?Company name
     C                   MOVEL     POCONM        PRCNAM
      * ?
      * ?Company address
     C                   CLEAR                   A
     C     POCOA1        IFNE      *BLANKS
     C                   ADD       1             A                 1 0
     C                   MOVEL     POCOA1        CADR(A)
     C                   ENDIF
     C     POCOA2        IFNE      *BLANKS
     C                   ADD       1             A
     C                   MOVEL     POCOA2        CADR(A)
     C                   ENDIF
     C     POCOCY        CAT(P)    ',':0         WKCSZ            35
     C                   CAT       POCOST:1      WKCSZ
     C                   CAT       POCOZP:1      WKCSZ
     C                   ADD       1             A
     C                   MOVEL     WKCSZ         CADR(A)
      *
     C                   MOVEL     CADR(1)       PRCAD1
     C                   MOVEL     CADR(2)       PRCAD2
     C                   MOVEL     CADR(3)       PRCAD3
     C                   MOVEL     CADR(4)       PRCAD4
      * ?
      * ?Get warehouse master record
     C                   CLEAR                   *IN99
     C     DGWHSE        CHAIN     WHSE                               99
      * ?
      * ?Warehouse name
     C                   MOVEL     WHWNAM        PRWNAM
      * ?
      * ?Warehouse address
     C                   CLEAR                   A
     C     WHWAD1        IFNE      *BLANKS
     C                   ADD       1             A
     C                   MOVEL     WHWAD1        WADR(A)
     C                   ENDIF
     C     WHWAD2        IFNE      *BLANKS
     C                   ADD       1             A
     C                   MOVEL     WHWAD2        WADR(A)
     C                   ENDIF
     C     WHWAD3        IFNE      *BLANKS
     C                   ADD       1             A
     C                   MOVEL     WHWAD3        WADR(A)
     C                   ENDIF
     C     WHWCTY        CAT(P)    ',':0         WKCSZ
     C                   CAT       WHWSTT:1      WKCSZ
     C                   CAT       WHWZIP:1      WKCSZ
     C                   ADD       1             A
     C                   MOVEL     WKCSZ         WADR(A)
      *
     C                   MOVEL     WADR(1)       PRWAD1
     C                   MOVEL     WADR(2)       PRWAD2
     C                   MOVEL     WADR(3)       PRWAD3
     C                   MOVEL     WADR(4)       PRWAD4
      * ?Vendor Number
     C                   Z-ADD     DGVNDR        PRVNDR
      * ?Vendor Name
     C                   MOVEL     VMNAME        PRJNAM
      * ?
      * ?Vendor address
     C                   CLEAR                   A
     C     VMADD2        IFNE      *BLANKS
     C                   ADD       1             A
     C                   MOVEL     VMADD2        JADR(A)
     C                   ENDIF
     C     VMADD3        IFNE      *BLANKS
     C                   ADD       1             A
     C                   MOVEL     VMADD3        JADR(A)
     C                   ENDIF
     C     VMCITY        CAT(P)    ',':0         WKCSZ
     C                   CAT       VMSTST:1      WKCSZ
     C                   MOVEL     VMZIPD        WKZIP5            5
     C                   MOVE      VMZIPD        WKZIP4            4
     C                   CAT       WKZIP5:1      WKCSZ
     C     WKZIP4        IFNE      *BLANKS
     C                   CAT       '-':0         WKCSZ
     C                   CAT       WKZIP4:0      WKCSZ
     C                   ENDIF
     C                   ADD       1             A
     C                   MOVEL     WKCSZ         JADR(A)
      *
     C                   MOVEL     JADR(1)       PRJAD1
     C                   MOVEL     JADR(2)       PRJAD2
     C                   MOVEL     JADR(3)       PRJAD3
      * ?Receipt date
     C                   Z-ADD     UDATE         PRDATE
      * ?Receipt number
     C                   Z-ADD     DRREC#        PRREC#
      **************
      * ?Print headings
      **************
     C                   CLEAR                   *IN31
     C                   CLEAR                   *IN32
     C                   CLEAR                   *IN50
     C                   CLEAR                   *IN51
      **************
      * ?Check for Comments line 2 and 3
      **************
     C     DGCOM2        IFNE      *BLANKS
     C                   MOVE      *ON           *IN50
     C                   ENDIF
     C     DGCOM3        IFNE      *BLANKS
     C                   MOVE      *ON           *IN51
     C                   ENDIF
     C                   Z-ADD     DGDUDT        PDUEDT            6 0
     C                   MOVE      RDATE         RECDTE            6 0
     C     RECDTE        MULT      100.0001      RECDTE
      * ?
     C                   WRITE     HEADER
      *
     C                   ENDSR
      ********************************************************************
      * ?$PRDTL - Prints the receiver detail lines                      ?*
      ********************************************************************
     CSR   $PRDTL        BEGSR
      **************
      * ?Fill detail fields
      **************
      *
      * ?Item number
     C                   MOVEL     DDITEM        PRITEM
     C*                    MOVE DDSIZE    PRSIZE
      *
      * ?Weight received
     C                   Z-ADD     S1PQTY        PRQORD
     C                   Z-ADD     S1RCQT        PRRCQT
     C****                 Z-ADDS1WTRC    PRWTRC
      *
      * ?Item description
     C*                    MOVELS1PRDN    PRDESC
     C                   MOVEL     DDIDS1        PRDESC
     C*                    MOVE IMINVN    PRGL#
      *
      * ?Override warehouse
     C                   SELECT
     C     S1OWH         WHENNE    *ZERO
     C     S1OWH         ANDNE     DDWHSE
     C                   MOVE      S1OWH         PROWH             2
     C     S1OWH         WHENEQ    *ZERO
     C     DDWHSE        ANDNE     DGWHSE
     C                   MOVE      DDWHSE        PROWH
     C                   OTHER
     C                   CLEAR                   PROWH
     C                   ENDSL
      *
      * ?Unit cost
     C     S1OPRC        IFNE      *ZEROS
     C                   Z-ADD     S1OPRC        PRRPRC
     C                   ELSE
     C                   Z-ADD     S1PRCE        PRRPRC
     C                   ENDIF
     C                   Z-ADD     DDVPRC        PRVPRC
      *
      * ?Check Price to Preferred Vendor Price
     C*                    MOVE *OFF      *IN75
     C*                    CLEARASTRSK
     C*          SERKEY    CHAINFMINSER              99
     C*          *IN99     IFEQ *OFF                                      ARC380
     C*          MINKEY    CHAINFSERIES              98
     C*          *IN98     IFEQ *OFF                                      ARC380
     C*          PRCKEY    CHAINFSERPRC              97
     C*          *IN97     IFEQ *OFF                                      ARC380
     C*          SPPRC1    IFNE *ZERO                                     ARC380
     C*                    Z-ADDSPPRC1    PRFPRC  94                      ARC380
     C*                    END                                            ARC380
     C*          SPPRC1    IFEQ *ZERO                                     ARC380
     C*          SPPRC2    IFNE *ZERO                                     ARC380
     C*                    Z-ADDSPPRC2    PRFPRC                          ARC380
     C*                    END                                            ARC380
     C*                    END                                            ARC380
     C*          SPPRC1    IFEQ *ZERO                                     ARC380
     C*          SPPRC2    IFEQ *ZERO                                     ARC380
     C*          SPPRC3    IFNE *ZERO                                     ARC380
     C*                    Z-ADDSPPRC3    PRFPRC                          ARC380
     C*                    END                                            ARC380
     C*                    END                                            ARC380
     C*                    END                                            ARC380
     C*          PRRPRC    IFNE PRFPRC
     C*                    MOVE *ON       *IN75
     C*                    MOVE '**'      ASTRSK  2
     C*                    ENDIF
     C*                    ENDIF
     C*                    ENDIF
     C*                    ENDIF
     C*          *IN76     IFEQ *OFF                                      ARC380
     C*          *IN75     ANDEQ*ON                                       ARC380
     C*                    MOVE *ON       *IN76
     C*                    ENDIF
      *
      * ?Line total
     C     PRRPRC        MULT(H)   PRRCQT        PRLTTL
      **************
      * ?Check for overflow
      **************
     C     *IN88         IFEQ      *ON
     C                   WRITE     HEADER
     C                   CLEAR                   *IN88
     C                   ENDIF
      **************
      * ?Accumulate order total
      **************
     C                   ADD       PRLTTL        PRPTTL
      **************
      * ?Print detail line
      **************
     C                   CLEAR                   *IN31
     C                   WRITE     DETAIL
     C                   CLEAR                   PRLTTL
     C                   CLEAR                   PRRPRC
     C*                    CLEARPRFPRC
     C                   CLEAR                   PRVPRC
     C                   CLEAR                   PRRCQT
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
      * ?BLNKS2 - Clear the subfile and write one blank record          ?*
      ********************************************************************
     CSR   BLNKS2        BEGSR
      *
      * ?Clear Subfile Fields                             ?
      *
     C                   CLEAR                   S2DATA
      *
      *? Clear the subfile                                ?             ?
      *
      *
     C                   MOVE      *ON           *IN80
     C                   Z-ADD     *ZERO         S2RRN             5 0
     C                   Z-ADD     1             ##RRNO
     C                   WRITE     S2CNTL
      *
      *? Write a blank, non-display record                ?             ?
      *
     C                   MOVE      *ON           *IN96
     C                   ADD       1             S2RRN
     C                   WRITE     S2DATA
     C                   MOVE      *OFF          *IN80
     C                   MOVE      *OFF          *IN96
      *
     CSR                 ENDSR
      ********************************************************************
      * ?$SVENT - Saves entries from subfile when switching statuses    ?*
      ********************************************************************
     CSR   $SVENT        BEGSR
      *
      *? Read thru entire subfile                                       ?
      *
B001 C                   DO        MXRRN         X
     C     X             CHAIN     S1DATA                             68
      *
B002 C                   SELECT
     C     *IN68         WHENEQ    '1'
     C                   LEAVE
      *
     C     S1RCQT        WHENNE    *ZEROS
     C     S1OPRC        ORNE      *ZEROS
     C     S1OWH         ORNE      *ZERO
     C     S1OSTS        ORNE      *BLANKS
     C                   MOVEL     S1LOOK        WKLOOK
     C                   MOVEL     S1ITEM        WKITEM
     C                   MOVE      S1SIZE        WKSIZE
     C                   Z-ADD     S1RCQT        WKRCQT
     C                   Z-ADD     S1OPRC        WKOPRC
     C                   MOVE      S1OWH         WKOWH
     C                   MOVE      S1OSTS        WKOSTS
     C                   WRITE     DG0013W
E002 C                   ENDSL
      *
E001 C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
      * ?$DLENT - Deletes entries from work file                        ?*
      ********************************************************************
     CSR   $DLENT        BEGSR
      *
      *? Read thru entire file                                          ?
      *
     C     *LOVAL        SETLL     DG0013W
      *
B001 C                   DO        999999
     C                   READ      DG0013W                                69
      *
B002 C                   SELECT
     C     *IN69         WHENEQ    '1'
     C                   LEAVE
      *
     C                   OTHER
     C                   DELETE    DG0013W
E002 C                   ENDSL
      *
E001 C                   ENDDO
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
      * ?*ENTRY parameter list
      *
     C     *ENTRY        PLIST
     C                   PARM                    #EPOYR            2
     C                   PARM                    #EJBPO            6
     C                   PARM                    RDATE             6
      *
      * ?Move *ENTRY parms to numeric fields
      *
     C                   MOVE      #EPOYR        DGPOYR
     C                   MOVE      #EJBPO        DGDGPO
      *
      * Define *LIKE Fields ?
      *
     C     *LIKE         DEFINE    #SFLPG        ##ROLL
     C     *LIKE         DEFINE    #SFLPG        ##FWRL
     C     *LIKE         DEFINE    #SFLPG        ##LOAD
     C     *LIKE         DEFINE    DDITEM        SVITEM
     C     *LIKE         DEFINE    DDITEM        DDPITM
     C     *LIKE         DEFINE    DDSIZE        DDPSIZ
     C     *LIKE         DEFINE    DDITEM        C1ITEM
     C     *LIKE         DEFINE    DDSIZE        C1SIZE
     C     *LIKE         DEFINE    S1RCQT        XXRCQT
     C     *LIKE         DEFINE    S1RCQT        CKRCQT
     C     *LIKE         DEFINE    DDRSTS        WKRSTS
      *
      * Define Key Lists ?
      *
      * ?KLIST for Vendor P/O Header File
      *
     C     HDKEY         KLIST
     C                   KFLD                    DGPOYR
     C                   KFLD                    DGDGPO
      *
      * ?KLIST for Vendor P/O Detail File
      *
     C     DTKEY         KLIST
     C                   KFLD                    DGPOYR
     C                   KFLD                    DGDGPO
     C                   KFLD                    DDLOOK
     C                   KFLD                    DDITEM
     C                   KFLD                    DDSIZE
      *
      * ?KLIST for ITEM WAREHOUSE MASTER FILE
      *
     C     IWHKEY        KLIST
     C                   KFLD                    DDPITM
     C                   KFLD                    DDPSIZ
     C                   KFLD                    IWWHSE
      *
      * ?KLIST for P/O Receipts File
      *
     C     RCKEY         KLIST
     C                   KFLD                    DGPOYR
     C                   KFLD                    DRDGPO
     C                   KFLD                    DRLOOK
     C                   KFLD                    DRITEM
     C                   KFLD                    DRSIZE
      *
      * ?KLIST for Vendor Item Master File
      *
     C     ITKEY         KLIST
     C                   KFLD                    DGVNDR
     C                   KFLD                    DDLOOK
     C                   KFLD                    DDPITM
     C                   KFLD                    DDPSIZ
      *
      * ?KLIST for Product Master and FMINSER File
      *
     C     PRKEY         KLIST
     C                   KFLD                    DDPITM
     C                   KFLD                    DDPSIZ
      * ?KLIST for Work File HG0013W
      *
     C     WKKEY         KLIST
     C                   KFLD                    DDLOOK
     C                   KFLD                    DDITEM
      *
      * ?KLIST for FMVEND
      *
     C     VMKEY         KLIST
     C                   KFLD                    DGVNDR
      * ?                                                  ?
      * ?KLIST for file - FMINSER Library - *LIBL     ?
      *
     C*          SERKEY    KLIST
     C*                    KFLD           DDPITM
      * ?                                                  ?
      * ?KLIST for file - FSERIES Library - *LIBL     ?
      *
     C*          MINKEY    KLIST
     C*                    KFLD           ISCODE
      * ?                                                  ?
      * ?KLIST for file - FSERPRC Library - *LIBL     ?
      *
     C*          PRCKEY    KLIST
     C*                    KFLD           SEVND
     C*                    KFLD           ISCODE
      *
      * ?KLIST for Security file by User ID
      *
     C     USKEY         KLIST
     C                   KFLD                    USSYS
     C                   KFLD                    USUSID
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
      *? Initial message                                                ?
      *
     C                   MOVE      'SR00012'     $#MSID
     C                   EXSR      SRMSGF
      *
      *? Position cursor at product number input field     ?            ?
      *
     C                   MOVE      '1'           *IN30
      * ?
      * ?Get P/O control file
      * ?
     C     999999        CHAIN     POCNTL                             99
     C                   MOVE      #EPOYR        DGPOYR
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
     C                   Z-ADD     6             #SFLPG            4 0          SFLPAG(7) Folded Siz
     C                   Z-ADD     2             ##FWRL                         SFL Roll Forward 14
     C                   Z-ADD     4             ##LOAD                         SFL Load 28 Records
      *
      *? Get P/O header record                                   ?             ?
     C                   CLEAR                   *IN99
     C     HDKEY         CHAIN(N)  DGHDR                              99
     C                   MOVEL     DGPOYR        DGKEY#
     C                   MOVE      DGDGPO        DGKEY#
      *
      *? Determine receipt number for this receipt                    ?        ?
     C                   CLEAR                   *IN99
     C     HDKEY         SETGT     RECL1
     C     HDKEY         READPE    RECL1                                  99
     C                   ADD       1             DRREC#
      *
      *? Get Jobber master record                                ?             ?
     C                   CLEAR                   *IN99
     C     VMKEY         CHAIN     FMVEND                             99
     C                   MOVEL     VMNAME        DGNAME
      *
      *? Get security record                             ?             ?
      *
     C                   EXSR      $SSPGM
     C     USFL07        IFEQ      'Y'
     C                   MOVE      *ON           *IN61
     C                   ENDIF
      *
      *? Initialize field protect indicator for Price, Warehouse, & Sts ?
      *
     C                   MOVE      '1'           *IN84
      *
      *? Initialize display options                                     ?
      *
     C                   MOVE      @CUNDO        UNDER
     C                   MOVE      @CF11A        CKYF11
     C                   MOVE      'O'           WKRSTS
      *
      *? Initial Sub File Load.                                  ?             ?
     C                   EXSR      LOADSF
      *
     C                   MOVEL     ##USER        DHUSER
     CSR                 ENDSR
