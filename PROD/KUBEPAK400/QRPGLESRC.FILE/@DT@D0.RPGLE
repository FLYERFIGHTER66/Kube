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
      **PROGRAM NAME-------- @DT@D0
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CHANGE DAY OF CENTURY AND RETURN MMDDYY
      *
      ********************************************************************
      * CONVERT DAY OF CENTURY DDDDD TO MMDDYY
      * ##DDD INPUT DAY OF CENTURY.
      * ##MDY OUTPUT DATE MMDDYY.
      * INDICATOR 90 IS A MINUS DATE.
      * INDICATORS 91-93 USED.
      * IF ERROR ##ERR =Y
      ********************************************************************
      * DAYS ARRAY
     D #JD             S             03  0 DIM(13) CTDATA PERRCD(13) ASCEND
      *
     C     *ENTRY        PLIST
     C                   PARM                    ##DDD             5 0
     C                   PARM                    ##MDY
     C                   PARM                    ##ERR             1
      *
     C                   MOVE      *BLANKS       ##ERR
     C                   Z-ADD     0             ##MDY             6 0
     C                   SETOFF                                       919293
     C* TEST IF ZERO OR NEGATIVE
     C     ##DDD         SUB       1             #05               5 0  90      REDUCE DDD BY 1
     C   90              GOTO      @DT@DX                                       ERROR
     C* CALCULATE YEARS AND DAY OF YEAR
     C     #05           DIV       365           #03               3 0          CYY
     C                   MVR                     #03A              3 0          DDD
     C* CALCULATE # OF LEAPS
     C     #03           DIV       4             #02               2 0    92    # LEAPS
     C                   MVR                     #01               1 0    91    LEAP YEAR
     C   92
     CAN 91              SETOFF                                       91        1900 NOT LEAP
     C     #03A          ADD       1             #03A                           ADD TO DDD BY 1
     C* IF LEAP YEAR, REDUCE # OF LEAPS BY ONE.
     C   91#02           SUB       1             #02
     C     #03A          SUB       #02           #03A                 92
     C* IF DAYS NOT POSITIVE, ADJUST YEARS.
     C  N92#03A          ADD       365           #03A
     C  N92#03           SUB       1             #03                    91      NO LONGER LEAP
     C* DETERMINE IF NEW YEAR IS A LEAP.
     C  N92
     CANN91#01           COMP      1                                      91    IS A LEAP
     C* IF LEAP YEAR WAS MINUS
     C  N92
     CAN 91#03A          ADD       1             #03A
     C*
     C     @DT@DA        TAG
     C* CALCULATE MONTH AND DAY.
     C                   Z-ADD     2             #02                    9293
     C* LEAP YEAR.
     C   91#03A          COMP      60                                 93  92
     C   91
     CAN 93#03A          SUB       1             #03A
     C   91
     CAN 92              Z-ADD     3             #02
     C  N92#03A          LOOKUP    #JD(#02)                           93  93
     C*
     C     #02           SUB       1             #02
     C     #03A          SUB       #JD(#02)      #03A
     C                   Z-ADD     #03A          #04               4 0
     C                   MOVEL     #02           #04
     C                   Z-ADD     #03           ##MDY
     C                   MOVEL     #04           ##MDY
     C*
     C                   SETOFF                                       919293
     C     @DT@DX        TAG
     C   90              MOVEL     'Y'           ##ERR
     C   90              SETOFF                                       90
     C                   SETON                                        LR
     C********************************************************************
**  02 03 04 05 06 07 08 09 10 11 12   DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334365
