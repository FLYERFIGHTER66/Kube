      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      *PROGRAM NAME-------- ARR950
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- MARK A/R HISTORY RECORDS FOR DELETION
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFARHISTD  IF   E           K DISK
     FFAHSEL    UF A E           K DISK
     F*FAHSEL  O   E           K        DISK                      A
      *
     D                UDS
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LCUST                  9     14  0
     D  LPRINT                15     15
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
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        RDATE             7 0
      *
     C     NXT           TAG
     C                   READ      FARHISTD                               90
     C   90              GOTO      END
      *
     C     AHCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   END
      *
     C     AHKEY         KLIST
     C                   KFLD                    AHCUST
     C                   KFLD                    AHINV#
     C     AHKEY         CHAIN     FAHSEL                             92
     C  N92              GOTO      NXT
      *
     C*          AHTTYP    IFEQ 5
     C     AHTDAT        IFLE      RDATE
     C                   EXSR      UAHSEL
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *********
      * UAHSEL
      *********
     C     UAHSEL        BEGSR
     C                   Z-ADD     AHCUST        RHCUST
     C                   Z-ADD     AHINV#        RHINV#
     C                   WRITE     RAHSEL
     C                   ENDSR
      *
