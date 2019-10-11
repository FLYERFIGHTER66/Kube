      *--------------------------------------------------------------
      **********************************************************
      * IF YOU MAKE CHANGES CHECK MAR020 IT RE-PRINTS MANIFEST
      **********************************************************
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      *PROGRAM NAME-------- MAR010
      *SYSTEM-------------- ORDER ENTRY/BILLING
      *APPLICATION--------- PRINT BROKER INVOICE MANIFEST PRINT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 10/10/01 EFD ADD P.O. # TO INVOICE LINE.
      *
     FFMCUST    IF   E           K DISK
     FFHORDWC   IF   E           K DISK
     FFHORCWI   IF   E           K DISK
     FFINMAN    UF A E           K DISK
     FFINMANDI  IF   E           K DISK
     F                                     RENAME(RINMAND:MAND)
     FFINMAND   O  A E           K DISK
     FMAR010    O    F   80        PRINTER OFLIND(*INOF)
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
      ****************
      *   LDA        *
      ****************
     D                UDS
      * COMPANY
     D  LCO                    1      2  0
      * REPRINT Y/N
     D  LDARPT                 3      3
      * BEGINING DATE
     D  BEGDAT                 5     10  0
      * ENDING DATE
     D  ENDDAT                11     16  0
      * BROKER NUMBER
     D  CUSTNO                17     22  0
      * PRINTER ID
     D  LPRTR                100    109
      * FORMS NUMBER
     D  LFORM                110    119
      * NUMBER OF COPIES
     D  LCOPY                120    121  0
      * JOB Q Y/N
     D  LJOBQ                122    122
      * HOLD PRINT OUTPUT
     D  LHOLD                123    126
      * PRINT AND SAVE OUTPUT
     D  LSAVE                127    130
      * CANCEL  X=CANCEL
     D  LCANCL               133    133
      *
      *******************
      * START HERE      *
      *******************
     C     CUSTNO        SETLL     FMCUST
     C     NXT           TAG
     C                   READ      FMCUST                                 90
     C   90              GOTO      END
     C     CMCUST        IFNE      CMARCU
     C     CMSTAT        OREQ      'D'
     C     CMJOBR        ORNE      'Y'
     C     CUSTNO        ANDEQ     0
     C                   GOTO      NXT
     C                   END
      * SET UP TO PRINT
     C                   Z-ADD     0             PAGE
     C                   SETON                                        OF
      * SEE IF WE ALREADY HAVE A MANIFEST
     C     MANKEY        KLIST
     C                   KFLD                    CMCUST
     C                   KFLD                    MANCYM
     C     MANKEY        CHAIN     FINMAN                             51
     C   51              DO
     C                   CLEAR                   RINMAN
     C                   Z-ADD     CMCUST        INCUST
     C                   Z-ADD     MANCYM        INMAN#
     C                   ENDDO                                                  51 DO
      ** EITHER WAY ZERO TOTALS WE WILL RECALC
     C                   Z-ADD     0             ININV$
     C                   Z-ADD     0             IN#INV
     C                   Z-ADD     0             IN#CRM
     C                   Z-ADD     BEGCYM        INBEGD
     C                   Z-ADD     ENDCYM        INENDD
      ** GET INVOICES
     C                   EXSR      GETINV
      ** GET CREDITS
     C                   EXSR      GETCRM
      ** SEE IF WE NEED RECORD
     C     IN#INV        IFEQ      0
     C     IN#CRM        ANDEQ     0
     C  N51              DELETE    RINMAN
     C                   ELSE
     C   51              WRITE     RINMAN
     C  N51              UPDATE    RINMAN
     C     IN#INV        ADD       IN#CRM        TOT#              5 0
     C                   EXCEPT    TOTL
     C                   END                                                    INV+CRM=0
      ** GOTO NXT CUST
     C     CUSTNO        IFLE      0
     C                   GOTO      NXT
     C                   END
      *
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** GET INVOICES      **
      ***********************
     C     GETINV        BEGSR
     C     CMCUST        SETLL     FHORDWC
     C     NXTINV        TAG
     C     CMCUST        READE     FHORDWC                                91
     C  N91              DO
     C                   Z-ADD     WHINDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##CYMD        IFGE      BEGCYM
     C     ##CYMD        ANDLE     ENDCYM
     C     DIIKEY        KLIST
     C                   KFLD                    WHINV#
     C                   KFLD                    SUFF
     C                   MOVE      *BLANKS       SUFF              2
     C     DIIKEY        CHAIN     FINMANDI                           52
     C  N52IDCUST        IFEQ      CMCUST
     C     IDMAN#        ANDNE     MANCYM
     C                   GOTO      NXTINV
     C                   END
     C   OF              DO
     C**         PAGE      IFLE 0
     C**                   EXCPTHEAD1
     C**                   END
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    DETL
     C                   ADD       1             IN#INV
     C                   ADD       WH$AMT        ININV$
     C   52              DO
     C                   Z-ADD     CMCUST        IDCUST
     C                   Z-ADD     MANCYM        IDMAN#
     C                   Z-ADD     WHINV#        IDINV#
     C                   Z-ADD     WHINDT        IDINVD
     C                   MOVE      *BLANKS       IDSUFF
     C                   Z-ADD     WH$AMT        IDINV$
     C                   WRITE     RINMAND
     C                   ENDDO                                                  52  DO
     C                   END                                                    DATE RANGE
     C                   GOTO      NXTINV
     C                   ENDDO                                                  N92  DO
     C                   ENDSR
      ***********************
      ** GET CREDITS       **
      ***********************
     C     GETCRM        BEGSR
     C     CMCUST        SETLL     FHORCWI
     C     NXTCRM        TAG
     C     CMCUST        READE     FHORCWI                                91
     C  N91              DO
     C     CHORDY        IFGE      BEGCYM
     C     CHORDY        ANDLE     ENDCYM
     C     DICKEY        KLIST
     C                   KFLD                    CHCRM#
     C                   KFLD                    SUFF
     C                   MOVEL     'CM'          SUFF              2
     C     DICKEY        CHAIN     FINMANDI                           52
     C  N52IDCUST        IFEQ      CMCUST
     C     IDMAN#        ANDNE     MANCYM
     C                   GOTO      NXTCRM
     C                   END
     C   OF              DO
     C**         PAGE      IFLE 0
     C**                   EXCPTHEAD1
     C**                   END
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    DETLC
     C                   ADD       1             IN#CRM
     C                   ADD       CHTOT$        ININV$
     C   52              DO
     C                   Z-ADD     CMCUST        IDCUST
     C                   Z-ADD     MANCYM        IDMAN#
     C                   Z-ADD     CHCRM#        IDINV#
     C                   Z-ADD     CHDTOR        IDINVD
     C                   MOVEL     'CM'          IDSUFF
     C                   Z-ADD     CHTOT$        IDINV$
     C                   WRITE     RINMAND
     C                   ENDDO                                                  52  DO
     C                   END                                                    DATE RANGE
     C                   GOTO      NXTCRM
     C                   ENDDO                                                  N92  DO
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      * GET MANIFEST DATE
     C                   Z-ADD     ENDDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        MANCYM            7 0
      * GET BEGDATE  CYMD
     C                   Z-ADD     BEGDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        BEGCYM            7 0
      * GET ENDDATE  CYMD
     C                   Z-ADD     ENDDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ENDCYM            7 0
     C                   ENDSR
      *
      ******************
      * OUTPUT SPECS   *
      ******************
     OMAR010    E            HEAD           2 03
     O                       CMNAME              35
     O                                           51 'Manifest Number:'
     O                       MANCYM        4     59
     O                       PAGE          4     80
     O                                           77 'Page:'
     O          E            HEAD           2
     O                                           26 'Invoices dated from -'
     O                       BEGDAT        Y     35
     O                                           42 'Thru -'
     O                       ENDDAT        Y     51
     O                                           73 'Customer #:'
     O                       CMCUST        4     80
     O          E            HEAD           0
     O                                           10 'Date  '
     O                                           17 'Number'
     O                                           29 'P.O. Number'
     O                                           48 'Amount '
     O                                           62 'Ship To Name'
     O          E            HEAD           1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O          EF           DETL           1
     O                       WHINDT        Y     10
     O                       WHINV#        4     17
     O                       WHPONO              33
     O                       WH$AMT        J     48
     O                       WHNAME              79
     O          EF           DETLC          1
     O                       CHDTOR        Y     10
     O                       CHCRM#        4     17
     O                       CHTOT$        J     48
     O                       CHNAME              79
     O          EF           TOTL           1
     O                                           48 '=========='
     O          EF           TOTL           2
     O                       ININV$        J     48
     O                                           24 'Total Dollars====>'
     O                                           71 'Number of Items===>'
     O                       TOT#          4     77
     O          EF           TOTL           1
     O                                           28 'Please sign on this line'
     O                                           44 'and fax back to'
     O          EF           TOTL           1
     O                                           23 'us at 609-259-0487'
     O                                           42 'Attention: Darren.'
     O                                           77 '__________________________'
