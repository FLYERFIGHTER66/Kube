      *--------------------------------------------------------------
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- QPKLCUPT
      **APPLICATION--------- DAILY LATE CHARGE UPDATE OF AROPEN
      *
      *
     FFARLC     IP   E           K DISK
     FFAROPN    UF A E           K DISK
     FFMCUST    IF   E           K DISK
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
     D                UDS
     D  LDATE                  1      6  0                                      ARC380
      ****************
      * START HERE   *
      ****************
     C     ARCUST        CHAIN     FMCUST                             90
     C     *IN90         IFEQ      *OFF
     C                   MOVEL     'LC'          ARSUFF
     C     LCKEY         CHAIN     FAROPN                             75
      ** NOW GET DAILY AMOUNT
     C  N75              DO
     C* no not this      Z-ADD     ARLCDU        ARDUE$
     C                   Z-ADD     ARLCAM        AR$AMT
     C* no not this      Z-ADD     ARLCPD        ARPAID
     C                   UPDATE    RAROPN
     C                   ENDDO                                                   N75  DO
     C   75              DO
      *? Only post to A/R if there is a balance Due.
     C                   If        ARLCDU <> 0
     C                   Eval      ARSTAT = 'L'                                 ?STATUS
     C*                  Eval      ARCUST = Implied                             ?AR CUST. NUMBER
     C*                  Eval      ARINV# = Implied                             ?INV #
     C*                  Eval      ARSUFF = Implied                             ?SUFFIX
     C                   Eval      ARSEQ# = 0                                   ?SEQ #
     C                   Eval      ARCTYP = CMCTYP                              ?CUST TYPE
     C                   Reset                   ARSLM1                         ?SLSPERSON 1
     C                   Reset                   ARCOM1                         ?COMM 1
     C                   Reset                   ARSLM2                         ?SLSPERSON 2
     C                   Reset                   ARCOM2                         ?COMM 2
     C                   Reset                   ARTERR                         ?TERRITORY
     C                   Eval      ARCOMP = 1                                   ?COMPANY NUMBER
     C                   Eval      ARTTYP = 7                                   ?TRANS TYPE
     C                   Eval      ARTDAT = LDATEC                              ?TRANS DATE CYMD
     C                   Eval      ARDUDT = LDATEC                              ?INV DUE DATE CYMD
     C                   Eval      AR$AMT = ARLCAM                              ?INV,O/A,C/M,L/C AMT
     C                   Eval      ARDISC = *Zero                               ?DISCOUNT AMOUNT
     C                   Eval      ARDTAK = *Zero                               ?DISCOUNT TAKEN
     C                   Eval      ARADJ$ = *Zero                               ?ADJ AMOUNT
     C                   Eval      ARPAID = ARLCPD                              ?AMOUNT PAID
     C                   Eval      ARDUE$ = ARLCDU                              ?REMAINING DUE
     C                   Reset                   ARCHEK                         ?CHECK NO.
     C                   Reset                   ARCKDT                         ?CHECK DATE CYMD
     C                   Reset                   ARGLAC                         ?G/L ACCT
     C                   Eval      ARDESC = MSG(1)                              ?DESC
     C                   Eval      ARDTLA = TDATE                               ?LAST ACT. DATE
     C                   Eval      ARTIME = TIMOD                               ?TIME
     C                   Eval      ARUSER = USERID                              ?USER
     C                   Reset                   ARDCDT                         ?CASH DISC. DUE DATE
     C                   Reset                   ARORD#                         ?ORDER #
     C                   Eval      ARLOOK = CMLOOK                              ?CUST ALPHA
     C                   Eval      ARSHCU = CMCUST                              ?SHIP TO CUST
     C                   Eval      ARSACU = CMSACU                              ?S/A CUST
     C                   Eval      ARBLCU = CMBLCU                              ?BILL TO CUST
     C                   Reset                   ARPONO                         ?CUST P.O. #
     C                   Reset                   ARCRCD                         ?CREDIT CARD
     C                   Reset                   ARCRC#                         ?CREDIT CARD #
     C                   Reset                   ARCRCE                         ?C.C. EXPIRE
     C                   Reset                   ARCRCA                         ?C.C. APPROVAL
     C                   Reset                   ARPRST                         ?PRINT ON STMNT Y/N
     C                   Reset                   ARSHP#                         ?SHIPMENT #
     C                   Reset                   ARREAS                         ?REASON CODE
     C                   Reset                   ARTAXJ                         ?TAX JURISDICTION
     C                   Reset                   ARSHFR                         ?SHIP FROM
     C                   Reset                   ARPOS                          ?POS CODE
     C                   Reset                   ARSINV                         ?OA INV #
     C                   Reset                   ARSSUF                         ?OA SUFFIX
     C                   Reset                   ARBKCD                         ?BANK CODE
    ?C                   WRITE     RAROPN
     C                   ENDIF                                                   75  DO
     C                   ENDDO                                                   75  DO
     C                   ENDIF                                                   75  DO
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C     LCKEY         KLIST
     C                   KFLD                    ARCUST
     C                   KFLD                    ARINV#
     C                   KFLD                    ARSUFF
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
     C                   Z-ADD     1             LCO               2 0
     C                   ENDSR
** Message Array
Calculate Daily Late Charges           1
