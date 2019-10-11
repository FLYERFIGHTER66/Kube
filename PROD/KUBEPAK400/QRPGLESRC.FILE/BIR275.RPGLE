      **PROGRAM NAME-------- BIR275
      **APPLICATION--------- CREDIT MEMO ENTRY
      *
      * RESERVED IORDR SEQ #
      * 001 - TAG ORDER NUMBER
      * 994 - DEPOSIT/DOWN PAYMENT
      * 995 - FREIGHT/DELIVERY CHARGE
      * 996 - CASH AND CARRY DISCOUNT
      * 997 - PACKING CHARGE
      * 998 - PHYTO CHARGE.
      * 999 - PHYTO CERTIFICATE REQUIRED.
      *
      *            CHANGE--DATE-------DESCRIPTION
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      *?SUD01   06/18/19   S.Uthaya     Added Function Key F4 to get Invoice
      *?                                by Order
      //--------------------------------------------------------------------
     FBIR275FM  CF   E             WORKSTN
     F                                     SFILE(TAXSFL:RECNT)
     F                                     SFILE(DLVSFL:RECND)
     F                                     SFILE(ORDSFL:RECNO)
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFMSLSM    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FFMTAXF    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFOECTL    UF   E           K DISK
     FFCMREAS   IF   E           K DISK
     FFHORCWI   IF   E           K DISK
     FFHORCR    UF A E           K DISK
     FFIORCR    UF A E           K DISK
     FFHORDW    IF   E           K DISK
     FFIORDW    IF   E           K DISK
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(5) CTDATA PERRCD(1)
      * ADDRESS ARRAYS
     D #SL             S             32    DIM(5)
     D #SH             S             32    DIM(5)
      * SCREEN E ARRAYS
     D CRD             S              6  0 DIM(10)                              CREDIT #
     D CDT             S              6  0 DIM(10)                              CREDIT DATE
     D CAM             S             11  2 DIM(10)                              CREDIT AMT
      *
SUD01 /Free
  |   *?Procedure Prototype Declaration : WSSNDFTPC
  |     Dcl-Pr LKORDINV01 ExtPgm('LKORDINV01');
  |        POrder#   Packed(6:0);
  |        PInvoice  Packed(6:0);
  |     End-Pr;
  |   *
  |     Dcl-S POrder#   Packed(6:0);
  |     Dcl-S PInvoice  Packed(6:0);
SUD01 /End-Free
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10
      ** RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      ** SOURCE LIBRARY
     D  SLIBR                314    323
      ****************
      *   LDA        *
      ****************
     D                UDS
      ** COMPANY
     D  LCO                    1      2  0
      ** REPRINT Y/N
     D  LDARPT                 3      3
      ** BEGINING CREDIT NUMBER
     D  LBCRM                  4      9  0
      ** ENDING CREDIT NUMBER
     D  LECRM                 10     15  0
      ** CREDIT MEMO DATE
     D  LDATE                 16     21  0
      ** CREDIT MEMO END DATE
     D  LENDT                 22     27  0
      ** SHIP FROM LOCATION
     D  LSHFR                 28     30
      ** IMMEDIATE PRINT Y/N
     D  LIMED                 31     31
      ** BILL TO CUSTOMER
     D  LBLCS                 32     37  0
      ** SHIP TO CUSTOMER
     D  LSHCS                 38     43  0
      ** LAST INVOICE CREDITED
     D  LBINV                 44     49  0
      ** PRINTER ID
     D  LPRTR                100    109
      ** FORMS NUMBER
     D  LFORM                110    113
      ** NUMBER OF COPIES
     D  LCOPY                114    115  0
      ** JOBQ
     D  LJOB                 116    116
      ** HOLD PRINT OUTPUT
     D  LHOLD                117    120
      ** PRINT AND SAVE OUTPUT
     D  LSAVE                121    124
      ** CANCEL  X=CANCEL
     D  LCANCL               133    133
      *
     IRHORDW
     I              WHNAME                      #WSHP1
     I              WHSHP2                      #WSHP2
     I              WHSHP3                      #WSHP3
     I              WHSHP4                      #WSHP4
     I              WHSHCT                      #WSHCT
     I              WHSHST                      #WSHST
     I              WHSHZP                      #WSHZP
      *
     IRMCUST
     I              CMNAME                      #WSLD1
     I              CMADD2                      #WSLD2
     I              CMADD3                      #WSLD3
     I              CMADD4                      #WSLD4
     I              CMCITY                      #WSLCT
     I              CMSTST                      #WSLST
     I              CMZIP                       #WSLZP
      *
     IRHORCR
     I              OHNAME                      #WSHP1
     I              OHSHP2                      #WSHP2
     I              OHSHP3                      #WSHP3
     I              OHSHP4                      #WSHP4
     I              OHSHCT                      #WSHCT
     I              OHSHST                      #WSHST
     I              OHSHZP                      #WSHZP
     IRMWHSE
     I              WHUSER                      WUSER
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     0             VBCUST
     C                   Z-ADD     0             VINV
     C                   Z-ADD     0             VCRM
SUD01C                   Z-ADD     0             VOrder#
     C                   Z-ADD     01            VCO
     C                   SETOFF                                       77
     C                   MOVE      *BLANKS       TYPE
     C     LBINV         IFLE      0
     C                   Z-ADD     0             LBINV
     C                   END
     C     LBCRM         IFLE      0
     C                   Z-ADD     0             LBCRM
     C                   END
     C                   MOVE      *BLANKS       VBALPH
     C                   MOVE      *BLANKS       VBNAME
     C                   MOVEA     '0'           *IN
     C     NXTA          TAG
     C     TYPE          IFEQ      'CM'
     C                   SETON                                        77
     C                   END
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C   77              GOTO      RSTART
      ** COMMAND KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       101117
     C                   SETOFF                                       203040
     C                   SETOFF                                       272829
     C                   SETOFF                                       262199
     C                   SETOFF                                       7118
SUD01C                   SETOFF                                       6061
      *** CHECK ACTION CODE
     C     VACT          IFNE      'A'
     C     VACT          ANDNE     'C'
     C     VACT          ANDNE     'D'
     C                   SETON                                        1099
     C                   GOTO      NXTA
     C                   END
      ** IF ACTION CODE = A NO CREDIT MEMO NUMBER ALLOWED
     C     VACT          IFEQ      'A'
     C     VCRM          IFGT      0
     C                   SETON                                        282999
     C                   GOTO      NXTA
     C                   END
     C                   ELSE
     C     VCRM          IFLE      0
     C                   SETON                                        2899
     C                   GOTO      NXTA
     C                   END
     C                   END
      ** GET MODE
     C     VACT          IFEQ      'A'
     C                   MOVEL     ' Add  '      VMODE
     C                   END
     C     VACT          IFEQ      'C'
     C                   MOVEL     'Change'      VMODE
     C                   END
     C     VACT          IFEQ      'D'
     C                   MOVEL     'Delete'      VMODE
     C                   END
      *
      *** CHECK IF CHANGE OR DELETE
     C     VACT          IFNE      'A'
     C                   EXSR      GETOLD
     C   99              GOTO      NXTA
     C     VACT          IFEQ      'D'
     C                   EXSR      DEL
     C                   GOTO      RSTART
     C                   END
     C                   GOTO      NXTB
     C                   END
      *
      *  BILL TO CUSTOMER ALPHA SEARCH
      *
     C     VBALPH        IFGT      *BLANKS
     C                   MOVEL     VBALPH        CMLOOK           15
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       VBALPH
     C                   MOVEL     *BLANKS       VBTELE
     C                   Z-ADD     CMCUST        VBCUST
     C                   MOVEL     CMNAME        VBNAME
     C                   GOTO      NXTA
     C                   ENDIF
      *
      *  SHIP TO TELEPHONE # SEARCH
      *
     C     VBTELE        IFGT      *BLANKS
     C                   MOVEL     VBTELE        CMPHON           10 0
     C                   CALL      'LKTELE'
     C                   PARM                    CMPHON
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       VBTELE
     C                   MOVEL     *BLANKS       VBALPH
     C                   Z-ADD     CMCUST        VBCUST
     C                   MOVEL     CMNAME        VBNAME
     C                   GOTO      NXTA
     C                   ENDIF
      *
      **** BOTH FIELDS BLANK ON OTHER THAN ADD
      *
     C     VBCUST        IFLE      0
     C     VBALPH        ANDEQ     *BLANKS
     C     VBTELE        ANDEQ     *BLANKS
     C     VACT          ANDNE     'A'
     C     VCRM          ANDLE     0
     C                   SETON                                        1117
     C                   GOTO      NXTA
     C                   ENDIF
      *
      *  CHECK BILL TO CUSTOMER NUMBER
      *
     C     KEY6          KLIST
     C                   KFLD                    VBCUST
     C     KEY6          CHAIN(N)  FMCUST                             90
     C   90              SETON                                        11
     C  N90CMSTAT        IFEQ      'D'
     C                   SETON                                        11
     C                   GOTO      NXTA
     C                   ENDIF
     C  N90CMCTYP        IFEQ      'XX'
     C                   SETON                                        1171
     C                   GOTO      NXTA
     C                   ENDIF
      ** NOW CHECK INVOICE NUMBER
     C   KB              DO
     C                   Z-ADD     VBCUST        WHBLCU
     C                   Z-ADD     VCO           WHCOMP
     C                   MOVE      *BLANKS       TYPE
     C                   CALL      'LKCINV'
     C                   PARM                    WHBLCU            6 0
     C                   PARM                    WHCOMP            2 0
     C                   PARM                    WHINV#            6 0
     C                   PARM                    TYPE              2
     C                   MOVEL     WHINV#        VINV
     C                   GOTO      NXTA
     C                   ENDDO
