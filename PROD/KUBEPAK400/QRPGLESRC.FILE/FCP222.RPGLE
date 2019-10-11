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
      **PROGRAM NAME-------- CHP222
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- CHEMICAL
      **PROGRAMMER---------- C.BUCK
      **APPLICATION--------- WEEKLY SPRAYER CONTROL REPORT.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFCP222FM  CF   E             WORKSTN
     FFFCMJOB   IF   E           K DISK
     FFFCMRUN5  IF   E           K DISK
     FFFCMCTL   IF   E           K DISK
     FFFCMTOT1  IF   E           K DISK
     FFFCMAPPR  IF   E           K DISK
     FFFCMOZS   IF   E           K DISK
     Ffminvt    IF   E           K DISK
     FQPRINT98  O    F   98        PRINTER OFLIND(*IN10)
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
      ** CONTROL FILE ARRAYS

     D
     D imdes10         S             10A
     D item1           S                   Like( CRSPIT )
     D ppm1            S                   Like( CRPPM  )
     D descr1          S                   Like( WRLOOK )
     D OZSitem1        S                   Like( OZS    )
     D item2           S                   Like( CRSPIT )
     D ppm2            S                   Like( CRPPM  )
     D descr2          S                   Like( WRLOOK )
     D OZSitem2        S                   Like( OZS    )

     D  RunDate        S              6S 0

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$isDate#
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY


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
     C***
      ** READ  CONTROL FILE
     C***
     C     *HIVAL        SETGT     FFCMCTL
     C                   READP     FFCMCTL                                91
     C     *IN91         IFEQ      *OFF
     C                   MOVE      CHWKDT        STRDAT            7 0
     C                   Eval      FRMDAT  = $MDYDate($Date(STRDAT))
     C                   END
     C***
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
     C                   MOVE      STRDAT        CRWKDT
     C                   Eval      RunDate = $MDYDate($Date(STRDAT))
     C***
     C                   EXSR      INIT
     C**
     C     RUNKEY        SETLL     FFCMRUN5
     C     NXTREC        TAG
     C                   READE     FFCMRUN5                               LR
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
     C     JOBKEY        CHAIN     FFCMJOB                            96
     C     *IN96         IFEQ      *OFF
     C                   MOVEL     CJLOOK        WKLOOK           30
wjb  C*    CJTRAY        DIV       55            WKPOLE            4 2
wjb  C                   z-add     cjpole        WKPOLE            4 2
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
     C*                  Exsr      MultSr
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
     C     STRDAT        READE     FFCMRUN5                               LR
     C                   END
     C**
     C     multsr        begsr
     C     item700       chain     FMINVT
     C     item700       KLIST
     C                   KFld                    CRSPIT
     C                   KFld                    CRSPSZ
     C                   If        IMDES2 = *Blanks
     C                   Eval      *In11    = *Off
     C                   Eval      item1    = CRSPIT
     C                   Eval      ppm1     = CRPPM
     C                   Eval      descr1   = WRLOOK
     C                   Eval      OZSitem1 = OZS
     C                   Eval      item2    = *Blanks
     C                   Eval      ppm2     = *Zeros
     C                   Eval      descr2   = *Blanks
     C                   Eval      OZSitem2 = *Zeros
     C                   Else
     C                   Eval      *In11    = *On
     C                   Eval      imdes10  = %subst(IMDES1:01:10)
     C                   Eval      item1    = %subst(IMDES2:27:04)
     C                   Eval      ppm1     = %dec(%subst(IMDES2:19:07):6:2)
     C                   Eval      descr1   = %subst(IMDES2:01:15)
     C                   Eval      item2    = %subst(IMDES3:27:04)
     C                   Eval      ppm2     = %dec(%subst(IMDES3:19:07):6:2)
     C                   Eval      descr2   = %subst(IMDES3:01:15)
     C                   EndIf
     C                   endsr
     C************************
     C** get ounces
     C************************
     C     GetOzs        BEGSR
     C                   Z-add     *Zero         OZS
     C     OZSKEY        CHAIN     FFCMOZS                            92
     C     *IN92         IFEQ      *OFF
     C     CTGALS        MULT      COOUNS        OZS               7 2
     C                   END
     C                   endsr
     C************************
     C** ITEM BREAK
     C************************
     C     ITMBRK        BEGSR
     C**
     C**
     C                   Exsr      MultSr
     C                   MOVE      CRSPRY        CTSPRY
     C                   MOVE      CRSPIT        CTSPIT
     C                   MOVE      CRPPM         CTPPM
     C     TOTKEY        CHAIN     FFCMTOT1                           98
     C     *IN98         IFEQ      *OFF
     C                   MOVEL     CTGALS        GALS              5 2
     C                   MOVEL     CTTRAY        TRAYS             5 0
     C                   MOVEL     CTPOLE        POLES             7 2
     C                   END
     C***
     C                   If        not *In11
     C                   MOVE      CJSPIT        COITEM
     C                   MOVE      CJPPM         COPPM
     C                   ExSr      GetOzs
     C                   Eval      OZSItem1 = OZS
     C                   Else
     C                   MOVE      Item1         COITEM
     C                   MOVE      PPM1          COPPM
     C                   ExSr      GetOzs
     C                   Eval      OZSItem1 = OZS
     C                   MOVE      Item2         COITEM
     C                   MOVE      PPM2          COPPM
     C                   ExSr      GetOzs
     C                   Eval      OZSItem2 = OZS
     C                   EndIf
     C***
     C     COITEM        IFEQ      '7206'                                       NO SPRAY
     C                   Z-ADD     0             OZS
     C                   END
     C**
     C                   MOVEL     CRSPIT        CAITEM
     C                   MOVE      CRPPM         CAPPM
     C                   MOVE      CRSPRY        CASPRY
     C     APPKEY        CHAIN     FFCMAPPR                           92
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
     OQPRINT98  E            HDGS           1 02
     O                                            6 'CHP222'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           57 'Spray Run Report for:'
     O                       RunDate             67 '  /  /  '
     O                       PAGE          Z     95
     O                                           91 'Page:'
     O          E            HDGS           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           86 'Time:'
     O               11                          54 'Chemical Mix:'
     O               11      IMDES10             66
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
     O          E            DETL1          1
     O                       item1               12
     O                       ppm1          4     18
     O                       descr1              41
     O                       TRAYS         Z     51
     O                       POLES         4     62
     O                       GALS          4     74
     O                       OZSitem1      4     87
     O          E            DETL1          1
     O                       item2               12
     O                       ppm2          4     18
     O                       descr2              41
     O               11                          50 '"'
     O               11                          61 '"'
     O               11                          73 '"'
     O                       OZSitem2      4     87
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
     O                       CRSEOW              18
     O                       CRSPOL        Z     22
     O                       CJSIZE              27
     O                       WKLOOK              59
     O                       CRTRAY        Z     65
     O                       WKPOLE        4     71
     O                       CJRDYD        Y     80
     O                       CREEOW              83
     O                       CREPOL        Z     89
     O**
