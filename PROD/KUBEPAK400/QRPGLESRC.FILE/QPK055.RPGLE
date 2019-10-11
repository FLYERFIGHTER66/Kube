      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.      1998
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   .  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- QPK055
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT SYSTEM
      **APPLICATION--------- SUMMARY PICK SLIP BY ITEM NUMBER
      *                      SELECTED FROM QPK050
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFIORDRAS  UF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FWBIR312   UF A E           K DISK
     FBIR312    O    F  132        PRINTER OFLIND(*INOF)
      *
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND                      @DT
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
      *
     D                UDS
     D  LSUMPK                 1      1
     D  LCOPY                 29     30  0
     D  LPRTR                 66     75
     I*                                     133 133 LCANCL
      *
     C                   Z-ADD     1             PSD               2 0
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     *ZEROS        KEY               2 0
     C     KEY           CHAIN     FMCOMP                             88
     C                   SETON                                        8990
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       4058
     C                   READ      FIORDRAS                               90
     C   90              GOTO      END
      *
     C     OISTAT        IFEQ      'D'
     C                   GOTO      END
     C                   ENDIF
     C     OIITYP        IFEQ      'S'
     C     OIITYP        OREQ      'F'
     C     OISPFL        ORNE      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK IF QTY SHIPPED >= QTY ORDERED, DO NOT PRINT
      *
     C     OIQSHP        IFGE      OIQORD
     C                   GOTO      NXT
     C                   ENDIF
     C     OIQORD        SUB       OIQSHP        QTYOPN           11 1          OPEN QTY
     C     OIRQTY        IFGT      0
     C                   Z-ADD     OIRQTY        QTYOPN
     C                   END
      *
     C     OIORD#        CHAIN     FHORDR                             22
      *
     C     OHSTAT        IFEQ      'D'
     C     OHCOFL        OREQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   MOVEL     OHNAME        SHNAME           20
      *
     C   55OIITEM        IFNE      OITEM
     C     OISIZE        ORNE      OSIZE
     C                   Z-ADD     1             PSD
     C                   EXCEPT    TL1
     C                   ENDIF
      *
      *  GET ITEM MASTER RECORD
      *
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     KEY18         CHAIN     FMINVT                             75
     C                   EXSR      GETDES
      *
     C                   MOVEL     OIITEM        OITEM            12
     C                   MOVEL     OISIZE        OSIZE             3
     C     OISIZE        CHAIN     FMSIZE                             90
     C                   MOVEL     SZDESC        SZDES            10
     C                   MOVEL     IMPUOM        OUOM              2
     C                   MOVEL     DESP          ODESC            36
     C   OF              Z-ADD     1             PSD
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C     OIITYP        IFEQ      'C'
     C                   GOTO      NXT
     C                   ENDIF
     C     PSD           IFEQ      1
     C                   SETON                                        58
     C                   ENDIF
     C                   SETON                                        55
     C                   ADD       QTYOPN        TOTQTY           11 1
     C                   ADD       QTYOPN        FTOT             11 1
      *
     C                   MOVEL     *BLANKS       OISPFL
     C                   UPDATE    RIORDR
      ** WRITE SUMM RECORD
     C     WRKKEY        KLIST
     C                   KFLD                    OIALPH
     C                   KFLD                    OICUST
     C                   KFLD                    OIORD#
     C     WRKKEY        CHAIN     WBIR312                            78
     C   78              DO
     C                   CLEAR                   RBIR312
     C                   Z-ADD     OICUST        OWCUST
     C                   Z-ADD     OIORD#        OWORD#
     C                   ENDDO
     C                   MOVEL     OIALPH        OWLOOK
     C                   ADD       QTYOPN        OWQOPN
     C   78              WRITE     RBIR312
     C  N78              UPDATE    RBIR312
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C     TOTQTY        IFGT      *ZEROS
     C                   EXCEPT    TL1
     C                   EXCEPT    TLR
     C                   ENDIF
     C                   SETON                                        LR
      *
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'P'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             36
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
      *****
      ********************************************************************@DT@B1
      * CONVERT CYYMMDD TO DAY OF CENTURY DDDDD. INDICATOR 90 MINUS DATE  @DT@B1
      * ##CYMD INPUT DATE CYYMMDD                                         @DT@B1
      * ##DDD OUTPUT DAY OF CENTURY DDDDD. BASE DATE IS 01/01/1900        @DT@B1
      * INDICATORS USED 90-92.                                            @DT@B1
      ********************************************************************@DT@B1
     C     @DT@B1        BEGSR                                                                 @DT@B
     C                   Z-ADD     ##CYMD        ##CYMD            7 0  90      NEG DATE       @DT@B
      * CONVERT YEAR TO DAYS                                              @DT@B1
     C                   MOVEL     ##CYMD        #03               3 0          YY             @DT@B
     C     #03           MULT      365           ##DDD             5 0          FIRST LEAP     @DT@B
     C     #03           DIV       4             #03                      93    # OF LEAPS     @DT@B
     C                   MVR                     #02A              2 0    91    LEAP YEAR      @DT@B
     C   91
     CANN93#03           SUB       1             #03                                           @DT@B
     C     #03           ADD       ##DDD         ##DDD                          DAYS FOR LEAP  @DT@B
      * CONVERT MONTH TO DAYS                                             @DT@B1
     C                   MOVE      ##CYMD        #04               4 0          MMDD           @DT@B
     C                   MOVEL     #04           #02A                           MM             @DT@B
     C     #DY(#02A)     ADD       ##DDD         ##DDD                          DAY OF YEAR    @DT@B
     C     #02A          COMP      02                                 92        GT FEB         @DT@B
     C   91
     CAN 92
     CANN931             ADD       ##DDD         ##DDD                          LP YR MM 3-12  @DT@B
      * ADD DAY OF MONTH                                                  @DT@B1
     C                   MOVE      ##CYMD        #02               2 0          DD             @DT@B
     C     #02           ADD       ##DDD         ##DDD                          ADD DAYS       @DT@B
     C   90              Z-ADD     0             ##DDD                                         @DT@B
     C                   SETOFF                                       919293                   @DT@B
     C                   ENDSR                                                                 @DT@B
      ********************************************************************@DT@B1
      *
     OBIR312    E            HDG            1 03
     O                       PROGID              10
     O                                           19 'Reqd by:'
     O                       USERID              30
     O                       MCNAME              65
     O                       PAGE          1     80
     O                                           76 'Page'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           53 'Summary Pick Slips B'
     O                                           59 'y Item'
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            2
     O                                           53 'For Items with Chang'
     O                                           61 'ed Dates'
     O*                                   5 'From:'
     O*                        LBEGDTY   14
     O*                                  18 'To:'
     O*                        LENDDTY   27
     O*                                  71 'Prod Class:'
     O*                        LPC1      74
     O*                                  77 'To'
     O*                        LPC2      80
     O          E            HDG            1
     O                                            4 'Item'
     O                                           16 'Size'
     O                                           30 'U/M'
     O                                           42 'Quantity'
     O                                           55 'Description'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           80 '________'
     O          EF           TL1         1  1
     O                       OITEM               12
     O                       OSIZE               16
     O                       SZDES               27
     O                       OUOM                30
     O                       TOTQTY        4B    40
     O                       ODESC               80
     O          E            TLR         1  2
     O                       FTOT          4B    30
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
