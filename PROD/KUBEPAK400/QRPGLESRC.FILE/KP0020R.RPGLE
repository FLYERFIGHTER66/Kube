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
      * Program?- KP0020R                                                *
      *                                                                   *
      * Purpose?- Inventory Preferred Vendor Price Inquiry               *
      *                                                                   *
      *    Date  Programmer    ? Comment                             ? *
      * 12/22/2004 R. Piasecki      Program Created                       *
      *                                                                   *
      *********************************************************************
     FSECUSER   IF   E           K DISK
     FKPVITM    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FKPPOHD    IF   E           K DISK
     FKPPODT    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FKPWHOUSE  IF   E           K DISK
     FKP0012WK  IF   E           K DISK
     FFMINSER   IF   E           K DISK
     FFSERPRC   IF   E           K DISK
     FFSERIES   IF   E           K DISK
      *
     FKP0020S   CF   E             WORKSTN
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
     D                 DS                  INZ
     D  FIRST3                 1      3
     D  S1ITEM                 1      6
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
     D                 DS                  INZ
     D  WKDATE                 1      8  0
     D  DGPOEC                 1      2  0
     D  DGPOEY                 3      4  0
     D  DGPOEM                 5      6  0
     D  DGPOED                 7      8  0
      ********************************************************************
      * ?Breakdown of message data                                      ?*
      ********************************************************************
     D                 DS                  INZ
     D  $#MSGD                 1     80
     D  #MLOOK                 1     15
     D  #MPROD                16     25
     D  #MSIZE                26     28
     D  #MVNDR                29     32P 0
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
B001 C     ENDPGM        DOWNE     YES
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
      *? If F3 or F12 not pressed, clear warning flags  ?
     C     *IN03         IFNE      *ON
     C     *IN12         ANDNE     *ON
     C                   CLEAR                   WKWRNG
     C                   ENDIF
      *
      * ?SFL Input Selection                          ?
      *
B002 C                   SELECT
      *
      * ?F12 pressed                                ?
     C     *IN12         WHENEQ    *ON
      *
      * ?If F12 pressed from change review screen,
      * ?return to entry subfile screen.                               g.
B003 C     #EMODE        IFNE      'I'
     C     WKMODE        ANDEQ     'I'
     C                   MOVE      #EMODE        WKMODE
     C                   EXSR      LOADSF
     C                   CLEAR                   WKWRNG
     C                   ELSE
      *
      * ?If warning already issued,
      * ?- or Inquiry mode,
      *? exit program,                                                 g.
      *? else issue appropriate warning.                               g.
B004 C     WKWRNG        IFEQ      'Y'
     C     WKCHNG        OREQ      *BLANK
     C     #EMODE        OREQ      'I'
     C                   MOVE      YES           ENDPGM            3
      *
B005 C     *IN03         IFEQ      *ON
     C                   MOVE      'XX'          #EPOYR
