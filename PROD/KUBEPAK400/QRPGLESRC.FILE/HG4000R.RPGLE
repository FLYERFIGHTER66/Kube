      *%*******************************************************************
      *%                                                                 **
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- Hard Goods Purchase Orders Inventory Processing **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- HG4000R                                                *
      *                                                                   *
      * Purpose?- Inventory Transaction Processing                       *
      *                                                                   *
      *   Date  ?Programmer    ? Comment                             ? *
      *  06/23/04  R. Piasecki      Program Created                       *
      *                                                                   *
      *%*******************************************************************
     FFMINVT    UF   E           K DISK
     FKPWHOUSE  IF   E           K DISK
     FKPITMWHS  UF A E           K DISK
     FKPHIST    O  A E           K DISK
     FHG4000S   CF   E             WORKSTN
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
     D                 DS
     D  DSDATE                 1      6  0
     D  DSMM                   1      2  0
     D  DSDD                   3      4  0
     D  DSYY                   5      6  0
     D                 DS
     D  DHCYMD                 1      8  0
     D  S2YMD                  3      8  0
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
     D GOOD            C                   CONST('GOOD')
     D @TRAN           C                   CONST(' WAREHOUSE TRANSFER ')
     D @OPEN           C                   CONST('  OPENING  BALANCE  ')
     D @ISSUE          C                   CONST('  ISSUE FROM STOCK  ')
     D @ADJUS          C                   CONST('INVENTORY ADJUSTMENT')
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
      *
     C                   WRITE     MSGCTL
     C                   EXFMT     SCREEN01
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN25
     C                   MOVE      *OFF          *IN70
     C                   CLEAR                   ERROR
      *
      *? Clear Messages                                   ?
      *
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
      *
      *? Select action                                   ?
     C                   SELECT
      *
      *? F3 pressed - end program                        ?
     C     *IN03         WHENEQ    *ON
     C                   MOVE      YES           ENDPGM            3
      *
     C                   OTHER
      *? Enter pressed - edit screen.
     C                   EXSR      $EDTS1
      *? If no errors, set up parameters
     C     ERROR         IFNE      YES
     C                   MOVE      *ON           *IN75
     C                   EXSR      $DSPLY
     C                   ENDIF
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   SETON                                        LR
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
     C                   MOVE      *DATE         YEAR              4 0
     C                   MOVEL     ##USER        DHUSER
      *
      *? Initialize values for message subfile            ?             ?
      *
     C                   MOVE      ##PGM         $#PGMQ           10            ?Pgm Msg Queue?
     C                   MOVEL     'KPMSGF'      $#MSGF           10            ?Msg File N/A ?
     C                   MOVEL     '*LIBL'       $#MSGL           10            ?Library  N/A ?
      * ?KLIST for ITEM MASTER File
      *
     C     IMKEY         KLIST
     C                   KFLD                    S1ITEM
     C                   KFLD                    S1SIZE
      * ?KLIST for ITEM/WAREHOUSE File
      *
     C     IWKEY         KLIST
     C                   KFLD                    S1ITEM
     C                   KFLD                    S1SIZE
     C                   KFLD                    DGWHSE
      *
      *
      * ?KLIST for WAREHOUSE MASTER File
      *
     C     WHKEY         KLIST
     C                   KFLD                    DGWHSE
      *
     C                   MOVE      '700'         S1SIZE                                     A ?
     C                   MOVE      01            S1WHSE                                     A ?
||X  C                   ENDSR
      ********************************************************************
VS02  *? $EDIT - Check the Input from Screen 1             ?
      ********************************************************************
     CSR   $EDTS1        BEGSR
      *****************************************************************
VS02  *? EDIT Transaction Type                            ?
      *****************************************************************
0051 C     S1TYPE        IFNE      'T'                                                         NORDT
0051 C     S1TYPE        IFNE      'O'                                                         NORDT
0051 C     S1TYPE        IFNE      'I'                                                         NORDT
0051 C     S1TYPE        IFNE      'A'                                                         NORDT
     C                   MOVE      *ON           *IN31
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'KP40001'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      END01
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
0051 C                   MOVE      S1TYPE        TYPSAV            1                           NORDT
      *****************************************************************
VS02  *? EDIT Item Number                                 ?
      *****************************************************************
0051 C                   Z-ADD     S1WHSE        DGWHSE            2 0                         NORDT
0051 C     IMKEY         CHAIN     FMINVT                             25                       NORDT
0051 C     *IN25         IFEQ      *ON                                                         NORDT
     C                   MOVE      YES           ERROR             3
