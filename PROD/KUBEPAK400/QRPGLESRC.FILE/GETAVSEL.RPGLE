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
      **PROGRAM NAME-------- GETAVSELL
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS DISTRIBUTION.
      **PROGRAMMER---------- EFD
      **APPLICATION--------- GET QUANTITY TO SELL.
      *                      (THIS IS A CALLED PROGRAM)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMINVT    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFDLOTRDD  IF   E           K DISK
      **
      ** MINVT ARRAYS
     D IGB             S              4  0 DIM(4)                               BEG WKS GERM 4
     D IGE             S              4  0 DIM(4)                               END WKS GERM 4
     D IGW             S              2  0 DIM(4)                               # OF WKS GERM
     D IGB7            S              7  0 DIM(4)                               BEG WKS GERM 7
     D IGE7            S              7  0 DIM(4)                               END WKS GERM 7
     IRMINVT
     I              IMBD1                       IGB(1)
     I              IMBD2                       IGB(2)
     I              IMBD3                       IGB(3)
     I              IMBD4                       IGB(4)
     I              IMED1                       IGE(1)
     I              IMED2                       IGE(2)
     I              IMED3                       IGE(3)
     I              IMED4                       IGE(4)
     I              IMWG1                       IGW(1)
     I              IMWG2                       IGW(2)
     I              IMWG3                       IGW(3)
     I              IMWG4                       IGW(4)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    PHYTO             1
     C                   PARM                    REQDAT            7 0
     C                   PARM                    BLCUST            6 0
     C                   PARM                    AVQTY            11 1
     C                   PARM                    SHPREG            2            SHP FRM REGN
      ********
     C                   MOVE      '0'           *IN
     C                   Z-ADD     0             AVQTY
     C                   Z-ADD     REQDAT        REVDAT            7 0
     C                   Z-ADD     REQDAT        ##CYMD
      ** GET TO PREV MONDAY DATE
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
     C     #Y            IFNE      1
     C     #Y            SUB       1             #L                2 0
     C                   SUB       #L            #Y
     C                   SUB       #L            ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        REVDAT            7 0
     C                   END
     C     ITMKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C     ITMKEY        CHAIN     FMINVT                             90
      ** GET ALL LOTS STILL GOOD AND AVAILABLE
     C   90              Z-ADD     0             IMWKAV
     C     IMWKAV        MULT      7             DAYS              5 0
      ** USE 26 WEEKS AS DEFAULT IF DAYS = 0
     C     DAYS          IFEQ      0
     C     26            MULT      7             DAYS
     C                   END
     C                   SUB       DAYS          ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        BADDAT            7 0
      ** CHECK FOR AVAIL
     C     LOTKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    CODE
     C                   KFLD                    CUST
     C                   KFLD                    REVDAT
     C     LOTCMP        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    CODE
     C                   KFLD                    CUST
      ** CHECK FOR AVAIL THIS CUSTOMER
     C                   Z-ADD     BLCUST        CUST              6 0
     C                   MOVE      'R'           CODE              1
     C     LOTKEY        SETLL     FDLOTRDD
     C     NXTCST        TAG
     C     LOTCMP        READE     FDLOTRDD                               90
     C   90              GOTO      ENDCST
     C     LRCRDY        IFLT      BADDAT
     C                   GOTO      ENDCST
     C                   END
     C     LRCPHY        IFLT      PHYTO
     C                   GOTO      NXTCST
     C                   END
      ** IF HERE LOT IS AVAILABLE TO THIS CUSTOMER
     C     LRQTOH        SUB       LRQTAL        LEFT             11 1
     C     LEFT          IFLE      0
     C                   GOTO      NXTCST
     C                   END
      ** CHECK IF SAME REGION
     C     LRCLOC        CHAIN     FMWHSE                             90
     C  N90WHREG         IFNE      SHPREG
     C                   GOTO      NXTCST
     C                   END
     C                   ADD       LEFT          AVQTY
     C                   GOTO      NXTCST
     C     ENDCST        TAG
      ** CHECK FOR AVAIL FROM NOT RESERVED LOTS
     C                   Z-ADD     0             CUST              6 0
     C                   MOVE      'A'           CODE              1
     C     LOTKEY        SETLL     FDLOTRDD
     C     NXTAV         TAG
     C     LOTCMP        READE     FDLOTRDD                               90
     C   90              GOTO      END
     C     LRCRDY        IFLT      BADDAT
     C                   GOTO      END
     C                   END
     C     LRCPHY        IFLT      PHYTO
     C                   GOTO      NXTAV
     C                   END
      ** IF HERE LOT IS AVAILABLE TO THIS CUSTOMER
     C     LRQTOH        SUB       LRQTAL        LEFT             11 1
     C     LEFT          IFLE      0
     C                   GOTO      NXTAV
     C                   END
      ** CHECK IF SAME REGION
     C     LRCLOC        CHAIN     FMWHSE                             90
     C  N90WHREG         IFNE      SHPREG
     C                   GOTO      NXTAV
     C                   END
     C                   ADD       LEFT          AVQTY
     C                   GOTO      NXTAV
      *** END PROGRAM
     C     END           TAG
     C                   MOVE      '0'           *IN
     C                   SETON                                        LR
