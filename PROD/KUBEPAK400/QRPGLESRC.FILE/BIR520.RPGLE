      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.       1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES INC.,   215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR520                                     S
      *APPLICATION--------- ORDER ENTRY
      *DESCRIPTION--------- UPDATE MINVT, - OUTPUT SOHST, TINVT        RY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/25/99 EFD ADD LIST CODE TO SOHST
      *
     FFDSALEI   UF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCONT    UF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFIORDR    IF   E           K DISK
     FFHORCR    IF   E           K DISK
     FFIORCR    IF   E           K DISK
     FFSOHST    O  A E           K DISK
     FFTINVT    O  A E             DISK
     FBIR520    O    F   85        PRINTER OFLIND(*INOF)
      *
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
      **
     D IDES            DS            30    OCCURS(1) INZ
     D  DTYP                   1      4    INZ
     D  SDINV#                 5     10  0 INZ
     D  J2                    11     15    INZ(' Seq ')
     D  SDSEQ#                16     18  0 INZ
     D  J3                    19     23    INZ(' Dte ')
     D  SDTDAT                24     30  0 INZ
      *
      *
     IRHORCR
     I              OHINDT                      INDT
     IRIORCR
     I              OIRSCD                      RSCD
      *
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        RDATE             7 0
      *
     C     NXT           TAG
     C                   READ      FDSALEI                                90
     C   90              GOTO      END
      *
      * CHECK IF ALREADY POSTED AND SAME COMPANY
      *
     C     SDSOFL        IFEQ      'P'
     C     SDCOMP        ORNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
      * SELECT TYPE OF RECORD
      *
     C     SDTTYP        COMP      01                                     37
     C     SDTTYP        COMP      05                                     36
      *
      * IF TYPE IS NON-STOCK BYPASS INVENTORY SECTION
      *
     C     SDITYP        IFNE      ' '
     C     SDITYP        ANDNE     'N'
     C                   GOTO      PASS2
     C                   ENDIF
      *
      * NEW ITEM
      *
     C     SDITEM        IFNE      OITEM
     C     SDSIZE        ORNE      OSIZE
     C     SDWHSE        ORNE      OWHSE
      *
      *
     C     KEY18         KLIST
     C                   KFLD                    SDITEM
     C                   KFLD                    SDSIZE
     C                   KFLD                    SDWHSE
     C     KEY18         CHAIN     FMINVT                             50
     C   50              MOVE      *BLANKS       OITEM            12
     C   50              MOVE      *BLANKS       OSIZE             3
     C   50              MOVE      *BLANKS       OWHSE             3
     C   50              GOTO      PASS2
      *
      * MOVE INTO COMP FIELDS
      *
     C                   MOVEL     SDITEM        OITEM
     C                   MOVEL     SDSIZE        OSIZE
     C                   MOVEL     SDWHSE        OWHSE
     C                   ENDIF
     C                   Z-ADD     SDQSHP        SVQTSH                         SAVE DSALE QTY
      *
      * CONVERT QUANTITY TO PRIMARY U/M
      *
     C                   MOVE      SDUUOM        #WRFUM
     C                   Z-ADD     SDQSHP        #WRFQT
     C                   EXSR      #CVQT
     C                   Z-ADD     #WQT1         SVQTSH           11 1
      *
      * GET ORDER HEADER
     C   37              DO
     C     SDORD#        CHAIN     FHORDR                             57
     C     IORKEY        KLIST
     C                   KFLD                    SDORD#
     C                   KFLD                    SDSEQ#
     C     IORKEY        CHAIN     FIORDR                             57
     C                   ENDDO
     C   36              DO
     C     SDORD#        CHAIN     FHORCR                             57
     C     IORKEY        CHAIN     FIORCR                             57
     C                   ENDDO
      * GET SOHST COMMON FIELDS
     C                   CLEAR                   RSOHST
     C                   Z-ADD     SDCOMP        SOCOMP
     C   37              Z-ADD     SDORD#        SOORD#
     C   36              Z-ADD     SDINV#        SOORD#
     C                   Z-ADD     SDSEQ#        SOSEQ#
     C                   Z-ADD     OHCUST        SOCUST
     C   37              Z-ADD     OHDTAC        SOSHDT
     C   36              Z-ADD     OHORDY        SOSHDT
     C                   MOVEL     SDITEM        SOITEM
     C                   MOVEL     SDSIZE        SOSIZE
     C                   MOVEL     SDWHSE        SOWHSE
     C                   MOVEL     SDPCL1        SOPCL1
     C                   MOVEL     IMPCL2        SOPCL2
     C                   MOVEL     IMPCL3        SOPCL3
     C                   MOVEL     IMLIST        SOLIST
     C   37              Z-ADD     OIQORD        SOQORD
     C   36              Z-ADD     SDQSHP        SOQORD
     C                   MOVEL     SDUUOM        SOUUOM
     C                   Z-ADD     OHDTOR        SOORDT
     C   37              Z-ADD     OIDTRQ        SORQDT
     C   36              Z-ADD     OHDTOR        SORQDT
     C                   Z-ADD     SDBLCU        SOBLCU
     C                   Z-ADD     SDUPRI        SOUPRI
     C                   Z-ADD     SDQSHP        SOQSHP
     C                   Z-ADD     SDEXT$        SOEXT$
     C**                   MOVELOIDES1    SODES1
     C                   MOVEL     IMDES1        SODES1
     C                   MOVEL     SDAFIV        SOAFIV
     C                   MOVEL     OIITYP        SOITYP
     C                   MOVEL     OHALPH        SOLOOK
     C   37              Z-ADD     SDINV#        SOINV#
     C   36              Z-ADD     OHAPNO        SOINV#
     C   37              MOVEL     OHPOS         SOINTP
     C                   MOVEL     OHSHFR        SOSHFR
     C   37              MOVEL     OHSHPC        SOSHVA
     C                   Z-ADD     OHOORD        SOOORD
     C                   MOVEL     IMLOOK        SOITAL
     C                   MOVEL     OHSLM1        SOSLS1
     C                   MOVEL     OHSLM2        SOSLS2
     C                   MOVEL     OHPONO        SOPONO
     C                   MOVEL     OHSALE        SOSLID
     C     OIITYP        IFEQ      ' '
     C     OIITYP        OREQ      'N'
     C   36              MOVEL     'C'           SOTTYP
     C   37              MOVEL     'I'           SOTTYP
     C                   WRITE     RSOHST
     C                   ENDIF
      ******************************
      *  PROCESS CREDIT MEMO OPTIONS
      ******************************
     C   36SDAFIV        IFEQ      'Y'
      ** IF LOT CONTROL ITEM OUTPUT REPORT
     C     OIITYP        IFEQ      ' '
     C     IMLOTC        ANDEQ     'Y'
     C   OF              EXCEPT    HEAD
     C   OF              SETOFF                                       OF
     C                   EXCEPT    CRDET
     C                   END
      *
      * CONVERT COST TO PRIMARY U/M IF NOT CATCH WEIGHT FOR CREDIT MEMOS
      *
     C                   MOVEL     SDUUOM        #WRFUM
     C                   Z-ADD     SDUCST        #WRFPR
     C                   EXSR      #CVPR
     C                   Z-ADD     #WPR1         SVUCST            9 4          COST IN PRIMARY
      *
     C                   Z-SUB     SVQTSH        WRK190                         QTY IN PRIMARY
      *
     C                   Z-ADD     SVUCST        WRK194                         COST PER PRIMAR
      *
     C                   Z-ADD     IMQTOH        #QTY1
     C                   Z-ADD     IMQ2OH        #QTY2
     C                   Z-ADD     IMQ3OH        #QTY3
     C                   EXSR      #PRUM
     C                   EXSR      #AVGC                                        RECALC AVG COST
      *
     C                   Z-SUB     SVQTSH        SVQTSH
     C**         IMMREC    ADD  SVQTSH    IMMREC           UPDATE RECEIPTS
     C                   Z-SUB     SVQTSH        SVQTSH
      *
     C                   Z-SUB     SDQSHP        WKQTY                          SAVE QTY -TINVT
     C                   Z-SUB     SDWGSH        WKWGSH           11 4
      *  UPDATE POUNDS ON HAND
      *
     C**         IMLBS#    ADD  WKWGSH    IMLBS#
     C                   EXSR      INVTR
      *
     C***        SDLOTC    IFNE 'Y'
     C                   Z-ADD     IMQTOH        #WOH1
     C                   Z-ADD     IMQ2OH        #WOH2
     C                   Z-ADD     IMQ3OH        #WOH3
     C*
     C                   Z-SUB     SDQSHP        #WRFRQ
     C                   MOVEL     SDUUOM        #WRFUM
     C                   EXSR      #AJOH
     C                   EXSR      #RUOH
     C***                  END
     C*
      *
     C                   ENDIF
      ******************************
      * PROCESS INVOICE OPTIONS
      *****************************
     C   37              DO
      *
     C     IM#ORD        SUB       1             IM#ORD
      *
      *
     C*  37      IMLOTC    IFEQ 'Y'
     C*                    EXSR LOTUPD
     C*                    END
      *
     C                   MOVEL     SDUUOM        #WRFUM
     C                   Z-ADD     SDQSHP        #WRFRQ
     C                   Z-ADD     IMQTOH        #WOH1A
     C                   Z-ADD     IMQ2OH        #WOH2A
     C                   Z-ADD     IMQ3OH        #WOH3A
     C                   EXSR      #RDOH
     C                   Z-ADD     #WOH1A        IMQTOH                         NEW QUANTITY
     C                   Z-ADD     #WOH2A        IMQ2OH                         ON HAND
     C                   Z-ADD     #WOH3A        IMQ3OH
      *
     C                   Z-ADD     IMQTOH        #WOH1
     C                   Z-ADD     IMQ2OH        #WOH2
     C                   Z-ADD     IMQ3OH        #WOH3
      *
      *
      * UPDATE QUANTITY ALLOCATIONS
      *
     C                   Z-ADD     #WOH1         IMQTOH
     C                   Z-ADD     #WOH2         IMQ2OH
     C                   Z-ADD     #WOH3         IMQ3OH
      *
     C                   Z-ADD     SDQSHP        #WRFAL
     C                   EXSR      #ALST
      *
     C                   END
      *
     C  N36              Z-ADD     SDQSHP        WKQTY            11 1
     C  N36              Z-ADD     SDWGSH        WKWGSH
