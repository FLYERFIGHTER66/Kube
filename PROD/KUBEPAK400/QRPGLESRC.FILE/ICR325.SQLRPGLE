    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *--------------------------------------------------------------
      *
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ICR325
      *SYSTEM-------------- INVENTORY
      *DESCRIPTION--------- STOCK STATUS REPORT PROMPT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  6/08/00 EFD TAKE OUT ON P.O. AND BACKORDER AND MOVE SPACEING
EFD01 *  6/13/00 EFD IF QTY O.H. = OR - PRINT ON ON-HAND YES OPTION
      *
     FFMINVTPS  IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     F*FMWHSE  IF  E           K        DISK
     FICR325    O    F   85        PRINTER OFLIND(*INOF)
      *
     D OnOrderList     PR              N
     D  #Item                              Like(IMITEM)
     D  #Size                              Like(IMSIZE)
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
     D  LCO                    1      2  0
     D  LBITEM                 3     14
     D  LEITEM                15     26
     D  LBSIZE                27     29
     D  LESIZE                30     32
     D  LBLOC                 33     35
     D  LELOC                 36     38
     D  LBVEND                39     44  0
     D  LEVEND                45     50  0
     D  LPC1                  51     52
     D  LPC2                  53     54
     D  LOH                   55     55
     D  LZOH                  56     56
     D  LNOH                  57     57
     D  LBRO                  58     58
     D  LBO                   59     59
     D  LZO                   60     60
     D  LPA                   61     61
WJB+ D  LOL                   62     62
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     1             PRC
      *
WJB  C*    LCO           CHAIN(N)  FMCORG                             90
WJB  C     LCO           CHAIN     FMCORG                             90
     C                   SETON                                        8990
      *
     C     LOH           IFEQ      'Y'                                           PLUS O/H
     C                   SETON                                        70
     C                   ENDIF
      *
     C     LZOH          IFEQ      'Y'                                           NEG O/H
     C                   SETON                                        71
     C                   END
      *
     C     LNOH          IFEQ      'Y'                                           0 ON HAND
     C                   SETON                                        72
     C                   END
      *
     C     LBRO          IFEQ      'Y'                                           PRINT AT OR
     C                   SETON                                        73
     C                   END
      *
     C     LBO           IFEQ      'Y'                                           BACK ORDER
     C                   SETON                                        74
     C                   END
      *
     C     LZO           IFEQ      'Y'                                           ZERO ALLOCATED
     C                   SETON                                        75
     C                   END
      *
     C     LPA           IFEQ      'Y'                                           POSITIVE AVAIL.
     C                   SETON                                        76
     C                   END
      *
WJB+ C     LOL           IFEQ      'Y'                                           POSITIVE AVAIL.
WJB+ C                   SETON                                        78
WJB+ C                   END
      *
     C     LBITEM        IFGT      *BLANKS                                       ITM RANGE
     C                   SETON                                        40
     C                   ENDIF
      *
     C     LBSIZE        IFGT      *BLANKS                                       SIZE RANGE
     C                   SETON                                        41
     C                   ENDIF
      *
     C     LBLOC         IFGT      *BLANKS                                       LOC RANGE
     C                   SETON                                        42
     C                   ENDIF
      *
     C     LBVEND        IFGT      0                                             VEND RANGE
     C                   SETON                                        43
     C                   ENDIF
      *
     C     LPC1          IFGT      *BLANKS                                       PC RANGE
     C                   SETON                                        44
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C     RSTRT         TAG
     C                   Z-ADD     1             CNT               3 0
     C                   Z-ADD     1             LINE              3 0
     C     NXT           TAG
     C                   SETOFF                                       11
     C                   READ      FMINVTPS                               90
     C   90              GOTO      END
      *
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   40IMITEM        IFLT      LBITEM                                                   TEM
     C     IMITEM        ORGT      LEITEM                                                   TEM
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   41IMSIZE        IFLT      LBSIZE                                                   TEM
     C     IMSIZE        ORGT      LESIZE                                                   TEM
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   42IMWHSE        IFLT      LBLOC                                                    TEM
     C     IMWHSE        ORGT      LELOC                                                    TEM
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   43IMVEND        IFLT      LBVEND                                                   NDR
     C     IMVEND        ORGT      LEVEND                                                   NDR
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   44IMPCL1        IFLT      LPC1                                                     L
     C     IMPCL1        ORGT      LPC2                                                     L
     C                   GOTO      NXT
     C                   ENDIF
      *
      *  PLUS ON HAND
      *
