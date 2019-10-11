      *%*******************************************************************
      *%                                                                 **
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- Inventory                                       **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- INV002R                                                *
      *                                                                   *
      * Purpose?- Product Class Master Maintenance                       *
      *                                                                   *
      *   Date  ? Programmer       ?  Comment                        ? *
      *  8/12/2003  Richard E. Piasecki  Program Created                  *
      *                                                                   *
      *%*******************************************************************
     FINV002S   CF   E             WORKSTN
     F                                     INFDS(INFDS3)
     FFMPRCL    UF A E           K DISK
0010 D DD              S              2  0 DIM(12) CTDATA PERRCD(12)            DATE EDIT        NWD
     D CK              S              2  0 DIM(4)
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
     D                 DS
     D  PCSDTF                 1      4  0 INZ(0)
     D  FRMM                   1      2  0
     D  FRDD                   3      4  0
     D                 DS
     D  PCSDTT                 1      4  0 INZ(0)
     D  TOMM                   1      2  0
     D  TODD                   3      4  0
     D                 DS
     D  INV                    1      4  0 INZ(0)
     D  PCPRI1                 1      1  0
     D  PCPRI2                 2      2  0
     D  PCPRI3                 3      3  0
     D  PCPRI4                 4      4  0
     D                 DS
     D  PS                     1      4  0 INZ(0)
     D  PCPRP1                 1      1  0
     D  PCPRP2                 2      2  0
     D  PCPRP3                 3      3  0
     D  PCPRP4                 4      4  0
     D                 DS
     D  REP                    1      4  0 INZ(0)
     D  PCPRR1                 1      1  0
     D  PCPRR2                 2      2  0
     D  PCPRR3                 3      3  0
     D  PCPRR4                 4      4  0
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
|    C                   MOVE      *OFF          *IN76                          CLR *IN76
|    C                   MOVE      *OFF          *IN99                          CLR *IN99
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
||    *
||    *? F12 - Previous - end program no update           ?
||    *
||3  C     *IN12         WHENEQ    *ON
     C     $$MODE        IFEQ      'U'
     C                   UNLOCK    FMPRCL
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
     C                   PARM                    #PPRD#            2
     C                   PARM                    #PACTN            1
     C                   MOVE      #PPRD#        #ICRID            2
      *
      * Define Key Lists ?
      *
      *
      * ?KLIST for file - FMPRCL      Library - *LIBL     ?
      *
     C     ICKEY         KLIST
     C                   KFLD                    PCPRCL
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
     C     #PACTN        IFEQ      'I'
     C                   MOVEA     '11'          *IN(88)
     C                   ENDIF
      *
      *? Initial Screen load                             ?             ?
      *
     C     #ICRID        IFNE      *BLANKS
     C                   MOVE      #ICRID        PCPRCL
     C                   ENDIF
     C     ICKEY         CHAIN     FMPRCL                             66
     C     *IN66         IFEQ      *ON
     C     #ICRID        OREQ      *BLANKS
     C                   MOVE      'A'           $$MODE            1
     C                   MOVE      *ON           *IN81
     C                   MOVE      'SR00008'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      'N'           PCSUMF
     C                   MOVE      'N'           PCEVD
     C                   Z-ADD     1             PCPRI1
     C                   Z-ADD     2             PCPRI2
     C                   Z-ADD     3             PCPRI3
     C                   Z-ADD     4             PCPRI4
     C                   Z-ADD     1             PCPRP1
     C                   Z-ADD     2             PCPRP2
     C                   Z-ADD     3             PCPRP3
     C                   Z-ADD     4             PCPRP4
     C                   Z-ADD     1             PCPRR1
     C                   Z-ADD     2             PCPRR2
     C                   Z-ADD     3             PCPRR3
     C                   Z-ADD     4             PCPRR4
     C                   ELSE
     C                   MOVE      'U'           $$MODE
     C                   MOVE      'SR00007'     $#MSID                         ?Message Id   ?
     C     *IN88         IFEQ      *ON
     C                   MOVE      'INV0041'     $#MSID                         ?Message Id   ?
     C                   ENDIF
     C                   EXSR      SRMSGF
     C                   END
      *
      *
     C                   CLEAR                   #ICRID
     CSR                 ENDSR
      ********************************************************************
      * ?$EDT01 - Check the input from screen 01                        ?*
      ********************************************************************
     CSR   $EDT01        BEGSR
      *****
      * IF ADDING RECORD, IT MUST NOT ALREADY EXIST
      *****
     C     $$MODE        IFEQ      'A'
     C     ICKEY         CHAIN     FMPRCL                             67
     C     *IN67         IFEQ      *OFF
     C     *NOKEY        CLEAR                   RMPRCL
     C                   MOVE      YES           ERROR             3
     C                   MOVE      'INV0023'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVEA     '1'           *IN(31)
     C                   GOTO      ##EN01
     C                   END
     C                   END
      *****
      * Continue if update mode or add mode & record not found
      *****
     C     $$MODE        IFEQ      'A'
     C     *IN67         ANDEQ     *ON
     C     $$MODE        OREQ      'U'
      *****
      * ?Item Class Code Must be Entered                                ?*
      *****
