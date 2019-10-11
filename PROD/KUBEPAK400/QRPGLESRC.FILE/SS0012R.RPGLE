      *%*******************************************************************
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- Kubepak                                         **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- SS0012R                                                *
      *                                                                   *
      * Purpose?- Security - User Master Maintenance                     *
      *                                                                   *
      *   Date  ?Programmer       ?  Comment                         ? *
      *  8/9/2003  Richard E. Piasecki  Program Created                   *
      *                                                                   *
      *%*******************************************************************
     FSS0012S   CF   E             WORKSTN
     F                                     INFDS(INFDS3)
     FSECSYS    IF   E           K DISK
     FSECUSER   UF A E           K DISK
      *
      ********************************************************************
      * ?Tables & arrays                                                ?*
      ********************************************************************
     D VE              S              1    DIM(20)
      ********************************************************************
      * ?Valid entries 1-20                                             ?*
      ********************************************************************
     D                 DS
     D  VV                     1    400
     D                                     DIM(20)
     D  SYVE01                 1     20
     D  SYVE02                21     40
     D  SYVE03                41     60
     D  SYVE04                61     80
     D  SYVE05                81    100
     D  SYVE06               101    120
     D  SYVE07               121    140
     D  SYVE08               141    160
     D  SYVE09               161    180
     D  SYVE10               181    200
     D  SYVE11               201    220
     D  SYVE12               221    240
     D  SYVE13               241    260
     D  SYVE14               261    280
     D  SYVE15               281    300
     D  SYVE16               301    320
     D  SYVE17               321    340
     D  SYVE18               341    360
     D  SYVE19               361    380
     D  SYVE20               381    400
      ********************************************************************
      * ?Actual entries 1-20                                            ?*
      ********************************************************************
     D                 DS
     D  EE                     1     20
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
      * ?Option Text 1-20                                               ?*
      ********************************************************************
     D                 DS
     D  TX                     1    400
     D                                     DIM(20)
     D  SYTX01                 1     20
     D  SYTX02                21     40
     D  SYTX03                41     60
     D  SYTX04                61     80
     D  SYTX05                81    100
     D  SYTX06               101    120
     D  SYTX07               121    140
     D  SYTX08               141    160
     D  SYTX09               161    180
     D  SYTX10               181    200
     D  SYTX11               201    220
     D  SYTX12               221    240
     D  SYTX13               241    260
     D  SYTX14               261    280
     D  SYTX15               281    300
     D  SYTX16               301    320
     D  SYTX17               321    340
     D  SYTX18               341    360
     D  SYTX19               361    380
     D  SYTX20               381    400
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
     C     WKVIEW        IFEQ      1
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
     C                   UNLOCK    SECUSER
     C                   ENDIF
||   C                   MOVE      'XX'          #ESYS
||   C                   MOVE      YES           ENDPGM            3
||    *
||    *? F12 - Previous - end program no update           ?
||    *
||3  C     *IN12         WHENEQ    *ON
     C     WKVIEW        IFEQ      2
     C                   Z-ADD     1             WKVIEW
     C                   ELSE
     C     $$MODE        IFEQ      'U'
     C                   UNLOCK    SECUSER
     C                   ENDIF
||   C                   MOVE      YES           ENDPGM            3
     C                   ENDIF
||    *
||    *? If change on screen -- reset confirm             ?
||    *
||O  C                   OTHER
||If C     *IN28         IFEQ      *ON
|||  C                   MOVE      *OFF          $$CNFR            1
||If C                   END
||    *
||    *? Validate screen
||    *
     C     WKVIEW        IFEQ      1
||   C                   EXSR      $EDT01
     C                   ELSE
     C                   EXSR      $EDT02
     C                   ENDIF
||    *
     C                   SELECT
||If C     ERROR         WHENEQ    YES
|||  C                   MOVE      *OFF          $$CNFR
|||   *
|||IfC     $$CNFR        WHENEQ    *OFF
     C     WKVIEW        ANDEQ     2
     C     $$CNFR        OREQ      *OFF
     C     WKVIEW        ANDEQ     1
     C     WKPAG2        ANDEQ     'N'
|||| C                   MOVE      *ON           $$CNFR
|||| C                   MOVE      'SR00006'     $#MSID                         ?Message Id   ?
|||| C                   EXSR      SRMSGF
||||  *
     C     WKVIEW        WHENEQ    1
     C     WKPAG2        ANDEQ     'Y'
     C                   Z-ADD     2             WKVIEW
      *
     C                   OTHER