EFD01C  N36              EXSR      INVTR
     C                   Z-ADD     TDATE         IMDTLS
      *
     C     PASS2         TAG
      *
     C                   SETON                                        70
      *
      * UPDATE CONTRACT FILE
      *
     C     SDCTCD        IFEQ      'Y'                                          OF CONTRACT
     C     KEY21         KLIST
     C                   KFLD                    SDBLCU
     C                   KFLD                    SDITEM
     C                   KFLD                    SDSIZE
     C     KEY21         CHAIN     FMCONT                             98        CONTRACT
     C  N98              ADD       SVQTSH        CPSUTD
     C  N98              UPDATE    RMCONT
     C                   ENDIF
      *
     C                   MOVEL     'P'           SDSOFL
     C                   UPDATE    RDSALE
      *
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
      *
      ********************************************************************
      **      START SUBROUTINE SECTION                                   *
      *  ***********
      *  * INVTR   *
      *  ***********
      *
     C     INVTR         BEGSR
      *
     C*                    Z-ADD0         RFQTY1 111
     C*                    Z-ADD0         RFQTY2 111
     C*                    Z-ADD0         RFQTY3 111
      * IF CREDIT MEMO AND AFFECT INV. NO SKIP TINVT
      *
     C   36SDAFIV        IFEQ      'N'
     C                   GOTO      ENDINT
     C                   ENDIF
      * GET TINVT FIELDS
     C                   CLEAR                   RTINVT
     C                   MOVEL     'A'           ITSTAT
     C                   MOVEL     SDITEM        ITITEM
     C                   MOVEL     SDSIZE        ITSIZE
     C                   MOVEL     SDWHSE        ITTWSE
     C                   Z-ADD     SDCOMP        ITTCOM
     C   37              MOVEL     'I'           ITTYPE
     C   36              MOVEL     'R'           ITTYPE
     C   37              Z-ADD     OHDTAC        ITYDAT
     C   36              Z-ADD     OHORDY        ITYDAT
     C   37              Z-ADD     OHDTAC        ##MDY
     C   36              Z-ADD     OHORDY        ##MDY
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         ITTDAT
     C   37              MOVEL     'Inv  '       DTYP
     C   36              MOVEL     'Crm  '       DTYP
     C                   MOVEL     IDES          ITDESC
     C                   MOVEL     'DOP'         ITTREF
     C   37              Z-ADD     SDQSHP        ITTQTY
     C   36              Z-SUB     SDQSHP        ITTQTY
     C                   MOVEL     SDUUOM        ITTUOM
     C   36              MOVEL     'Y'           ITCMRC
     C                   Z-ADD     SDUCST        ITCOST
     C                   Z-ADD     SDUCST        ITCOAV
     C                   Z-ADD     TDATE         ITDTLA
     C                   Z-ADD     TIMOD         ITTIME
     C                   MOVEL     USERID        ITUSER
     C   36              MOVEL     'N'           ITREPO
     C                   Z-ADD     SDINV#        ITORD#
     C                   Z-ADD     SDSEQ#        ITSEQ#
     C   37              Z-ADD     OHDTAC        ITYDAT
     C   36              Z-ADD     OHORDY        ITYDAT
     C   36              MOVEL     SDRSCD        ITREAS
      *
     C                   WRITE     RTINVT                                       ADD TRANSACTION
      *
     C     ENDINT        ENDSR
      *
      *  ***********
      *  * #CVQT   *
      *  ***********
      *
      * QUANITITY CONVERSION SUBROUTINE
      * #WRFUM - CONTAINS ENTERED UNIT OF MEASURE
      * #WRFQT - CONTAINS ENTERED QUANITITY
      *
     C     #CVQT         BEGSR
     C     *LIKE         DEFINE    IMQTOH        #WQT1
     C     *LIKE         DEFINE    IMQTOH        #WQT2
     C     *LIKE         DEFINE    IMQTOH        #WQT3
     C     *LIKE         DEFINE    IMUWGT        #WQT#
     C     *LIKE         DEFINE    IMUWGT        #WQR#
     C     *LIKE         DEFINE    IMUWGT        WKWGT2
     C     *LIKE         DEFINE    IMUWGT        WKWGT3
     C     *LIKE         DEFINE    IMQTOH        #WRFQT
     C     *LIKE         DEFINE    IMPUOM        #WRFUM
      *
      *  UNIT OF MEASURE EQUAL TO PRIMARY UNIT OF MEASURE
      *
     C     #WRFUM        IFEQ      IMPUOM
      *
     C                   Z-ADD     #WRFQT        #WQT1
     C                   Z-ADD     IMUWGT        #WQR#
     C     #WRFQT        MULT(H)   IMUWGT        #WQT#
      *
     C     IMSUOM        IFNE      *BLANKS
      *
     C     #WQT1         MULT(H)   IMMULT        #WQT2
      *
     C                   END
      *
     C     IM3UOM        IFNE      *BLANKS
      *
     C     #WQT2         MULT(H)   IMMUL2        #WQT3
      *
     C                   END
      *
     C                   END
      *
      *  UNIT OF MEASURE EQUAL TO SECONDARY UNIT OF MEASURE
      *
     C     IMSUOM        IFNE      *BLANKS
     C     #WRFUM        IFEQ      IMSUOM
      *
     C     IMUWGT        DIV(H)    IMMULT        WKWGT2
     C                   Z-ADD     WKWGT2        #WQR#
     C                   Z-ADD     #WRFQT        #WQT2
     C     #WQT2         MULT(H)   WKWGT2        #WQT#
      *
     C     #WQT2         DIV(H)    IMMULT        #WQT1
      *
     C     IM3UOM        IFNE      *BLANKS
      *
     C     #WQT2         MULT(H)   IMMUL2        #WQT3
      *
     C                   END
      *
     C                   END
     C                   END
      *
      *  UNIT OF MEASURE EQUAL TO THIRD UNIT OF MEASURE
      *
     C     IM3UOM        IFNE      *BLANKS
     C     #WRFUM        IFEQ      IM3UOM
      *
     C     IMUWGT        DIV(H)    IMMULT        WKWGT2
     C     WKWGT2        DIV(H)    IMMUL2        WKWGT3
     C                   Z-ADD     WKWGT3        #WQR#
      *
     C                   Z-ADD     #WRFQT        #WQT3
     C     #WQT3         MULT(H)   WKWGT3        #WQT#
      *
     C     #WQT3         DIV(H)    IMMUL2        #WQT2
      *
     C     #WQT2         DIV(H)    IMMULT        #WQT1
      *
     C                   END
     C                   END
      *
     C                   ENDSR