E005 C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      'Y'           WKWRNG            1
E004 C                   ENDIF
E003 C                   ENDIF
      *
      *
      *? F1 - Cursor Help                                 ?
     C     *IN01         WHENEQ    '1'
     C                   EXSR      SRCHLP
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
      *? Clear saved RRN                                                ?
      *
     C                   CLEAR                   SVRRN
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
     C                   MOVE      *LOVAL        DILOOK
     C                   MOVE      *LOVAL        DIPITM
     C                   MOVE      *LOVAL        DISIZE
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
     C                   MOVE      *LOVAL        DILOOK
     C                   MOVE      *LOVAL        DIPITM
     C                   MOVE      *LOVAL        DISIZE
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
     C                   MOVE      DILOOK        S1LOOK
     C                   MOVEL     DIPITM        S1ITEM
     C                   MOVEL     DIPITM        PROD             12
     C                   MOVE      DISIZE        S1SIZE
     C     PRKEY         CHAIN     RMINVT                             99
     C     *IN99         IFEQ      '0'
      *
     C                   EXSR      MOV@S1
      *
      *
     C     WKMODE        IFEQ      'I'
      *
     C     WKMODE        ORNE      'I'
     C     DIRSTS        ANDEQ     'D'
      *
     C     WKMODE        ORNE      'I'
     C     DIRSTS        ANDNE     'D'
     C                   ADD       1             S1RRN
     C                   WRITE     S1DATA
      *
      *? If item was just added, save RRN for positioning SFL
     C     DILOOK        IFEQ      SVLOOK
     C     DIPITM        ANDEQ     SVITEM
     C     DISIZE        ANDEQ     SVSIZE
     C                   Z-ADD     S1RRN         SVRRN
     C                   CLEAR                   SVLOOK
     C                   CLEAR                   SVITEM
     C                   CLEAR                   SVSIZE
     C                   ENDIF
      *
     C****       S1RRN     IFEQ ##ROLL
     C****                 MOVE *ON       $EXLOD
     C****                 END
     C                   ENDIF
     C                   ENDIF
      *
     C                   END
     C                   END
      *
      *? If records loaded                                ?             ?
      *
     C     S1RRN         IFGT      *ZERO
     C     SVRRN         IFNE      *ZEROS
     C                   Z-ADD     SVRRN         ##RRNO
     C                   ELSE
     C                   Z-ADD     1             ##RRNO
     C                   ENDIF
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
     C     WKMODE        IFEQ      'I'
      *
     C     WKMODE        ORNE      'I'
     C     DIRSTS        ANDEQ     'D'
      *
     C     WKMODE        ORNE      'I'
     C     DIRSTS        ANDNE     'D'
     C                   ADD       1             S1RRN
     C                   ADD       1             $COUNT            5 0
     C                   WRITE     S1DATA
     C     $COUNT        IFEQ      ##ROLL
     C                   MOVE      *ON           $EXLOD
     C                   END
     C                   ENDIF
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
     C     DGVNDR        SETLL     KPVITM
      *
     C                   ENDSR
      ********************************************************************
      * ?$READP - Performs read prior on file currently being read      ?*
      ********************************************************************
     CSR   $READP        BEGSR
      *
     C                   CLEAR                   *IN66
     C     DGVNDR        READPE    DGITEMR                                66
      *
     C                   ENDSR
      ********************************************************************
      * ?$READ - Performs read on file currently being read             ?*
      ********************************************************************
     CSR   $READ         BEGSR
      *
     C                   CLEAR                   *IN66
     C     DGVNDR        READE     DGITEMR                                66
      *
     C                   ENDSR
      *****************************************************************
      * ?MOV@S1 - Move File Fields to SFL Display Output Fields     ? *
      *****************************************************************
     CSR   MOV@S1        BEGSR
      *
     C                   CLEAR                   S1DATA
     C                   CLEAR                   *IN85
     C                   MOVE      *OFF          *IN95
     C                   CLEAR                   S1ASTR
     C                   CLEAR                   PRFPRC
      *
      * ?Set on global field protect indicator if Inquiry mode
      *
     C                   MOVE      *ON           *IN82
      *
      * ?P/O Jobber Item File Fields              ?
      *
     C                   MOVE      DILOOK        S1LOOK
     C                   MOVEL     DIPITM        S1ITEM
     C                   MOVEL     DIPITM        PROD
     C                   MOVE      DISIZE        S1SIZE
     C     USFL07        IFEQ      'Y'
     C*          #EMODE    ANDEQ'U'
     C                   CLEAR                   S1VNPR
     C     SERKEY        CHAIN     FMINSER                            99
     C     *IN99         IFEQ      *OFF                                                        ARC38
     C     PRCKEY        CHAIN     FSERPRC                            97
     C     *IN97         IFEQ      *OFF                                                        ARC38
     C     SPPRC1        IFNE      *ZERO                                                       ARC38
     C                   Z-ADD     SPPRC1        S1VNPR           11 5                         ARC38
     C                   END                                                                   ARC38
     C     SPPRC1        IFEQ      *ZERO                                                       ARC38
     C     SPPRC2        IFNE      *ZERO                                                       ARC38
     C                   Z-ADD     SPPRC2        S1VNPR                                        ARC38
     C                   END                                                                   ARC38
     C                   END                                                                   ARC38
     C     SPPRC1        IFEQ      *ZERO                                                       ARC38
     C     SPPRC2        IFEQ      *ZERO                                                       ARC38
     C     SPPRC3        IFNE      *ZERO                                                       ARC38
     C                   Z-ADD     SPPRC3        S1VNPR                                        ARC38
     C                   END                                                                   ARC38
     C                   END                                                                   ARC38
     C                   END                                                                   ARC38
     C                   END                                                                   ARC38
     C                   END                                                                   ARC38
     C*                    Z-ADDIMSEL1    S1PRCE
     C                   Z-ADD     S1VNPR        S1PRCE
      * ?Check Vendor Price to Preferred Vendor Price
     C     MINKEY        CHAIN     FSERIES                            98
     C     *IN98         IFEQ      *OFF                                                        ARC38
     C     PRVKEY        CHAIN     FSERPRC                            97
     C     *IN97         IFEQ      *OFF                                                        ARC38
     C     SPPRC1        IFNE      *ZERO                                                       ARC38
     C                   Z-ADD     SPPRC1        PRFPRC            9 4                         ARC38
     C                   END                                                                   ARC38
     C     SPPRC1        IFEQ      *ZERO                                                       ARC38
     C     SPPRC2        IFNE      *ZERO                                                       ARC38
     C                   Z-ADD     SPPRC2        PRFPRC                                        ARC38
     C                   END                                                                   ARC38
     C                   END                                                                   ARC38
     C     SPPRC1        IFEQ      *ZERO                                                       ARC38
     C     SPPRC2        IFEQ      *ZERO                                                       ARC38
     C     SPPRC3        IFNE      *ZERO                                                       ARC38
     C                   Z-ADD     SPPRC3        PRFPRC                                        ARC38
     C                   END                                                                   ARC38
     C                   END                                                                   ARC38
     C                   END                                                                   ARC38
     C                   CLEAR                   S1PRVN
     C     SEVND         CHAIN     FMVEND                             95
     C     *IN95         IFEQ      *OFF
     C                   MOVEL     VMNAME        S1PRVN
     C                   ENDIF
      * IF NO VENDOR PRICE REPLACE WITH PREFERRED VENDOR PRICE
     C*          S1VNPR    IFEQ *ZERO
     C*                    Z-ADDPRFPRC    S1VNPR
     C                   Z-ADD     PRFPRC        S1PVPR
     C*                    ENDIF
      *
     C*          S1VNPR    IFNE PRFPRC
     C     S1PRCE        IFNE      PRFPRC
     C                   MOVE      *ON           *IN95
     C                   MOVE      '*'           S1ASTR            1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*          *IN95     IFEQ *OFF                                      ARC380
     C*          *IN75     ANDEQ*ON                                       ARC380
     C*                    MOVE *ON       *IN95
     C*                    ENDIF
      *
     C                   ENDIF
      *
      *
      * ?P/O Header File Fields              ?
      *
      *
      * ?P/O Detail File Fields              ?
      *
     C                   CLEAR                   *IN99
     C     DTKEY         CHAIN     DGDTL                              99
     C     *IN99         IFEQ      '0'
     C                   MOVEL     DDITEM        PROD
     C                   MOVEL     DDITEM        S1ITEM
     C                   MOVEL     DDIDS1        S1PRDN
     C                   MOVEL     DDLOOK        S1LOOK
     C                   MOVEL     DDSIZE        S1SIZE
     C                   MOVE      DDRSTS        S1RSTS
     C     USFL07        IFEQ      'Y'
     C     #EMODE        ANDEQ     'U'
     C                   Z-ADD     DDOPRC        S1PRCE
     C*                    Z-ADDDDVPRC    S1VNPR
     C                   ENDIF
     C     DDRSTS        IFEQ      'C'
     C                   MOVE      *ON           *IN85
     C                   ENDIF
     C                   ENDIF
      *
      * ?Get product description
      *
     C                   CLEAR                   *IN99
     C     PRKEY         CHAIN     RMINVT                             99
     C     *IN99         IFEQ      '0'
     C     FIRST3        IFNE      'NSI'
     C                   MOVEL     IMDES1        S1PRDN
     C                   ENDIF
     C                   MOVEL     IMSIZE        S1SIZE
     C                   MOVEL     IMLOOK        S1LOOK
     C                   ENDIF
      *
      * ?Check in work file for prior entries.
      *
     C     WKKEY         CHAIN     DG0012W                            99
     C     *IN99         IFEQ      '0'
     C                   MOVE      WKLOOK        S1LOOK
     C                   MOVE      WKSIZE        S1SIZE
     C                   MOVEL     WKIDS1        S1PRDN
     C                   Z-ADD     WKPRCE        S1PRCE
     C*                    Z-ADDWKVPRC    S1VNPR
     C                   ENDIF
      *
      * ?Set on protect/non-display indicator
      * ?for prices if security flag 7 = N.
      *
     C     USFL07        IFEQ      'N'
     C     #EMODE        ANDNE     'U'
     C                   MOVE      *ON           *IN62
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
      *
      *? Reset Indicators and Update subfile              ?
      *
     C     S1RSTS        IFEQ      'C'
     C                   MOVE      *ON           *IN85
     C                   ELSE
     C                   CLEAR                   *IN85
     C                   ENDIF
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
     C     WKMODE        IFNE      'I'
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
     C                   ENDIF
      *
     C     $$RLOD        IFEQ      *ON
     C                   MOVE      *ON           *IN28
     C                   EXSR      LOADSF
     C                   ENDIF
      *
     CSR                 ENDSR
      ********************************************************************
      *?$CNFRM - Fill confirmation screen                               ?*
      ********************************************************************
     CSR   $CNFRM        BEGSR
      *
      *
      *? Process changes if F10 pressed.                  ?             ?
      *