0054 C                   MOVE      'KP40002'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      END01
     C                   ELSE
0051 C                   MOVE      S1SIZE        IWSIZE                                        NORDT
0054 C                   MOVEL     IMDES1        S1IDES                                        NORDT
0051 C     S1TYPE        IFEQ      'O'                                                         NORDT
0051 C     IWKEY         CHAIN     KPITMWHS                           81                       NORDT
     C     *IN81         IFEQ      *OFF
0051 C     IWQTOH        IFGT      *ZERO                                                       NORDT
     C                   MOVE      YES           ERROR             3
0054 C                   MOVE      'KP40009'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      END01
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *****************************************************************
VS02  *? EDIT Warehouse Number                            ?
      *****************************************************************
0051 C                   EXSR      EDTWHS                                                      NORDT
     C     ERROR         IFEQ      YES
     C                   MOVE      *ON           *IN70
     C                   GOTO      END01
     C                   ENDIF
0051 C                   MOVE      S1WHSE        WHSSAV            2 0                         NORDT
      *
0054 C                   CLEAR                   S2FBAL                                        NORDT
0051 C     S1TYPE        IFNE      'O'                                                         NORDT
0051 C     IWKEY         CHAIN     KPITMWHS                           81                       NORDT
     C     *IN81         IFEQ      *OFF
0054 C                   Z-ADD     IWQTOH        S2FBAL           11 0                         NORDT
     C                   ENDIF
     C*                    ELSE
     C     *IN81         IFEQ      *ON
     C                   MOVE      YES           ERROR
     C                   MOVE      *ON           *IN70
0054 C                   MOVE      'KP40008'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      END01
     C                   ENDIF
     C                   ENDIF
      *
0051 C     S1TYPE        IFEQ      'A'                                                         NORDT
     C     *IN81         IFEQ      *ON
     C                   MOVE      YES           ERROR
     C                   MOVE      *ON           *IN70
0054 C                   MOVE      'KP40011'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   ENDIF
      *
     C                   ENDIF
      *
     CSR   END01         ENDSR
      *
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
      ********************************************************************
      * ?$DSPLY - Display screens                                     *
      ********************************************************************
     C     $DSPLY        BEGSR
      *
     C     *ON           DOWEQ     *ON
      *****
      *? Display appropriate screen                                     ?
      *****
     C                   SELECT
     C     S1TYPE        WHENEQ    'T'
     C                   MOVEL     @TRAN         S2DESC
     C                   EXSR      $SC02
     C                   LEAVE
     C*
     C     S1TYPE        WHENEQ    'I'
     C                   MOVEL     @ISSUE        S2DESC
     C                   EXSR      $SC03
     C                   LEAVE
     C*
     C     S1TYPE        WHENEQ    'O'
     C                   MOVEL     @OPEN         S2DESC
     C                   EXSR      $SC04
     C                   LEAVE
     C*
     C     S1TYPE        WHENEQ    'A'
     C                   MOVEL     @ADJUS        S2DESC
     C                   EXSR      $SC05
     C                   LEAVE
     C*
     C                   ENDSL
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
VS02  *? EDIT Warehouse Number                            ?
      *****************************************************************
     C     EDTWHS        BEGSR
