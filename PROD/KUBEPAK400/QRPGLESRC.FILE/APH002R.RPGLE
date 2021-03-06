     F*%******************************************************************
     F*%                                                                **
     F*% Programmer: Rich Piasecki                   2/19/04            **
     F*%******************************************************************
     F********************************************************************
     F* ?                                                               ?*
     F* ?   APH002S - Enter Purge selections for                        ?*
     F* ?             Accounts Payable History File                     ?*
     F* ?                                                               ?*
     F* ?   CALLING MENU:  ????                                         ?*
     F* ?                                                               ?*
     F* ?   CALLING PROGRAM:  APH002CL                                  ?*
     F* ?                                                               ?*
     F* ?   FUNCTION:  This program will allow the user to enter        ?*
     F* ?              selection parameters to Purge the Accounts       ?*
     F* ?              Payable History File.                            ?*
     F* ?                                                               ?*
     F* ?   PROGRAMMER       - Richard E. Piasecki                      ?*
     F* ?   DATE WRITTEN     - 2/19/2004                                ?*
     F* ?                                                               ?*
     F********************************************************************
     FAPH002S   CF   E             WORKSTN
     F                                     INFDS(INFDS1)
     FFAPDTP    UF   E           K DISK
     FFAPDTPDT  IF   E           K DISK
     F                                     RENAME(RAPDTP:APHSL2)
     FPGAPHIST  O  A E           K DISK
     F                                     RENAME(RAPDTP:APHSPG)
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
     D*          IDS
     D*                                       1   70AHTDAT
     D*                                       1   30YEAR
      *                                                                 ?*
     D                 DS
     D  SBDATE                 1      8  0 INZ(0)
     D  WKCCYY                 1      4  0 INZ(0)
     D  M#                     5      6  0 INZ(0)
     D  WKDD                   7      8  0 INZ(0)
     D                 DS
     D  CUSDTE                 1     13  0
     D  ATCYMD                 1      7  0 INZ(0)
      ********************************************************************
      * ?Named Constants                                                ?*
      ********************************************************************
     D YES             C                   CONST('YES')
     D @ZRO20          C                   CONST('00000000000000000000')
      ********************************************************************
      ********************************************************************
      ******************  Program Main Line?  ***************************
      ********************************************************************
      ********************************************************************
      **
      *? Clear Message Subfile -- set function to send    ?             ?
      *
     C     ENDPGM        DOWNE     YES
      *
      *? Display screen
     C                   WRITE     MSGCTL
     C                   EXFMT     SCREEN01
     C                   MOVEA     @ZRO20        *IN(31)
     C                   MOVEA     @ZRO20        *IN(71)
     C                   CLEAR                   ERROR
      *
      *? Clear Message Subfile -- set function to send    ?             ?
      *
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
      *
      *? Select action                                   ?
     C                   SELECT
     C     *IN12         WHENEQ    *ON
     C                   MOVE      YES           ENDPGM            3
     C                   MOVE      '12'          @@FKEY
      *
     C                   OTHER
     C                   EXSR      $EDT01
      *
      *? If no errors, set up parameters and End Program
     C     ERROR         IFNE      YES
     C                   MOVE      YES           ENDPGM
     C                   ENDIF                                                  ?End if changes
      *
      *? Fill *Entry parms to pass back to CLP.
      *
     C                   CLEAR                   @@SBDT
     C                   CLEAR                   @@FKEY
      *
     C     *IN12         IFEQ      *OFF
     C                   MOVE      SBDATE        @@SBDT
     C                   ENDIF
      *
     C     *IN12         IFEQ      *ON
     C                   MOVE      '12'          @@FKEY
     C                   ENDIF
      *
      *
     C     *IN12         IFNE      *ON
     C                   EXSR      PURGE
     C                   ENDIF
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   SETON                                        LR
      *
      ********************************************************************
      * ?$EDT01 - Edit fields on SCREEN01                               ?*
      ********************************************************************
     CSR   $EDT01        BEGSR
      *
     C                   CLEAR                   S1DS02
      *
      *? Sell By Date
      *
     C                   Z-ADD     S1SBDT        DSDATE
     C                   EXSR      $CKDTE
     C     WKDERR        IFEQ      'Y'
     C                   MOVE      '1'           *IN33
     C                   MOVEL     'APH0021'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      YES           ERROR             3
     C                   GOTO      END01
     C                   ELSE
     C                   EXSR      $ALDTE
     C                   MOVEL     WKALDT        S1DS02
     C                   ENDIF
      *
      *
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
      *****************************************************************
      * ?PURGE  - Purges A/R History File of Older Records All Cust   *
      *****************************************************************
     CSR   PURGE         BEGSR
      ********************************************************************
     C                   MOVE      SBDATE        YYMMDD            6 0
     C*          YYMMDD    MULT 10000.01  YYMMDD  60
     C                   Z-ADD     YYMMDD        WKDATE            7 0
     C     WKCCYY        IFGE      1995
     C     WKCCYY        ANDLT     2000
     C                   MOVEL     0             WKDATE
     C                   ELSE
     C                   MOVEL     1             WKDATE
     C                   ENDIF
      *
      *
     C     DATEKY        SETLL     FAPDTPDT
     C                   DO        99999999
     C                   READP     FAPDTPDT                               66
      *
     C     *IN66         IFEQ      *ON
     C                   LEAVE
     C                   ELSE
      *
     C     PGKEY         CHAIN     FAPDTP                             65
     C                   WRITE     APHSPG
     C                   DELETE    RAPDTP
     C                   ENDIF
     C                   ENDDO
      *
     CSR                 ENDSR
      ********************************************************************
      * ?INIT - Program Initialization and Housekeeping                 ?*
      ********************************************************************
     CSR   *INZSR        BEGSR
      *
      *? *ENTRY Parms
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@SBDT            8
     C                   PARM                    @@FKEY            2
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
     C     DATEKY        KLIST
     C                   KFLD                    COMP
     C                   KFLD                    WKDATE
     C                   MOVE      '01'          COMP              2 0
      *
      *
     C     PGKEY         KLIST
     C                   KFLD                    ATVEND
     C                   KFLD                    ATCOMP
     C                   KFLD                    ATCYMD
     C                   KFLD                    ATVOUC
     C                   KFLD                    ATINV#
      *
      *
      *
      * ?KLIST for Serial Numbers File
      *
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
