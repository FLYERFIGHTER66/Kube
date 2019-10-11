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
      *PROGRAM NAME-------- ARR500
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- MONTHLY PURGE OF A/R OPEN FILE.
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * MJT01 08/23/01 OUTPUT NEW FIELDS FROM FAROPEN TO FARHIST
      *
      *
     FFARSEL    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
RPADDFFARLCD    UF   E           K DISK
RPADDFFARLC     UF   E           K DISK
     FFAROPN    UF   E           K DISK
     FFARCTL    UF   E           K DISK
     FFARHIST   O  A E           K DISK
     FARR500    O    F  120        PRINTER OFLIND(*INOF)
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
      *
     D                UDS
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LADD                   9      9
     D  LPRINT                10     10
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
RPADDD                 DS
RPADDD  LCDATE                 1      7  0
RPADDD  YYMM                   2      5  0
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   UNLOCK    FARCTL
      *
     C     LPRINT        IFEQ      'Y'
     C                   SETON                                        77
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCORG                             88
     C   77              EXCEPT    HDG
      *
      * Y = ADD PURGED RECORDS TO ARHIST
      *
     C     LADD          IFEQ      'Y'
     C                   SETON                                        50
     C                   ENDIF
      *
     C     NXT           TAG
     C                   READ      FARSEL                                 90
     C   90              GOTO      END
      *
     C     ARKEY         KLIST
     C                   KFLD                    PICUST
     C                   KFLD                    PIINV#
     C                   KFLD                    PISUFF
      *
     C     ARKEY         SETLL     FAROPN
     C     NXTAR         TAG
     C                   SETOFF                                       30
     C     ARKEY         READE     FAROPN                                 91
     C  N91              DO
      *
     C     ARSTAT        IFNE      'A'
RPADDC     ARSTAT        IFNE      'L'
     C                   GOTO      NXTAR
     C                   ENDIF
     C                   ENDIF
      *
     C     ARCUST        CHAIN     FMCUST                             20
     C     ARTTYP        IFEQ      01
     C     ARTTYP        OREQ      05
     C     ARTTYP        OREQ      07
     C                   SETON                                        10
     C                   ENDIF
      *
     C   50              EXSR      UHIST
RPADDC     ARSTAT        IFEQ      'L'
RPADDC     ARDUE$        ANDEQ     *ZEROS
RPADDC                   Z-ADD     ARDUDT        LCDATE
RPADDC     LCKEY         CHAIN     FARLCD                             98
RPADDC     *IN98         IFEQ      *OFF
RPADDC                   DELETE    RARLCD
RPADDC                   ENDIF
RPADDC     LDKEY         CHAIN     FARLC                              97
RPADDC     *IN97         IFEQ      *OFF
RPADDC                   DELETE    RARLC
RPADDC                   ENDIF
RPADDC                   ENDIF
     C                   DELETE    RAROPN
      *
     C   OF
     CAN 77              EXCEPT    HDG
     C   OF
     CAN 77              SETOFF                                       OF
      *
     C     ARSUFF        IFGT      *BLANKS
     C                   SETON                                        30
     C                   ENDIF
      *
     C                   Z-ADD     ARTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TDAT              6 0
      *
     C                   Z-ADD     ARDUDT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         DDAT              6 0
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
     C   77              EXCEPT    DETL
     C                   ADD       1             CNT               6 0
     C                   GOTO      NXTAR
     C                   ENDDO
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C     CNT           IFEQ      0
     C                   EXCEPT    TNO
     C                   ENDIF
     C     CNT           IFNE      0
     C                   EXCEPT    TLR
     C     LCO           CHAIN     FARCTL                             90
     C                   Z-ADD     LDATE         ACDTPR
     C                   UPDATE    RARCTL
     C                   ENDIF
     C                   SETON                                        LR
      *
      ********
      * UHIST
      ********
     C     UHIST         BEGSR
      *
     C                   MOVEL     ARSTAT        AHSTAT
