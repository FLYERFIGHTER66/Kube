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
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR040
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- COMPANY DEFAULTS FILE MAINTENANCE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR040FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMCDEF    UF A E           K DISK
     FFMCORG    IF   E           K DISK
     FFMSLSM    IF   E           K DISK
     FFMTERR    IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FFMSVIA    IF   E           K DISK
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
      *       ************************************
      *       *      PROGRAM MAINLINE            *
      *       ************************************
      *
     C     RSTRTA        TAG
     C                   EXSR      CLRIT
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131416
     C                   SETOFF                                       202122
     C                   SETOFF                                       2324
     C                   SETOFF                                       17
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C     VACTOK        TAG
      *
     C     VCO           IFEQ      0                                                        K
     C                   SETON                                        2021
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VCO           CHAIN(N)  FMCORG                             96
     C   96              SETON                                        2021
     C   21              GOTO      RSTRTA
      *
     C     VCO           CHAIN     FMCDEF                             90
      *
     C  N90VACT          IFEQ      'A'
     C                   SETON                                        2022
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C   90VACT          IFNE      'A'
     C                   SETON                                        2023
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        16
     C                   ENDIF
      *
     C   16
     CANN96              SETON                                        2024
     C   24              GOTO      RSTRTA
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       202122
     C                   SETOFF                                       232425
     C                   SETOFF                                       262728
     C                   SETOFF                                       293031
     C                   SETOFF                                       323334
     C                   SETOFF                                       353637
     C                   SETOFF                                       383940
     C                   SETOFF                                       419899
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
      *
     C     1             SUBST     CDTMCD:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     CDTMCD        TCTERM            2
     C                   CALL      'LKTERM'
     C                   PARM                    TCTERM
     C                   PARM                    TCDESC           30
     C                   MOVEL     *BLANKS       CDTMCD
     C                   MOVEL     *BLANKS       VTST
     C                   MOVEL     TCTERM        CDTMCD
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     KEYT          KLIST
     C                   KFLD                    CDTMCD
     C     KEYT          CHAIN     FMTERM                             96
     C   96              SETON                                        20
     C   20              GOTO      RSTRTB
      *
      * PRICE CODE
      *
     C     CDPRCD        IFLT      1
     C     CDPRCD        ORGT      5
     C                   SETON                                        21
     C   21              GOTO      RSTRTB
     C                   ENDIF
      *
      * CONTRACT PRICE
      *
     C     CDCTCD        IFNE      'Y'
     C     CDCTCD        ANDNE     'N'
     C                   SETON                                        22
     C   22              GOTO      RSTRTB
     C                   ENDIF
      *
      * MARK UP PRICE
      *
     C     CDMRKP        IFNE      'Y'
     C     CDMRKP        ANDNE     'N'
     C                   SETON                                        23
     C   23              GOTO      RSTRTB
     C                   ENDIF
      *
      * SHIP VIA
      *
     C     1             SUBST     CDSVIA:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     CDSVIA        SVCODE            2
     C                   CALL      'LKSVIA'
     C                   PARM                    SVCODE
     C                   PARM                    SVDESC           30
     C                   MOVEL     *BLANKS       CDSVIA
     C                   MOVEL     *BLANKS       VTST
     C                   MOVEL     SVCODE        CDSVIA
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     CDSVIA        IFEQ      *BLANKS
     C                   SETON                                        24
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      * VALIDATE SHIP VIA CODE
      *
     C     CKEYS         KLIST
     C                   KFLD                    CDSVIA
     C     CKEYS         CHAIN     FMSVIA                             96
     C   96              SETON                                        24
     C   24              GOTO      RSTRTB
      *
      * VALIDATE BACK ORDERS Y/N
      *
     C     CDBOOK        IFNE      'Y'
     C     CDBOOK        ANDNE     'N'
     C                   SETON                                        25
     C   25              GOTO      RSTRTB
     C                   ENDIF
      *
      * VALIDATE SALESPERSON
      *
     C     1             SUBST     CDSLSM:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     CDSLSM        SMSLSM            2
     C                   CALL      'LKSALE'
     C                   PARM                    SMSLSM
     C                   PARM                    SMNAME           30
     C                   MOVEL     *BLANKS       CDSLSM
     C                   MOVEL     SMSLSM        CDSLSM
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      * TEST SALESPERSON CODE
      *
     C     CDSLSM        IFEQ      *BLANKS
     C                   SETON                                        26
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   MOVEL     CDSLSM        SMSLSM            2
     C     KEYL          KLIST
     C                   KFLD                    SMSLSM
     C     KEYL          CHAIN     FMSLSM                             90
     C   90              SETON                                        26
     C   26              GOTO      RSTRTB
      *
      *  CASH/CHECK FLAG
      *
     C     CDCODF        IFNE      'N'
     C     CDCODF        ANDNE     'C'
     C     CDCODF        ANDNE     'K'
     C                   SETON                                        27
     C   27              GOTO      RSTRTB
     C                   ENDIF
      *
      * TERRITORY
      *
     C     1             SUBST     CDTERR:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     CDTERR        TETERR            2
     C                   CALL      'LKTERR'
     C                   PARM                    TETERR
     C                   PARM                    TEDESC           30
     C                   MOVEL     *BLANKS       CDTERR
     C                   MOVEL     TETERR        CDTERR
     C                   SETON                                        99
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      * VALIDATE TERRITORY CODE
      *
     C     CDTERR        CHAIN(N)  FMTERR                             96
     C   96              SETON                                        28
     C   28              GOTO      RSTRTB
      *
      * VALIDATE QTY DISCOUNT Y/N
      *
     C     CDQDIS        IFNE      'Y'
     C     CDQDIS        ANDNE     'N'
     C                   SETON                                        29
     C   29              GOTO      RSTRTB
     C                   ENDIF
      *
      * VALIDATE TAX EXEMPT  Y/N
      *
     C     CDTXST        IFNE      'Y'
     C     CDTXST        ANDNE     'N'
     C                   SETON                                        30
     C   30              GOTO      RSTRTB
     C                   ENDIF
      *
      * VALIDATE STATE TAXABLE  Y/N
      *
     C     CDTCD1        IFNE      'Y'
     C     CDTCD1        ANDNE     'N'
     C                   SETON                                        32
     C   32              GOTO      RSTRTB
     C                   ENDIF
      *
      * VALIDATE COUNTY TAXABLE  Y/N
      *
     C     CDTCD2        IFNE      'Y'
     C     CDTCD2        ANDNE     'N'
     C                   SETON                                        33
     C   33              GOTO      RSTRTB
     C                   ENDIF
      *
      * VALIDATE CITY TAXABLE  Y/N
      *
     C     CDTCD3        IFNE      'Y'
     C     CDTCD3        ANDNE     'N'
     C                   SETON                                        34
     C   34              GOTO      RSTRTB
     C                   ENDIF
      *
      * VALIDATE A/R CODE  O/B
      *
     C     CDARCD        IFNE      'O'
     C     CDARCD        ANDNE     'B'
     C                   SETON                                        36
     C   36              GOTO      RSTRTB
     C                   ENDIF
      *
      * VALIDATE INV/STMT COPIES
      *
     C     CDCOPY        IFLT      1
     C     CDCOPY        ORGT      3
     C                   SETON                                        38
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      * VALIDATE POST SLS HISTORY  Y/N
      *
     C     CDPDSL        IFNE      'Y'
     C     CDPDSL        ANDNE     'N'
     C                   SETON                                        37
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      * VALIDATE LATE CHARGES  Y/N
      *
     C     CDAPLC        IFNE      'Y'
     C     CDAPLC        ANDNE     'N'
     C                   SETON                                        35
     C   35              GOTO      RSTRTB
     C                   ENDIF
      *
      * ITEM TAXABLE  Y/N
      *
     C     CDTXBL        IFNE      'Y'
     C     CDTXBL        ANDNE     'N'
     C                   SETON                                        31
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      * VALIDATE CONSOL QTYS  Y/N
      *
     C     CDCNSF        IFNE      'Y'
     C     CDCNSF        ANDNE     'N'
     C                   SETON                                        41
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      * VALIDATE LOT CONTROL  Y/N
      *
     C     CDLOTC        IFNE      'Y'
     C     CDLOTC        ANDNE     'N'
     C                   SETON                                        39
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   Z-ADD     VCO           CDCOMP
     C     VACT          IFEQ      'A'
     C                   WRITE     RMCDEF
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RMCDEF
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RMCDEF
     C                   ENDIF
      *
     C     END           TAG
      *
      *********
      * CLRIT *
      *********
      *
     C     CLRIT         BEGSR
      *
     C                   MOVE      0             VCO
     C     ECLRFL        ENDSR
      *
