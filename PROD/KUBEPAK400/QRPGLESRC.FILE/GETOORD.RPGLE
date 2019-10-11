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
      *PROGRAM NAME-------- GETOORD
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- GET NUMBER OF FLATS IN OPEN ORDERS.
      *                     (THIS IS A CALLED PROGRAM)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFIORCUST  IF   E           K DISK
     FFMPRCL    IF   E           K DISK
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    CMCUST            6 0
     C                   PARM                    TOTDOL            9 2
     C                   PARM                    TOTQTY           11 1
      *
     C                   Z-ADD     0             TOTDOL
     C                   Z-ADD     0             TOTQTY
     C     CMCUST        SETLL     FIORCUST
     C     NXTIOR        TAG
     C     CMCUST        READE     RIORDR                                 90
     C   90              GOTO      END
     C     OISTAT        IFNE      'A'
     C     OIITYP        OREQ      'S'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'C'
     C                   GOTO      NXTIOR
     C                   ENDIF
     C     OIPRCL        CHAIN     FMPRCL                             91
     C   91              GOTO      NXTIOR
     C     PCEVD         IFNE      'Y'
     C                   GOTO      NXTIOR
     C                   END
     C     OIQORD        SUB       OIQSHP        TEST             11 1
     C     TEST          IFGT      0
     C                   ADD       TEST          TOTQTY
     C                   ADD       OIEXT$        TOTDOL
     C                   END
     C                   GOTO      NXTIOR
     C     END           TAG
     C                   SETON                                        LR
