      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- GLR870
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- CONSOLIDATION OF GENERAL LEDGER DETAIL
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      * INDICATOR USAGE
      *    U1     PRINT REPORT
      *    U2     POST TO G/L
      *    U3     SELECTED APPLICATION
      *
     FFGLPRSAD  UF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFGLCTL    UF   E           K DISK
     FFGLDET    O  A E             DISK
     FFGLDCON   O  A E             DISK
     FGLR870    O    F  120        PRINTER OFLIND(*INOF)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      ****************
      *   LDA        *
      ****************
     D                UDS
      * COMPANY NUMBER
     D  LCO                  201    202  0                                      ARC380
      * POST G/L Y/N
     D  GLPST                203    203
      * PRINT REPORT Y/N (ONLY IF POST = N)
     D  PRTRPT               204    204
      * APPLICATION
     D  APPL                 205    207
      *
     IRGLPRE
     I              GTSTAT                      STATUS
     I              GTCOMP                      COMP
     I              GTACCT                      ACCT
     I              GTDOL$                      DOLLAR
     I              GTTDAT                      TRDATE
     I              GTSRCE                      SOURCE
     I              GTPROD                      PROD
     I              GTJEPR                      JEPR
     I              GTJENM                      JENM
     I              GTJESF                      JESF
     I              GTJEDS                      JEDS
     I              GTAPER                      APER
     I              GTDETT                      DETT
     I              GTPOST                      POST
     I              GTSRDS                      SRDS
     I              GTDTLA                      DTLA
     I              GTTIME                      TIM
     I              GTUSER                      USR
     I              GTSHFR                      SHFR
     I              GTAPPL                      IAPPL
     I              GTVEND                      OVEND
      *
      *
      *
     C                   Z-ADD     1             CNT               6 0
     C     LCO           SETLL     FGLPRSAD
      *
     C     NXT           TAG
     C                   SETOFF                                       8822
     C     LCO           READE     FGLPRSAD                               90
     C   90              GOTO      END
      *
     C     STATUS        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      * CHECK FOR ZERO DOLLARS
     C     DOLLAR        IFEQ      0
     C                   MOVEL     'D'           STATUS
     C                   DELETE    RGLPRE
     C                   GOTO      NXT
     C                   END
      *
     C     APPL          IFGT      *BLANKS
     C     APPL          ANDNE     IAPPL
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     CNT           IFEQ      1
     C                   GOTO      NL1
     C                   ENDIF
      *
     C     SOURCE        IFNE      OLSRCE
     C     ACCT          ORNE      OLACCT
     C     TRDATE        ORNE      OLDATE
     C     CNT           ANDNE     1
     C                   EXSR      GETGL
     C   U2              WRITE     RGLDET
     C   U1              EXCEPT    TL1
     C                   Z-ADD     *ZEROS        GLTOT
     C                   ENDIF
     C     NL1           TAG
      *
     C                   ADD       1             CNT
     C     GLKEY         KLIST
     C                   KFLD                    COMP
     C                   KFLD                    ACCT
     C     GLKEY         CHAIN     FMGLCH                             20
      *
     C  N20GCSTAT        IFEQ      'D'
     C                   SETON                                        21
     C                   ENDIF
      *
     C  N20GCCONF        IFEQ      'N'
     C                   SETON                                        22
     C                   EXSR      GETGL
     C   U2              WRITE     RGLDET
     C                   Z-ADD     1             CNT               6 0
     C                   MOVEL     'D'           STATUS
     C                   DELETE    RGLPRE
     C                   SETOFF                                       55
     C                   GOTO      NXT
     C                   ENDIF
      *
     C*  OF U1             DO
     C   OF
     CAN U1              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C**                   ENDDO
      *
     C   U1              EXCEPT    DETL
     C                   ADD       1             DCNT              8 0
      *
     C                   MOVEL     'D'           STATUS
     C                   DELETE    RGLPRE
     C                   Z-ADD     GTTDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        GTCYMD
     C                   Z-ADD     CON#          GTCON#
     C                   MOVEL     STATUS        GTSTAT
     C                   Z-ADD     COMP          GTCOMP
     C                   Z-ADD     ACCT          GTACCT
     C                   Z-ADD     DOLLAR        GTDOL$
     C                   Z-ADD     TRDATE        GTTDAT
     C                   MOVEL     SOURCE        GTSRCE
     C                   MOVEL     PROD          GTPROD
     C                   MOVEL     JEPR          GTJEPR
     C                   Z-ADD     JENM          GTJENM
     C                   MOVEL     JESF          GTJESF
     C                   MOVEL     JEDS          GTJEDS
     C                   Z-ADD     APER          GTAPER
     C                   MOVEL     DETT          GTDETT
     C                   MOVEL     POST          GTPOST
     C                   MOVEL     SRDS          GTSRDS
     C                   Z-ADD     DTLA          GTDTLA
     C                   Z-ADD     TIM           GTTIME
     C                   MOVEL     USR           GTUSER
     C                   MOVEL     SHFR          GTSHFR
     C                   Z-ADD     OVEND         GTVEND
     C                   MOVEL     IAPPL         GTAPPL
     C   U2              WRITE     RGLDCON
      *
     C                   MOVE      GCDESC        OLDESC           30
     C                   MOVE      TRDATE        OLDATE            6 0
     C                   Z-ADD     COMP          OLCOMP            2 0
     C                   Z-ADD     ACCT          OLACCT            8 0
     C                   ADD       DOLLAR        GLTOT            11 2
     C                   MOVE      SOURCE        OLSRCE            3
     C                   Z-ADD     APER          OLAPER            4 0
     C                   MOVEL     IAPPL         OAPPL             3
     C                   SETON                                        55        MID CONSOL
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C   55              DO
     C                   EXSR      GETGL
     C   U2              WRITE     RGLDET
     C   OF
     CAN U1              EXCEPT    HDG
     C   OF
     CAN U1              SETOFF                                       OF
     C   U1              EXCEPT    TL1
     C                   Z-ADD     *ZEROS        GLTOT
     C                   ENDDO
     C     GLTOT         IFNE      0
     C   OF
     CAN U1              EXCEPT    HDG
     C   OF
     CAN U1              SETOFF                                       OF
     C   U1              EXCEPT    TL1
     C                   ENDIF
     C     DCNT          IFEQ      0
     C   OF
     CAN U1              EXCEPT    HDG
     C   OF
     CAN U1              SETOFF                                       OF
     C   U1              EXCEPT    TLR
     C                   ENDIF
      ** END PROGRAM
     C                   SETOFF                                       U1U2
     C                   SETON                                        LR
      *
      *********
      * GETGL *
      *********
     C     GETGL         BEGSR
     C                   MOVEL     'A'           GTSTAT
     C   22              Z-ADD     COMP          GTCOMP
     C  N22              Z-ADD     OLCOMP        GTCOMP
     C   22              MOVEL     ACCT          GTACCT
     C  N22              MOVEL     OLACCT        GTACCT
     C   22              Z-ADD     DOLLAR        GTDOL$
     C  N22              Z-ADD     GLTOT         GTDOL$
     C   22              Z-ADD     TRDATE        GTTDAT
     C  N22              Z-ADD     OLDATE        GTTDAT
     C   22              Z-ADD     0             GTCON#
     C  N22              Z-ADD     CON#          GTCON#
     C                   Z-ADD     GTTDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        GTCYMD
     C   22              MOVEL     SHFR          GTSHFR
     C  N22              MOVE      *BLANKS       GTSHFR
     C   22              MOVEL     SOURCE        GTSRCE
     C  N22              MOVEL     OLSRCE        GTSRCE
     C                   MOVEL     *BLANKS       GTPROD
     C                   MOVEL     *BLANKS       GTJEPR
     C*                    Z-ADD*ZEROS    GTJENM
     C                   MOVEL     *BLANKS       GTJENM
     C                   MOVEL     *BLANKS       GTJESF
     C  N22              MOVEL     'Consolid'    JEDSA            16
     C  N22              MOVE      'ated    '    JEDSA
     C  N22              MOVEL     OLDATE        JEDSB            16
     C  N22              MOVE      CON#          JEDSC             8
     C  N22              MOVEL     '#'           JEDSC
     C  N22              MOVE      JEDSC         JEDSB
     C  N22              MOVEL     JEDSA         GTJEDS
     C  N22              MOVE      JEDSB         GTJEDS
     C   22              MOVE      JEDS          GTJEDS
     C   22              Z-ADD     APER          GTAPER
     C  N22              Z-ADD     OLAPER        GTAPER
     C   22              Z-ADD     OVEND         GTVEND
     C  N22              Z-ADD     0             GTVEND
     C   22              MOVEL     IAPPL         GTAPPL
     C  N22              MOVEL     OAPPL         GTAPPL
     C                   MOVEL     *BLANKS       GTDETT
     C                   MOVEL     *BLANKS       GTPOST
     C   22              MOVEL     SRDS          GTSRDS
     C  N22              MOVEL     GTJEDS        GTSRDS
     C                   Z-ADD     TIMOD         GTTIME
     C                   Z-ADD     TDATE         GTDTLA
     C                   MOVEL     USERID        GTUSER
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      ** GET COMPANY INFO
     C     LCO           CHAIN     FMCORG                             97
      *
     C     LCO           CHAIN     FGLCTL                             97
     C  N97              DO                                                                  NM
     C                   Z-ADD     GZCONS        CON#              6 0
     C                   ADD       1             GZCONS
     C                   UPDATE    RGLCTL
     C                   ENDDO
      ** GET PRINT/POST STATUS
     C                   SETOFF                                       U1U2U3
     C     GLPST         IFEQ      'Y'
     C                   SETON                                        U1U2
     C                   ELSE
     C     PRTRPT        IFEQ      'Y'
     C                   SETON                                        U1
     C                   END
     C                   END
      ** CHECK APPLICATION
     C     APPL          IFGT      *BLANKS
     C                   SETON                                        U3
     C                   END
     C                   SETON                                        OF
     C                   ENDSR
      *
     OGLR870    E            HDG            1 02
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           55 'General Ledger Detail Co'
     O                                           74 'nsolidation Listing'
     O                                           82 'Number:'
     O                       CON#          4     89
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           43 'Application:'
     O               U3      APPL                47
     O              NU3                          48 '*All'
     O          E            HDG            1
     O                                           84 'Trans'
     O                                           91 'SRC'
     O          E            HDG            1
     O                                           20 'G/L Acct#'
     O                                           47 'D E S C R I P T I O N'
     O                                           73 'Detail Dollars'
     O                                           83 'Date'
     O                                           91 'Ref'
     O          E            HDG            1
     O                                           34 '________________________'
     O                                           58 '________________________'
     O                                           82 '________________________'
     O                                           97 '_______________'
     O          EF           DETL        1  0
     O                       COMP                13
     O                       ACCT                23 '    -    '
     O                       JEDS                56
     O                       DOLLAR        J     74
     O                       TRDATE        Y     85
     O                       SOURCE              91
     O          EF           TL1         1  1
     O                                           74 '----------'
     O          EF           TL1            1
     O                       OLCOMP              13
     O                       OLACCT              23 '    -    '
     O                       OLDESC              56
     O                       GLTOT         J     74
     O                                           93 'Consolidated For:'
     O                       OLDATE        Y    102
     O          E            TLR            2
     O                                           60 '*** No Detail Records Co'
     O                                           83 'nsolidated This Run ***'