0148 C     PCPRCL        IFEQ      *BLANK
     C                   MOVE      YES           ERROR             3
0150 C                   MOVE      'INV0022'     $#MSID
     C                   EXSR      SRMSGF
0152 C                   MOVEA     '1'           *IN(31)
     C                   GOTO      ##EN01
0166 C                   END
      *****
      * Class Description must be entered
      *****
     C     PCDESC        IFEQ      *BLANKS
     C                   MOVE      YES           ERROR             3
     C                   MOVE      'INV0024'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVEA     '1'           *IN(32)
     C                   GOTO      ##EN01
     C                   END
     C                   ENDIF                                                  End if Add mode
      *****
      * Summarize on Invoice Must by Y or N
      *****
     C     PCSUMF        IFNE      'Y'
     C     PCSUMF        IFNE      'N'
     C                   MOVE      YES           ERROR             3
     C                   MOVE      'INV0025'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVEA     '1'           *IN(33)
     C                   GOTO      ##EN01
     C                   ENDIF                                                  End if Add mode
     C                   ENDIF                                                  End if Add mode
      *****
      * Eligible/Volumn Discount Must by Y or N
      *****
     C     PCEVD         IFNE      'Y'
     C     PCEVD         IFNE      'N'
     C                   MOVE      YES           ERROR             3
     C                   MOVE      'INV0026'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVEA     '1'           *IN(34)
     C                   GOTO      ##EN01
     C                   ENDIF                                                  End if Add mode
     C                   ENDIF                                                  End if Add mode
      *****
      * ?Validate From Month and Day                                    ?*
      *****
0051 C     FRMM          IFLT      01                                                          NORDT
0052 C     FRMM          ORGT      12                                                          NORDT
0062 C                   MOVE      *ON           *IN35                                         NORDT
     C                   ENDIF
0056 C*                                                                   NORDTE
     C     *IN35         IFNE      *ON
0057 C                   MOVE      FRMM          CMO               2 0                         NORDT
0058 C                   MOVE      FRDD          CDA               2 0                         NORDT
0059 C                   MOVE      UYEAR         CKYR              2 0                         NORDT
0060 C                   EXSR      EDITDT                                                      NORDT
     C                   ENDIF
0056 C*                                                                   NORDTE
     C     *IN76         IFEQ      *ON
0062 C                   MOVE      *ON           *IN35                                         NORDT
     C                   ENDIF
     C     *IN35         IFEQ      *ON
     C                   MOVE      YES           ERROR
0061 C                   MOVEL     'INV0027'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
0056 C*                                                                   NORDTE
      *****
      * ?Validate To Month and Day                                      ?*
      *****
0051 C     TOMM          IFLT      01                                                          NORDT
0052 C     TOMM          ORGT      12                                                          NORDT
0062 C                   MOVE      *ON           *IN36                                         NORDT
     C                   ENDIF
0056 C*                                                                   NORDTE
     C     *IN36         IFNE      *ON
0057 C                   MOVE      TOMM          CMO               2 0                         NORDT
0058 C                   MOVE      TODD          CDA               2 0                         NORDT
0059 C                   MOVE      UYEAR         CKYR              2 0                         NORDT
0060 C                   EXSR      EDITDT                                                      NORDT
     C                   ENDIF
0056 C*                                                                   NORDTE
     C     *IN76         IFEQ      *ON
0062 C                   MOVE      *ON           *IN36                                         NORDT
     C                   ENDIF
     C     *IN36         IFEQ      *ON
     C                   MOVE      YES           ERROR
0061 C                   MOVEL     'INV0028'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
0056 C*                                                                   NORDTE
      *****
      * ?From Month and Day cannot be less than to Month and Day        ?*
      *****
0051 C     PCSDTT        IFLT      PCSDTF                                                      NORDT
0062 C                   MOVEA     '11'          *IN(35)                                       NORDT
     C                   MOVE      YES           ERROR
0061 C                   MOVEL     'INV0029'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
0056 C*                                                                   NORDTE
      *****
      * ?At least one number must be entered for Invoice Print Sequence ?*
      *****
0051 C     INV           IFEQ      *ZEROS                                                      NORDT
0062 C                   MOVE      *ON           *IN37                                         NORDT
     C                   MOVE      YES           ERROR
0061 C                   MOVEL     'INV0210'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
0056 C*                                                                   NORDTE
     C                   Z-ADD     PCPRI1        I1                1 0
     C                   Z-ADD     PCPRI2        I2                1 0
     C                   Z-ADD     PCPRI3        I3                1 0
     C                   Z-ADD     PCPRI4        I4                1 0
     C                   EXSR      CHKIT
     C     *IN99         IFEQ      *ON
     C                   MOVE      *ON           *IN37
     C                   MOVE      YES           ERROR
0061 C                   MOVEL     'INV0211'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
      *****
      * ?At least one number must be entered for Pick Slip Sequence     ?*
      *****
