      *--------------------------------------------------------------
      *
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ARR365
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- CALCULATE AND POST LATE CHARGES
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * EFD01  9/04/00 ADD REPORT HEADINGS
      *                UPDATE AR BALANCE IN MCUST
      *
      *
     FFAROPN    UF A E           K DISK
     FFAROPNI   IF   F  249    17AIDISK    KEYLOC(2)
     FFMCORG    IF   E           K DISK
     FFARCTL    UF   E           K DISK
EFD01FFMCUST    UF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFMTRAN    O  A E           K DISK
     FARR365    O    F  120        PRINTER OFLIND(*INOF)
      *
      * MESSAGE
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)              MESSAGE
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    261
      * SOURCE LIBRARY
     D  SLIBR                314    323
     D                UDS
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LCDATE                 9     13  0
     D  LDAYS                 14     16  0
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
      * A/R OPEN
     IFAROPNI   NS
     I                                  1    1  STAT
     I                                  2    7 0CUST
     I                                  8   13 0INV#
     I                                 14   15  SUFF
     I                                 16   18 0SEQ#
     I                                 19   20  CTYP
     I                                 21   22  SLM1
     I                                 27   28  SLM2
     I                                 33   34  TERR
     I                                 35   36 0COMP
     I                                 37   38 0TTYP
     I                             P   43   46 0DUDT
     I                             P   47   52 2$AMT
     I                             P   71   76 2DUE$
      *
     C                   Z-ADD     0             BCUST             6 0
     C     BCUST         SETLL     FAROPNI
     C     NXT           TAG
     C                   READ      FAROPNI                                90
     C   90              GOTO      END
      *
     C     STAT          IFEQ      'D'
     C     SEQ#          ORNE      000
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     COMP          IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      **************************************************************
      **************************************************************
      **                                                          **
      **     Added  during testing of daily late charges          **
      **                                                          **
      **************************************************************
     C     CUST          IFEQ      002353
     C     CUST          OREQ      004954
     C     CUST          OREQ      001705
     C     CUST          OREQ      006945
     C     CUST          OREQ      006396
     C     CUST          OREQ      001972
     C     CUST          OREQ      008308
     C     CUST          OREQ      000987
     C     CUST          OREQ      001508
     C     CUST          OREQ      001209
     C                   GOTO      NXT
     C                   ENDIF
      **************************************************************
      **************************************************************
      *
     C     TTYP          IFEQ      07
     C     CUST          ANDEQ     OCUST
     C     DUDT          ANDEQ     TRNDTE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     FIRST         IFGT      1
     C     CUST          ANDNE     OCUST
     C                   EXSR      LATCHG
     C                   Z-ADD     0             TOTDUE
     C                   Z-ADD     0             TOTLC$
     C                   ENDIF
      *
     C     WLATE$        IFGT      0
     C                   EXSR      UAROPN
     C                   EXSR      UMTRAN
EFD01C     OCUST         CHAIN     FMCUST                             90
EFD01C                   ADD       WLATE$        CMARB$
EFD01C                   ADD       WLATE$        CMCUR$
EFD01C                   UPDATE    RMCUST
     C                   Z-ADD     0             WLATE$
     C                   ENDIF
      *
     C     CUST          CHAIN     FMCUST                             92
     C     CMAPLC        IFEQ      'N'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     DUDT          ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DUEDTE            5 0
      *
     C     LCDATE        SUB       DUEDTE        DAYDIF            5 0          DAYS OVERDUE>0
      *
      * TEST FOR PAST DUE RELATIVE TO LDA DAYS
      *
     C  N88DAYDIF        IFGE      LDAYS
     C     TTYP          ANDNE     07
     C                   ADD       DUE$          TOTLC$           11 2
     C                   ENDIF
      *
     C   88DAYDIF        IFGE      LDAYS
     C                   ADD       DUE$          TOTLC$           11 2
     C                   ENDIF
      *
     C                   ADD       DUE$          TOTDUE           11 2
      *
     C                   ADD       1             FIRST
      *
     C                   Z-ADD     CUST          OCUST             6 0
     C                   MOVEL     CMNAME        ONAME            30
     C                   MOVEL     CMSLSM        OSLSM             2
     C                   MOVEL     CMTERR        OTERR             2
     C                   MOVEL     CMLOOK        OLOOK            15
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C  N77              EXCEPT    TLRN
     C   77              EXSR      LATCHG
     C   77WLATE$        IFGT      0
     C                   EXSR      UAROPN
     C                   EXSR      UMTRAN
