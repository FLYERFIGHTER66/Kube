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
      * Program?- HG0119                                                 *
      *                                                                   *
      * Purpose?- Hard Goods P/O Detail File Maintenance                 *
      *                                                                   *
      *    Date  Programmer    ? Comment                             ? *
      *  3/02/2004 R. Piasecki      Program Created                       *
      *                                                                   *
      *********************************************************************
     FSECUSER   IF   E           K DISK
     FHGVITM    UF   E           K DISK
     FFMINVT    IF   E           K DISK
     FHGROHD    IF   E           K DISK
     FHGRODT    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     F**TABL  IF  E           K        DISK
     FKPWHOUSE  IF   E           K DISK
      *
     FHG0119S   CF   E             WORKSTN
     F                                     SFILE(S1DATA:S1RRN)
     F                                     SFILE(S2DATA:S2RRN)
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
     D  S1PROD                 1      6
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
     D  #MPROD                 1     10
     D  #MVNDR                11     14P 0
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
B002 C                   SELECT
      *
      * ?F3 or F12 pressed                                ?
     C     *IN03         WHENEQ    *ON
     C     *IN12         OREQ      *ON
     C                   MOVE      '  '          #EFKEY
     C                   MOVE      YES           ENDPGM            3
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
     C                   MOVE      *LOVAL        DILOOK
     C                   MOVE      *LOVAL        DIPITM
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
     C                   MOVEL     DIPITM        PROD             12
     C                   MOVE      DISIZE        S1SIZE
     C     PRKEY         CHAIN     RMINVT                             99
     C     *IN99         IFEQ      '0'
      *
     C                   EXSR      MOV@S1
      *
     C     WKMODE        IFEQ      'I'
     C     S1QTYO        ANDNE     *ZEROS
      *
     C     WKMODE        ORNE      'I'
     C     DIRSTS        ANDEQ     'D'
     C     S1QTYO        ANDNE     *ZEROS
      *
     C     WKMODE        ORNE      'I'
     C     DIRSTS        ANDNE     'D'
     C                   ADD       1             S1RRN
     C                   WRITE     S1DATA
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
     C     WKMODE        IFEQ      'I'
     C     S1QTYO        ANDNE     *ZEROS
      *
     C     WKMODE        ORNE      'I'
     C     DIRSTS        ANDEQ     'D'
     C     S1QTYO        ANDNE     *ZEROS
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
     C     DGVNDR        SETLL     HGVITM
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
      *
      * ?Set on global field protect indicator if Inquiry mode
      *
     C     WKMODE        IFEQ      'I'
     C                   MOVE      *ON           *IN82
     C                   ELSE
     C                   CLEAR                   *IN82
     C                   ENDIF
      *
      * ?P/O Jobber Item File Fields              ?
      *
     C                   MOVE      DILOOK        S1LOOK
     C                   MOVEL     DIPITM        S1PROD
     C                   MOVE      DIPITM        PROD
     C                   MOVEL     DISIZE        S1SIZE
      *
      * ?P/O Header File Fields              ?
      *
     C*                    MOVE DGWHSE    S1WHSE
      *
      * ?P/O Detail File Fields              ?
      *
     C                   CLEAR                   *IN99
     C     DTKEY         CHAIN     DGRDTL                             99
     C     *IN99         IFEQ      '0'
     C                   MOVEL     DDITEM        PROD
     C                   MOVEL     DDLOOK        S1LOOK
     C                   MOVEL     DDIDS1        S1PRDN
     C*                    MOVELDDPUOM    S1UOM
     C*                    MOVELDDWHSE    S1WHSE
     C                   Z-ADD     DDPQTY        S1QTYO
     C                   MOVE      DDRSTS        S1RSTS
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
     C     S1QTYO        OREQ      *ZERO
     C                   MOVEL     IMDES1        S1PRDN
     C                   ENDIF
     C*                    MOVELIMPUOM    S1UOM
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
B003 C     S1SEL         IFNE      *BLANK
     C                   Z-ADD     S1RRN         ##RRNO
      *
B004 C                   SELECT
     C     S1SEL         WHENEQ    ' '
      *
      *? Invalid Option entered                           ?
      *
     C                   OTHER
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN39
     C                   MOVE      *OFF          $$RLOD
     C                   MOVE      'SF00101'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      YES           ERROR             3
      *
