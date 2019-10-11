    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
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
      **PROGRAM NAME-------- CHP220
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- CHEMICAL
      **PROGRAMMER---------- C.BUCK
      **APPLICATION--------- WEEKLY SPRAYER CONTROL REPORT.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFCP220FM  CF   E             WORKSTN
     FFFCMJOB3  IF   E           K DISK
     FFFCMRUN2  IF   E           K DISK
     FFFCMCTL   IF   E           K DISK
     FFFCMTOT   IF   E           K DISK
     FFFCMOZS   IF   E           K DISK
      ****FFCHMOZS1IF  E           K        DISK
     FFFCMSPY   IF   E           K DISK
     FQPRINT98  O    F  120        PRINTER OFLIND(*IN10)
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

     D  RunDate        S              6S 0

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$isDate#
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY

      ** CONTROL FILE ARRAYS
      ***********************
      ** START HERE        **
      ***********************
     C**
     C**     KEYS
     C**
     C     JOBKEY        KLIST
     C                   KFLD                    CJWKDT
     C                   KFLD                    CJSPIT
     C                   KFLD                    CJPPM
     C**
     C     RUNKEY        KLIST
     C                   KFLD                    CRWKDT
     C                   KFLD                    CRSPIT
     C                   KFLD                    CRPPM
     C**
     C     TOTKEY        KLIST
     C                   KFLD                    CTSPIT
     C                   KFLD                    CTPPM
     C**
     C     OZSKEY        KLIST
     C                   KFLD                    COITEM
     C                   KFLD                    COPPM
     C**
     C     SPYKEY        KLIST
     C                   KFLD                    CSITEM
     C                   KFLD                    CSSIZE
     C                   KFLD                    CSPPM
     C**
     C                   EXSR      $FIRST
     C***
      ** READ  CONTROL FILE
     C***
     C     *HIVAL        SETGT     FFCMCTL
     C                   READP     FFCMCTL                                91
     C     *IN91         IFEQ      *OFF
     C                   MOVE      CHWKDT        STRDAT            7 0
     C                   Eval      FRMDAT  = $MDYDate($Date(STRDAT))
     C                   END
     C     ScrnA_        Tag
     C                   ExFmt     SCRNA
     C                   SetOFF                                       1011
     C                   If        *InKC
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf

     C                   If        Not $isDate#(FRMDAT:'*MDY')
     C                   Eval      *In10 = *On
     C                   Goto      ScrnA_
     C                   EndIf

     C                   Eval      STRDAT = $Date7($DateMDY(FRMDAT))
     C     STRDAT        Chain     FFCMCTL

     C                   If        Not %Found(FFCMCTL)
     C                   Eval      *In11 = *On
     C                   Goto      ScrnA_
     C                   EndIf
     C***
     C                   MOVE      STRDAT        CJWKDT
     C                   Eval      RunDate = $MDYDate($Date(STRDAT))
     C***
     C                   EXSR      INIT
     C**
     C     JOBKEY        SETLL     FFCMJOB3
     C     NXTREC        TAG
     C                   READE     FFCMJOB3                               LR
     C     *INLR         DOWEQ     *OFF
     C**
     C                   MOVE      *BLANKS       WKLOOK
     C                   MOVEL     CJLOOK        WKLOOK           30
     C**
wjb  C*    CJTRAY        DIV       55            WKPOLE            4 2
wjb  C                   z-add     cjpole        WKPOLE            4 2
     C**
     C                   MOVE      CJWKDT        CRWKDT
     C                   MOVE      CJSPIT        CRSPIT
     C                   MOVE      CJPPM         CRPPM
     C**
     C                   MOVE      STRDAT        CRWKDT
     C                   MOVE      *BLANKS       WRLOOK
     C     RUNKEY        CHAIN     FFCMRUN2                           96
     C     *IN96         IFEQ      *OFF
     C                   MOVEL     CRLOOK        WRLOOK           15
     C                   END
     C**
     C**  BREAK FOR ITEM/PPM CHANGE
     C**
     C                   MOVEL     CJSPIT        WRKDEC           11
     C                   MOVE      CJPPM         WRKDEC
     C**
     C     WRKDEC        IFNE      WRKDES
     C                   Z-ADD     0             TRAYS
     C                   Z-ADD     0             GALS
     C                   Z-ADD     0             POLES
     C                   Z-ADD     0             OZS
     C                   MOVE      *BLANKS       WRSPRY
     C                   MOVE      *BLANKS       WRAPP1
     C                   MOVE      *BLANKS       WRAPP2
     C                   EXSR      ITMBRK
     C                   ENDIF
     C**
     C**    PRINT ALL HDGS AT TOP OF EVERY PAGE
     C**
     C     *IN10         IFEQ      *ON
     C                   EXCEPT    HDGS
     C                   EXCEPT    HEAD
     C                   EXCEPT    DETL1
     C                   EXCEPT    HDGS1
     C                   MOVE      *OFF          *IN10
     C                   END
     C**
     C                   EXCEPT    DETL2
     C**
     C**
     C                   MOVE      WRKDEC        WRKDES           11
     C**
     C     STRDAT        READE     FFCMJOB3                               LR
     C                   END
     C**
     C************************
     C** ITEM BREAK
     C************************
     C     ITMBRK        BEGSR
     C**
     C                   MOVE      CJSPIT        CTSPIT
     C                   MOVE      CJPPM         CTPPM
     C     TOTKEY        CHAIN     FFCMTOT                            98
     C     *IN98         IFEQ      *OFF
     C                   MOVEL     CTGALS        GALS              5 2
     C                   MOVEL     CTTRAY        TRAYS             5 0