0051 C     WHKEY         CHAIN     KPWHOUSE                           80                       NORDT
0051 C     *IN80         IFEQ      *ON                                                         NORDT
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'KP40003'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   ENDIF
     C                   ENDSR
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
     C     WKDERR        IFEQ      'Y'
     C                   MOVE      YES           ERROR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *? Process Screen 2: Item Transfers
      *****************************************************************
     C     $SC02         BEGSR
     C     *ON           DOWEQ     *ON
     C                   WRITE     MSGCTL
     C                   EXFMT     SCREEN02
     C                   MOVEA     '0000'        *IN(71)
     C                   CLEAR                   ERROR
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
      *? F12, Return to SCREEN 1
     C     *IN12         IFEQ      *ON
     C                   CLEAR                   S2TWHS
     C                   CLEAR                   S2WNAM
     C                   CLEAR                   S2DTE4
     C                   CLEAR                   S2TQTY
     C                   LEAVE
     C                   ENDIF
      *? Edit Transfer Screen Input
     C                   EXSR      $EDTS2
     C     ERROR         IFEQ      YES
     C                   ITER
     C                   ELSE
     C                   EXSR      UPDATT
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
     C                   CLEAR                   S1TYPE
     C                   CLEAR                   S1ITEM
     C                   CLEAR                   S1WHSE
     C                   ENDSR
      *****************************************************************
      *? Process Screen 3: Item Issues
      *****************************************************************
     C     $SC03         BEGSR
     C     *ON           DOWEQ     *ON
     C                   WRITE     MSGCTL
     C                   EXFMT     SCREEN03
     C                   MOVEA     '0000'        *IN(71)
     C                   CLEAR                   ERROR
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
      *? F12, Return to SCREEN 1
     C     *IN12         IFEQ      *ON
     C                   CLEAR                   S2DTE
     C                   CLEAR                   S2TQTY
     C                   LEAVE
     C                   ENDIF
      *? Edit Issue Screen Input
     C                   EXSR      $EDTS3
     C     ERROR         IFEQ      YES
     C                   ITER
     C                   ELSE
     C                   EXSR      UPDATI
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
     C*                    CLEARS1TYPE
     C                   MOVE      TYPSAV        S1TYPE
     C                   CLEAR                   S1ITEM
     C*                    CLEARS1WHSE
     C                   MOVE      WHSSAV        S1WHSE
     C                   ENDSR
      *****************************************************************
      *? Process Screen 4: Opening Balance
      *****************************************************************
     C     $SC04         BEGSR
     C     *ON           DOWEQ     *ON
     C                   WRITE     MSGCTL
     C                   EXFMT     SCREEN04
     C                   MOVEA     '0000'        *IN(71)
     C                   CLEAR                   ERROR
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
      *? F12, Return to SCREEN 1
     C     *IN12         IFEQ      *ON
     C                   CLEAR                   S2DTE
     C                   CLEAR                   S2TQTY
     C                   LEAVE
     C                   ENDIF
      *? Edit Opening Balance Screen Input
     C                   EXSR      $EDTS4
     C     ERROR         IFEQ      YES
     C                   ITER
     C                   ELSE
     C                   EXSR      UPDATO
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
     C*                    CLEARS1TYPE
     C                   MOVE      TYPSAV        S1TYPE
     C                   CLEAR                   S1ITEM
     C*                    CLEARS1WHSE
     C                   MOVE      WHSSAV        S1WHSE
     C                   ENDSR
      *****************************************************************
      *? Process Screen 5: Item Adjustments
      *****************************************************************
     C     $SC05         BEGSR
     C     *ON           DOWEQ     *ON
     C                   WRITE     MSGCTL
     C                   EXFMT     SCREEN05
     C                   MOVEA     '0000'        *IN(71)
     C                   CLEAR                   ERROR
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
      *? F12, Return to SCREEN 1
     C     *IN12         IFEQ      *ON
     C                   CLEAR                   S2WNAM
     C                   CLEAR                   S2DTE4
     C                   CLEAR                   S2TQTY
     C                   LEAVE
     C                   ENDIF
      *? Edit Transfer Screen Input
     C                   EXSR      $EDTS5
     C     ERROR         IFEQ      YES
     C                   ITER
     C                   ELSE
     C                   EXSR      UPDATA
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
     C*                    CLEARS1TYPE
     C                   MOVE      TYPSAV        S1TYPE
     C                   CLEAR                   S1ITEM
     C*                    CLEARS1WHSE
     C                   MOVE      WHSSAV        S1WHSE
     C                   ENDSR
      *****************************************************************
      *? Edit Screen 2: Item Transfer Input
      *****************************************************************
     C     $EDTS2        BEGSR
     C     S2TWHS        IFEQ      S1WHSE
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'KP40004'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   ENDIF
     C     ERROR         IFNE      YES
0051 C                   Z-ADD     S2TWHS        DGWHSE            2 0                         NORDT
     C                   EXSR      EDTWHS
     C                   ENDIF
     C     ERROR         IFEQ      YES
     C                   MOVE      *ON           *IN73
     C                   GOTO      ENDS2
     C                   ELSE
0051 C                   MOVEL     WHWNAM        S2WNAM                                        NORDT
     C                   ENDIF
0051 C                   Z-ADD     S2DTE4        DSDATE                                        NORDT
     C                   EXSR      $CKDTE
     C     ERROR         IFEQ      YES
     C                   MOVE      *ON           *IN71