0002  *
0003  *  SUBROUTINE ROLLS UP QUANTITY ON HAND TO PRIMARY UNIT OF MEASURE
0004  *  QUANTITY ON HAND IN EACH UNIT OF MEASURE NEEDS TO BE LOADED
0005  *  INTO FIELDS #WOH1, #WOH2, #WOH3
0006  *  SUBROUTINE ASSUMES AVAILABILITY OF MULTIPLIERS FROM MINVT
0007  *
0008  *  ***********
0009  *  * #RUOH   *
0010  *  ***********
0011  *
0001 C     #RUOH         BEGSR
0012  *
0013 C                   Z-ADD     0             WKRES            11 0
0014 C     *LIKE         DEFINE    IMQTOH        WKREM
0015 C     *LIKE         DEFINE    IMQTOH        #WOH1
0016 C     *LIKE         DEFINE    IMQTOH        #WOH2
0017 C     *LIKE         DEFINE    IMQTOH        #WOH3
0018  *
0019  *  DETERMINE IF QUANTITY CONSOLIDATION IS IN EFFECT
0020  *
0021 C     IMCNSF        IFEQ      'Y'
0022  *
0023 C     #WOH3         IFGE      IMMUL2
0024  *
0025 C     IMMUL2        IFNE      *ZEROS
0026  *
0027 C     #WOH3         DIV       IMMUL2        WKRES
0028 C                   MVR                     WKREM
0029 C                   Z-ADD     WKREM         #WOH3
0030 C                   ADD       WKRES         #WOH2
0031  *
0032 C                   END
0034  *
0035 C                   END
0036  *
0037 C     #WOH2         IFGE      IMMULT
0038  *
0039 C     IMMULT        IFNE      *ZEROS
0040  *
0041 C     #WOH2         DIV       IMMULT        WKRES
0042 C                   MVR                     WKREM
0043 C                   Z-ADD     WKREM         #WOH2
0044 C                   ADD       WKRES         #WOH1
0045  *
0046 C                   END
0049 C                   END
0052 C                   END
0053  *
0054 C                   ENDSR
      *
      *  ***********
      *  * #ALST   *
      *  ***********
     C     #ALST         BEGSR
      *
      *  ALLOCATE QUANITIES TO MEET ORDER REQUIREMENTS
      *  LOAD QUANTITY REQUIRED INTO FIELD #WRFAL
      *  LOAD REQUIRED IN UNIT OF MEASURE TO FIELD #WRFUM
      *  REQUIRED ALLOCATION IN ALL UNITS OF MEASURE WILL BE RETURNED IN
      *  FIELDS #WRAL1,#WRAL2,#WRAL3. THESE FIELDS CAN BE USED TO
      *  ADJUST EXISTING ALLOCATION AMOUNTS.
      *
     C     *LIKE         DEFINE    IMQTAL        #WRFAL
     C     *LIKE         DEFINE    IMQTAL        #WRAL1
     C     *LIKE         DEFINE    IMQTAL        #WRAL2
     C     *LIKE         DEFINE    IMQTAL        #WRAL3
     C                   Z-ADD     0             #WRAL1
     C                   Z-ADD     0             #WRAL2
     C                   Z-ADD     0             #WRAL3
      *
      *  UNIT OF MEASURE EQUAL TO PRIMARY UNIT OF MEASURE
      *
     C     #WRFUM        IFEQ      IMPUOM
     C                   Z-ADD     #WRFAL        #WRAL1
     C                   ENDIF
      *
      *  DETERMINE IF QUANTITY CONSOLIDATION IS IN EFFECT
      *
     C     IMCNSF        IFEQ      'Y'
      *
      *  UNIT OF MEASURE EQUAL TO SECONDARY UNIT OF MEASURE
     C     #WRFUM        ANDEQ     IMSUOM
     C     #WRFAL        DOWGE     IMMULT
     C                   ADD       1             #WRAL1
     C     #WRFAL        SUB       IMMULT        #WRFAL
     C                   ENDDO
     C                   ADD       #WRFAL        #WRAL2
     C                   ENDIF                                                  IF = SECOND
      *
      *  UNIT OF MEASURE EQUAL TO THIRD UNIT OF MEASURE
     C     #WRFUM        IFEQ      IM3UOM
     C     #WRFAL        DOWGE     IMMUL2
     C                   ADD       1             #WRAL2
     C     #WRFAL        SUB       IMMUL2        #WRFAL
     C                   ENDDO
      *
     C     #WRAL2        DOWGE     IMMULT
     C                   ADD       1             #WRAL1
     C     #WRAL2        SUB       IMMULT        #WRAL2
     C                   ENDDO
     C                   ADD       #WRFAL        #WRAL3
     C                   ENDIF                                                  IF = THIRD
      *
      *  NO CONSOLIDATION OF QUANTITIES
      *
     C     #WRFUM        IFEQ      IMSUOM
     C                   Z-ADD     #WRFAL        #WRAL2
     C                   ENDIF
     C     #WRFUM        IFEQ      IM3UOM
     C                   Z-ADD     #WRFAL        #WRAL3
     C                   ENDIF
      *
     C                   ENDSR
      *******
      * #AVGC   *
      *******
     C     #AVGC         BEGSR
      *
      *  SUBROUTINE CALCULATES AVERAGE COST - MODIFIED TO HANDLE CASH ONLY ADJ.
      *       PASS RECEIPT QUANTITY INTO A FIELD - WRK190
      *       PASS RECEIPT COST INTO A FIELD - WRK194
      *       SUBROUTINE ASSUMES ITEM MASTER RECORD TO BE UPDATED
      *       HAS ALREADY BEEN CHAINED.
      *       CASH ONLY ADJ ON NEGATIVE QTY. ON HAND YIELDS UNPREDICTABLE
      *       RESULT.
      *       NEGATIVE ON HAND FORCES COST OF RECEIPT TO BE NEW AVERAGE COST
      *       NEGATVIE QTY. ON HAND AFTER RECEIPT FORCES COST ON HAND TO ZERO
      *
     C                   Z-ADD     #PRQTY        WRKQTH           11 1
     C                   Z-ADD     WRKQTH        WRK290           11 1
     C     WRKQTH        ADD       WRK190        WRKQTH
      *
     C     WRK290        IFGT      *ZEROS
     C     WRK290        MULT      IMUCST        WR1134           13 4
     C     WRK190        MULT      WRK194        WR2134           13 4
     C     WR1134        ADD       WR2134        WR2134
     C     WRK190        ADD       WRK290        WRK290
     C     WR2134        DIV(H)    WRK290        IMUCST
     C     WRKQTH        MULT(H)   IMUCST        IMCSOH
     C                   ELSE
     C                   Z-ADD     WRK194        IMUCST
     C     WRKQTH        IFGT      *ZEROS
     C     WRKQTH        MULT(H)   IMUCST        IMCSOH
     C                   ELSE
     C                   Z-ADD     *ZEROS        IMCSOH
     C                   END
     C                   END
      *
     C                   Z-ADD     *ZEROS        WRK190           11 1
     C                   Z-ADD     *ZEROS        WRK194            9 4
      *
     C     E#AVGC        ENDSR
      *  ***********
      *  * #CVPR   *
      *  ***********
     C     #CVPR         BEGSR
      *
      * CONVERT PRICE TO PRICE IN ALTERNATE UNITS OF MEASURE
      * LOAD PRICE INTO FIELD #WRFPR
      * LOAD UNIT OF MEASURE INTO #WRFUM
      *
     C     *LIKE         DEFINE    IMSEL1        #WRFPR
     C     *LIKE         DEFINE    IMSEL1        #WPR1
     C     *LIKE         DEFINE    IMSEL1        #WPR2
     C     *LIKE         DEFINE    IMSEL1        #WPR3
      *
     C                   Z-ADD     0             #WPR1
     C                   Z-ADD     0             #WPR2
     C                   Z-ADD     0             #WPR3
      *
     C     #WRFUM        IFEQ      IMPUOM
     C                   Z-ADD     #WRFPR        #WPR1
     C     IMSUOM        IFNE      *BLANKS
     C     #WRFPR        DIV(H)    IMMULT        #WPR2
     C     IM3UOM        IFNE      *BLANKS
     C     #WPR2         DIV(H)    IMMUL2        #WPR3
     C                   END
     C                   END
     C                   END
      *
     C     #WRFUM        IFEQ      IMSUOM
     C                   Z-ADD     #WRFPR        #WPR2
     C     #WPR2         MULT(H)   IMMULT        #WPR1
     C     IM3UOM        IFNE      *BLANKS
     C     #WPR2         DIV(H)    IMMUL2        #WPR3
     C                   END
     C                   END
      *
     C     #WRFUM        IFEQ      IM3UOM
     C                   Z-ADD     #WRFPR        #WPR3
     C     #WRFPR        MULT(H)   IMMUL2        #WPR2
     C     #WPR2         MULT(H)   IMMULT        #WPR1
     C                   END
      *
     C                   ENDSR
      *  ***********
      *  * #PRUM   *
      *  ***********
     C     #PRUM         BEGSR
      *  #PRUM - PRIMARY UNIT OF MEASURE QUANTITY ROUTINE
      *  CONVERTS QUANTITIES IN ALL UNITS OF MEASURE
      *  INTO THE PRIMARY UNIT OF MEASURE.
      *  ITEM MASTER QUANTITY FIELDS MUST BE Z-ADDED INTO
      *  #QTY1, #QTY2, #QTY3 BEFORE EXECUTING SUBROUTINE.
      *  OUTPUT FIELD IS #PRQTY
      *
     C     *LIKE         DEFINE    IMQTOH        #QTY1
     C     *LIKE         DEFINE    IMQ2OH        #QTY2
     C     *LIKE         DEFINE    IMQ3OH        #QTY3
     C     *LIKE         DEFINE    IMQTOH        #PRQTY
     C     *LIKE         DEFINE    IMQTOH        #WK1
     C     *LIKE         DEFINE    IMQTOH        #WK2
      *
     C                   Z-ADD     *ZEROS        #WK1
     C                   Z-ADD     *ZEROS        #WK2
      *
     C                   Z-ADD     #QTY1         #PRQTY
      *
     C     #QTY3         IFNE      *ZEROS
     C     IMMUL2        IFNE      *ZEROS
      *
     C     #QTY3         DIV(H)    IMMUL2        #WK2
     C     #WK2          ADD       #QTY2         #QTY2
      *
     C                   END
     C                   END
      *
     C     #QTY2         IFNE      *ZEROS
     C     IMMULT        IFNE      *ZEROS
      *
     C     #QTY2         DIV(H)    IMMULT        #WK1
      *
     C                   END
     C                   END
      *
     C                   ADD       #WK1          #PRQTY
      *
     C                   ENDSR
      *
      *  ***********
      *  * #RDOH   *
      *  ***********
      *
     C     #RDOH         BEGSR
      *
      *  ROLL DOWN QUANTITY ON HAND TO MEET QUANTITY REQUIREMENT
      *  LOAD QUANTITY REQUIRED INTO FIELD #WRFRQ
      *  LOAD REQUIRED IN UNIT OF MEASURE TO FIELD #WRFUM
     C     *LIKE         DEFINE    IMQTOH        #WRFRQ
     C     *LIKE         DEFINE    IMQTOH        #WOH1A
     C     *LIKE         DEFINE    IMQTOH        #WOH2A
     C     *LIKE         DEFINE    IMQTOH        #WOH3A
      *
     C     #WRFUM        IFEQ      IMPUOM
     C     #WOH1A        SUB       #WRFRQ        #WOH1A
     C                   END
      *
      *  DETERMINE IF QTY. CONSOLIDATION IS ACTIVE
      *
     C     IMCNSF        IFEQ      'Y'
      *
     C     #WRFUM        IFEQ      IMSUOM
      *
     C     #WOH2A        DOWLT     #WRFRQ
     C                   ADD       IMMULT        #WOH2A
     C                   SUB       1             #WOH1A
     C                   END
      *
     C     #WOH2A        SUB       #WRFRQ        #WOH2A
      *
     C                   END
      *
     C     #WRFUM        IFEQ      IM3UOM
      *
     C     #WOH3A        DOWLT     #WRFRQ
     C                   ADD       IMMUL2        #WOH3A
     C     #WOH2A        DOWLT     1
     C                   ADD       IMMULT        #WOH2A
     C                   SUB       1             #WOH1A
     C                   END
     C                   SUB       1             #WOH2A
     C                   END
      *
     C     #WOH3A        SUB       #WRFRQ        #WOH3A
      *
     C                   END
      *
     C                   ELSE
      *
      *  QUANTITY CONSOLIDATION NOT IN EFFECT
      *
     C     #WRFUM        IFEQ      IMSUOM
     C     #WOH2A        SUB       #WRFRQ        #WOH2A
     C                   END
     C     #WRFUM        IFEQ      IM3UOM
     C     #WOH3A        SUB       #WRFRQ        #WOH3A
     C                   END
      *
     C                   END
     C                   ENDSR
