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
      *PROGRAM NAME-------- ARR490
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- MONTHLY PURGE OF A/R OPEN FILE.
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      * 09/08/05 - WJB - Removed Suffix from the Level Break so that the ENTIRE invoice
      *                  must balance to zero to be elegible for purge.
      *
     FFAROPN    IF   E           K DISK
WJB  F*FARSEL  O   E           K        DISK                      A
WJB  FFARSEL    UF A E           K DISK
      *
     D                UDS
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LADD                   9      9
     D  LPRINT                10     10
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *
     C                   Z-ADD     1             CNT               9 0
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        RDATE             7 0
      *
     C     NXT           TAG
     C                   READ      FAROPN                                 90
     C   90              GOTO      END
      *
     C     ARCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   END
      *
     C*          ARCUST    IFNE OCUST
     C*          ARINV#    ORNE OINV#
     C*          ARSUFF    ORNE OSUFF
     C*                    SETOF                     77
     C*                    ENDIF
      *
     C     ARCUST        IFEQ      OCUST
     C     ARINV#        ANDEQ     OINV#
WJB  C*    ARSUFF        ANDEQ     OSUFF
     C                   GOTO      NOL1
     C                   ENDIF
      *
     C  N77CNT           IFGT      1
     C     WRKNET        ANDEQ     *ZEROS
     C                   Z-ADD     OCUST         PICUST
     C                   Z-ADD     OINV#         PIINV#
     C                   Z-ADD     OCOMP         PICOMP
     C                   MOVEL     OSUFF         PISUFF
     C                   WRITE     RARSEL
     C                   ENDIF
WJB  C* DELETE THE INVOICE FROM THE REMOVAL FILE IF L/C STILL DUE
WJB  C  N77CNT           IFGT      1
WJB  C     WRKNET        ANDNE     *ZEROS
WJB  C     OSTAT         ANDEQ     'L'
WJB  C                   Z-ADD     OCUST         PICUST
WJB  C                   Z-ADD     OINV#         PIINV#
WJB  C                   MOVE      '  '          PISUFF
WJB  C     PIKEY         KLIST
WJB  C                   KFLD                    PICUST
WJB  C                   KFLD                    PIINV#
WJB  C                   KFLD                    PISUFF
WJB  C     PIKEY         CHAIN     FARSEL                             91
WJB  C  N91              DELETE    RARSEL
WJB  C                   ENDIF
     C                   Z-ADD     *ZEROS        WRKNET           11 2
     C                   SETOFF                                       77
      *
     C     NOL1          TAG
      *
     C     ARTDAT        IFGT      RDATE
     C                   SETON                                        77
     C                   ENDIF
      *
WJB  C                   MOVE      ARSTAT        OSTAT             1
     C                   Z-ADD     ARCUST        OCUST             6 0
     C                   Z-ADD     ARINV#        OINV#             6 0
     C                   Z-ADD     ARCOMP        OCOMP             2 0
     C                   MOVEL     ARSUFF        OSUFF             2
      *
     C                   ADD       AR$AMT        WRKNET
      *
     C                   ADD       1             CNT
     C                   GOTO      NXT
      *
     C     END           TAG
EFD01C  N77WRKNET        IFEQ      0
EFD01C                   Z-ADD     OCUST         PICUST
EFD01C                   Z-ADD     OINV#         PIINV#
EFD01C                   Z-ADD     OCOMP         PICOMP
EFD01C                   MOVEL     OSUFF         PISUFF
EFD01C                   WRITE     RARSEL
EFD01C                   ENDIF
     C                   SETON                                        LR
      *
