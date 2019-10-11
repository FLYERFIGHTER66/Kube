      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES INC.      215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME------   GETAMOUNT
      **COMPANY-----------   ACCOUNTS PAYABLEMS
      **SYSTEM------------   TGMS
      **PROGRAMMER--------   EFD
      **DESCRIPTION-------   CONVERTS NUMBERS INTO SPELLED OUT LINE.
      *                        (CALLED)
      *
      *   CHANGE LOG
      *
      *
      *
      *            *******************************
      *            *   EXTENSION SPECIFICATIONS  *
      *            *******************************
      *
     D******   WORK ARRAY FOR PRINTING PAYEE NAME AND ADDRESS
     D XTRA            S             11    DIM(7) CTDATA PERRCD(1)
     D TEN             S              7    DIM(9) CTDATA PERRCD(1)
     D ONE             S              7    DIM(10) CTDATA PERRCD(1)
     D TEEN            S              9    DIM(9) CTDATA PERRCD(1)
      *
      ****************
      *   PARMS      *
      ****************
     C     *ENTRY        PLIST
     C                   PARM                    AMOUNT           11 2
     C                   PARM                    CWORDW           80
     C                   PARM                    ##ERR             1
      ** SET UP CWORD
     C                   MOVE      *BLANKS       ##ERR
     C                   MOVE      *BLANKS       CWORD            90
     C                   MOVEL     '***'         CWORD
     C                   MOVE      *BLANKS       CWORDW
      *
      * CHECK IF ANY DOLLARS
     C     AMOUNT        IFLE      0.99
     C     CWORD         CAT       XTRA(7):1     CWORD
     C                   GOTO      NOTEN
     C                   END
      * GET MILLONS
     C     AMOUNT        DIV       1000000       LEFT              5 0
     C     LEFT          IFGT      99
     C                   MOVEL     'Y'           ##ERR
     C                   GOTO      END
     C                   END
     C     LEFT          IFLE      0
     C                   GOTO      NOMIL
     C                   END
     C     LEFT          IFGT      19
     C                   MOVE      LEFT          WK2               2 0
     C                   MOVEL     WK2           WK1               1 0
     C     CWORD         CAT       TEN(WK1):1    CWORD
     C                   MOVE      LEFT          WK2
     C                   MOVE      WK2           WK1
     C     WK1           IFGT      0
     C     CWORD         CAT       ONE(WK1):1    CWORD
     C                   END
     C     CWORD         CAT       XTRA(1):1     CWORD
     C                   GOTO      NOMIL
     C                   END
      ** LESS THAN 19 MILLION
     C     LEFT          IFLE      19
     C                   MOVE      LEFT          WK2               2 0
     C                   MOVE      WK2           WK1               1 0
     C     WK2           IFEQ      10
     C     CWORD         CAT       TEN(1):1      CWORD
     C                   ELSE
     C     WK2           IFGT      9
     C     CWORD         CAT       TEEN(WK1):1   CWORD
     C                   MOVE      LEFT          WK2
     C                   MOVE      WK2           WK1
     C                   ELSE
     C     WK1           IFGT      0
     C     CWORD         CAT       ONE(WK1):1    CWORD
     C                   END
     C                   END
     C                   END
     C     CWORD         CAT       XTRA(1):1     CWORD
     C                   GOTO      NOMIL
     C                   END
      ** END OF MILLIONS
     C     NOMIL         TAG
      * GET HUNDRED THOUSANDS
     C                   Z-ADD     AMOUNT        HTHOU             8 2
     C     HTHOU         DIV       100000        LEFT
     C                   MOVE      LEFT          WK2               2 0
     C                   MOVE      WK2           WK1               1 0
     C     LEFT          IFGT      0
     C     CWORD         CAT       ONE(WK1):1    CWORD
     C     CWORD         CAT       XTRA(3):1     CWORD
     C                   END
      * GET THOUSANDS
     C                   Z-ADD     AMOUNT        THOU              7 2
     C     THOU          DIV       1000          LEFT              5 0
     C     LEFT          IFLE      0
     C     HTHOU         IFGE      100000
     C     CWORD         CAT       XTRA(2):1     CWORD
     C                   END
     C                   GOTO      NOTHO
     C                   END
     C     LEFT          IFGT      19
     C                   MOVE      LEFT          WK2               2 0
     C                   MOVEL     WK2           WK1               1 0
     C     CWORD         CAT       TEN(WK1):1    CWORD
     C                   MOVE      LEFT          WK2
     C                   MOVE      WK2           WK1
     C     WK1           IFGT      0
     C     CWORD         CAT       ONE(WK1):1    CWORD
     C                   END
     C     CWORD         CAT       XTRA(2):1     CWORD
     C                   GOTO      NOTHO
     C                   END
      ** LESS THAN 19 THOUSAND
     C     LEFT          IFLE      19
     C                   MOVE      LEFT          WK2               2 0
     C                   MOVE      WK2           WK1               1 0
     C     WK2           IFEQ      10
     C     CWORD         CAT       TEN(1):1      CWORD
     C                   ELSE
     C     WK2           IFGT      9
     C     CWORD         CAT       TEEN(WK1):1   CWORD
     C                   MOVE      LEFT          WK2
     C                   MOVE      WK2           WK1
     C                   ELSE
     C     WK1           IFGT      0
     C     CWORD         CAT       ONE(WK1):1    CWORD
     C                   END
     C                   END
     C                   END
     C     CWORD         CAT       XTRA(2):1     CWORD
     C                   GOTO      NOTHO
     C                   END
      ** END OF THOUSANDS
     C     NOTHO         TAG
      * GET HUNDREDS
     C                   Z-ADD     AMOUNT        HUND              5 2
     C     HUND          DIV       100           LEFT              5 0
     C     LEFT          IFLE      0
     C                   GOTO      NOHUND
     C                   END
      ** LESS THAN 9 HUNDRED
     C     LEFT          IFLE      9
     C                   MOVE      LEFT          WK2               2 0
     C                   MOVE      WK2           WK1               1 0
     C     CWORD         CAT       ONE(WK1):1    CWORD
     C     CWORD         CAT       XTRA(3):1     CWORD
     C                   GOTO      NOHUND
     C                   END
      ** END OF HUNDREDS
     C     NOHUND        TAG
      * GET TENS
     C                   Z-ADD     AMOUNT        TEN$              4 2
     C     TEN$          DIV       1.00          LEFT              5 0
     C     LEFT          IFLE      0
     C                   GOTO      NOTEN
     C                   END
     C     LEFT          IFGT      19
     C                   MOVE      LEFT          WK2               2 0
     C                   MOVEL     WK2           WK1               1 0
     C     CWORD         CAT       TEN(WK1):1    CWORD
     C                   MOVE      LEFT          WK2
     C                   MOVE      WK2           WK1
     C     WK1           IFGT      0
     C     CWORD         CAT       ONE(WK1):1    CWORD
     C                   END
     C**         CWORD     CAT  XTRA,1:1  CWORD
     C                   GOTO      NOTEN
     C                   END
      ** LESS THAN 19 DOLLARS
     C     LEFT          IFLE      19
     C                   MOVE      LEFT          WK2               2 0
     C                   MOVE      WK2           WK1               1 0
     C     WK2           IFEQ      10
     C     CWORD         CAT       TEN(1):1      CWORD
     C                   ELSE
     C     WK2           IFGT      9
     C     CWORD         CAT       TEEN(WK1):1   CWORD
     C                   MOVE      LEFT          WK2
     C                   MOVE      WK2           WK1
     C                   ELSE
     C     WK1           IFGT      0
     C     CWORD         CAT       ONE(WK1):1    CWORD
     C                   END
     C                   END
     C                   END
     C*          CWORD     CAT  XTRA,1:1  CWORD
     C                   GOTO      NOTEN
     C                   END
      ** END OF TENS
     C     NOTEN         TAG
     C     CWORD         CAT       XTRA(4):1     CWORD
     C     CWORD         CAT       XTRA(5):1     CWORD
      ** GET CENTS
     C                   MOVE      AMOUNT        CENT$             2
     C     CWORD         CAT       CENT$:1       CWORD
     C     CWORD         CAT       XTRA(6):1     CWORD
     ** END JOB
     C     END           TAG
     C                   MOVE      CWORD         TST10            10
     C     TST10         IFGT      *BLANKS
     C                   MOVEL     'Y'           ##ERR
     C                   ELSE
     C                   MOVEL     CWORD         CWORDW
     C                   END
     C                   SETON                                        LR
** XTRAS
MILLION
THOUSAND
HUNDRED
DOLLARS
AND
CENTS
ZERO
** TENS
TEN
TWENTY
THIRTY
FORTY
FIFTY
SIXTY
SEVENTY
EIGHTY
NINETY
** ONES
ONE
TWO
THREE
FOUR
FIVE
SIX
SEVEN
EIGHT
NINE
TEN
**  TEENS
ELEVEN
TWELVE
THIRTEEN
FOURTEEN
FIFTEEN
SIXTEEN
SEVENTEEN
EIGHTEEN
NINETEEN
