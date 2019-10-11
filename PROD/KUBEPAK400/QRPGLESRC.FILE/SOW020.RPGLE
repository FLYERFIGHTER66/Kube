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
      **PROGRAM NAME-------- SOW020
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- BUILD FILE FOR SOW LINE
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 12/10/01 EFD ADD REPORT
      *  2/22/02 EFD SKIP BACK ORDER RECORDS
      *  2/22/02 EFD USE PROD. CLASS 50-60 ONLY.
      *
      *
      *  80=NEW RUN  81=UPDATE
      *
     FFMINVT    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFPTABLE   IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFCALEN    IF   E           K DISK
     FFIORDRSP  IF   E           K DISK
     F                                     RENAME(RIORDR:IORDR)
     FFIORDISA  IF   E           K DISK
     FFJOBNM    UF A E           K DISK
     FFSOWSCH   UF A E           K DISK
     FFSOWSCHJ  UF   E           K DISK
     F                                     RENAME(RSOWSCH:SOWSCH)
     FSOW020    O    F  120        PRINTER OFLIND(*INOF)

WJB ?D  Item           S                   Like(IMITEM)
WJB ?D  Size           S                   Like(IMSIZE)
WJB ?D  Table          S                   Like(IMFTAB)
WJB ?D  Order          S              7S 1
WJB ?D  ToSow          S              7S 1

      ** PTABLE ARRAYS
     D PMN             S              7  0 DIM(12)                              MINIMUM
     D PMX             S              7  0 DIM(12)                              MAXIMUM
     D PUN             S              5  0 DIM(12)                              FACTOR UNITS
     D PPC             S              5  2 DIM(12)                              FACTOR %
      *
      ** MESSAGE ARRAY
     D MSG             S             30    DIM(5) CTDATA PERRCD(1)              MESSAGES
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
      ************
      *  LDA     *
      ************
     D                UDS
      ** LDA SPECS HAVE TO CONFORM TO QPK212
      ** SOW DATE
     D  PLDATE                11     16  0
      * PRINT ALL OR ONLY CHANGES  A/C
     D  PRTALL                99     99
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
      *
     IRPTABLE
     I              PTBQ01                      PMN(1)
     I              PTBQ02                      PMN(2)
     I              PTBQ03                      PMN(3)
     I              PTBQ04                      PMN(4)
     I              PTBQ05                      PMN(5)
     I              PTBQ06                      PMN(6)
     I              PTBQ07                      PMN(7)
     I              PTBQ08                      PMN(8)
     I              PTBQ09                      PMN(9)
     I              PTBQ10                      PMN(10)
     I              PTBQ11                      PMN(11)
     I              PTBQ12                      PMN(12)
     I              PTEQ01                      PMX(1)
     I              PTEQ02                      PMX(2)
     I              PTEQ03                      PMX(3)
     I              PTEQ04                      PMX(4)
     I              PTEQ05                      PMX(5)
     I              PTEQ06                      PMX(6)
     I              PTEQ07                      PMX(7)
     I              PTEQ08                      PMX(8)
     I              PTEQ09                      PMX(9)
     I              PTEQ10                      PMX(10)
     I              PTEQ11                      PMX(11)
     I              PTEQ12                      PMX(12)
     I              PTUN01                      PUN(1)
     I              PTUN02                      PUN(2)
     I              PTUN03                      PUN(3)
     I              PTUN04                      PUN(4)
     I              PTUN05                      PUN(5)
     I              PTUN06                      PUN(6)
     I              PTUN07                      PUN(7)
     I              PTUN08                      PUN(8)
     I              PTUN09                      PUN(9)
     I              PTUN10                      PUN(10)
     I              PTUN11                      PUN(11)
     I              PTUN12                      PUN(12)
     I              PTPE01                      PPC(1)
     I              PTPE02                      PPC(2)
     I              PTPE03                      PPC(3)
     I              PTPE04                      PPC(4)
     I              PTPE05                      PPC(5)
     I              PTPE06                      PPC(6)
     I              PTPE07                      PPC(7)
     I              PTPE08                      PPC(8)
     I              PTPE09                      PPC(9)
     I              PTPE10                      PPC(10)
     I              PTPE11                      PPC(11)
     I              PTPE12                      PPC(12)
      ****************
      * READ IORDR   *
      ****************
     C     SOWCYM        SETLL     FIORDRSP
     C     NXT           TAG
     C     SOWCYM        READE     FIORDRSP                               90                   ARC38
      ** LOGIC FOR LAST RECORD
     C   90              DO
     C     SOITEM        IFGT      *BLANKS
     C                   EXSR      WRTREC
     C                   END
     C                   GOTO      END
     C                   ENDDO
     C     OISTAT        IFNE      'A'
     C     OIQORD        ORLE      OIQSHP
     C     OILOTC        OREQ      'Y'
