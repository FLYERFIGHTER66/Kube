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
      **PROGRAM NAME-------- CHR075
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- CAB
      **APPLICATION--------- CREATE TOTALS FILE FOR REPORTS.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFCHMJOB   IF   E           K DISK
     FFCHMCTL   IF   E           K DISK
     FFCHMRUN3  IF   E           K DISK
     FFCHMTOT2  UF   E           K DISK    RENAME(RCHMTOT1:RCHMTOT2)
     FFCHMTOT1  O  A E           K DISK
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

     C     *Entry        PList
     C                   Parm                    Date7@            7
     C                   Move      Date7@        Date7             7 0

     C     Date7         SetLL     FCHMTOT2
     C     Date7         ReadE     FCHMTOT2
     C                   DoW       not %eof(FCHMTOT2)
     C                   Delete    RCHMTOT2
     C     Date7         ReadE     FCHMTOT2
     C                   EndDo

     C**
     C**     SPRAYER CONTROL KEY
     C**
     C     JOBKEY        KLIST
     C                   KFLD                    CJWKDT
     C                   KFLD                    CJJOB#
     C***
     C     RUNKEY        KLIST
     C                   KFLD                    CRWKDT
     C                   KFLD                    CRSPRY
     C**
      ** READ  CONTROL FILE
     C***
WJB  C*    *HIVAL        SETGT     FCHMCTL
WJB  C*                  READP     FCHMCTL                                91
WJB  C     Date7         Chain     FCHMCTL                            91
     C     *IN91         IFEQ      *OFF
     C                   MOVE      CHWKDT        STRDAT            7 0
     C                   END
     C***
     C                   MOVE      STRDAT        CJWKDT
WJB  C                   MOVE      STRDAT        CRWKDT
     C**
     C                   EXSR      INIT
     C**
     C     RUNKEY        SETLL     FCHMRUN3
WJB  C*                  READE     FCHMRUN3                               92
WJB  C     Date7         READE     FCHMRUN3                               92
     C**         RUNKEY    READEFCHMRUN3                 LR
     C   92              EXSR      ITMBRK
     C     *INLR         DOWEQ     *OFF
     C**
     C                   MOVEL     CRSPRY        WRKDEC
     C                   MOVE      CRSPIT        WRKDEC           17
     C                   MOVE      CRPPM         WRKDEC
     C**
     C**  BREAK FOR ITEM/PPM CHANGE
     C     WRKDES        IFNE      *BLANKS
     C     WRKDEC        IFNE      WRKDES
     C                   EXSR      ITMBRK
     C                   ENDIF
     C                   ENDIF
     C**
     C**  BREAK FOR ITEM/PPM CHANGE
     C**
     C                   ADD       CRTRAY        TRAYS             5 0
     C                   MOVE      CRLOOK        WKLOOK           15
     C**
     C                   MOVE      STRDAT        CJWKDT
     C                   MOVE      CRJOB#        CJJOB#
     C     JOBKEY        CHAIN     FCHMJOB                            96
     C     *IN96         IFEQ      *OFF
     C                   MOVE      WRKDEC        WRKDES           17
     C                   MOVE      CRSPRY        WKSPRY            5
     C                   END
     C**
      ** OUTPUT THE TOTALS FILE
     C**
WJB  C*                  READ      FCHMRUN3                               LR
WJB  C     Date7         READE     FCHMRUN3                               LR
     C   LR              EXSR      ITMBRK
     C                   ENDDO
     C**
     C************************
     C** INIT
     C************************
     C     INIT          BEGSR
     C                   MOVE      *BLANKS       WRKDES           17
     C                   ENDSR
     C*************************
     C** ITEM BREAK
     C*************************
     C     ITMBRK        BEGSR
     C**
     C                   MOVE      '700'         CTSPSZ
     C                   MOVE      STRDAT        CTWKDT
     C                   MOVE      WKSPRY        CTSPRY
     C                   MOVE      CJSPIT        CTSPIT
     C                   MOVE      CJPPM         CTPPM
     C                   ADD       TRAYS         CTTRAY
     C                   MOVE      WKLOOK        CTLOOK
     C**
     C**     55 TRAYS EQUAL 1 POLE
     C**
     C     CTTRAY        DIV       55            CTPOLE
     C**
     C**     55 TRAYS EQUAL 1/2 GALLON....USE 100 TRAYS FOR 10% OVERAGE
     C**
     C     CTTRAY        DIV       100           GALWRK            9 4
     C                   MOVEL     GALWRK        GAL               5 0
     C                   MOVE      GALWRK        TST44             4 4
     C     TST44         IFGT      .0000
     C                   ADD       1             GAL
     C                   END
     C                   MOVE      GAL           CTGALS
     C**
     C                   WRITE     RCHMTOT1
     C**
     C                   CLEAR                   WKLOOK
     C                   CLEAR                   WKSPRY
     C                   Z-ADD     0             TRAYS
     C                   Z-ADD     0             CTTRAY
     C                   Z-ADD     0             CTPOLE
     C                   Z-ADD     0             CTGALS
     C                   ENDSR
     C**
