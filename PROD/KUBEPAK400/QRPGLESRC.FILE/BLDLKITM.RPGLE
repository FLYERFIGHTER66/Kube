      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1998
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
      **PROGRAM NAME-------- BLDLKITM
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER----------
      **APPLICATION---------
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMINVT    UF   E           K DISK
     FFINVAVL   IF   E           K DISK
     FFLKITM    O  A E           K DISK
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LDAPTO                 1      1  0                                      ARC380
      ***********************
      *  READ MINVT
      ***********************
     C     NXT           TAG
     C                   READ      FMINVT                                 90
     C   90              GOTO      END
     C     IMSTAT        IFEQ      'D'
     C     IMPRPL        OREQ      'N'
     C                   GOTO      NXT
     C                   END
     C                   Z-ADD     0             #OPRC             9 4
     C                   Z-ADD     0             OIQDDC            4 2
     C                   Z-ADD     0             OHBLCU            6 0
     C                   Z-ADD     0             OHORD#            6 0
     C                   Z-ADD     1             QTYORD            8 1
     C                   MOVEL     '1'           PRICD             1
     C                   MOVEL     'N'           OICTCD            1
     C                   MOVEL     'N'           OIFRQD            1
     C                   Z-ADD     0             VOLDSC            4 2
     C                   MOVEL     IMORDD        ORDD              1
     C                   CALL      '#PRICE'
     C                   PARM                    OHBLCU
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMBPUM
     C                   PARM                    QTYORD
     C                   PARM                    PRICD
     C                   PARM                    #OPRC
     C                   PARM                    OIQDDC
     C                   PARM                    OICTCD
     C                   PARM                    VOLDSC
     C                   PARM                    OIFRQD
     C                   PARM                    OHORD#
     C                   PARM                    ORDD
     C                   Z-ADD     #OPRC         LKUPRI
      ** GET DESCRIPTION
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C     DESCO         IFGT      *BLANKS
     C                   MOVEL     DESCO         LKDES1
     C                   ELSE
     C                   MOVEL     IMDES1        LKDES1
     C                   END
     C                   MOVEL     IMITEM        LKITEM
     C                   MOVEL     IMSIZE        LKSIZE
     C                   MOVEL     IMWHSE        LKWHSE
     C                   Z-ADD     IMCOMP        LKCOMP
     C                   MOVEL     IMITEM        LKITEM
     C                   Z-ADD     IMQTOH        LKPOH
     C                   Z-ADD     IMQTAL        LKPAL
     C                   Z-ADD     IMQTSO        LKSAL
      ** GET NEXT
     C     AVAKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
     C     AVAKEY        SETLL     FINVAVL
     C     NXTAVL        TAG
     C     AVAKEY        READE     FINVAVL                                90
     C  N90              DO
     C     FADTRV        IFLE      TSTDAT
     C                   GOTO      NXTAVL
     C                   END
     C                   ADD       FAQTOR        LKNOH
     C                   ADD       FANAL         LKNAL
     C                   GOTO      NXTAVL
     C                   ENDDO                                                     90 DO
     C                   Z-ADD     0             IMQTSO
     C                   MOVEL     IMLOOK        LKLOOK
     C                   WRITE     RLKITM
     C                   UPDATE    RMINVT
     C                   Z-ADD     0             LKNOH
     C                   Z-ADD     0             LKNAL
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        TSTDAT            7 0
     C                   ENDSR
      ********************************************************************@DT@A1
      * VALIDATE DATES. INDICATOR 90 IS ON IF ERROR. 91-92 ALWAYS SETOF.  @DT@A1
      * YY GE 00  MM 01-12 DAY 01-28/29/30/31                             @DT@A1
      * ##MDY INPUT DATE MMDDYY                                           @DT@A1
      * ##CYMD OUTPUT DATE CYYMMDD IF DATE IS OK. ELSE ZERO.              @DT@A1
      * C IDENTIFIES 20 OR 21 CENTURY. C=0 FOR YY 70-99. C=1 FOR YY 00-69.@DT@A1
     C     @DT@A1        BEGSR                                                                 @DT@A
     C                   MOVE      ##MDY         #03A              3 0          MYY            @DT@A
     C                   MOVEL     0             #03A                           CYY            @DT@A
     C                   MOVEL     ##MDY         #04               4 0          MMDD           @DT@A
     C                   MOVEL     ##MDY         #02B              2 0          MM             @DT@A
     C                   MOVE      #04           #02C              2 0          DD             @DT@A
     C                   Z-ADD     ##MDY         ##MDY             6 0  90      YY IS NEGATIVE @DT@A
     C  N90              Z-ADD     #02B          #02               2 0    90    MM LT 01 ERROR @DT@A
     C  N90#02B          COMP      12                                 90        MM GT 12 ERROR @DT@A
     C  N90#02C          COMP      01                                   90      DD LT 01 ERROR @DT@A
     C  N90#02C          COMP      31                                 90  91    DD GT OR EQ 31 @DT@A
     C     #02B          COMP      07                                 92        MM 08-12       @DT@A
     C   921             ADD       #02B          #02                            MAKE MM ODD    @DT@A
     C     #02           DIV       2             #02                                           @DT@A
     C                   MVR                     #02                  92        31 DAY MONTH   @DT@A
     C   91
     CANN92              SETON                                        90        MM EVEN DD 31  @DT@A
     C     #02B          COMP      02                                     91    FEB            @DT@A
     C  N91                                                                                    @DT@A
     COR 90              GOTO      @DT@AX                                                      @DT@A
     C     #03A          DIV       4             #03               3 0          JUST FOR MVR   @DT@A
     C                   MVR                     #02                      91    LEAP YEAR      @DT@A
     C     #02C          COMP      29                                 90  92    DD GT 29 ERROR @DT@A
     C  N91
     CAN 92              SETON                                        90        NO LEAP DD 29  @DT@A
     C     @DT@AX        TAG                                                    GOOD DATE      @DT@A
     C                   MOVEL     #03A          ##CYMD            7 0          CYY----        @DT@A
     C                   MOVE      #04           ##CYMD                         CYYMMDD        @DT@A
     C     #03A          COMP      070                                  91                     @DT@A
     C   91              MOVEL     1             ##CYMD                         21ST CENTURY   @DT@A
     C   90              Z-ADD     0             ##CYMD                         ERROR          @DT@A
     C                   SETOFF                                       9192                     @DT@A
     C                   ENDSR                                                                 @DT@A
