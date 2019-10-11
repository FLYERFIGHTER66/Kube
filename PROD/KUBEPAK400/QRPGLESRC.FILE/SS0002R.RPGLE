      *%*******************************************************************
      *%                                                                 **
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- Kubepak                                         **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- SS0002R                                                *
      *                                                                   *
      * Purpose?- Program Security Maintenance                           *
      *                                                                   *
      *   Date  ?Programmer       ?  Comment                         ? *
      *  8/9/2003  Richard E. Piasecki  Program Created                   *
      *                                                                   *
      *%*******************************************************************
     FSS0002S   CF   E             WORKSTN
     F                                     INFDS(INFDS3)
     FSECSYS    UF A E           K DISK
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
     D LO              C                   CONST('abcdefghijklmnopqrst-
     D                                     uvwxyz')
     D HI              C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ')
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
     C     WKSCRN        IFEQ      1
|    C                   EXFMT     SCREEN01
     C                   ELSE
|    C                   EXFMT     SCREEN02
     C                   ENDIF
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
     C                   UNLOCK    SECSYS
     C                   ENDIF
||   C                   MOVE      'XX'          #ESYS
||   C                   MOVE      YES           ENDPGM            3
||    *
||    *? F11 - Toggle views                              ?
||    *
 |1  C     *IN11         WHENEQ    *ON
||   C                   EXSR      $EDT01
||    *
||If C     ERROR         IFNE      YES
||   C     WKSCRN        IFEQ      1
     C                   Z-ADD     2             WKSCRN
     C                   ELSE
     C                   Z-ADD     1             WKSCRN
     C                   ENDIF
     C                   ENDIF
||    *
||    *? F12 - Previous - end program no update           ?
||    *
||3  C     *IN12         WHENEQ    *ON
     C     $$MODE        IFEQ      'U'
     C                   UNLOCK    SECSYS
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
     C                   PARM                    #ESYS            10
      *
      * Define Key Lists ?
      *
      *
      * ?KLIST for file - SECSYS      Library - *LIBL     ?
      *
     C     SYKEY         KLIST
     C                   KFLD                    SYSYS
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
     C     #ESYS         IFNE      *BLANKS
     C                   MOVE      #ESYS         SYSYS
     C     SYKEY         CHAIN     SYSTM                              66
     C                   ENDIF
      *
     C     *IN66         IFEQ      *ON
     C     #ESYS         OREQ      *BLANKS
     C                   MOVE      'A'           $$MODE            1
     C                   MOVE      *ON           *IN66
     C                   MOVE      'CB01107'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   ELSE
     C                   MOVE      'U'           $$MODE
     C                   MOVE      'CB01108'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   END
      *
     C                   CLEAR                   #ESYS
     C                   Z-ADD     1             WKSCRN            1 0
     CSR                 ENDSR
      ********************************************************************
      * ?$EDT01 - Check the input from screen 01                        ?*
      ********************************************************************
     CSR   $EDT01        BEGSR
      *****
      * Check to perform only when adding a record
      *****
B001 C     $$MODE        IFEQ      'A'
      *****
      * Check for existence of record
      *****
     C     SYKEY         CHAIN     SYSTM                              67
B002 C     *IN67         IFEQ      *OFF
     C     *NOKEY        CLEAR                   SYSTM
     C                   MOVE      YES           ERROR             3
     C                   MOVE      'SS00030'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVEA     '1'           *IN(31)
E002 C                   ENDIF
      *****
E001 C                   ENDIF
      *****
      * Continue if update mode or add mode & record not found
      *****
     C     $$MODE        IFEQ      'A'
     C     *IN67         ANDEQ     *ON
     C     $$MODE        OREQ      'U'
      *****
      * System ID must be entered
      *****
     C     SYSYS         IFEQ      *BLANKS
     C                   MOVE      YES           ERROR             3
     C                   MOVE      'SS00031'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVEA     '1'           *IN(31)
     C                   ENDIF
      *****
      * System description must be entered
      *****
     C     SYDESC        IFEQ      *BLANKS
     C                   MOVE      YES           ERROR
     C                   MOVE      'SS00032'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVEA     '1'           *IN(32)
     C                   ENDIF
      *****
     C                   ENDIF
      *****
     CSR                 ENDSR
      *****************************************************************
      * ?EXSC01 - Clear record format SCREEN01                      ? *
      *****************************************************************
     CSR   EXSC01        BEGSR
      *
     C                   SELECT
     C     $$MODE        WHENEQ    'A'
     C                   WRITE     SYSTM
     C     $$MODE        WHENEQ    'U'
     C                   UPDATE    SYSTM
     C                   ENDSL
      *
     C                   MOVE      SYSYS         #ESYS
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