wjb  C*                  MOVEL     CTPOLE        POLES             7 2
wjb  C                   Z-add     CTPOLE        POLES             7 2
     C                   END
     C***
     C                   MOVE      CJSPIT        COITEM
     C                   MOVE      CJPPM         COPPM
     C     OZSKEY        CHAIN     FFCMOZS                            92
     C     *IN92         IFEQ      *OFF
     C     CTGALS        MULT      COOUNS        OZS               7 2
     C                   END
     C***
     C     COITEM        IFEQ      '7206'                                       NO SPRAY
     C                   Z-ADD     0             OZS
     C                   END
     C***
     C                   MOVEL     CJSPIT        CSITEM
     C                   MOVEL     CJSPSZ        CSSIZE
     C                   MOVEL     CJPPM         CSPPM
     C     SPYKEY        CHAIN     FFCMSPY                            94
     C     *IN94         IFEQ      *OFF
     C*
     C*    CSXPL         MULT      55            WTRYS             5 0
     C*    CTTRAY        IFGT      WTRYS
wjb  C     ctpole        ifgt      csxpl
     C                   MOVEL     'BEAN'        WRSPRY            5
     C                   ELSE
     C                   MOVEL     'BOSS'        WRSPRY
     C                   END
     C                   END
     C**
     C                   MOVE      CRAPP1        WRAPP1            8
     C                   MOVE      CRAPP2        WRAPP2            8
     C*
     C*  BREAK AT TOP OF PAGE WHEN THERE IS A NEW ITEM
     C*
     C                   EXCEPT    HDGS
     C                   EXCEPT    HEAD
     C                   EXCEPT    DETL1
     C                   EXCEPT    HDGS1
     C*
     C                   ENDSR
     C**
     C************************
     C** FIRST
     C************************
     C     $FIRST        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TIMWRK           12 0
     C                   MOVE      TIMWRK        TDATE             6 0
     C                   ENDSR
     C************************
     C** INIT
     C************************
     C     INIT          BEGSR
     C                   MOVE      *BLANKS       WRKDES
     C                   ENDSR
     C*************************
      * OUTPUT SPECS   *
      *************************
     OQPRINT98  E            HDGS           1 02
     O                                            6 'FCP220'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           65 'Weekly Finished Spray Run'
     O                       PAGE          Z     95
     O                                           91 'Page:'
     O          E            HDGS           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           86 'Time:'
     O                       TIMOD               95 '  :  :  '
     O***
     O          E            HEAD        1  1
     O                                            4 'ITEM'
     O                                           16 'PPM'
     O                                           37 'Description'
     O                                           51 'Count'
     O                                           63 'Poles'
     O                                           75 'Gallons'
     O                                           87 'Ounces'
     O**
     O          E            HDGS1       1  1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           95 '_______________________'
     O**
     O          E            HDGS1       1  1
     O                                            3 'Grn'
     O                                            7 'Sec'
     O                                           11 'Bay'
     O                                           15 'N/S'
     O                                           19 'Str'
     O                                           23 'Str'
     O                                           28 'Size'
     O                                           50 'Product'
     O                                           66 'Count'
     O                                           72 'Poles'
     O                                           79 'Plant'
     O                                           84 'End'
     O                                           89 'End'
     O                                           95 'Comp'
     O          E            HDGS1          2
     O                                            3 'Hse'
     O                                           19 'E/W'
     O                                           23 'Pol'
     O                                           28 'Code'
     O                                           48 'Name'
     O                                           79 'Date'
     O                                           84 'E/W'
     O                                           90 'Pole'
     O          E            DETL1          2
     O                       CJSPIT              12
     O                       CJPPM         4     18
     O                       WRLOOK              41
     O                       TRAYS         Z     51
     O                       POLES         4     62
     O                       GALS          4     74
     O                       OZS           4     87
     O          E            DETL1          1
     O                                           13 'Sprayer:'
     O                       WRSPRY              20
     O                                           50 'Applicator1:'
     O                       WRAPP1              59
     O                                           77 'Applicator2:'
     O                       WRAPP2              86
     O          E            DETL2       1  1
     O                       CJHSE         Z      2
     O                       CJSECT        Z      7
     O                       CJBAY         Z     11
     O                       CJNOS               14
     O                       CJSEOW              18
     O                       CJSPOL        Z     22
     O                       CJSIZE              27
     O                       WKLOOK              59
     O                       CJTRAY        Z     65
     O                       WKPOLE        4     71
     O                       CJRDYD        Y     80
     O                       CJEEOW              83
     O                       CJEPOL        Z     89
     O**
