    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      **PROGRAM NAME-------- CHP222
      **SYSTEM-------------- CHEMICAL
      **PROGRAMMER---------- C.BUCK
      **APPLICATION--------- WEEKLY SPRAYER CONTROL REPORT.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFCHMJOB   IF   E           K DISK
     FFCHMRUN5  IF   E           K DISK
     FFCHMCTL   IF   E           K DISK
     FFCHMTOT1  IF   E           K DISK
     FFCHMAPPR  IF   E           K DISK
     FFCHMOZS   IF   E           K DISK
     FQPRINT    O    F  120        PRINTER OFLIND(*IN10)
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

      *? Function Prototypes
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$Date7

      ***********************
      ** START HERE        **
      ***********************
     C**
     C**     KEYS
     C**
     C     JOBKEY        KLIST
     C                   KFLD                    CJWKDT
     C                   KFLD                    CJJOB#
     C**
     C     RUNKEY        KLIST
     C                   KFLD                    CRWKDT
     C                   KFLD                    CRSPRY
     C**
     C     TOTKEY        KLIST
     C                   KFLD                    CTSPRY
     C                   KFLD                    CTSPIT
     C                   KFLD                    CTPPM
     C                   KFLD                    CRWKDT
     C**
     C     OZSKEY        KLIST
     C                   KFLD                    COITEM
     C                   KFLD                    COPPM
     C**
     C     APPKEY        KLIST
     C                   KFLD                    CHWKDT
     C                   KFLD                    CAITEM
     C                   KFLD                    CRSPSZ
     C                   KFLD                    CAPPM
     C                   KFLD                    CASPRY
     C**
     C                   EXSR      $FIRST
      *
     C                   Z-Add     *Zero         SelDate           6 0
     C                   Z-Add     *Zero         SelDate7          7 0
    ?C                   Call      '#GETDATE'
    ?C     SelDate       Parm      SelDate       #Date             6 0
    ?C                   Parm                    #FromDate         6 0
    ?C                   Parm                    #ToDate           6 0
    ?C                   Parm      '1111111'     #DaysOK           7            SSMTWTF
    ?C                   Parm                    #ReqPrior         1
    ?C                   Parm                    #ReqFuture        1
    ?C                   Parm      '1'           #TodayOK          1
    ?C                   Parm      'Select the'  #Text01          40
    ?C                   Parm      'date for the'#Text02          40
    ?C                   Parm      'Spray Run'   #Text03          40
    ?C                   Parm                    #Text04          40
    ?C                   Parm                    #Text05          40
      *
     C                   Eval      SelDate7 = $Date7($DateMDY(SelDate))
      *
     C***
      ** READ  CONTROL FILE
     C***
     C*    *HIVAL        SETGT     FCHMCTL
     C*                  READP     FCHMCTL                                91
     C     SelDate7      Chain     FCHMCTL                            91
     C     *IN91         IFEQ      *OFF
     C                   MOVE      CHWKDT        STRDAT            7 0
     C                   END
     C***
     C                   MOVE      STRDAT        CRWKDT
     C***
     C                   EXSR      INIT
     C**
     C     RUNKEY        SETLL     FCHMRUN5
     C     NXTREC        TAG
     C     SelDate7      READE     FCHMRUN5                               LR
     C     *INLR         DOWEQ     *OFF
     C**
     C                   MOVE      *BLANKS       WRLOOK
     C                   MOVEL     CRLOOK        WRLOOK           15
     C**
     C**
     C                   MOVE      CRWKDT        CJWKDT
     C                   MOVE      CRJOB#        CJJOB#
     C**
     C                   MOVE      *BLANKS       WKLOOK
     C     JOBKEY        CHAIN     FCHMJOB                            96
     C     *IN96         IFEQ      *OFF
     C                   MOVEL     CJLOOK        WKLOOK           30
     C     CJTRAY        DIV       55            WKPOLE            4 2
     C                   END
     C**
     C**  BREAK FOR ITEM/PPM CHANGE
     C**
     C                   MOVEL     CRSPRY        WRKDEC           17
     C                   MOVE      CRSPIT        WRKDEC
     C                   MOVE      CRPPM         WRKDEC
     C**
     C     WRKDEC        IFNE      WRKDES
     C                   Z-ADD     0             TRAYS
     C                   Z-ADD     0             GALS
     C                   Z-ADD     0             POLES
     C                   Z-ADD     0             OZS
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
     C                   MOVE      WRKDEC        WRKDES           17
     C**
     C*                  READ      FCHMRUN5                               LR
     C     SelDate7      READE     FCHMRUN5                               LR
     C                   END
     C**
     C************************
     C** ITEM BREAK
     C************************
     C     ITMBRK        BEGSR
     C**
     C**
     C                   MOVE      CRSPRY        CTSPRY
     C                   MOVE      CRSPIT        CTSPIT
     C                   MOVE      CRPPM         CTPPM
     C     TOTKEY        CHAIN     FCHMTOT1                           98
     C     *IN98         IFEQ      *OFF
     C                   MOVEL     CTGALS        GALS              5 2
     C                   MOVEL     CTTRAY        TRAYS             5 0
     C                   MOVEL     CTPOLE        POLES             5 0
     C                   END
     C***
     C                   MOVE      CJSPIT        COITEM
     C                   MOVE      CJPPM         COPPM
     C     OZSKEY        CHAIN     FCHMOZS                            92
     C     *IN92         IFEQ      *OFF
     C     CTGALS        MULT      COOUNS        OZS               7 2
     C                   END
     C***
     C     COITEM        IFEQ      '7206'                                       NO SPRAY
     C                   Z-ADD     0             OZS
     C                   END
     C**
     C                   MOVEL     CRSPIT        CAITEM
     C                   MOVE      CRPPM         CAPPM
     C                   MOVE      CRSPRY        CASPRY
     C     APPKEY        CHAIN     FCHMAPPR                           92
     C     *IN92         IFEQ      *OFF
     C                   MOVE      CAAPP1        WRAPP1            8
     C                   MOVE      CAAPP2        WRAPP2            8
     C                   END
     C*
     C     COITEM        IFEQ      '7206'                                       NO SPRAY
     C                   MOVE      *BLANKS       WRAPP1
     C                   MOVE      *BLANKS       WRAPP2
     C                   END
     C**
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
     OQPRINT    E            HDGS           1 02
     O                                            6 'CHP222'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           65 'Weekly Spray Run Report'
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
     O                                           51 'Trays'
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
     O                                           66 'Trays'
     O                                           72 'Poles'
     O                                           79 'Ship'
     O                                           84 'End'
     O                                           89 'End'
     O                                           95 'Comp'
     O          E            HDGS1          2
     O                                            3 'Hse'
     O                                           19 'L/R'
     O                                           23 'Pol'
     O                                           28 'Code'
     O                                           48 'Name'
     O                                           79 'Date'
     O                                           84 'L/R'
     O                                           90 'Pole'
     O          E            DETL1          2
     O                       CRSPIT              12
     O                       CRPPM         4     18
     O                       WRLOOK              41
     O                       TRAYS         Z     51
     O                       POLES         4     62
     O                       GALS          4     74
     O                       OZS           4     87
     O          E            DETL1          1
     O                                           13 'Sprayer:'
     O                       CRSPRY              20
     O                                           50 'Applicator1:'
     O                       WRAPP1              59
     O                                           77 'Applicator2:'
     O                       WRAPP2              86
     O          E            DETL2       1  1
     O                       CJHSE         Z      2
     O                       CRSECT        Z      7
     O                       CRBAY         Z     11
     O                       CRNOS               14
     O                       CRSLOR              18
     O                       CRSPOL        Z     22
     O                       CJSIZE              27
     O                       WKLOOK              59
     O                       CRTRAY        Z     65
     O                       WKPOLE        4     71
     O                       CJRDYD        Y     80
     O                       CRELOR              83
     O                       CREPOL        Z     89
     O**
