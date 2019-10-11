      *--------------------------------------------------------------
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- QPARLCD
      **APPLICATION--------- DAILY LATE CHARGE CALCULATION
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMCUST    IF   E           K DISK
     FFAROPNDD  IF   E           K DISK
     F                                     RENAME(RAROPN:AROPNI)
     F*AROPN  UF  E           K        DISK                      A
     FFARCTL    IF   E           K DISK
     FFARLC     UF A E           K DISK
     FFARLCD    UF A E           K DISK
     FFSTATUS   UF A E           K DISK
     FFMTRAN    UF A E           K DISK
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)              MESSAGES
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LDATE                  1      6  0                                      ARC380
     D  LCANCL               133    133                                         ARC380
      ****************
      * START HERE   *
      ****************
     C                   Z-ADD     0             MTRAMT            9 2
     C     RSTART        TAG
     C                   Z-ADD     0             CMCUST
     C     CMCUST        SETLL     FMCUST
     C     NXTCST        TAG
     C                   READ      FMCUST                                 90
     C   90              GOTO      END
     C** 90                GOTO RSTART
      ** PUT SELECTION HERE  APPLY LATE CHARGES EQUAL B FOR BROKER
      **                                        EQUAL Y FOR ALL OTHERS
      **                                        EQUAL N FOR NO LATE CHG
     C     CMAPLC        IFNE      'B'
     C                   GOTO      NXTCST
     C                   END
      ** GET AR BALANCE
     C                   EXSR      GETBAL
     C     BAL           IFLE      0
     C                   GOTO      NXTCST
     C                   END
      ** IF HERE THEY HAVE A BALANCE
     C                   Z-SUB     NEG           TEST             11 2
     C                   Z-ADD     0             ARAMT            15 9
     C     CMCUST        SETLL     FAROPNDD
     C     NXTWRK        TAG
     C     CMCUST        READE     FAROPNDD                               91
     C   91              GOTO      ENDWRK
      ** ONLY GET HEADER RECORDS WITH A BALANCE
     C     ARSEQ#        IFNE      000
     C     ARDUE$        OREQ      0.00
     C     ARTTYP        ORNE      01
     C                   GOTO      NXTWRK
     C                   END
     C     TEST          IFGT      0
     C     TEST          IFGE      ARDUE$
     C                   SUB       ARDUE$        TEST
     C                   GOTO      NXTWRK
     C                   END                                                    TEST>ARDUE$
      ** IF HERE ARDUE>TEST
     C                   SUB       TEST          ARDUE$
     C                   Z-ADD     0             TEST
     C                   END                                                    TEST>0
      ** NOW CALC OVER DUE DAYS
     C                   Z-ADD     ARDUDT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   GOTO      NXTWRK
     C                   END
     C                   Z-ADD     ##DDD         DDDAYS            5 0
     C     TDDAYS        SUB       DDDAYS        WKDAYS            5 0
     C     WKDAYS        IFLT      ACLCD#
     C                   GOTO      NXTWRK
     C                   END
     C     LCKEY         CHAIN     FARLC                              75
      ** NOW GET DAILY AMOUNT
     C  N75              DO
     C     ARDUE$        MULT(H)   WKPCT         WKAMT
     C                   ADD       WKAMT         ARLCAM
     C                   Z-ADD(H)  ARLCAM        ARLCDU
     C                   ADD       WKAMT         ARLCMT
     C**         WKAMT     MULT WKDAYS    ARLCAM    H
     C                   Z-ADD     WKDAYS        ARLCDY
     C                   UPDATE    RARLC
     C                   ENDDO                                                   N75  DO
     C   75              DO
     C                   Z-ADD     0             ARLCPD
     C     ARDUE$        MULT(H)   BPCT          WKAMT            15 9
     C                   Z-ADD     WKAMT         ARLCAM
     C                   Z-ADD(H)  ARLCAM        ARLCDU
     C                   Z-ADD     WKAMT         ARLCMT
     C                   Z-ADD     1             ARLCDY
     C                   Z-ADD     LDATEC        ARLMLC
     C                   WRITE     RARLC
     C                   ENDDO                                                   75  DO
     C                   ADD(H)    WKAMT         ARAMT
     C                   Z-ADD     YYMM          ARYYMM
     C     LDKEY         CHAIN     FARLCD                             75
     C                   Z-ADD     ARLCMT        ARMAMT
     C   75              WRITE     RARLCD
     C  N75              UPDATE    RARLCD
     C                   GOTO      NXTWRK
     C     ENDWRK        TAG
     C                   ADD(H)    ARAMT         MTRAMT
     C                   GOTO      NXTCST
     C*          ARAMT     IFGT 0
      ** OUTPUT AROPN RECORD
     C*                    Z-ADDCMCUST    CUST    60
     C*                    Z-ADDARINV     INV#    60
     C*                    MOVEL'LC'      SUFF    2
     C*                    Z-ADD0         SEQ     30
     C*          MTKEY     CHAINFAROPN               57
     C*  57                DO
     C*                    CLEARRAROPN
     C*                    Z-ADDCMCUST    ARCUST
     C*                    Z-ADDARINV     ARINV#
     C*                    MOVEL'LC'      ARSUFF
     C*                    Z-ADD0         ARSEQ#
     C*                    MOVEL'A'       ARSTAT
     C*                    Z-ADD1         ARCOMP
     C*                    ENDDO                           57 DO
     C*                    MOVELCMCTYP    ARCTYP
     C*                    Z-ADD7         ARTTYP
     C*                    Z-ADDLDATEC    ARTDAT
     C*                    Z-ADDLDATEC    ARDUDT
     C*                    ADD  ARAMT     AR$AMT    H
     C*                    ADD  ARAMT     MTRAMT    H
     C*                    ADD  ARAMT     ARDUE$    H
     C*                    MOVELMSG,1     ARDESC
     C*                    Z-ADDTDATE     ARDTLA
     C*                    Z-ADDTIMOD     ARTIME
     C*                    MOVELUSERID    ARUSER
     C*                    MOVELCMLOOK    ARLOOK
     C*                    Z-ADDCMCUST    ARSHCU
     C*                    Z-ADDCMSACU    ARSACU
     C*                    Z-ADDCMBLCU    ARBLCU
     C*  57                WRITERAROPN
     C* N57                UPDATRAROPN
     C*                    END                             ARAMT>0
      ** END PROGRAM
     C     END           TAG
      ** UPDATE STATUS FILE
     C                   MOVEL     'QPKARLCD'    STPROG
     C                   Z-ADD     1             STCOMP
     C     STKEY         CHAIN     FSTATUS                            55
     C                   Z-ADD     TDATET        STDATE
     C                   Z-ADD     TIMOD         STTIME
     C                   Z-ADD     0             STACTP
     C                   MOVEL     USERID        STUSER
     C                   MOVEL     MSG(1)        STDESC
     C   55              WRITE     RSTATUS
     C  N55              UPDATE    RSTATUS
      ** OUTPUT MTRAN
     C     MTRAMT        IFNE      0
     C                   Z-ADD     3912          CUST              6 0
     C                   Z-ADD     LDATE         INV#              6 0
     C                   MOVEL     'LC'          SUFF              2
     C                   Z-ADD     0             SEQ               3 0
     C     MTKEY         CHAIN     RMTRAN                             57
     C   57              DO
     C                   CLEAR                   RMTRAN
     C                   Z-ADD     3912          MTCUST
     C                   Z-ADD     LDATE         MTINV#
     C                   MOVEL     'LC'          MTSUFF
     C                   Z-ADD     0             MTSEQ#
     C                   MOVEL     'A'           MTSTAT
     C                   Z-ADD     1             MTCOMP
     C                   ENDDO                                                  57 DO
     C                   Z-ADD     07            MTTTYP
     C                   Z-ADD     LDATEC        MTTDAT
     C                   Z-ADD     LDATEC        MTDUDT
     C                   ADD(H)    MTRAMT        MT$AMT
     C                   Z-ADD     MTCUST        MTSHCU
     C                   Z-ADD     MTCUST        MTSACU
     C                   Z-ADD     MTCUST        MTBLCU
     C     MTCUST        CHAIN     FMCUST                             90
     C                   MOVEL     CMLOOK        MTLOOK
     C                   MOVEL     MSG(1)        MTDESC
     C                   Z-ADD     TDATE         MTDTLA
     C                   Z-ADD     TIMOD         MTTIME
     C                   MOVEL     USERID        MTUSER
     C                   MOVEL     CMCTYP        MTCTYP
     C   57              WRITE     RMTRAN
     C  N57              UPDATE    RMTRAN
     C                   END                                                    MTRAMT><0
      ** RUN MONTHLY NEXT
     C                   MOVE      *BLANKS       LCANCL
     C                   SETON                                        LR
      ***********************
      ** GET CUST BALANCE  **
      ***********************
     C     GETBAL        BEGSR
     C                   Z-ADD     0             BAL              11 2
     C                   Z-ADD     0             NEG              11 2
     C     CMCUST        SETLL     FAROPNDD
     C     NXTBAL        TAG
     C     CMCUST        READE     FAROPNDD                               91
     C   91              GOTO      ENDBAL
      ** ONLY GET HEADER RECORDS WITH A BALANCE
     C     ARSEQ#        IFNE      000
     C     ARDUE$        OREQ      0.00
     C                   GOTO      NXTBAL
     C                   END
     C                   ADD       ARDUE$        BAL
     C     ARDUE$        IFLT      0
     C                   ADD       ARDUE$        NEG
     C                   END
     C                   GOTO      NXTBAL
     C     ENDBAL        TAG
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C     LCKEY         KLIST
     C                   KFLD                    ARCUST
     C                   KFLD                    ARINV#
     C                   KFLD                    ARSUFF
     C     LDKEY         KLIST
     C                   KFLD                    ARCUST
     C                   KFLD                    ARINV#
     C                   KFLD                    ARSUFF
     C                   KFLD                    ARYYMM
     C     STKEY         KLIST
     C                   KFLD                    STPROG
     C                   KFLD                    STCOMP
     C     MTKEY         KLIST
     C                   KFLD                    CUST
     C                   KFLD                    INV#
     C                   KFLD                    SUFF
     C                   KFLD                    SEQ
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATET            6 0
     C                   Z-ADD     LDATE         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        LDATEC            7 0
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         TDDAYS            5 0
      ** GET YYMM
     C                   MOVEL     LDATE         MM                2 0
     C                   MOVE      LDATE         YY                2 0
     C                   MOVEL     YY            YYMM              4 0
     C                   MOVE      MM            YYMM
     C     200000        ADD       YYMM          ARINV             6 0
     C                   Z-ADD     1             LCO               2 0
     C     LCO           CHAIN     FARCTL                             LR
     C     ACLCPC        DIV       100           BPCT              4 4
      ** USE 30 DAYS PER MONTH
     C     BPCT          DIV       30            WKPCT            10 9
     C                   ENDSR
** Message Array
Calculate Daily Late Charges           1