0002  *
0003  *  ***********
0004  *  * #AJOH   *
0005  *  ***********
0006  *
0007 C     #AJOH         BEGSR
0001  *  ADD TO ON HAND FIELD FOR A GIVEN QUANTITY AND UNIT OF MEASURE
0014  *
0015 C     #WRFUM        IFEQ      IMPUOM
0016 C                   ADD       #WRFRQ        #WOH1
0017 C                   END
0018 C     #WRFUM        IFEQ      IMSUOM
0019 C                   ADD       #WRFRQ        #WOH2
0020 C                   END
0021 C     #WRFUM        IFEQ      IM3UOM
0022 C                   ADD       #WRFRQ        #WOH3
0023 C                   END
0025  *
0026 C                   ENDSR
      *                                                                ***
     OBIR520    E            HEAD           1 03
     O                                            6 'BIR520'
     O                                           60 'Lot Items NOT Posted to'
     O                                           66 'a Lot'
     O                       PAGE          4     82
     O                                           79 'Page:'
     O          E            HEAD           2
     O                       TIMOD                8 '  :  :  '
     O                       TDATE         Y     82
     O          E            HEAD           1
     O                                           11 'Type       '
     O                                           18 'Number'
     O                                           23 'Item'
     O                                           30 'Size'
     O                                           75 'Quantity'
     O                                           42 'Description'
     O          EF           CRDET          1
     O                                           11 'Credit Memo'
     O                       SDINV#        4     18
     O                       SDITEM              26
     O                       SDSIZE              30
     O                       SDQSHP        J     75
     O                       IMDES1              61
     O*       EF 1             INVDET
     O*                                  11 'Invoice    '
     O*                        SDINV#4   18
     O*                        SDITEM    26
     O*                        SDSIZE    30
     O*                        LOTQTYJ   75
     O*                        IMDES1    61
