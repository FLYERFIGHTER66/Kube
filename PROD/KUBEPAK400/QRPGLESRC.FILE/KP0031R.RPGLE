      *********************************************************************
      *                                                                   *
      * Program?- KP0031R                                                *
      *                                                                   *
      * Purpose?- Display Open PO Detail by Item Number                  *
      *                                                                   *
      *   Date  ?Programmer    ? Comment                             ? *
      *  10/20/03  R. Piasecki      Program Created                       *
      *                                                                   *
      *********************************************************************
     FSECUSER   IF   E           K DISK
     FKPPODTL1  IF   E           K DISK
     FKPPOHD    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FKP0031S   CF   E             WORKSTN
     F                                     SFILE(S1DATA:S1RRN)
     F                                     INFDS(INFDS3)
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
     D                 DS
     D  PODATE                 1      6  0 INZ(0)
     D  DGPOEM                 1      2  0
     D  DGPOED                 3      4  0
     D  DGPOEY                 5      6  0
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
     D NOGOOD          C                   CONST('NOT ON VENDOR MASTER-
     D                                       ')
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
      *****
      *? Move 1st RRN for Current SFL Page to ##RRNO      ?             ?
      *****
     C                   Z-ADD     PAGRRN        ##RRNO
      *****
      *? Reset Cursor Position                            ?             ?
      *****
     C                   Z-ADD     *ZERO         ##ROW
     C                   Z-ADD     *ZERO         ##COL
      *****
      *? Clear Error indicators and flags                       ?
      *****
     C                   MOVEA     '00000000'    *IN(31)                        CLR *IN31-38
     C                   MOVEA     '00000000'    *IN(39)                        CLR *IN39-46
     C                   MOVEA     '00000000'    *IN(47)                        CLR *IN47-54
     C                   MOVE      *BLANKS       ERROR             3
      *****
      *? Clear Messages                                   ?
      *****
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN
      *****
      * ?SFL Input Selection                          ?
      *****
     C                   SELECT
      *****
      * ?F03 pressed EXIT PROGRAM                   ?
      *****
     C     *IN03         WHENEQ    *ON
     C                   MOVE      YES           ENDPGM            3
     C                   MOVE      *ON           EOJ               1
      *****
      * ?F12 pressed RETURN                         ?
      *****
     C     *IN12         WHENEQ    *ON
     C                   MOVE      YES           ENDPGM            3
      ******
      *? F1 - Cursor Help                                 ?
      ******
     C     *IN01         WHENEQ    '1'
     C                   EXSR      SRCHLP
      *
      *    ?Postioned Past EOF, Load Prior Page if Not BOF
     C     S1RRN         IFEQ      *ZEROS
     C     $$BOF         IFNE      *ON
     C                   EXSR      BACKSF
     C                   ELSE
      *    ?ELSE  Subfile Empty Write One Blank SFL Record (ND PR)
     C                   MOVE      'KP00221'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   EXSR      BLNKSF
     C                   ENDIF
     C                   ENDIF
      *
      * ?RollDown                                         ?
     C*          *IN27     WHEQ *ON
     C*          $$BOF     IFEQ *ON
     C*                    Z-ADD1         ##RRNO
     C*                    MOVE 'GP00001' $#MSID           ?Message Id   ?
     C*                    EXSR SRMSGF
     C*                    ENDIF
      *??If No Errors Found in READSF Execute Roll Back
     C*                    EXSR READSF
     C*          ERROR     IFNE YES
     C*                    EXSR BACKSF
     C*                    ENDIF
      *
      * ?Rollup                                           ?
     C*          *IN26     WHEQ *ON
     C*          $EOF      IFEQ *OFF
     C*                    EXSR LOAD##
     C*                    ELSE
     C*                    MOVE 'GP00002' $#MSID           ?Message Id   ?
     C*                    EXSR SRMSGF
     C*                    END
      *
      *? Process SFL Input               ?
     C     $$LOAD        WHENEQ    '1'
     C                   EXSR      READSF
     C                   MOVE      'KP00221'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
      *
      *? No Records Loaded to SFL
     C                   OTHER
     C                   Z-ADD     1             ##RRNO
     C                   MOVE      'SR00016'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
      *
     C                   ENDSL
      *
     C                   ENDDO
      *
      *? End the program                                  ?             ?
      *
     C                   MOVE      '1'           *INLR
      ********************************************************************
      * ?LOADSF - Load the  Master Display                              ?*
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
     C                   MOVEL     DDVNDR        SVVNDR
     C                   MOVEL     DDITEM        SVITNO
     C     PRKEY         SETLL     DGDTL
      *
     C*                    CLEARS1ITM#
     C                   MOVE      *OFF          $EXLOD            1
     C                   MOVE      *OFF          $EOF              1
     C                   MOVE      *ON           *IN81
      *
      *? Read Loop                                        ?             ?
      *
     C     $EXLOD        DOUEQ     *ON
     C     S2KEY         READE     DGDTL                                  66
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
     C     DDRSTS        IFEQ      'O'
     C                   ADD       1             S1RRN
     C                   WRITE     S1DATA
     C     S1RRN         IFEQ      300
     C                   LEAVE
     C                   END
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
     C                   MOVE      'KP00221'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   ELSE
      *
      *? If no records loaded                             ?
      *
     C                   MOVE      *OFF          $$LOAD            1
     C                   EXSR      BLNKSF
     C                   MOVE      'KP00231'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   END
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
      *
      *? Selection 2 - Inquire P/O                         ?
      *
     C     S1SEL         WHENEQ    '2'
     C     SSFLG1        ANDEQ     *BLANK
     C                   MOVE      S1POYR        #YRKEY            2
     C                   MOVE      S1PONO        #POKEY            6
     C                   CALL      'KP0017R '                           69
     C                   PARM                    #YRKEY
     C                   PARM                    #POKEY
     C*                    SELEC
     C                   CLEAR                   S1SEL
     C     #YRKEY        WHENEQ    'XX'                                         F3=EXIT
     C                   MOVE      *ON           *IN66
     C     #YRKEY        WHENNE    *BLANKS
     C                   MOVE      SVITNO        S1ITM#
     C                   MOVE      SVVNDR        DDVNDR
     C                   MOVE      *ON           $$RLOD            1
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
E003 C                   ENDIF
E003 C                   ENDIF
E001 C                   ENDDO
      *
      *
     C     $$RLOD        IFEQ      *ON
213  C                   MOVE      *ON           *IN28
     C                   EXSR      LOADSF
     C                   ENDIF
      *
     CSR                 ENDSR
      ********************************************************************
      * ?LOAD## - Load the ITEM Master Display                          ?*
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
     C                   READ      DGDTL                                  66
     C     *IN66         IFEQ      *ON
     C                   MOVE      *ON           $EOF              1
     C                   MOVE      *ON           $EXLOD            1
     C                   MOVE      *OFF          *IN81
     C                   ELSE
      *
      *? Initialize SFL Record Field Values               ?
     C                   EXSR      MOV@S1
      *****
      *? Write subfile record                             ?
      *****
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
      * ?Forms Master File Fields.                    ?
      *
     C     POKEY         CHAIN     KPPOHD                             42
     C                   Z-ADD     PODATE        S1DATE
     C                   MOVEL     DDPOYR        S1POYR
     C                   MOVEL     DDDGPO        S1PONO
     C                   MOVEL     DDVNDR        S1VEN#
     C     VMKEY         CHAIN     FMVEND                             42
     C     *IN42         IFEQ      *ON
     C                   MOVEL     NOGOOD        S1VNDN
     C                   ELSE
     C                   MOVEL     VMNAME        S1VNDN
     C                   ENDIF
     C                   Z-ADD     DDPQTY        S1QTOR
     C                   Z-ADD     DDRCQT        S1QTRC
     CSR                 ENDSR
      *****************************************************************
      * ?BACKSF - Roll Back File One Page of SFL Records            ? *
      *****************************************************************
     CSR   BACKSF        BEGSR
      *
     C                   MOVE      SVVNDR        DDVNDR
     C     PRKEY         SETLL     DGDTL
      *
     C     1             DO        13
     C                   READP     DGDTL                                  66
     C                   ENDDO
     C     *IN66         IFEQ      *ON
.    C                   MOVE      *LOVAL        S1ITM#
     C                   ELSE
     C                   MOVE      DDITEM        S1ITM#
     C                   ENDIF
      *
213  C**                   MOVE *ON       *IN28
     C                   EXSR      LOADSF
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
      ********************************************************************
      * ?       Program Initialization and Housekeeping                 ?*
      ********************************************************************
     CSR   *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    #PPROD           12
     C                   PARM                    #PSIZE            3
     C                   PARM                    #PDESC           30
     C                   PARM                    EOJ               1
     C                   MOVEL     #PPROD        S1ITM#
     C                   MOVEL     #PSIZE        S1SIZE
     C                   MOVE      #PDESC        S1DESC
      *
      * Define *LIKE Fields ?
      *
     C     *LIKE         DEFINE    #SFLPG        ##ROLL
     C     *LIKE         DEFINE    #SFLPG        ##FWRL
     C     *LIKE         DEFINE    #SFLPG        ##LOAD
     C     *LIKE         DEFINE    DDVNDR        SVVNDR
     C     *LIKE         DEFINE    DDITEM        SVITNO
     C     S1KEY         CHAIN     FMINVT                             99
      *
      * Define Key Lists ?
      *
      * ?KLIST for Security file by User ID
      *
     C     USKEY         KLIST
     C                   KFLD                    USSYS
     C                   KFLD                    USUSID
      *
      * ?KLIST for file - DGPODT   Library - *LIBL     ?
      *
     C     PRKEY         KLIST
     C                   KFLD                    IMLOOK
     C                   KFLD                    S1ITM#
     C                   KFLD                    S1SIZE
     C                   KFLD                    DDVNDR
      *
      * ?KLIST for file - DGPODTL1 Library - *LIBL     ?
      *
     C     S1KEY         KLIST
     C                   KFLD                    S1ITM#
     C                   KFLD                    S1SIZE
      *
     C     S2KEY         KLIST
     C                   KFLD                    IMLOOK
     C                   KFLD                    S1ITM#
     C                   KFLD                    S1SIZE
      *
      * ?KLIST for file - APMSTP   Library - *LIBL     ?
      *
     C     VMKEY         KLIST
     C                   KFLD                    DDVNDR
      *
      * ?KLIST for file - DGPOHD   Library - *LIBL     ?
      *
     C     POKEY         KLIST
     C                   KFLD                    DDPOYR
     C                   KFLD                    DDDGPO
      *
      *? Initialize values for message subfile            ?             ?
      *
     C                   MOVE      ##PGM         $#PGMQ           10            ?Pgm Msg Queue?
     C                   MOVEL     'KPMSGF'      $#MSGF           10            ?Msg File N/A ?
     C                   MOVEL     '*LIBL'       $#MSGL           10            ?Library  N/A ?
      *
     C                   EXSR      $SSPGM
      *
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
.    C                   Z-ADD     4             ##LOAD                         SFL Load 28 Records
      *
      *? Initial Sub File Load.                                  ?             ?
     C                   EXSR      LOADSF
      *
     CSR                 ENDSR
** OTX - Valid options
2=Inquire
