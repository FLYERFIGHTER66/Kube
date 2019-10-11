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
      **PROGRAM NAME-------- FCR075
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- CAB
      **APPLICATION--------- CREATE TOTALS FILE FOR REPORTS.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFFCMJOB2  IF   E           K DISK
     FFFCMCTL   IF   E           K DISK
     FFFCMRUN2  IF   E           K DISK
     FFFCMTOT   O  A E           K DISK
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
     C     *ENTRY        PLIST
     C                   PARM                    DATE7             7
     C**
     C**     SPRAYER CONTROL KEY
     C**
     C     JOBKEY        KLIST
     C                   KFLD                    CJWKDT
     C                   KFLD                    CJITEM
     C                   KFLD                    CJPPM
     C***
     C     RUNKEY        KLIST
     C                   KFLD                    CRWKDT
     C                   KFLD                    CRSPIT
     C                   KFLD                    CRPPM
     C**
      ** READ  CONTROL FILE
     C***
     C                   Eval      STRDAT = %Int(DATE7)
     C*    *HIVAL        SETGT     FFCMCTL
     C     STRDAT        SETGT     FFCMCTL
     C                   READP     FFCMCTL                                91
     C***                  READ FFCMCTL                  91
     C     *IN91         IFEQ      *OFF
     C                   MOVE      CHWKDT        STRDAT            7 0
     C                   END
     C***
     C                   MOVE      STRDAT        CJWKDT
     C**
     C                   EXSR      INIT
     C**
     C     JOBKEY        SETLL     FFCMJOB2
     C                   READE     FFCMJOB2                               LR
     C     *INLR         DOWEQ     *OFF
     C**
     C                   MOVEL     CJSPIT        WRKDEC           11
     C                   MOVE      CJPPM         WRKDEC
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
     C                   ADD       CJTRAY        TRAYS             5 0
     C                   ADD       CJPOLE        POLES             7 2
     C**
     C                   MOVE      STRDAT        CRWKDT
     C                   MOVE      CJSPIT        CRSPIT
     C                   MOVE      CJPPM         CRPPM
     C     RUNKEY        CHAIN     FFCMRUN2                           96
     C     *IN96         IFEQ      *OFF
     C                   MOVEL     CRSPIT        WRKDES           11
     C                   MOVE      CRPPM         WRKDES
     C                   END
     C**
      ** OUTPUT THE TOTALS FILE
     C**
     C     STRDAT        READE     FFCMJOB2                               LR
     C                   ENDDO
     C**
     C************************
     C** INIT
     C************************
     C     INIT          BEGSR
     C                   MOVE      *BLANKS       WRKDES           11
     C                   ENDSR
     C*************************
     C** ITEM BREAK
     C************************
     C     ITMBRK        BEGSR
     C**
     C                   MOVE      '700'         CTSPSZ
     C                   MOVE      STRDAT        CTWKDT
     C                   MOVE      CRSPIT        CTSPIT
     C                   MOVE      CRPPM         CTPPM
     C                   ADD       TRAYS         CTTRAY
     C                   ADD       POLES         CTPOLE
     C                   MOVE      CRLOOK        CTLOOK
     C**
     C**     55 TRAYS EQUAL 1 POLE
     C**
     C*    CTTRAY        DIV       55            CTPOLE
     C**
     C**     55 TRAYS EQUAL 1/2 GALLON....USE 100 TRAYS FOR 10% OVERAGE
     C**
     C*    CTTRAY        DIV       100           GALWRK            9 4
     C     CTPOLE        DIV       1             GALWRK            9 4
     C                   MOVEL     GALWRK        GAL               5 0
     C                   MOVE      GALWRK        TST44             4 4
     C     TST44         IFGT      .0000
     C                   ADD       1             GAL
     C                   END
     C                   MOVE      GAL           CTGALS
     C**
     C                   WRITE     RCHMTOT
     C**
     C                   Z-ADD     0             TRAYS
     C                   Z-ADD     0             POLES
     C                   Z-ADD     0             CTTRAY
     C                   Z-ADD     0             CTPOLE
     C                   Z-ADD     0             CTGALS
     C                   ENDSR
     C**
