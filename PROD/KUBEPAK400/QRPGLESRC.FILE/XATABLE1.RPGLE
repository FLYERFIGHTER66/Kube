      *%*******************************************************************
      *%                                                                 **
      *%                                                  ?              **
      *%                                                                 **
      *%                        ?                                        **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- Table Element Master Maintenance                **
      *%  ?                     ?                                        **
      *%                        ?                                        **
      *%                                                                 **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- XATABLE1                                               *
      *                                                                   *
      * Purpose?- Table Element Master Maintenance                       *
      *                                                                   *
      *   Date  ?Programmer    ? Comment                             ? *
      *  05/16/03  R. Piasecki      Program Created                       *
      *                                                                   *
      *%*******************************************************************
     FXATABL    UF A E           K DISK
     FFMCUST    IF   E           K DISK
     FXATABE1S  CF   E             WORKSTN
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
|    C                   MOVEA     '0'           *IN(76)                        CLR *IN76
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
||   C*                    MOVE 'XXXXXXX' #ETAB#
||   C*                    MOVE YES       ENDPGM  3
||    *
||    *? F12 - Previous - End Program No Update           ?
||    *
||3  C     *IN12         WHENEQ    *ON
     C     $$MODE        IFEQ      'U'
     C                   UNLOCK    XATABL
     C                   ENDIF
0148 C                   MOVE      TBTBCD        #ETAB#
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
     C                   PARM                    #ETAB#            8
     C                   PARM                    #KEYP#            2
     C                   MOVEL     #ETAB#        TBIDKY            8
     C                   MOVEL     #ETAB#        TBRTKY            2
     C                   MOVE      #ETAB#        #TBNO#            6
     C                   MOVE      #KEYP#        KEYLEN            2 0
     C     KEYLEN        ADD       40            X                 2 0
     C                   MOVEA     '1'           *IN(X)
      *
      *
      * BROKER TABLE
     C     TBRTKY        IFEQ      'BR'
     C                   MOVE      *ON           *IN75
     C                   ENDIF
      * DRIVERS COMMISSION INFO
     C*          TBRTKY    IFEQ 'DC'
     C*                    MOVE *ON       *IN49
     C*                    ENDIF
      * PRODUCT RELATED CREDITS
     C*          TBRTKY    IFEQ 'IC'
     C*                    MOVE *ON       *IN51
     C*                    ENDIF
      * SALESMAN INFO
     C*          TBRTKY    IFEQ 'SM'
     C*          ##USER    IFEQ 'RP'
     C*          ##USER    OREQ 'ED'
     C*          ##USER    OREQ 'CHAS'
     C*          ##USER    OREQ 'CHRIS'
     C*          ##USER    OREQ 'LOUIS'
     C*          ##USER    OREQ 'CEY'
     C*                    MOVE *ON       *IN50
     C*                    ENDIF
     C*                    ENDIF
      *
      * Define Key Lists ?
      *
      *
      * ?KLIST for file - XATABL      Library - *LIBL     ?
      *
     C     TBKEY         KLIST
     C                   KFLD                    TBIDKY
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
0148 C   41              MOVEL     #TBNO#        S1CD1             1
0148 C   42              MOVEL     #TBNO#        S1CD2             2
0148 C   43              MOVEL     #TBNO#        S1CD3             3
0148 C   44              MOVEL     #TBNO#        S1CD4             4
0148 C   45              MOVEL     #TBNO#        S1CD5             5
0148 C   46              MOVEL     #TBNO#        S1CD6             6
0148 C   47              MOVEL     #TBNO#        S1CD7             7
0148 C   48              MOVEL     #TBNO#        S1CD8             8
      *
     C                   CLEAR                   #TBNO#
     CSR                 ENDSR
      ********************************************************************
      * ?GETREC - Chain to the Table Code Master File                   ?*
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
0148 C   41              MOVEL     S1CD1         #TBNO#            6
0148 C   42              MOVEL     S1CD2         #TBNO#
0148 C   43              MOVEL     S1CD3         #TBNO#
0148 C   44              MOVEL     S1CD4         #TBNO#
0148 C   45              MOVEL     S1CD5         #TBNO#
0148 C   46              MOVEL     S1CD6         #TBNO#
0148 C   47              MOVEL     S1CD7         #TBNO#
0148 C   48              MOVEL     S1CD8         #TBNO#
0148 C                   MOVE      #TBNO#        TBIDKY
      *****
