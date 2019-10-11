      *%*******************************************************************
      *%                                                                 **
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?-       Inventory Purchasing System               **
      *%                                                               ?**
      *********************************************************************
      *                                                                   *
      * Program?- HG0030R                                                *
      *                                                                   *
      * Purpose?- Open PO's by Item Inquiry Selection Program            *
      *                                                                   *
      *   Date  ?Programmer    ? Comment                             ? *
      *  05/15/04  R. Piasecki      Program Created                       *
      *                                                                   *
      *********************************************************************
     FSECUSER   IF   E           K DISK
     FFMINVTL8  IF   E           K DISK
     FFMINVTL7  IF   E           K DISK
     F                                     RENAME(RMINVT:PRDNM)
     F                                     INFDS(INFDS1)
     FHG0030S   CF   E             WORKSTN
     F                                     SFILE(S1DATA:S1RRN)
     F                                     INFDS(INFDS3)
      ********************************************************************
      * ?Tables & arrays                                                ?*
      ********************************************************************
     D OTX             S             15    DIM(1) CTDATA PERRCD(1)
     D OPT             S              1    DIM(5)
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
      *? Position to requested -- change in CHAIN/NAME    ?
     C     *IN28         WHENEQ    *ON
      *
      * ?If first position of description is "?", set scan flag         ?*
     C                   MOVE      'N'           WKSCAN            1
     C                   MOVEL     C1PDS1        CKSCAN            1
     C                   MOVE      C1PDS1        CKDESC           29
     C     CKSCAN        IFEQ      '?'
     C     CKDESC        ANDNE     *BLANKS
     C                   MOVE      'Y'           WKSCAN
     C     ' '           CHECKR    CKDESC        I                 2 0
     C                   ENDIF
      *
      *? Should SFL be Ordered By PRD# and NAME or NAME    Only         ?
      *? Remains the same if Both are Blanks.
     C     C1PRD#        IFEQ      *BLANKS
     C     C1PDS1        ANDNE     *BLANKS
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
     C                   MOVE      'KP00301'     $#MSID                         ?Message Id   ?
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
     C                   MOVE      'KP00301'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
      *? No Records Loaded to SFL
     C                   OTHER
     C                   Z-ADD     1             ##RRNO
     C                   MOVE      'KP00302'     $#MSID                         ?Message Id   ?
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
     C                   MOVEL     C1PRD#        SVPRD#
     C                   MOVEL     C1SIZE        SVSIZE
     C                   MOVEL     C1PDS1        SVPDS1
      *
      *? Set File Position                                ?             ?
     C                   SELECT
     C     *IN28         WHENEQ    *OFF
     C                   MOVE      *LOVAL        IMITEM
     C                   MOVE      *LOVAL        IMSIZE
     C                   MOVE      *LOVAL        IMDES1
     C     WKSCAN        WHENEQ    'Y'
     C                   MOVEL     C1PRD#        IMITEM
     C                   MOVE      *LOVAL        IMSIZE
     C                   MOVE      *LOVAL        IMDES1
     C                   OTHER
     C                   MOVEL     C1PRD#        IMITEM
     C                   MOVEL     C1SIZE        IMSIZE
     C                   MOVEL     C1PDS1        IMDES1
     C                   ENDSL
      *
      *? Check for BOF                                    ?             ?
     C                   SELECT
     C     NMFLAG        WHENEQ    YES
     C     PRKEY2        SETLL     PRDNM
     C                   READP     PRDNM                                  66
     C     WKSCAN        WHENEQ    'N'
     C     PRKEY         SETLL     RMINVT
     C                   READP     RMINVT                                 66
     C     WKSCAN        WHENEQ    'Y'
     C     PRKEY         SETLL     RMINVT
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
     C                   MOVE      *LOVAL        IMITEM
     C                   MOVE      *LOVAL        IMSIZE
     C                   MOVE      *LOVAL        IMDES1
     C     WKSCAN        WHENEQ    'Y'
     C                   MOVEL     C1PRD#        IMITEM
     C                   MOVEL     C1SIZE        IMSIZE
     C                   MOVE      *LOVAL        IMDES1
     C                   OTHER
     C                   MOVEL     C1PRD#        IMITEM
     C                   MOVEL     C1SIZE        IMSIZE
     C                   MOVEL     C1PDS1        IMDES1
     C                   ENDSL
      *
     C     NMFLAG        IFEQ      YES
     C     PRKEY2        SETLL     PRDNM
     C                   ELSE
     C     PRKEY         SETLL     RMINVT
     C                   END
      *
     C                   CLEAR                   C1PRD#
     C                   CLEAR                   C1SIZE
     C     WKSCAN        IFNE      'Y'
     C                   CLEAR                   C1PDS1
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
     C                   READ      PRDNM                                  66
     C     WKSCAN        WHENNE    'Y'
     C                   READ      RMINVT                                 66
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
     C                   MOVE      'KP00301'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   ELSE
      *
      *? If no records loaded                             ?
      *
     C                   MOVE      *OFF          $$LOAD            1
     C                   EXSR      BLNKSF
     C                   MOVE      'KP00302'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   END
      *
     CSR                 ENDSR
      ********************************************************************
      * ?LOAD## - Load the PRODUCT Master Display                       ?*
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
     C                   READ      PRDNM                                  66
     C     WKSCAN        WHENNE    'Y'
     C                   READ      RMINVT                                 66
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
      * ?Item Master File Fields.                    ?
      *
     C                   Z-ADD     *ZERO         QTYOH
     C                   MOVEL     IMITEM        S1PRD#
     C                   MOVEL     IMSIZE        S1SIZE
     C                   MOVEL     IMDES1        S1PDS1
     C                   MOVEL     IMDES2        S1PDS2
     C*          IMOPNB    ADD  IMMTDR    QTYOH   90
     C*                    ADD  IMMTDI    QTYOH
     C*                    ADD  IMMTDA    QTYOH
     C                   Z-ADD     IMQTOH        QTYOH             9 0
     C                   Z-ADD     QTYOH         S1QTOH
     C                   Z-ADD     IMQTOO        S1QTOO
      *
     CSR                 ENDSR
      *****************************************************************
      * ?BACKSF - Roll Back File One Page of SFL Records            ? *
      *****************************************************************
     CSR   BACKSF        BEGSR
      *
      *? Restore Saved Position to Fields from last SFL Load            ?
      *
     C                   MOVE      SVPRD#        C1PRD#
     C                   MOVE      SVSIZE        C1SIZE
     C                   MOVE      SVPDS1        C1PDS1
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
     C                   MOVE      C1PRD#        IMITEM
     C                   MOVE      C1SIZE        IMSIZE
     C                   MOVE      C1PDS1        IMDES1
      *
     C     NMFLAG        IFEQ      YES
     C     PRKEY2        SETLL     PRDNM
     C                   ELSE
     C     PRKEY         SETLL     RMINVT
     C                   ENDIF
      *
     C     1             DO        ##ROLL
      *
     C                   SELECT
     C     NMFLAG        WHENEQ    YES
     C                   READP     PRDNM                                  66
     C     WKSCAN        WHENNE    'Y'
     C                   READP     RMINVT                                 66
     C     WKSCAN        WHENEQ    'Y'
     C                   EXSR      $READP
     C                   ENDSL
      *
     C     *IN66         IFEQ      *ON
