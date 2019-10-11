     F*%******************************************************************
     F*%                                                                **
     F*%                                                                **
     F*%                                                                **
     F*%******************************************************************
     F********************************************************************
     F* ?                                                               ?*
     F* ?   KP4010R - Enter report selections for                       ?*
     F* ?             Transaction Edit Detail Report                    ?*
     F* ?                                                               ?*
     F* ?                                                               ?*
     F* ?                                                               ?*
     F* ?   PROGRAMMER       - Richard E. Piasecki                      ?*
     F* ?   DATE WRITTEN     - 06/24/2004                               ?*
     F* ?                                                               ?*
     F********************************************************************
     FHG4010S   CF   E             WORKSTN
     F                                     INFDS(INFDS1)
     FPRTTABL   IF   E           K DISK
     F*
     D MDS             S              9    DIM(12) CTDATA PERRCD(1)
      ********************************************************************
      * ?File Information Data Structure                                ?*
      ********************************************************************
     D INFDS1          DS
      *   Display File name (internal RPG name)
     D  $1FILN           *FILE
      *   Record format ID for last record input
     D  $1RCDF           *RECORD
      *   AID byte: identifies which function key was pressed:
     D  $1AID                369    369
      *   Current Cursor row and column (Binary)
     D  $1CURP               370    371B 0
      *    Low Relative Record # on SFLPAG
     D  PAGRRN               378    379B 0
      *    Relative Record # of Last Changed Record in SFLRCD
     D  $1RRN#               397    400B 0
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
      * ?Define message id field for XAMSFC                             ?*
      ********************************************************************
     D                 DS
     D  $#MSID                 1      7
     D  $#MPFX                 1      3
     D  $#MSEQ                 4      7
      *
      ********************************************************************
      * ?Breakdown of Date field                                        ?*
      ********************************************************************
      *                                                                 ?*
     D                 DS                  INZ
     D  DSDATE                 1      6  0
     D  DSMM                   1      2  0
     D  DSDD                   3      4  0
     D  DSYY                   5      6  0
      *                                                                 ?*
     D                 DS
     D  SBDATE                 1      8  0 INZ(0)
     D  WKCCYY                 1      4  0 INZ(0)
     D  M#                     5      6  0
     D  WKDD                   7      8  0
      ********************************************************************
      * ?Named Constants                                                ?*
      ********************************************************************
     D @ZRO20          C                   CONST('00000000000000000000')
      ********************************************************************
      ********************************************************************
      ******************  Program Main Line?  ***************************
      ********************************************************************
      ********************************************************************
      **
      *? Clear Message Subfile -- set function to send    ?             ?
      *
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
      *
     C                   MOVE      'N'           #EXIT             1
      *
     C     #EXIT         DOUEQ     'Y'
      *
      *? Display screen
     C                   WRITE     MSGCTL
     C                   EXFMT     SCREEN01
     C                   MOVEA     @ZRO20        *IN(31)
     C                   MOVE      'Y'           #EXIT
      *
      *? Clear Message Subfile -- set function to send    ?             ?
      *
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
      *
     C     *IN03         IFEQ      *OFF
     C                   EXSR      $EDT01
      *
      *? Redisplay if changes were made
      *
     C     *IN28         IFEQ      *ON                                          ?If changes made
     C     #EXIT         IFEQ      'Y'                                          ?|If no errors found
     C                   MOVEL     'SR00022'     $#MSID                         ?|||"Press enter to
     C                   EXSR      SRMSGF                                       ?|||  edit"
     C                   ENDIF                                                  ?|End if no errors
     C                   MOVE      'N'           #EXIT                          ?|Don't exit
     C                   ENDIF                                                  ?End if changes
      *
     C                   ENDIF
     C                   ENDDO
      *
      *? Fill *Entry parms to pass back to CLP.
      *
     C                   CLEAR                   @@USER
     C                   CLEAR                   @@FRDT
     C                   CLEAR                   @@TODT
     C                   CLEAR                   @@OUTQ
     C                   CLEAR                   @@FKEY
      *
     C     *IN03         IFEQ      *OFF
     C                   MOVE      S1USER        @@USER
     C                   MOVE      FRDTE         @@FRDT
     C                   MOVE      TODTE         @@TODT
     C                   MOVEL     S1OUTQ        @@OUTQ
     C                   ENDIF
      *
     C     *IN03         IFEQ      *ON
     C                   MOVE      '03'          @@FKEY
     C                   ENDIF
      *
     C                   MOVE      *ON           *INLR
      *
      ********************************************************************
      * ?$EDT01 - Edit fields on SCREEN01                               ?*
      ********************************************************************
     CSR   $EDT01        BEGSR
      *
     C                   CLEAR                   S1FRDS
     C                   CLEAR                   S1TODS
      *
      *? From Date must be entered and valid
      *
     C     S1FRDT        IFEQ      *ZEROS
     C                   MOVEA     '1'           *IN(31)
     C                   MOVEL     'SR00018'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      'N'           #EXIT
     C                   GOTO      END01
     C                   ENDIF
      *
      *? From Date
      *
     C     S1FRDT        IFGT      *ZEROS
     C                   Z-ADD     S1FRDT        DSDATE
     C                   EXSR      $CKDTE
     C     WKDERR        IFEQ      'Y'
     C                   MOVE      '1'           *IN31
     C                   MOVEL     'SR00019'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      'N'           #EXIT
     C                   GOTO      END01
     C                   ELSE
     C                   EXSR      $ALDTE
     C                   MOVEL     WKALDT        S1FRDS
     C                   Z-ADD     SBDATE        FRDTE             8 0
     C                   ENDIF
     C                   ENDIF
      *
      *
      *? To Date must be entered and valid
      *
     C     S1TODT        IFEQ      *ZEROS
     C                   MOVEA     '1'           *IN(32)
     C                   MOVEL     'SR00018'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      'N'           #EXIT
     C                   GOTO      END01
     C                   ENDIF
      *
      *? To Date
      *
     C     S1TODT        IFGT      *ZEROS
     C                   Z-ADD     S1TODT        DSDATE
     C                   EXSR      $CKDTE
     C     WKDERR        IFEQ      'Y'
     C                   MOVE      '1'           *IN32
     C                   MOVEL     'SR00020'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      'N'           #EXIT
     C                   GOTO      END01
     C                   ELSE
     C                   EXSR      $ALDTE
     C                   MOVEL     WKALDT        S1TODS
     C                   Z-ADD     SBDATE        TODTE             8 0
     C                   ENDIF
     C                   ENDIF
      *
      *
      *? From Date cannot be greater than to date
      *
     C     FRDTE         IFGT      TODTE
     C                   MOVE      '11'          *IN31
     C                   MOVEL     'SR00021'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      'N'           #EXIT
     C                   GOTO      END01
     C                   ENDIF
      *****
      * ?Printer Code Must be Valid                                     ?*
      *****
