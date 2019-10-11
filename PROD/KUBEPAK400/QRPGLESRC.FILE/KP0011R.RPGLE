      *%*******************************************************************
      *%                                                                 **
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- Dietz & Watson Dry Goods Inventory              **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- KP0011R                                                *
      *                                                                   *
      * Purpose?- P/O Header File Maintenance                            *
      *                                                                   *
      *    Date  Programmer       ? Comment                          ? *
      *  8/19/2003 Richard E. Piasecki Program Created                    *
      *                                                                   *
      *%*******************************************************************
     FKP0011S   CF   E             WORKSTN
     F                                     INFDS(INFDS3)
     FSECUSER   IF   E           K DISK
     FKPPOHD    UF A E           K DISK
     FKPPODT    UF   E           K DISK
     FFMVEND    IF   E           K DISK
     F*PDFTP  IF  E           K        DISK
     FKPWHOUSE  IF   E           K DISK
     FPOCNTL    IF   E           K DISK
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
      * ?Breakdown of date fields                                       ?*
      ********************************************************************
     D                 DS                  INZ
     D  DGDATE                 1      6  0
     D  DGPODM                 1      2  0
     D  DGPODD                 3      4  0
     D  DGPODY                 5      6  0
      *                                                                 ?*
     D                 DS                  INZ
     D  DGUDAT                 1      6  0
     D  DGPOEM                 1      2  0
     D  DGPOED                 3      4  0
     D  DGPOEY                 5      6  0
      *                                                                 ?*
     D                 DS                  INZ
     D  DSDATE                 1      6  0
     D  DSMM                   1      2  0
     D  DSDD                   3      4  0
     D  DSYY                   5      6  0
     D                 DS
     D  DGWHSE                 1      2  0 INZ(0)
      *****************************************************************
      * ?Define Program Constants                                   ? *
      *****************************************************************
     D YES             C                   CONST('YES')
     D DFTVAL          C                   CONST('*DEFAULT  ')
     D SERS            C                   CONST('SERLSTATUS')
     D USERWH          C                   CONST('USERWH    ')
      *
      ********************************************************************
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
|    C                   EXFMT     SCREEN01
|     *
|     *? Reset Cursor Position                            ?             ?
|     *
|    C                   Z-ADD     *ZERO         ##ROW
|    C                   Z-ADD     *ZERO         ##COL
|     *
|     *? Clear indicators and flags                       ?
|     *
|    C                   MOVEA     '00000000'    *IN(30)                        CLR *IN31-37
|    C                   MOVEA     '00000000'    *IN(38)                        CLR *IN38-45
|    C                   MOVEA     '00000000'    *IN(46)                        CLR *IN46-53
|    C                   MOVEA     '00000000'    *IN(54)                        CLR *IN54-61
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
||    *
||    *? F3 - Exit program                                ?
||    *
||2  C     *IN03         WHENEQ    *ON
     C     $$MODE        IFEQ      'U'
     C                   UNLOCK    KPPOHD
     C                   ENDIF
||   C                   MOVE      'XX'          #EPOYR
||   C                   MOVE      YES           ENDPGM            3
      *
      * ?F4 pressed                                ?
     C     *IN04         WHENEQ    *ON
     C     #EMODE        ANDNE     'I'
     C                   EXSR      $PRMPT
||    *
||    *? F12 - Previous - end program no update           ?
||    *
||3  C     *IN12         WHENEQ    *ON
     C     $$MODE        IFEQ      'U'
     C                   UNLOCK    KPPOHD
     C                   ENDIF
||   C                   MOVE      YES           ENDPGM            3
||    *
||    *? If change on screen -- reset confirm             ?
||    *
||O  C                   OTHER
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
||    *? Process Add or update
||    *
     C     #EMODE        IFNE      'I'
|||| C                   EXSR      EXSC01
     C                   ENDIF
||    *
||    *? Call P/O Detail maintenance program KP0012R
||    *
     C                   CALL      'KP0012C'
     C                   PARM      #EPOYR        #PPOYR            2
     C                   PARM                    #EDGPO            6
     C                   PARM                    #EMODE            1
||    *
||    *? If returned from KP0012R by F12, reset exit flag & continue
||    *
     C     #PPOYR        IFEQ      #EPOYR
     C                   CLEAR                   ENDPGM
     C     #EMODE        IFNE      'I'
     C     POKEY         CHAIN     DGHDR                              66
     C                   MOVE      DGWHSE        SVWHSE
     C                   MOVE      'U'           $$MODE
     C                   ENDIF
     C                   ENDIF
      *
