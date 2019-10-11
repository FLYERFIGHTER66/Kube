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
      **PROGRAM NAME-------- GLR660
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- EFDGL
      **PROGRAMMER---------- EFD
      **APPLICATION--------- ROLL BEG BALANCES
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/12/01 EFD UPDATE LAST YEAR BALANCES WITH THIS YEAR FROM
      *              INPUT FILE.    EFD01
      *
     FGLR660FM  CF   E             WORKSTN
     FFMGLCH    IF   E           K DISK
     FFGLBALI   IF   E           K DISK
     F                                     RENAME(RGLBAL:GLBAL)
     FFGLBAL    UF   E           K DISK
     FFGLCTL    IF   E           K DISK
      *
      * GLBAL  ARRAY IN
     D GLP             S             11  2 DIM(13)
     D GLN             S             11  2 DIM(13)
EFD01 * GLBAL  ARRAY OUT
EFD01D OLP             S             11  2 DIM(13)
EFD01D OLN             S             11  2 DIM(13)
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
     D  LCO                    1      2  0                                      ARC380
     D  LCANCL               133    133                                         ARC380
      *
     IGLBAL
     I              GLBALT                      NEWBLT
     I              GLBALL                      NEWBLL
     I              GLT01                       GLP(1)
     I              GLT02                       GLP(2)
     I              GLT03                       GLP(3)
     I              GLT04                       GLP(4)
     I              GLT05                       GLP(5)
     I              GLT06                       GLP(6)
     I              GLT07                       GLP(7)
     I              GLT08                       GLP(8)
     I              GLT09                       GLP(9)
     I              GLT10                       GLP(10)
     I              GLT11                       GLP(11)
     I              GLT12                       GLP(12)
     I              GLT13                       GLP(13)
     I              GLL01                       GLN(1)
     I              GLL02                       GLN(2)
     I              GLL03                       GLN(3)
     I              GLL04                       GLN(4)
     I              GLL05                       GLN(5)
     I              GLL06                       GLN(6)
     I              GLL07                       GLN(7)
     I              GLL08                       GLN(8)
     I              GLL09                       GLN(9)
     I              GLL10                       GLN(10)
     I              GLL11                       GLN(11)
     I              GLL12                       GLN(12)
     I              GLL13                       GLN(13)
      *
      *
EFD01IRGLBAL
 |   I              GLT01                       OLP(1)
 |   I              GLT02                       OLP(2)
 |   I              GLT03                       OLP(3)
 |   I              GLT04                       OLP(4)
 |   I              GLT05                       OLP(5)
 |   I              GLT06                       OLP(6)
 |   I              GLT07                       OLP(7)
 |   I              GLT08                       OLP(8)
 |   I              GLT09                       OLP(9)
 |   I              GLT10                       OLP(10)
 |   I              GLT11                       OLP(11)
 |   I              GLT12                       OLP(12)
 |   I              GLT13                       OLP(13)
 |   I              GLL01                       OLN(1)
 |   I              GLL02                       OLN(2)
 |   I              GLL03                       OLN(3)
 |   I              GLL04                       OLN(4)
 |   I              GLL05                       OLN(5)
 |   I              GLL06                       OLN(6)
 |   I              GLL07                       OLN(7)
 |   I              GLL08                       OLN(8)
 |   I              GLL09                       OLN(9)
 |   I              GLL10                       OLN(10)
 |   I              GLL11                       OLN(11)
 |   I              GLL12                       OLN(12)
EFD01I              GLL13                       OLN(13)
      ***********************
      ** START HERE        **
      ***********************
     C     LCO           CHAIN     FGLCTL                             90
     C     GZYCYN        IFEQ      'Y'
     C                   WRITE     SCRNNE
     C                   READ      SCRNNE                                 90
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      EOJ
     C                   END
      *
     C                   Z-ADD     0             TOTAL            11 2
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C     LCO           SETLL     FGLBALI
     C     NXT           TAG
     C     LCO           READE     FGLBALI                                90
     C   90              GOTO      END
     C     BALKEY        CHAIN     FMGLCH                             71
     C   71              GOTO      NXT
     C     GCATYP        IFEQ      1
     C     GCATYP        OREQ      2
     C     BALKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GLGLNO
     C     BALKEY        CHAIN(N)  FGLBAL                             70
     C   70              GOTO      NXT
     C                   XFOOT     GLP           WORK             11 2
     C                   ADD       NEWBLT        WORK
     C                   ADD       WORK          TOTAL
     C                   END
     C                   GOTO      NXT
      ** CHECK IF OK
     C     END           TAG
     C     TOTAL         IFNE      0
     C                   WRITE     SCRNE
     C                   READ      SCRNE                                  90
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      EOJ
     C                   END
      ** IF OK UPDATE BALANCES AND CLOSE YEAR
     C                   WRITE     SCRNB
     C     LCO           SETLL     FGLBALI
     C     NXTUP         TAG
     C     LCO           READE     FGLBALI                                90
     C   90              GOTO      EOJ
     C     BALKEY        CHAIN     FMGLCH                             71
     C   71              GOTO      NXTUP
EFD01C**         GCATYP    IFEQ 1
EFD01C**         GCATYP    OREQ 2
     C     BALKEY        CHAIN     FGLBAL                             70
     C   70              GOTO      NXTUP
EFD01C     GCATYP        IFEQ      1
EFD01C     GCATYP        OREQ      2
     C                   XFOOT     GLP           WORK             11 2
     C                   ADD       NEWBLT        WORK
     C                   ADD       WORK          TOTAL
     C                   Z-ADD     WORK          GLBALT
EFD01C                   ELSE
EFD01C                   Z-ADD     0             GLBALT
EFD01C                   END
EFD01C                   Z-ADD     GLP           OLN
     C                   UPDATE    RGLBAL
EFD01C**                   END
     C                   GOTO      NXTUP
     C     EOJ           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVE      *BLANKS       LCANCL
     C                   ENDSR