E004 C                   ENDSL
E003 C                   ENDIF
      *
      *? Reset Indicators and Update subfile              ?
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
     C     $$RLOD        IFEQ      *ON
     C                   MOVE      *ON           *IN28
     C                   EXSR      LOADSF
     C                   ENDIF
      *
     CSR                 ENDSR
      ********************************************************************
      * ?SRDEL  - Check for Delete option and process                   ?*
      ********************************************************************
     CSR   SRDEL         BEGSR
      *
      *?   Clear the subfile                              ?             ?
      *
     C                   MOVE      *ON           *IN80
     C                   Z-ADD     *ZERO         S2RRN             5 0
     C                   WRITE     S2CNTL
     C                   CLEAR                   S2DATA
     C                   MOVE      *OFF          *IN80
      *
      *? Set loop -- read all changed subfile records     ?             ?
      *
B001 C     *IN66         DOUEQ     '1'
     C                   READC     S1DATA                                 66
B002 C     *IN66         IFEQ      *OFF
      *
      *? Set Subfile Next Change                          ?             ?
      *
     C                   MOVE      *ON           *IN39
      *
      *? Selection 4 - Delete                             ?             ?
      *
B003 C     S1SEL         IFEQ      '4'
     C                   ADD       1             S2RRN
     C                   WRITE     S2DATA
     C                   CLEAR                   S1SEL
     C                   MOVE      *OFF          *IN39
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
     C                   Z-ADD     1             #2RRNO
      *
      *? Save number of records                           ?             ?
      *
     C                   Z-ADD     S2RRN         $2RRN             5 0
      *
      *? Delete message                                   ?             ?
      *
     C                   MOVE      'SR00015'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
      *
      *? Display the screen                               ?             ?
      *
     C     *IN03         DOUEQ     *ON
     C     *IN12         OREQ      *ON
     C     *IN10         OREQ      *ON
      *
     C                   WRITE     CFKY02
     C                   WRITE     MSGCTL
     C                   EXFMT     S2CNTL
      *
      *? Process each subfile record                      ?             ?
      *
     C     *IN10         IFEQ      *ON
     C                   MOVE      '10'          #EFKEY
     C                   MOVE      YES           ENDPGM
     C     1             DO        $2RRN         $$RRN             5 0
     C     $$RRN         CHAIN     S2DATA                             66
     C     *IN66         IFEQ      *OFF
     C                   MOVE      *ON           $$RLOD
     C                   MOVEL     S1PROD        PROD
     C     ITKEY         CHAIN     DGITEMR                            67
     C     *IN67         IFEQ      *OFF
     C                   MOVE      'D'           DIRSTS
     C                   UPDATE    DGITEMR
      *
     C                   END
     C                   END
     C                   END       1
     C                   END
      *
     C                   ENDDO
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
     C                   PARM                    #EDGPO            6
     C                   PARM                    #EMODE            1
     C                   PARM                    #EFKEY            2
      *
      * ?Move *ENTRY parms to numeric fields
      *
     C                   MOVE      #EPOYR        DGPOYR
     C                   MOVE      #EDGPO        DGDGPO
      *
     C                   MOVE      #EMODE        WKMODE            1
      *
      * Define *LIKE Fields ?
      *
     C     *LIKE         DEFINE    #SFLPG        ##ROLL
     C     *LIKE         DEFINE    #SFLPG        ##FWRL
     C     *LIKE         DEFINE    #SFLPG        ##LOAD
     C     *LIKE         DEFINE    DDPQTY        SVPQTY
     C     *LIKE         DEFINE    DDIDS1        SVPRDN
     C     *LIKE         DEFINE    DGRCID        #ERCID
     C     *LIKE         DEFINE    DIPITM        SVITEM
     C     *LIKE         DEFINE    DISIZE        SVSIZE
     C     *LIKE         DEFINE    DILOOK        SVLOOK
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
     C     PRKEY         KLIST
     C                   KFLD                    PROD
     C                   KFLD                    S1SIZE
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
     C     HDKEY         CHAIN     DGRHDR                             99
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
      *? Initial Sub File Load.                                  ?             ?
     C                   EXSR      LOADSF
      *
     CSR                 ENDSR
