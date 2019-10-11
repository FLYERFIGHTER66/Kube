    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.      1995
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
      **PROGRAM NAME-------- BIR312
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT SYSTEM
      **APPLICATION--------- SUMMARY PICK SLIP BY ITEM NUMBER
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 6/13/00 EFD01  CHANGE OUTPUT LAYOUT
      * 8/17/00 EFD02  ADD LOGIC FOR FUTURE ORDER RELEASE
      *
      *
EFD02FFIORDRAS  UF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMINVTKP  IF   E           K DISK    RENAME(RMINVT:KPITEMS)
     FFMSIZE    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FWBIR312   UF A E           K DISK
     F*FMSTCRTS  UF A E           K DISK
     FFMSTCRTSDOUF A E           K DISK
     FFTRSCHDCO IF   E           K DISK
     FBIR312    O    F   80        PRINTER OFLIND(*INOF)
     FBIR312PF  O  A E             DISK    UsrOpn
     FFFINLOC02 IF   E           K DISK                                         ?Finished Locations
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
      *
     D                UDS
     D  LCONO                  1      2  0
     D  LCALL                  3      5
     D  LJOBQ                  6      6
     D  LP1ID                 17     24
     D  LP2ID                 27     34
     D  LDAPID                17     18
     D  LBEGDT                37     42  0
     D  LENDDT                43     48  0
     D  LSELEC                49     49  0
     D  LORDER                50     55  0
     D  LOALL                 56     58
     D  LPC1                  59     60
     D  LPC2                  61     62
     D  LRTE1                 63     64
     D  LRTE2                 65     66
     D  LPHY1                 67     67
     D  LPHY2                 68     68
     D  LPREV                 69     69
     D  LSHP1                 70     71
     D  LSHP2                 72     73
     D  LLOC1                 74     76
     D  LLOC2                 77     79
     D  LCANCL               133    133
     D  MASTERTYPE           999    999
     D  SHOWYN              1000   1000

     D* SaveOrder      S                   Like(OIORD#)
     D* SaveDate       S                   Like(OIRVDT)
     D ReportType      S             20A   Inz(' ')
     D Location        S              8A

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Center

     C                   ExSr      CLEAR312PF
      *
      *  GET DAY OF CENTURY
      *
     C                   If        SHOWYN = ' '
     C                   Eval      SHOWYN = 'N'
     C                   EndIf

      *        Report type, "Kube Pak Only", "Custom Only", or "Kube Pak and Custom"
     C                   Select
     C                   When      MasterType = 'A'
     C                   Eval      ReportType = $Center
     C                             ('Kube Pak and Custom':%Len(ReportType))
     C                   When      MasterType = 'K' or MasterType = ' '
     C                   Eval      ReportType = $Center
     C                             ('Kube Pak Only':%Len(ReportType))
     C                   When      MasterType = 'C'
     C                   Eval      ReportType = $Center
     C                             ('Custom Only':%Len(ReportType))
     C                   Other
     C                   Eval      ReportType = *Blanks
     C                   EndSl

     C                   Z-ADD     LBEGDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         BDATE             5 0
     C                   Z-ADD     LENDDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EDATE             5 0
     C                   Z-ADD     1             PSD               2 0
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     *ZEROS        KEY               2 0
     C     KEY           CHAIN     FMCOMP                             88
     C                   SETON                                        8990
      *
     C     LPC1          IFGT      *BLANKS
     C                   SETON                                        10
     C                   ENDIF
      *
     C     LRTE1         IFGT      *BLANKS
     C                   SETON                                        11
     C                   ENDIF
      *
     C     LORDER        IFGT      *ZEROS
     C                   SETON                                        12
     C                   ENDIF
      *
     C     LCONO         IFGT      *ZEROS
     C                   SETON                                        13
     C                   ENDIF
      *
     C     LPHY1         IFGT      *BLANKS
     C                   SETON                                        14
     C                   ENDIF
      *
     C     LSHP1         IFGT      *BLANKS
     C                   SETON                                        15
     C                   ENDIF
      *
     C     LLOC1         IFGT      *BLANKS
     C                   SETON                                        16
     C                   ENDIF
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

      *    If Master Type is 'A'        then Kube Pak & Custom
      *    If Master Type is 'K' or ' ' then Kube Pak Only
      *    If Master Type is 'C'        then Custom Only
     C     KEY18         SetLL     FMINVTKP
     C                   Select
     C                   When      MasterType = 'A'
     C                   When      MasterType = 'K' and %Equal(FMINVTKP)
     C                   When      MasterType = ' ' and %Equal(FMINVTKP)
     C                   When      MasterType = 'C' and not %Equal(FMINVTKP)
     C                   Other
     C                   GOTO      NXT
     C                   EndSl

     C     OIITYP        IFEQ      'S'
     C     OIITYP        OREQ      'F'
     C                   GOTO      NXT
     C                   ENDIF
EFD02 * IF CALLED BY FUTURE ORDER REL ONLY PRINT THEM
EFD02C     LCALL         IFEQ      'FUT'
EFD02C     OIRQTY        ANDLE     0
EFD02C                   GOTO      NXT
EFD02C                   ENDIF
EFD02C     LCALL         IFEQ      'FUT'
EFD02C     OINPSL        ANDNE     'Y'
EFD02C                   GOTO      NXT
EFD02C                   ENDIF
      *
      *  GET DAY OF CENTURY
      *
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RSHDT             5 0
     C     RSHDT         IFLT      BDATE
     C     RSHDT         ORGT      EDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   10OIPRCL        IFLT      LPC1
     C     OIPRCL        ORGT      LPC2
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   11OIROUT        IFLT      LRTE1
     C     OIROUT        ORGT      LRTE2
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   12OIORD#        IFNE      LORDER
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   13OICOMP        IFNE      LCONO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   16OIWHSE        IFLT      LLOC1
     C     OIWHSE        ORGT      LLOC2
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
     C   14OHPHYT        IFLT      LPHY1
     C     OHPHYT        ORGT      LPHY2
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   15OHSHPC        IFLT      LSHP1
     C     OHSHPC        ORGT      LSHP2
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OHSTAT        IFEQ      'D'
     C     OHCOFL        OREQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   MOVEL     OHNAME        SHNAME           20
      *
WJB  C*                  If        SaveOrder <> OIORD# or
WJB  C*                            SaveDate  <> OIRVDT
WJB  C*                  Eval      SaveOrder =  OIORD#
WJB  C*                  Eval      SaveDate  =  OIRVDT
WJB  C*    CARTKY        SetLL     FMSTCRTS
WJB  C*    CARTKY        Chain     FMSTCRTS
WJB  C     CARTKY        Chain     FMSTCRTSDO
WJB  C     CARTKY        KList
WJB  C                   KFld                    OIRVDT
WJB  C                   KFld                    OIORD#
WJB  C*                  If        not %Equal(FMSTCRTS)
WJB  C                   Call      'BIR103CL'
WJB  C                   PARM                    OIDTRQ
WJB  C                   PARM                    OIORD#
WJB  C                   PARM                    QTCART            5 2
WJB  C                   PARM                    SHOWYN
WJB  C                   PARM                    CART01
WJB  C                   PARM                    CART02
WJB  C                   PARM                    CART03
WJB  C                   PARM                    CART04
WJB  C                   PARM                    CART05
WJB  C                   PARM                    CART06
WJB  C                   PARM                    CART07
WJB  C                   PARM                    CART08
WJB  C                   PARM                    CART09
WJB  C                   PARM                    CART10
WJB  C                   PARM                    CART11
WJB  C                   PARM                    CART12
WJB  C                   PARM                    CART13
WJB  C                   PARM                    CART14
WJB  C                   PARM                    CART15
WJB  C                   Eval      TRTRK# = *Blanks
WJB  C                   Eval      TRSTOP = *Zeros
WJB  C     TruckKey      Chain     FTRSCHDCO
WJB  C     TruckKey      KList
WJB  C                   KFld                    OIRVDT
WJB  C                   KFld                    OICUST
WJB  C                   KFld                    OIORD#
     C                   If        not %Found(FTRSCHDCO)
WJB  C     TruckKey2     Chain     FTRSCHDCO
     C                   EndIf
WJB  C     TruckKey2     KList
WJB  C                   KFld                    OIRVDT
WJB  C                   KFld                    OICUST
WJB  C*                  If        not %Found(FMSTCRTS)
WJB  C                   If        not %Found(FMSTCRTSDO)
WJB  C                   WRITE     RMSTCRTS
WJB  C                   Else
WJB  C* N99              UPDATE    RMSTCRTS
WJB  C                   UPDATE    RMSTCRTS
WJB  C                   EndIf
     C   55OIITEM        IFNE      OITEM
     C     OISIZE        ORNE      OSIZE
     C                   Z-ADD     1             PSD
     C                   Eval      PAGE# = PAGE
     C                   Write     BIR312R
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
    ?C     LocationKey   Chain     FFINLOC02
    ?C     LocationKey   KList
    ?C                   KFld                    OIITEM
    ?C                   KFld                    OISIZE
     C                   If        %Found(FFINLOC02)
     C                   Eval      Location = %Trim(%EditC(FLSECT:'Z')) + '-' +
     C                                        %Trim(%EditC(FLBAY :'Z')) +
     C                                        FLNORS + FLEORW
     C                   Else
     C                   Eval      Location = *Blanks
     C                   EndIf
      *
     C                   MOVEL     OIITEM        OITEM            12
     C                   MOVEL     OISIZE        OSIZE             3
     C     OISIZE        CHAIN     FMSIZE                             90
     C                   MOVEL     SZDESC        SZDES            10
     C                   MOVEL     IMPUOM        OUOM              2
EFD01C                   MOVEL     DESP          ODESC            32
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
     C                   ADD       QTYOPN        TOTQTY0           5 0
     C                   ADD       QTYOPN        FTOT             11 1
EFD02C     LCALL         IFEQ      'FUT'
EFD02C                   MOVEL     'N'           OINPSL
EFD02C                   UPDATE    RIORDR
EFD02C                   END
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
EFD01C                   MOVEL     DESCO         DESP             32
     C                   ENDSR
      ********************************************************************@DT@B1
      *? ......................................................................
      *? :      CLEAR312PF    Clear this Date in BIR312PF                     :
      *? :....................................................................:
    ?C     CLEAR312PF    BegSr
     C                   If        %Open(BIR312PF)
     C                   Close     BIR312PF
     C                   EndIf
    ?c/exec sql
    ?c+                  DELETE    FROM          BIR312PF
    ?c/end-exec
     C                   If        not %Open(BIR312PF)
     C                   Open      BIR312PF
     C                   EndIf
    ?C                   EndSr
      ********************************************************************@DT@B1
      *
     OBIR312    E            HDG              02
     O                                           80 'Kube-Pak - Allentown, NJ'
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
     O          E            HDG            1
     O                                            5 'From:'
     O                       LBEGDT        Y     14
     O                                           18 'To:'
     O                       LENDDT        Y     27
     O                                           71 'Prod Class:'
     O                       LPC1                74
     O                                           77 'To'
     O                       LPC2                80
     O          E            HDG            1
     O                       ReportType          50
     O          E            HDG            1
     O                                           19 'Size /'
     O          E            HDG            1
     O                                            4 'Item'
     O                                           29 '/Description'
     O                                           38 'Quantity'
     O                                           55 'Item Description'
     O                                           80 'Location'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           80 '________'
     O          E            TL1         1  1
     O                       TOTQTY0       4B    39
     O                       OITEM               12
     O                       OSIZE               16
     O                                           18 '-'
     O                       SZDESC              29
     O                       OUOM                32
     O                       ODESC               73
     O                       LOCATION            80
     O          E            TLR         1  2
     O                       FTOT          4B    44