B002 C     *IN10         IFEQ      *ON
     C                   MOVE      YES           ENDPGM
     C                   MOVE      'XX'          #EPOYR
E002 C                   ENDIF
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
     C                   MOVEL     'KPWPO'       USSYS
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
     C                   PARM                    #EDGPO            6
     C                   PARM                    #EMODE            1
      *
      * ?Move *ENTRY parms to numeric fields
      *
     C                   MOVE      #EPOYR        DGPOYR
     C                   MOVE      #EDGPO        DGDGPO
      *
     C                   MOVE      'I'           WKMODE            1
      *
      * Define *LIKE Fields ?
      *
     C     *LIKE         DEFINE    #SFLPG        ##ROLL
     C     *LIKE         DEFINE    #SFLPG        ##FWRL
     C     *LIKE         DEFINE    #SFLPG        ##LOAD
     C     *LIKE         DEFINE    DDPQTY        SVPQTY
     C     *LIKE         DEFINE    DDIDS1        SVPRDN
     C     *LIKE         DEFINE    DILOOK        SVLOOK
     C     *LIKE         DEFINE    DIPITM        SVITEM
     C     *LIKE         DEFINE    DISIZE        SVSIZE
     C     *LIKE         DEFINE    S1RRN         SVRRN
      *
      * Define Key Lists ?
      *
      * ?KLIST for Jobber P/O Header File
      *
     C     HDKEY         KLIST
     C                   KFLD                    DGPOYR
     C                   KFLD                    DGDGPO
      *
      * ?KLIST for Jobber P/O Detail File
      *
     C     DTKEY         KLIST
     C                   KFLD                    DGPOYR
     C                   KFLD                    DGDGPO
     C                   KFLD                    S1LOOK
     C                   KFLD                    PROD
     C                   KFLD                    S1SIZE
      *
      * ?KLIST for Jobber WORK FILE KP0012WK
      *
     C     WKKEY         KLIST
     C                   KFLD                    DILOOK
     C                   KFLD                    DIPITM
     C                   KFLD                    DISIZE
      *
      * ?KLIST for Jobber Item Master File
      *
     C     ITKEY         KLIST
     C                   KFLD                    DGVNDR
     C                   KFLD                    S1LOOK
     C                   KFLD                    PROD
     C                   KFLD                    S1SIZE
      *
      * ?KLIST for Product Master File
      *
     C     WRKKEY        KLIST
     C                   KFLD                    S1LOOK
     C                   KFLD                    PROD
     C                   KFLD                    S1SIZE
      *
      * ?KLIST for Product Master File
      *
     C     PRKEY         KLIST
     C                   KFLD                    PROD
     C                   KFLD                    S1SIZE
      * ?                                                  ?
      * ?KLIST for file - FSERIES Library - *LIBL     ?
      *
     C     MINKEY        KLIST
     C                   KFLD                    ISCODE
      *
      * ?KLIST for FMVEND
      *
     C     VMKEY         KLIST
     C                   KFLD                    DGVNDR
      *
      * ?KLIST for Security file by User ID
      *
     C     USKEY         KLIST
     C                   KFLD                    USSYS
     C                   KFLD                    USUSID
      * ?KLIST for file - FMINSER Library - *LIBL     ?
      *
     C     SERKEY        KLIST
     C                   KFLD                    PROD
      * ?                                                  ?
      * ?KLIST for file - FSERPRC Library - *LIBL     ?
      *
     C     PRCKEY        KLIST
     C                   KFLD                    DGVNDR
     C                   KFLD                    ISCODE
      * ?                                                  ?
      * ?KLIST for file - FSERPRC Library - *LIBL Selected Vendor
      *
     C     PRVKEY        KLIST
     C                   KFLD                    SEVND
     C                   KFLD                    ISCODE
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
     C     #EMODE        IFNE      'I'
     C                   MOVE      'SR00012'     $#MSID
     C                   EXSR      SRMSGF
     C                   ENDIF
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
     C     HDKEY         CHAIN     DGHDR                              99
     C                   MOVEL     DGPOYR        DGKEY#
     C                   MOVE      DGDGPO        DGKEY#
      *
      *? Get Jobber master record                                ?             ?
     C                   CLEAR                   *IN99
     C     VMKEY         CHAIN     FMVEND                             99
     C                   MOVEL     VMNAME        DGNAME
      *
      *? Get Warehouse master record                                  ?        ?
     C                   CLEAR                   *IN99
     C     DGWHSE        CHAIN     WHSE                               99
     C                   MOVEL     WHWNAM        DGWNAM
      *
      *? Get security record                             ?             ?
      *
     C                   EXSR      $SSPGM
     C     USFL07        IFEQ      'Y'
     C                   MOVE      *ON           *IN61
     C                   ENDIF
      *
      *? Initialize field protect indicator for U/M & WH.               ?
      *
     C                   MOVE      '1'           *IN84
      *
      *? Initial Sub File Load.                                  ?             ?
     C                   EXSR      LOADSF
      *
     CSR                 ENDSR