0157  * IF ADDING RECORD, IT MUST NOT ALREADY EXIST
      *****
0148 C     $$MODE        IFEQ      'A'
0149 C     TBKEY         CHAIN     XATABL                             67
     C     *IN67         IFEQ      *OFF
     C     *NOKEY        CLEAR                   TBMASTR
     C                   MOVE      YES           ERROR             3
0150 C                   MOVE      'XAF1111'     $#MSID
     C                   EXSR      SRMSGF
0152 C                   MOVEA     '1'           *IN(10)
     C                   GOTO      ##EN01
0166 C                   END
0166 C                   END
      *****
0157  * Catagory Code Cannot be Blank
      *****
     C   41S1CD1         IFEQ      *BLANKS
     C                   MOVE      YES           ERROR             3
0150 C                   MOVE      'TBE1115'     $#MSID
     C                   EXSR      SRMSGF
0152 C                   MOVEA     '1'           *IN(10)
     C                   GOTO      ##EN01
0166 C                   END
      *****
     C   42S1CD2         IFEQ      *BLANKS
     C                   MOVE      YES           ERROR             3
0150 C                   MOVE      'TBE1115'     $#MSID
     C                   EXSR      SRMSGF
0152 C                   MOVEA     '1'           *IN(10)
     C                   GOTO      ##EN01
0166 C                   END
      *****
     C   43S1CD3         IFEQ      *BLANKS
     C                   MOVE      YES           ERROR             3
0150 C                   MOVE      'TBE1115'     $#MSID
     C                   EXSR      SRMSGF
0152 C                   MOVEA     '1'           *IN(10)
     C                   GOTO      ##EN01
0166 C                   END
      *****
     C   44S1CD4         IFEQ      *BLANKS
     C                   MOVE      YES           ERROR             3
0150 C                   MOVE      'TBE1115'     $#MSID
     C                   EXSR      SRMSGF
0152 C                   MOVEA     '1'           *IN(10)
     C                   GOTO      ##EN01
0166 C                   END
      *****
     C   45S1CD5         IFEQ      *BLANKS
     C                   MOVE      YES           ERROR             3
0150 C                   MOVE      'TBE1115'     $#MSID
     C                   EXSR      SRMSGF
0152 C                   MOVEA     '1'           *IN(10)
     C                   GOTO      ##EN01
0166 C                   END
      *****
     C   46S1CD6         IFEQ      *BLANKS
     C                   MOVE      YES           ERROR             3
0150 C                   MOVE      'TBE1115'     $#MSID
     C                   EXSR      SRMSGF
0152 C                   MOVEA     '1'           *IN(10)
     C                   GOTO      ##EN01
0166 C                   END
      *****
     C   47S1CD7         IFEQ      *BLANKS
     C                   MOVE      YES           ERROR             3
0150 C                   MOVE      'TBE1115'     $#MSID
     C                   EXSR      SRMSGF
0152 C                   MOVEA     '1'           *IN(10)
     C                   GOTO      ##EN01
0166 C                   END
      *****
     C   48S1CD8         IFEQ      *BLANKS
     C                   MOVE      YES           ERROR             3
0150 C                   MOVE      'TBE1115'     $#MSID
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
0157  * IF PLANT CODE MAINTENANCE WAREHOUSE MUST BE ENTERED
      *****
0148 C     *IN75         IFEQ      *ON
0148 C     TBBROK        CHAIN     FMCUST                             76
0148 C     *IN76         IFEQ      *ON
     C                   MOVE      YES           ERROR             3
0150 C                   MOVE      'TBF1119'     $#MSID
     C                   EXSR      SRMSGF
0166 C                   ENDIF
0166 C                   ENDIF
      *****
0166 C     ##EN01        ENDSR
      *****************************************************************
      * ?EXSC01 - Clear record format SCREEN01                      ? *
      *****************************************************************
     CSR   EXSC01        BEGSR
      *
     C     $$MODE        IFEQ      'A'
0148 C                   MOVE      TBIDKY        TBTBCD
     C                   MOVE      #TBNO#        TBTBCD
     C                   WRITE     TBMASTR
0148 C*                    MOVE TBIDKY    #ETAB#
     C                   END
      *
     C     $$MODE        IFEQ      'U'
0148 C                   MOVE      TBIDKY        TBTBCD
     C                   MOVE      #TBNO#        TBTBCD
     C                   UPDATE    TBMASTR
0148 C                   MOVE      TBIDKY        #ETAB#
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
