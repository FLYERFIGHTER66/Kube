      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- CHR300
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- GET NUMBER OF OPEN FLATS/POLES   (CALLED)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFCHMLOCP  IF   E           K DISK
      *
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
      *   PARMS      *
      ****************
     C     *ENTRY        PLIST
     C                   PARM                    STRDAT            7 0
     C                   PARM                    SECT              2 0
     C                   PARM                    BAY               2 0
     C                   PARM                    NORS              1
     C                   PARM                    BPOLE             2 0
     C                   PARM                    BLORR             1
     C                   PARM                    EPOLE             2 0
     C                   PARM                    ELORR             1
     C                   PARM                    OPNPOL            3 0
     C                   PARM                    OPNFLT            5 0
     C                   PARM                    CPAVL             3 0
      ** GET PROG FIELDS
     C                   Z-ADD     EPOLE         POLE              2 0
     C                   MOVEL     ELORR         LORR              1
     C                   Z-ADD     0             OPNPOL
     C                   Z-ADD     0             OPNFLT
      ** GET NUMBER OF POLES
     C     SECT          IFLE      5
     C                   Z-ADD     24            TOTPOL            3 0
     C                   ELSE
     C                   Z-ADD     28            TOTPOL
     C                   END
      * NOW I HAVE ALL SOWN HOW MANY POLES LEFT?
     C     LORR          IFEQ      'L'
     C                   Z-ADD     POLE          EPOLEW            2 0
     C                   Z-ADD     POLE          EPOLKY            2 0
     C                   ELSE
     C     TOTPOL        IFEQ      24
     C     12            SUB       POLE          SUBPOL            2 0
     C     13            ADD       SUBPOL        EPOLEW
     C                   ELSE
     C     14            SUB       POLE          SUBPOL            2 0
     C     15            ADD       SUBPOL        EPOLEW
     C                   END
     C     50            SUB       POLE          EPOLKY            2 0
     C                   END
     C                   Z-ADD     POLE          TSTPOL            2 0
      ** GET THIS POLE
     C     LOPKEY        CHAIN     FCHMLOCP                           91
     C     55            SUB       CLTRAY        CPAVL             3 0
     C     TOTPOL        SUB       EPOLEW        POLEFT
     C     POLEFT        MULT      55            POLFLT            3 0
      ** GET REST OF THIS POLE
     C                   ADD       CPAVL         POLFLT
     C                   ADD       1             POLEFT            2 0
      ** CHECK NEXT RECORD
     C     LOPKEY        KLIST
     C                   KFLD                    STRDAT
     C                   KFLD                    SECT
     C                   KFLD                    BAY
     C                   KFLD                    NORS
     C                   KFLD                    EPOLKY
     C     LOCTST        KLIST
     C                   KFLD                    STRDAT
     C                   KFLD                    SECT
     C                   KFLD                    BAY
     C                   KFLD                    NORS
     C                   ADD       1             EPOLKY            2 0
     C     LOPKEY        SETLL     FCHMLOCP
     C     LOCTST        READE     FCHMLOCP                               94
     C   94              DO
     C                   Z-ADD     POLEFT        OPNPOL
     C                   Z-ADD     POLFLT        OPNFLT
     C                   ENDDO                                                  94  DO
      ** N94 MEANS A RECORD AFTER CURRENT ONE IS USED
     C  N94              DO
     C     CLLOR         IFEQ      'L'
     C                   Z-ADD     CLPOLE        POLEW             2 0
     C                   ELSE
     C     TOTPOL        IFEQ      24
     C     12            SUB       CLPOLE        SUBPOL            2 0
     C     13            ADD       SUBPOL        POLEW
     C                   ELSE
     C     14            SUB       CLPOLE        SUBPOL            2 0
     C     15            ADD       SUBPOL        POLEW
     C                   END
     C                   END
     C     POLEW         SUB       EPOLEW        OPNPOL
     C**         TOTPOL    SUB  POLEW     OPNPOL
     C     55            MULT      OPNPOL        OPNFLT
     C                   ADD       CPAVL         OPNFLT
     C                   ADD       1             OPNPOL
     C                   ENDDO                                                  N94  DO
     C                   SETON                                        LR