||    *
     C                   MOVE      *OFF          *IN74                          ?Inactive     ?
||1  C     S1OUTQ        IFEQ      '?'
||   C                   EXSR      $PPRMT
||If C                   END
      *
||1  C     PRTKEY        CHAIN     PRTTABL                            74
||1  C     *IN74         IFEQ      *ON
     C                   MOVE      '1'           *IN33
     C                   MOVEL     'SS99998'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      'N'           #EXIT
     C                   GOTO      END01
     C                   ENDIF
      *
     C     S1OUTQ        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN74                          ?Inactive     ?
||1  C     *IN74         IFEQ      *ON
     C                   MOVE      '1'           *IN33
     C                   MOVEL     'SS99998'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      'N'           #EXIT
     C                   ENDIF
     C                   ENDIF
     C     END01         ENDSR
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
      * ?$ALDTE - Converts date to alpha format                     ? *
      *****************************************************************
     CSR   $ALDTE        BEGSR
      *
      * ?Put month name in alpha field
      *
     C                   Z-ADD     DSMM          M#                2 0
     C                   MOVEL(P)  MDS(M#)       WKALDT           30
     C                   MOVE      DSDD          WKDD              2 0
      *
      * ?Put day of month in alpha field
      *
     C     DSDD          IFLE      9
     C                   MOVE      DSDD          WKD1              1
     C                   CAT       WKD1:1        WKALDT
     C                   ELSE
     C                   MOVE      DSDD          WKD2              2
     C                   CAT       WKD2:1        WKALDT
     C                   ENDIF
      *
      * ?Put century in alpha field
      *
     C                   CAT       ',':0         WKALDT
     C     DSYY          IFGT      95
     C                   CAT       '19':1        WKALDT
     C                   MOVEL     19            WKCCYY
     C                   ELSE
     C                   CAT       '20':1        WKALDT
     C                   MOVEL     20            WKCCYY
     C                   ENDIF
      *
      * ?Put year in alpha field
      *
     C                   MOVE      DSYY          WKYY              2
     C                   MOVE      DSYY          WKCCYY            4 0
     C                   CAT       WKYY:0        WKALDT
      *
     C                   ENDSR
      ********************************************************************
      * ?INIT - Program Initialization and Housekeeping                 ?*
      ********************************************************************
     CSR   *INZSR        BEGSR
      *
      *? *ENTRY Parms
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@USER           10
     C                   PARM                    @@FRDT            8
     C                   PARM                    @@TODT            8
     C                   PARM                    @@OUTQ           10
     C                   PARM                    @@FKEY            2
      * ?KLIST for Printer  file
      *
     C     PRTKEY        KLIST
     C                   KFLD                    S1OUTQ
      *
      *
      *? Open files
      *
      *
      *? Initialize values for message subfile            ?             ?
      *
     C                   MOVE      ##PGM         $#PGMQ           10            ?Pgm Msg Queue?
     C                   MOVEL     'KPMSGF'      $#MSGF           10            ?Msg File N/A ?
     C                   MOVEL     '*LIBL'       $#MSGL           10            ?Library  N/A ?
     C                   MOVE      '*******'     $#MSID                         ?Message Id   ?
      *
      *? Clear Message Subfile -- set function to send    ?             ?
      *
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
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
     C                   PARM                    $#PGMQ           10            Pgm Msg Queue
     C                   PARM                    $#MSGF           10            Message File
     C                   PARM                    $#MSGL           10            Library
     C                   PARM                    $#MSID            7            Message Id
     C                   PARM                    $#MSGD           80            Message Data
     C                   PARM                    $#MSKY            4            Message Key
     C                   PARM                    $#MSFN            1            Send or Clear
      *
      *? Call Msg processing CL                           ?
      *
     C                   CALL      'XAMSFC'      PLMSGF
      *
     C                   ENDSR
      *
      *****************************************************************
      * ?$PPRMT - Handles F4 prompt function                       ? *
      *****************************************************************
     CSR   $PPRMT        BEGSR
      *
     C                   SELECT
      *
      *? Printer ID
      *
     C     ##RCD         WHENEQ    'SCREEN01'
     C     S1OUTQ        ANDEQ     '?'
     C                   CLEAR                   @PELM#
     C                   MOVE      'I'           INQ               1
     C                   CALL      'PRTTABLR'
     C                   PARM                    @PELM#           10
     C                   PARM                    INQ
     C     @PELM#        IFNE      *BLANKS
     C                   MOVEL     @PELM#        S1OUTQ
     C                   ENDIF
      *
     C*                    OTHER
     C*                    MOVE *ON       *IN74
     C                   ENDSL
      *
     C                   ENDSR
** MDS - Month descriptions
January
February
March
April
May
June
July
August
September
October
November
December
