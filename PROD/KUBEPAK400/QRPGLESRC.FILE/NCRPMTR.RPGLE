      *%*******************************************************************
      *%                                                                 **
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- SCRPMTR                                                *
      *                                                                   *
      * Purpose?- For Prompting for Item #, Size, Printer,               *
      *            Number of Copies, Status and Clear files               *
      *                                                                   *
      *   Date  ?Programmer    ? Comment                             ? *
      *  03/03/04  R. Piasecki      Program Created                       *
      *                                                                   *
      *%*******************************************************************
     FPRTTABL   IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FNCRPMTS   CF   E             WORKSTN
      *
0010 D DD              S              2  0 DIM(12) CTDATA PERRCD(12)            DATE EDIT        NWD
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
      * ?Define From & To Dates                                         ?*
      ********************************************************************
     D                 DS
     D  S1DATE                 1      8  0 INZ(0)
     D  FYYYY                  1      4  0 INZ(0)
     D  FMONTH                 5      6  0 INZ(0)
     D  FDAY                   7      8  0 INZ(0)
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
     C     S1SIZE        IFNE      *BLANKS
     C                   MOVE      *BLANKS       S1ITEM
     C                   MOVE      *ON           *IN48
     C                   ENDIF
Do   C     ENDPGM        DOWNE     YES
|     *
|     *? Write Cmd Key, Msgsfl                            ?
|     *
Do   C     STR01         TAG
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
|    C                   MOVEA     '0000000'     *IN(48)                        CLR *IN48-54
|    C                   MOVEA     '00'          *IN(13)                        CLR *IN48-54
|    C                   MOVE      *OFF          *IN18                          CLR *IN48-54
|    C                   MOVE      *BLANKS       ERROR             3
|     *
|     *? Clear Messages                                   ?
|     *
|    C                   MOVE      'C'           $#MSFN            1
|    C                   EXSR      SRMSGF
|    C                   MOVE      'S'           $#MSFN            1
     C     *IN04         IFEQ      *ON
     C                   EXSR      $PRMPT
     C                   GOTO      STR01
     C                   ENDIF
|     *? SELECT WHEN:
|Sl  C                   SELECT
||    *? Read SCREEN01 and check for  Validity.       ?
||    *
||    *? F03 -  End Program No Report           ?
||    *
||3  C     *IN03         WHENEQ    *ON
||   C                   MOVE      YES           ENDPGM            3
||   C                   MOVE      '1'           F3                1
||    *? If change on screen -- reset confirm             ?
||    *
||O  C                   OTHER
||If C     *IN28         IFEQ      *ON
|||  C                   MOVE      *OFF          $$CNFR            1
||If C                   END
||   C                   EXSR      CKIN01
||    *
||If C     ERROR         IFEQ      YES
|||  C                   MOVE      *OFF          $$CNFR
||X  C                   ELSE
|||   *
|||IfC     $$CNFR        IFEQ      *OFF
|||| C                   MOVE      *ON           $$CNFR            1
|||| C                   MOVE      'SR00006'     $#MSID                         ?Message Id   ?
|||| C                   EXSR      SRMSGF
|||X C                   ELSE
||||  *
|||| C                   EXSR      EXSC01
Do   C                   ENDIF
Do   C                   ENDIF
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
      *? PASS PARAMETER LIST                              ?             ?
      *
     C     *ENTRY        PLIST
     C                   PARM                    DATE              8
     C                   PARM                    ITEM#            12
     C                   PARM                    SIZE              3
     C                   PARM                    OUTQ             10
     C                   PARM                    COPY              2
     C                   PARM                    OUTP              4
     C                   PARM                    SAVE              4
     C                   PARM                    DFILE             1
     C                   PARM                    F3                1
      *
     C                   MOVE      DATE          S1DATE
     C                   MOVE      *BLANKS       S1ITEM
     C                   MOVE      SIZE          S1SIZE
     C                   MOVE      OUTQ          S1OUTQ
     C                   MOVE      COPY          S1COPY
     C                   MOVE      OUTP          S1OUTP
      *
     C     S1KEY         KLIST
     C                   KFLD                    ITEM#
     C                   KFLD                    S1SIZE
     C                   KFLD                    LOC
     C                   MOVE      '   '         LOC               3            ?Pgm Msg Queue?
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
     C                   Z-ADD     1             S1COPY
     C                   Z-ADD     1             S1OUTP
     CSR                 ENDSR
      ********************************************************************
      * ?CKIN01 - Check the input from Screen                           ?*
      ********************************************************************
     CSR   CKIN01        BEGSR
      *****
VS02  *? Date Must be valid                   ?
      *****
0051 C     FMONTH        IFLT      01                                                          NORDT
0052 C     FMONTH        ORGT      12                                                          NORDT
     C                   MOVE      YES           ERROR
0062 C                   MOVE      *ON           *IN18                                         NORDT
0054 C                   MOVE      'DATE111'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
0056 C*                                                                   NORDTE
0057 C                   MOVE      FMONTH        CMO               2 0                         NORDT
0058 C                   MOVE      FDAY          CDA               2 0                         NORDT
0059 C                   MOVE      FYYYY         CKYR              4 0                         NORDT
0059 C                   MOVEL     FYYYY         CENT              2 0                         NORDT
0060 C                   EXSR      EDITDT                                                      NORDT
     C     *IN50         IFEQ      *ON
     C                   MOVE      YES           ERROR