|||IfC                   ENDIF
||If C                   ENDIF
||    *
|Sl  C                   ENDSL
Do   C                   ENDDO
      *
      *? End the program                                  ?             ?
      *
     C                   MOVE      *ON           *INLR
      *
      ********************************************************************
      ********************************************************************
      ********************  End Main Line?  *****************************
      ********************************************************************
      ********************************************************************
      *
      ********************************************************************
      * ?       Program Initialization and Housekeeping                 ?*
      ********************************************************************
     CSR   *INZSR        BEGSR
      *
      *? *ENTRY parameter list                         ?                ?
      *
     C     *ENTRY        PLIST
     C                   PARM                    #EPOYR            2
     C                   PARM                    #EDGPO            6
     C                   PARM                    #EMODE            1
      *
      * ?Move *ENTRY parameters to numeric fields         ?
      *
     C                   MOVEL     #EPOYR        DGPOYR
     C                   MOVEL     #EDGPO        DGDGPO
      *
      *? Define work fields                            ?                ?
      *
     C     *LIKE         DEFINE    DGWHSE        SVWHSE
      *
      * ?Set on global field protect indicator if Inquiry mode
      *
     C     #EMODE        IFEQ      'I'
     C                   MOVE      *ON           *IN82
     C                   ENDIF
      *
      * Define Key Lists ?
      *
      *
      * ?KLIST for file - KPPOHD      Library - *LIBL     ?
      *
     C     POKEY         KLIST
     C                   KFLD                    DGPOYR
     C                   KFLD                    DGDGPO
      *
      * ?KLIST for file - VFMVEND     Library - APAYFILE  ?
      *
     C     VMKEY         KLIST
     C                   KFLD                    PVEND#
      *
      * ?KLIST for Security file by User ID
      *
     C     USKEY         KLIST
     C                   KFLD                    USSYS
     C                   KFLD                    USUSID
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
      *? Get security record                             ?             ?
      *
     C                   EXSR      $SSPGM
      *
      *? Initial Screen load                             ?             ?
      *
     C     POKEY         CHAIN     DGHDR                              66
     C     *IN66         IFEQ      *ON
     C                   MOVE      'A'           $$MODE            1
     C     999999        CHAIN     POCNTL                             99
     C                   MOVEL     POWHSE        DGWHSE
     C                   MOVE      'SR00008'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   ELSE
     C                   MOVE      'U'           $$MODE
     C                   MOVE      DGWHSE        SVWHSE
     C                   MOVE      'SR00007'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   END
      *
      *? Check for detail records. Field protect VENDOR number         ?
      *? if any detail found for this order.                           ?
      *
     C     POKEY         SETLL     KPPODT                                 81
      *
      *? Fill vendor name & warehouse name               ?             ?
      *
     C                   EXSR      $GTVND
     C                   EXSR      $GTWHS
      *
     CSR                 ENDSR
      ********************************************************************
      * ?$EDT01 - Check the input from screen 01                        ?*
      ********************************************************************
     CSR   $EDT01        BEGSR
      *
     C                   CLEAR                   DGNAME
     C                   CLEAR                   DGWNAM
      *****
      * Validate Vendor Number
      *****
     C                   EXSR      $GTVND
      *
     C                   SELECT
     C     *IN99         WHENEQ    '1'
     C                   MOVE      YES           ERROR
     C                   MOVE      'KP00111'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVEA     '1'           *IN(31)
      *
     C     USFL01        WHENEQ    'N'
     C     #EMODE        ANDEQ     'A'
     C                   MOVE      YES           ERROR
     C                   MOVE      'SS99997'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVEA     '1'           *IN(31)
      *
     C                   ENDSL
      *****
      * Validate requested date
      *****
     C                   Z-ADD     DGDATE        DSDATE
     C                   EXSR      $CKDTE
     C     WKDERR        IFEQ      'Y'
     C                   MOVE      'YES'         ERROR
     C                   MOVE      'KP00112'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVE      '1'           *IN32
     C                   ENDIF
      *****
      * Validate Receiving Warehouse
      *****
     C                   EXSR      $GTWHS
     C     *IN99         IFEQ      '1'
     C                   MOVE      YES           ERROR             3
     C                   MOVE      'KP00113'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVEA     '1'           *IN(33)
     C                   END
      *****
     CSR                 ENDSR
      *****************************************************************
      * ?EXSC01 - Clear record format SCREEN01                      ? *
      *****************************************************************
     CSR   EXSC01        BEGSR
      *
      * ?Fill all century fields before writing or updating record
      *
     C                   SELECT
     C     DGPODY        WHENGT    95
     C                   Z-ADD     19            DGPODC
     C     DGPODY        WHENLE    95
     C                   Z-ADD     20            DGPODC
     C                   ENDSL
      *
     C                   Z-ADD     UDATE         DGUDAT
     C                   SELECT
     C     DGPOEY        WHENGT    95
     C                   Z-ADD     19            DGPOEC
     C     DGPOEY        WHENLE    95
     C                   Z-ADD     20            DGPOEC
     C                   ENDSL
      *
     C                   Z-ADD     1             DGCORP
      *
     C                   SELECT
     C     $$MODE        WHENEQ    'A'
     C                   MOVE      'O'           DGOST
     C*                    MOVE 'N'       DGPRTF
     C                   MOVE      ' '           DGPRTF
     C                   MOVEL     ##USER        DGUSER
     C                   MOVEL     'IM'          DGRCID
     C                   WRITE     DGHDR
     C     $$MODE        WHENEQ    'U'
     C                   UPDATE    DGHDR
     C     DGWHSE        IFNE      SVWHSE
     C                   EXSR      $UPDTL
     C                   ENDIF
     C                   ENDSL
      *
     C                   MOVE      YES           ENDPGM
      *
     CSR                 ENDSR
      *****************************************************************
      * ?$UPDTL - Updates warehouse in detail file                  ? *
      *****************************************************************
     CSR   $UPDTL        BEGSR
      *
     C     POKEY         SETLL     DGDTL
     C     POKEY         READE     DGDTL                                  61
     C     *IN61         DOWEQ     '0'
     C                   MOVE      DGWHSE        DDWHSE
     C                   UPDATE    DGDTL
     C     POKEY         READE     DGDTL                                  61
     C                   ENDDO
      *
     CSR                 ENDSR
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
      *****************************************************************
      * ?$GTVND - Get vendor master record                         ? *
      *****************************************************************
     CSR   $GTVND        BEGSR
      *
     C                   CLEAR                   *IN99
     C                   CLEAR                   VMNAME
     C                   Z-ADD     DGVNDR        PVEND#            6 0
     C     VMKEY         CHAIN     RMVEND                             99
     C                   MOVEL     VMNAME        DGNAME
     C*          *IN99     IFEQ '0'
     C*          VMKEY     CHAINAPDFT                98
     C*                    ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * ?$GTWHS - Get warehouse master record                      ? *
      *****************************************************************
     CSR   $GTWHS        BEGSR
      *
     C                   CLEAR                   *IN99
     C                   CLEAR                   WHWNAM
     C     DGWHSE        CHAIN     WHSE                               99
     C                   MOVEL     WHWNAM        DGWNAM
      *
     C                   ENDSR
      *****************************************************************
      * ?$PRMPT - Handles F4 prompt function                       ? *
      *****************************************************************
     CSR   $PRMPT        BEGSR
      *
     C                   SELECT
      *
      *? Jobber Number
      *
     C     ##RCD         WHENEQ    'SCREEN01'
     C     ##FLD         ANDEQ     'DGVNDR'
     C     *IN81         IFEQ      *ON
     C                   MOVE      'YES'         ERROR
     C                   MOVE      'KP00114'     $#MSID
     C                   EXSR      SRMSGF
     C                   ELSE
     C                   MOVE      *BLANKS       @PVNDR            6
     C                   CALL      'VMIQ01R'
     C                   PARM                    @PVNDR
     C     @PVNDR        IFNE      *BLANKS
     C                   MOVEL     @PVNDR        DGVNDR
     C                   MOVE      *ON           *IN28
     C                   EXSR      $GTVND
     C                   ENDIF
     C                   ENDIF
      *
      *? Receiving warehouse
      *
     C     ##RCD         WHENEQ    'SCREEN01'
     C     ##FLD         ANDEQ     'DGWHSE'
     C                   CALL      'KP0005R'
     C                   PARM      '00'          @PWHSE            2
     C     @PWHSE        IFNE      *ZERO
     C                   MOVE      @PWHSE        DGWHSE
     C                   MOVE      *ON           *IN28
     C                   EXSR      $GTWHS
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
