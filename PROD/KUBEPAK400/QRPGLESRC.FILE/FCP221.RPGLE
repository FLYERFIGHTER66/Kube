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
     FFFCMRUN6  IF   E           K DISK
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
     D  PROGID                 1     10                                         PROGRAM NAME
     D  RLIBR                 81     90                                         RUN LIBRARY
     D  USERID               254    263                                         USER I.D.
     D  SLIBR                314    323                                         SOURCE LIBRARY

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

     D  Location       DS
     D    CRSECT
     D*   CRBAY
     D*   CRNOS




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

     C     RUNKEY        SETLL     FFCMRUN6
     C     NXTREC        TAG
     C                   READE     FFCMRUN6                               LR
     C     *INLR         DOWEQ     *OFF

     C                   MOVE      *BLANKS       WRLOOK
     C                   MOVEL     CRLOOK        WRLOOK           15


     C                   MOVE      CRWKDT        CJWKDT
     C                   MOVE      CRJOB#        CJJOB#

     C                   MOVE      *BLANKS       WKLOOK
     C     JOBKEY        CHAIN     FFCMJOB                            96
     C     *IN96         IFEQ      *OFF
     C                   MOVEL     CJLOOK        WKLOOK           30
wjb  C                   z-add     cjpole        WKPOLE            4 2
     C                   END

     C**  BREAK FOR LOCATION CHANGE
     C**
     C*                  MOVEL     CRSPRY        WRKDEC           17
     C*                  MOVE      CRSPIT        WRKDEC
     C*                  MOVE      CRPPM         WRKDEC
     C                   MOVEL     Location      WRKDEC           17
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
     C                   EXCEPT    HDGS1
     C                   MOVE      *OFF          *IN10
     C                   END
     C**
     C                   EXCEPT    DETL2
     C**
     C**
     C                   MOVE      WRKDEC        WRKDES           17
     C**
     C     STRDAT        READE     FFCMRUN6                               LR
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
     O                                            6 'FCP221'
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
     O                       TIMOD               95 '  :  :  '

     O          E            HEAD        1  1
     O                                           51 'Section:'
     O                       WRKDEC              69

     O          E            HDGS1       1  1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           95 '_______________________'

     O          E            HDGS1       1  1
     O          E            HDGS1          2
     O                                           03 'Bay'
     O                                           11 'Pole'
     O                                           18 'Poles'
     O                                           25 'Size'
     O                                           39 'Product Name'
     O                                           66 'Chemical'
     O                                           84 'PPM'
     O          E            DETL2       1  1
     O                       CRBAY         Z     02
     O                                           03 '-'
     O                       CRNOS               04
     O                       CRSEOW              05
     O                       CRSPOL        Z     10
     O                       WKPOLE        4     18
     O                       CJSIZE              24
     O                       WKLOOK              56
     O                       CRLOOK              73
     O                       CRPPM         4     84
     O**