|||| C                   EXSR      $UPDAT
|||IfC                   ENDSL
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
     C                   PARM                    #EUSID           10
      *
      * Define Key Lists ?
      *
      *
      * ?KLIST for file - SECSYS      Library - *LIBL     ?
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
      *? Get system record                                              ?
      *
     C     #ESYS         CHAIN     SYSTM                              99
      *
      *? Determine number of options in file                            ?
      *
     C     SYCH11        IFNE      *BLANKS
     C     SYCH12        ORNE      *BLANKS
     C     SYCH13        ORNE      *BLANKS
     C     SYCH14        ORNE      *BLANKS
     C     SYCH15        ORNE      *BLANKS
     C     SYCH16        ORNE      *BLANKS
     C     SYCH17        ORNE      *BLANKS
     C     SYCH18        ORNE      *BLANKS
     C     SYCH19        ORNE      *BLANKS
     C     SYCH20        ORNE      *BLANKS
     C                   MOVE      'Y'           WKPAG2            1
     C                   ELSE
     C                   MOVE      'N'           WKPAG2
     C                   ENDIF
      *
      *? Build valid options fields                                     ?
      *
     C     SYVE01        IFNE      *BLANKS
     C                   MOVEL     SYVE01        WKVEIN           20
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE01
     C                   ELSE
     C                   MOVE      *ON           *IN71
     C                   ENDIF
      *
     C     SYVE02        IFNE      *BLANKS
     C                   MOVEL     SYVE02        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE02
     C                   ELSE
     C                   MOVE      *ON           *IN72
     C                   ENDIF
      *
     C     SYVE03        IFNE      *BLANKS
     C                   MOVEL     SYVE03        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE03
     C                   ELSE
     C                   MOVE      *ON           *IN73
     C                   ENDIF
      *
     C     SYVE04        IFNE      *BLANKS
     C                   MOVEL     SYVE04        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE04
     C                   ELSE
     C                   MOVE      *ON           *IN74
     C                   ENDIF
      *
     C     SYVE05        IFNE      *BLANKS
     C                   MOVEL     SYVE05        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE05
     C                   ELSE
     C                   MOVE      *ON           *IN75
     C                   ENDIF
      *
     C     SYVE06        IFNE      *BLANKS
     C                   MOVEL     SYVE06        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE06
     C                   ELSE
     C                   MOVE      *ON           *IN76
     C                   ENDIF
      *
     C     SYVE07        IFNE      *BLANKS
     C                   MOVEL     SYVE07        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE07
     C                   ELSE
     C                   MOVE      *ON           *IN77
     C                   ENDIF
      *
     C     SYVE08        IFNE      *BLANKS
     C                   MOVEL     SYVE08        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE08
     C                   ELSE
     C                   MOVE      *ON           *IN78
     C                   ENDIF
      *
     C     SYVE09        IFNE      *BLANKS
     C                   MOVEL     SYVE09        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE09
     C                   ELSE
     C                   MOVE      *ON           *IN79
     C                   ENDIF
      *
     C     SYVE10        IFNE      *BLANKS
     C                   MOVEL     SYVE10        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE10
     C                   ELSE
     C                   MOVE      *ON           *IN80
     C                   ENDIF
      *
     C     SYVE11        IFNE      *BLANKS
     C                   MOVEL     SYVE11        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE11
     C                   ELSE
     C                   MOVE      *ON           *IN81
     C                   ENDIF
      *
     C     SYVE12        IFNE      *BLANKS
     C                   MOVEL     SYVE12        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE12
     C                   ELSE
     C                   MOVE      *ON           *IN82
     C                   ENDIF
      *
     C     SYVE13        IFNE      *BLANKS
     C                   MOVEL     SYVE13        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE13
     C                   ELSE
     C                   MOVE      *ON           *IN83
     C                   ENDIF
      *
     C     SYVE14        IFNE      *BLANKS
     C                   MOVEL     SYVE14        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE14
     C                   ELSE
     C                   MOVE      *ON           *IN84
     C                   ENDIF
      *
     C     SYVE15        IFNE      *BLANKS
     C                   MOVEL     SYVE15        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE15
     C                   ELSE
     C                   MOVE      *ON           *IN85
     C                   ENDIF
      *
     C     SYVE16        IFNE      *BLANKS
     C                   MOVEL     SYVE16        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE16
     C                   ELSE
     C                   MOVE      *ON           *IN86
     C                   ENDIF
      *
     C     SYVE17        IFNE      *BLANKS
     C                   MOVEL     SYVE17        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE17
     C                   ELSE
     C                   MOVE      *ON           *IN87
     C                   ENDIF
      *
     C     SYVE18        IFNE      *BLANKS
     C                   MOVEL     SYVE18        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE18
     C                   ELSE
     C                   MOVE      *ON           *IN88
     C                   ENDIF
      *
     C     SYVE19        IFNE      *BLANKS
     C                   MOVEL     SYVE19        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE19
     C                   ELSE
     C                   MOVE      *ON           *IN89
     C                   ENDIF
      *
     C     SYVE20        IFNE      *BLANKS
     C                   MOVEL     SYVE20        WKVEIN
     C                   EXSR      $BLDVE
     C                   MOVEL     WKVEOT        S1VE20
     C                   ELSE
     C                   MOVE      *ON           *IN90
     C                   ENDIF
      *
      *? Initial Screen load                             ?             ?
      *
     C                   MOVEL     #ESYS         USSYS
     C     #EUSID        IFNE      *BLANKS
     C                   MOVE      #EUSID        USUSID
     C     USKEY         CHAIN     USERR                              66
     C                   ENDIF
      *
     C     *IN66         IFEQ      *ON
     C     #EUSID        OREQ      *BLANKS
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
     C                   CLEAR                   #EUSID
     C                   Z-ADD     1             WKVIEW            1 0
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
     C     USKEY         CHAIN     USERR                              67
