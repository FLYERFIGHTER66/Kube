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
      *PROGRAM NAME--------- APR410
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *DESCRIPTION---------- POST TO A/P MONTHLY DISBURSEMENTS FILE
      *                      AND A/P CHECK RECONCILIATION FILE.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFAPCHK    UF   E           K DISK
     FFMVEND    UF   E           K DISK
     FFYVEND    UF A E           K DISK
     FFAPFUT    UF A E           K DISK
     FFAPMTH    O  A E             DISK
     FFAPREC    O  A E           K DISK
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
     D                UDS
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LDISB                  9      9
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   MOVEL     USERID        USER              8
      *
     C     NXT           TAG
     C                   READ      FAPCHK                                 90
     C   90              GOTO      END
      *
     C     ACCOMP        IFNE      LCO
     C     ACSTAT        ORNE      'A'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     ACCTYP        IFNE      'V'
     C                   EXSR      VEND
     C                   EXSR      APMTH
     C                   EXSR      V1099
     C                   END
     C                   EXSR      APREC
      *
     C                   DELETE    RAPCHK
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      ********
      * VEND *
      ********
     C     VEND          BEGSR
     C                   Z-ADD     ACCKDT        TRNDT             6 0
     C                   CALL      'GETAPER'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    TRNDAT            6 0
     C                   PARM                    ERR               1 0
     C     ACVEND        CHAIN     FMVEND                             98
     C     ACTPER        IFNE      99
     C                   ADD       AC$NET        VMPAID
     C                   ADD       ACDTAK        VMYDIT
     C                   ELSE
     C     ACVEND        CHAIN     FAPFUT                             97
     C   97              DO
     C                   CLEAR                   RAPFUT
     C                   Z-ADD     ACVEND        AFVEND
     C                   MOVEL     'A'           AFSTAT
     C                   ENDDO
     C                   ADD       AC$NET        AFPAID
     C                   ADD       ACDTAK        AFDTAK
     C   97              WRITE     RAPFUT
     C  N97              UPDATE    RAPFUT
     C                   END
     C                   Z-ADD     ACCKDT        VMDTPY
     C                   MOVEL     USER          VMUSER
     C                   Z-ADD     TIMOD         VMTIME
     C                   Z-ADD     TDATE         VMDTLA
     C  N98              UPDATE    RMVEND
      **
     C                   ENDSR
      *********
      * APREC *
      *********
     C     APREC         BEGSR
     C                   SETOFF                                       10
     C     ACCTYP        IFEQ      'V'
     C                   SETON                                        10
     C                   ENDIF
     C                   MOVEL     'A'           AKSTAT
     C                   Z-ADD     ACCOMP        AKCOMP
     C                   Z-ADD     ACCHEK        AKCHEK
     C                   Z-ADD     ACCKDT        AKCKDT
     C                   Z-ADD     ACVEND        AKVEND
     C                   Z-ADD     AC$AMT        AK$AMT
     C                   Z-ADD     ACDTAK        AKDTAK
     C                   Z-ADD     AC$NET        AK$NET
     C                   Z-ADD     ACTDAT        AKTDAT
     C                   MOVEL     ACTDES        AKTDES
     C                   Z-ADD     ACPEDT        AKPEDT
     C                   Z-ADD     ACPSDT        AKPSDT
     C                   MOVEL     ACGLUD        AKGLUD
     C                   MOVEL     ACVUPD        AKVUPD
     C                   MOVEL     USER          AKUSER
     C                   Z-ADD     TIMOD         AKTIME
     C                   Z-ADD     TDATE         AKDTLA
     C   10              MOVEL     'Y'           AKCKRC
     C  N10              MOVEL     ' '           AKCKRC
     C   10              Z-ADD     ACCKDT        AKDTRC
     C  N10              Z-ADD     0             AKDTRC
     C                   MOVEL     ACCTYP        AKCTYP
     C                   WRITE     RAPREC
     C                   ENDSR
      *********
      * APMTH *
      *********
     C     APMTH         BEGSR
     C                   MOVEL     'A'           AMSTAT
     C                   Z-ADD     ACCOMP        AMCOMP
     C                   Z-ADD     ACCHEK        AMCHEK
     C                   Z-ADD     ACCKDT        AMCKDT
     C                   Z-ADD     ACVEND        AMVEND
     C                   Z-ADD     AC$AMT        AM$AMT
     C                   Z-ADD     ACDTAK        AMDTAK
     C                   Z-ADD     AC$NET        AM$NET
     C                   Z-ADD     ACTDAT        AMTDAT
     C                   MOVEL     ACTDES        AMTDES
     C                   Z-ADD     ACPEDT        AMPEDT
     C                   Z-ADD     ACPSDT        AMPSDT
     C                   MOVEL     ACGLUD        AMGLUD
     C                   MOVEL     ACVUPD        AMVUPD
     C                   MOVEL     USER          AMUSER
     C                   Z-ADD     TIMOD         AMTIME
     C                   Z-ADD     TDATE         AMDTLA
     C                   MOVEL     ACCTYP        AMCTYP
     C                   WRITE     RAPMTH
     C                   ENDSR
      ********
      * V1099
      ********
     C     V1099         BEGSR
     C                   MOVE      LDATE         YEAR              2 0
     C     YEAR          IFGT      80
     C                   MOVEL     1900          Y4                4 0
     C                   ELSE
     C                   MOVEL     2000          Y4
     C                   END
     C                   MOVE      YEAR          Y4
     C     V10KEY        KLIST
     C                   KFLD                    Y4
     C                   KFLD                    LCO
     C                   KFLD                    ACVEND
     C     V10KEY        CHAIN     FYVEND                             98
     C   98              DO
     C                   CLEAR                   RYVEND
     C                   Z-ADD     LCO           YMCONO
     C                   Z-ADD     ACVEND        YMVEND
     C                   Z-ADD     Y4            YMYEAR
     C                   ENDDO
     C                   ADD       AC$NET        YMPAID
     C  N98              UPDATE    RYVEND
     C   98              WRITE     RYVEND
     C                   ENDSR
      *
