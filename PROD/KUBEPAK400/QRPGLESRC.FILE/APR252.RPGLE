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
      *PROGRAM NAME--------- APR252
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *APPLICATION---------- VOID BLANK CHECK
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAPREC    UF A E           K DISK
     FAPR252FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     D  USERID               254    261
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     0             CNTA              6 0
      *
     C     RSTRT         TAG
     C                   Z-ADD     *ZEROS        VCHECK
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       50
     C     NXT           TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102021
     C                   SETOFF                                       22
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO
      *
     C     VCHECK        IFEQ      *ZEROS
     C                   SETON                                        2021
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     KEY8          KLIST
     C                   KFLD                    LCO
     C                   KFLD                    VCHECK
     C     KEY8          CHAIN     FAPREC                             92
     C  N92              SETON                                        2022
     C   20
     CAN 22              GOTO      RSTRT
      *
     C                   ADD       1             CNT
     C                   ADD       1             CNTA
     C                   Z-ADD     VCHECK        LCHECK
      *
     C     CNTA          IFGT      1
     C                   SETON                                        55
     C                   ENDIF
      *
     C                   SETON                                        50
     C     CNT           IFEQ      1
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   MOVEL     'A'           AKSTAT
     C                   Z-ADD     LCO           AKCOMP
     C                   Z-ADD     VCHECK        AKCHEK
     C                   Z-ADD     TDATE         AKCKDT
     C                   Z-ADD     *ZEROS        AKVEND
     C                   Z-ADD     *ZEROS        AK$AMT
     C                   Z-ADD     *ZEROS        AKDTAK
     C                   Z-ADD     *ZEROS        AK$NET
     C                   Z-ADD     TDATE         AKTDAT
     C                   MOVEL     *BLANKS       AKTDES
     C                   MOVEL     'Void Che'    DESC             10
     C                   MOVE      'ck'          DESC
     C                   MOVEL     DESC          AKTDES
     C                   Z-ADD     *ZEROS        AKPEDT
     C                   Z-ADD     *ZEROS        AKPSDT
     C                   MOVEL     'Y'           AKGLUD
     C                   MOVEL     'Y'           AKVUPD
     C                   Z-ADD     TDATE         AKDTLA
     C                   Z-ADD     TIMOD         AKTIME
     C                   MOVEL     USERID        AKUSER
     C                   MOVEL     'Y'           AKCKRC
     C                   Z-ADD     *ZEROS        AKDTRC
     C                   MOVEL     *BLANKS       AKCTYP
     C                   WRITE     RAPREC
     C                   GOTO      RSTRT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