0061 C                   MOVEL     'DATE112'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
0062 C                   MOVE      *ON           *IN13                                         NORDT
     C                   GOTO      ##EN01
     C                   ENDIF
0056 C*                                                                   NORDTE
0065 C     CKYR          IFLT      1998                                                        NORDT
0066 C     CENT          ORGT      20                                                          NORDT
     C                   MOVE      YES           ERROR
0067 C                   MOVE      *ON           *IN14                                         NORDT
0068 C                   MOVEL     'DATE113'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
0069 C                   ENDIF                                                                 NORDT
0056 C*                                                                   NORDTE
      *****
VS02  *? Item and Size Must be valid                   ?
      *****
||1  C                   MOVEL     S1ITEM        ITEM#            12
||1  C                   MOVEL     S1SIZE        SIZE              3
||1  C     S1KEY         CHAIN     FMINVT                             48
||1  C     *IN48         IFEQ      *ON
     C                   MOVE      YES           ERROR
0054 C                   MOVE      *ON           *IN49                                         NORDT
0054 C                   MOVE      'SAR0001'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
      *****
VS02  *? Printer Must be Valid                          ?
      *****
||1  C     S1OUTQ        CHAIN     PRTTABL                            54
||1  C     *IN54         IFEQ      *ON
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'SS99997'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
      *****
VS02  *? Number of Copies cannot be Zero                ?
      *****
||1  C     S1COPY        IFEQ      *ZEROS
||1  C                   MOVE      *ON           *IN51
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'SS99993'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
      *****
VS02  *? Output Status must be 1, 2, or 3.                ?
      *****
||1  C     S1OUTP        IFNE      1
||1  C     S1OUTP        IFNE      2
||1  C     S1OUTP        IFNE      3
||1  C                   MOVE      *ON           *IN52
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'SS99995'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ##EN01
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     CSR   ##EN01        ENDSR
      *****************************************************************
      * ?EXSC01 - EXECUTE PARAMETER SETUP                           ? *
      *****************************************************************
     CSR   EXSC01        BEGSR
      *
||    *
     C     $$CNFR        IFEQ      *ON
     C                   MOVE      S1DATE        DATE              8
     C                   MOVE      S1OUTQ        OUTQ             10
     C                   MOVE      S1COPY        COPY              2
     C     S1OUTP        IFEQ      1
     C                   MOVEL     '*NO '        OUTP              4
     C                   MOVEL     '*NO '        SAVE              4
||If C                   ENDIF
     C     S1OUTP        IFEQ      2
     C                   MOVEL     '*NO '        OUTP
     C                   MOVEL     '*YES'        SAVE
||If C                   ENDIF
     C     S1OUTP        IFEQ      3
     C                   MOVEL     '*YES'        OUTP
     C                   MOVEL     '*YES'        SAVE
||If C                   ENDIF
||   C                   MOVE      YES           ENDPGM            3
||If C                   ENDIF
||If C                   ENDSR
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
      * ?Call Cursor Help Program                         ?
      *
     C                   CALL      'XACHLPC'                            69
     C                   PARM                    ##FLD
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
      * ?$PRMPT - Handles F4 prompt function                       ? *
      *****************************************************************
      *? Product Codes Lookup
      *****
     CSR   $PRMPT        BEGSR
     C                   SELECT
      *****
      *? Printer look-up Valid from Fmt SCREEN01
      *****
     C     ##RCD         WHENEQ    'SCREEN01'
     C     ##FLD         ANDEQ     'S1OUTQ'
     C                   CLEAR                   @PELM#
     C                   MOVE      'I'           INQ               1
     C                   CALL      'PRTTABLR'
     C                   PARM                    @PELM#           10
     C                   PARM                    INQ
     C     @PELM#        IFNE      *BLANKS
     C                   MOVEL     @PELM#        S1OUTQ
     C                   ENDIF
     C                   ENDSL
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
0108 C********************************************************************ROYDTE
VS02 C*?EDITDT - EDIT THAT DATES ARE VALID                   ?
0109 C******************************************************************* NORDTE
0110 C*                                                                   NORDTE
0111 C     EDITDT        BEGSR                                                                 NORDT
0112 C*                                                                   NORDTE
0113 C     CKYR          DIV       4             CKLEAP            5 0                         NORDT
0114 C                   MVR                     CKLEAP                                        NORDT
0115 C     CKLEAP        IFEQ      *ZERO                                                       NORDT
0116 C                   Z-ADD     29            DD(2)                                         NORDT
0116 C                   ELSE                                                                  NORDT
0117 C                   Z-ADD     28            DD(2)                                         NORDT
0117 C                   ENDIF                                                                 NORDT
0118 C*                                                                   NORDTE
0119 C     CDA           IFLT      01                                                          NORDT
0120 C     CDA           ORGT      DD(CMO)                                                     NORDT
     C                   MOVE      *ON           *IN50                                         NORDT
     C                   ENDIF                                                                 NORDT
0121 C                   ENDSR                                                                 NORDT
** DD
312831303130313130313031
