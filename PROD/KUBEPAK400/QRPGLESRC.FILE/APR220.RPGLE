      *--------------------------------------------------------------
      *
      *  COPYRIGHT  EFD ENTERPRISES, INC.   1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *****************************************************************
      *PROGRAM NAME-------- APR220
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- PAYMENT SELECTION
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FAPR220FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     F                                     SFILE(VENSFL:RECNO)
     F                                     SFILE(DTESFL:RECNO)
     FFAPOPN    UF   E           K DISK
     F*APOPNDTIF  E           K        DISK
     FFAPOPNDN  IF   E           K DISK
     F                                     RENAME(RAPOPN:MLIST)
     FFMVEND    IF   E           K DISK
     FFTOPAY    IF   E           K DISK
     FFAPCTL    UF   E           K DISK
      *
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)
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
     D  AUTO                   3      3
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVE      *BLANKS       AUTO
      *
     C                   Z-ADD     1             CNT               6 0
      *
     C                   Z-ADD     TDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RDATE             5 0
      *
     C                   Z-ADD     LCO           VCO               2 0
     C     VCO           CHAIN(N)  FAPCTL                             90
     C     AZPAYS        IFEQ      'Y'
     C                   SETON                                        88
     C                   GOTO      AZTAG
     C                   ENDIF
     C                   MOVEL     AZPSEL        CODE
     C     AZTAG         TAG
      *
      * SELECTION SCREEN
      *
     C     RSTRT         TAG
     C                   Z-ADD     0             VDDATE
     C                   Z-ADD     0             VVEND
     C                   MOVEL     *BLANKS       VNAME
     C                   SETOFF                                       223344
     C                   SETOFF                                       5566
     C                   SETOFF                                       242526
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101213
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRT
      *
      *
      * CHECK TO SEE IF PREV CK RUN HAS BEEN POSTED
      *
     C     CNT           IFEQ      1
     C                   SETON                                        77
     C                   ENDIF
     C   77              DO
     C                   Z-ADD     0             VEND              6 0
     C     TPKEY         KLIST
     C                   KFLD                    VEND
     C                   KFLD                    VCO
     C     TPKEY         SETLL     FTOPAY
     C                   READ      FTOPAY                                 95
     C  N95VCO           IFEQ      TPCOMP
     C                   SETON                                        1012
     C   10
     CAN 12              GOTO      NXTA
     C                   ENDIF
     C                   ENDDO
      *
     C                   ADD       1             CNT
     C     VSEL          IFLT      1
     C     VSEL          ORGT      6
     C                   SETON                                        1013
     C   10
     CAN 13              GOTO      NXTA
     C                   ENDIF
      *
      * CHECK IF AUTO SELECT RUN FOR CALL TO APR221
      *
     C     VSEL          IFEQ      2
     C     VSEL          OREQ      4
     C     VSEL          OREQ      5
     C     VSEL          OREQ      6
     C                   MOVEL     'Y'           AUTO
     C                   END
      *
      * 1 = BY VENDOR
      *
     C     VSEL          IFEQ      1
     C                   GOTO      NXTB
     C                   ENDIF
      *
      * 2 = BY DUE DATE
      *
     C     VSEL          IFEQ      2
     C                   SETON                                        22
     C                   GOTO      NXTC
     C                   ENDIF
      *
      * 3 = BY VOUCHER
      *
     C     VSEL          IFEQ      3
     C                   GOTO      NXTD
     C                   ENDIF
      *
      * 4 = BY HELD INVOICES
      *
     C     VSEL          IFEQ      4
     C                   SETON                                        44
     C                   GOTO      NXTC
     C                   ENDIF
      *
      * 5 = ALL OPEN PAYABLES
      *
     C     VSEL          IFEQ      5
     C                   SETON                                        55
     C                   GOTO      NXTE
     C                   ENDIF
      *
      * 5 = ALL SPECIFIC DUE DATE
      *
     C     VSEL          IFEQ      6
     C                   SETON                                        66
     C                   GOTO      NXTF
     C                   ENDIF
      *
      * SELECT BY VENDOR
      *
     C     NXTB          TAG
     C                   MOVEL     *BLANKS       VMNAME
     C                   MOVEL     *BLANKS       VALPHA
      *
     C                   WRITE     SCRNB
     C                   SETOFF                                       101125
     C                   SETOFF                                       99
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRT
      *
     C     VVEND         IFEQ      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   Z-ADD     VCO           VMCOMP            2 0
     C                   MOVEL     VALPHA        VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   MOVEL     VMNAME        VNAME
     C                   Z-ADD     VMVEND        VVEND
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VVEND         IFEQ      *ZEROS
     C                   SETON                                        1011
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VVEND         CHAIN     FMVEND                             90
     C   90              SETON                                        1011
     C   10              GOTO      NXTB
      *
     C                   EXSR      BLDVEN
     C   25              SETON                                        10
     C   25              GOTO      NXTB
     C     NXTVEN        TAG
     C                   EXFMT     VENCTL
     C   KF              GOTO      RSTRT
      *
      * SELECT ALL THIS VENDOR INVOICES
      *
     C   KH              DO
     C                   EXSR      SELALL
     C                   ENDDO
      * DESELECT ALL
     C   KI              DO
     C                   EXSR      DESEL
     C                   ENDDO
     C                   EXSR      CHKVEN
     C   99              GOTO      NXTVEN
     C   KA              DO
     C                   EXSR      PUTVEN
     C                   SETON                                        89
     C                   GOTO      RSTRT
     C                   ENDDO
     C  NKA              GOTO      NXTVEN
      *
     C     NXTD          TAG
     C                   SETON                                        33
     C                   SETOFF                                       1011
     C                   Z-ADD     *ZEROS        VVEND
     C                   Z-ADD     *ZEROS        VVOUC
     C                   MOVEL     *BLANKS       VMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C     NXTDA         TAG
      *
     C                   WRITE     SCRND
     C                   SETOFF                                       1011
     C                   READ      SCRND                                  90
      *
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRT
      *
     C     VVEND         IFEQ      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   Z-ADD     VCO           VMCOMP            2 0
     C                   MOVEL     VALPHA        VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        VVEND
     C                   GOTO      NXTDA
     C                   ENDIF
      *
     C     VVEND         IFEQ      *ZEROS
     C                   SETON                                        10
     C   10              GOTO      NXTDA
     C                   ENDIF
      *
     C     VVEND         CHAIN     FMVEND                             90
     C   90              SETON                                        10
     C   10              GOTO      NXTDA
      *
      * VOUCHER SEARCH
      *
     C   KD              DO
     C                   Z-ADD     VVEND         APVEND
     C                   CALL      'LKAPOPN'
     C                   PARM                    APVEND            6 0
     C                   PARM                    APCOMP            2 0
     C                   PARM                    APVOUC            6 0
     C                   PARM                    APINV#           10
     C                   PARM                    APITYP            1
     C                   PARM                    APSEQ#            3 0
     C                   PARM                    APTDES           30
     C                   MOVEL     APVOUC        VVOUC
     C                   Z-ADD     APCOMP        VCO
     C                   MOVEL     '000'         SEQ               3
     C                   GOTO      NXTDA
     C                   ENDDO
      *
     C     VVOUC         IFEQ      *ZEROS
     C                   SETON                                        11
     C   11              GOTO      NXTDA
     C                   ENDIF
      *
     C                   EXSR      BLDVEN
     C     NXTVVC        TAG
     C                   EXFMT     VENCTL
     C   KF              GOTO      RSTRT
     C   KH              DO
     C                   EXSR      SELALL
     C                   ENDDO
      * DESELECT ALL
     C   KI              DO
     C                   EXSR      DESEL
     C                   ENDDO
     C                   EXSR      CHKVEN
     C   99              GOTO      NXTVVC
     C   KA              DO
     C                   EXSR      PUTVEN
     C                   SETON                                        89
     C                   GOTO      RSTRT
     C                   ENDDO
     C  NKA              GOTO      NXTVVC
      *
     C     NXTC          TAG
     C   44              GOTO      HOLD
     C                   Z-ADD     *ZEROS        VDDATE
      *
     C                   WRITE     SCRNC
     C                   SETOFF                                       1011
     C                   READ      SCRNC                                  90
      *
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRT
      *
     C                   Z-ADD     VDDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1011
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     HOLD          TAG
     C   44              MOVE      'H'           CODE
     C                   EXSR      BLDSFL
     C     NXTDUE        TAG
     C                   EXFMT     RECCTL
     C   KF              GOTO      RSTRT
      * SELECT ALL
     C   KH              DO
     C                   EXSR      ALLDTE
     C                   ENDDO
      * DESELECT ALL
     C   KI              DO
     C                   EXSR      NODTE
     C                   ENDDO
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTDUE
     C   KA              DO
     C                   EXSR      PUTSFL
     C                   SETON                                        89
     C                   GOTO      RSTRT
     C                   ENDDO
     C  NKA              GOTO      NXTDUE
      *
     C     NXTE          TAG
      *
     C                   WRITE     SCRNE
     C                   SETOFF                                       10
     C                   READ      SCRNE                                  90
      *
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRT
     C  NKA              GOTO      RSTRT
      *
     C                   Z-ADD     0             VVEND
     C     VVEND         SETLL     FAPOPN
     C     NXTEE         TAG
     C                   READ      FAPOPN                                 90
     C   90              GOTO      ENDP
     C     APSTAT        IFEQ      'D'
     C                   GOTO      NXTEE
     C                   ENDIF
     C     APCLCD        IFEQ      'Y'
     C                   GOTO      NXTEE
     C                   ENDIF
     C     APDUE$        IFEQ      0
     C                   GOTO      NXTEE
     C                   ENDIF
     C     APTBPD        IFEQ      'H'
     C                   GOTO      NXTEE
     C                   ENDIF
      *
     C*          APKEY     CHAINFAPOPN               92
     C                   MOVEL     'Y'           APTBPD
     C     DIS           IFEQ      0
     C                   Z-ADD     PAY           AP$TOP
     C                   ELSE
     C     PAY           SUB       DIS           AP$TOP
     C                   ENDIF
     C                   Z-ADD     DIS           APDISC
     C                   Z-ADD     TDATE         APDTLA
     C                   Z-ADD     TIMOD         APTIME
     C                   MOVEL     USERID        APUSER
     C                   UPDATE    RAPOPN
     C                   GOTO      NXTEE
      *
     C     NXTF          TAG
     C                   Z-ADD     *ZEROS        VDDATE
      *
     C                   WRITE     SCRNF
     C                   SETOFF                                       101125
     C                   READ      SCRNF                                  90
      *
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRT
      *
     C                   Z-ADD     VFDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1011
     C                   GOTO      NXTF
     C                   ENDIF
     C                   Z-ADD     VFDATE        VDDATE
      *
     C                   EXSR      DATSFL
      *
     C   25              SETON                                        10
     C   25              GOTO      NXTF
      *
     C     NXTDUF        TAG
     C                   EXFMT     DTECTL
     C   KF              GOTO      RSTRT
      * SELECT ALL
     C   KH              DO
     C                   EXSR      DTEALL
     C                   ENDDO
      * DESELECT ALL
     C   KI              DO
     C                   EXSR      DTENO
     C                   ENDDO
     C                   EXSR      CHKDTE
     C   99              GOTO      NXTDUF
     C   KA              DO
     C                   EXSR      GETDTE
     C                   SETON                                        89
     C                   GOTO      RSTRT
     C                   ENDDO
     C  NKA              GOTO      NXTDUF
      *
     C     ENDP          TAG
     C     VCO           CHAIN     FAPCTL                             90
     C   89              MOVEL     'Y'           AZPAYS
     C   89              MOVEL     *BLANKS       AZOKC
     C   89              Z-ADD     TDATE         AZDTLA
     C   89              Z-ADD     TIMOD         AZTIME
     C   89              MOVEL     USERID        AZUSER
     C   89              UPDATE    RAPCTL
     C                   SETON                                        LR
      *
      ***********
      * BLDVEN
      ***********
     C     BLDVEN        BEGSR
     C                   SETOFF                                       102530
     C                   SETOFF                                       31
     C     VVEND         SETLL     FAPOPN
     C                   MOVE      '1'           *IN80
     C                   WRITE     VENCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     VENBLD        TAG
     C                   SETOFF                                       90
     C     VVEND         READE     FAPOPN                                 90
     C   90              GOTO      ENDVEN
     C     APSTAT        IFEQ      'D'
     C                   GOTO      VENBLD
     C                   ENDIF
     C     APTBPD        IFEQ      'H'
     C                   SETON                                        24
     C                   GOTO      VENBLD
     C                   ENDIF
     C     APCLCD        IFEQ      'Y'
     C                   GOTO      VENBLD
     C                   ENDIF
     C     APDUE$        IFEQ      0
     C                   GOTO      VENBLD
     C                   ENDIF
     C   33APVOUC        IFNE      VVOUC
     C                   GOTO      VENBLD
     C                   ENDIF
     C                   Z-ADD     APDUE$        PAY
     C     APDCDT        IFGT      0
     C                   Z-ADD     APDCDT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DSDATE            5 0
     C                   ENDIF
     C     APTBPD        IFNE      'Y'
     C     DSDATE        IFGE      RDATE
     C                   Z-ADD     APDAVL        DISC
     C                   Z-ADD     APDAVL        DIS
     C                   Z-ADD     APDCDT        DDATE
     C                   ELSE
     C                   Z-ADD     0             DISC
     C                   Z-ADD     0             DIS
     C                   Z-ADD     0             DDATE
     C                   ENDIF
     C                   Z-ADD     APDUE$        PAY
     C                   ELSE                                                   APTBPD=Y
     C     APDISC        ADD       AP$TOP        PAY
     C                   Z-ADD     APDISC        DIS
     C                   ENDIF                                                  APTBPD=Y
     C   88              MOVEL     APTBPD        CODE
     C   88APTBPD        IFNE      'Y'
     C                   MOVEL     'N'           CODE
     C                   ENDIF
     C                   Z-ADD     APVOUC        VOUCH
     C                   MOVEL     APINV#        INV#
     C                   MOVEL     APITYP        ITYP
     C                   Z-ADD     APDUDT        IDATE
     C                   Z-ADD     APDUE$        AMT
     C                   Z-ADD     APDUE$        BAL
     C                   ADD       1             RECNO
     C     RECNO         IFGT      5000
     C                   GOTO      ENDVEN
     C                   ENDIF
     C                   WRITE     VENSFL
     C                   GOTO      VENBLD
     C     ENDVEN        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
      *
     C     LSTREC        IFEQ      0
     C                   SETON                                        25
     C                   ENDIF
      *
     C                   ADD       2             RECNO
     C                   SETON                                        26
     C                   MOVEL     *BLANKS       CODE
     C                   MOVEL     *BLANKS       INV#
     C                   MOVEL     *BLANKS       ITYP
     C                   Z-ADD     0             PAY
     C                   Z-ADD     0             DIS
     C                   Z-ADD     0             VOUCH
     C                   Z-ADD     0             IDATE
     C                   Z-ADD     0             BAL
     C                   Z-ADD     0             DISC
     C                   Z-ADD     0             DDATE
     C                   MOVEL     MSG(1)        INV#
     C                   WRITE     VENSFL
     C                   SETOFF                                       26
     C                   ENDSR
      *
      ***********
      * CHKVEN
      ***********
     C     CHKVEN        BEGSR
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       203099
     C                   SETOFF                                       213141
     C                   SETOFF                                       403536
     C                   SETOFF                                       37
     C     VENCHK        TAG
     C                   SETOFF                                       203035
     C                   SETOFF                                       3240
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDVCK
     C                   ENDIF
     C     RECNO         CHAIN     VENSFL                             90
     C   90              GOTO      VENCHK
      *
     C     CODE          IFEQ      ' '
     C     PAY           ANDEQ     0
     C     DIS           ANDEQ     0
     C                   MOVE      *BLANKS       INV#
     C                   Z-ADD     0             VOUCH
     C                   Z-ADD     0             IDATE
     C                   Z-ADD     0             DDATE
     C                   Z-ADD     0             PAY
     C                   Z-ADD     0             BAL
     C                   Z-ADD     0             DIS
     C                   Z-ADD     0             DISC
     C                   GOTO      VENCHK
     C                   ENDIF
      *
     C     CODE          IFNE      'N'
     C     CODE          ANDNE     'Y'
     C     CODE          ANDNE     'H'
     C                   SETON                                        202199
     C                   ENDIF
      *
     C     PAY           IFEQ      0
     C                   SETON                                        303199
     C                   ENDIF
      *
     C     PAY           IFGT      AMT
     C                   SETON                                        303799
     C                   ENDIF
      *
     C     DIS           IFNE      0
     C     DIS           ANDGE     PAY
     C                   SETON                                        353699
     C                   ENDIF
      *
     C                   UPDATE    VENSFL
     C                   GOTO      VENCHK
     C     ENDVCK        TAG
     C                   ENDSR
      ***********
      * PUTVEN
      ***********
     C     PUTVEN        BEGSR
     C                   Z-ADD     0             RECNO
     C     VENPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDVPT
     C                   ENDIF
     C     RECNO         CHAIN     VENSFL                             90
     C   90              GOTO      VENPUT
      *
     C                   Z-ADD     APSEQ#        SEQ#              3 0
     C     APKEY         KLIST
     C                   KFLD                    VVEND
     C                   KFLD                    VCO
     C                   KFLD                    VOUCH
     C                   KFLD                    INV#
     C                   KFLD                    SEQ#
     C                   KFLD                    ITYP
     C     APKEY         CHAIN     FAPOPN                             92
     C                   MOVEL     CODE          APTBPD
     C     CODE          IFEQ      'N'
     C                   Z-ADD     0             APDISC
     C                   Z-ADD     0             AP$TOP
     C                   ELSE
     C     PAY           SUB       DIS           AP$TOP
     C                   Z-ADD     DIS           APDISC
     C                   ENDIF
     C                   Z-ADD     TDATE         APDTLA
     C                   Z-ADD     TIMOD         APTIME
     C                   MOVEL     USERID        APUSER
     C                   UPDATE    RAPOPN
     C     NVPAY         TAG
     C                   GOTO      VENPUT
      *
     C     ENDVPT        ENDSR
      *
      ***********
      * BLDSFL
      ***********
     C     BLDSFL        BEGSR
     C                   SETOFF                                       1030
     C                   Z-ADD     0             DATELL            8 0
     C     VDDATE        MULT      10000.01      DUEDTE            6 0
     C     DUEDTE        IFGT      700000
     C                   MOVEL     19            DTEDUE            8 0
     C                   ELSE
     C                   MOVEL     20            DTEDUE
     C                   ENDIF
     C                   MOVE      DUEDTE        DTEDUE
     C     DATELL        SETLL     FAPOPNDN
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTBLD        TAG
     C                   SETOFF                                       90
     C                   READ      FAPOPNDN                               90
     C   90              GOTO      ENDBLD
     C     APSTAT        IFEQ      'D'
     C                   GOTO      NXTBLD
     C                   ENDIF
     C  N44APTBPD        IFEQ      'H'
     C                   GOTO      NXTBLD
     C                   ENDIF
     C   44APTBPD        IFNE      'H'
     C                   GOTO      NXTBLD
     C                   ENDIF
     C     APCLCD        IFEQ      'Y'
     C                   GOTO      NXTBLD
     C                   ENDIF
     C     APDUE$        IFEQ      0
     C                   GOTO      NXTBLD
     C                   ENDIF
     C     APVEND        CHAIN     FMVEND                             90
     C  N90              MOVEL     VMNAME        VNME
     C   90              MOVEL     *BLANKS       VNME
      *
     C                   Z-ADD     APDUE$        AMT
     C  N44APRVDU        IFGT      DTEDUE
     C                   GOTO      NXTBLD
     C                   ENDIF
     C   66APRVDU        IFNE      DTEDUE
     C                   GOTO      NXTBLD
     C                   ENDIF
     C     APDCDT        IFGT      0
     C                   Z-ADD     APDCDT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DSDATE            5 0
     C                   ENDIF
     C     APTBPD        IFNE      'Y'
     C     DSDATE        IFGE      RDATE
     C                   Z-ADD     APDAVL        DISC
     C                   Z-ADD     APDAVL        DIS
     C                   Z-ADD     APDCDT        DDATE
     C                   ELSE
     C                   Z-ADD     0             DISC
     C                   Z-ADD     0             DIS
     C                   Z-ADD     0             DDATE
     C                   ENDIF
     C                   Z-ADD     APDUE$        PAY
     C                   ELSE                                                   APTBPD=Y
     C     APDISC        ADD       AP$TOP        PAY
     C                   Z-ADD     APDISC        DIS
     C                   ENDIF                                                  APTBPD=Y
     C   88              MOVEL     APTBPD        CODE
     C   88APTBPD        IFNE      'Y'
     C                   MOVEL     'N'           CODE
     C                   ENDIF
     C   44              MOVEL     APTBPD        CODE
     C     CODE          IFEQ      'Y'
     C                   SETON                                        87
     C                   ENDIF
     C                   Z-ADD     APVEND        VEND
     C                   Z-ADD     APVOUC        VOUCH
     C                   MOVEL     APINV#        INV#
     C                   MOVEL     APITYP        ITYP
     C                   Z-ADD     APDUDT        IDATE
     C                   Z-ADD     APDUE$        BAL
     C                   ADD       1             RECNO
     C     RECNO         IFGT      5000
     C                   GOTO      ENDBLD
     C                   ENDIF
     C                   WRITE     RECSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
      *
     C     LSTREC        IFEQ      0
     C                   SETON                                        25
     C                   ENDIF
      *
     C                   ADD       2             RECNO
     C                   SETON                                        26
     C                   MOVEL     *BLANKS       CODE
     C                   MOVEL     *BLANKS       VNME
     C                   MOVEL     *BLANKS       INV#
     C                   MOVEL     *BLANKS       ITYP
     C                   Z-ADD     0             VEND
     C                   Z-ADD     0             PAY
     C                   Z-ADD     0             DIS
     C                   Z-ADD     0             VOUCH
     C                   Z-ADD     0             IDATE
     C                   Z-ADD     0             BAL
     C                   Z-ADD     0             DISC
     C                   Z-ADD     0             DDATE
     C                   MOVEL     MSG(1)        INV#
     C                   WRITE     RECSFL
     C                   SETOFF                                       26
     C                   ENDSR
      *
      ***********
      * CHKSFL
      ***********
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       203099
     C                   SETOFF                                       213141
     C                   SETOFF                                       403536
     C                   SETOFF                                       37
     C     NXTCHK        TAG
     C                   SETOFF                                       203035
     C                   SETOFF                                       3240
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   ENDIF
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTCHK
      *
     C     CODE          IFEQ      ' '
     C     PAY           ANDEQ     0
     C     DIS           ANDEQ     0
     C                   MOVE      *BLANKS       INV#
     C                   Z-ADD     0             VOUCH
     C                   Z-ADD     0             IDATE
     C                   Z-ADD     0             DDATE
     C                   Z-ADD     0             PAY
     C                   Z-ADD     0             BAL
     C                   Z-ADD     0             DIS
     C                   Z-ADD     0             DISC
     C                   GOTO      NXTCHK
     C                   ENDIF
      *
     C     CODE          IFNE      'N'
     C     CODE          ANDNE     'Y'
     C     CODE          ANDNE     'H'
     C                   SETON                                        202199
     C                   ENDIF
      *
     C     PAY           IFEQ      0
     C                   SETON                                        303199
     C                   ENDIF
      *
     C     PAY           IFGT      AMT
     C                   SETON                                        303799
     C                   ENDIF
      *
     C     DIS           IFNE      0
     C     DIS           ANDGE     PAY
     C                   SETON                                        353699
     C                   ENDIF
      *
     C                   UPDATE    RECSFL
     C                   GOTO      NXTCHK
      *
     C     ENDCHK        TAG
     C                   ENDSR
      ***********
      * PUTSFL
      ***********
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   ENDIF
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTPUT
      *
     C                   MOVEL     APITYP        ITYP
     C                   Z-ADD     VEND          VVEND
     C                   Z-ADD     APCOMP        VCO
     C                   Z-ADD     APSEQ#        SEQ#
     C     APKEY         CHAIN     FAPOPN                             92
     C                   MOVEL     CODE          APTBPD
     C     CODE          IFEQ      'N'
     C                   Z-ADD     0             APDISC
     C                   Z-ADD     0             AP$TOP
     C                   ELSE
     C     PAY           SUB       DIS           AP$TOP
     C                   Z-ADD     DIS           APDISC
     C                   ENDIF
     C                   Z-ADD     TDATE         APDTLA
     C                   Z-ADD     TIMOD         APTIME
     C                   MOVEL     USERID        APUSER
     C                   UPDATE    RAPOPN
     C                   GOTO      NXTPUT
      *
     C     ENDPUT        ENDSR
      ***********
      * DATSFL
      ***********
     C     DATSFL        BEGSR
     C                   SETOFF                                       1030
     C                   Z-ADD     0             DATELL            8 0
     C     VDDATE        MULT      10000.01      DUEDTE            6 0
     C     DUEDTE        IFGT      700000
     C                   MOVEL     19            DTEDUE            8 0
     C                   ELSE
     C                   MOVEL     20            DTEDUE
     C                   ENDIF
     C                   MOVE      DUEDTE        DTEDUE
     C     DTEDUE        SETLL     FAPOPNDN
     C                   MOVE      '1'           *IN80
     C                   WRITE     DTECTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTBDT        TAG
     C                   SETOFF                                       90
     C     DTEDUE        READE     FAPOPNDN                               90
     C   90              GOTO      ENDBDT
     C     APSTAT        IFEQ      'D'
     C                   GOTO      NXTBDT
     C                   ENDIF
     C  N44APTBPD        IFEQ      'H'
     C                   GOTO      NXTBDT
     C                   ENDIF
     C   44APTBPD        IFNE      'H'
     C                   GOTO      NXTBDT
     C                   ENDIF
     C     APCLCD        IFEQ      'Y'
     C                   GOTO      NXTBDT
     C                   ENDIF
     C     APDUE$        IFEQ      0
     C                   GOTO      NXTBDT
     C                   ENDIF
     C  N44APRVDU        IFGT      DTEDUE
     C                   GOTO      NXTBDT
     C                   ENDIF
     C   66APRVDU        IFNE      DTEDUE
     C                   GOTO      NXTBDT
     C                   ENDIF
     C     APDCDT        IFGT      0
     C                   Z-ADD     APDCDT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DSDATE            5 0
     C                   ENDIF
     C     APTBPD        IFNE      'Y'
     C     DSDATE        IFGE      RDATE
     C                   Z-ADD     APDAVL        DISC
     C                   Z-ADD     APDAVL        DIS
     C                   Z-ADD     APDCDT        DDATE
     C                   ELSE
     C                   Z-ADD     0             DISC
     C                   Z-ADD     0             DIS
     C                   Z-ADD     0             DDATE
     C                   ENDIF
     C                   Z-ADD     APDUE$        PAY
     C                   ELSE                                                   APTBPD=Y
     C     APDISC        ADD       AP$TOP        PAY
     C                   Z-ADD     APDISC        DIS
     C                   ENDIF                                                  APTBPD=Y
     C   88              MOVEL     APTBPD        CODE
     C   88APTBPD        IFNE      'Y'
     C                   MOVEL     'N'           CODE
     C                   ENDIF
     C   44              MOVEL     APTBPD        CODE
     C     CODE          IFEQ      'Y'
     C                   SETON                                        87
     C                   ENDIF
     C                   Z-ADD     APVEND        VEND
     C                   Z-ADD     APVOUC        VOUCH
     C                   MOVEL     APINV#        INV#
     C                   MOVEL     APITYP        ITYP
     C                   Z-ADD     APDUDT        IDATE
     C                   Z-ADD     APDUE$        BAL
     C     APVEND        CHAIN     FMVEND                             90
     C                   MOVEL     VMNAME        VENNAM           11
     C                   ADD       1             RECNO
     C     RECNO         IFGT      5000
     C                   GOTO      ENDBDT
     C                   ENDIF
     C                   WRITE     DTESFL
     C                   GOTO      NXTBDT
     C     ENDBDT        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
      *
     C     LSTREC        IFEQ      0
     C                   SETON                                        25
     C                   ENDIF
      *
     C                   ADD       2             RECNO
     C                   SETON                                        26
     C                   MOVEL     *BLANKS       CODE
     C                   MOVEL     *BLANKS       INV#
     C                   MOVEL     *BLANKS       ITYP
     C                   MOVEL     *BLANKS       VENNAM
     C                   Z-ADD     0             PAY
     C                   Z-ADD     0             DIS
     C                   Z-ADD     0             VOUCH
     C                   Z-ADD     0             VEND
     C                   Z-ADD     0             IDATE
     C                   Z-ADD     0             BAL
     C                   Z-ADD     0             DISC
     C                   Z-ADD     0             DDATE
     C                   MOVEL     MSG(1)        INV#
     C                   WRITE     DTESFL
     C                   SETOFF                                       26
     C                   ENDSR
      *
      ***********
      * CHKDTE
      ***********
     C     CHKDTE        BEGSR
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       203099
     C                   SETOFF                                       213141
     C                   SETOFF                                       403536
     C                   SETOFF                                       37
     C     NXTCDT        TAG
     C                   SETOFF                                       203035
     C                   SETOFF                                       3240
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCDT
     C                   ENDIF
     C     RECNO         CHAIN     DTESFL                             90
     C   90              GOTO      NXTCDT
      *
     C     CODE          IFEQ      ' '
     C     PAY           ANDEQ     0
     C     DIS           ANDEQ     0
     C                   MOVE      *BLANKS       INV#
     C                   Z-ADD     0             VOUCH
     C                   Z-ADD     0             IDATE
     C                   Z-ADD     0             DDATE
     C                   Z-ADD     0             PAY
     C                   Z-ADD     0             AMT
     C                   Z-ADD     0             BAL
     C                   Z-ADD     0             DIS
     C                   Z-ADD     0             DISC
     C                   GOTO      NXTCDT
     C                   ENDIF
      *
     C     CODE          IFNE      'N'
     C     CODE          ANDNE     'Y'
     C     CODE          ANDNE     'H'
     C                   SETON                                        202199
     C                   ENDIF
      *
     C     PAY           IFEQ      0
     C                   SETON                                        303199
     C                   ENDIF
      *
     C     PAY           IFGT      AMT
     C                   SETON                                        303799
     C                   ENDIF
      *
     C     DIS           IFNE      0
     C     DIS           ANDGE     PAY
     C                   SETON                                        353699
     C                   ENDIF
      *
     C                   UPDATE    DTESFL
     C                   GOTO      NXTCDT
      *
     C     ENDCDT        TAG
     C                   ENDSR
      ***********
      * GETDTE
      ***********
     C     GETDTE        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTPDT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPDT
     C                   ENDIF
     C     RECNO         CHAIN     DTESFL                             90
     C   90              GOTO      NXTPDT
      *
     C                   MOVEL     APITYP        ITYP
     C                   Z-ADD     VEND          VVEND
     C                   Z-ADD     APCOMP        VCO
     C                   Z-ADD     APSEQ#        SEQ#
     C     APKEY         CHAIN     FAPOPN                             92
     C                   MOVEL     CODE          APTBPD
     C     CODE          IFEQ      'N'
     C                   Z-ADD     0             AP$TOP
     C                   Z-ADD     0             APDISC
     C                   ELSE
     C     PAY           SUB       DIS           AP$TOP
     C                   Z-ADD     DIS           APDISC
     C                   ENDIF
     C                   Z-ADD     TDATE         APDTLA
     C                   Z-ADD     TIMOD         APTIME
     C                   MOVEL     USERID        APUSER
     C                   UPDATE    RAPOPN
     C                   GOTO      NXTPDT
      *
     C     ENDPDT        ENDSR
      *
      **********
      * SELALL * SELECT ALL ON SCREEN BY VENDOR
      **********
     C     SELALL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTALL        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDSEL
     C                   ENDIF
     C     RECNO         CHAIN     VENSFL                             90
     C   90              GOTO      NXTALL
     C                   MOVEL     'Y'           CODE
     C                   UPDATE    VENSFL
     C                   GOTO      NXTALL
     C     ENDSEL        ENDSR
      **********
      * ALLDTE * SELECT ALL ON SCREEN BY DUE DATE
      **********
     C     ALLDTE        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTDTE        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDDTE
     C                   ENDIF
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTDTE
     C                   MOVEL     'Y'           CODE
     C                   UPDATE    RECSFL
     C                   GOTO      NXTDTE
     C     ENDDTE        ENDSR
      **********
      * DTEALL * SELECT ALL ON SCREEN BY SPECIFIC DUE DATE
      **********
     C     DTEALL        BEGSR
     C                   Z-ADD     0             RECNO
     C     DTENXT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      DTEEND
     C                   ENDIF
     C     RECNO         CHAIN     DTESFL                             90
     C   90              GOTO      DTENXT
     C                   MOVEL     'Y'           CODE
     C                   UPDATE    DTESFL
     C                   GOTO      DTENXT
     C     DTEEND        ENDSR
      **********
      * DESEL  *
      **********
     C     DESEL         BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTNON        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDDE
     C                   ENDIF
     C     RECNO         CHAIN     VENSFL                             90
     C   90              GOTO      NXTNON
     C                   MOVEL     'N'           CODE
     C                   UPDATE    VENSFL
     C                   GOTO      NXTNON
     C     ENDDE         ENDSR
      **********
      * NODTE  *
      **********
     C     NODTE         BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTNOD        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDNO
     C                   ENDIF
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTNOD
     C                   MOVEL     'N'           CODE
     C                   UPDATE    RECSFL
     C                   GOTO      NXTNOD
     C     ENDNO         ENDSR
      **********
      * DTENO  *
      **********
     C     DTENO         BEGSR
     C                   Z-ADD     0             RECNO
     C     NODNXT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      NOEND
     C                   ENDIF
     C     RECNO         CHAIN     DTESFL                             90
     C   90              GOTO      NODNXT
     C                   MOVEL     'N'           CODE
     C                   UPDATE    DTESFL
     C                   GOTO      NODNXT
     C     NOEND         ENDSR
      **********
      * VENALL *
      **********
      *
     C     VENALL        BEGSR
      *
     C                   ENDSR
      *
**
*End Data*