0051 C     PS            IFEQ      *ZEROS                                                      NORDT
0062 C                   MOVE      *ON           *IN38                                         NORDT
     C                   MOVE      YES           ERROR
0061 C                   MOVEL     'INV0210'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
0056 C*                                                                   NORDTE
     C                   Z-ADD     PCPRP1        I1                1 0
     C                   Z-ADD     PCPRP2        I2                1 0
     C                   Z-ADD     PCPRP3        I3                1 0
     C                   Z-ADD     PCPRP4        I4                1 0
     C                   EXSR      CHKIT
     C     *IN99         IFEQ      *ON
     C                   MOVE      *ON           *IN38
     C                   MOVE      YES           ERROR
0061 C                   MOVEL     'INV0211'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
      *****
      * ?At least one number must be entered for Report Sequence        ?*
      *****
0051 C     REP           IFEQ      *ZEROS                                                      NORDT
0062 C                   MOVE      *ON           *IN39                                         NORDT
     C                   MOVE      YES           ERROR
0061 C                   MOVEL     'INV0210'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
0056 C*                                                                   NORDTE
     C                   Z-ADD     PCPRR1        I1                1 0
     C                   Z-ADD     PCPRR2        I2                1 0
     C                   Z-ADD     PCPRR3        I3                1 0
     C                   Z-ADD     PCPRR4        I4                1 0
     C                   EXSR      CHKIT
     C     *IN99         IFEQ      *ON
     C                   MOVE      *ON           *IN39
     C                   MOVE      YES           ERROR
0061 C                   MOVEL     'INV0211'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
      *****
     CSR   ##EN01        ENDSR
      *****************************************************************
      * ?EXSC01 - Clear record format SCREEN01                      ? *
      *****************************************************************
     CSR   EXSC01        BEGSR
      *
      *
     C                   SELECT
     C     $$MODE        WHENEQ    'A'
     C                   WRITE     RMPRCL
     C     $$MODE        WHENEQ    'U'
     C                   UPDATE    RMPRCL
     C                   ENDSL
      *
     C                   MOVE      PCPRCL        #PPRD#
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
0108 C********************************************************************ROYDTE
VS02 C*?EDITDT - EDIT THAT DATES ARE VALID                   ?
0109 C******************************************************************* NORDTE
0110 C*                                                                   NORDTE
0111 C     EDITDT        BEGSR                                                                 NORDT
0112 C*                                                                   NORDTE
0113 C     CKYR          DIV       4             CKLEAP            2 0                         NORDT
0114 C                   MVR                     CKLEAP                                        NORDT
0115 C     CKLEAP        IFEQ      *ZERO                                                       NORDT
0116 C                   Z-ADD     29            DD(2)                                         NORDT
0116 C                   ELSE                                                                  NORDT
0117 C                   Z-ADD     28            DD(2)                                         NORDT
0117 C                   ENDIF                                                                 NORDT
0118 C*                                                                   NORDTE
0119 C     CDA           IFLT      01                                                          NORDT
0120 C     CDA           ORGT      DD(CMO)                                                     NORDT
     C                   MOVE      *ON           *IN76                                         NORDT
     C                   ENDIF                                                                 NORDT
0121 C                   ENDSR                                                                 NORDT
      **********
      * CHKIT  *
      **********
      *
     C     CHKIT         BEGSR
      *
      * VALIDATE ORDER OF DESCRIPTIONS DURING PRING
      *
     C     I1            ADD       I2            TEST              3 0
     C                   ADD       I3            TEST
     C                   ADD       I4            TEST
      *
     C     TEST          IFGT      10
     C     TEST          ORLT      1
     C                   SETON                                          99
     C                   GOTO      ENDCK
     C                   ENDIF
      *
     C     I1            IFGT      4
     C     I2            ORGT      4
     C     I3            ORGT      4
     C     I4            ORGT      4
     C                   SETON                                          99
     C                   GOTO      ENDCK
     C                   ENDIF
      *
     C                   Z-ADD     0             CK
     C     I1            IFGT      0
     C                   ADD       1             CK(I1)
     C                   ENDIF
     C     I2            IFGT      0
     C                   ADD       1             CK(I2)
     C                   ENDIF
     C     I3            IFGT      0
     C                   ADD       1             CK(I3)
     C                   ENDIF
     C     I4            IFGT      0
     C                   ADD       1             CK(I4)
     C                   ENDIF
     C     CK(1)         IFEQ      0
     C                   SETON                                          99
     C                   GOTO      ENDCK
     C                   ENDIF
      *
     C                   Z-ADD     1             X                 1 0
     C     X             DOUEQ     5
     C     CK(X)         IFGT      1
     C                   SETON                                          99
     C                   GOTO      ENDCK
     C                   ENDIF
     C     X             ADD       1             X1                1 0
     C     X1            IFLE      4
     C     CK(X)         ANDEQ     0
     C     CK(X1)        ANDGT     0
     C                   SETON                                          99
     C                   GOTO      ENDCK
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
     C     ENDCK         ENDSR
      *
** DD
312831303130313130313031