.    C                   MOVE      *LOVAL        IMITEM
.    C                   MOVE      *LOVAL        IMSIZE
.    C                   MOVE      *LOVAL        IMDES1
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
.    C                   MOVE      IMITEM        C1PRD#
.    C                   MOVE      IMSIZE        C1SIZE
.    C                   MOVE      IMDES1        C1PDS1
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
     C                   READP     RMINVT                                 66
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
     C*          CKDESC:I  SCAN PRPADS    II      20
     C     CKDESC:I      SCAN      IMDES1        III               2 0
     C*          II        IFNE 0
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
     C                   READ      RMINVT                                 66
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
     C*          CKDESC:I  SCAN PRPADS    II      20
     C     CKDESC:I      SCAN      IMDES1        III               2 0
     C*          II        IFNE 0
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
     C                   MOVE      S1PRD#        #PPRD#           12
     C                   MOVE      S1SIZE        #PSIZE            3
     C                   MOVEL     S1PDS1        #PDESC           30
     C                   MOVE      *OFF          EOJ               1
     C                   CALL      'HG0031R '                           69
     C                   PARM                    #PPRD#
     C                   PARM                    #PSIZE
     C                   PARM                    #PDESC
     C                   PARM                    EOJ
     C     EOJ           IFEQ      *ON                                          F3=EXIT
     C                   MOVE      *ON           *INLR
     C                   MOVE      YES           ENDPGM
     C                   LEAVE
     C                   ENDIF
     C     #PPRD#        IFNE      *BLANKS
     C                   MOVE      #PPRD#        C1PRD#
     C                   MOVE      #PSIZE        C1SIZE
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
     C                   CLEAR                   C1PRD#
     C     WKSCAN        IFNE      'Y'
     C                   CLEAR                   C1PDS1
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
      *? Inquiry?                                                       ?
      *
     C     USFL04        IFNE      'N'
     C     USFL04        ANDNE     *BLANK
     C                   MOVEL     OTX(1)        WKOPT             1
     C                   ADD       2             O                 1 0
     C                   MOVE      WKOPT         OPT(O)
     C                   MOVEL     OTX(1)        WKOPTN           20
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
     C     *LIKE         DEFINE    C1PRD#        SVPRD#
     C     *LIKE         DEFINE    C1SIZE        SVSIZE
     C     *LIKE         DEFINE    C1PDS1        SVPDS1
      *
      * Define Key Lists ?
      *
      * ?KLIST for Security file by User ID
      *
     C     USKEY         KLIST
     C                   KFLD                    USSYS
     C                   KFLD                    USUSID
      *
      * ?KLIST for file - FMINVTPF Library - *LIBL     ?
      * ?LF - by ITEM                                ?
      * ?ITEM MASTER                            ?
      *
      *
     C     PRKEY         KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
      * ?KLIST for file - VMINVTL1    Library - *LIBL     ?
      * ?LF - by NAME                           ?
     C     PRKEY2        KLIST
     C                   KFLD                    C1PDS1
     C*                    KFLD           C1PRD#
     C*                    KFLD           C1SIZE
      *
     C                   MOVE      *ON           *IN75
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
2=Inquire