SUD01 *?Prompt Function Key F4 - Invoice By Order
  |   /Free
  |       If *InKD = *On;
  |          If VOrder# <> *Zeros;
  |             LKORDINV01(VOrder#:PInvoice);
  |             VINV = PInvoice;
  |             *In60 = *Off;
  |             *In61 = *Off;
  |          Else;
  |             *In60 = *On;
  |             *In61 = *On;
  |          Endif;
  |   /End-Free
  |  C                   GOTO      NXTA
  |   /Free
  |       Else;
  |          *In60 = *Off;
  |          *In61 = *Off;
  |       Endif;
SUD01 /End-Free
      ** CHECK FOR ITEM SEARCH
     C   KE              DO
     C                   EXSR      GETITM
     C                   GOTO      NXTA
     C                   ENDDO
      *
      *
     C     VINV          IFEQ      *ZEROS
     C     VACT          ANDEQ     'A'
     C                   SETON                                        20
     C   20              GOTO      NXTA
     C                   ENDIF
      *
      *  CHECK IF RECORD EXISTS IN FHORDW
      *
     C     VINV          CHAIN(N)  FHORDW                             92
     C   92              SETON                                        2099
     C  N20DESHFR        IFGT      *BLANKS
     C     WHSHFR        ANDNE     DESHFR
     C                   SETON                                        202199
     C                   ENDIF
     C  N20VBCUST        IFNE      WHARCU
     C                   SETON                                        111899
     C                   END
     C  N20              Z-ADD     WHINDT        INDT              6 0
     C  N20              Z-ADD     WH$AMT        INTOT            11 2
     C   99              GOTO      NXTA
      ** GET PRIOR CREDIT MEMO INFO
     C                   EXSR      GETCRD
     C   99              DO
     C                   SETOFF                                       99
     C                   GOTO      RSTART
     C                   ENDDO
      ** GET INVOICE INFO
     C                   EXSR      LOADB
      ** SETUP NOT RETURN FROM NEXT SCREEN
     C                   Z-ADD     0             PRIOR             1 0
      ** PROTECT REASON CODE IF TAX OR DELIVERY
     C     OHREAS        IFEQ      'DLV'
     C     OHREAS        OREQ      'TAX'
     C                   SETON                                        57        PROT REAS CD
     C                   ELSE
     C                   SETOFF                                       57
     C                   END
      *******************
      **  SCREEN B
      *******************
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C                   SETOFF                                       27
     C   KFPRIOR         IFGT      0
     C                   SETON                                        27
     C                   GOTO      NXTB
     C                   ELSE
     C                   GOTO      RSTART
     C                   END
     C                   SETOFF                                       242526
      ** CHECK REASON CODE
     C                   MOVEL     OHREAS        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      OHREAS        TST2              2
     C                   MOVE      *BLANKS       CRREAS
     C                   MOVEL     TST2          CRREAS
     C                   Z-ADD     LCO           CO                2 0
     C                   CALL      'LKREAS'
     C                   PARM                    CO
     C                   PARM                    CRREAS
     C                   PARM                    CRDESC
     C                   MOVEL     *BLANKS       OHREAS
     C                   MOVEL     CRREAS        OHREAS
     C                   GOTO      NXTB
     C                   ENDIF
     C                   SETOFF                                       2728
     C     REAKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    OHREAS
     C     REAKEY        CHAIN     FCMREAS                            26
     C   26              MOVE      *BLANKS       CRDESC
     C  N26OHREAS        IFEQ      'TAX'
     C     WHTAX$        ANDLE     0
     C                   SETON                                        2627
     C                   ENDIF
     C  N26OHREAS        IFEQ      'DLV'
     C     WHFRT$        ANDLE     0
     C                   SETON                                        2628
     C                   ENDIF
     C   26              GOTO      NXTB
      ** CHECK CR DATE
     C     OHDTOR        IFLE      0
     C                   SETON                                        24
     C                   GOTO      NXTB
     C                   END
     C                   Z-ADD     OHDTOR        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        24
     C                   GOTO      NXTB
     C                   END
     C                   Z-ADD     ##CYMD        OHORDY
     C     ##CYMD        IFLT      TODAY
     C                   SETON                                        2425
     C                   GOTO      NXTB
     C                   END
      ** CHECK PRICE CODE
     C                   SETOFF                                       30
     C     OHPRCD        IFLT      1
     C     OHPRCD        ORGT      5
     C                   SETON                                        30
     C                   GOTO      NXTB
     C                   END
      ** CHECK TERMS CODE
     C                   SETOFF                                       31
     C                   MOVEL     OHTMCD        TST1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     OHTMCD        TCTERM
     C                   CALL      'LKTERM'
     C                   PARM                    TCTERM
     C                   PARM                    TCDESC
     C                   MOVEL     TCTERM        OHTMCD
     C                   SETON                                        99
     C                   GOTO      NXTB
     C                   ENDIF
     C     OHTMCD        CHAIN     FMTERM                             31
     C   31              GOTO      NXTB
      ** CHECK TAX EXEMPT
     C                   SETOFF                                       35
     C     OHTXST        IFNE      'N'
     C     OHTXST        ANDNE     'Y'
     C                   SETON                                        35
     C                   GOTO      NXTB
     C                   END
      ** CHECK TAX JURIS.
     C                   SETOFF                                       40
     C                   MOVEL     OHTXJU        TST1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      OHTXJU        TST2
     C                   MOVE      *BLANKS       TXTXJU
     C                   MOVEL     TST2          TXTXJU
     C                   CALL      'LKTAXJ'
     C                   PARM                    TXTXJU
     C                   PARM                    TXJUNM
     C                   MOVEL     *BLANKS       OHTXJU
     C                   MOVEL     TXTXJU        OHTXJU
     C                   GOTO      NXTB
     C                   ENDIF
     C     OHTXJU        CHAIN     FMTAXF                             40
     C   40              GOTO      NXTB
      ** CHECK TAX FREIGHT
     C                   SETOFF                                       45
     C     OHFRTX        IFNE      'N'
     C     OHFRTX        ANDNE     'Y'
     C                   SETON                                        45
     C                   GOTO      NXTB
     C                   END
      ** CHECK TAX SPECIAL CHARGES
     C                   SETOFF                                       46
     C     OHSPTX        IFNE      'N'
     C     OHSPTX        ANDNE     'Y'
     C                   SETON                                        46
     C                   GOTO      NXTB
     C                   END
      ** CHECK AFFECT INVENTORY
     C                   SETOFF                                       47
     C     OHAFIV        IFNE      'N'
     C     OHAFIV        ANDNE     'Y'
     C                   SETON                                        47
     C                   GOTO      NXTB
     C                   END
      ** CHECK AFFECT S/A
     C                   SETOFF                                       48
     C     OHAFSL        IFNE      'N'
     C     OHAFSL        ANDNE     'Y'
     C                   SETON                                        48
     C                   GOTO      NXTB
     C                   END
      ** CHECK AUTO SPREAD
     C                   SETOFF                                       49
     C     OHPOS         IFNE      'N'
     C     OHPOS         ANDNE     'Y'
     C                   SETON                                        49
     C                   GOTO      NXTB
     C                   END
     C                   Z-ADD     VINV          LBINV
     C                   Z-ADD     OHCRM#        LBCRM
      ** IF HERE ALL OK WRITE HEADER
     C     VACT          IFEQ      'A'
     C     PRIOR         ANDLE     0
     C                   WRITE     RHORCR
     C                   ELSE
     C                   UPDATE    RHORCR
     C                   END
      ** DECIDE WHERE TO GO
     C     OHREAS        IFEQ      'TAX'
     C                   EXSR      CRMTAX
     C                   GOTO      RSTART
     C                   END
     C     OHREAS        IFEQ      'DLV'
     C                   EXSR      CRMDLV
     C                   GOTO      RSTART
     C                   END
     C     PRIOR         IFGT      0
     C                   GOTO      NXTC
     C                   END
      *** DISPLAY CREDIT MEMO SUB FILE
     C     RSTRTC        TAG
     C                   EXSR      BLDSFL
     C     NXTC          TAG
     C                   Z-ADD     0             PRIOR
     C                   EXFMT     ORDCTL
      *** DELETE CREDIT MEMO
     C   KX              DO
     C     NONDL         TAG
     C                   SETON                                        98
     C                   EXFMT     ORDCTL
     C   KF              DO
     C                   SETOFF                                       98
     C                   GOTO      NXTC
     C                   ENDDO
     C  NKX              GOTO      NONDL
     C                   EXSR      DELET
     C                   GOTO      RSTART
     C                   ENDDO
      *** RESTART ORDSFL
     C   KF              GOTO      RSTRTC
      *** PREVIOUS SCREEN
     C   KL              DO
     C                   Z-ADD     1             PRIOR
     C     VCRM          CHAIN     FHORCR                             27
     C                   GOTO      NXTB
     C                   ENDDO
      *** CREDIT ENTIRE INVOICE
     C   KA              DO
     C                   EXSR      CRDALL
     C                   GOTO      NXTC
     C                   ENDDO
      *** UN-CREDIT ENTIRE INVOICE
     C   KY              DO
     C                   EXSR      UNCALL
     C                   GOTO      NXTC
     C                   ENDDO
      ** NOW CHECK SUB FILE
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTC
      *** CALC RESTOCKING CHARGE
     C   KH              DO
     C                   ADD       RESTCK        CRMTOT
     C     MRCH$         MULT(H)   .15           RESTCK
     C                   SUB       RESTCK        CRMTOT
     C                   GOTO      NXTC
     C                   ENDDO
      *** CALC TAX
     C   KI              DO
     C                   SUB       TAX$          CRMTOT
     C     WHDISC        DIV(H)    100           WKDIS             5 4
     C     DISTX         MULT(H)   WHDIS$        DTLFT             9 2
     C     TXAMT         SUB       DTLFT         TXBASE            9 2
     C     TXBASE        MULT(H)   .07           TAX$
     C     TAX$          IFGT      WHTAX$
     C                   Z-ADD     WHTAX$        TAX$
     C                   END
     C                   Z-SUB     TAX$          OHTAX$
     C                   ADD       TAX$          CRMTOT
     C                   GOTO      NXTC
     C                   ENDDO
      ** IF NEW SELECTED OUTPUT CREDIT MEMO
     C   KB              DO
     C                   EXSR      PUTSFL
     C                   GOTO      RSTART
     C                   ENDDO
      **
     C                   GOTO      NXTC
      *****
      * END
      *****
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** GET PRIOR CREDITS **
      ***********************
     C     GETCRD        BEGSR
     C     OCRKEY        KLIST
     C                   KFLD                    WHBLCU
     C                   KFLD                    VINV
     C                   SETOFF                                       010203
     C                   SETOFF                                       040506
     C                   SETOFF                                       070809
     C                   SETOFF                                       101112
     C                   SETOFF                                       141516
     C                   SETOFF                                       171819
     C                   SETOFF                                       20  99
     C     OCRKEY        SETLL     FHORCWI
     C                   Z-ADD     0             CN                5 0
     C                   Z-ADD     0             CRT
     C                   Z-ADD     0             CRD
     C                   Z-ADD     0             CDT
     C                   Z-ADD     0             CAM
     C     NXTCRD        TAG
     C     OCRKEY        READE     FHORCWI                                90
     C   90              GOTO      ENDCRD
     C                   ADD       1             CN
     C     CN            IFLE      10
     C                   Z-ADD     CHCRM#        CRD(CN)
     C                   Z-ADD     CHDTOR        CDT(CN)
     C                   Z-ADD     CHTOT$        CAM(CN)
     C                   MOVEL     '1'           *IN(CN)
     C                   ENDIF
     C                   ADD       CHTOT$        CRT
     C                   GOTO      NXTCRD
     C     ENDCRD        TAG
     C     CN            IFLE      0
     C                   Z-ADD     INTOT         LEFTT
     C                   GOTO      ENCRD1
     C                   END
     C                   Z-ADD     CRD(1)        CRD1
     C                   Z-ADD     CRD(2)        CRD2
     C                   Z-ADD     CRD(3)        CRD3
     C                   Z-ADD     CRD(4)        CRD4
     C                   Z-ADD     CRD(5)        CRD5
     C                   Z-ADD     CRD(6)        CRD6
     C                   Z-ADD     CRD(7)        CRD7
     C                   Z-ADD     CRD(8)        CRD8
     C                   Z-ADD     CRD(9)        CRD9
     C                   Z-ADD     CRD(10)       CRD10
     C                   Z-ADD     CDT(1)        CDT1
     C                   Z-ADD     CDT(2)        CDT2
     C                   Z-ADD     CDT(3)        CDT3
     C                   Z-ADD     CDT(4)        CDT4
     C                   Z-ADD     CDT(5)        CDT5
     C                   Z-ADD     CDT(6)        CDT6
     C                   Z-ADD     CDT(7)        CDT7
     C                   Z-ADD     CDT(8)        CDT8
     C                   Z-ADD     CDT(9)        CDT9
     C                   Z-ADD     CDT(10)       CDT10
     C                   Z-ADD     CAM(1)        CAM1
     C                   Z-ADD     CAM(2)        CAM2
     C                   Z-ADD     CAM(3)        CAM3
     C                   Z-ADD     CAM(4)        CAM4
     C                   Z-ADD     CAM(5)        CAM5
     C                   Z-ADD     CAM(6)        CAM6
     C                   Z-ADD     CAM(7)        CAM7
     C                   Z-ADD     CAM(8)        CAM8
     C                   Z-ADD     CAM(9)        CAM9
     C                   Z-ADD     CAM(10)       CAM10
     C     CN            ADD       10            CI                2 0
     C                   MOVEL     '1'           *IN(CI)
     C     INTOT         ADD       CRT           LEFTT
     C     LEFTT         IFLE      0
     C                   SETON                                        99
     C                   END
     C                   WRITE     SCRNE
     C                   READ      SCRNE                                  90
     C                   SETOFF                                       010203
     C                   SETOFF                                       040506
     C                   SETOFF                                       070809
     C                   SETOFF                                       101112
     C                   SETOFF                                       141516
     C                   SETOFF                                       171819
     C                   SETOFF                                       20
     C     ENCRD1        ENDSR
      ***********************
      ** GET OLD CRM       **
      ***********************
     C     GETOLD        BEGSR
     C     VCRM          CHAIN     FHORCR                             27
     C   27              DO
     C                   SETON                                        2899
     C                   GOTO      ENDOLD
     C                   ENDDO
      ** CHECK FOR USER SHIP FROM
     C     DESHFR        IFGT      *BLANKS
     C     OHSHFR        ANDNE     DESHFR
     C                   SETON                                        262899
     C                   GOTO      ENDOLD
     C                   ENDIF
     C                   Z-ADD     OHAPNO        VINV
     C                   Z-ADD     OHCOMP        VCO
     C     OHAPNO        CHAIN     FHORDW                             2099
     C     REAKEY        CHAIN     FCMREAS                            91
     C     OHTMCD        CHAIN     FMTERM                             91
     C     OHSHFR        CHAIN     FMWHSE                             91
     C     OHSLM1        CHAIN     FMSLSM                             91
     C                   MOVEL     SMNAME        SNAME1
     C     OHSLM2        IFGT      *BLANKS
     C     OHSLM2        CHAIN     FMSLSM                             91
     C                   MOVEL     SMNAME        SNAME2
     C                   ENDIF
     C     OHBLCU        CHAIN     FMCUST                             91
      * GET ADDRESS
     C                   EXSR      #SLD
     C                   EXSR      #SHP
     C                   MOVEL     #WSLD1        OHSLD1
     C                   MOVEL     #WSLD2        OHSLD2
     C                   MOVEL     #WSLD3        OHSLD3
     C                   MOVEL     #WSLD4        OHSLD4
     C                   MOVEL     #WSLCT        OHSLCT
     C                   MOVEL     #WSLST        OHSLST
     C                   MOVEL     #WSLZP        OHSLZP
      *
     C     ENDOLD        TAG
     C                   ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        TODAY             7 0
     C                   MOVEL     ' '           LCANCL
     C     USERID        CHAIN     FMUSER                             90
     C   90              MOVEL     '999'         USDEPT
     C   90              MOVEL     '999'         WHSE
     C  N90              MOVEL     '   '         WHSE
     C     USDEPT        CHAIN     FMDEPT                             90
     C   90              MOVEL     'PRT01'       DEPINV
     C                   MOVEL     DEPINV        LPRTR
     C                   MOVEL     '*INV '       LFORM
     C                   MOVEL     '*NO  '       LHOLD
     C                   MOVEL     '*NO  '       LSAVE
     C                   ENDSR
      *
      *  ***********
      *  * LOADB   * GET INFO FROM INVOICE RECORD INTO SCREEN B
      *  ***********
     C     LOADB         BEGSR
     C                   Z-ADD     VINV          OHAPNO
     C                   MOVE      *BLANKS       OHREAS
     C                   MOVE      *BLANKS       CRDESC
     C                   MOVEL     WHTMCD        OHTMCD
     C     OHTMCD        CHAIN     FMTERM                             91
     C                   MOVEL     WHSHFR        OHSHFR
     C     OHSHFR        CHAIN     FMWHSE                             91
     C                   MOVEL     WHSLM1        OHSLM1
     C     OHSLM1        CHAIN     FMSLSM                             91
     C                   MOVEL     SMNAME        SNAME1
     C                   MOVEL     WHSLM2        OHSLM2
     C     OHSLM2        IFGT      *BLANKS
     C     OHSLM2        CHAIN     FMSLSM                             91
     C                   MOVEL     SMNAME        SNAME2
     C                   ENDIF
     C                   Z-ADD     WHBLCU        OHBLCU
     C                   Z-ADD     WHARCU        OHARCU
     C                   Z-ADD     WHSACU        OHSACU
     C                   Z-ADD     WHCUST        OHCUST
     C     OHBLCU        CHAIN     FMCUST                             91
      * GET ADDRESS
     C                   EXSR      #SLD
     C                   EXSR      #SHP
     C                   MOVEL     #WSLD1        OHSLD1
     C                   MOVEL     #WSLD2        OHSLD2
     C                   MOVEL     #WSLD3        OHSLD3
     C                   MOVEL     #WSLD4        OHSLD4
     C                   MOVEL     #WSLCT        OHSLCT
     C                   MOVEL     #WSLST        OHSLST
     C                   MOVEL     #WSLZP        OHSLZP
      ** GET REST OF HEADER FIELDS
     C                   Z-ADD     0             OCCOMP
     C     OCCOMP        CHAIN     FOECTL                             91
     C                   Z-ADD     OCNCMN        OHCRM#
     C                   Z-ADD     OCNCMN        VCRM
     C                   ADD       1             OCNCMN
     C  N91              UPDATE    ROECTL
     C                   MOVEL     'A'           OHSTAT
     C                   Z-ADD     VCO           OHCOMP
     C                   Z-ADD     WHINDT        OHINDT
     C***                  Z-ADDWHINDT    OHDTOR
     C                   MOVE      *BLANKS       OHCOMM
     C                   MOVE      WHPONO        OHPONO
     C**                   MOVELWHPOS     OHPOS
     C                   MOVEL     WHSALE        OHSALE
     C                   Z-ADD     WHDISC        OHCCDS
     C**                   MOVELWHCANC    OHCANC
     C                   MOVEL     WHALPH        OHALPH
     C                   MOVEL     WHROUT        OHROUT
     C                   MOVEL     WHSTOP        OHSTOP
     C                   MOVEL     WHTXID        OHTXID
     C                   MOVEL     WHSPTX        OHSPTX
     C                   MOVEL     WHFRTX        OHFRTX
     C                   MOVEL     WHTXST        OHTXST
     C                   MOVEL     WHTXJU        OHTXJU
     C                   Z-ADD     WHTDAS        OHTDAS
     C                   Z-ADD     WHTRDC        OHTRDC
     C                   Z-ADD     WHPRCD        OHPRCD
     C     OHPRCD        IFLT      1
     C     OHPRCD        ORGT      5
     C                   Z-ADD     1             OHPRCD
     C                   END
     C                   MOVEL     USERID        OHUSER
     C                   Z-ADD     TIMOD         OHTIME
     C                   Z-ADD     TDATE         OHDTLA
     C                   Z-ADD     TDATE         OHTDAT
     C                   MOVE      *BLANKS       OHAFIV
     C                   MOVEL     'Y'           OHAFSL
     C                   MOVEL     'Y'           OHPOS                          USE FOR SPRD
     C                   Z-ADD     0             OHTOT$
     C                   Z-ADD     0             OHTAX$
     C                   Z-ADD     0             OHMIS$
     C                   Z-ADD     0             OHDIS$
     C                   Z-ADD     0             OHMER$
     C                   Z-ADD     0             ROY$              9 2
     C                   Z-ADD     0             OHFRT$
     C                   MOVEL     WHSLM1        OHSLM1
     C                   Z-ADD     WHSCM1        OHSCM1
     C                   MOVEL     WHSLM2        OHSLM2
     C                   Z-ADD     WHSCM2        OHSCM2
     C                   MOVEL     WHTYPE        OHTYPE
     C                   Z-ADD     0             OHAMT1
     C                   Z-ADD     0             OHAMT2
     C                   Z-ADD     0             OHAMT3
     C                   Z-ADD     WHTDAY        OHTDAY
     C                   Z-ADD     WHTRAT        OHTRAT
     C                   MOVEL     WHTERM        OHTERM
     C                   Z-ADD     TDATE         OHDTOR
     C                   MOVEL     'CM'          OHAPSF
     C                   ENDSR
      *
      *
      *  ***********
      *  * DEL     *
      *  ***********
     C     DEL           BEGSR
     C     NXTDEL        TAG
     C                   WRITE     SCRNBD
     C                   READ      SCRNBD                                 90
      ** K6 RESTART NO DELETE
     C   KF              GOTO      ENDDE
      ** K23 DELETE
     C  NKX              GOTO      NXTDEL
     C                   EXSR      DELET
     C     ENDDE         ENDSR
      ****************
      * DELETE ENTIRE CREDIT MEMO
      ***************************
     C     DELET         BEGSR
     C     VCRM          CHAIN     FHORCR                             50
     C     VCRM          SETLL     FIORCR
     C     NXTDI         TAG
     C     VCRM          READE     FIORCR                                 90
     C   90              GOTO      ENDDI
     C                   DELETE    RIORCR
     C                   GOTO      NXTDI
     C     ENDDI         TAG
     C  N50              DELETE    RHORCR
     C     ENDDEL        TAG
     C                   ENDSR
      *
      *  ***********
      *  * CRMTAX  * GET TAX ONLY CREDIT
      *  ***********
     C     CRMTAX        BEGSR
     C     RSTCRX        TAG
     C                   EXSR      BLDTAX
     C     NXTCRX        TAG
     C                   EXFMT     TAXCTL
     C   KF              GOTO      RSTCRX
      *** DELETE CREDIT MEMO
     C   KX              DO
     C     TAXDL         TAG
     C                   SETON                                        98
     C                   EXFMT     TAXCTL
     C   KF              DO
     C                   SETOFF                                       98
     C                   GOTO      NXTCRX
     C                   ENDDO
     C  NKX              GOTO      TAXDL
     C                   EXSR      DELET
     C                   GOTO      ENDTAX
     C                   ENDDO
      ** CHECK INPUT
     C                   EXSR      CHKTAX
     C   99              GOTO      NXTCRX
      ** IF F2 OUTPUT CREDIT MEMO
     C   KB              DO
     C                   EXSR      PUTTAX
     C                   GOTO      ENDTAX
     C                   ENDDO
     C                   GOTO      NXTCRX
     C     ENDTAX        ENDSR
      *
      *  ***********
      *  * BLDSFL  * BUILD SUB FILE FOR CREDIT
      *  ***********
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     ORDCTL
     C                   SETOFF                                       8098
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             LSTSEQ            3 0
     C                   Z-ADD     0             RESTCK
     C                   Z-ADD     0             CANDC             9 2
     C                   Z-ADD     0             CACSEQ            3 0
     C                   Z-SUB     OHTAX$        TAX$
     C                   Z-SUB     OHFRT$        FRT$
     C     TAX$          ADD       FRT$          CRMTOT
     C     OHAPNO        SETLL     FIORDW
     C     NXTBLD        TAG
     C     OHAPNO        READE(N)  FIORDW                                 90
     C   90              GOTO      ENDBLD
      ** FREIGHT TAKEN CARE OF ABOVE.
     C     WIITYP        IFEQ      'F'
     C     WIITYP        OREQ      'C'
     C                   GOTO      NXTBLD
     C                   END
     C                   ADD       1             RECNO
     C                   Z-ADD     WIQINV        QTYINV
     C                   MOVEL     WIDES1        DESO
     C                   MOVEL     WIDES2        DESC20           20
     C                   MOVE      DESC20        DESO
     C                   Z-ADD     WISEQ#        OISEQ#
     C                   SETOFF                                       58
      ** 996 IS ALWAYS C & C
     C     WISEQ#        IFEQ      996
     C                   Z-ADD     WIAMT         CANDC
     C                   Z-ADD     WISEQ#        CACSEQ
     C                   SETON                                        58
     C                   END
     C     OITM          KLIST
     C                   KFLD                    WIITEM
     C                   KFLD                    WISIZE
     C                   KFLD                    WIWHSE
     C     WIITYP        IFEQ      ' '
     C     OITM          CHAIN     FMINVT                             92
     C                   END
     C     WIITYP        IFEQ      'S'
     C                   MOVEL     OHSPTX        IMTXBL
     C                   END
     C     WIITYP        IFEQ      'F'
     C                   MOVEL     OHFRTX        IMTXBL
     C                   END
     C     OICKEY        CHAIN(N)  FIORCR                             91
     C   91              DO
     C                   MOVE      *BLANKS       OIRSCD
     C                   MOVE      *BLANKS       REASDC
     C                   Z-ADD     0             QTYCRD
     C                   Z-ADD     0             OIUPRI
     C                   Z-ADD     0             EXT$
     C                   ENDDO
     C  N91              DO
     C     REAKY1        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    OIRSCD
     C     REAKY1        CHAIN     FCMREAS                            92
     C                   MOVEL     CRDESC        REASDC
     C                   Z-SUB     OIQCRD        QTYCRD
     C                   Z-SUB     OIEXT$        EXT$
     C                   ADD       EXT$          CRMTOT
     C                   ENDDO
     C                   MOVEL     IMLOOK        TST1              1
      ** CHECK IF CASH AND CARRY ALLOWED
     C     IMORDD        IFEQ      'N'
     C                   MOVEL     'N'           ALCAC
     C                   GOTO      SKPC
     C                   END
     C     SKPC          TAG
     C                   WRITE     ORDSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC
     C     RECNO         IFLE      0
     C                   ADD       1             RECNO
     C                   WRITE     ORDSFL
     C                   END
     C                   Z-ADD     999           OISEQ#
     C     OICKEY        CHAIN(N)  FIORCR                             91
     C  N91              Z-ADD     OIEXT$        RESTCK
     C                   SUB       RESTCK        CRMTOT
     C                   ENDSR
      *
      *  ***********
      *  * CHKSFL  * CHECK SUB FILE FOR CREDIT
      *  ***********
     C     CHKSFL        BEGSR
     C                   SETOFF                                       102030
     C                   SETOFF                                       252635
     C                   SETOFF                                       364546
     C                   SETOFF                                       992756
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             MRCH$             9 2
     C                   Z-ADD     0             ROY$
     C                   Z-ADD     0             DISAL             9 2
     C                   Z-ADD     0             DISTX             9 2
     C                   Z-ADD     0             TXAMT             9 2
     C     TAX$          IFGT      WHTAX$
     C                   SETON                                        30  99
     C                   END
     C     FRT$          IFGT      WHFRT$
     C     WHFRT$        ANDGT     .00
     C                   SETON                                        20  99
     C                   END
     C     FRT$          IFLT      WHFRT$
     C     FRT$          ANDLT     .00
     C                   SETON                                        20  99
     C                   END
     C                   Z-SUB     TAX$          OHTAX$
     C                   Z-SUB     FRT$          OHFRT$
     C     TAX$          ADD       FRT$          CRMTOT
     C                   SUB       RESTCK        CRMTOT
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTCHK
     C                   SETOFF                                       253545
     C                   SETOFF                                       58
     C     WISEQ#        IFEQ      996
     C     WHDISC        DIV(H)    100           DSWRK             6 4
     C     DISAL         MULT(H)   DSWRK         WRKDIS            9 2
     C                   Z-SUB     WRKDIS        EXT$
     C     EXT$          IFLT      CANDC
     C                   Z-ADD     CANDC         EXT$
     C                   END
     C                   Z-ADD     0             QTYCRD
     C                   SETON                                        58
     C                   END
      ** CHECK QTY CREDITED
     C     QTYCRD        IFGT      QTYINV
     C                   SETON                                        252699
     C                   ELSE
     C     QTYCRD        IFGT      0
     C     EXT$          ANDEQ     0
     C     QTYCRD        MULT(H)   WIUPRI        EXT$
     C     EXT$          IFGT      WIAMT
     C                   Z-ADD     WIAMT         EXT$
     C                   END
     C                   ENDIF                                                  QTYCRD>0
     C                   END                                                    QTYCRD>QTYIN
      ** CHECK AMOUNT FIELD
     C     WIAMT         IFGT      0
     C     EXT$          IFGT      WIAMT
     C                   SETON                                        353699
     C                   END
     C                   ELSE
     C     EXT$          IFLT      WIAMT
     C                   SETON                                        353699
     C                   END
     C                   END                                                    WIAMT >0
      ** CHECK REASON CODE
     C                   MOVEL     OIRSCD        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      OIRSCD        TST2              2
     C                   MOVE      *BLANKS       CRREAS
     C                   MOVEL     TST2          CRREAS
     C                   Z-ADD     LCO           CO
     C                   CALL      'LKREAS'
     C                   PARM                    CO
     C                   PARM                    CRREAS
     C                   PARM                    CRDESC
     C                   MOVEL     *BLANKS       OIRSCD
     C                   MOVEL     CRREAS        OIRSCD
     C                   ENDIF
     C     OIRSCD        IFGT      *BLANKS
     C     REAKY1        CHAIN     FCMREAS                            45
     C   45              SETON                                        4699
     C   45              MOVE      *BLANKS       REASDC
     C                   ELSE
     C                   MOVE      *BLANKS       REASDC
     C                   END                                                    OIRSCD>" "
     C                   ADD       EXT$          CRMTOT
     C     WIITYP        IFEQ      ' '
     C     WIITYP        OREQ      'N'
     C                   ADD       EXT$          MRCH$
     C                   END
     C     WISIZE        IFEQ      'ROY'
     C                   ADD       EXT$          ROY$
     C                   END
     C                   UPDATE    ORDSFL
      ** CHECK FOR CASH AND CARRY
     C     CACSEQ        IFGT      0
     C     WIOVER        ANDNE     'Y'
     C     ALCAC         ANDEQ     'Y'
     C                   ADD       EXT$          DISAL
     C     IMTXBL        IFEQ      'Y'
     C                   ADD       EXT$          DISTX
     C                   END
     C                   END
     C     IMTXBL        IFEQ      'Y'
     C                   ADD       EXT$          TXAMT
     C                   END
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C     OHTRDC        IFGT      0.00
     C     OHTRDC        DIV       100           DISWRK            5 4
     C     MRCH$         SUB       ROY$          WRK$              9 2
     C     WRK$          MULT      DISWRK        DISAMT            7 2
     C                   Z-SUB     DISAMT        OHDIS$
     C                   SUB       DISAMT        CRMTOT
     C                   END
      ** CHECK CREDIT TOTAL
     C     CRMTOT        IFGT      WH$AMT
     C                   SETON                                        5699
     C                   ELSE
     C                   SETOFF                                       56
     C                   END
     C     CRMTOT        IFLT      0
     C                   SETON                                        5799
     C                   ELSE
     C                   SETOFF                                       57
     C                   END
     C*          LEFTT     ADD  .01       LFTTST 112
     C*          CRMTOT    IFGT LFTTST
     C*                    SETON                     2799
     C*                    END
     C                   ENDSR
      *
      *  ***********
      *  * CRDALL  * CREDIT ENTIRE INVOICE
      *  ***********
     C     CRDALL        BEGSR
     C                   SETOFF                                       102030
     C                   SETOFF                                       252635
     C                   SETOFF                                       364546
     C                   SETOFF                                       99  56
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             MRCH$             9 2
     C                   Z-ADD     WHTAX$        TAX$
     C                   Z-ADD     WHFRT$        FRT$
     C                   Z-SUB     TAX$          OHTAX$
     C                   Z-SUB     FRT$          OHFRT$
     C     TAX$          ADD       FRT$          CRMTOT
     C                   SUB       RESTCK        CRMTOT
     C     NXTALL        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDALL
     C                   END
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTALL
     C                   SETOFF                                       253545
     C                   SETOFF                                       58
     C                   Z-ADD     QTYINV        QTYCRD
     C                   Z-ADD     WIAMT         EXT$
     C                   ADD       EXT$          MRCH$
     C                   ADD       EXT$          CRMTOT
     C                   UPDATE    ORDSFL
     C                   GOTO      NXTALL
     C     ENDALL        TAG
     C                   ENDSR
      *
      *  ***********
      *  * UNCALL  * UN-CREDIT ENTIRE INVOICE
      *  ***********
     C     UNCALL        BEGSR
     C                   SETOFF                                       102030
     C                   SETOFF                                       252635
     C                   SETOFF                                       364546
     C                   SETOFF                                       99  56
     C                   SETOFF                                       58
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             MRCH$             9 2
     C                   Z-ADD     0             TAX$
     C                   Z-ADD     0             FRT$
     C                   Z-SUB     TAX$          OHTAX$
     C                   Z-SUB     FRT$          OHFRT$
     C     OHTAX$        ADD       OHFRT$        CRMTOT
     C                   Z-ADD     0             RESTCK
     C                   SUB       RESTCK        CRMTOT
     C     NXTUNC        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDUNC
     C                   END
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTUNC
     C                   SETOFF                                       253545
     C                   Z-ADD     0             QTYCRD
     C                   Z-ADD     0             EXT$
     C                   ADD       EXT$          MRCH$
     C                   ADD       EXT$          CRMTOT
     C                   UPDATE    ORDSFL
     C                   GOTO      NXTUNC
     C     ENDUNC        TAG
     C                   ENDSR
      *
      *  ***********
      *  * BLDTAX  * BUILD SUB FILE
      *  ***********
     C     BLDTAX        BEGSR
     C                   SETON                                        80
     C                   WRITE     TAXCTL
     C                   SETOFF                                       8098
     C                   Z-ADD     0             RECNT             5 0
     C                   Z-ADD     0             LSTSEQ            3 0
     C                   Z-SUB     OHTAX$        TAX$
     C     OHCRM#        SETLL     FIORCR
     C     NXTCTX        TAG
     C     OHCRM#        READE     FIORCR                                 90
     C   90              GOTO      ENDCTX
     C     OISEQ#        IFEQ      10
     C                   GOTO      NXTCTX
     C                   END
     C                   ADD       1             RECNT
     C                   WRITE     TAXSFL
     C                   GOTO      NXTCTX
     C     ENDCTX        TAG
     C                   Z-ADD     OISEQ#        LSTSEQ            3 0
     C     RECNT         ADD       20            ENDREC            5 0
     C                   Z-ADD     0             OISEQ#
     C                   MOVE      *BLANKS       OIDES1
     C     NXTTXB        TAG
     C                   ADD       1             RECNT
     C                   WRITE     TAXSFL
     C     RECNT         IFLE      ENDREC
     C                   GOTO      NXTTXB
     C                   END
     C                   ENDSR
      *
      *  ***********
      *  * PUTSFL  * PUT SUB FILE FOR CREDIT
      *  ***********
     C     PUTSFL        BEGSR
     C     OHCRM#        CHAIN     FHORCR                             50
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             MRCH$             9 2
     C                   Z-ADD     0             OHTOT$
     C                   Z-ADD     0             OHFRT$
     C                   Z-ADD     0             OHMER$
     C                   Z-ADD     0             ROY$
     C                   Z-ADD     0             OHDIS$
     C                   Z-ADD     0             OHMIS$
     C                   Z-SUB     TAX$          OHTAX$
     C                   Z-SUB     FRT$          OHFRT$
     C     OHTAX$        DIV(H)    .06           OHAMT1
     C     OHTAX$        ADD       OHFRT$        CRMTOT
     C***                  SUB  RESTCK    CRMTOT
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTPUT
     C     OIRSCD        IFGT      *BLANKS
     C                   MOVEL     OIRSCD        HLDREA            3
     C                   ELSE
     C                   MOVEL     OHREAS        HLDREA
     C                   END
     C     CRKEY         KLIST
     C                   KFLD                    OHCRM#
     C                   KFLD                    WISEQ#
     C     CRKEY         CHAIN     FIORCR                             51
      ** CHECK QTY CREDITED
     C     QTYCRD        IFGT      0.0
     C     EXT$          ORNE      0.00
     C     ORDKEY        KLIST
     C                   KFLD                    OHAPNO
     C                   KFLD                    WISEQ#
     C     ORDKEY        CHAIN     FIORDW                             75
     C   51              DO
     C                   CLEAR                   RIORCR
     C                   Z-ADD     OHCRM#        OICRM#
     C                   Z-ADD     WISEQ#        OISEQ#
     C                   Z-ADD     OHCUST        OICUST
     C                   ENDDO
     C                   MOVEL     'A'           OISTAT
     C                   MOVEL     WIITEM        OIITEM
     C                   MOVEL     WISIZE        OISIZE
     C                   MOVEL     WIDES1        OIDES1
     C                   MOVEL     WIDES2        OIDES2
     C                   Z-ADD     WICOMP        OICOMP
     C                   MOVEL     WIWHSE        OIWHSE
     C                   MOVEL     WIBIN#        OIBIN#
     C                   MOVEL     WIUUOM        OIUUOM
     C                   Z-ADD     WIMULT        OIMULT
     C                   Z-ADD     WIUWGT        OIUWGT
     C                   Z-ADD     WIUCST        OIUCST
     C                   Z-ADD     WIUPRI        OIUPRI
     C                   Z-ADD     WIQDDC        OIQDDC
     C                   Z-SUB     EXT$          OIEXT$
     C                   Z-ADD     WIDISC        OIDISC
     C                   MOVEL     WIOVER        OIOVER
     C                   MOVEL     WISLM1        OISLM1
     C                   Z-ADD     WICOM1        OICOM1
     C                   MOVEL     WISLM2        OISLM2
     C                   Z-ADD     WICOM2        OICOM2
     C                   MOVEL     WIITYP        OIITYP
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C                   Z-SUB     QTYCRD        OIQCRD
     C                   Z-ADD     QTYINV        OIQINV
     C                   Z-ADD     WITRDC        OITRDC
     C                   MOVEL     WICTCD        OICTCD
     C                   MOVEL     HLDREA        OIRSCD
     C                   Z-ADD     WISEQ#        OISEQP
     C                   MOVEL     WIBLUM        OIBPUM
     C                   MOVEL     WISUOM        OISUOM
     C                   Z-ADD     WIMUL2        OIMUL2
     C                   MOVEL     WILOTC        OILOTC
     C                   MOVEL     WIITAL        OIITMA
     C                   MOVEL     WIPRAL        OIPRAL
     C                   Z-ADD     WIGLNO        OIGLNO
     C   51              WRITE     RIORCR
     C  N51              UPDATE    RIORCR
     C                   ADD       OIEXT$        CRMTOT
     C     WIITYP        IFEQ      ' '
     C     WIITYP        OREQ      'N'
     C                   ADD       OIEXT$        OHMER$
     C                   END
     C     WIITYP        IFEQ      'S'
     C                   ADD       OIEXT$        OHMIS$
     C                   END
     C     WISIZE        IFEQ      'ROY'
     C                   ADD       OIEXT$        ROY$
     C                   END
     C     WIITYP        IFEQ      'F'
     C                   ADD       OIEXT$        OHFRT$
     C                   END
     C                   ELSE
     C  N51              DELETE    RIORCR
     C                   END
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
      ** CHECK FOR RESTOCK CHARGE
     C                   Z-ADD     999           WISEQ#
     C     CRKEY         CHAIN     FIORCR                             51
     C     RESTCK        IFGT      0.00
     C   51              DO
     C                   CLEAR                   RIORCR
     C                   Z-ADD     OHCRM#        OICRM#
     C                   Z-ADD     WISEQ#        OISEQ#
     C                   Z-ADD     OHCUST        OICUST
     C                   ENDDO
     C                   MOVEL     'A'           OISTAT
     C                   MOVE      *BLANKS       OIITEM
     C                   MOVE      *BLANKS       OISIZE
     C                   MOVEL     MSG(1)        OIDES1
     C                   MOVE      *BLANKS       OIDES2
     C                   Z-ADD     WICOMP        OICOMP
     C                   MOVE      *BLANKS       OIWHSE
     C                   MOVE      *BLANKS       OIBIN#
     C                   MOVE      *BLANKS       OIUUOM
     C                   Z-ADD     0             OIMULT
     C                   Z-ADD     0             OIUWGT
     C                   Z-ADD     WIUCST        OIUCST
     C                   Z-ADD     0             OIUPRI
     C                   Z-ADD     0             OIQDDC
     C                   Z-ADD     RESTCK        OIEXT$
     C                   Z-ADD     0             OIDISC
     C                   MOVEL     ' '           OIOVER
     C                   MOVEL     WISLM1        OISLM1
     C                   Z-ADD     WICOM1        OICOM1
     C                   MOVEL     WISLM2        OISLM2
     C                   Z-ADD     WICOM2        OICOM2
     C                   MOVEL     'S'           OIITYP
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C                   Z-SUB     0             OIQCRD
     C                   Z-ADD     0             OIQINV
     C                   Z-ADD     0             OITRDC
     C                   MOVE      *BLANKS       OICTCD
     C                   MOVEL     HLDREA        OIRSCD
     C                   Z-ADD     0             OISEQP
     C                   MOVE      *BLANKS       OIBPUM
     C                   MOVE      *BLANKS       OISUOM
     C                   Z-ADD     0             OIMUL2
     C                   MOVEL     WILOTC        OILOTC
     C                   MOVEL     WIITAL        OIITMA
     C                   MOVEL     WIPRAL        OIPRAL
     C                   Z-ADD     WIGLNO        OIGLNO
     C   51              WRITE     RIORCR
     C  N51              UPDATE    RIORCR
     C                   ADD       OIEXT$        CRMTOT
     C                   ADD       OIEXT$        OHMIS$
     C                   ELSE
     C  N51              DELETE    RIORCR
     C                   END
     C     OHTRDC        IFGT      0.00
     C     OHTRDC        DIV       100           DISWRK            5 4
     C     OHMER$        SUB       ROY$          WRK$$            11 2
     C     WRK$$         MULT      DISWRK        DISAMT            7 2
     C                   Z-SUB     DISAMT        OHDIS$
     C                   SUB       DISAMT        CRMTOT
     C                   END
     C                   Z-ADD     CRMTOT        OHTOT$
     C                   UPDATE    RHORCR
     C                   ENDSR
      *
      *  ***********
      *  * CHKTAX  * CHECK INPUT FIELDS
      *  ***********
     C     CHKTAX        BEGSR
     C                   SETOFF                                       9920
     C     TAX$          IFGT      WHTAX$
     C                   SETON                                        9920
     C                   END
      ** SEE IF WE NEED MORE BLANK LINES
     C     RECNT         CHAIN     TAXSFL                             90
     C     OIDES1        IFGT      *BLANKS
     C     RECNT         ADD       20            ENDREC            5 0
     C                   Z-ADD     0             OISEQ#
     C                   MOVE      *BLANKS       OIDES1
     C     NXTTXC        TAG
     C                   ADD       1             RECNT
     C                   WRITE     TAXSFL
     C     RECNT         IFLE      ENDREC
     C                   GOTO      NXTTXC
     C                   END
     C                   END
     C                   ENDSR
      *
      *  ***********
      *  * PUTTAX  * PUT TAX CREDIT MEMO
      *  ***********
     C     PUTTAX        BEGSR
     C     OHCRM#        CHAIN     FHORCR                             50
     C                   Z-SUB     TAX$          OHTAX$
     C     OHTAX$        DIV(H)    .06           OHAMT1
     C                   Z-ADD     OHTAX$        OHTOT$
     C                   Z-ADD     0             OHFRT$
     C                   Z-ADD     0             OHMER$
     C                   Z-ADD     0             ROY$
     C                   Z-ADD     0             OHDIS$
     C                   Z-ADD     0             OHMIS$
     C  N50              UPDATE    RHORCR
      ** NOW GET DETAIL LINES
      * FIRST THE TAX COMMENT
     C     OICKEY        KLIST
     C                   KFLD                    OHCRM#
     C                   KFLD                    OISEQ#
     C                   Z-ADD     10            OISEQ#
     C     OICKEY        CHAIN     FIORCR                             51
     C   51              DO
     C                   CLEAR                   RIORCR
     C                   Z-ADD     OHCRM#        OICRM#
     C                   Z-ADD     10            OISEQ#
     C                   MOVEL     CRDESC        OIDES1
     C                   Z-ADD     OHCUST        OICUST
     C                   MOVEL     OHREAS        OIRSCD
     C                   ENDDO
     C                   MOVEL     'C'           OIITYP
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C                   Z-ADD     WIGLNO        OIGLNO
     C   51              WRITE     RIORCR
     C  N51              UPDATE    RIORCR
      ** GET ADDITIONAL COMMENTS
     C     OISEQ#        IFLT      10
     C                   Z-ADD     10            LSTSEQ            3 0
     C                   END
     C                   Z-ADD     RECNT         LSTREC            5 0
     C                   Z-ADD     1             RECNT
     C     NXPTX         TAG
     C     RECNT         CHAIN     TAXSFL                             90
     C  N90              DO
     C                   MOVEL     OIDES1        HLDDES           30
     C     OISEQ#        IFGT      0
     C                   Z-ADD     OISEQ#        OISEQ             3 0
     C                   ELSE
     C     LSTSEQ        ADD       3             OISEQ
     C                   ADD       3             LSTSEQ
     C                   END
     C     OICKEY        CHAIN     FIORCR                             51
     C   51              DO
     C                   CLEAR                   RIORCR
     C                   Z-ADD     OHCRM#        OICRM#
     C                   Z-ADD     OISEQ         OISEQ#
     C                   Z-ADD     OHCUST        OICUST
     C                   MOVEL     OHREAS        OIRSCD
     C                   ENDDO
     C     HLDDES        IFGT      *BLANKS
     C                   MOVEL     HLDDES        OIDES1
     C                   END
     C                   MOVEL     'C'           OIITYP
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C                   Z-ADD     WIGLNO        OIGLNO
     C     HLDDES        IFGT      *BLANKS
     C   51              WRITE     RIORCR
     C  N51              UPDATE    RIORCR
     C                   ELSE
     C  N51              DELETE    RIORCR
     C                   ENDIF
     C                   ENDDO
     C                   ADD       1             RECNT
     C     RECNT         IFLE      LSTREC
     C                   GOTO      NXPTX
     C                   END
     C                   ENDSR
      *
      *  ***********
      *  * CRMDLV  * GET FREIGHT ONLY CREDIT
      *  ***********
     C     CRMDLV        BEGSR
     C     RSTDLV        TAG
     C                   EXSR      BLDDLV
     C     NXTDVX        TAG
     C                   EXFMT     DLVCTL
     C   KF              GOTO      RSTDLV
      *** DELETE CREDIT MEMO
     C   KX              DO
     C     DLVDL         TAG
     C                   SETON                                        98
     C                   EXFMT     DLVCTL
     C   KF              DO
     C                   SETOFF                                       98
     C                   GOTO      NXTDVX
     C                   ENDDO
     C  NKX              GOTO      DLVDL
     C                   EXSR      DELET
     C                   GOTO      ENDDLV
     C                   ENDDO
      ** CHECK INPUT
     C                   EXSR      CHKDLV
     C   99              GOTO      NXTDVX
      ** IF F2 OUTPUT CREDIT MEMO
     C   KB              DO
     C                   EXSR      PUTDLV
     C                   GOTO      ENDDLV
     C                   ENDDO
     C                   GOTO      NXTDVX
     C     ENDDLV        ENDSR
      *
      *  ***********
      *  * BLDDLV  * BUILD SUB FILE
      *  ***********
     C     BLDDLV        BEGSR
     C                   SETON                                        80
     C                   WRITE     DLVCTL
     C                   SETOFF                                       8098
     C                   Z-ADD     0             RECND             5 0
     C                   Z-ADD     0             LSTSEQ            3 0
     C                   Z-SUB     OHFRT$        FRT$
     C                   Z-SUB     OHTAX$        TAX$
     C     OHCRM#        SETLL     FIORCR
     C     NXTCDX        TAG
     C     OHCRM#        READE     FIORCR                                 90
     C   90              GOTO      ENDCDX
     C     OISEQ#        IFEQ      10
     C                   GOTO      NXTCDX
     C                   END
     C                   ADD       1             RECND
     C                   WRITE     DLVSFL
     C                   GOTO      NXTCDX
     C     ENDCDX        TAG
     C                   Z-ADD     OISEQ#        LSTSEQ            3 0
     C     RECND         ADD       20            ENDREC            5 0
     C                   Z-ADD     0             OISEQ#
     C                   MOVE      *BLANKS       OIDES1
     C     NXTDLB        TAG
     C                   ADD       1             RECND
     C                   WRITE     DLVSFL
     C     RECND         IFLE      ENDREC
     C                   GOTO      NXTDLB
     C                   END
     C                   ENDSR
      *
      *  ***********
      *  * CHKDLV  * CHECK INPUT FIELDS
      *  ***********
     C     CHKDLV        BEGSR
     C                   SETOFF                                       9920
     C     FRT$          IFGT      WHFRT$
     C                   SETON                                        9920
     C                   END
     C     TAX$          IFGT      WHTAX$
     C                   SETON                                        9930
     C                   END
      ** SEE IF WE NEED MORE BLANK LINES
     C     RECND         CHAIN     DLVSFL                             90
     C     OIDES1        IFGT      *BLANKS
     C     RECND         ADD       20            ENDREC            5 0
     C                   Z-ADD     0             OISEQ#
     C                   MOVE      *BLANKS       OIDES1
     C     NXTTDC        TAG
     C                   ADD       1             RECND
     C                   WRITE     DLVSFL
     C     RECND         IFLE      ENDREC
     C                   GOTO      NXTTDC
     C                   END
     C                   END
     C                   ENDSR
      *
      *  ***********
      *  * PUTDLV  * PUT TAX CREDIT MEMO
      *  ***********
     C     PUTDLV        BEGSR
     C     OHCRM#        CHAIN     FHORCR                             50
     C                   Z-SUB     FRT$          OHFRT$
     C                   Z-SUB     TAX$          OHTAX$
     C                   Z-ADD     OHFRT$        OHTOT$
     C                   ADD       OHTAX$        OHTOT$
     C                   Z-ADD     0             OHMER$
     C                   Z-ADD     0             ROY$
     C                   Z-ADD     0             OHDIS$
     C                   Z-ADD     0             OHMIS$
     C  N50              UPDATE    RHORCR
      ** NOW GET DETAIL LINES
      * FIRST THE TAX COMMENT
     C                   Z-ADD     10            OISEQ#
     C     OICKEY        CHAIN     FIORCR                             51
     C   51              DO
     C                   CLEAR                   RIORCR
     C                   Z-ADD     OHCRM#        OICRM#
     C                   Z-ADD     10            OISEQ#
     C                   MOVEL     CRDESC        OIDES1
     C                   Z-ADD     OHCUST        OICUST
     C                   MOVEL     OHREAS        OIRSCD
     C                   ENDDO
     C                   MOVEL     'C'           OIITYP
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C   51              WRITE     RIORCR
     C  N51              UPDATE    RIORCR
      ** GET ADDITIONAL COMMENTS
     C     OISEQ#        IFLT      10
     C                   Z-ADD     10            LSTSEQ            3 0
     C                   END
     C                   Z-ADD     RECND         LSTREC            5 0
     C                   Z-ADD     1             RECND
     C     NXPDV         TAG
     C     RECNT         CHAIN     DLVSFL                             90
     C  N90              DO
     C                   MOVEL     OIDES1        HLDDES           30
     C     OISEQ#        IFGT      0
     C                   Z-ADD     OISEQ#        OISEQ             3 0
     C                   ELSE
     C     LSTSEQ        ADD       3             OISEQ
     C                   ADD       3             LSTSEQ
     C                   END
     C     OICKEY        CHAIN     FIORCR                             51
     C   51              DO
     C                   CLEAR                   RIORCR
     C                   Z-ADD     OHCRM#        OICRM#
     C                   Z-ADD     OISEQ         OISEQ#
     C                   Z-ADD     OHCUST        OICUST
     C                   MOVEL     OHREAS        OIRSCD
     C                   ENDDO
     C     HLDDES        IFGT      *BLANKS
     C                   MOVEL     HLDDES        OIDES1
     C                   END
     C                   MOVEL     'C'           OIITYP
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C     HLDDES        IFGT      *BLANKS
     C   51              WRITE     RIORCR
     C  N51              UPDATE    RIORCR
     C                   ELSE
     C  N51              DELETE    RIORCR
     C                   ENDIF
     C                   ENDDO
     C                   ADD       1             RECND
     C     RECND         IFLE      LSTREC
     C                   GOTO      NXPDV
     C                   END
     C                   ENDSR
      *
      *  ***********
      *  * GETITM  *
      *  ***********
     C     GETITM        BEGSR
     C                   MOVE      *BLANKS       ITEM             12
     C                   MOVE      *BLANKS       SIZE              3
     C                   MOVE      *BLANKS       IMDES1
     C                   SETOFF                                       10
     C     NXTI          TAG
     C                   EXFMT     SCRNI
     C   KC
     COR KF
     COR KG              GOTO      ENDI
     C                   SETOFF                                       10
     C                   MOVEL     ITEM          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     ITEM:2        IMLOOK
     C                   CALL      'ITMALOOK'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    DESHFR
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   MOVEL     IMWHSE        USDEPT
     C     IMITEM        IFLE      *BLANKS
     C                   GOTO      NXTI
     C                   END
     C                   ENDIF
     C     ITMKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C                   KFLD                    USDEPT
     C  N90              MOVE      WHSE          USDEPT
     C     ITMKEY        CHAIN     FMINVT                             10
     C   10              GOTO      NXTI
      ** GET INVOICE
     C                   Z-ADD     0             WIINV#            6 0
     C                   Z-ADD     01            IMCOMP
     C                   CALL      'LKITIV'
     C                   PARM                    VBCUST
     C                   PARM                    IMCOMP
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    WIINV#
     C                   Z-ADD     WIINV#        VINV
     C     ENDI          TAG
     C                   ENDSR
      *
      *  ***********
      *  * #SLD    *
      *  ***********
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE SOLD TO
      *  ADDRESS.  WORK FIELDS ARE DEFINED AS:
      *
      *                 WORK  = CITY,STATE,ZIP(9 DIGIT)
      *                 WORK1 = CITY, STATE
      *                 WORK2 = ZIP CODE(XXXXX-XXXX)
      *                 WORK3 = STANDARD ZIP CODE(XXXXX)
      *                 WORK4 = ADDITIONAL ZIP CODE(-XXXX)
      *
      *  THE SUBROUTINE REQUIRES MOVING NAME AND ADDRESS INFORMATION TO
      *  BE CONDENSED TO A DATA STRUCTURE
      *
     C     #SLD          BEGSR
      *
     C                   MOVE      *BLANKS       #SL
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WSLD1        #SL(#X)
     C                   ADD       1             #X
     C     #WSLD2        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD1
     C                   MOVEL     #WSLD2        #SL(#X)
     C                   ADD       1             #X
     C     #SLD1         TAG
     C     #WSLD3        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD2
     C                   MOVEL     #WSLD3        #SL(#X)
     C                   ADD       1             #X
     C     #SLD2         TAG
     C     #WSLD4        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD3
     C                   MOVEL     #WSLD4        #SL(#X)
     C                   ADD       1             #X
     C     #SLD3         TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WSLCT        CAT       #WSLST:1      WORK1
     C                   MOVEL     #WSLZP        WORK3
     C                   MOVE      #WSLZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SL(#X)
     C                   SETOFF                                       919293
     C                   MOVEL     #SL(1)        BIL1
     C                   MOVEL     #SL(2)        BIL2
     C                   MOVEL     #SL(3)        BIL3
     C                   MOVEL     #SL(4)        BIL4
     C                   MOVEL     #SL(5)        BIL5
     C                   ENDSR
      *  ***********
      *  * #SHP    *
      *  ***********
      *
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE SHIP TO
      *  ADDRESS.  WORK FIELDS ARE DEFINED AS:
      *
      *                 WORK  = CITY,STATE,ZIP(9 DIGIT)
      *                 WORK1 = CITY, STATE
      *                 WORK2 = ZIP CODE(XXXXX-XXXX)
      *                 WORK3 = STANDARD ZIP CODE(XXXXX)
      *                 WORK4 = ADDITIONAL ZIP CODE(-XXXX)
      *
      *  THE SUBROUTINE REQUIRES MOVING NAME AND ADDRESS INFORMATION TO
      *  BE CONDENSED TO A DATA STRUCTURE
      *
     C     #SHP          BEGSR
      *
     C                   MOVE      *BLANKS       #SH
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WSHP1        #SH(#X)
     C                   ADD       1             #X
     C     #WSHP2        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP1
     C                   MOVEL     #WSHP2        #SH(#X)
     C                   ADD       1             #X
     C     #SHP1         TAG
     C     #WSHP3        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP2
     C                   MOVEL     #WSHP3        #SH(#X)
     C                   ADD       1             #X
     C     #SHP2         TAG
     C     #WSHP4        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP3
     C                   MOVEL     #WSHP4        #SH(#X)
     C                   ADD       1             #X
     C     #SHP3         TAG
     C                   MOVE      *BLANKS       WORK             32            BLANK
     C                   MOVE      *BLANKS       WORK1            21            BLANK
     C                   MOVE      *BLANKS       WORK2            10             "
     C                   MOVE      *BLANKS       WORK3             5             "
     C                   MOVE      *BLANKS       WORK4             5             "
     C     #WSHCT        CAT       #WSHST:1      WORK1
     C                   MOVEL     #WSHZP        WORK3
     C                   MOVE      #WSHZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C*                    MOVELWORK1     WORK
     C*                    MOVE WORK2     WORK
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SH(#X)
     C                   SETOFF                                       919293
     C                   MOVEL     #SH(1)        SHIP1
     C                   MOVEL     #SH(2)        SHIP2
     C                   MOVEL     #SH(3)        SHIP3
     C                   MOVEL     #SH(4)        SHIP4
     C                   MOVEL     #SH(5)        SHIP5
     C                   ENDSR
**  MESSAGES
Re-Stocking Charge
