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
      **PROGRAM NAME-------- SCR210
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- MANUAL INPUT FOR GREENHOUSE CART ENTRY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FNCR201HHFMCF   E             WORKSTN
     F                                     SFILE(SCR20101S:RRN01)
     F                                     SFILE(SCR20102S:RRN02)
     FFCALEN    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FNCARTST   O  A E           K DISK
      *
      *
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  CRMDY                  1      6  0                                      ARC380
     D  CRCYMD                 7     13  0                                      ARC380
     D  CRYEAR                14     17  0                                      ARC380
     D  CRWEEK                18     19  0                                      ARC380
     D  NXMDY                 20     25  0                                      ARC380
     D  NXCYMD                26     32  0                                      ARC380
     D  NXYEAR                33     36  0                                      ARC380
     D  NXWEEK                37     38  0                                      ARC380
     D  LCANCL               133    133                                         ARC380
      ***********************
     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   RRN02         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D  ItemKey        S                   Like(ITEM)
      ***********************

     D  ITEM           S             12A
     D  SIZE           S              3A

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate

      ** START HERE        **
      ***********************
     C     RSTART        TAG
      ** IF WEDNESDAY OR LATER USE NEXT WEEK ELSE USE THIS WEEK
     C     TODAY         IFGE      3
     C                   Z-ADD     NXMDY         SHPDAT
     C                   ELSE
     C                   Z-ADD     CRMDY         SHPDAT
     C                   END
      ** Make the Date Tommorrow unless it's currently Saturday... then make it Next Monday
     C     TODAY         IFGE      6
     C                   Z-ADD     NXMDY         SHPDAT
     C                   ELSE
     C                   Eval      SHPDAT = $MDYDate($AddDate($Date(0):1))
     C                   END
      ** WRITE SCRNA
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG  DO
      ** CHECK INPUT
     C                   SETOFF                                       101112
     C                   SETOFF                                       202122
     C                   SETOFF                                       2324
     C     SHPDAT        IFLE      0
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   END
     C     SHPDAT        CHAIN     FCALEN                             10
     C   10              DO
     C                   SETON                                        11
     C                   GOTO      NXTA
     C                   ENDDO                                                  10  DO
     C                   Z-ADD     CLCYMD        SHPCYM            7 0
     C                   SETOFF                                       555660
      ** WRITE SCRNA1
     C     RSTRT1        TAG
     C                   Z-ADD     0             CARTNO
     C                   Z-ADD     0             QTY
     C                   MOVE      *BLANKS       IMDES1
     C*                  MOVE      *BLANKS       ITEM
     C*                  MOVE      *BLANKS       SIZE
     C                   SETOFF                                       202110
     C                   SETOFF                                       303132
     C                   SETOFF                                         9899
     C                   ExSr      LoadSfl
     C     NXTA1         TAG
     C                   ExFmt     SCR20101C
     C                   SETON                                          60
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG  DO
     C                   SETOFF                                       202110
     C                   SETOFF                                       303132
     C                   SETOFF                                           99
      ** NOW CHECK CART NUMBER
     C     CARTNO        IFLE      0
     C                   SETON                                        202199
     C                   GOTO      NXTA1
     C                   END
     C                   SETON                                        98
      *
     C                   Eval      TOTQTY = *Zeros
     C                   ReadC     SCR20101S
     C                   DoW       not %EOF(NCR201HHFM)
     C                   Eval      ITEM = %SUBST(ITEMSIZE:1:4)
     C                   Eval      SIZE = %SUBST(ITEMSIZE:5:3)
     C     ITMKEY        KList
     C                   KFld                    ITEM
     C                   KFld                    SIZE
     C     ITMKEY        CHAIN     FMINVT                             10
     C                   If        %Found(FMINVT) and QTY > 0
     C                   If        *InKJ
     C                   Eval      RRN02 = RRN01
     C                   Eval      TOTQTY = TOTQTY + QTY
     C                   Write     SCR20102S
     C                   Eval      *In28 =  *On
     C                   Update    SCR20101S
     C                   Eval      *In28 =  *Off
     C                   Else
     C                   ExSr      BLDITEMS
     C                   EndIf
     C                   EndIf
     C                   ReadC     SCR20101S
     C                   EndDo
      *
     C                   If        *InKJ
     C                   Eval      *InKJ = *Off
     C                   ExFmt     SCR20102C
     C                   GOTO      NXTA1
     C                   EndIf
      **  PRINT
     C                   Z-ADD     0             CONTRL            6 0
     C                   CALL      'NCR230CL'
     C                   PARM                    CARTNO
     C                   PARM                    SHPCYM
     C                   PARM                    SMASTER
     C                   PARM                    CONTRL
     C                   GOTO      RSTRT1
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR

      ***********************
      ** BUILD ITEM RECORDS**
      ***********************
     C     BLDITEMS      BEGSR
      ** NOW BUILD CART RECORDS
     C                   Z-ADD     0             OUT               2 0
      ** IF THERE UPDATE
     C     NXTOUT        TAG
     C                   CLEAR                   RCARTS
     C                   Z-ADD     CARTNO        CTCART
     C                   MOVEL     'A'           CTSTAT
     C                   Z-ADD     99999999      CTTAG#
     C                   MOVEL     ITEM          CTITEM
     C                   MOVEL     SIZE          CTSIZE
     C                   Z-ADD     SHPCYM        CTSHDT
     C                   Z-ADD     SMASTER       CTMSTR
     C                   WRITE     RCARTS
     C                   ADD       1             OUT
     C     OUT           IFLT      QTY
     C                   GOTO      NXTOUT
     C                   END
     C                   ENDSR
      ***********************
      ** load subfile empty **
      ***********************
     C     LoadSfl       BEGSR
      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
    ?C                   Write     SCR20101C                                    ?
    ?C                   Write     SCR20102C                                    ?

      *? Load the Subfile Empty

     C                   Z-add     *Zero         RRN01                          ?
     C                   Eval      ITEMSIZE = *Blanks
     C                   Eval      QTY      = *Zeros

     C                   Do        30
     C                   Add       1             RRN01                          ?
    ?C                   Write     SCR20101S                                    ?
     C                   Eval      *In26 = *On                                  ?
     C                   EndDo                                                  ?

     C                   IF        *In26 = *On                                  ?
    ?C     RRN01         Chain     SCR20101S                                    ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    SCR20101S                                    ?
     C                   EndIF                                                  ?
     C                   Eval      *In25 = *On
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     TDATE         CHAIN     FCALEN                             90
     C                   Z-ADD     CL#Y          TODAY             1 0
     C                   MOVE      *BLANKS       LCANCL
     C                   Eval      *In40 = *On
     C                   ENDSR
