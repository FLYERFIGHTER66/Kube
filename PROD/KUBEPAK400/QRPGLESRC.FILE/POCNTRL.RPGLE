      *%*******************************************************************
      *%                                                                 **
      *%                                                  ?              **
      *%                                                                 **
      *%                        ?                                        **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- Purchase Order Control File Maint.              **
      *%                        ?                                        **
      *%  ?                     ?                                        **
      *%                        ?                                        **
      *%                                                                 **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- POCNTRL                                                *
      *                                                                   *
      * Purpose?- CONTROL FILE Master Maintenance                        *
      *                                                                   *
      *   Date  ?Programmer    ? Comment                             ? *
      *  08/13/03  R. Piasecki      Program Created                       *
      *                                                                   *
      *%*******************************************************************
     FSECUSER   IF   E           K DISK
     FPOCNTL    UF A E           K DISK
     FPOCNTLS   CF   E             WORKSTN
     F                                     INFDS(INFDS3)
      *
      ********************************************************************
      * ?Tables & arrays                                                ?*
      ********************************************************************
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
|    C***        *IN50     IFEQ *ON
|    C***                  WRITEMSGCTL
|    C***                  EXFMTSCREEN01
||2  C***        *IN03     IFEQ *ON
|    C***                  MOVE YES       ENDPGM  3
|    C***                  ITER
|    C***                  ENDIF
     C***                  EXSR GETWK
|    C***                  ENDIF
      *
|    C                   WRITE     MSGCTL
     C                   EXFMT     SCREEN02
|     *? Reset Cursor Position                            ?             ?
|     *
|    C                   Z-ADD     *ZERO         ##ROW
|    C                   Z-ADD     *ZERO         ##COL
|     *
|     *? Clear indicators and flags                       ?
|     *
     C                   MOVE      0             *IN50
|    C                   MOVE      *BLANKS       ERROR             3
|     *
|     *? Clear Messages                                   ?
|     *
|    C                   MOVE      'C'           $#MSFN            1
|    C                   EXSR      SRMSGF
|    C                   MOVE      'S'           $#MSFN            1
|     *? Write Cmd Key, Msgsfl                            ?
|     *
|     *
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
||2  C     *IN12         OREQ      *ON
     C     $$MODE        IFEQ      'U'
     C                   UNLOCK    POCNTL
     C                   ENDIF
||   C                   MOVE      YES           ENDPGM            3
||    *
||    *? F4 - DELETE RECORD                               ?
||    *
||2  C***        *IN04     WHEQ *ON
     C***        $$MODE    IFEQ 'U'
     C***                  DELETPOCNTL
     C***                  CLEARPOCNTL
     C***                  MOVE 1         *IN50
     C***                  ENDIF
||    *
||    *? F12 - Previous - end program no update           ?
||    *
||3  C     *IN12         WHENEQ    *ON
     C                   UNLOCK    POCNTL
     C                   CLEAR                   POCNTLR
     C                   Z-ADD     0             RECKEY
     C                   MOVE      1             *IN50
||    *
||    *? If change on screen -- reset confirm             ?
||    *
     C                   OTHER
||If C     *IN28         IFEQ      *ON
|||  C                   MOVE      *OFF          $$CNFR            1
||If C                   END
||    *
||    *? Read SCREEN02 and check for "?", Validity.       ?
||    *
||   C                   EXSR      CKIN01
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
|||| C                   EXSR      EXSC01
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
      * Define *ENTRY plist?
     C     *ENTRY        PLIST
     C                   PARM                    #ESEC             1
      *
      * Define Key Lists ?
     C     POKEY         KLIST
     C                   KFLD                    RECKEY
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
     C                   MOVE      1             *IN50
      *
      *? Check security                                                 ?
      *
     C                   EXSR      $SSPGM
      *
      *? Get the control record                                         ?
      *
     C                   MOVE      *ALL'9'       RECKEY
     C                   EXSR      GETWK
      *
      *
     CSR                 ENDSR
      *****************************************************************
      * ?$SSPGM - Handles program security checking function        ? *
      *****************************************************************
     CSR   $SSPGM        BEGSR
      *
      *? Check for User ID in security file (1st time thru only)        ?
      *
B001 C     SECOK         IFNE      'Y'
      *
     C                   MOVEL     'POCNTRL'     USSYS
     C                   MOVEL     ##USER        USUSID
     C     USKEY         CHAIN     USERR                              99
      *
      *? If User ID found, check for option other than "N" or blank.    ?
      *?                                                                ?
B002 C     *IN99         IFEQ      '0'
B003 C                   DO        20            X                 2 0
B004 C     UF(X)         IFNE      'N'
     C     UF(X)         ANDNE     *BLANK
     C                   MOVE      'Y'           SECOK             1
     C                   LEAVE
E004 C                   ENDIF
E003 C                   ENDDO
E002 C                   ENDIF
      *
      *? If User ID not found, or found & all "N" or blank,             ?
      *? issue error message and return.                                ?
      *
B002 C     *IN99         IFEQ      '1'
     C     SECOK         ORNE      'Y'
     C                   MOVE      'N'           #ESEC
     C                   MOVE      '1'           *INLR
     C                   RETURN
E002 C                   ENDIF
      *
E001 C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      * ?GETWK - Chain to the INVENTORY CONTROL FILE                    ?*
      ********************************************************************
     CSR   GETWK         BEGSR
     C     POKEY         CHAIN     POCNTL                             66
     C     *IN66         IFEQ      *ON
     C                   MOVE      'A'           $$MODE            1
     C                   MOVE      *OFF          *IN78
     C                   MOVE      *OFF          *IN96
     C                   MOVE      'SR00008'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   ELSE
     C                   MOVE      'U'           $$MODE
     C                   MOVE      *ON           *IN96
     C                   MOVE      'SR00007'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   END
     C                   ENDSR
      ********************************************************************
      * ?CKIN01 - Check the input from screen 01                        ?*
      ********************************************************************
     CSR   CKIN01        BEGSR
      *****
0157  * IF ADDING RECORD, IT MUST NOT ALREADY EXIST
      *****
0148 C***        $$MODE    IFEQ 'A'
0149 C***        DGKEY     CHAINPOCNTL               67
     C***        *IN67     IFEQ *OFF
     C***        *NOKEY    CLEARPOCNTL
     C***                  MOVE YES       ERROR   3
0150 C***                  MOVE 'FBF1111' $#MSID
     C***                  EXSR SRMSGF
0152 C***                  MOVEA'1'       *IN,11
     C***                  GOTO ##EN01
0166 C***                  END
0166 C***                  END
      ***
0166 C     ##EN01        ENDSR
      *****************************************************************
      * ?EXSC01 - Clear record format SCREEN02                      ? *
      *****************************************************************
     CSR   EXSC01        BEGSR
      *
      *? Clear Message Subfile -- set function to send    ?             ?
      *
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
      *
     C     $$MODE        IFEQ      'A'
     C                   WRITE     POCNTLR
     C                   MOVE      'SR00010'     $#MSID
     C                   EXSR      SRMSGF
     C                   END
      *
     C     $$MODE        IFEQ      'U'
     C                   UPDATE    POCNTLR
     C                   MOVE      'SR00011'     $#MSID
     C                   EXSR      SRMSGF
     C                   END
      *
      *? Get the control record                                         ?
      *
     C                   MOVE      *ALL'9'       RECKEY
     C                   EXSR      GETWK
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
