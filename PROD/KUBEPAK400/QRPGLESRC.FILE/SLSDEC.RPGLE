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
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- SLSDEC
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT OPEN ORDER VALUE BY DESCEND SALES
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMCUST    IF   E           K DISK
     FFSOHSTPC  IF   E           K DISK
     FFHORCUS   IF   E           K DISK
     FFIORDR    IF   E           K DISK
     FSLSDECFL  UF A E           K DISK
     FSLSDEC    O    F  198        PRINTER OFLIND(*INOF)
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
     D  LCO                    1      2  0
     D  LBMTHY                 3      6  0
     D  LEMTHY                 7     10  0
     D  LBPC                  11     12
     D  LEPC                  13     14
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      ***********************
      ** GET CUSTOMER      **
      ***********************
     C     NXTCST        TAG
     C                   READ      FMCUST                                 90
     C   90              GOTO      ENDGET
     C     CMCTYP        IFNE      '05'
     C     CMCTYP        ANDNE     '12'
     C                   GOTO      NXTCST
     C                   END
     C                   MOVEL     CMCTYP        SLCTYP
     C                   Z-ADD     CMCUST        SLCUST
     C                   MOVEL     CMNAME        SLNAME
     C                   Z-ADD     CMPHON        SLPHON
     C                   MOVEL     CMCNME        SLCNME
     C                   MOVEL     CMCITY        SLCITY
     C                   MOVEL     CMSTST        SLSTST
     C                   Z-ADD     0             SLOPNO
     C                   Z-ADD     0             SLLSTS
     C                   EXSR      GETOPN
     C                   EXSR      GETSLS
     C                   WRITE     RSLSDECF
     C                   GOTO      NXTCST
      ** DUMMY UPDATE
     C                   UPDATE    RSLSDECF
      ** NOW PRINT REPORT
     C     ENDGET        TAG
     C                   Z-ADD     9999999.99    SLLSTS
     C     SLLSTS        SETLL     SLSDECFL
     C     NXTRPT        TAG
     C                   READ      SLSDECFL                               90
     C   90              GOTO      END
      ** PRINT REPORT
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C     SLLSTS        IFNE      0
     C                   EXCEPT    DETL
     C                   ENDIF
     C                   GOTO      NXTRPT
      * END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** GET OPEN ORDERS   **
      ***********************
     C     GETOPN        BEGSR
     C     CMCUST        SETLL     FHORCUS
     C     NXTHED        TAG
     C     CMCUST        READE     FHORCUS                                90
     C   90              GOTO      ENDHED
     C     OHSTAT        IFEQ      'D'
     C     OHCOFL        OREQ      'Y'
     C                   GOTO      NXTHED
     C                   ENDIF
      ** GET DETAIL
     C     OHORD#        SETLL     FIORDR
     C     NXTDET        TAG
     C     OHORD#        READE     FIORDR                                 90
     C   90              GOTO      NXTHED
     C     OISTAT        IFEQ      'D'
     C     OICOFL        OREQ      'Y'
     C     OIITYP        ORNE      ' '
     C                   GOTO      NXTDET
     C                   ENDIF
     C     OIQORD        SUB       OIQSHP        WRKQTY           11 1
     C     WRKQTY        MULT(H)   OIUPRI        WRKDOL           11 2
     C                   ADD       WRKDOL        SLOPNO
     C                   GOTO      NXTDET
     C     ENDHED        ENDSR
      ***********************
      ** GET SALES HIST    **
      ***********************
     C     GETSLS        BEGSR
     C                   Z-ADD     CMCUST        SOCUST
     C                   MOVEL     *BLANKS       SOPCL1
     C                   MOVEL     *BLANKS       SOITEM
     C                   MOVEL     *BLANKS       SOSIZE
     C                   Z-ADD     0             SOSHDT
     C                   Z-ADD     0             SOORD#
     C     SOKEY         KLIST
     C                   KFLD                    SOCUST
     C                   KFLD                    SOPCL1
     C                   KFLD                    SOITEM
     C                   KFLD                    SOSIZE
     C                   KFLD                    SOSHDT
     C                   KFLD                    SOORD#
     C     SOKEY         SETLL     FSOHSTPC
     C                   Z-ADD     EDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ERDATE            7 0
     C     NXTSO         TAG
     C                   READ      FSOHSTPC                               90
     C   90              GOTO      ENDSLS
     C     SOCUST        IFNE      CMCUST
     C                   GOTO      ENDSLS
     C                   ENDIF
     C     SOPCL1        IFLT      LBPC
     C     SOPCL1        ORGT      LEPC
     C                   GOTO      NXTSO
     C                   ENDIF
     C     SOSHDT        IFLT      BRDATE
     C     SOSHDT        ORGT      990631
     C                   GOTO      NXTSO
     C                   ENDIF
     C                   ADD       SOEXT$        SLLSTS
     C                   GOTO      NXTSO
     C     ENDSLS        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   SETON                                        OF
     C                   MOVEL     LBMTHY        BMTH              2 0
     C                   MOVE      LBMTHY        BYR               2 0
     C                   MOVEL     BMTH          BMMDD             4 0
     C                   MOVE      01            BMMDD             4 0
     C                   MOVEL     BMMDD         BDATE             6 0
     C                   MOVE      BYR           BDATE
     C                   Z-ADD     BDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        BRDATE            7 0
     C                   MOVEL     LEMTHY        EMTH              2 0
     C                   MOVE      LEMTHY        EYR               2 0
     C                   MOVEL     EMTH          EMMDD             4 0
     C                   MOVE      31            EMMDD             4 0
     C                   MOVEL     EMMDD         EDATE             6 0
     C                   MOVE      EYR           EDATE
     C                   Z-ADD     EDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ERDATE            7 0
     C                   ENDSR
      *
     OSLSDEC    E            HEAD           1 03
     O                                            6 'SLSDEC'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           80 'Customer Sales/Open'
     O                                           87 'Orders'
     O                       PAGE          Z    190
     O                                          181 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           70 'Sales from'
     O                       LBMTHY        Y     76
     O                                           81 'Thru'
     O                       LEMTHY        Y     87
     O                                          181 'Time:'
     O                       TIMOD              190 '  :  :  '
     O          E            HEAD           0
     O                                            5 'Type'
     O                                           11 '#  '
     O                                           16 'Name'
     O                                           55 'Phone #     '
     O                                           63 'Contact'
     O                                           91 'City'
     O                                          109 'State'
     O                                          121 'Open Order'
     O                                          134 'Sales  '
     O                                          160 'Comments                '
     O          E            HEAD           1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O                                          100 '____________________'
     O                                          120 '____________________'
     O                                          140 '____________________'
     O                                          160 '____________________'
     O                                          180 '____________________'
     O          EF           DETL           2
     O                       SLCTYP               3
     O                       SLCUST        Z     11
     O                       SLNAME              42
     O                       SLPHON              55 '   -   -    '
     O                       SLCNME              86
     O                       SLCITY             105
     O                       SLSTST             108
     O                       SLOPNO        J    121
     O                       SLLSTS        J    134
     O                                          160 '________________________'
     O                                          184 '________________________'
