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
      **PROGRAM NAME-------- CUR360
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- POST UPDATES TO CUT LOT FILE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFCUTLOT   UF   E           K DISK
     FFCUTORDN  UF   E           K DISK
WJB  FFMVEND    IF   E           K DISK
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
WJB  D  Vendor         S                   Like(VMVEND)
      ****************
      * START HERE   *
      ****************
WJB  C     VendOrd#      KList
WJB  C                   KFld                    Vendor
WJB  C                   KFld                    ORD#
WJB  C*    ORD#          SETLL     FCUTORDN
WJB  C     VendOrd#      SETLL     FCUTORDN
     C     NXT           TAG
WJB  C*    ORD#          READE     FCUTORDN                               90                   ARC38
WJB  C     VendOrd#      READE     FCUTORDN                               90                   ARC38
     C   90              GOTO      END
     C     COTRAN        IFNE      'Y'
     C     COQTRC        OREQ      0
     C     COSTAT        ORNE      ' '
     C                   GOTO      NXT
     C                   END
     C     LOTKEY        KLIST
WJB  C                   KFLD                    Vendor
     C                   KFLD                    COITEM
     C                   KFLD                    COSIZE
     C*                  KFLD                    COUSEC
     C                   KFLD                    COSOWD
     C     LOTKEY        CHAIN     FCUTLOT                            91
     C  N91              DO
     C                   ADD       COQTRC        CLQTOH
     C                   SUB       COQTOO        CLQTOO
     C     CLQTOH        ADD       CLQTOO        CLQTAV
     C                   SUB       CLQTSL        CLQTAV
     C                   UPDATE    RCUTLOT
     C                   MOVEL     'C'           COSTAT
     C                   UPDATE    RCUTORD
     C                   ENDDO
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