EFD01C                   ENDIF
     C     LCO           CHAIN     FARCTL                             90
EFD01C                   Z-ADD     LDATE         ACDTLC
     C                   UPDATE    RARCTL
     C   77              EXCEPT    TLR
     C                   SETON                                        LR
      *
      *********
      * LATCHG
      *********
      *
      * MULTIPLY TOTAL AMOUNT DUE FROM CUSTOMER BY LC %
      * DECIDE TO USE EITHER MINIMUM OR CALCULATED LATE CHARGE
      *
     C     LATCHG        BEGSR
      *
     C     TOTDUE        IFLE      0
     C     TOTLC$        ORLE      0
     C                   GOTO      NOLATE
     C                   ENDIF
      *
     C     TOTLC$        MULT(H)   ACLCPC        WLATE            13 4
     C     WLATE         DIV(H)    100           WLATE$           11 2
      *
     C     ACLCMN        IFGT      0
     C     WLATE$        ANDLT     ACLCMN
     C                   Z-ADD     ACLCMN        WLATE$
     C                   ENDIF
      *
     C                   ADD       WLATE$        TOTAMT           11 2
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
     C                   EXCEPT    DETL
     C                   SETON                                        77
     C     NOLATE        ENDSR
      *
      *********
      * UAROPN
      *********
     C     UAROPN        BEGSR
     C     ARKEY         KLIST
     C                   KFLD                    CMCUST
     C                   KFLD                    ARINV#
     C                   KFLD                    ARSUFF
     C                   KFLD                    ARSEQ#
     C                   CLEAR                   RAROPN
     C                   Z-ADD     CMCUST        ARCUST
     C                   Z-ADD     LDATE         ARINV#
     C                   MOVEL     'LC'          ARSUFF
     C                   Z-ADD     000           ARSEQ#
     C     ARKEY         CHAIN     FAROPN                             71
     C   71              DO
     C                   MOVEL     'A'           ARSTAT
     C                   MOVEL     *BLANKS       ARCTYP
     C                   MOVEL     CMSLSM        ARSLM1
     C                   MOVEL     CMTERR        ARTERR
     C                   Z-ADD     LCO           ARCOMP
     C                   Z-ADD     07            ARTTYP
     C                   Z-ADD     TRNDTE        ARTDAT
     C                   Z-ADD     TRNDTE        ARDUDT
     C                   Z-ADD     WLATE$        AR$AMT
     C                   Z-ADD     0             ARDISC
     C                   Z-ADD     0             ARDTAK
     C                   Z-ADD     0             ARADJ$
     C                   Z-ADD     0             ARPAID
     C                   Z-ADD     WLATE$        ARDUE$
     C                   MOVEL     *BLANKS       ARCHEK
     C                   Z-ADD     0             ARCKDT
     C                   Z-ADD     GLNOAR        ARGLAC
     C                   MOVEL     MSG(1)        ARDESC
     C                   Z-ADD     TDATE         ARDTLA
     C                   Z-ADD     TIMOD         ARTIME
     C                   MOVEL     USERID        ARUSER
     C                   Z-ADD     0             ARDCDT
     C                   Z-ADD     0             ARORD#
     C                   MOVEL     CMLOOK        ARLOOK
     C                   Z-ADD     CMCUST        ARSHCU
     C                   Z-ADD     CMSACU        ARSACU
     C                   Z-ADD     CMBLCU        ARBLCU
     C                   WRITE     RAROPN
     C                   ENDDO                                                  71 DO
     C  N71              DO
     C                   Z-ADD     TRNDTE        ARTDAT
     C                   Z-ADD     TRNDTE        ARDUDT
     C                   Z-ADD     WLATE$        AR$AMT
     C                   UPDATE    RAROPN
     C                   ENDDO                                                  N71  DO
     C                   ENDSR
      *********
      * UMTRAN
      *********
     C     UMTRAN        BEGSR
     C                   CLEAR                   RMTRAN
     C                   MOVEL     'A'           MTSTAT
     C                   Z-ADD     CMCUST        MTCUST
     C                   Z-ADD     LDATE         MTINV#
     C                   MOVEL     'LC'          MTSUFF
     C                   Z-ADD     000           MTSEQ#
     C                   MOVEL     *BLANKS       MTCTYP
     C                   MOVEL     CMSLSM        MTSLM1
     C                   MOVEL     CMTERR        MTTERR
     C                   Z-ADD     LCO           MTCOMP
     C                   Z-ADD     07            MTTTYP
     C                   Z-ADD     TRNDTE        MTTDAT
     C                   Z-ADD     TRNDTE        MTDUDT
     C                   Z-ADD     WLATE$        MT$AMT
     C                   Z-ADD     GLNO          MTGLAC
     C                   Z-ADD     TDATE         MTDTLA
     C                   Z-ADD     TIMOD         MTTIME
     C                   MOVEL     USERID        MTUSER
     C                   MOVEL     CMLOOK        MTLOOK
     C                   Z-ADD     CMCUST        MTSHCU
     C                   Z-ADD     CMSACU        MTSACU
     C                   Z-ADD     CMBLCU        MTBLCU
     C                   WRITE     RMTRAN
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   UNLOCK    FARCTL
      *
      * GET LATE CHARGE %, MINIMUM CHARGE AND # OF DAYS
      *
     C     LCO           CHAIN(N)  FMCORG                             22
     C     LCO           CHAIN(N)  FARCTL                             22
      *
      * 88 = CHARGE LATE CHARGES ON LATE CHARGES
      *
     C     ACLCLC        IFEQ      'Y'
     C                   SETON                                        88
     C                   ENDIF
      *
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        TRNDTE            7 0
      *
     C     LCO           CHAIN     FGLDF                              22
     C                   Z-ADD     GDLCHG        GLNO              8 0
     C                   Z-ADD     GDARRC        GLNOAR            8 0
     C                   Z-ADD     1             FIRST             6 0
      *
     C                   EXCEPT    HDG
      *
     C                   ENDSR
      *
     OARR365    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           72 'Late Charges Post Report'
     O                       TIMOD              120 '  :  :  '