B002 C     *IN67         IFEQ      *OFF
     C     *NOKEY        CLEAR                   USERR
     C                   MOVE      YES           ERROR             3
     C                   MOVE      'SS01230'     $#MSID
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
      * User ID must be entered
      *****
     C     USUSID        IFEQ      *BLANKS
     C                   MOVE      YES           ERROR             3
     C                   MOVE      'SS01231'     $#MSID
     C                   EXSR      SRMSGF
     C                   MOVEA     '1'           *IN(31)
     C                   ENDIF
      *****
      * Options 1-10
      *****
B001 C                   DO        10            XX                2 0
     C                   MOVEA     VV(XX)        CKVENT           20
B002 C     CKVENT        IFNE      *BLANKS
     C                   MOVEA     VV(XX)        VE
     C                   MOVEA     EE(XX)        WKENT             1
     C                   CLEAR                   *IN99
     C                   Z-ADD     1             X
     C     WKENT         LOOKUP    VE(X)                                  99
B003 C     *IN99         IFEQ      '0'
     C     WKENT         OREQ      *BLANK
     C                   MOVE      YES           ERROR
     C                   MOVE      'SS01232'     $#MSID
     C                   MOVEL     TX(XX)        WKTEXT           20
     C                   MOVEL     WKTEXT        $#MSGD
     C                   EXSR      SRMSGF
     C     XX            ADD       40            IN                2 0
     C                   MOVEA     '1'           *IN(IN)
E003 C                   ENDIF
E002 C                   ENDIF
E001 C                   ENDDO
      *****
     C                   ENDIF
      *****
     CSR                 ENDSR
      ********************************************************************
      * ?$EDT02 - Check the input from screen 02                        ?*
      ********************************************************************
     CSR   $EDT02        BEGSR
      *****
      * Options 11-20
      *****
B001 C     11            DO        20            XX                2 0
     C                   MOVEA     VV(XX)        CKVENT           20
B002 C     CKVENT        IFNE      *BLANKS
     C                   MOVEA     VV(XX)        VE
     C                   MOVEA     EE(XX)        WKENT             1
     C                   CLEAR                   *IN99
     C                   Z-ADD     1             X
     C     WKENT         LOOKUP    VE(X)                                  99
B003 C     *IN99         IFEQ      '0'
     C     WKENT         OREQ      *BLANK
     C                   MOVE      YES           ERROR
     C                   MOVE      'SS01232'     $#MSID
     C                   MOVEL     TX(XX)        WKTEXT           20
     C                   MOVEL     WKTEXT        $#MSGD
     C                   EXSR      SRMSGF
     C     XX            ADD       40            IN                2 0
     C                   MOVEA     '1'           *IN(IN)
E003 C                   ENDIF
E002 C                   ENDIF
E001 C                   ENDDO
      *****
     CSR                 ENDSR
      *****************************************************************
      * ?$UPDAT - performs update on data file                      ? *
      *****************************************************************
     CSR   $UPDAT        BEGSR
      *
     C                   SELECT
     C     $$MODE        WHENEQ    'A'
     C                   WRITE     USERR
     C     $$MODE        WHENEQ    'U'
     C                   UPDATE    USERR
     C                   ENDSL
      *
     C                   MOVE      USUSID        #EUSID
     C                   MOVE      YES           ENDPGM
      *
     CSR                 ENDSR
      *****************************************************************
      * ?$BLDVE - Builds valid entries text                         ? *
      *****************************************************************
     CSR   $BLDVE        BEGSR
      *
     C                   MOVEA     WKVEIN        VE
     C                   CLEAR                   WKVEOT
      *
     C                   DO        20            X                 2 0
     C     VE(X)         IFNE      *BLANK
     C                   MOVE      VE(X)         WKVE              1
     C     WKVEOT        IFEQ      *BLANK
     C     '('           CAT       WKVE:0        WKVEOT           20
     C                   ELSE
     C                   CAT       '/':0         WKVEOT
     C                   CAT       WKVE:0        WKVEOT
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     WKVEOT        IFNE      *BLANK
     C                   CAT       ')':0         WKVEOT
     C                   ENDIF
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
