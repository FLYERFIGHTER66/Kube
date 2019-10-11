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
      **PROGRAM NAME-------- ICR800
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- INVENTORY CONTROL (NON LOT) INQUIRY INTO
      *                      TRANSACTIONS.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FICR800FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     F                                     SFILE(DETSFL:RECN1)
     FFMINVT    IF   E           K DISK
     FFTINVTIS  IF   E           K DISK
     FFPRODCD   IF   E           K DISK
      *
      *
     D MSG             S             30    DIM(12) CTDATA PERRCD(1)             MESSAGES
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
     D*                                       1   20LCO                   ARC380
     D*                                       3   80BEGDAT
     D*                                       9  140ENDDAT
     D*                                      15  26 ITEM
     D*                                      27  29 SIZE
     D*                                     100 109 LPRTR
     D*                                     110 119 LFORM
     D*                                     120 1210LCOPY
     D*                                     122 122 LJOBQ
     D*                                     123 126 LHOLD
     D*                                     127 130 LSAVE
     D  LCANCL               133    133
      ***********************
      ** START HERE        **
      ***********************
     C                   IF        PITEM <> *BLANKS
     C                   Eval      ITEM = PITEM
     C                   Eval      SIZE = PSIZE
     C                   Goto      Skip_A
     C                   EndIf
     C     RSTART        TAG
     C                   MOVE      *BLANKS       LCANCL
     C                   CLEAR                   *IN
     C     NXTA          TAG
     C                   WRITE     SCRENA
     C                   READ      SCRENA                                 90
     C     SKIP_A        TAG
      ** CHECK F KEYS
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
      ** RESET INDICATORS
     C                   SETOFF                                       101120
     C                   SETOFF                                       3031
      ** CHECK ITEM NUMBER
     C                   MOVEL     ITEM          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     ITEM:2        IMLOOK
     C                   MOVEL     SIZE          IMSIZE
     C                   CALL      'LKITAL'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   GOTO      NXTA
     C                   ENDIF
      ** SEE IF VALID
     C     ITMKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C     ITMKEY        CHAIN     FMINVT                             10
     C   10              GOTO      NXTA
      ** CHECK DATES
     C     BEGDAT        IFGT      0
     C                   Z-ADD     BEGDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     ##CYMD        BEGCYM            7 0
     C                   ELSE
     C                   Z-ADD     0             BEGCYM
     C                   END                                                    BEGDAT > 0
     C     ENDDAT        IFGT      0
     C                   Z-ADD     ENDDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     ##CYMD        ENDCYM            7 0
     C                   ELSE
     C                   Z-ADD     9999999       ENDCYM
     C                   END                                                    ENDDAT > 0
      ** MAKE SURE DATE RANGE IS OK
     C     ENDCYM        IFLT      BEGCYM
     C                   SETON                                        3031
     C                   GOTO      NXTA
     C                   END
      ** IF HERE INPUT OK GET SCREEN TOTALS ETC
     C     BEGCYM        IFLE      0
     C                   SETON                                        51
     C                   ELSE
     C                   SETOFF                                       51
     C                   END
     C                   EXSR      GETTOT
     C     NXTB          TAG
     C                   WRITE     SCRENB
     C                   READ      SCRENB                                 90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       10
     C     ACT           IFNE      'A'
     C     ACT           ANDNE     'I'
     C     ACT           ANDNE     'R'
     C     ACT           ANDNE     'T'
     C     ACT           ANDNE     'C'
     C     ACT           ANDNE     'P'
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   END
      ** SHOW ALL DETAIL IF SELECTED
     C     ACT           IFEQ      'C'
     C                   EXSR      BLDDET
     C                   EXFMT     DETCTL
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C                   GOTO      NXTB
     C                   END
      ** SHOW SELECTED SUB FILE
     C                   EXSR      BLDSFL
     C     NXTFMT        TAG
     C                   EXFMT     RECCTL
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C                   GOTO      NXTB
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** GET TOTALS        **
      ***********************
     C     GETTOT        BEGSR
     C                   Z-ADD     0             TOTADJ
     C                   Z-ADD     0             TOTISS
     C                   Z-ADD     0             TOTREC
     C                   Z-ADD     0             TOTPRJ
     C                   Z-ADD     0             TOTTRN
     C                   Z-ADD     0             TOTAL
     C     ITMKEY        SETLL     FTINVTIS
     C     NXTGET        TAG
     C     ITMKEY        READE     FTINVTIS                               91
     C  N91              DO
     C     ITYDAT        IFGE      BEGCYM
     C     ITYDAT        ANDLE     ENDCYM
     C     ITTYPE        IFEQ      'A'
     C                   ADD       ITTQTY        TOTADJ
     C                   END
     C     ITTYPE        IFEQ      'R'
     C                   ADD       ITTQTY        TOTREC
     C                   END
     C     ITTYPE        IFEQ      'P'
     C                   ADD       ITTQTY        TOTPRJ
     C                   END
     C     ITTYPE        IFEQ      'T'
     C                   ADD       ITTQTY        TOTTRN
     C                   END
      ** GET SIGN REVERSED ON ISSUES
     C     ITTYPE        IFEQ      'I'
     C                   SUB       ITTQTY        TOTISS
     C                   END
     C                   END                                                    DATE RANGE
     C                   GOTO      NXTGET
     C                   ENDDO                                                  N91 DO
      ** NOW GET TOTAL
     C     TOTADJ        ADD       TOTREC        TOTAL
     C                   ADD       TOTPRJ        TOTAL
     C                   ADD       TOTISS        TOTAL
     C                   ADD       TOTTRN        TOTAL
     C                   ENDSR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     RECCTL
     C                   SETOFF                                       80
      ** GET HEADING AND TOTAL
     C     ACT           IFEQ      'A'
     C                   MOVEL     MSG(1)        TDESC
     C                   Z-ADD     TOTADJ        TYPTOT
     C                   END
     C     ACT           IFEQ      'I'
     C                   MOVEL     MSG(2)        TDESC
     C                   Z-ADD     TOTISS        TYPTOT
     C                   END
     C     ACT           IFEQ      'R'
     C                   MOVEL     MSG(3)        TDESC
     C                   Z-ADD     TOTREC        TYPTOT
     C                   END
     C     ACT           IFEQ      'P'
     C                   MOVEL     MSG(12)       TDESC
     C                   Z-ADD     TOTPRJ        TYPTOT
     C                   END
     C     ACT           IFEQ      'T'
     C                   MOVEL     MSG(4)        TDESC
     C                   Z-ADD     TOTTRN        TYPTOT
     C                   END
     C                   Z-ADD     0             RECNO             5 0
     C                   SETOFF                                       78
     C     ITMKEY        SETLL     FTINVTIS
     C     NXTBLD        TAG
     C     ITMKEY        READE     FTINVTIS                               91
     C  N91              DO
     C     ITTYPE        IFNE      ACT
     C                   GOTO      NXTBLD
     C                   END
     C     ITYDAT        IFGE      BEGCYM
     C     ITYDAT        ANDLE     ENDCYM
     C     ITDESC        IFLE      *BLANKS
     C     ITTYPE        ANDEQ     'A'
     C     ITREAS        CHAIN     FPRODCD                            77
     C  N77              MOVEL     PCDESC        ITDESC
     C                   END
     C     ITREAS        IFEQ      'PHY'
     C     ITTYPE        ANDEQ     'A'
     C     ITREAS        CHAIN     FPRODCD                            77
     C  N77              MOVEL     PCDESC        ITDESC
     C                   END
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   END
     C                   GOTO      NXTBLD
     C                   ENDDO                                                  N91 DO
     C                   Z-ADD     0             ITTDAT
     C                   Z-ADD     0             ITTQTY
     C                   MOVE      *BLANKS       ITDESC
     C                   MOVE      *BLANKS       ITUSER
     C                   MOVEL     MSG(5)        ITDESC
     C                   SETON                                        78
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   ENDSR
      ***********************
      ** BUILD DET FILE    **
      ***********************
     C     BLDDET        BEGSR
     C                   SETON                                        80
     C                   WRITE     DETCTL
     C                   SETOFF                                       80
      ** GET HEADING AND TOTAL
     C                   SETOFF                                       78
     C                   MOVEL     MSG(6)        TDESC
     C     TOTADJ        ADD       TOTISS        TYPTOT
     C                   ADD       TOTREC        TYPTOT
     C                   ADD       TOTPRJ        TYPTOT
     C                   ADD       TOTTRN        TYPTOT
     C                   Z-ADD     0             RECN1             5 0
     C     ITMKEY        SETLL     FTINVTIS
      ** PUT ISSUES FIRST
     C                   Z-ADD     0             ITTDAT
     C                   MOVEL     MSG(11)       ITDESC
     C                   MOVEL     MSG(8)        TYPE
     C                   MOVE      *BLANKS       ITUSER
     C                   Z-ADD     TOTISS        ITTQTY
     C                   ADD       1             RECN1
     C                   WRITE     DETSFL
     C     NXTDET        TAG
     C     ITMKEY        READE     FTINVTIS                               91
     C  N91              DO
     C     ITTYPE        IFEQ      'I'
     C                   GOTO      NXTDET
     C                   END
     C     ITYDAT        IFGE      BEGCYM
     C     ITYDAT        ANDLE     ENDCYM
     C     ITDESC        IFLE      *BLANKS
     C     ITTYPE        ANDEQ     'A'
     C     ITREAS        CHAIN     FPRODCD                            77
     C  N77              MOVEL     PCDESC        ITDESC
     C                   END
     C     ITREAS        IFEQ      'PHY'
     C     ITTYPE        ANDEQ     'A'
     C     ITREAS        CHAIN     FPRODCD                            77
     C  N77              MOVEL     PCDESC        ITDESC
     C                   END
     C     ITTYPE        IFEQ      'A'
     C                   MOVEL     MSG(7)        TYPE
     C                   END
     C     ITTYPE        IFEQ      'I'
     C                   MOVEL     MSG(8)        TYPE
     C                   END
     C     ITTYPE        IFEQ      'R'
     C                   MOVEL     MSG(9)        TYPE
     C                   END
     C     ITTYPE        IFEQ      'T'
     C                   MOVEL     MSG(10)       TYPE
     C                   END
     C     ITTYPE        IFEQ      'P'
     C                   MOVEL     MSG(12)       TYPE
     C                   END
     C                   ADD       1             RECN1
     C                   WRITE     DETSFL
     C                   END
     C                   GOTO      NXTDET
     C                   ENDDO                                                  N91 DO
     C                   Z-ADD     0             ITTDAT
     C                   Z-ADD     0             ITTQTY
     C                   MOVE      *BLANKS       ITDESC
     C                   MOVE      *BLANKS       ITUSER
     C                   MOVE      *BLANKS       TYPE
     C                   MOVEL     MSG(5)        ITDESC
     C                   SETON                                        78
     C                   ADD       1             RECN1
     C                   WRITE     DETSFL
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    PITEM            12
     C                   PARM                    PSIZE             3
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVE      'C'           ACT
     C                   ENDSR
** DESCRIPTION ARRAY
 Adjustments                              1
   Issues                                 2
  Receipts                                3
  Transfers                               4
   *** End of Data ***                    5
  All Types                               6
Adjust                                    7
Issue                                     8
Receipt                                   9
Transfer                                 10
Total of All Issues for Period           11
Project                                  12
