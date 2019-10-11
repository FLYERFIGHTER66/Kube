      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES  INC.     1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC. ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ICR200
      *SYSTEM-------------- INVENTORY
      *APPLICATION--------- INVENTORY TRANSACTION ENTRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  5/31/01 EFD DO NOT CLEAR SIZE ON SCREEN A. PER BILL
      *
     FICR200FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMINVT    UF A E           K DISK
     FFMINVTI   IF   E           K DISK
     F                                     RENAME(RMINVT:MINVTI)
     FFLKITM    UF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFPRODCD   IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFTINVT    O  A E             DISK
      *
      ** MINVT ARRAYS
     D IP1             S              9  4 DIM(5)                               PRICE U/M 1
     D IP2             S              9  4 DIM(5)                               PRICE U/M 2
     D IP3             S              9  4 DIM(5)                               PRICE U/M 3
     D IDQ             S             11  1 DIM(5)                               QTY. DISC QTY.
     D IDP             S              4  2 DIM(5)                               QTY. DISC %
     D ISQ             S             11  1 DIM(13)                              SOLD QTY 13 MO
     D ISP             S              9  2 DIM(13)                              SOLD PRICE 13
     D ISC             S              9  2 DIM(13)                              SOLD COST 13 M
     D IGB             S              4  0 DIM(4)                               BEG WKS GERM
     D IGE             S              4  0 DIM(4)                               END WKS GERM
     D IGW             S              2  0 DIM(4)                               # OF WKS GERM
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0

     D PITEM           S                   Like(VITEM)
     D PSIZE           S                   Like(VSIZE)
      *
     IMINVTI
     I              IMQTOH                      QTOH
     I              IMUCST                      UCST
     I              IMLCST                      LCST
     I              IMPUOM                      PUOM
     I              IMSUOM                      SUOM
     I              IM3UOM                      U3OM
     IRMINVT
     I              IMSEL1                      IP1(1)
     I              IMSEL2                      IP1(2)
     I              IMSEL3                      IP1(3)
     I              IMSEL4                      IP1(4)
     I              IMSEL5                      IP1(5)
     I              IMBCS1                      IP2(1)
     I              IMBCS2                      IP2(2)
     I              IMBCS3                      IP2(3)
     I              IMBCS4                      IP2(4)
     I              IMBCS5                      IP2(5)
     I              IM3CS1                      IP3(1)
     I              IM3CS2                      IP3(2)
     I              IM3CS3                      IP3(3)
     I              IM3CS4                      IP3(4)
     I              IM3CS5                      IP3(5)
     I              IMQLB1                      IDQ(1)
     I              IMQLB2                      IDQ(2)
     I              IMQLB3                      IDQ(3)
     I              IMQLB4                      IDQ(4)
     I              IMQLB5                      IDQ(5)
     I              IMDIS1                      IDP(1)
     I              IMDIS2                      IDP(2)
     I              IMDIS3                      IDP(3)
     I              IMDIS4                      IDP(4)
     I              IMDIS5                      IDP(5)
     I              IMQM01                      ISQ(1)
     I              IMQM02                      ISQ(2)
     I              IMQM03                      ISQ(3)
     I              IMQM04                      ISQ(4)
     I              IMQM05                      ISQ(5)
     I              IMQM06                      ISQ(6)
     I              IMQM07                      ISQ(7)
     I              IMQM08                      ISQ(8)
     I              IMQM09                      ISQ(9)
     I              IMQM10                      ISQ(10)
     I              IMQM11                      ISQ(11)
     I              IMQM12                      ISQ(12)
     I              IMQM13                      ISQ(13)
     I              IM$M01                      ISP(1)
     I              IM$M02                      ISP(2)
     I              IM$M03                      ISP(3)
     I              IM$M04                      ISP(4)
     I              IM$M05                      ISP(5)
     I              IM$M06                      ISP(6)
     I              IM$M07                      ISP(7)
     I              IM$M08                      ISP(8)
     I              IM$M09                      ISP(9)
     I              IM$M10                      ISP(10)
     I              IM$M11                      ISP(11)
     I              IM$M12                      ISP(12)
     I              IM$M13                      ISP(13)
     I              IMCM01                      ISC(1)
     I              IMCM02                      ISC(2)
     I              IMCM03                      ISC(3)
     I              IMCM04                      ISC(4)
     I              IMCM05                      ISC(5)
     I              IMCM06                      ISC(6)
     I              IMCM07                      ISC(7)
     I              IMCM08                      ISC(8)
     I              IMCM09                      ISC(9)
     I              IMCM10                      ISC(10)
     I              IMCM11                      ISC(11)
     I              IMCM12                      ISC(12)
     I              IMCM13                      ISC(13)
     I              IMBD1                       IGB(1)
     I              IMBD2                       IGB(2)
     I              IMBD3                       IGB(3)
     I              IMBD4                       IGB(4)
     I              IMED1                       IGE(1)
     I              IMED2                       IGE(2)
     I              IMED3                       IGE(3)
     I              IMED4                       IGE(4)
     I              IMWG1                       IGW(1)
     I              IMWG2                       IGW(2)
     I              IMWG3                       IGW(3)
     I              IMWG4                       IGW(4)
      *
     C     *Entry        PList
     C     VITEM         Parm                    PITEM
     C     VSIZE         Parm                    PSIZE
     C                   SETOFF                                       9930
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         VDATE
     C                   Z-ADD     1             FIRST             6 0
      ** GET USER AND DEPARTMENT
     C     USERID        CHAIN     FMUSER                             57
     C*  57                DO
     C*                    WRITESCRNERR
     C*                    READ SCRNERR                  90
     C*                    GOTO ENDP
     C*                    ENDDO
     C     USDEPT        CHAIN     FMDEPT                             58
     C                   MOVEL     DESHFR        VLOC
     C*          DEALL     IFEQ 'N'
     C*                    SETON                     29
     C*                    ELSE
     C                   SETOFF                                       29
     C*                    END
      *
     C     KEY18         KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C                   KFLD                    VLOC
      *
     C                   If        VITEM <> *Blanks
     C                   Eval      VType = 'A'
     C                   Goto      SkipA
     C                   EndIf
      *
     C     RSTRTA        TAG
     C                   SETOFF                                       98
     C                   EXSR      CLRIT
      *
     C                   UNLOCK    FMINVT
     C                   UNLOCK    FLKITM
      *
     C     NXTA          TAG
     C     FIRST         IFGT      1
     C                   SETON                                        11
     C                   ENDIF
     C                   MOVEL     *BLANKS       VALPHA
     C                   WRITE     SCRNA
     C                   SETOFF                                       102021
     C                   SETOFF                                       2230
     C                   READ      SCRNA                                  90
     C     SkipA         Tag
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      ENDP
      *
     C     VITEM         IFEQ      *BLANKS
     C     VALPHA        ANDGT     *BLANKS
     C                   MOVEL     VALPHA        IMLOOK
     C                   MOVEL     VSIZE         IMSIZE
     C                   MOVEL     VLOC          SHPFR
     C                   MOVEL     VLOC          IMWHSE
     C                   CALL      'LKITAL'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        VITEM
     C                   MOVEL     IMSIZE        VSIZE
     C**                   MOVELIMWHSE    VLOC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VTYPE         IFNE      'R'
     C     VTYPE         ANDNE     'I'
     C     VTYPE         ANDNE     'O'
     C     VTYPE         ANDNE     'A'
     C     VTYPE         ANDNE     'T'
     C     VTYPE         ANDNE     'P'
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VITEM         IFEQ      *BLANKS
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     1             SUBST     VSIZE:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     VSIZE         SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       VSIZE
     C                   MOVEL     SZCODE        VSIZE
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     1             SUBST     VLOC:1        VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     *BLANKS       WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       VLOC
     C                   MOVEL     WHWHSE        VLOC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     KEY18         CHAIN     FMINVT                             90
     C   90              SETON                                        2021
     C   21              GOTO      NXTA
      *
     C     IMLOTC        IFEQ      'Y'
     C                   SETON                                        2022
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   EXSR      GETDES
     C                   Z-ADD     IMUCST        OLUCST
      *
     C                   Z-ADD     VDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     ##CYMD        VDATEC            7 0
      *
     C                   MOVEL     VTYPE         OTYPE             1
     C                   MOVEL     VITEM         OITEM            12
     C                   MOVEL     VSIZE         OSIZE             3
     C                   MOVEL     VLOC          OLOC              3
     C                   MOVEL     DESP          ODESC
     C                   Z-ADD     VDATE         ODATE             6 0
     C                   ADD       1             FIRST
      *
     C     VTYPE         IFEQ      'R'
     C                   Z-ADD     IMLCST        VCOST
     C                   MOVEL     'U'           VUORE
     C                   MOVEL     IMPUOM        ITTUOM
     C                   GOTO      RSTRTB
     C                   ENDIF
     C     VTYPE         IFEQ      'I'
     C                   MOVEL     IMPUOM        ITTUOM
     C                   GOTO      RSTRTC
     C                   ENDIF
     C     VTYPE         IFEQ      'O'
     C                   MOVEL     IMPUOM        ITTUOM
     C                   GOTO      RSTRTD
     C                   ENDIF
     C     VTYPE         IFEQ      'A'
     C                   MOVEL     IMPUOM        ITTUOM
     C                   GOTO      RSTRTE
     C                   ENDIF
     C     VTYPE         IFEQ      'P'
     C                   MOVEL     IMPUOM        ITTUOM
     C                   GOTO      RSTRTF
     C                   ENDIF
     C     VTYPE         IFEQ      'T'
     C                   Z-ADD     IMLCST        TRNCST
     C                   MOVEL     'U'           VUORE
     C                   MOVEL     IMPUOM        ITTUOM
     C                   GOTO      RSTRTT
     C                   ENDIF
     C                   GOTO      RSTRTA
      *
     C     RSTRTB        TAG
     C                   MOVEL     IMPUOM        ITTUOM
     C                   MOVEL     'N'           VREPO
     C                   Z-ADD     1             B                 3 0
     C                   SETOFF                                           88
      *
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       313240
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRTA
      *
     C   KB              DO
     C                   Z-ADD     LCO           VMCOMP            2 0
     C                   MOVEL     *BLANKS       VMLOOK           15
     C                   MOVEL     'A'           VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        VVEND
     C                   MOVEL     VMNAME        VNAME
     C                   GOTO      NXTB
     C                   ENDDO
      *
     C     1             SUBST     ITTUOM:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     IMPUOM        VUNIT             2
     C                   EXSR      UOMSR
     C                   MOVEL     VUNIT         ITTUOM
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     ITTQTY        IFEQ      0
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     ITTQTY        IFNE      OQTY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ITTQTY        OQTY             11 1
      *
     C     ITTUOM        IFNE      IMPUOM
     C*          ITTUOM    ORNE IMSUOM
     C*          ITTUOM    ORNE IM3UOM
     C                   SETON                                        20
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     ITTUOM        IFNE      OTUOM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     ITTUOM        OTUOM             2
      *
     C     VREPO         IFNE      'Y'
     C     VREPO         ANDNE     'N'
     C                   SETON                                        3031
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VREPO         IFEQ      'N'
     C                   GOTO      NREPO
     C                   ENDIF
      *
     C     IMQTOO        IFEQ      0
     C                   SETON                                        3032
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VREPO         IFNE      OREPO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VREPO         OREPO             1
      *
     C     NREPO         TAG
      *
      * CALCULATE COST
      *
     C     VCOST         IFEQ      0
     C                   GOTO      NUORE
     C                   ENDIF
      *
     C     VUORE         IFNE      'E'
     C     VUORE         ANDNE     'U'
     C                   SETON                                        40
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VUORE         IFNE      OUORE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VUORE         OUORE             1
      *
     C     VUORE         IFEQ      'U'
     C                   Z-ADD     VCOST         COST              9 4
     C                   ENDIF
      *
     C     VUORE         IFEQ      'E'
     C     VCOST         DIV(H)    ITTQTY        COST              9 4
     C                   ENDIF
      *
     C     NUORE         TAG
      *
     C     VREF          IFNE      OREF
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VREF          OREF             30
      *
     C     VCOMM         IFNE      OCOMM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VCOMM         OCOMM            30
      *
     C     VVEND         IFGT      0
     C     VVEND         CHAIN     FMVEND                             90
     C   90              SETON                                        50
     C   50              GOTO      NXTB
     C  N90              MOVEL     VMNAME        VNAME
     C                   ENDIF
      *
     C     VVEND         IFNE      OVEND
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VVEND         OVEND             6 0
      *
     C     VVITEM        IFNE      OVITEM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VVITEM        OVITEM           30
      *
     C     IMQTOH        ADD       ITTQTY        NQTYOH           11 1
     C                   Z-ADD     COST          NLCST
      *
     C     VCOST         IFGT      0
     C                   Z-ADD     COST          WRK194
     C                   Z-ADD     ITTQTY        WRK190
     C                   EXSR      #AVGC
     C                   Z-ADD     IMUCST        NUCST
     C                   ENDIF
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C                   EXSR      UTINVT
     C                   EXSR      UMINVT
     C***                  EXSR ULKITM
      *
     C                   GOTO      RSTRTA
      *
     C     RSTRTC        TAG
     C                   MOVEL     IMPUOM        ITTUOM
      *
     C     NXTC          TAG
     C                   WRITE     SCRNC
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       40
     C                   READ      SCRNC                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRTA
      *
     C     1             SUBST     ITTUOM:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     IMPUOM        VUNIT             2
     C                   EXSR      UOMSR
     C                   MOVEL     VUNIT         ITTUOM
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     ITTQTY        IFEQ      0
     C                   SETON                                        10
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     ITTQTY        IFNE      OQTY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ITTQTY        OQTY             11 1
      *
     C     ITTUOM        IFNE      IMPUOM
     C*          ITTUOM    ORNE IMSUOM
     C*          ITTUOM    ORNE IM3UOM
     C                   SETON                                        20
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     ITTUOM        IFNE      OTUOM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     ITTUOM        OTUOM             2
      *
     C     VREF          IFNE      OREF
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VREF          OREF             30
      *
     C     VCOMM         IFNE      OCOMM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VCOMM         OCOMM            30
      *
     C     IMQTOH        SUB       ITTQTY        NQTYOH           11 1
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C                   EXSR      UTINVT
     C                   EXSR      UMINVT
      *
     C                   GOTO      RSTRTA
      *
     C     RSTRTD        TAG
     C                   MOVEL     IMPUOM        ITTUOM
      *
     C     NXTD          TAG
     C                   WRITE     SCRND
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       40
     C                   READ      SCRND                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRTA
      *
     C   KB              DO
     C                   Z-ADD     LCO           VMCOMP            2 0
     C                   MOVEL     *BLANKS       VMLOOK           15
     C                   MOVEL     'A'           VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        VVEND
     C                   MOVEL     VMNAME        VNAME
     C                   GOTO      NXTD
     C                   ENDDO
      *
     C     1             SUBST     ITTUOM:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     IMPUOM        VUNIT             2
     C                   EXSR      UOMSR
     C                   MOVEL     VUNIT         ITTUOM
     C                   GOTO      NXTD
     C                   ENDIF
      *
     C     ITTQTY        IFEQ      0
     C                   SETON                                        10
     C                   GOTO      NXTD
     C                   ENDIF
      *
     C     ITTQTY        IFNE      OQTY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ITTQTY        OQTY             11 1
      *
     C     ITTUOM        IFNE      IMPUOM
     C*          ITTUOM    ORNE IMSUOM
     C*          ITTUOM    ORNE IM3UOM
     C                   SETON                                        20
     C                   GOTO      NXTD
     C                   ENDIF
      *
     C     ITTUOM        IFNE      OTUOM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     ITTUOM        OTUOM             2
      *
     C     VREF          IFNE      OREF
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VREF          OREF             30
      *
     C     VCOMM         IFNE      OCOMM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VCOMM         OCOMM            30
      *
     C     VVEND         IFGT      0
     C     VVEND         CHAIN     FMVEND                             90
     C   90              SETON                                        50
     C   50              GOTO      NXTD
     C  N90              MOVEL     VMNAME        VNAME
     C                   ENDIF
      *
     C     VVEND         IFNE      OVEND
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VVEND         OVEND             6 0
      *
     C     VVITEM        IFNE      OVITEM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VVITEM        OVITEM           30
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C                   EXSR      UTINVT
     C                   EXSR      UMINVT
      *
     C                   GOTO      RSTRTA
      *
     C     RSTRTE        TAG
     C                   MOVEL     IMPUOM        ITTUOM
     C                   MOVEL     *BLANKS       VCODE
     C                   MOVEL     *BLANKS       PDESC
     C                   MOVE      *BLANKS       OCODE
     C                   MOVEL     'ADJ'         VCODE
     C     VCODE         CHAIN     FPRODCD                            90
     C                   MOVEL     VCODE         OCODE             3
     C                   Z-ADD     0             OQTY
     C                   Z-ADD     0             QTYPLS
     C                   Z-ADD     0             QTYMIN
     C                   Z-ADD     0             OCOST
     C                   Z-ADD     0             VCOST
     C                   Z-ADD     1             B                 3 0
     C                   SETOFF                                       98
     C                   SETON                                        17
      *
     C     NXTE          TAG
     C                   WRITE     SCRNE
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102021
     C                   SETOFF                                       2223
     C                   READ      SCRNE                                  90
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRTA
      *
     C     1             SUBST     VCODE:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     VCODE         PCCODE
     C                   CALL      'LKPRCD'
     C                   PARM                    PCCODE
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VCODE
     C                   MOVEL     PCCODE        VCODE
     C                   MOVEL     PCDESC        PDESC
     C                   GOTO      NXTE
     C                   ENDIF
      *
     C     1             SUBST     ITTUOM:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     IMPUOM        VUNIT             2
     C                   EXSR      UOMSR
     C                   MOVEL     VUNIT         ITTUOM
     C                   GOTO      NXTE
     C                   ENDIF
      *
     C     VCODE         CHAIN     FPRODCD                            90
     C   90              SETON                                        10
     C   10              GOTO      NXTE
      *
     C     VCODE         IFNE      OCODE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VCODE         OCODE             3
      *
     C     QTYPLS        IFNE      0
     C     QTYMIN        ANDNE     0
     C                   SETON                                        2023
     C                   GOTO      NXTE
     C                   ENDIF
      ** EFD 5/24/01 SWITCHED Z-ADD AND Z-SUB
     C     QTYPLS        IFNE      0
     C                   Z-ADD     QTYPLS        ITTQTY
     C                   ENDIF
     C     QTYMIN        IFNE      0
     C                   Z-SUB     QTYMIN        ITTQTY
     C                   ENDIF
      *
     C     ITTQTY        IFEQ      0
     C     VCOST         ANDEQ     0
     C                   SETON                                        2021
     C                   GOTO      NXTE
     C                   ENDIF
      *
     C     ITTQTY        IFNE      0
     C     VCOST         ANDNE     0
     C                   SETON                                        2022
     C                   GOTO      NXTE
     C                   ENDIF
      *
     C     ITTQTY        IFNE      OQTY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ITTQTY        OQTY             11 1
      *
     C     VCOST         IFNE      OCOST
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VCOST         OCOST             9 4
      * 5/24/01 EFD CHANGED THE FOLLOWING
     C     IMQTOH        ADD       ITTQTY        NQTYOH           11 1
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      NXTE
     C                   ENDIF
     C                   If        *InKJ
     C                   EXSR      ITSGONE
     C                   EndIf
      *
     C                   EXSR      UTINVT
     C                   EXSR      UMINVT
      *
     C                   GOTO      RSTRTA
      *
      *
     C     RSTRTF        TAG
     C                   MOVEL     IMPUOM        ITTUOM
     C                   MOVEL     *BLANKS       VCODE
     C                   MOVEL     *BLANKS       PDESC
     C                   MOVE      *BLANKS       OCODE
     C                   MOVEL     'PRJ'         VCODE
     C     VCODE         CHAIN     FPRODCD                            90
     C                   MOVEL     VCODE         OCODE             3
     C                   Z-ADD     0             OQTY
     C                   Z-ADD     0             QTYPLS
     C                   Z-ADD     0             QTYMIN
     C                   Z-ADD     0             OCOST
     C                   Z-ADD     0             VCOST
     C                   Z-ADD     1             B                 3 0
     C                   SETOFF                                       98
     C                   SETON                                        17
      *
     C     NXTF          TAG
     C                   WRITE     SCRNF
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102021
     C                   SETOFF                                       2223
     C                   READ      SCRNF                                  90
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRTA
      *
     C     1             SUBST     VCODE:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     VCODE         PCCODE
     C                   CALL      'LKPRCD'
     C                   PARM                    PCCODE
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VCODE
     C                   MOVEL     PCCODE        VCODE
     C                   MOVEL     PCDESC        PDESC
     C                   GOTO      NXTF
     C                   ENDIF
      *
     C     1             SUBST     ITTUOM:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     IMPUOM        VUNIT             2
     C                   EXSR      UOMSR
     C                   MOVEL     VUNIT         ITTUOM
     C                   GOTO      NXTF
     C                   ENDIF
      *
     C     VCODE         CHAIN     FPRODCD                            90
     C   90              SETON                                        10
     C   10              GOTO      NXTF
      *
     C     VCODE         IFNE      OCODE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VCODE         OCODE             3
      *
     C     QTYPLS        IFNE      0
     C     QTYMIN        ANDNE     0
     C                   SETON                                        2023
     C                   GOTO      NXTF
     C                   ENDIF
      ** EFD 5/24/01 SWITCHED Z-ADD AND Z-SUB
     C     QTYPLS        IFNE      0
     C                   Z-ADD     QTYPLS        ITTQTY
     C                   ENDIF
     C     QTYMIN        IFNE      0
     C                   Z-SUB     QTYMIN        ITTQTY
     C                   ENDIF
      *
     C     ITTQTY        IFEQ      0
     C     VCOST         ANDEQ     0
     C                   SETON                                        2021
     C                   GOTO      NXTF
     C                   ENDIF
      *
     C     ITTQTY        IFNE      0
     C     VCOST         ANDNE     0
     C                   SETON                                        2022
     C                   GOTO      NXTF
     C                   ENDIF
      *
     C     ITTQTY        IFNE      OQTY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ITTQTY        OQTY             11 1
      *
     C     VCOST         IFNE      OCOST
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VCOST         OCOST             9 4
      * 5/24/01 EFD CHANGED THE FOLLOWING
     C     IMQTOH        ADD       ITTQTY        NQTYOH           11 1
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      NXTF
     C                   ENDIF
      *
     C                   EXSR      UTINVT
     C                   EXSR      UMINVT
      *
     C                   GOTO      RSTRTA
      *
      *
     C     RSTRTT        TAG
     C                   MOVEL     IMPUOM        ITTUOM
     C     VLOC          CHAIN     FMWHSE                             10
     C                   MOVEL     WHDESC        CURWHS
      *
     C     NXTT          TAG
     C                   WRITE     SCRNT
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       40
     C                   READ      SCRNT                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRTA
      *
     C                   MOVEL     TOWHSE        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     *BLANKS       WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       TOWHSE
     C                   MOVEL     WHWHSE        TOWHSE
     C                   GOTO      NXTT
     C                   ENDIF
      ** CHECK WHSE
     C     TOWHSE        CHAIN     FMWHSE                             20
     C   20              DO
     C                   MOVE      *BLANKS       TWHSNM
     C                   GOTO      NXTT
     C                   ENDDO                                                  20  DO
     C                   MOVEL     WHDESC        TWHSNM
      *
     C     ITTQTY        IFLE      0
     C                   SETON                                        10
     C                   GOTO      NXTT
     C                   ENDIF
     C     MINVTK        KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C                   KFLD                    TOWHSE
      *
     C                   Z-ADD     0             QTOH
     C     MINVTK        CHAIN     FMINVTI                            57
     C   57              DO
     C     NXT57         TAG
     C                   WRITE     SCRNT
     C                   READ      SCRNT                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRTA
     C  NKI              GOTO      NXT57
      ** F9=ADD RECORD TO NEW WHSE
     C                   EXSR      ADDREC
     C                   SETOFF                                       57
     C                   ENDDO
      *
      *
     C     ITTQTY        IFNE      OQTY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ITTQTY        OQTY             11 1
      *
     C     ITTUOM        IFNE      IMPUOM
     C*          ITTUOM    ORNE IMSUOM
     C*          ITTUOM    ORNE IM3UOM
     C                   SETON                                        20
     C                   GOTO      NXTT
     C                   ENDIF
      *
     C     ITTUOM        IFNE      OTUOM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     ITTUOM        OTUOM             2
      *
     C     TOWHSE        IFNE      OTWHS
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     TOWHSE        OTWHS             3
      *
     C     VREF          IFNE      OREF
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VREF          OREF             30
      *
     C     VCOMM         IFNE      OCOMM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VCOMM         OCOMM            30
      *
     C     IMQTOH        SUB       ITTQTY        NQTYOH
     C     QTOH          ADD       ITTQTY        TQTYOH
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      NXTT
     C                   ENDIF
      *
     C**                   EXSR UTINVT
     C                   MOVEL     'A'           ITSTAT
     C                   MOVEL     VITEM         ITITEM
     C                   MOVEL     VSIZE         ITSIZE
     C                   MOVEL     TOWHSE        ITTWSE
     C                   MOVEL     VLOC          ITFWSE
     C                   Z-ADD     LCO           ITFCOM
     C                   Z-ADD     LCO           ITTCOM
     C                   MOVEL     'T'           ITTYPE
     C                   MOVEL     VCOMM         ITDESC
     C                   MOVEL     VREF          ITTREF
     C                   MOVEL     VVITEM        ITVITM
     C                   Z-ADD     VDATE         ITTDAT
     C                   Z-ADD     VDATEC        ITYDAT
     C                   Z-ADD     VVEND         ITVEND
     C                   Z-ADD     COST          ITCOST
     C                   Z-ADD     NUCST         ITCOAV
     C                   Z-ADD     TDATE         ITDTLA
     C                   Z-ADD     TIMOD         ITTIME
     C                   MOVEL     USERID        ITUSER
     C                   MOVEL     VREPO         ITREPO
     C                   MOVEL     VCODE         ITREAS
     C                   WRITE     RTINVT
      ** POST ISSUE FIRST
     C                   MOVEL     'I'           VTYPE
     C     KEY18         CHAIN     FMINVT                             90
     C                   EXSR      UMINVT
      ** NOW GET RECEIPT
     C                   MOVEL     'R'           VTYPE
     C                   MOVEL     TOWHSE        VLOC
     C     KEY18         CHAIN     FMINVT                             90
     C                   EXSR      UMINVT
      *
     C                   MOVEL     'T'           VTYPE
     C                   MOVEL     DESHFR        VLOC
     C                   GOTO      RSTRTA
      *
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *********
      * UTINVT
      *********
     C     UTINVT        BEGSR
     C                   MOVEL     'A'           ITSTAT
     C                   MOVEL     VITEM         ITITEM
     C                   MOVEL     VSIZE         ITSIZE
     C                   MOVEL     VLOC          ITTWSE
     C                   Z-ADD     LCO           ITTCOM
     C                   MOVEL     VTYPE         ITTYPE
     C                   MOVEL     VCOMM         ITDESC
     C                   MOVEL     VREF          ITTREF
     C                   MOVEL     VVITEM        ITVITM
     C                   Z-ADD     VDATE         ITTDAT
     C                   Z-ADD     VDATEC        ITYDAT
     C                   Z-ADD     VVEND         ITVEND
     C                   Z-ADD     COST          ITCOST
     C                   Z-ADD     NUCST         ITCOAV
     C                   Z-ADD     TDATE         ITDTLA
     C                   Z-ADD     TIMOD         ITTIME
     C                   MOVEL     USERID        ITUSER
     C                   MOVEL     VREPO         ITREPO
     C                   MOVEL     VCODE         ITREAS
     C                   WRITE     RTINVT
     C                   ENDSR
      *********
      * UMINVT
      *********
     C     UMINVT        BEGSR
     C     KEY18         CHAIN     FLKITM                             90
     C     VTYPE         IFNE      'R'
     C                   GOTO      NOREC
     C                   ENDIF
     C                   ADD       ITTQTY        IMQTOH
     C                   ADD       ITTQTY        IMQTAV
     C                   ADD       ITTQTY        IMMREC
     C                   ADD       ITTQTY        LKPOH
     C     VREPO         IFEQ      'Y'
     C                   SUB       ITTQTY        IMQTOO
     C                   ENDIF
     C     VCOST         IFGT      0
     C                   Z-ADD     COST          IMLCST
     C                   Z-ADD     NUCST         IMUCST
     C                   ENDIF
     C     NOREC         TAG
     C     VTYPE         IFEQ      'I'
     C                   SUB       ITTQTY        IMQTOH
     C                   SUB       ITTQTY        IMQTAV
     C                   SUB       ITTQTY        IMISSU
     C                   SUB       ITTQTY        LKPOH
     C                   ENDIF
     C     VTYPE         IFEQ      'O'
     C                   ADD       ITTQTY        IMQTOO
     C                   ENDIF
      ** CHANGED THE FOLLOWING TO ADD TO GET SIGN RIGHT EFD 5/24/01
     C     VTYPE         IFEQ      'A'
     C     VTYPE         OREQ      'P'
     C                   ADD       ITTQTY        IMQTOH
     C                   ADD       ITTQTY        IMQTAV
     C******               SUB  ITTQTY    IMISSU
     C                   ADD       ITTQTY        IMMADJ
     C                   ADD       ITTQTY        LKPOH
     C                   ENDIF
     C                   Z-ADD     TDATE         IMDTLA
     C                   Z-ADD     TIMOD         IMTIME
     C                   MOVEL     USERID        IMUSER
     C                   UPDATE    RMINVT
     C  N90              UPDATE    RLKITM
     C                   ENDSR
      *********
      * ULKITM
      *********
     C*          ULKITM    BEGSR
     C*          KEY18     CHAINFLKITM               90
     C*          VTYPE     IFNE 'R'
     C*                    GOTO NORE2
     C*                    ENDIF
     C*                    ADD  ITTQTY    LKPOH
     C*          NORE2     TAG
     C*                    UPDATRLKITM
     C*                    ENDSR
      *********
      * ADDREC
      *********
     C     ADDREC        BEGSR
     C     KEY18         CHAIN(N)  FMINVT                             91
     C                   Z-ADD     0             ISQ
     C                   Z-ADD     0             ISP
     C                   Z-ADD     0             ISC
     C                   Z-ADD     0             IMQTSO
     C                   Z-ADD     0             IMDTLO
     C                   Z-ADD     0             IMQTOH
     C                   Z-ADD     0             IMQ2OH
     C                   Z-ADD     0             IMQ3OH
     C                   Z-ADD     0             IMQTOO
     C                   Z-ADD     0             IMQTAL
     C                   Z-ADD     0             IMALC2
     C                   Z-ADD     0             IMALC3
     C                   Z-ADD     0             IMQTAV
     C                   Z-ADD     0             IMQTA2
     C                   Z-ADD     0             IMQTA3
     C                   Z-ADD     0             IMQTBO
     C                   Z-ADD     0             IMQMTD
     C                   Z-ADD     0             IM$MTD
     C                   Z-ADD     0             IMCMTD
     C                   Z-ADD     0             IMDTLS
     C                   Z-ADD     0             IMMREC
     C                   Z-ADD     0             IMMADJ
     C                   Z-ADD     0             IMISSU
     C                   Z-ADD     0             IMQPHY
     C                   Z-ADD     0             IMQPH2
     C                   Z-ADD     0             IMQPH3
     C                   Z-ADD     0             IMBPOH
     C                   Z-ADD     0             IMCSOH
     C                   Z-ADD     0             IMLBS#
     C                   Z-ADD     0             IMQPH#
      ** GET ALPHA SEARCH
     C     IMWHSE        IFEQ      'F  '
     C     IMWHSE        OREQ      'P  '
     C     IMWHSE        OREQ      'S  '
     C     TOWHSE        IFEQ      'D  '
     C     TOWHSE        OREQ      'L  '
     C                   MOVEL     IMLOOK        LOOK14           14
     C                   MOVEL     IMWHSE        IMLOOK
     C                   MOVE      LOOK14        IMLOOK
     C                   ENDIF
     C                   ENDIF
      ** GET TYPE OUT OF ALPHA
     C     TOWHSE        IFEQ      'D  '
     C     TOWHSE        OREQ      'L  '
     C     IMWHSE        IFEQ      'F  '
     C     IMWHSE        OREQ      'P  '
     C     IMWHSE        OREQ      'S  '
     C                   MOVE      IMLOOK        LOOK14           14
     C                   MOVE      *BLANKS       IMLOOK
     C                   MOVEL     LOOK14        IMLOOK
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     TOWHSE        IMWHSE
     C                   WRITE     RMINVT
     C     KEY18         CHAIN     FMINVT                             91
     C                   ENDSR
      *********
      * CLRIT
      *********
     C     CLRIT         BEGSR
     C                   MOVEL     *BLANKS       VITEM
     C                   MOVEL     *BLANKS       OVITEM
      ***                  MOVEL*BLANKS   VSIZE
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       VREF
     C                   MOVEL     *BLANKS       OREF
     C                   MOVEL     *BLANKS       OREPO
     C                   MOVEL     *BLANKS       OTUOM
     C                   Z-ADD     0             ITTQTY
     C                   Z-ADD     0             VCOST
     C                   Z-ADD     0             COST
     C                   Z-ADD     0             VVEND
     C                   Z-ADD     0             OVEND
     C                   Z-ADD     0             OQTY
     C                   MOVEL     *BLANKS       VNAME
     C                   MOVEL     *BLANKS       VCOMM
     C                   MOVEL     *BLANKS       OCOMM
     C                   MOVEL     *BLANKS       VVITEM
     C                   MOVEL     *BLANKS       OVITEM
     C                   MOVEL     *BLANKS       VUORE
     C                   MOVEL     *BLANKS       OUORE
     C                   ENDSR
      *********
      * GETDES
      *********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             50
     C                   ENDSR
      **********
      * CLCST  *
      **********
      *  EXTEND COST BASED ON INPUT INFORMATION
     C     CLCST         BEGSR
      *
     C   21              EXSR      CSTDV
      *
     C                   ENDSR
      *  ***********
      *  * CSTDV   *
      *  ***********
      *
     C     CSTDV         BEGSR
      *
     C                   MOVE      ITTUOM        #WRFUM
     C                   Z-ADD     VCOST         #WRFPR
     C                   EXSR      #CVPR
      *
      *            TEST FOR COST DEVIATION
      *            BYPASS COST DEVIATION TEST IF COMPANY
      *            NUMBER IS EQUAL TO ZERO
      *            47 WILL BE ON IF A COST DEVIATION EXISTS
      *
     C*          CONSDV    COMP 0                        46
     C* N46      IMLCST    COMP 0                        46
     C* N46      #WPR1     DIV  IMLCST    CSTDEV  94
     C* N46      CSTDEV    COMP 1                    47
     C* N46 47   CSTDEV    SUB  1         CSTDEV
     C* N46 47   CSTDEV    MULT 100       CSTDEV
     C* N46 47   CSTDEV    COMP CONSDV               47
      *
     C                   ENDSR
      *
      *  ***********
      *  * #CVPR   *
      *  ***********
      *
      * CONVERT PRICE TO PRICE IN ALTERNATE UNITS OF MEASURE
      * LOAD PRICE INTO FIELD #WRFPR
      * LOAD UNIT OF MEASURE INTO #WRFUM
      *
     C     #CVPR         BEGSR
     C     *LIKE         DEFINE    IMSEL1        #WRFPR
     C     *LIKE         DEFINE    IMSEL1        #WPR1
     C     *LIKE         DEFINE    IMSEL1        #WPR2
     C     *LIKE         DEFINE    IMSEL1        #WPR3
     C     *LIKE         DEFINE    IMPUOM        #WRFUM
      *
     C                   Z-ADD     0             #WPR1
     C                   Z-ADD     0             #WPR2
     C                   Z-ADD     0             #WPR3
      *
     C     #WRFUM        IFEQ      IMPUOM
     C                   Z-ADD     #WRFPR        #WPR1
     C                   ENDIF
     C     IMSUOM        IFNE      *BLANKS
     C     #WRFPR        DIV(H)    IMMULT        #WPR2
     C                   ENDIF
     C     IM3UOM        IFNE      *BLANKS
     C     #WPR2         DIV(H)    IMMUL2        #WPR3
     C                   ENDIF
      *
     C     #WRFUM        IFEQ      IMSUOM
     C                   Z-ADD     #WRFPR        #WPR2
     C     #WPR2         MULT(H)   IMMULT        #WPR1
     C                   ENDIF
     C     IM3UOM        IFNE      *BLANKS
     C     #WPR2         DIV(H)    IMMUL2        #WPR3
     C                   ENDIF
      *
     C     #WRFUM        IFEQ      IM3UOM
     C                   Z-ADD     #WRFPR        #WPR3
     C     #WRFPR        MULT(H)   IMMUL2        #WPR2
     C     #WPR2         MULT(H)   IMMULT        #WPR1
     C                   ENDIF
      *
     C                   ENDSR
      **********
      * #AVGC  *
      **********
      *
      *  SUBROUTINE CALCULATES AVERAGE COST - MODIFIED TO HANDLE CASH ONLY ADJ.
      *       PASS RECEIPT QUANTITY INTO A FIELD - WRK190
      *       PASS RECEIPT COST INTO A FIELD - WRK194
      *       SUBROUTINE ASSUMES ITEM MASTER RECORD TO BE UPDATED
      *       HAS ALREADY BEEN CHAINED.
      *       CASH ONLY ADJ ON NEGATIVE QTY. ON HAND YIELDS UNPREDICTABLE
      *       RESULT.
      *       NEGATIVE ON HAND FORCES COST OF RECEIPT TO BE NEW AVERAGE COST
      *       NEGATVIE QTY. ON HAND AFTER RECEIPT FORCES COST ON HAND TO ZERO
      *
     C     #AVGC         BEGSR
     C                   Z-ADD     #PRQTY        WRKQTH           11 1
     C                   Z-ADD     WRKQTH        WRK290           11 1
     C     WRKQTH        ADD       WRK190        WRKQTH
      *
     C     WRK290        IFGT      0
     C     WRK290        MULT      IMUCST        WR1134           13 4
     C*  22 65             Z-ADD1         WRK190
     C     WRK190        MULT      WRK194        WR2134           13 4
     C*  22 65             Z-ADD0         WRK190
     C     WR1134        ADD       WR2134        WR2134
     C     WRK190        ADD       WRK290        WRK290
     C     WR2134        DIV(H)    WRK290        IMUCST
     C     WRKQTH        MULT(H)   IMUCST        IMCSOH
     C                   ELSE
     C                   Z-ADD     WRK194        IMUCST
     C                   ENDIF
     C     WRKQTH        IFGT      0
     C     WRKQTH        MULT(H)   IMUCST        IMCSOH
     C                   ELSE
     C                   Z-ADD     0             IMCSOH
     C                   ENDIF
      *
     C                   Z-ADD     0             WRK190           11 1
     C                   Z-ADD     0             WRK194            9 4
      *
     C     E#AVGC        ENDSR
      *
      *  ***********
      *  * #CVQT   *
      *  ***********
      *
      * QUANITITY CONVERSION SUBROUTINE
      * #WRFUM - CONTAINS ENTERED UNIT OF MEASURE
      * #WRFQT - CONTAINS ENTERED QUANITITY
      *
     C     #CVQT         BEGSR
     C*          *LIKE     DEFN IMQTOH    #WQT1
     C*          *LIKE     DEFN IMQTOH    #WQT2
     C*          *LIKE     DEFN IMQTOH    #WQT3
     C*          *LIKE     DEFN IMUWGT    #WQT#
     C*          *LIKE     DEFN IMUWGT    #WQR#
     C*          *LIKE     DEFN IMUWGT    WKWGT2
     C*          *LIKE     DEFN IMUWGT    WKWGT3
     C*          *LIKE     DEFN IMQTOH    #WRFQT
     C*          *LIKE     DEFN IMPUOM    #WRFUM
      *
      *  UNIT OF MEASURE EQUAL TO PRIMARY UNIT OF MEASURE
      *
     C*          #WRFUM    IFEQ IMPUOM
      *
     C*                    Z-ADD#WRFQT    #WQT1
     C*                    Z-ADDIMUWGT    #WQR#
     C*          #WRFQT    MULT IMUWGT    #WQT#     H
      *
     C*          IMSUOM    IFNE *BLANKS
     C*          #WQT1     MULT IMMULT    #WQT2     H
     C*                    ENDIF
      *
     C*          IM3UOM    IFNE *BLANKS
     C*          #WQT2     MULT IMMUL2    #WQT3     H
     C*                    ENDIF
      *
     C*                    END
      *
      *  UNIT OF MEASURE EQUAL TO SECONDARY UNIT OF MEASURE
      *
     C*          IMSUOM    IFGT *BLANKS
     C*          #WRFUM    IFEQ IMSUOM
      *
     C*          IMUWGT    DIV  IMMULT    WKWGT2    H
     C*                    Z-ADDWKWGT2    #WQR#
     C*                    Z-ADD#WRFQT    #WQT2
     C*          #WQT2     MULT WKWGT2    #WQT#     H
      *
     C*          #WQT2     DIV  IMMULT    #WQT1     H
      *
     C*          IM3UOM    IFNE *BLANKS
      *
     C*          #WQT2     MULT IMMUL2    #WQT3     H
      *
     C*                    END
      *
     C*                    END
     C*                    END
      *
      *  UNIT OF MEASURE EQUAL TO THIRD UNIT OF MEASURE
      *
     C*          IM3UOM    IFGT *BLANKS
     C*          #WRFUM    IFEQ IM3UOM
      *
     C*          IMUWGT    DIV  IMMULT    WKWGT2    H
     C*          WKWGT2    DIV  IMMUL2    WKWGT3    H
     C*                    Z-ADDWKWGT3    #WQR#
      *
     C*                    Z-ADD#WRFQT    #WQT3
     C*          #WQT3     MULT WKWGT3    #WQT#     H
      *
     C*          #WQT3     DIV  IMMUL2    #WQT2     H
      *
     C*          #WQT2     DIV  IMMULT    #WQT1     H
      *
     C*                    END
     C*                    END
      *
     C                   ENDSR
      *
     C     #AJOH         BEGSR
      *  ADD TO ON HAND FIELD FOR A GIVEN QUANTITY AND UNIT OF MEASURE
      *
      *  ***********
      *  * #AJOH   *
      *  ***********
      *
     C*          *LIKE     DEFN IMQTOH    #WRFRQ
     C*          *LIKE     DEFN IMPUOM    #WRFUM
     C*          *LIKE     DEFN IMQTOH    #WOH1
     C*          *LIKE     DEFN IMQTOH    #WOH2
     C*          *LIKE     DEFN IMQTOH    #WOH3
      *
     C*          #WRFUM    IFEQ IMPUOM
     C*                    ADD  #WRFRQ    #WOH1
     C*                    END
     C*          #WRFUM    IFEQ IMSUOM
     C*                    ADD  #WRFRQ    #WOH2
     C*                    END
     C*          #WRFUM    IFEQ IM3UOM
     C*                    ADD  #WRFRQ    #WOH3
     C*                    END
      *
     C                   ENDSR
      *
     C     #UPAV         BEGSR
     C*
     C*  UPDATE QUANTITY AVAILABLE - SUBROUTINE ASSUMES QUANTITY ON HAND
     C*  IS CONTAINED IN FIELDS #WOH1, #WOH2, #WOH3
     C*
     C*  ***********
     C*  * #UPAV   *
     C*  ***********
     C*
     C*
     C     #WOH1         SUB       IMQTAL        IMQTAV
     C*          #WOH2     SUB  IMALC2    IMAVA2
     C*          #WOH3     SUB  IMALC3    IMAVA3
     C*
     C                   ENDSR
      *
      *  SUBROUTINE ROLLS UP QUANTITY ON HAND TO PRIMARY UNIT OF MEASURE
      *  QUANTITY ON HAND IN EACH UNIT OF MEASURE NEEDS TO BE LOADED
      *  INTO FIELDS #WOH1, #WOH2, #WOH3
      *  SUBROUTINE ASSUMES AVAILABILITY OF MULTIPLIERS FROM MINVT
      *
      *  ***********
      *  * #RUOH   *
      *  ***********
      *
     C     #RUOH         BEGSR
      *
     C                   Z-ADD     0             WKRES            11 0
     C     *LIKE         DEFINE    IMQTOH        WKREM
     C     *LIKE         DEFINE    IMQTOH        #WOH1
     C     *LIKE         DEFINE    IMQTOH        #WOH2
     C     *LIKE         DEFINE    IMQTOH        #WOH3
      *
      *  DETERMINE IF QUANTITY CONSOLIDATION IS IN EFFECT
      *
     C     IMCNSF        IFEQ      'Y'
      *
     C     #WOH3         IFGE      IMMUL2
      *
     C     IMMUL2        IFNE      0
      *
     C     #WOH3         DIV       IMMUL2        WKRES
     C                   MVR                     WKREM
     C                   Z-ADD     WKREM         #WOH3
     C                   ADD       WKRES         #WOH2
      *
     C                   END
      *
     C                   END
      *
     C     #WOH2         IFGE      IMMULT
      *
     C     IMMULT        IFNE      0
      *
     C     #WOH2         DIV       IMMULT        WKRES
     C                   MVR                     WKREM
     C                   Z-ADD     WKREM         #WOH2
     C                   ADD       WKRES         #WOH1
      *
     C                   END
     C                   END
     C                   END
      *
     C                   ENDSR
      *
     C     #RDOH         BEGSR
      *
      *  ROLL DOWN QUANTITY ON HAND TO MEET QUANTITY REQUIREMENT
      *  LOAD QUANTITY REQUIRED INTO FIELD #WRFRQ
      *  LOAD REQUIRED IN UNIT OF MEASURE TO FIELD #WRFUM
      *
      *  ***********
      *  * #RDOH   *
      *  ***********
      *
     C     *LIKE         DEFINE    IMQTOH        #WRFRQ
     C*          *LIKE     DEFN IMPUOM    #WRFUM
     C     *LIKE         DEFINE    IMQTOH        #WOH1A
     C     *LIKE         DEFINE    IMQTOH        #WOH2A
     C     *LIKE         DEFINE    IMQTOH        #WOH3A
      *
     C     #WRFUM        IFEQ      IMPUOM
     C     #WOH1A        SUB       #WRFRQ        #WOH1A
     C                   END
      *
      *  DETERMINE IF QTY. CONSOLIDATION IS ACTIVE
      *
     C     IMCNSF        IFEQ      'Y'
      *
     C     #WRFUM        IFEQ      IMSUOM
      *
     C     #WOH2A        DOWLT     #WRFRQ
     C                   ADD       IMMULT        #WOH2A
     C                   SUB       1             #WOH1A
     C                   END
      *
     C     #WOH2A        SUB       #WRFRQ        #WOH2A
      *
     C                   END
      *
     C     #WRFUM        IFEQ      IM3UOM
      *
     C     #WOH3A        DOWLT     #WRFRQ
     C                   ADD       IMMUL2        #WOH3A
     C     #WOH2A        DOWLT     1
     C                   ADD       IMMULT        #WOH2A
     C                   SUB       1             #WOH1A
     C                   END
     C                   SUB       1             #WOH2A
     C                   END
      *
     C     #WOH3A        SUB       #WRFRQ        #WOH3A
      *
     C                   END
      *
     C                   ELSE
      *
      *  QUANTITY CONSOLIDATION NOT IN EFFECT
      *
     C     #WRFUM        IFEQ      IMSUOM
     C     #WOH2A        SUB       #WRFRQ        #WOH2A
     C                   END
     C     #WRFUM        IFEQ      IM3UOM
     C     #WOH3A        SUB       #WRFRQ        #WOH3A
     C                   END
      *
     C                   END
     C                   ENDSR
      *
     C     #PRUM         BEGSR
      *  #PRUM - PRIMARY UNIT OF MEASURE QUANTITY ROUTINE
      *  CONVERTS QUANTITIES IN ALL UNITS OF MEASURE
      *  INTO THE PRIMARY UNIT OF MEASURE.
      *  ITEM MASTER QUANTITY FIELDS MUST BE Z-ADDED INTO
      *  #QTY1, #QTY2, #QTY3 BEFORE EXECUTING SUBROUTINE.
      *  OUTPUT FIELD IS #PRQTY
      *
     C     *LIKE         DEFINE    IMQTOH        #QTY1
     C     *LIKE         DEFINE    IMQ2OH        #QTY2
     C     *LIKE         DEFINE    IMQ3OH        #QTY3
     C     *LIKE         DEFINE    IMQTOH        #PRQTY
     C     *LIKE         DEFINE    IMQTOH        #WK1
     C     *LIKE         DEFINE    IMQTOH        #WK2
      *
     C                   Z-ADD     0             #WK1
     C                   Z-ADD     0             #WK2
      *
     C                   Z-ADD     #QTY1         #PRQTY
      *
     C     #QTY3         IFNE      0
     C     IMMUL2        IFNE      0
      *
     C     #QTY3         DIV(H)    IMMUL2        #WK2
     C     #WK2          ADD       #QTY2         #QTY2
      *
     C                   END
     C                   END
      *
     C     #QTY2         IFNE      0
     C     IMMULT        IFNE      0
      *
     C     #QTY2         DIV(H)    IMMULT        #WK1
      *
     C                   END
     C                   END
      *
     C                   ADD       #WK1          #PRQTY
      *
     C                   ENDSR
      *********
      * UOMSR
      *********
     C     UOMSR         BEGSR
     C                   MOVEL     VUNIT         UNCODE            2
     C                   CALL      'LKUOM'
     C                   PARM                    UNCODE
     C                   PARM                    UNDESC           30
     C                   MOVEL     *BLANKS       VUNIT
     C                   MOVEL     UNCODE        VUNIT
     C                   ENDSR
      *
      *********
      * ITSGONE
      *********
     C     ITSGONE       BEGSR
      /Free

         Exec SQL
           Update FMORLS
           Set    OLNOTE = 'GONE'
           ,      OLRDYC = 'GONE'
           Where  OLITEM = :VITEM
             and  OLSIZE = :VSIZE;

      /End-Free
     C                   ENDSR