WJB  C     OILOT#        ANDNE     'CustomOrdr'
     C     OISTA         OREQ      'Y'
     C     OIPRBO        OREQ      'B'
     C     OIBOLN        OREQ      'B'
     C                   GOTO      NXT
     C                   END
     C     OIITEM        IFNE      SOITEM
     C     OISIZE        ORNE      SOSIZE
     C     OIRVDT        ORNE      SORDYD
     C     SOITEM        IFGT      *BLANKS
     C                   EXSR      WRTREC
     C                   END
     C                   EXSR      GETITM
     C                   END
      ** SKIP P.C. NOT 50 TO 61
     C     IMPCL1        IFGT      '61'
     C     IMPCL1        ORLT      '50'
     C                   GOTO      NXT
     C                   END
      ** SKIP 84 TRAYS FOR CUTTINGS 12/21/01 INCLUDE PER JOHN
     C*          IMSIZE    IFEQ '84 '
     C*          IMFRSZ    ANDEQ'CUT'
     C*                    GOTO NXT
     C*                    END
      ** SKIP SHIPPED ORDERS
     C     OIQORD        SUB       OIQSHP        OPNQTY            7 1
     C     OPNQTY        IFLE      0
     C                   GOTO      NXT
     C                   END
     C                   ADD       OPNQTY        QTYORD
     C     OICUST        CHAIN     FMCUST                             21
      ** IF CUST NO FIX CUST
     C  N21PTCTYP        IFNE      *BLANKS
     C     PTCTYP        ANDEQ     CMCTYP
     C                   ADD       OPNQTY        QTYSKP
     C                   END
     C                   GOTO      NXT
      *** END PROGRAM
     C     END           TAG
      ** NOW CHECK IF ANY ITEMS HAVE NO OPEN ORDERS (ALL DELETED)
     C                   EXSR      CHKDEL
     C                   SETON                                        LR
      ***********************
      ** WRITE SOW RECORD  **
      ***********************
     C     WRTREC        BEGSR
      ** GET FIXERS
     C                   EXSR      GETFIX
      ** SEE WHAT HAS BEEN SCHEDULED/SOWN
     C     QTYORD        ADD       FIXERS        TOTQTY            7 1
     C                   EXSR      GETSOW
      ** Correct number scheduled
WJB  C     NEED          Mult(H)   1             NEED0             6 0
     C     NEED0         IFEQ      0
     C                   GOTO      ENDREC
     C                   END
      ** CHECK OVERFLOW BECAUSE I WILL PRINT AFTER THIS
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF DO
      ** CHECK IF TO MANY
     C     NEED0         IFLT      0
     C                   EXSR      LOWER
     C                   GOTO      ENDREC
     C                   END
      ** IF HERE NOT ENOUGH SEE IF ANY WRITTEN
     C     RECS          IFLE      0
     C     OPNR          ORLE      0
     C                   GOTO      WRTOK
     C                   END
      ** NOW I HAVE A RECORD THAT MAY BE ADDED TO?
     C     SOJKEY        KLIST
     C                   KFLD                    SOSOWD
     C                   KFLD                    SOJOB#
     C                   Z-ADD     OPNJOB        SOJOB#
     C     SOJKEY        CHAIN     FSOWSCHJ                           57
     C  N57              DO
     C                   MOVEL     'A'           SOSTAT
     C                   MOVEL     IMLOOK        SOLOOK
     C                   Z-ADD     IM#SED        SO#SED
     C                   MOVEL     IMTRYC        SOTRYC
     C                   MOVEL     IMALTP        SOALTP
     C                   MOVE      IMMSCX        SOMSCX
     C                   MOVE      IMTPSW        SOTPSW
     C                   MOVE      IMLOC         SOLOC
     C     SOSOWT        ADD       NEED0         NEWQTY            7 1
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF DO
     C                   EXCEPT    UPDDET
      ** GET QTYS
