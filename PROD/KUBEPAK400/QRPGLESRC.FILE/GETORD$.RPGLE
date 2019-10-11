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
      *PROGRAM NAME-------- GETORD$
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- GET VALUE OF OPEN ORDER AND UPDATE MCUST
      *                     IF CHANGE NEEDED.   (CALLED PROGRAM)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCUST    UF   E           K DISK
     FFOPNORD   UF A E           K DISK
     FFIORDR    IF   E           K DISK
     FFHORDR    IF   E           K DISK
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LDAPTO                 1      1  0
      **********
      * ENTRY  *
      **********
     C     *ENTRY        PLIST
     C                   PARM                    OHORD#            6 0
     C                   PARM                    TOTDOL            9 2
     C                   Z-ADD     0             TOTDOL
     C                   CLEAR                   *IN
      ** GET HEADER
     C     OHORD#        CHAIN     FHORDR                             93
     C  N93OHSTAT        IFEQ      'D'
     C                   SETON                                        93
     C                   END
      ** IF ORDER DELETED GET RID OF OPNORD REC
     C     OHORD#        SETLL     FIORDR
     C     NXTIOR        TAG
     C     OHORD#        READE     FIORDR                                 90
     C  N90              DO
     C     OIQORD        SUB       OIQINV        QTYORD
     C     OISTAT        IFNE      'D'
      ** GET LINE ITEMS
     C     OIITYP        IFEQ      ' '
     C     QTYORD        ANDGT     0.0
     C                   Z-ADD     OIUPRI        VUPRIC
     C                   Z-ADD     OIQDDC        VDISC
     C                   Z-ADD     0             #LINGR
     C                   Z-ADD     0             #LINNT
     C                   Z-ADD     0             #LINDS
     C                   CALL      '#EXLN'
     C                   PARM                    QTYORD            8 1
     C                   PARM                    VUPRIC            9 4
     C                   PARM                    VDISC             4 2
     C                   PARM                    #LINGR            9 2
     C                   PARM                    #LINNT            9 2
     C                   PARM                    #LINDS            7 2
     C                   ADD       #LINNT        TOTDOL
     C                   END                                                    OIITYP=' '
     C     OIITYP        IFEQ      'F'
     C     OIITYP        OREQ      'S'
     C                   ADD       OIEXT$        TOTDOL
     C                   END                                                    OIITYP= F/S
     C                   END                                                    OISTAT><'D'
     C                   GOTO      NXTIOR
     C                   ENDDO
      ** GET TRADE DISCOUNT
     C     OHTRDC        IFGT      0.0
     C     OHTRDC        DIV       100           WRKPCT            6 4
     C     TOTDOL        MULT(H)   WRKPCT        DISTOT            9 2
     C                   ELSE
     C                   Z-ADD     0             DISTOT
     C                   END
     C                   SUB       DISTOT        TOTDOL
     C     OHORD#        CHAIN     FOPNORD                            92
      ** DELETED ORDER AND NO HIT GOTO END
     C   93
     CAN 92              GOTO      END
      ** DELETED ORDER AND HIT DELETE FOPNORD REC
     C   93
     CANN92              DO
     C                   DELETE    ROPNORD
     C                   GOTO      ENDORD
     C                   ENDDO
      ** IF NEEDED BUILD RECORD
     C   92              DO
     C                   CLEAR                   ROPNORD
     C                   Z-ADD     OHORD#        OOORD#
     C                   ENDDO
     C                   Z-ADD     OHCOMP        OOCOMP
     C                   Z-ADD     OHCUST        OOCUST
     C                   Z-ADD     OHARCU        OOARCU
     C                   Z-ADD     OHBLCU        OOBLCU
     C                   Z-ADD     OHSACU        OOBLCU
     C                   MOVEL     OHSHFR        OOSHFR
     C                   Z-ADD     OHORDY        OOORDY
     C                   Z-ADD     OHDTRY        OODTRY
     C     ENDORD        TAG
      ** CHECK TOTAL DOLLARS
     C**         TOTDOL    IFNE OOEXT$
     C     TOTDOL        SUB       OOEXT$        DIFF              9 2
      ** FIRST UPDATE SHIP TO CUST
     C     OHCUST        CHAIN     FMCUST                             88
     C                   ADD       DIFF          CMVOPO
     C     CMVOPO        IFLE      0
     C                   Z-ADD     0             CMVOPO
     C                   END
     C**                   END
     C                   Z-ADD     CMDTLO        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
      ** GET DATE OF LAST ORDER
     C     ##CYMD        IFLT      OHORDY
     C                   Z-ADD     OHDTOR        CMDTLO
     C                   END
      ** IF NEW ORDER ADD TO COUNT
     C   92              ADD       1             CMOCUR
     C   92              ADD       1             CMOYTD
      ** IF DELETED ORDER SUB FROM COUNT
     C   93              SUB       1             CMOCUR
     C  N88              UPDATE    RMCUST
      ** NOW UPDATE A/R CUST IF DIFFERENT
     C     OHARCU        IFNE      OHCUST
     C     OHARCU        CHAIN     FMCUST                             88
     C                   ADD       DIFF          CMVOPO
     C     CMVOPO        IFLE      0
     C                   Z-ADD     0             CMVOPO
     C                   END
     C**                   END
     C                   Z-ADD     CMDTLO        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
      ** GET DATE OF LAST ORDER
     C     ##CYMD        IFLT      OHORDY
     C                   Z-ADD     OHDTOR        CMDTLO
     C                   END
      ** IF NEW ORDER ADD TO COUNT
     C   92              ADD       1             CMOCUR
     C   92              ADD       1             CMOYTD
      ** IF DELETED ORDER SUB FROM COUNT
     C   93              SUB       1             CMOCUR
     C  N88              UPDATE    RMCUST
     C                   END                                                    OHARCU><OHCU
     C                   Z-ADD     TOTDOL        OOEXT$
     C   92
     CANN93              WRITE     ROPNORD
     C  N92
     CANN93              UPDATE    ROPNORD
      **** END OF PROGRAM
     C     END           TAG
     C                   UNLOCK    FMCUST
     C                   UNLOCK    FOPNORD
     C                   CLEAR                   *IN
     C                   CALL      'GETTORD$'
     C                   PARM                    OHCUST
     C                   SETON                                        LR
