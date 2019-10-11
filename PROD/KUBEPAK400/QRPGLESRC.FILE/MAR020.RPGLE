      *--------------------------------------------------------------
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
      *PROGRAM NAME-------- MAR022
      *SYSTEM-------------- ORDER ENTRY/BILLING
      *APPLICATION--------- PRINT BROKER INVOICE MANIFEST INQUIRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 10/10/01 EFD ADD P.O. # TO INVOICE LINE.
      *
     FMAR020FM  CF   E             WORKSTN
     F                                     SFILE(MANSFL:RECNO)
     F                                     SFILE(INVSFL:RECN1)
     F                                     SFILE(OPNSFL:RECNO)
     FFMCUST    IF   E           K DISK
     FFINMANR   IF   E           K DISK
     F                                     RENAME(RINMAN:INMAN)
     FFINMAND   IF   E           K DISK
     FFHORDW    IF   E           K DISK
     FFHORCW    IF   E           K DISK
     FFINMAN    UF   E           K DISK
     FMAR020    O    F  132        PRINTER OFLIND(*INOF)
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(5) CTDATA PERRCD(1)              MESSAGE
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
      * GET CUSTOMER
     C     RSTART        TAG
     C                   SETOFF                                       1011
     C                   SETOFF                                       2021
     C                   Z-ADD     0             CUSTNO
     C                   MOVE      *BLANKS       LCANCL
     C                   MOVE      *BLANKS       ALPHA
     C                   MOVE      *BLANKS       CMNAME
     C                   EXSR      BLDSFL
     C     NXTA          TAG
     C                   EXFMT     MANCTL
      ** CHECK F KEYS
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
     C   KF              GOTO      RSTART
     C   KB              EXSR      OPEN
     C     LCANCL        IFEQ      'X'
     C                   GOTO      END
     C                   END
      ** RESET IND
     C                   SETOFF                                       101121
      ** CHECK SUBFILE
     C                   EXSR      CHKSFL
      ** CHECK CUSTOMER
     C     ALPHA         IFGT      *BLANKS
     C     CUSTNO        ANDLE     0
     C                   MOVEL     ALPHA         CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       ALPHA
     C                   MOVEL     CMCUST        CUSTNO
     C**                   GOTO NXTA
     C                   END
     C     CUSTNO        IFLE      0
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
     C     CUSTNO        CHAIN     FMCUST                             10
     C   10              GOTO      NXTA
     C**         CMJOBR    IFNE 'Y'
     C     CMCUST        IFNE      CMARCU
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   END
      *
     C                   EXSR      BLDSFL
     C                   GOTO      NXTA
      *
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD MAN SUB FILE *
      ***********************
     C     BLDSFL        BEGSR
     C                   MOVE      '1'           *IN(80)
     C                   WRITE     MANCTL
     C                   MOVE      '0'           *IN(80)
     C                   Z-ADD     0             RECNO             5 0
     C                   SETOFF                                       55
     C     CUSTNO        SETLL     FINMANR
     C     NXTBLD        TAG
     C     CUSTNO        READE     FINMANR                                90
     C   90              GOTO      ENDBLD
      ** GET INTO SCREEN FIELDS
     C                   MOVE      *BLANKS       SELECT
     C                   Z-ADD     ININV$        INV$
     C     IN#INV        ADD       IN#CRM        TOTITM
     C                   Z-ADD     INBEGD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         BEGDAT
     C                   Z-ADD     INENDD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         ENDDAT
     C                   Z-ADD     INMAN#        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         MANDAT
     C     INACKD        IFGT      0
     C                   Z-ADD     INACKD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         ACKDAT
     C                   ELSE
     C                   Z-ADD     0             ACKDAT
     C                   END
     C                   ADD       1             RECNO
     C                   WRITE     MANSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   MOVE      *BLANKS       SELECT
     C                   Z-ADD     0             INMAN#
     C                   Z-ADD     0             INV$
     C                   Z-ADD     0             TOTITM
     C                   Z-ADD     0             BEGDAT
     C                   Z-ADD     0             ENDDAT
     C                   Z-ADD     0             MANDAT
     C                   Z-ADD     0             ACKDAT
     C                   MOVE      *BLANKS       INNAME
     C                   MOVE      '* END *'     INNAME
     C                   ADD       1             RECNO
     C                   SETON                                        55
     C                   WRITE     MANSFL
     C                   SETOFF                                       55
     C                   ENDSR
      ***********************
      ** CHECK MAN SUB FILE *
      ***********************
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       2021
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C                   SETOFF                                       20
     C     RECNO         IFLE      LSTREC
     C     RECNO         CHAIN     MANSFL                             91
     C   91              GOTO      NXTCHK
     C     SELECT        IFEQ      *BLANKS
     C                   GOTO      NXTCHK
     C                   END
     C     SELECT        IFLT      '1'
     C     SELECT        ORGT      '3'
     C                   SETON                                        2021
     C                   UPDATE    MANSFL
     C                   GOTO      NXTCHK
     C                   END
     C     SELECT        IFEQ      '1'
     C                   EXSR      GETACK
     C                   UPDATE    MANSFL
     C                   GOTO      NXTCHK
     C                   END
     C     SELECT        IFEQ      '2'
     C                   EXSR      INVBLD
     C  NKC
     CANNKG
     CANNKF              UPDATE    MANSFL
     C  NKC
     CANNKG
     CANNKF              GOTO      NXTCHK
     C                   END
     C     SELECT        IFEQ      '3'
     C                   EXSR      REPRNT
     C                   UPDATE    MANSFL
     C                   GOTO      NXTCHK
     C                   END
     C                   GOTO      NXTCHK
     C                   END                                                    RECNO<LSTREC
     C                   ENDSR
      ***********************
      ** BUILD INV SUB FILE *
      ***********************
     C     INVBLD        BEGSR
     C                   MOVE      '1'           *IN(80)
     C                   WRITE     INVCTL
     C                   MOVE      '0'           *IN(80)
     C                   Z-ADD     0             RECN1             5 0
     C                   Z-ADD     0             INVTOT            9 2
     C                   SETOFF                                       55
     C     MANKEY        CHAIN     FINMAND                            90
     C     MANKEY        SETLL     FINMAND
     C     NXTINV        TAG
     C     MANKEY        READE     FINMAND                                90
     C   90              GOTO      ENDINV
      ** GET INTO SCREEN FIELDS
     C     IDSUFF        IFEQ      'CM'
     C     IDINV#        CHAIN     FHORCW                             91
     C                   MOVEL     CHNAME        SHNAME
     C                   MOVEL     'CM'          TYPE
     C                   ELSE
     C     IDINV#        CHAIN     FHORDW                             91
     C                   MOVEL     WHNAME        SHNAME
     C                   MOVEL     'IN'          TYPE
     C                   END
     C   91              MOVEL     MSG(1)        SHNAME
     C                   Z-ADD     IDINV$        INV$
     C                   ADD       1             RECN1
     C                   ADD       INV$          INVTOT
     C                   WRITE     INVSFL
     C                   GOTO      NXTINV
     C     ENDINV        TAG
     C                   Z-ADD     0             IDINVD
     C                   Z-ADD     0             IDINV#
     C                   Z-ADD     INVTOT        INV$
     C                   MOVE      *BLANKS       IDSUFF
     C                   MOVE      *BLANKS       TYPE
     C                   MOVEL     MSG(2)        SHNAME
     C                   ADD       1             RECN1
     C                   WRITE     INVSFL
     C     NXTIFM        TAG
     C                   EXFMT     INVCTL
     C   KK              DO                                                     VIEW INVOICEPLAY
     C     LINE          IFLE      0
     C                   GOTO      NXTIFM
     C                   END
     C     LINE          CHAIN     INVSFL                             77
     C   77              GOTO      NXTIFM
     C                   MOVEL     TYPE          TYPO              2
     C                   Z-ADD     IDINV#        INVINI           15 5
     C                   CALL      'BIR337CL'
     C                   PARM                    INVINI
     C                   PARM                    TYPO
     C                   GOTO      NXTIFM
     C                   ENDDO
     C  NKC
     CANNKG
     CANNKF              GOTO      NXTIFM
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C                   ENDSR
      ***********************
      ** GET ACKNOWLEDGE   **
      ***********************
     C     GETACK        BEGSR
     C                   SETOFF                                       1098
     C     MANKEY        KLIST
     C                   KFLD                    INCUST
     C                   KFLD                    INMAN#
     C     MANKEY        CHAIN     FINMAN                             88
     C     NXTACK        TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNACK
     C                   READ      SCRNACK                                90
     C                   SETOFF                                       10
     C   KF              GOTO      ENDACK
     C     ACKDAT        IFGT      0
     C                   Z-ADD     ACKDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      '1'
     C                   SETON                                        1099
     C                   GOTO      NXTACK
     C                   END                                                    ##ERR=Y
     C                   Z-ADD     ##CYMD        INACKD
     C                   ELSE
     C                   Z-ADD     0             INACKD
     C                   END                                                    ACKDAT>0
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTACK
     C                   ENDDO
     C                   UPDATE    RINMAN
     C     ENDACK        ENDSR
      ***********************
      ** REPRINT MANIFEST  **
      ***********************
     C     REPRNT        BEGSR
     C                   Z-ADD     0             TOT#              5 0
     C                   Z-ADD     0             TINV$             9 2
     C                   Z-ADD     0             PAGE
     C     INCUST        CHAIN     FMCUST                             92
     C     MANKEY        CHAIN(N)  FINMAN                             88
     C                   Z-ADD     INBEGD        ##CYMD
     C                   SETON                                        OF
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         BEGDAT
     C                   Z-ADD     INENDD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         ENDDAT
     C                   Z-ADD     INBEGD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         BEGDAT
     C                   Z-ADD     INENDD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         ENDDAT
     C     MANKEY        SETLL     FINMAND
     C     NXTPRT        TAG
     C     MANKEY        READE     FINMAND                                90
     C   90              GOTO      ENDPRT
      ** GET INTO SCREEN FIELDS
     C     IDSUFF        IFEQ      'CM'
     C     IDINV#        CHAIN     FHORCW                             91
     C                   MOVEL     CHNAME        SHNAME
     C                   ELSE
     C     IDINV#        CHAIN     FHORDW                             91
     C                   MOVEL     WHNAME        SHNAME
     C                   END
     C   91              MOVEL     MSG(1)        SHNAME
     C                   Z-ADD     IDINV$        INV$
     C                   ADD       1             TOT#
     C                   ADD       INV$          TINV$
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   END
     C                   EXCEPT    DETL
     C                   GOTO      NXTPRT
     C     ENDPRT        TAG
     C                   EXCEPT    TOTL
     C                   ENDSR
      ***********************
      ** GET OPEN MANIFESTS *
      ***********************
     C     OPEN          BEGSR
     C     RSTOPN        TAG
     C                   EXSR      BLDOPN
     C                   EXFMT     OPNCTL
      **
     C  NKC
     CANNKG
     CANNKF              EXSR      CHKOPN
     C  NKC
     CANNKG
     CANNKF              GOTO      RSTOPN
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C                   ENDSR
      ************************
      ** BUILD OPEN SUB FILE *
      ************************
     C     BLDOPN        BEGSR
     C                   MOVE      '1'           *IN(80)
     C                   WRITE     OPNCTL
     C                   MOVE      '0'           *IN(80)
     C                   Z-ADD     0             RECNO             5 0
     C                   SETOFF                                       55
     C                   Z-ADD     0             CUSTNO
     C     CUSTNO        SETLL     FINMANR
     C     NXTOPB        TAG
     C                   READ      FINMANR                                90
     C   90              GOTO      ENDOPB
      ** CHECK IF OPEN
     C     INACKD        IFGT      0
     C                   GOTO      NXTOPB
     C                   END
      ** GET INTO SCREEN FIELDS
     C                   MOVE      *BLANKS       SELECT
     C     INCUST        CHAIN     FMCUST                             91
     C                   Z-ADD     ININV$        INV$
     C     IN#INV        ADD       IN#CRM        TOTITM
     C                   Z-ADD     INMAN#        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         MANDAT
     C                   ADD       1             RECNO
     C                   WRITE     OPNSFL
     C                   GOTO      NXTOPB
     C     ENDOPB        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   MOVE      *BLANKS       SELECT
     C                   Z-ADD     0             INMAN#
     C                   Z-ADD     0             INV$
     C                   Z-ADD     0             TOTITM
     C                   Z-ADD     0             BEGDAT
     C                   Z-ADD     0             ENDDAT
     C                   Z-ADD     0             MANDAT
     C                   Z-ADD     0             ACKDAT
     C                   Z-ADD     0             CMPHON
     C                   MOVE      *BLANKS       CMNAME
     C                   MOVEL     MSG(3)        CMNAME
     C                   ADD       1             RECNO
     C                   SETON                                        55
     C                   WRITE     OPNSFL
     C                   SETOFF                                       55
     C                   ENDSR
      ************************
      ** CHECK OPEN SUB FILE *
      ************************
     C     CHKOPN        BEGSR
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       2021
     C     NXTOPC        TAG
     C                   ADD       1             RECNO
     C                   SETOFF                                       20
     C     RECNO         IFLE      LSTREC
     C     RECNO         CHAIN     OPNSFL                             91
     C   91              GOTO      NXTOPC
     C     SELECT        IFEQ      *BLANKS
     C                   GOTO      NXTOPC
     C                   END
     C     SELECT        IFLT      '1'
     C     SELECT        ORGT      '3'
     C                   SETON                                        2021
     C                   UPDATE    OPNSFL
     C                   GOTO      NXTOPC
     C                   END
     C     SELECT        IFEQ      '1'
     C                   EXSR      GETACK
     C                   UPDATE    OPNSFL
     C                   GOTO      NXTOPC
     C                   END
     C     SELECT        IFEQ      '2'
     C                   EXSR      INVBLD
     C  NKC
     CANNKG              UPDATE    OPNSFL
     C  NKC
     CANNKG              GOTO      NXTOPC
     C                   END
     C     SELECT        IFEQ      '3'
     C                   EXSR      REPRNT
     C                   UPDATE    OPNSFL
     C                   GOTO      NXTOPC
     C                   END
     C                   GOTO      NXTOPC
     C                   END                                                    RECNO<LSTREC
     C                   SETOFF                                       KCKFKG
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
      *
      ******************
      * OUTPUT SPECS   *
      ******************
     OMAR020    E            HEAD           2 03
     O                       CMNAME              35
     O                                           51 'Manifest Number:'
     O                       INMAN#        4     59
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
     O                       IDINVD        Y     10
     O                       IDINV#        4     17
     O                       WHPONO         B    33
     O                       IDINV$        J     48
     O                       SHNAME              79
     O          EF           TOTL           1
     O                                           48 '=========='
     O          EF           TOTL           2
     O                       ININV$        J     48
     O                                           24 'Total Dollars====>'
     O                                           71 'Number of Items===>'
     O                       TOT#          4     77
     O          EF           TOTL           1
     O                                           28 'Please sign on this line'
     O                                           50 'and fax back to: 609-'
     O                                           70 '259-0487 Att: Darren'
     O                                           85 '_______________'
      *
** Message
Ship to Un-Known                                 1
  * End Of Invoices/Credits *                    2
  * End Of Open Manifests *                      3