0054 C                   MOVE      'KP40005'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ENDS2
     C                   ENDIF
     C     S2TQTY        IFEQ      *ZERO
     C                   MOVE      *ON           *IN78
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'KP40006'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ENDS2
     C                   ENDIF
     C     S2TQTY        IFGT      S2FBAL
     C                   MOVE      *ON           *IN78
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'KP40007'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   ENDIF
     C     ENDS2         ENDSR
      *****************************************************************
      *? Edit Screen 3: Item Issue Input
      *****************************************************************
     C     $EDTS3        BEGSR
0051 C                   Z-ADD     S2DTE         DSDATE                                        NORDT
     C                   EXSR      $CKDTE
     C     ERROR         IFEQ      YES
     C                   MOVE      *ON           *IN71
0054 C                   MOVE      'KP40005'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ENDS3
     C                   ENDIF
     C     S2TQTY        IFEQ      *ZERO
     C                   MOVE      *ON           *IN78
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'KP40006'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ENDS3
     C                   ENDIF
     C     S2TQTY        IFGT      S2FBAL
     C                   MOVE      *ON           *IN78
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'KP40007'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   ENDIF
     C     ENDS3         ENDSR
      *****************************************************************
      *? Edit Screen 4: Opening Balance
      *****************************************************************
     C     $EDTS4        BEGSR
0051 C                   Z-ADD     S2DTE         DSDATE                                        NORDT
     C                   EXSR      $CKDTE
     C     ERROR         IFEQ      YES
     C                   MOVE      *ON           *IN71
0054 C                   MOVE      'KP40005'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ENDS4
     C                   ENDIF
     C     S2TQTY        IFEQ      *ZERO
     C                   MOVE      *ON           *IN78
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'KP40006'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ENDS4
     C                   ENDIF
     C     ENDS4         ENDSR
      *****************************************************************
      *? Edit Screen 5: Item Adjustment Input
      *****************************************************************
     C     $EDTS5        BEGSR
0051 C                   Z-ADD     S2DTE4        DSDATE                                        NORDT
     C                   EXSR      $CKDTE
     C     ERROR         IFEQ      YES
     C                   MOVE      *ON           *IN71
0054 C                   MOVE      'KP40005'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ENDS5
     C                   ENDIF
     C     S2TQTY        IFEQ      *ZERO
     C                   MOVE      *ON           *IN78
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'KP40006'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   GOTO      ENDS5
     C                   ENDIF
     C     S2TQTY        MULT      -1            S2WRK            11 0
     C                   SUB       S2WRK         S2FBAL
     C     S2FBAL        IFLT      *ZERO
     C                   MOVE      *ON           *IN78
     C                   MOVE      YES           ERROR
0054 C                   MOVE      'KP40010'     $#MSID                                        NORDT
     C                   EXSR      SRMSGF
     C                   ENDIF
     C     ENDS5         ENDSR
      *****************************************************************
      *? Update Transfer Information to Master Files
      *****************************************************************
     C     UPDATT        BEGSR
      *?   Clear F10 indicator                            ?             ?
      *
     C                   CLEAR                   *IN10
      *
      *
      *? Display the screen until F3, F10, or F12 pressed               ?
      *
     C     *IN10         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN
     C                   MOVE      'KPX1004'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   WRITE     MSGCTL
     C                   EXFMT     SCREEN02
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
E002 C                   ENDDO
      *
      *? Process changes if F10 pressed.                  ?             ?
      *
B002 C     *IN10         IFEQ      *ON
0051 C                   Z-ADD     S1WHSE        DGWHSE                                        NORDT
0051 C     IWKEY         CHAIN     KPITMWHS                           81                       NORDT
0051 C                   SUB       S2TQTY        IWQTOH                                        NORDT
0051 C                   UPDATE    ITMWHSR                                                     NORDT
0051 C                   MOVEL     S1SIZE        IWSIZE                                        NORDT
0051 C                   Z-ADD     S2TWHS        IWWHSE                                        NORDT
0051 C                   Z-ADD     S2TWHS        DGWHSE                                        NORDT
0051 C     IWKEY         CHAIN     KPITMWHS                           81                       NORDT
0051 C     *IN81         IFEQ      *ON                                                         NORDT
0051 C                   Z-ADD     S2TQTY        IWQTOH                                        NORDT
0051 C                   WRITE     ITMWHSR                                                     NORDT
0051 C                   UNLOCK    KPITMWHS                                                    NORDT
0051 C                   ELSE                                                                  NORDT
0051 C                   ADD       S2TQTY        IWQTOH                                        NORDT
0051 C                   UPDATE    ITMWHSR                                                     NORDT
0051 C                   UNLOCK    KPITMWHS                                                    NORDT
E002 C                   ENDIF
      *
