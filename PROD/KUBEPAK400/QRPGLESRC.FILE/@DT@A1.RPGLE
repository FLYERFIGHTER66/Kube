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
      **PROGRAM NAME-------- @DT@A1
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- VALIDATE DATE AND RETURN CENTURY DATE
      *
      ********************************************************************
      * VALIDATE DATES. INDICATOR 90 IS ON IF ERROR. 91-92 ALWAYS SETOF.
      * YY GE 00  MM 01-12 DAY 01-28/29/30/31
      * ##MDY INPUT DATE MMDDYY
      * ##CYMD OUTPUT DATE CYYMMDD IF DATE IS OK. ELSE ZERO.
      * C IDENTIFIES 20 OR 21 CENTURY. C=0 FOR YY 70-99. C=1 FOR YY 00-69.
      * IF ERROR ##ERR CONTAINS Y
      *
     C     *ENTRY        PLIST
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##CYMD
     C                   PARM                    ##ERR             1
      *
     C                   MOVE      *BLANKS       ##ERR
     C                   MOVE      ##MDY         #03A              3 0          MYY
     C                   MOVEL     0             #03A                           CYY
     C                   MOVEL     ##MDY         #04               4 0          MMDD
     C                   MOVEL     ##MDY         #02B              2 0          MM
     C                   MOVE      #04           #02C              2 0          DD
     C                   Z-ADD     ##MDY         ##MDY             6 0  90      YY IS NEGATIVE
     C  N90              Z-ADD     #02B          #02               2 0    90    MM LT 01 ERROR
     C  N90#02B          COMP      12                                 90        MM GT 12 ERROR
     C  N90#02C          COMP      01                                   90      DD LT 01 ERROR
     C  N90#02C          COMP      31                                 90  91    DD GT OR EQ 31
     C     #02B          COMP      07                                 92        MM 08-12
     C   921             ADD       #02B          #02                            MAKE MM ODD
     C     #02           DIV       2             #02
     C                   MVR                     #02                  92        31 DAY MONTH
     C   91
     CANN92              SETON                                        90        MM EVEN DD 31
     C     #02B          COMP      02                                     91    FEB
     C  N91
     COR 90              GOTO      @DT@AX
     C     #03A          DIV       4             #03               3 0          JUST FOR MVR
     C                   MVR                     #02                      91    LEAP YEAR
     C     #02C          COMP      29                                 90  92    DD GT 29 ERROR
     C  N91
     CAN 92              SETON                                        90        NO LEAP DD 29
     C     @DT@AX        TAG                                                    GOOD DATE
     C                   MOVEL     #03A          ##CYMD            7 0          CYY----
     C                   MOVE      #04           ##CYMD                         CYYMMDD
     C     #03A          COMP      070                                  91
     C   91              MOVEL     1             ##CYMD                         21ST CENTURY
     C   90              Z-ADD     0             ##CYMD                         ERROR
     C   90              MOVEL     'Y'           ##ERR                          ERROR
     C                   SETOFF                                       919290
     C                   SETON                                        LR
