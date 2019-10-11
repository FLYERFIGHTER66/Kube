      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1996
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
      **PROGRAM NAME-------- RBVALOO
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- REBUILD VALUE OF OPEN ORDERS IN FMCUST
      *
      *     NOTE: THE VALUE OF THE ORDER IS ADDED TO BOTH THE SHIP TO
      *           CUSTOMER AND THE A/R CUSTOMER IF THEY ARE DIFFERENT
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/02/00 EFD IF ONLY COMMENTS MARK ORDER AS CLOSED
      *  3/15/01 EFD ADD QINV TO LEFT BEFORE MARKING FOR DELETE
      *
     FFMCUST    UF   E           K DISK
     FFHORDR    UF   E           K DISK
     FFIORDR    UF   E           K DISK
      *
      ** FIRST CLEAR OUT MCUST
      *
     C     NXTCLR        TAG
     C                   READ      FMCUST                                 90
     C   90              GOTO      ENDCLR
     C                   Z-ADD     0             CMOCUR
     C                   Z-ADD     0             CMVOPO
     C                   UPDATE    RMCUST
     C                   GOTO      NXTCLR
     C     ENDCLR        TAG
      *
      ** NOW GET OPEN ORDERS
      *
     C     NXTHOR        TAG
     C                   READ      FHORDR                                 90
     C   90              GOTO      END
     C     OHSTAT        IFNE      'A'
     C     OHCOFL        OREQ      'Y'
     C                   GOTO      NXTHOR
     C                   ENDIF
      ** NOW GET THE VALUE OF THE ORDER
     C                   EXSR      GETIOR
     C     TOTVAL        IFEQ      0
     C                   GOTO      NXTHOR
     C                   END
     C*          OHCUST    CHAINFMCUST               91
     C* N91                DO
     C*                    ADD  1         CMOCUR
     C*                    ADD  TOTVAL    CMVOPO
     C*                    UPDATRMCUST
     C*                    ENDDO
     C     OHCUST        IFNE      OHARCU
     C     OHARCU        CHAIN     FMCUST                             91
     C                   ELSE
     C     OHCUST        CHAIN     FMCUST                             91
     C  N91              DO
     C                   ADD       1             CMOCUR
     C                   ADD       TOTVAL        CMVOPO
     C                   UPDATE    RMCUST
     C                   ENDDO
     C                   END
     C                   GOTO      NXTHOR
      ** END JOB
     C     END           TAG
     C                   SETON                                        LR
      **********************
      * GET ORDER VALUE    *
      **********************
     C     GETIOR        BEGSR
     C                   Z-ADD     0             TOTVAL           11 2
     C                   Z-ADD     0             COMNT             5 0
     C                   Z-ADD     0             LFTTST           11 1
     C     OHORD#        SETLL     FIORDR
     C     NXTIOR        TAG
     C     OHORD#        READE     FIORDR                                 91
     C   91              GOTO      ENDIOR
     C     OISTAT        IFEQ      'A'
     C     OIITYP        ANDEQ     'C'
     C                   ADD       1             COMNT
     C                   ENDIF
     C     OISTAT        IFNE      'A'
     C     OICOFL        OREQ      'Y'
     C     OIITYP        OREQ      'C'
     C                   GOTO      NXTIOR
     C                   ENDIF
     C     OIITYP        IFEQ      ' '
     C     OIITYP        OREQ      'N'
     C     OIQORD        SUB       OIQSHP        LEFT             11 1
     C     LEFT          IFGT      0
     C     LEFT          ADD       OIQINV        LEFTIN           11 1
     C                   ADD       LEFTIN        LFTTST
     C     LEFT          MULT(H)   OIUPRI        LEFT$            11 2
     C                   ADD       LEFT$         TOTVAL
     C                   END
     C                   ELSE
     C                   ADD       OIEXT$        TOTVAL
     C                   END
     C                   GOTO      NXTIOR
     C     ENDIOR        TAG
      ** IF ONLY COMMENTS CLOSE ORDER
     C     LFTTST        IFLE      0
     C     TOTVAL        ANDEQ     0
     C     COMNT         ANDGT     0
     C                   EXSR      CLOSE
     C                   END
     C                   ENDSR
      *****************************
      * CLOSE COMMENT ONLY ORDERS *
      *****************************
     C     CLOSE         BEGSR
     C     OHORD#        SETLL     FIORDR
     C     NXTCLO        TAG
     C     OHORD#        READE     FIORDR                                 91
     C   91              GOTO      ENDCLO
     C     OISTAT        IFNE      'D'
     C     OICOFL        ORNE      'Y'
     C                   MOVEL     'D'           OISTAT
     C                   MOVEL     'Y'           OICOFL
     C                   UPDATE    RIORDR
     C                   ENDIF
     C                   GOTO      NXTCLO
     C     ENDCLO        TAG
     C                   MOVEL     'D'           OHSTAT
     C                   MOVEL     'Y'           OHCOFL
     C                   UPDATE    RHORDR
     C                   ENDSR