WJB  C* 12/2/05          ADD       NEED          SOORDQ
WJB  C* 05/27/09         z-add     QtyOrd        SOORDQ
WJB  C     QtyOrd        Mult(H)   1             SOORDQ
     C                   ADD       NEED0         SOSOWT
     C                   TIME                    SOTIME
     C                   MOVEL     USERID        SOUSER
     C                   Z-ADD     TDATE         SODTLA
     C                   UPDATE    SOWSCH
     C                   GOTO      ENDREC
     C                   ENDDO                                                  N57  DO
      ** IF HERE WRITE NEW RECORD
     C     WRTOK         TAG
     C                   MOVEL     'A'           SOSTAT
     C                   Z-ADD     SOWCYM        SOSOWD
     C                   MOVEL     IMLOOK        SOLOOK
     C                   Z-ADD     IM#SED        SO#SED
     C                   MOVEL     IMTRYC        SOTRYC
     C                   MOVEL     IMALTP        SOALTP
     C                   MOVE      IMMSCX        SOMSCX
     C                   MOVE      IMTPSW        SOTPSW
     C                   MOVE      IMLOC         SOLOC
      ** GET QTYS
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF DO
     C     NUMKEY        CHAIN     FJOBNM                             71
     C                   Z-ADD     JNJOB#        SOJOB#
     C                   ADD       1             JNJOB#
     C  N71              UPDATE    RJOBNM
     C                   EXCEPT    ADDDET
WJB  C     QtyOrd        Mult(H)   1             SOORDQ
     C                   Z-ADD     NEED0         SOSOWT
     C                   Z-ADD     0             SOSOWL
     C                   Z-ADD     0             SOSOWQ
     C                   TIME                    SOTIME
     C                   MOVEL     USERID        SOUSER
     C                   Z-ADD     TDATE         SODTLA
     C                   WRITE     RSOWSCH
     C     ENDREC        TAG
     C                   ENDSR
     C*
     C**************
     C* GET ITEM   *
     C**************
     C     GETITM        BEGSR
     C                   MOVEL     OIITEM        SOITEM
     C                   MOVEL     OISIZE        SOSIZE
     C     MINKEY        KLIST
     C                   KFLD                    SOITEM
     C                   KFLD                    SOSIZE
     C     MINKEY        CHAIN     FMINVT                             91
     C     IMSIZE        CHAIN     FMSIZE                             91
     C                   Z-ADD     SZCELL        SOCELL
     C                   Z-ADD     OIRVDT        SORDYD
     C                   Z-ADD     0             QTYORD            7 1
     C                   Z-ADD     0             QTYSKP            7 1
     C     IMFTAB        IFLE      *BLANKS
     C                   MOVEL     '01'          IMFTAB
     C                   END
     C     IMFTAB        IFEQ      '00'
     C                   MOVEL     '01'          IMFTAB
     C                   END
     C     IMFTAB        IFNE      '**'
     C     IMFTAB        CHAIN     FPTABLE                            70
     C                   END
     C                   ENDSR
     C**************
     C* GET SOWN   *
     C**************
     C     GETSOW        BEGSR
     C                   Z-ADD     0             NEED              7 1
     C                   Z-ADD     0             SCHD              7 1
     C                   Z-ADD     0             RECS              7 1
     C                   Z-ADD     0             OPNR              7 1
     C                   Z-ADD     0             OPNJOB            4 0
     C     SOWKEY        KLIST
     C                   KFLD                    SOSOWD
     C                   KFLD                    SORDYD
     C                   KFLD                    SOITEM
     C                   KFLD                    SOSIZE
     C     SOWKEY        SETLL     FSOWSCH
     C     NXTSOW        TAG
     C     SOWKEY        READE(N)  FSOWSCH                                90
     C   90              GOTO      ENDSOW
     C     SOSTAT        IFNE      'D'                                          only count not = D
     C                   ADD       SOSOWT        SCHD
     C                   EndIf
     C                   ADD       1             RECS
     C     SOSTAT        IFEQ      'A'
     C                   ADD       1             OPNR
     C                   Z-ADD     SOJOB#        OPNJOB
     C                   END
     C                   GOTO      NXTSOW
     C     ENDSOW        TAG
     C     TOTQTY        SUB       SCHD          NEED
     C                   ENDSR
     C**************
     C* LOWER QTYS *
     C**************
     C     LOWER         BEGSR
     C                   Z-SUB     NEED          LOWQTY            7 1
     C     SOWKEY        SETLL     FSOWSCH
     C     NXTLOW        TAG
     C                   SETOFF                                       5152
     C     SOWKEY        READE     FSOWSCH                                90
     C   90              GOTO      ENDLOW
     C     SOSTAT        IFNE      'A'
     C                   GOTO      NXTLOW
     C                   END
     C     SOSOWT        IFGT      LOWQTY
     C     SOSOWT        SUB       LOWQTY        NEWQTY
     C                   SETON                                        51
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF DO
     C                   EXCEPT    LOWDET
     C                   SUB       LOWQTY        SOSOWT
     C                   Z-ADD     0             LOWQTY
     C                   TIME                    SOTIME
     C                   MOVEL     USERID        SOUSER
     C                   Z-ADD     TDATE         SODTLA
     C                   UPDATE    RSOWSCH
     C                   GOTO      ENDLOW
     C                   END
     C     SOSOWT        IFLE      LOWQTY
     C                   Z-ADD     0             NEWQTY
     C                   SETON                                        52
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF DO
     C                   EXCEPT    LOWDET
     C                   MOVEL     'D'           SOSTAT
     C                   SUB       SOSOWT        LOWQTY
     C                   TIME                    SOTIME
     C                   MOVEL     USERID        SOUSER
     C                   Z-ADD     TDATE         SODTLA
     C                   UPDATE    RSOWSCH
     C                   END
     C     LOWQTY        IFGT      0
     C                   GOTO      NXTLOW
     C                   END
     C     ENDLOW        ENDSR
     C**************
     C* GET FIXERS *
     C**************
     C     GETFIX        BEGSR
     C                   Z-ADD     0             FIXERS
     C     QTYORD        SUB       QTYSKP        WRKQTY            7 1
     C     IMFTAB        IFEQ      '**'
     C                   GOTO      ENDPTB
     C                   END
     C* CALCULATE NUMBER OF FIXERS
     C                   Z-ADD     1             X                 2 0
     C     NXTX          TAG
     C     WRKQTY        IFGE      PMN(X)
     C     WRKQTY        ANDLE     PMX(X)
     C     PUN(X)        IFGT      0
     C                   Z-ADD     PUN(X)        FIXERS            6 1
     C                   ELSE
     C     PPC(X)        DIV(H)    100           PCTWK             5 4
     C     WRKQTY        MULT(H)   PCTWK         FIXERS
