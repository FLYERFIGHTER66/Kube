      *--------------------------------------------------------------
      *
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- SAC370
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- SALES ANALYSIS BY CUSTOMER TOP RANKED
      **
      *
     FFMAPER    IF   E           K DISK
     FXATABL    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FSAC370S   CF   E             WORKSTN
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
      *
     D                UDS
     D  LCO                    1      2  0
     D  LMONTH                 3      4  0
     D  LDOLUN                 5      5  0
     D  LRANK                  6     11  0
     D  EMONTH                12     13  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *
     D  LPC01                172    173
     D  LPC02                174    175
     D  LPC03                176    177
     D  LPC04                178    179
     D  LPC05                180    181
     D  LPC06                182    183
     D  LPC07                184    185
     D  LPC08                186    187
     D  LPC09                188    189
     D  LPC10                190    191
     D  LPCFR                192    193
     D  LPCTO                194    195
     D  LCT01                196    197
     D  LCT02                198    199
     D  LCT03                200    201
     D  LCT04                202    203
     D  LCT05                204    205
     D  LCT06                206    207
     D  LCT07                208    209
     D  LCT08                210    211
     D  LCT09                212    213
     D  LCT10                214    215
     D  LCTFR                216    217
     D  LCTTO                218    219
      *
      ********************************************************************
      * ?Price Codes Selected                                           ?*
      ********************************************************************
     D                 DS
     D  PC                     1     20
     D                                     DIM(10)
     D  S1PC01                 1      2
     D  S1PC02                 3      4
     D  S1PC03                 5      6
     D  S1PC04                 7      8
     D  S1PC05                 9     10
     D  S1PC06                11     12
     D  S1PC07                13     14
     D  S1PC08                15     16
     D  S1PC09                17     18
     D  S1PC10                19     20
      *
      ********************************************************************
      * ?Customers Types Selected                                       ?*
      ********************************************************************
     D                 DS
     D  CT                     1     20
     D                                     DIM(10)
     D  S1CT01                 1      2
     D  S1CT02                 3      4
     D  S1CT03                 5      6
     D  S1CT04                 7      8
     D  S1CT05                 9     10
     D  S1CT06                11     12
     D  S1CT07                13     14
     D  S1CT08                15     16
     D  S1CT09                17     18
     D  S1CT10                19     20
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
     D*                                   B 378 3790PAGRRN
      *    Relative Record # of Last Changed Record in SFLRCD
     D  $3RRN#               397    400B 0
      *****************************************************************
      * ?Define Program Constants                                   ? *
      *****************************************************************
     D YES             C                   CONST('YES')
      *
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
|    C*                    WRITECFKY01
|    C                   WRITE     MSGCTL
|    C                   EXFMT     SCRNA
|     *
|     *? Reset Cursor Position                            ?             ?
      *
|    C                   Z-ADD     *ZERO         ##ROW
|    C                   Z-ADD     *ZERO         ##COL
|     *
|     *? Clear indicators and flags                       ?
|     *
     C                   SETOFF                                       98
     C                   MOVEA     '00'          *IN(10)
     C                   MOVEA     '0'           *IN(20)
     C                   MOVEA     '000'         *IN(30)
     C                   MOVEA     '00000000'    *IN(32)
     C                   MOVEA     '0000'        *IN(40)
     C                   MOVEA     '00000000'    *IN(51)
     C                   MOVEA     '0000'        *IN(59)
     C                   MOVEA     '00'          *IN(95)
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
      *
      * ?F2 pressed                                ?
     C     *IN02         WHENEQ    *ON
     C                   Z-ADD     LCO           ACCOMP            2 0
     C                   CALL      'LKACTP'
     C                   PARM                    ACCOMP
     C                   PARM                    VACTP
||    *
||    *? F12 - Previous - end program no update           ?
||    *
||3  C     *IN12         WHENEQ    *ON
||   C                   MOVE      YES           ENDPGM            3
     C                   MOVE      'X'           LCANCL
||   C                   LEAVE
||    *
||    *? If change on screen -- reset confirm             ?
||    *
||O  C                   OTHER
     C                   MOVE      *BLANKS       LCANCL
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
||    *? Process
||    *
|||| C                   EXSR      MOV@TO
||   C                   MOVE      YES           ENDPGM            3
     C                   ENDIF
     C                   ENDIF
