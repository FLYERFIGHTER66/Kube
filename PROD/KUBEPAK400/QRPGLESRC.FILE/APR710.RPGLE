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
      *PROGRAM NAME--------- APR710
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *DESCRIPTION---------- A/P YEAR END CLOSING.
      *                      THIS PROGRAM MOVES CURRENT YEAR TO PRIOR
      *                      AND ZEROS OUT THE Y-T-D AMOUNTS.
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMVEND    UF   E           K DISK
     FFAPCTL    UF   E           K DISK
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
     D  LSAVE                  3      3
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     NXTA          TAG
     C                   READ      FMVEND                                 90
     C   90              GOTO      END
      *
     C     VMCONM        IFNE      LCO
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     VMYPUR        VMLYPU
     C                   Z-ADD     VMYDIT        VMLYDT
     C                   Z-ADD     VMYDAV        VMLYDV
     C                   Z-ADD     VMPAID        VMLYPD
     C                   Z-ADD     *ZEROS        VMYPUR
     C                   Z-ADD     *ZEROS        VMYDIT
     C                   Z-ADD     *ZEROS        VMYDAV
     C                   Z-ADD     *ZEROS        VMPAID
     C                   MOVEL     USERID        VMUSER
     C                   Z-ADD     TDATE         VMDTLA
     C                   Z-ADD     TIMOD         VMTIME
      *
     C                   UPDATE    RMVEND
     C                   GOTO      NXTA
      *
     C     END           TAG
     C     LCO           CHAIN     FAPCTL                             90
     C                   Z-ADD     TDATE         AZDTYC
     C                   Z-ADD     TDATE         AZDTLA
     C                   Z-ADD     TIMOD         AZTIME
     C                   MOVEL     USERID        AZUSER
     C                   UPDATE    RAPCTL
     C                   SETON                                        LR
      *