RPADDC     ARSTAT        IFEQ      'L'
RPADDC                   MOVE      'A'           AHSTAT
RPADDC                   ENDIF
     C                   Z-ADD     ARCUST        AHCUST
     C                   Z-ADD     ARINV#        AHINV#
     C                   MOVEL     ARSUFF        AHSUFF
     C                   Z-ADD     ARSEQ#        AHSEQ#
     C                   MOVEL     ARCTYP        AHCTYP
     C                   MOVEL     ARSLM1        AHSLM1
     C                   MOVEL     ARSLM2        AHSLM2
     C                   Z-ADD     ARCOM1        AHCOM1
     C                   Z-ADD     ARCOM2        AHCOM2
     C                   MOVEL     ARTERR        AHTERR
     C                   Z-ADD     ARCOMP        AHCOMP
     C                   Z-ADD     ARTTYP        AHTTYP
     C                   Z-ADD     ARTDAT        AHTDAT
     C                   Z-ADD     ARDUDT        AHDUDT
     C                   Z-ADD     AR$AMT        AH$AMT
     C                   Z-ADD     ARDISC        AHDISC
     C                   Z-ADD     ARDTAK        AHDTAK
     C                   Z-ADD     ARADJ$        AHADJ$
     C                   Z-ADD     ARPAID        AHPAID
     C                   Z-ADD     ARDUE$        AHDUE$
     C                   MOVEL     ARCHEK        AHCHEK
     C                   Z-ADD     ARCKDT        AHCKDT
     C                   Z-ADD     ARGLAC        AHGLAC
     C                   MOVEL     ARDESC        AHDESC
     C                   Z-ADD     TDATE         AHDTLA
     C                   Z-ADD     TIMOD         AHTIME
     C                   MOVEL     USERID        AHUSER
     C                   Z-ADD     ARDCDT        AHDCDT
     C                   Z-ADD     ARORD#        AHORD#
     C                   Z-ADD     ARSHCU        AHSHCU
     C                   Z-ADD     ARSACU        AHSACU
     C                   Z-ADD     ARBLCU        AHBLCU
     C                   MOVEL     ARLOOK        AHLOOK
     C                   MOVEL     ARPONO        AHPONO
     C                   MOVEL     ARCRCD        AHCRCD
     C                   Z-ADD     ARCRC#        AHCRC#
     C                   Z-ADD     ARCRCE        AHCRCE
     C                   MOVEL     ARCRCA        AHCRCA
MJT01C                   MOVE      ARBKCD        AHBKCD
MJT01C                   Z-ADD     ARSINV        AHSINV
MJT01C                   MOVE      ARSSUF        AHSSUF
     C                   WRITE     RARHIS
     C                   ENDSR
RPADDCSR   *INZSR        BEGSR
RPADD *
RPADD * Define Key Lists ?
RPADD *
RPADD *
RPADDC     LCKEY         KLIST
RPADDC                   KFLD                    ARCUST
RPADDC                   KFLD                    ARINV#
RPADDC                   KFLD                    SUFF
RPADDC                   KFLD                    YYMM
RPADDC     LDKEY         KLIST
RPADDC                   KFLD                    ARCUST
RPADDC                   KFLD                    ARINV#
RPADDC                   KFLD                    SUFF
RPADDC                   Z-ADD     1             SEQ               3 0
RPADDC                   MOVE      *BLANKS       SUFF              2
RPADDC                   ENDSR
     OARR500    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                                          114 'Page:'
     O                       PAGE          1    120
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           64 'A/R Paid Item Removal Re'
     O                                           79 'ference Listing'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           65 'For Items Dated On Or Be'
     O                                           70 'fore:'
     O                       LDATE         Y     79
     O          E            HDG            1
     O                                            6 'Cust.'
     O                                           50 'Reference'
     O                                           59 'Trans'
     O                                           67 'Due'
     O                                           96 'Check'
     O          E            HDG            1
     O                                            7 'Number'
     O                                           20 'N  A  M  E'
     O                                           48 'Number'
     O                                           58 'Date'
     O                                           68 'Date'
     O                                           86 'Invoice Amount'
     O                                           97 'Number'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          100 '____'
     O          E            DETL           1
     O                       ARCUST        Z      7
     O                       CMNAME              39
     O                       ARINV#        Z     47
     O               30                          48 '-'
     O                       ARSUFF              50
     O                       TDAT          Y     60
     O                  10   DDAT          Y     70
     O                       AR$AMT        J     87
     O                 N10   ARCHEK              99
     O          E            TNO            1
     O                                           72 '*** No Items Purged ***'
     O          E            TLR            1
     O                                           51 '*** These Records Were '
     O                  50                       75 'Added To A/R History ***'
     O                 N50                       75 'NOT Added To A/R History'
     O                 N50                       79 '***'
