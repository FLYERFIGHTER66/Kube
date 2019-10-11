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
      **PROGRAM NAME-------- @DT@B1
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CONVERT CYYMMDD TO DAY OF CENTURY DDDDD
      * MONTH ARRAY
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND
      *
     C     *ENTRY        PLIST
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##DDD
     C                   PARM                    ##ERR             1
      *
      ********************************************************************
      * CONVERT CYYMMDD TO DAY OF CENTURY DDDDD. INDICATOR 90 MINUS DATE
      * ##CYMD INPUT DATE CYYMMDD
      * ##DDD OUTPUT DAY OF CENTURY DDDDD. BASE DATE IS 01/01/1900
      * INDICATORS USED 90-92.
      * IF ERROR ##ERR=Y
      ********************************************************************
     C                   MOVE      *BLANKS       ##ERR
     C                   Z-ADD     ##CYMD        ##CYMD            7 0  90      NEG DATE
      * CONVERT YEAR TO DAYS
     C                   MOVEL     ##CYMD        #03               3 0          YY
     C     #03           MULT      365           ##DDD             5 0          FIRST LEAP
     C     #03           DIV       4             #03                      93    # OF LEAPS
     C                   MVR                     #02A              2 0    91    LEAP YEAR
     C   91
     CANN93#03           SUB       1             #03
     C     #03           ADD       ##DDD         ##DDD                          DAYS FOR LEAP
      * CONVERT MONTH TO DAYS
     C                   MOVE      ##CYMD        #04               4 0          MMDD
     C                   MOVEL     #04           #02A                           MM
     C     #02A          IFLT      1
     C     #02A          ORGT      12
     C                   Z-ADD     1             #02A
     C                   SETON                                        90
     C                   ENDIF
     C  N90#DY(#02A)     ADD       ##DDD         ##DDD                          DAY OF YEAR
     C  N90#02A          COMP      02                                 92        GT FEB
     C   91
     CAN 92
     CANN931             ADD       ##DDD         ##DDD                          LP YR MM 3-12
      * ADD DAY OF MONTH
     C                   MOVE      ##CYMD        #02               2 0          DD
     C     #02           ADD       ##DDD         ##DDD                          ADD DAYS
     C   90              Z-ADD     0             ##DDD
     C   90              MOVEL     'Y'           ##ERR
     C                   SETOFF                                       919293
     C                   SETON                                        LR
      ********************************************************************
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
