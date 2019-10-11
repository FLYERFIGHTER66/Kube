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
      **PROGRAM NAME-------- CUR650
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- ORDER ENTRY CHANGES TO 105 ECKE PRODUCTION
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/17/02 EFD CHANGE FROM 84 TO 105 TRAYS.
      *  1/09/03 CAB CHANGES RIGHT HAND MARGIN PRINTING TO FIT ON 8 1/2 X 11
      *
     FFCUTDELD  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FCUR650    O    F  120        PRINTER OFLIND(*INOF)
WJB  FFMVEND    IF   E           K DISK
      *
      *
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
     D  LCO                    1      2  0                                      ARC380
     D  BEGDAT                 3      8  0                                      ARC380
     D  ENDDAT                 9     14  0                                      ARC380
     D  BEGCYM                15     21  0                                      ARC380
     D  ENDCYM                22     28  0                                      ARC380
WJB
WJB  D  Vendor         S                   Like(IMVEND)
      ***********************
      ** START HERE        **
      ***********************
     C                   Z-ADD     0             OLDORD            6 0
WJB  C     VendDate      KList
WJB  C                   KFld                    Vendor
WJB  C                   KFld                    BEGCYM
WJB  C*    BEGCYM        SETLL     FCUTDELD
WJB  C     VendDate      SETLL     FCUTDELD
     C     NXT           TAG
WJB  C*                  READ      FCUTDELD                               90
WJB  C     Vendor        READe     FCUTDELD                               90
     C   90              GOTO      END
      ** GET RID OF NO QTY RECORDS
     C     CDOQTY        IFLE      0
     C     CDNQTY        ANDLE     0
     C                   GOTO      NXT
     C                   END
     C     CDCHDT        IFGT      ENDCYM
     C                   GOTO      END
     C                   END
      ** SAME ORDER
     C     CDORD#        IFNE      OLDORD
     C     CDCUST        CHAIN     FMCUST                             91
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    CUST
     C                   Z-ADD     CDORD#        OLDORD
     C                   END                                                    CDORD#><OLDO
      ** NOW GET LINES
     C                   SETOFF                                       010203
     C                   SETOFF                                       0405
     C     CDACT         IFEQ      'A'
     C     CDACT         OREQ      'I'
     C                   SETON                                        01
     C                   END
     C     CDACT         IFEQ      'C'
     C                   SETON                                        02
     C                   END
     C     CDACT         IFEQ      'D'
     C                   SETON                                        03
     C                   END
     C     MINKEY        KLIST
     C                   KFLD                    CDITEM
     C                   KFLD                    SIZE
WJB01C                   MOVEL     'CUT'         SIZE              3
     C     MINKEY        CHAIN     FMINVT                             92
     C   02CDOSOW        IFNE      CDNSOW
     C                   SETON                                        04
     C                   END                                                    CDOSOW<>CDNS
     C                   Z-ADD     CDOSOW        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         OSOW              6 0
     C                   Z-ADD     CDNSOW        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         NSOW              6 0
     C   02CDOQTY        IFNE      CDNQTY
     C                   SETON                                        05
     C     CDNQTY        SUB       CDOQTY        NETQTY            7 0
     C                   ELSE
     C                   Z-ADD     0             NETQTY
     C                   END                                                    CDOQTY><CDNQ
     C   01              Z-ADD     CDNQTY        NETQTY
     C   03              Z-SUB     CDOQTY        NETQTY
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    ORD
     C                   GOTO      NXT
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
WJB  C     *Entry        PList
WJB  C                   Parm                    Vendor
WJB  C     Vendor        Chain     FMVEND
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   SETON                                        OF
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OCUR650    E            HEAD           1 03
     O                                            6 'CUR650'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           58 'Changes to Cutting'
     O                                           65 'Orders'
CAB  O***                      PAGE  Z   84
CAB  O                       PAGE          Z     82
     O                                           80 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           40 'Changes made from:'
     O                       BEGDAT        Y     49
     O                                           56 '-Thru-'
     O                       ENDDAT        Y     65
     O                                           75 'Time:'
CAB  O***                      TIMOD     84 '  :  :  '
CAB  O                       TIMOD               82 '  :  :  '
     O          EF           CUST        1  1
     O                                           10 'Order #:'
     O                       CDORD#        4     15
     O                                           26 'Customer:'
     O                       CDCUST        4     33
     O                       CMNAME              64
     O          EF           CUST           0
     O                                           17 'Item  Description'
     O                                           36 'Type'
     O                                           45 'Old Sow'
     O                                           54 'New Sow'
     O                                           62 'Old Qty'
CAB  O***                                73 'New Qty'
CAB  O                                           72 'New Qty'
CAB  O***                                84 'Qty Chg'
CAB  O                                           83 'Qty Chg'
     O          EF           CUST           1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
CAB  O***                                84 '____'
CAB  O                                           83 '____'
     O          EF           ORD            1
     O                       CDITEM              12
     O                       IMDES1              36
     O               01                          36 ' Add'
     O               02                          36 ' Chg'
     O               03                          36 ' Del'
     O              N01      OSOW          Y     45
     O              N03      NSOW          Y     54
     O              N01      CDOQTY        4     62
CAB  O***             N03      CDNQTY4   73
CAB  O              N03      CDNQTY        4     72
CAB  O***                      NETQTYK   84
CAB  O                       NETQTY        K     83