WJB  C     WRKQTY        MULT      PCTWK         FIXER2            5 5
WJB  C     FIXER2        IFLT      .5
WJB  C     FIXER2        ANDGT     0
WJB  C                   ADD       1             FIXERS
WJB  C                   END
     C                   END
     C                   GOTO      ENDPTB
     C                   ENDIF                                                  WRKQTY><
     C                   ADD       1             X
     C     X             IFLE      12
     C                   GOTO      NXTX
     C                   END
     C*
     C     ENDPTB        TAG
     C                   Eval      Order = WRKQTY
WJB ?C                   Call      '#SOWFACT71'
WJB ?C                   Parm      IMITEM        Item
WJB ?C                   Parm      IMSIZE        Size
WJB ?C                   Parm      IMFTAB        Table
WJB ?C                   Parm                    Order
WJB ?C                   Parm                    ToSow
     C                   Eval      FIXERS = ToSow - Order
     C                   ENDSR
      ***********************
      ** CHECK FOR DELETED **
      ***********************
     C     CHKDEL        BEGSR
     C     SOWCYM        SETLL     FSOWSCH
     C     NXTDEL        TAG
     C     SOWCYM        READE     FSOWSCH                                90
     C   90              GOTO      ENDDEL
     C     SOSTAT        IFNE      'A'
     C                   GOTO      NXTDEL
     C                   END
      ** NOW CHECK IF ANY OPEN ORDERS
     C     DELKEY        KLIST
     C                   KFLD                    SOITEM
     C                   KFLD                    SOSIZE
     C                   KFLD                    SORDYD
     C     DELKEY        SETLL     FIORDISA
     C     NXDETS        TAG
     C     DELKEY        READE     FIORDISA                               71
     C  N71              DO
     C     OISTAT        IFNE      'A'
     C     OIQORD        ORLE      OIQSHP
     C     OILOTC        OREQ      'Y'
