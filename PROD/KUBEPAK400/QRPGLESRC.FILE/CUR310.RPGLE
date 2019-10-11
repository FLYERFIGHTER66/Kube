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
      **PROGRAM NAME-------- CUR310
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- POST UPDATES TO CUT LOT FILE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFCUTNEED  UF   E           K DISK
     FFCUTLOT   UF   E           K DISK
     FFCUTCTL   UF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCUTSEQA  IF   E           K DISK
WJB  FFMVEND    IF   E           K DISK
     FFCUTORD   O  A E           K DISK
      *
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  ORD#                   1      6  0                                      ARC380
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
WJB
WJB  D  Vendor         S                   Like(IMVEND)
      ****************
      * START HERE   *
      ****************
     C                   MOVEL     'A'           STAT              1
WJB  C     VendStat      KList
WJB  C                   KFld                    Vendor
WJB  C                   KFld                    STAT
WJB  C*    STAT          SETLL     FCUTNEED
WJB  C     VendStat      SETLL     FCUTNEED
     C     NXT           TAG
WJB  C*    STAT          READE     FCUTNEED                               90                   ARC38
WJB  C     VendStat      READE     FCUTNEED                               90                   ARC38
     C   90              GOTO      END
     C     LOTKEY        KLIST
WJB  C                   KFLD                    Vendor
     C                   KFLD                    CNITEM
     C                   KFLD                    CNSIZE
     C*                  KFLD                    CNUSEC
     C                   KFLD                    CNSOWD
     C     LOTKEY        CHAIN     FCUTLOT                            91
     C  N91              DO
     C                   ADD       CNQTSH        CLQTOO
     C     CLQTOH        ADD       CLQTOO        CLQTAV
     C                   SUB       CLQTSL        CLQTAV
     C                   UPDATE    RCUTLOT
     C*    CNQTSH        IFGT      0
     C     CNQTSH        IFNE      0
     C                   EXSR      GETORD
     C                   END
     C                   MOVEL     'D'           CNSTAT
     C                   UPDATE    RCUTNEED
     C                   ENDDO
     C                   GOTO      NXT
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ****************
      * BUILD ORDER  *
      ****************
     C     GETORD        BEGSR
     C     COORD#        IFLE      0
     C     CTLKEY        KLIST
     C                   KFLD                    LCO
WJB  C                   KFLD                    Vendor
     C                   Z-ADD     1             LCO               2 0
     C     CTLKEY        CHAIN     FCUTCTL                            92
     C                   Z-ADD     CCNXTO        COORD#
     C                   Z-ADD     CCNXTO        ORD#
     C                   ADD       1             CCNXTO
     C                   MOVEL     'N'           CCTXFR
     C  N92              UPDATE    RCUTCTL
     C                   END
     C     ITMKEY        KLIST
     C                   KFLD                    CNITEM
     C                   KFLD                    CNSIZE
     C     ITMKEY        CHAIN     FMINVT                             92
     C                   MOVEL     CNITEM        COITEM
     C                   MOVEL     CNSIZE        COSIZE
     C                   Z-ADD     CNSOWD        COSOWD
     C                   MOVEL     CNSVND        COSVND
     C                   MOVEL     IMLOOK        COLOOK
     C                   MOVEL     IMLOOK        CSLOOK
     C                   MOVEL     IMVITM        COVITM
     C                   Z-ADD     CNQTSH        COQTOO
     C                   MOVEL     'N'           COPRTD
     C                   MOVEL     'N'           COTRAN
      ** GET VENDOR ALPHA SEARCH   CURRENTLY NOT USED
     C                   GOTO      NOLOOK
     C                   MOVEL     IMLOOK        TST8              8
     C                   MOVE      *BLANKS       CSLOOK
     C                   MOVEL     TST8          CSLOOK
WJB  C     VendLook      KList
WJB  C                   KFld                    Vendor
WJB  C                   KFld                    CSLOOK
WJB  C*    CSLOOK        CHAIN     FCUTSEQA                           55
WJB  C     VendLook      CHAIN     FCUTSEQA                           55
     C   55              DO
     C                   MOVEL     IMLOOK        TST7              7
     C                   MOVE      *BLANKS       CSLOOK
     C                   MOVEL     TST7          CSLOOK
WJB  C*    CSLOOK        CHAIN     FCUTSEQA                           55
WJB  C     VendLook      CHAIN     FCUTSEQA                           55
     C                   ENDDO
     C   55              DO
     C                   MOVEL     IMLOOK        TST6              6
     C                   MOVE      *BLANKS       CSLOOK
     C                   MOVEL     TST6          CSLOOK
WJB  C*    CSLOOK        CHAIN     FCUTSEQA                           55
WJB  C     VendLook      CHAIN     FCUTSEQA                           55
     C                   ENDDO
     C   55              DO
     C                   MOVEL     IMLOOK        TST5              5
     C                   MOVE      *BLANKS       CSLOOK
     C                   MOVEL     TST5          CSLOOK
WJB  C*    CSLOOK        CHAIN     FCUTSEQA                           55
WJB  C     VendLook      CHAIN     FCUTSEQA                           55
     C                   ENDDO
     C   55              DO
     C                   MOVEL     IMLOOK        TST4              4
     C                   MOVE      *BLANKS       CSLOOK
     C                   MOVEL     TST4          CSLOOK
WJB  C*    CSLOOK        CHAIN     FCUTSEQA                           55
WJB  C     VendLook      CHAIN     FCUTSEQA                           55
     C                   ENDDO
     C   55              DO
     C                   MOVEL     IMLOOK        TST3              3
     C                   MOVE      *BLANKS       CSLOOK
     C                   MOVEL     TST3          CSLOOK
WJB  C*    CSLOOK        CHAIN     FCUTSEQA                           55
WJB  C     VendLook      CHAIN     FCUTSEQA                           55
     C                   ENDDO
     C   55              DO
     C                   MOVEL     IMLOOK        TST2              2
     C                   MOVE      *BLANKS       CSLOOK
     C                   MOVEL     TST2          CSLOOK
WJB  C*    CSLOOK        CHAIN     FCUTSEQA                           55
WJB  C     VendLook      CHAIN     FCUTSEQA                           55
     C                   ENDDO
     C   55              DO
     C                   MOVE      *BLANKS       CSLOOK
     C                   MOVEL     '99999999'    CSLOOK
     C                   ENDDO
     C                   MOVEL     CSLOOK        COVNAL
     C     NOLOOK        TAG
     C                   Z-ADD     VMVEND        COVEND
     C                   WRITE     RCUTORD
      ** IF ANY ORDERED DO NOT CANCEL
     C                   MOVE      *BLANKS       LCANCL
     C                   ENDSR
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
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        COORDD
      ** GET PRINT PARMS
     C                   MOVEL     'P1      '    LPRTR
     C                   MOVEL     '*NAR'        LFORM
     C                   Z-ADD     1             LCOPY
     C                   MOVEL     'N'           LJOBQ
     C                   MOVEL     '*NO  '       LHOLD
     C                   MOVEL     '*NO  '       LSAVE
     C                   MOVEL     'X'           LCANCL
     C                   ENDSR
