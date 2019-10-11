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
      **PROGRAM NAME-------- GETAVAL
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS DISTRIBUTION.
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CHECK AVAILABLE DATES.
      *                      (THIS IS A CALLED PROGRAM)
      *
      * THE LOGIC OF AVAILABILITY IS AS FOLLOWS:
      *
      *   1. IF ANY ON HAND AND NOT ALLOCATED THE NET IS AVAILABLE
      *
      *   2. IF RECORD EXISTS IN FMAVDTE THE ITEM IS NOT AVAIL. UNTIL
      *      THE DATE IN THAT RECORD.
      *
      *   3. IF RECORD EXISTS IN FMITSES THE ITEM AVAILABLILITY IS
      *      DETERMINED BY THE SEASON DATES IN THAT RECORD.
      *
      *   4. THEN CHECK THE PRODUCT CLASS SEASON LIMITS FOR AVAIL.
      *      DATES
      *
      *** THIS PROGRAM CHECKS STEPS 2 THRU 4. IF ITEM IS AVAILABLE
      *   FROM INVENTORY DO-NOT COME TO THIS PROGRAM.
      *
      *   5. IF NOTHING FOUND ABOVE THEN AVAIL. WILL BE CALCULATED
      *      USING SOWING PARAMETERS. (GETGERM PROGRAM)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMINVT    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMAVDTE   IF   E           K DISK
     FFMITSES   IF   E           K DISK
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
     C                   PARM                    REQDAT            7 0
     C**                   PARM           AVADAT  70
     C                   PARM                    AVMDYY            8 0
     C                   PARM                    ERCODE            1
     C                   PARM                    COMENT           30
     C                   PARM                    SESBEG            4 0
     C                   PARM                    SESEND            4 0
     C                   MOVE      '0'           *IN
      ** ERCODE  ERROR CODE                   **** RETURNED FIELDS ****
      * ' '- NO ERROR ENCOUNTERED.
      *  1 - NOT AVAILABLE UNTIL (FMAVDTE)    AVMDYY COMENT
      *  2 - OUT OF SEASON  (FMITSES)         SESBEG SESEND COMENT
      *  3 - OUT OF SEASON  (FMPRCL)          SESBEG SESEND COMENT
      *  X - ITEM NOT FOUND IN MINVT.
      ********
     C**                   Z-ADD0         AVADAT
     C                   Z-ADD     0             AVMDYY
     C                   Z-ADD     0             SESBEG
     C                   Z-ADD     0             SESEND
     C                   MOVE      *BLANKS       ERCODE
     C                   MOVE      *BLANKS       COMENT
      *
     C                   Z-ADD     REQDAT        REVDAT            7 0
     C     ITMKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
     C     ITMKEY        CHAIN     FMINVT                             90
     C   90              MOVE      'X'           ERCODE
     C   90              GOTO      END
      ** CHECK FOR NOT AVAIL FILE
     C     AVAKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C     AVAKEY        CHAIN     FMAVDTE                            92
      ** SEE IF ANY DATE
     C   92              GOTO      ENDAVA
      ** GET YEAR PREFIX 19/20
     C                   MOVE      REQDAT        RVYYMD            8 0
     C     REQDAT        IFLT      1000000
     C                   MOVEL     19            RVYYMD
     C                   ELSE
     C                   MOVEL     20            RVYYMD
     C                   END
     C     RVYYMD        IFLT      AVDYMD
     C                   MOVE      '1'           ERCODE
     C                   MOVEL     AVCOMM        COMENT
     C                   Z-ADD     AVDMDY        AVMDYY
     C                   GOTO      END
     C                   END
     C     ENDAVA        TAG
      ** CHECK ITEM SEASON DATES
     C     AVAKEY        CHAIN     FMITSES                            93
     C  N93              GOTO      ITHIT
      ** NO HIT ON ITEM AND SIZE TRY JUST ITEM
     C     IMITEM        CHAIN     FMITSES                            93
     C   93              GOTO      ENDSES
     C     ISSIZE        IFGT      *BLANKS
     C                   GOTO      ENDSES
     C                   END
      ** IF HERE GOT A SEASON RECORD WITH OR WITH OUT SIZE
     C     ITHIT         TAG
     C                   MOVE      REQDAT        RMMDD             4 0
     C                   MOVE      RMMDD         TSTREQ            6 0
     C                   MOVE      ISBEG         TSTBEG            6 0
     C                   MOVE      ISEND         TSTEND            6 0
     C     RMMDD         IFLT      ISBEG
     C                   MOVEL     02            TSTREQ
     C                   ELSE
     C                   MOVEL     01            TSTREQ
     C                   END
     C     ISEND         IFLT      ISBEG
     C                   MOVEL     01            TSTBEG
     C                   MOVEL     02            TSTEND
     C                   ELSE
     C                   MOVEL     01            TSTBEG
     C                   MOVEL     01            TSTEND
     C                   END
      ** NOW TEST
     C     TSTREQ        IFLT      TSTBEG
     C     TSTREQ        ORGT      TSTEND
     C                   MOVE      '2'           ERCODE
     C                   MOVEL     ISCOMM        COMENT
     C                   Z-ADD     ISBEG         SESBEG
     C                   Z-ADD     ISEND         SESEND
     C                   ENDIF
      ** IF RECORD EXISTS IN ITMSEAS SKIP PROD CLASS
     C                   GOTO      END
     C     ENDSES        TAG
      ** GET PRODUCT CLASS FILE
     C     IMPCL1        CHAIN     FMPRCL                             91
     C   91              GOTO      END
     C                   MOVE      REQDAT        RMMDD             4 0
     C                   MOVE      RMMDD         TSTREQ            6 0
     C                   MOVE      PCSDTF        TSTBEG            6 0
     C                   MOVE      PCSDTT        TSTEND            6 0
     C     RMMDD         IFLT      PCSDTF
     C                   MOVEL     02            TSTREQ
     C                   ELSE
     C                   MOVEL     01            TSTREQ
     C                   END
     C     PCSDTT        IFLT      PCSDTF
     C                   MOVEL     01            TSTBEG
     C                   MOVEL     02            TSTEND
     C                   ELSE
     C                   MOVEL     01            TSTBEG
     C                   MOVEL     01            TSTEND
     C                   END
      ** NOW TEST
     C     TSTREQ        IFLT      TSTBEG
     C     TSTREQ        ORGT      TSTEND
     C                   MOVE      '3'           ERCODE
     C                   Z-ADD     PCSDTF        SESBEG
     C                   Z-ADD     PCSDTT        SESEND
     C                   GOTO      END
     C                   ENDIF
      *** END PROGRAM
     C     END           TAG
     C                   MOVE      '0'           *IN
     C                   SETON                                        LR