||    *
|Sl  C                   ENDSL
Do   C                   ENDDO
      *
      *? End the program                                  ?             ?
      *
     C                   MOVE      *ON           *INLR
      *
      ***************************************************************
      *? Edit Screen                                   ?            *   ?
      ***************************************************************
     C     $EDT01        BEGSR
     C                   Z-ADD     VACTP         LMONTH
      *
     C     VACTP         IFLE      0                                                        K
     C     VACTP         ORGT      13                                                       K
     C                   MOVE      *ON           *IN10
     C                   MOVE      'YES'         ERROR
     C                   MOVE      'SAC3703'     $#MSID
     C                   EXSR      SRMSGF
     C                   GOTO      END01
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C     ACST13        IFEQ      0                                                        K
     C     VACTP         ANDEQ     13                                                       K
     C                   MOVE      *ON           *IN10
     C                   MOVE      'SAC3703'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVE      'YES'         ERROR
     C                   GOTO      END01
     C                   ENDIF
      *
     C     EMONTH        IFLE      0
     C                   Z-ADD     VACTP         EMONTH
     C                   ENDIF
      *
      *
     C     ACST13        IFEQ      0                                                        K
     C     EMONTH        ANDEQ     13                                                       K
     C                   MOVE      *ON           *IN30
     C                   MOVE      'SAC3703'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVE      'YES'         ERROR
     C                   GOTO      END01
     C                   ENDIF
      *
     C     EMONTH        IFLT      VACTP                                                    K
     C                   MOVE      *ON           *IN10
     C                   MOVE      *ON           *IN30
     C                   MOVE      'SAC3707'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVE      'YES'         ERROR
     C                   GOTO      END01
     C                   ENDIF
      *
     C     LDOLUN        IFLT      1                                                        K
     C     LDOLUN        ORGT      2                                                        K
     C                   MOVE      *ON           *IN20
     C                   MOVE      'SAC3704'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVE      'YES'         ERROR
     C                   GOTO      END01
     C                   ENDIF
      *
     C                   EXSR      CKCT
     C     *IN95         IFEQ      *ON
     C                   MOVE      'YES'         ERROR
     C                   MOVE      'SAC3701'     $#MSID
     C                   EXSR      SRMSGF
     C                   GOTO      END01
     C                   ENDIF
      *
     C                   MOVEL     S1CTFR        CSTTYP            2
     C     CSTTYP        IFNE      *BLANKS
     C     'CT'          CAT(P)    CSTTYP:0      TBIDKY            8
     C     TBKEY         CHAIN     XATABL                             99
     C     *IN99         IFEQ      *ON
     C                   MOVE      YES           ERROR
     C                   MOVE      '1'           *IN(61)
0054 C                   MOVEL     'SAC3702'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      END01
0069 C                   ENDIF                                                                 NORDT
0069 C                   ENDIF                                                                 NORDT
0051 C                   MOVEL     S1CTTO        CSTTYP                                        NORDT
     C     CSTTYP        IFNE      *BLANKS
     C     'CT'          CAT(P)    CSTTYP:0      TBIDKY            8
     C     TBKEY         CHAIN     XATABL                             99
     C     *IN99         IFEQ      *ON
     C                   MOVE      YES           ERROR
     C                   MOVE      '1'           *IN(62)
0054 C                   MOVEL     'SAC3702'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      END01
0069 C                   ENDIF                                                                 NORDT
0069 C                   ENDIF                                                                 NORDT
      *****
VS02  *? Low CT Range if Entered Must be Lower Than High Range    ?
      *****
0051 C     S1CTFR        IFGT      S1CTTO                                                      NORDT
     C                   MOVEA     '11'          *IN(61)
     C                   MOVE      YES           ERROR
0054 C                   MOVEL     'SAC3705'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      END01
0069 C                   ENDIF                                                                 NORDT
      *
     C                   EXSR      CKPC
     C     *IN96         IFEQ      *ON
     C                   MOVE      'YES'         ERROR
     C                   MOVE      'SAC3702'     $#MSID
     C                   EXSR      SRMSGF
     C                   GOTO      END01
     C                   ENDIF
      *
     C                   MOVEL     S1PCFR        PRCCDE            2
     C     PRCCDE        IFNE      *BLANKS
     C     PRCCDE        CHAIN     FMPRCL                             99
     C     *IN99         IFEQ      *ON
     C                   MOVE      YES           ERROR
     C                   MOVE      '1'           *IN(42)