E002 C     S2DTE4        MULT      10000.01      S2YMD             6 0
E002 C                   MOVEL     YEAR          DHCYMD
0051 C                   MOVEL     S1ITEM        DHPITM                                        NORDT
0051 C                   MOVEL     S1SIZE        DHPSIZ                                        NORDT
0051 C                   MOVEL     'T'           DHTRAN                                        NORDT
0051 C                   MOVEL     @TRAN         DHTYPE                                        NORDT
0051 C                   MOVEL     S1WHSE        DHFWHS                                        NORDT
0051 C                   MOVEL     S2TWHS        DHTWHS                                        NORDT
0051 C                   MOVEL     S2TQTY        DHTQTY                                        NORDT
0051 C                   WRITE     DGHISTR                                                     NORDT
E002 C                   ENDIF
     C                   CLEAR                   S2TWHS
     C                   CLEAR                   S2WNAM
     C                   CLEAR                   S2DTE4
     C                   CLEAR                   S2TQTY
      *
     C                   ENDSR
      *****************************************************************
      *? Update Issue Information to Master Files
      *****************************************************************
     C     UPDATI        BEGSR
      *?   Clear F10 indicator                            ?             ?
      *
     C                   CLEAR                   *IN10
      *
      *
      *? Display the screen until F3, F10, or F12 pressed               ?
      *
     C     *IN10         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN
     C                   MOVE      'KPX1005'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   WRITE     MSGCTL
     C                   EXFMT     SCREEN03
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
E002 C                   ENDDO
      *
      *? Process changes if F10 pressed.                  ?             ?
      *
B002 C     *IN10         IFEQ      *ON
0051 C                   Z-ADD     S1WHSE        DGWHSE                                        NORDT
0051 C     IWKEY         CHAIN     KPITMWHS                           81                       NORDT
0051 C                   SUB       S2TQTY        IWQTOH                                        NORDT
0051 C                   UPDATE    ITMWHSR                                                     NORDT
      *
E002 C     S2DTE         MULT      10000.01      S2YMD             6 0
E002 C                   MOVEL     YEAR          DHCYMD
0051 C                   MOVEL     S1ITEM        DHPITM                                        NORDT
0051 C                   MOVEL     S1SIZE        DHPSIZ                                        NORDT
0051 C                   MOVEL     'I'           DHTRAN                                        NORDT
0051 C                   MOVEL     @ISSUE        DHTYPE                                        NORDT
0051 C                   MOVEL     S1WHSE        DHFWHS                                        NORDT
0051 C                   Z-ADD     *ZERO         DHTWHS                                        NORDT
0051 C                   Z-SUB     S2TQTY        DHTQTY                                        NORDT
0051 C                   WRITE     DGHISTR                                                     NORDT
      *
0051 C     IMKEY         CHAIN     FMINVT                             82                       NORDT
 051 C     S2TQTY        MULT      -1            WRKQTY           11 0                         NORDT
 051 C                   ADD       WRKQTY        IMISSU                                        NORDT
 051 C                   SUB       S2TQTY        IMQTOH                                        NORDT
0051 C                   UPDATE    RMINVT                                                      NORDT
0051 C                   UNLOCK    FMINVT                                                      NORDT
E002 C                   ENDIF
     C                   CLEAR                   S2DTE
     C                   CLEAR                   S2TQTY
     C                   ENDSR
      *****************************************************************
      *? Update Opening Balance Information to Master Files
      *****************************************************************
     C     UPDATO        BEGSR
      *?   Clear F10 indicator                            ?             ?
      *
     C                   CLEAR                   *IN10
      *
      *
      *? Display the screen until F3, F10, or F12 pressed               ?
      *
     C     *IN10         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN
     C                   MOVE      'KPX1006'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   WRITE     MSGCTL
     C                   EXFMT     SCREEN04
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
E002 C                   ENDDO
      *
      *? Process changes if F10 pressed.                  ?             ?
      *