EFD01C** 70      IMQTOH    IFLE 0                                      L
EFD01C     *In70         IFEQ      *On
EFD01C     IMQTOH        AndEq     *Zero
     C     IMQTAL        AndEq     *Zero
     C                   GOTO      NXT
     C                   ENDIF
      *
      *  ZERO ON HAND
      *
     C   71IMQTOH        IFNE      0                                                        L
     C                   GOTO      NXT
     C                   ENDIF
      *
      *  NEGATIVE ON HAND
      *
     C   72IMQTOH        IFGE      0                                                        L
     C                   GOTO      NXT
     C                   ENDIF
      *
      *  ITEMS BELOW REORDER
      *
     C   73IMQEOQ        IFEQ      *ZEROS                                                   L
     C                   GOTO      NXT
     C                   ENDIF
     C   73IMQTOH        IFGT      IMQEOQ                                                   L
     C                   GOTO      NXT
     C                   ENDIF
      *
      *  ITEMS ON BACKORDER
      *
     C   74IMQTBO        IFLE      0                                                        L
     C                   GOTO      NXT
     C                   ENDIF
      *
      *  ITEMS ON BACKORDER
      *
     C   74IMQTBO        IFLE      0                                                        L
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   55IMPCL1        IFGT      OLPCL1
EFD  C*                    Z-ADD1         PRC
     C                   EXCEPT    TL1
     C                   EXCEPT    HDG
     C                   SETOFF                                       55
     C                   ENDIF
      *
      *
      *  ITEMS WITH ZERO ALLOCATED
      *
     C     *IN75         IFEQ      *ON                                                      L
     C     IMQTAL        IFNE      0                                                        L
     C*          IMALC2    ORNE 0                                      L
     C*          IMALC3    ORNE 0                                      L
     C                   GOTO      NXT
     C                   ENDIF
     C                   ENDIF
      *
      *  ITEMS WITH POSITIVE AVAILABILITY
      *
     C     *IN76         IFEQ      *ON                                                      L
     C     IMQTAV        IFLE      0                                                        L
     C*          IMQTA2    ANDEQ0                                      L
     C*          IMQTA3    ANDEQ0                                      L
     C                   GOTO      NXT
     C                   ENDIF
     C                   ENDIF
      *
      *  ITEMS ON Order LIST (OL)
      *