EFD01O          E            HDG            2
     O                                           50 'Calculated As Of:'
     O                       LDATE         Y     59
     O                                           81 'On Invoices Overdue'
     O                       LDAYS         Z     85
     O                                           90 'Days'
EFD01O          E            HDG            1
EFD01O                                            5 'A/R'
EFD01O          E            HDG            1
EFD01O                                            5 'Cust'
EFD01O                                           24 'N   A   M   E'
EFD01O                                           63 'Ref.'
EFD01O                                           68 'Suff'
EFD01O                                           85 'A/R Amt'
EFD01O                                           94 'Over'
EFD01O                       LDAYS         Z     98
EFD01O                                          103 'Days'
EFD01O                                          118 'Amount'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       OCUST         Z      6
     O                       ONAME               37
EFD01O*                        LDATE Y   46
EFD01O*                        LDATE Y   55
     O                       LDATE         Z     64
     O                                           67 'LC'
     O                       TOTDUE        1     85
     O                       TOTLC$        1    100
     O                       WLATE$        1    120
EFD01O          E            TLR         1  1
EFD01O                                          120 '----------'
     O          E            TLR            1
EFD01O                                           86 'Total Late Charges'
EFD01O                                          100 ' Added To A/R:'
     O                       TOTAMT        1    120
      *
      * PRINT IF NO LATE CHARGE RECORDS
      *
     O          E            TLRN           1
     O                                           60 '** There Were No Late'
     O                                           82 'Charges Calculated **'
      *                                                                ***@DT@B2
** MESSAGE ARRAY
Late Charge                               1