B002 C     *IN10         IFEQ      *ON
0051 C                   Z-ADD     S1WHSE        DGWHSE                                        NORDT
0051 C                   Z-ADD     S1WHSE        IWWHSE                                        NORDT
0051 C                   MOVE      S1SIZE        IWSIZE                                        NORDT
0051 C                   MOVEL     S1ITEM        IWPITM                                        NORDT
0051 C     IWKEY         CHAIN     KPITMWHS                           81                       NORDT
0051 C                   Z-ADD     S2TQTY        IWQTOH                                        NORDT
0051 C     *IN81         IFEQ      *ON                                                         NORDT
0051 C                   WRITE     ITMWHSR                                                     NORDT
0051 C                   UNLOCK    KPITMWHS                                                    NORDT
0051 C                   ELSE                                                                  NORDT
0051 C                   UPDATE    ITMWHSR                                                     NORDT
0051 C                   UNLOCK    KPITMWHS                                                    NORDT
0051 C                   ENDIF                                                                 NORDT
      *
E002 C     S2DTE         MULT      10000.01      S2YMD             6 0
E002 C                   MOVEL     YEAR          DHCYMD
0051 C                   MOVEL     S1ITEM        DHPITM                                        NORDT
0051 C                   MOVEL     S1SIZE        DHPSIZ                                        NORDT
0051 C                   MOVEL     'O'           DHTRAN                                        NORDT
0051 C                   MOVEL     @OPEN         DHTYPE                                        NORDT
0051 C                   MOVEL     S1WHSE        DHTWHS                                        NORDT
0051 C                   MOVE      '00'          DHFWHS                                        NORDT
0051 C                   Z-ADD     S2TQTY        DHTQTY                                        NORDT
0051 C                   Z-ADD     IMLCST        DHPPRC                                        NORDT
0051 C                   WRITE     DGHISTR                                                     NORDT
      *
0051 C     IMKEY         CHAIN     FMINVT                             82                       NORDT
 051 C                   ADD       S2TQTY        IMBPOH                                        NORDT
 051 C                   ADD       S2TQTY        IMQTOH                                        NORDT
0051 C                   UPDATE    RMINVT                                                      NORDT
0051 C                   UNLOCK    FMINVT                                                      NORDT
E002 C                   ENDIF
     C                   CLEAR                   S2DTE
     C                   CLEAR                   S2TQTY
     C                   ENDSR
      *****************************************************************
      *? Update Adjustment Information to Master Files
      *****************************************************************
     C     UPDATA        BEGSR
      *?   Clear F10 indicator                            ?             ?
      *
     C                   CLEAR                   *IN10
      *
      *
      *? Display the screen until F3, F10, or F12 pressed               ?
      *
     C     *IN10         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN
     C                   MOVE      'KPX1007'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   WRITE     MSGCTL
     C                   EXFMT     SCREEN05
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
E002 C                   ENDDO
      *
      *? Process changes if F10 pressed.                  ?             ?
      *
B002 C     *IN10         IFEQ      *ON
0051 C                   Z-ADD     S1WHSE        DGWHSE                                        NORDT
0051 C                   MOVEL     S1ITEM        IWPITM                                        NORDT
0051 C                   MOVE      S1SIZE        IWSIZE                                        NORDT
0051 C     IWKEY         CHAIN     KPITMWHS                           81                       NORDT
0051 C                   ADD       S2TQTY        IWQTOH                                        NORDT
B002 C     *IN81         IFEQ      *OFF
0051 C                   UPDATE    ITMWHSR                                                     NORDT
0051 C                   UNLOCK    KPITMWHS                                                    NORDT
0051 C                   ENDIF                                                                 NORDT
      *
E002 C     S2DTE4        MULT      10000.01      S2YMD             6 0
E002 C                   MOVEL     YEAR          DHCYMD
0051 C                   MOVEL     S1ITEM        DHPITM                                        NORDT
0051 C                   MOVEL     S1SIZE        DHPSIZ                                        NORDT
0051 C                   MOVEL     'A'           DHTRAN                                        NORDT
0051 C                   MOVEL     @ADJUS        DHTYPE                                        NORDT
0051 C                   MOVEL     '00'          DHFWHS                                        NORDT
0051 C                   MOVEL     S1WHSE        DHTWHS                                        NORDT
0051 C                   MOVEL     S2TQTY        DHTQTY                                        NORDT
0051 C                   WRITE     DGHISTR                                                     NORDT
      *
0051 C     IMKEY         CHAIN     FMINVT                             82                       NORDT
 051 C                   ADD       S2TQTY        IMMADJ                                        NORDT
 051 C                   ADD       S2TQTY        IMQTOH                                        NORDT
0051 C                   UPDATE    RMINVT                                                      NORDT
0051 C                   UNLOCK    FMINVT                                                      NORDT
E002 C                   ENDIF
     C                   CLEAR                   S2DTE4
     C                   CLEAR                   S2TQTY
      *
     C                   ENDSR