WJB+ C                   If        *In78 and
WJB+ C                             not OnOrderList(IMITEM:IMSIZE)
WJB+ C                   GOTO      NXT
WJB+ C                   EndIf
      *
      *
      *
     C                   EXSR      GETDES
      *
     C     PRC           IFEQ      1
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C     IMPCL1        CHAIN     FMPRCL                             90
     C                   EXCEPT    DETL1
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   MOVEL     IMITEM        ITEM              6
     C                   Z-add     IMQTOH        IMQTOH0           9 0
     C                   Z-add     IMQTAL        IMQTAL0           9 0
     C                   Z-add     IMQTAV        IMQTAV0           9 0
     C                   EXCEPT    DETL
     C                   MOVEL     IMPCL1        OLPCL1            2
     C                   SETON                                        5577
     C                   ADD       1             PRC               4 0
      *
      * EXECUTE ITEM TOTALS SUBROUTINE
      *
     C                   EXSR      ITTOT
      *
     C                   MOVEL     IMITEM        OITEM            12
     C                   MOVEL     IMSIZE        OSIZE             3
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C   77              Z-add     PCQTOH        PCQTOH0           9 0
     C   77              Z-add     PCQTAL        PCQTAL0           9 0
     C   77              Z-add     PCQTAV        PCQTAV0           9 0
     C   77              EXCEPT    TL1
     C   77              Z-add     RPQTOH        RPQTOH0           9 0
     C   77              Z-add     RPQTAL        RPQTAL0           9 0
     C   77              Z-add     RPQTAV        RPQTAV0           9 0
     C   77              EXCEPT    TLR
     C  N77              EXCEPT    TLRN
     C                   SETON                                        LR
      *
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             30
     C                   ENDSR
      *
      *  *************************************************************
      *  *  THIS SUBROUTINE ACCUMULATES ITEM TOTALS FOR SIX FIELDS   *
      *  *  AND ALSO ACCUMULATES TOTAL VALUE OF INVENTORY            *
      *  *************************************************************
      *
     C     ITTOT         BEGSR
     C                   ADD       IMQTOO        PCQTOO           11 1
     C                   ADD       IMQTBO        PCQTBO           11 1
     C                   ADD       IMQTOH        PCQTOH           11 1
     C                   ADD       IMQTAL        PCQTAL           11 1
     C                   ADD       IMQTAV        PCQTAV           11 1
     C                   ADD       IMQTOO        RPQTOO           11 1
     C                   ADD       IMQTBO        RPQTBO           11 1
     C                   ADD       IMQTOH        RPQTOH           11 1
     C                   ADD       IMQTAL        RPQTAL           11 1
     C                   ADD       IMQTAV        RPQTAV           11 1
     C                   ENDSR
      *
      *  *************************************************************
      *  *  THIS SUBROUTINE CLEARS ITEM TOTAL FIELDS                 *
      *  *************************************************************
      *
     C     CLEAR         BEGSR
     C                   Z-ADD     0             ITMCST            9 2
     C                   Z-ADD     0             ITMQOO           11 1
     C                   Z-ADD     0             ITMQBO           11 1
     C                   Z-ADD     0             ITMQOH           11 1
     C                   Z-ADD     0             ITMQAL           11 1
     C                   Z-ADD     0             ITMQAV           11 1
     C                   Z-ADD     0             ITMMTD           11 1
     C                   ENDSR
      *
     OICR325    E            HDG            1 03
     O                                           10 'ICR325'
     O                                           21 'Req''d by:'
     O                       USERID              31
     O                       RGNAMC              58
     O**                                 95 'Company:'                    APR500
     O**                       LCO       98                               APR500
     O                       PAGE          1     78
     O                                           74 'Page:'
     O          E            HDG            1
     O                                           13 'Run Date:'
     O                       TDATE         Y     21
     O                                           56 'Stock Status By Product'
     O                                           63 ' Class'
     O                       TIMOD               78 '  :  :  '
     O          E            HDG            1
     O               70                          52 'Only Items With An On Ha'
     O               70                          67 'nd Balance     '
     O               71                          66 'Only Items With A Zero O'
     O               71                          81 'n Hand Quantity'
     O               72                          66 'Only Items With A Negati'
     O               72                          76 've Balance'
     O               73                          66 'Only Items At Or Below R'
     O               73                          78 'eorder Point'
     O               74                          66 'Only Items With Items On'
     O               74                          77 'Back Order'
     O               75                          66 'Only Items With Zero All'
     O               75                          76 'ocated    '
     O               76                          66 'Only Items Positive Avai'
     O               76                          76 'lability  '
     O               78                          66 'Only Items On Order List'
     O          E            HDG            1
     O                                           24 '    --------------------'
     O                                           48 '------------------------'
     O                                           72 '------------------------'
     O                                           85 '------       '
     O***                               120 '------------------------'
     O          E            HDG            1
     O                                           24 '- Selection Criteria-'
     O                                           36 'Item:'
     O              N40                          42 'ALL'
     O               40                          42 'From'
     O               40      LBITEM              55
     O               40                          62 'To'
     O               40      LEITEM              75
     O          E            HDG            1
     O                                           36 'Size:'
     O              N41                          42 'ALL'
     O               41                          42 'From'
     O               41      LBSIZE              46
     O               41                          50 'To'
     O               41      LESIZE              54
     O                                           63 'Vendor:'
     O              N43                          68 'ALL'
     O               43                          68 'From'
     O               43      LBVEND        Z     75
     O               43                          78 'To'
     O               43      LEVEND        Z     85
     O          E            HDG            1
     O                                           36 'Prod Class:'
     O              N44                          40 'ALL'
     O               44                          41 'From'
     O               44      LPC1                44
     O               44                          47 'To'
     O               44      LPC2                52
     O                                           63 'Location:'
     O              N42                          68 'ALL'
     O               42                          68 'From'
     O               42      LBLOC               72
     O               42                          75 'To'
     O               42      LELOC               79
     O          E            HDG            2
     O                                           24 '    --------------------'
     O                                           48 '------------------------'
     O                                           72 '------------------------'
     O                                           85 '------       '
     O**                                120 '------------------------'
     O          E            HDG            1
     O                                           54 '    --'
     O                                           74 'Q U A N T I T I E S'
     O                                           81 '---   '
     O          E            HDG            0
     O                                           12 'Item  '
     O                                           15 'Size'
     O                                           32 'Description'
     O                                           49 'UM'
     O**                                 64 'On P.O.'
     O**                                 78 'Back Order'
     O                                           60 'On Hand'
     O                                           69 'Alloc.'
     O                                           78 'Avail.'
     O          E            HDG            1
     O                                           24 '      __________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           78 '______'
     O**                                120 '________________________'
     O          EF           DETL1          0
     O                       IMPCL1              12
     O                       PCDESC              43
     O          EF           DETL1          1
     O                                           34 '________________________'
     O                                           43 '_________'
     O          EF           DETL           1
     O                       IMQTAV0       K     78
     O                       IMQTAL0       K     69
     O                       IMQTOH0       K     60
     O**                       IMQTBOK   78
     O**                       IMQTOOK   64
     O                       ITEM                12
     O                       IMSIZE              15
     O                       DESP                46
     O                       IMPUOM              49
     O          EF           TL1            1
     O                       PCQTAV0       KB    78
     O                       PCQTAL0       KB    69
     O                       PCQTOH0       KB    60
     O**                       PCQTBOKB  78
     O**                       PCQTOOKB  64
     O                                           49 'Product Class Totals:'
     O          EF           TLR            1
     O                       RPQTAV0       KB    78
     O                       RPQTAL0       KB    69
     O                       RPQTOH0       KB    60
     O**                       RPQTBOKB  78
     O**                       RPQTOOKB  64
     O                                           49 'Report Totals:'
     O          E            TLRN           1
     O                                           45 '**** There Are No Transa'
     O                                           68 'ctions For The Report S'
     O                                           82 'elections ****'
      // WJB+ Add OnOrderList SubProcedure
     P OnOrderList     B
     D OnOrderList     PI              N
     D  #Item                              Like(IMITEM)
     D  #Size                              Like(IMSIZE)
     D  #OnList        S               N   Inz(*Off)
      /Free
         Exec SQL
           Select '1'
           into   :#OnList
           from   FMORLS
           Where  OLITEM = :#Item
             and  OLSIZE = :#Size
           Fetch First Row Only ;
         Return #OnList;
      /End-Free
     P OnOrderList     E