WJB  C     OILOT#        ANDNE     'CustomOrdr'
     C     OISTA         OREQ      'Y'
     C                   GOTO      NXDETS
     C                   END
     C                   GOTO      NXTDEL
     C                   ENDDO
      ** IF HERE NO ORDER EXISTS
     C     MINKEY        CHAIN     FMINVT                             91
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF DO
     C                   EXCEPT    DELDET
     C                   MOVEL     'D'           SOSTAT
     C                   TIME                    SOTIME
     C                   MOVEL     USERID        SOUSER
     C                   Z-ADD     TDATE         SODTLA
     C                   UPDATE    RSOWSCH
     C                   GOTO      NXTDEL
     C     ENDDEL        TAG
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     TDATE         CHAIN     FCALEN                             90
     C                   Z-ADD     CLCYMD        TDATEC            7 0
     C     PLDATE        CHAIN     FCALEN                             90
     C                   Z-ADD     CLCYMD        SOWCYM            7 0
     C                   Z-ADD     CLWEEK        SOWWEK            2 0
     C                   MOVEL     CLCENT        SOWYER            4 0
     C                   MOVE      CLYEAR        SOWYER
     C     NUMKEY        KLIST
     C                   KFLD                    SOWYER
     C                   KFLD                    SOWWEK
     C     NUMKEY        CHAIN     FJOBNM                             71
      ** IF NO RECORD THIS IS ORIGINAL RUN
     C   71              DO
     C                   Z-ADD     0             LUPD
     C                   MOVEL     'A'           JNSTAT
     C                   Z-ADD     TDATEC        JNORGD
     C                   Z-ADD     SOWYER        JNYEAR
     C                   Z-ADD     SOWWEK        JNWEEK
     C                   Z-ADD     SOWCYM        JNCYMD
     C                   Z-ADD     1             JNJOB#
     C                   WRITE     RJOBNM
     C                   MOVEL     'A'           RPTTYP            1
     C                   ENDDO
     C                   Z-ADD     0             LUPD
     C                   Z-ADD     0             ORGD
     C                   SETOFF                                       8081
      ** IF RECORD EXISTS THEN THIS IS AN UPDATE
     C  N71              DO
     C                   Z-ADD     JNUPDD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         LUPD              6 0
     C                   Z-ADD     TDATEC        JNUPDD
     C                   UPDATE    RJOBNM
     C                   MOVEL     'U'           RPTTYP            1
     C                   ENDDO
     C     RPTTYP        IFEQ      'A'
     C                   MOVEL     MSG(1)        TYDES            12
     C                   SETON                                        80
     C                   ELSE
     C                   MOVEL     MSG(2)        TYDES
     C                   Z-ADD     JNORGD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         ORGD              6 0
     C                   SETON                                        81
     C                   END
     C                   Z-ADD     SOWCYM        SOSOWD
     C                   SETON                                        OF
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OSOW020    E            HEAD           1 03
     O                                            6 'SOW020'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           55 'Sow Line Schedule for:'
     O                       PLDATE        Y     64
     O                       PAGE          Z     85
     O                                           81 'Page:'
     O          E            HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                       TYDES               55
     O                                           76 'Time:'
     O                       TIMOD               85 '  :  :  '
     O          E            HEAD           2
     O               81                          40 'Original Run Date:'
     O               81      ORGD                49 '  /  /  '
     O               81                          68 'Last Update Date:'
     O               81      LUPD                78 '  /  /  '
     O          E            HEAD           1
     O                                           51 'Orig.'
     O                                           58 'Need'
     O                                           68 '---------------Quantitie'
     O                                           85 's----------------'
     O          E            HEAD           0
     O                                            3 'Job'
     O                                           13 'Item Size'
     O                                           25 'Description'
     O                                           51 'Orig.'
     O                                           58 'Need'
     O                                           65 'New'
     O                                           85 'Action'
     O          E            HEAD           1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O                                           85 '_____'
     O          EF           ADDDET         1
     O                       SOJOB#        4      4
     O                       SOITEM              17
     O                       SOSIZE              13
     O                       IMDES1              44
     O                       NEED          M     58
     O                       NEED          4     65
     O                                           85 '** Added **'
     O          EF           UPDDET         1
     O                       SOJOB#        4      4
     O                       SOITEM              17
     O                       SOSIZE              13
     O                       IMDES1              44
     O                       SOSOWT        4     51
     O                       NEED          M     58
     O                       NEWQTY        4     65
     O                                           85 '* Updated *'
     O          EF           LOWDET         1
     O                       SOJOB#        4      4
     O                       SOITEM              17
     O                       SOSIZE              13
     O                       IMDES1              44
     O                       SOSOWT        4     51
     O                       NEED          M     58
     O                       NEWQTY        4     65
     O               52                          85 '* Deleted *'
     O               51                          85 '* Updated *'
     O          EF           DELDET         1
     O                       SOJOB#        4      4
     O                       SOITEM              17
     O                       SOSIZE              13
     O                       IMDES1              44
     O                       SOSOWT        4     51
     O**                       NEED  M   58
     O**                       NEWQTY4   65
     O                                           85 '* Deleted *'
** MESSAGE ARRAY
Original Run                           1
Update Run                             2
