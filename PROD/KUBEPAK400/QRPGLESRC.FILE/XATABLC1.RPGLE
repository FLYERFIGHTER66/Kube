      *%*******************************************************************
      *%                                                                 **
      *%                                                  ?              **
      *%                                                                 **
      *%                        ?                                        **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- Table Catagory  Code Master Maintenance         **
      *%  ?                     ?                                        **
      *%                        ?                                        **
      *%                                                                 **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- XATABLC1                                               *
      *                                                                   *
      * Purpose?- Table Catagory Code Master Maintenance                 *
      *                                                                   *
      *   Date  ?Programmer    ? Comment                             ? *
      *  03/16/03  R. Piasecki      Program Created                       *
      *                                                                   *
      *%*******************************************************************
     FXATABL    UF A E           K DISK
     FXATABL1S  CF   E             WORKSTN
     F                                     INFDS(INFDS3)
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
|    C                   MOVEA     '00'          *IN(10)                        CLR *IN10-11
|    C                   MOVEA     '00000'       *IN(13)                        CLR *IN13-17
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
||2  C*          *IN03     WHEQ *ON
     C*          $$MODE    IFEQ 'U'
     C*                    UNLCKXATABL
     C*                    ENDIF
||   C*                    MOVE 'XXXX'    #PTAB#
||   C*                    MOVE YES       ENDPGM  3
||    *
||    *? F12 - Previous - End Program No Update           ?
||    *
||3  C     *IN12         WHENEQ    *ON
     C     $$MODE        IFEQ      'U'
     C                   UNLOCK    XATABL
     C                   ENDIF
0148 C                   MOVE      TBTBCD        #PTAB#
||   C                   MOVE      YES           ENDPGM            3
||    *
||    *
||    *
||    *? If change on screen -- reset confirm             ?
||    *
     C                   OTHER
||    *
||If C     *IN28         IFEQ      *ON
|||  C                   MOVE      *OFF          $$CNFR            1
||If C                   END
||    *
||    *? Read SCREEN01 and check for "?", Validity.       ?
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
      *? Program Entry Point                              ?             ?
      *
     C     *ENTRY        PLIST
     C                   PARM                    #PTAB#            4
      *
      * Define Key Lists ?
      *
      *
      * ?KLIST for file - XATABL      Library - *LIBL     ?
      *
     C     TBKEY         KLIST
     C                   KFLD                    TBTBCD
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
      *? Initial Screen load                             ?             ?
      *
0148 C                   MOVE      'T'           TBRCDE
     C                   MOVEL     #PTAB#        TBTBCD
     C                   MOVE      #PTAB#        S1CD
     C     TBKEY         CHAIN     XATABL                             66
     C     *IN66         IFEQ      *ON
     C                   MOVE      'A'           $$MODE            1
     C                   MOVE      *OFF          *IN78
     C                   MOVE      *OFF          *IN96
     C                   MOVE      'XXF1107'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   ELSE
     C                   MOVE      'U'           $$MODE
     C                   MOVE      *ON           *IN96
     C                   MOVE      'SR00007'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   END
      *
      *
     C                   CLEAR                   #PTAB#
     CSR                 ENDSR
      ********************************************************************
      * ?GETCUS - Chain to the Table Code Master File                   ?*
      ********************************************************************
     CSR   GETREC        BEGSR
     C     TBKEY         CHAIN     XATABL                             66
     C     *IN66         IFEQ      *ON
     C                   MOVE      'A'           $$MODE            1
     C                   MOVE      *OFF          *IN78
     C                   MOVE      *OFF          *IN96
     C                   MOVE      'XXF1107'     $#MSID                         ?Message Id   ?
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
0148 C     $$MODE        IFEQ      'A'
0148 C                   MOVEL     'TB'          #PTAB#
0148 C                   MOVE      S1CD          #PTAB#
0148 C                   MOVEL     #PTAB#        TBTBCD
0149 C     TBKEY         CHAIN     XATABL                             67
     C     *IN67         IFEQ      *OFF
     C     *NOKEY        CLEAR                   TBMASTR
     C                   MOVE      YES           ERROR             3
0150 C                   MOVE      'XXF1111'     $#MSID
     C                   EXSR      SRMSGF
0152 C                   MOVEA     '1'           *IN(10)
     C                   GOTO      ##EN01
0166 C                   END
0166 C                   END
      *****
0157  * Catagory Code Cannot be Blank
      *****
     C     S1CD          IFEQ      *BLANKS
     C                   MOVE      YES           ERROR             3
0150 C                   MOVE      'TBF1115'     $#MSID
     C                   EXSR      SRMSGF
0152 C                   MOVEA     '1'           *IN(10)
     C                   GOTO      ##EN01
0166 C                   END
      *****
0157  * SHORT CODE NAME MUST BE ENTERED
      *****
0148 C     TBSHRT        IFEQ      *BLANKS
     C                   MOVE      YES           ERROR             3
0150 C                   MOVE      'TBF1112'     $#MSID
     C                   EXSR      SRMSGF
0152 C                   MOVEA     '1'           *IN(11)
0166 C                   END
      *****
0157  * LONG CODE NAME MUST BE ENTERED
      *****
0148 C     TBLONG        IFEQ      *BLANKS
     C                   MOVE      YES           ERROR             3
0150 C                   MOVE      'TBF1113'     $#MSID
     C                   EXSR      SRMSGF
0152 C                   MOVEA     '1'           *IN(13)
0166 C                   END
      *****
0157  * KEY LENGTH MUST BE 1 TO 6
      *****
0148 C     TBKEYP        IFLT      1
0148 C     TBKEYP        ORGT      6
     C                   MOVE      YES           ERROR             3
0150 C                   MOVE      'TBF1114'     $#MSID
     C                   EXSR      SRMSGF
0152 C                   MOVEA     '1'           *IN(14)
0166 C                   END
      *****
0166 C     ##EN01        ENDSR
      *****************************************************************
      * ?EXSC01 - Clear record format SCREEN01                      ? *
      *****************************************************************
     CSR   EXSC01        BEGSR
      *
     C     $$MODE        IFEQ      'A'
     C                   WRITE     TBMASTR
0148 C                   MOVE      TBTBCD        #PTAB#
     C                   END
      *
     C     $$MODE        IFEQ      'U'
     C                   UPDATE    TBMASTR
0148 C                   MOVE      TBTBCD        #PTAB#
     C                   END
      *
     C                   MOVE      YES           ENDPGM
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