0054 C                   MOVEL     'SAC3701'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      END01
0069 C                   ENDIF                                                                 NORDT
0069 C                   ENDIF                                                                 NORDT
0051 C                   MOVEL     S1PCTO        PRCCDE                                        NORDT
     C     PRCCDE        IFNE      *BLANKS
     C     PRCCDE        CHAIN     FMPRCL                             99
     C     *IN99         IFEQ      *ON
     C                   MOVE      YES           ERROR
     C                   MOVE      '1'           *IN(43)
0054 C                   MOVEL     'SAC3701'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      END01
0069 C                   ENDIF                                                                 NORDT
0069 C                   ENDIF                                                                 NORDT
      *****
VS02  *? Low PC Range if Entered Must be Lower Than High Range    ?
      *****
0051 C     S1PCFR        IFGT      S1PCTO                                                      NORDT
     C                   MOVEA     '11'          *IN(42)
     C                   MOVE      YES           ERROR
0054 C                   MOVEL     'SAC3706'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      END01
0069 C                   ENDIF                                                                 NORDT
      *
     C                   EXSR      MOV@TO
      *
     C     END01         ENDSR
      *
      ***************************************************************
      ***************************************************************
      *? Validate Customers Selected                   ?            *   ?
      ***************************************************************
     C     CKCT          BEGSR
     C                   DO        10            II                2 0
     C                   MOVEL     CT(II)        CSTTYP            2
     C     CSTTYP        IFNE      *BLANKS
     C     'CT'          CAT(P)    CSTTYP:0      TBIDKY            8
     C     TBKEY         CHAIN     XATABL                             99
     C     *IN99         IFEQ      *ON
     C     II            ADD       50            IN                2 0
     C                   MOVE      *ON           *IN(IN)
     C                   MOVE      *ON           *IN95
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDSR
      ***************************************************************
      *? Validate Price Codes                          ?            *   ?
      ***************************************************************
     C     CKPC          BEGSR
     C                   DO        10            II                2 0
     C                   MOVEL     PC(II)        PRCCDE            2
     C     PRCCDE        IFNE      *BLANKS
     C     PRCCDE        CHAIN     FMPRCL                             99
     C     *IN99         IFEQ      *ON
     C     II            ADD       31            IN                2 0
     C                   MOVE      *ON           *IN(IN)
     C                   MOVE      *ON           *IN96
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
      * ?       Program Initialization and Housekeeping                 ?*
      ********************************************************************
     CSR   *INZSR        BEGSR
      *
      * Define Key Lists ?
      *
      *
      * ?KLIST for file - CBTABL      Library - *LIBL     ?
      *
     C     TBKEY         KLIST
     C                   KFLD                    TBIDKY
      *
     C                   Z-ADD     1             LDOLUN
     C                   Z-ADD     1             LRANK
     C                   Z-ADD     0             EMONTH
     C                   Z-ADD     0             LMONTH
     C                   Z-ADD     1             LCO
     C                   Z-ADD     1             LCOPY
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
     C                   ENDSR
      ********************************************************************
      * ?       Move Screen Fields to LDA                               ?*
      ********************************************************************
     CSR   MOV@TO        BEGSR
     C                   MOVE      S1PC01        LPC01
     C                   MOVE      S1PC02        LPC02
     C                   MOVE      S1PC03        LPC03
     C                   MOVE      S1PC04        LPC04
     C                   MOVE      S1PC05        LPC05
     C                   MOVE      S1PC06        LPC06
     C                   MOVE      S1PC07        LPC07
     C                   MOVE      S1PC08        LPC08
     C                   MOVE      S1PC09        LPC09
     C                   MOVE      S1PC10        LPC10
     C                   MOVE      S1PCFR        LPCFR
     C                   MOVE      S1PCTO        LPCTO
     C                   MOVE      S1CT01        LCT01
     C                   MOVE      S1CT02        LCT02
     C                   MOVE      S1CT03        LCT03
     C                   MOVE      S1CT04        LCT04
     C                   MOVE      S1CT05        LCT05
     C                   MOVE      S1CT06        LCT06
     C                   MOVE      S1CT07        LCT07
     C                   MOVE      S1CT08        LCT08
     C                   MOVE      S1CT09        LCT09
     C                   MOVE      S1CT10        LCT10
     C                   MOVE      S1CTFR        LCTFR
     C                   MOVE      S1CTTO        LCTTO
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
