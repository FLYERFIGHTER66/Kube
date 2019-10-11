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
      **PROGRAM NAME-------- PUR100
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TRUCK SCHEDULE
      **PROGRAMMER---------- EFD
      **APPLICATION--------- TRUCK SCHEDULE MAINTAINENCE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FPUR100FM  CF   E             WORKSTN
     F                                     SFILE(TRKSFL:RECNO)
     F                                     SFILE(ORDSFL:RECN1)
     FFCALEN    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:ICALEN)
     FFCALENCY  IF   E           K DISK
     F                                     RENAME(RCALEN:YCALEN)
     FFMCUST    IF   E           K DISK
     FFMSVIA    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFIORDR    IF   E           K DISK
     FFPUUCKO   IF   E           K DISK
     FFPUSTAT   IF   E           K DISK
     FFPUUCKS   UF   E           K DISK
     FFPUUCKSW  IF   E           K DISK
     F                                     RENAME(RPUUCKS:TRUCKS)
      *
      * message array
     D MSG             S             30    DIM(10) CTDATA PERRCD(1)             MESSAGE
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LCO                    1      2  0                                      ARC380
     D  BEGDT                  3      8  0                                      ARC380
     D  ENDDT                  9     14  0                                      ARC380
     D  YEAR                  15     18  0                                      ARC380
     D  WEEK                  19     20  0                                      ARC380
     D  BEGCYM                21     27  0                                      ARC380
     D  CANCEL               133    133                                         ARC380
      ***********************
      ** START OR RESTART  **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     1             LCO
     C                   Z-ADD     0             BEGDT
     C                   Z-ADD     0             ENDDT
     C                   Z-ADD     0             BEGCYM
     C                   MOVE      *BLANKS       CANCEL
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                       9899
     C                   SETOFF                                       6162
      ** DISPLAY SCREEN
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           CANCEL
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                       6162
     C                   SETOFF                                         99
      ** CHECK INPUT
      **
      ** CHECK DATE
     C     FRMDAT        IFLE      0
     C     BEGYY         ANDLE     0
     C     BEGWW         ANDLE     0
     C                   SETON                                        10  99
     C                   GOTO      NXTA
     C                   ENDIF
      **
     C     FRMDAT        IFGT      0
     C                   Z-ADD     FRMDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1099
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     ##CYMD        BEGCYM            7 0
     C     FRMDAT        CHAIN     FCALEN                             92
     C                   MOVEL     CLCENT        BEGYY
     C                   MOVE      CLYEAR        BEGYY
     C                   Z-ADD     CLWEEK        BEGWW
     C     CL#Y          IFNE      1
     C                   SETON                                        101199    9
     C                   GOTO      NXTA
     C                   END
     C                   ELSE                                                   FRMDAT > 0
     C                   MOVEL     BEGYY         CLCENT
     C                   MOVE      BEGYY         CLYEAR
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    BEGWW
     C                   KFLD                    CL#Y
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             92
     C   92              DO
     C                   SETON                                        2099
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        FRMDAT
     C                   Z-ADD     CLCYMD        BEGCYM
     C                   END                                                    FRMDAT > 0
     C                   Z-ADD     FRMDAT        BEGDT
      ** CHECK STATUS OF FILES
     C     BEGCYM        CHAIN     FPUSTAT                            61
     C  N61              DO
     C     STBLDR        IFNE      'Y'
     C                   SETON                                        6199
     C                   END
     C     STTRNR        IFEQ      'Y'
     C                   SETON                                        6299
     C                   END
     C                   ENDDO                                                  N61  DO
     C   61              SETON                                        99
     C   99              GOTO      NXTA
      *** SEE WHERE WE ARE
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   END
      ** GET ENDING DATES
     C                   Z-ADD     BEGYY         ENDYY             4 0
     C                   Z-ADD     BEGWW         ENDWW             2 0
     C                   MOVEL     BEGYY         CLCENT
     C                   MOVE      BEGYY         CLYEAR
     C                   Z-ADD     7             CL#Y
     C     CALKEY        CHAIN     FCALEX                             92
     C                   Z-ADD     CLDATE        ENDDT
      ** NOW BUILD SUB FILE
     C                   SETOFF                                       57
     C                   EXSR      BLDSFL
      ** DISPLAY
     C     NXTSFL        TAG
     C     PAGE#         IFLE      0
     C                   Z-ADD     1             PAGE#
     C                   END
     C     PAGE#         IFGT      RECNO
     C                   Z-ADD     RECNO         PAGE#
     C                   END
     C                   EXFMT     TRKCTL
      ** CHECK F KEYS
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           CANCEL
     C                   GOTO      END
     C                   ENDDO
     C   KF              GOTO      RSTART
      ** INQUIRE INTO ORDERS
     C   KB              DO
     C                   Z-ADD     LINE          PAGE#
     C                   EXSR      ORDINQ
     C                   EXSR      BLDSFL
     C                   GOTO      NXTSFL
     C                   ENDDO
      ** CHANGE SHIP VIA
     C   KK              DO
     C                   EXSR      GETVIA
     C                   EXSR      BLDSFL
     C                   GOTO      NXTSFL
     C                   ENDDO
      ** CHECK SUB FILE
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTSFL
      ** PUT SUB FILE
     C                   EXSR      PUTSFL
     C   57
     CAN KD              GOTO      END
     C                   EXSR      BLDSFL
     C                   GOTO      NXTSFL
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     TRKCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             ODAY#             1 0
     C                   MOVE      *BLANKS       OSVIA             2
     C                   MOVE      *BLANKS       ROUT
     C     BEGCYM        SETLL     FPUUCKSW
     C     NXTBLD        TAG
     C     BEGCYM        READE     FPUUCKSW                               90
     C   90              GOTO      ENDBLD
      ** GET ORDER RECORD
     C     TSORD#        CHAIN(N)  FHORDR
      ** SEE IF NEW HEADING
     C     TSSVIA        IFNE      OSVIA
     C     TSDAY#        ORNE      ODAY#
     C                   SETON                                        55
     C     TSSVIA        CHAIN     FMSVIA                             77
     C                   MOVEL     SVDESC        NAME
     C   77              MOVEL     TSSVIA        NAME
     C   77              MOVE      'NO HIT  '    NAME
     C                   MOVEL     TSSVIA        OSVIA
     C                   MOVEL     '99'          CMSTST
     C     TSDAY#        IFGT      0
     C     TSDAY#        ANDLT     8
     C                   MOVEL     MSG(TSDAY#)   CITY
     C                   ELSE
     C                   MOVE      *BLANKS       CITY
     C                   END
     C                   Z-ADD     TSDAY#        ODAY#
     C                   ADD       1             RECNO
     C                   WRITE     TRKSFL
     C                   MOVEL     TSROUT        ROUT
     C                   ENDIF                                                  TSSVIA><OSVI
     C                   SETOFF                                       55
      ** PUT BLANK LINE BETWEEN ROUTS
     C     TSROUT        IFNE      ROUT
     C     ROUT          ANDGT     *BLANKS
     C                   SETON                                        55
     C                   MOVE      *BLANKS       CITY
     C                   MOVE      *BLANKS       NAME
WJB  C                   MOVEL     '99'          CMSTST
     C                   ADD       1             RECNO
     C                   WRITE     TRKSFL
     C                   END
     C                   SETOFF                                       55
     C*    TSCUST        CHAIN     FMCUST                             88
     C     OHCUST        CHAIN     FMCUST                             88
     C                   Z-ADD     TSDAY#        DAY
     C                   MOVEL     TSROUT        ROUT
     C                   Z-ADD     TSSTOP        STOP
     C                   MOVEL     CMCITY        CITY
     C                   MOVEL     CMNAME        NAME
     C                   Z-ADD     TSQTY1        TRAYS
     C                   Z-ADD     TSQTY3        CARTS
     C     CMFILL        IFEQ      'NT'
     C                   SETON                                        59
     C                   ELSE
     C                   SETOFF                                       59
     C                   END
     C                   ADD       1             RECNO
     C                   WRITE     TRKSFL
     C                   SETOFF                                       59
     C                   GOTO      NXTBLD
      ** END BUILD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   MOVEL     MSG(8)        CMNAME
WJB  C                   MOVE      MSG(8)        NAME
     C                   MOVE      *BLANKS       CITY
WJB  C                   MOVEL     '99'          CMSTST
     C                   ADD       1             RECNO
     C                   SETON                                        55
     C                   WRITE     TRKSFL
     C                   SETOFF                                       55
     C                   ENDSR
      ***********************
      ** CHECK SUB FILE    **
      ***********************
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       1011
     C                   SETON                                            57
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C                   SETOFF                                       59
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     TRKSFL                             90
     C   90              GOTO      NXTCHK
      ** DONOT CHECK HEADINGS
     C     CMSTST        IFEQ      '99'
     C                   GOTO      NXTCHK
     C                   END
     C     CMFILL        IFEQ      'NT'
     C                   SETON                                        59
     C                   ELSE
     C                   SETOFF                                       59
     C                   END
     C     DAY           IFLT      0
     C     DAY           ORGT      7
     C                   SETON                                        1011
     C                   UPDATE    TRKSFL
     C                   ENDIF
     C                   SETOFF                                       10
      ** DO NOT ALLOW ANY TRUCK TO BE UNASSIGNED
     C     TSSVIA        IFEQ      '01'
     C     DAY           IFLT      1
     C     ROUT          ORLE      *BLANKS
     C                   SETOFF                                       57
     C                   END
     C                   END
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C                   ENDSR
      ***********************
      **   PUT SUB FILE    **
      ***********************
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     TRKSFL                             90
     C   90              GOTO      NXTPUT
      ** DONOT CHECK HEADINGS
     C     CMSTST        IFEQ      '99'
     C                   GOTO      NXTPUT
     C                   END
      ** UPDATE TRUCKS RECORD
     C     TRKKEY        KLIST
     C                   KFLD                    TSSHPD
     C                   KFLD                    TSSEQ#
     C     TRKKEY        CHAIN     FPUUCKS                            55
     C  N55              DO
     C                   Z-ADD     DAY           TSDAY#
     C                   MOVEL     ROUT          TSROUT
     C                   Z-ADD     STOP          TSSTOP
     C                   UPDATE    RPUUCKS
     C                   ENDDO
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
     C                   ENDSR
      ***********************
      ** ORDER INQUIRY     **
      ***********************
     C     ORDINQ        BEGSR
     C     LINE          CHAIN     TRKSFL                             91
     C   91              GOTO      ENDINQ
     C                   EXSR      BLDORD
     C                   EXFMT     ORDCTL
     C     ENDINQ        ENDSR
      ***********************
      ** BUILD ORDER SFL   **
      ***********************
     C     BLDORD        BEGSR
     C                   SETON                                        80
     C                   WRITE     ORDCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECN1             5 0
     C                   Z-ADD     0             TOTQTY            7 0
     C                   Z-ADD     0             ORDQTY            7 0
     C                   Z-ADD     0             ORDS              5 0
     C     CMFILL        IFEQ      'NT'
     C                   SETON                                        59
     C                   ELSE
     C                   SETOFF                                       59
     C                   END
     C     TRKOKY        KLIST
     C                   KFLD                    TSSHPD
     C                   KFLD                    TSSEQ#
     C*    TSCUST        CHAIN     FMCUST                             91
     C     OHCUST        CHAIN     FMCUST                             91
     C     TRKOKY        SETLL     FPUUCKO
     C     NXTRI1        TAG
     C     TRKOKY        READE     FPUUCKO                                91
     C   91              GOTO      ENDTRI
     C     TOORD#        SETLL     FIORDR
     C     NXTRI2        TAG
     C     TOORD#        READE     FIORDR                                 91
     C   91              DO
     C                   Z-ADD     0             OIORD#
     C                   Z-ADD     0             OISEQ#
     C                   MOVE      *BLANKS       OIITEM
     C                   MOVE      *BLANKS       OISIZE
     C                   MOVE      *BLANKS       OIDES1
     C                   Z-ADD     ORDQTY        QTYOPN
     C                   ADD       1             RECN1
     C                   MOVEL     MSG(9)        OIDES1
     C                   WRITE     ORDSFL
     C                   ADD       1             ORDS
     C                   Z-ADD     0             ORDQTY            7 0
     C                   GOTO      NXTRI1
     C                   ENDDO
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXTRI2
     C                   END
     C     OIQORD        SUB       OIQSHP        QTYOPN
     C                   ADD       QTYOPN        ORDQTY
     C                   ADD       QTYOPN        TOTQTY
     C                   ADD       1             RECN1
     C                   WRITE     ORDSFL
     C                   GOTO      NXTRI2
     C     ENDTRI        TAG
     C     ORDS          IFGT      1
     C                   Z-ADD     0             OIORD#
     C                   Z-ADD     0             OISEQ#
     C                   MOVE      *BLANKS       OIITEM
     C                   MOVE      *BLANKS       OISIZE
     C                   MOVE      *BLANKS       OIDES1
     C                   Z-ADD     TOTQTY        QTYOPN
     C                   ADD       1             RECN1
     C                   MOVEL     MSG(10)       OIDES1
     C                   WRITE     ORDSFL
     C                   END
     C                   Z-ADD     0             OIORD#
     C                   Z-ADD     0             OISEQ#
     C                   MOVE      *BLANKS       OIITEM
     C                   MOVE      *BLANKS       OISIZE
     C                   MOVEL     MSG(8)        OIDES1
     C                   Z-ADD     0             QTYOPN
     C                   ADD       1             RECN1
     C                   WRITE     ORDSFL
     C                   SETOFF                                       59
     C                   ENDSR
      ***********************
      ** CHANGE SHIP VIA   **
      ***********************
     C     GETVIA        BEGSR
     C     LINE          CHAIN     TRKSFL                             91
     C   91              GOTO      ENDVIA
     C                   If        CMSTST <> '99'
     C                   Z-ADD     LINE          PAGE#
     C     TRKKEY        CHAIN     FPUUCKS                            75
     C   75              GOTO      ENDVIA
     C     TSORD#        CHAIN     FHORDR                             91
     C   91              GOTO      ENDVIA
     C     TSSVIA        CHAIN     FMSVIA                             90
     C                   MOVEL     SVDESC        CSDESC
     C     NEWVIA        TAG
     C                   MOVE      *BLANKS       SVDESC
     C                   MOVE      '? '          NVIA
     C                   MOVE      *BLANKS       OVIA              2
     C                   SETOFF                                       109899
     C     NXTVIA        TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              GOTO      ENDVIA
     C   KF              GOTO      NEWVIA
     C                   SETOFF                                       10  99
     C     NVIA          IFEQ      '? '
     C     NVIA          OREQ      ' ?'
     C                   CALL      'LKSVIA'
     C                   PARM                    NVIA
     C                   PARM                    SVDESC
     C                   SETON                                            99
     C                   GOTO      NXTVIA
     C                   ENDIF
WJB  C*          NVIA      IFNE '99'
WJB  C*          NVIA      ANDNE'01'
WJB  C*          NVIA      ANDNE'02'
WJB  C*          NVIA      ANDNE'03'
WJB  C*          NVIA      ANDNE'04'
WJB  C*          NVIA      ANDNE'05'
WJB  C*          NVIA      ANDNE'15'
WJB  C*          NVIA      ANDNE'18'
WJB  C*          NVIA      ANDNE'19'
WJB  C*          NVIA      ANDNE'24'
WJB  C*          NVIA      ANDNE'28'
WJB  C*          NVIA      ANDNE'30'
WJB  C*                    SETON                     10  99
WJB  C*                    GOTO NXTVIA
WJB  C*                    END
     C     NVIA          IFNE      '99'
     C     NVIA          CHAIN     FMSVIA                             71
WJB  C     *IN71         IFEQ      *ON
WJB  C                   SETON                                        10  99
WJB  C                   GOTO      NXTVIA
WJB  C                   END
     C                   ELSE
     C                   MOVEL     MSG(9)        SVDESC
     C                   END
     C     NVIA          IFNE      OVIA
     C                   SETOFF                                       98
     C                   MOVEL     NVIA          OVIA
     C                   END
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTVIA
     C                   END
     C     NVIA          IFNE      '01'
     C                   MOVEL     NVIA          TSSVIA
     C                   MOVEL     NVIA          TSNVIA
     C  N75              UPDATE    RPUUCKS
     C                   ELSE
     C  N75              DELETE    RPUUCKS
     C                   END
     C     ENDVIA        TAG
     C                   EndIf
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY
     C                   Z-ADD     0             WEEK
     C                   Z-ADD     0             YEAR
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##CYMD        CHAIN     FCALENCY                           10
     C                   MOVEL     CLCENT        YEAR
     C                   MOVE      CLYEAR        YEAR
     C                   Z-ADD     CLWEEK        WEEK
     C                   Z-ADD     CLWEEK        CWEEK
     C                   Z-ADD     YEAR          CYEAR
     C   10              SETOFF                                       10
     C                   ENDSR
** Day Names
Monday                                           1
Tuesday                                          2
Wednesday                                        3
Thursday                                         4
Friday                                           5
Saturday                                         6
Sunday                                           7
     *** End of Data ***                         8
    Total Quanitiy This Order:                   9
    Total Quanitiy All Orders:                  10
