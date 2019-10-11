      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 2000
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ICR21A
      *APPLICATION--------- INVENTORY
      *DESCRIPTION--------- ITEM BALANCE LOCATOR
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 7/14/00 EFD01 ZERO OUT AVERAGE PRICE
      *
      *
     FICR21AFM  CF   E             WORKSTN
     F                                     SFILE(PORSFL:RECNO)
     F                                     SFILE(LOCSFL:RECN1)
     F                                     SFILE(LOTSFL:RECN2)
     FFMINVT    IF   E           K DISK
     FFSHISTS   IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFQDISC    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFDLOTRDR  IF   E           K DISK
      *
     D CS$             S              9  2 DIM(13)
     D CC$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D PC$             S              9  2 DIM(13)
     D SVR             S              6  2 DIM(13)
     D QVR             S              6  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
      *
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
      ** SHIST ARRAYS
     IRSHISTS
     I              SHCQ01                      CSQ(1)
     I              SHCQ02                      CSQ(2)
     I              SHCQ03                      CSQ(3)
     I              SHCQ04                      CSQ(4)
     I              SHCQ05                      CSQ(5)
     I              SHCQ06                      CSQ(6)
     I              SHCQ07                      CSQ(7)
     I              SHCQ08                      CSQ(8)
     I              SHCQ09                      CSQ(9)
     I              SHCQ10                      CSQ(10)
     I              SHCQ11                      CSQ(11)
     I              SHCQ12                      CSQ(12)
     I              SHCQ13                      CSQ(13)
      *
     I              SHLQ01                      PSQ(1)
     I              SHLQ02                      PSQ(2)
     I              SHLQ03                      PSQ(3)
     I              SHLQ04                      PSQ(4)
     I              SHLQ05                      PSQ(5)
     I              SHLQ06                      PSQ(6)
     I              SHLQ07                      PSQ(7)
     I              SHLQ08                      PSQ(8)
     I              SHLQ09                      PSQ(9)
     I              SHLQ10                      PSQ(10)
     I              SHLQ11                      PSQ(11)
     I              SHLQ12                      PSQ(12)
     I              SHLQ13                      PSQ(13)
      *
     I              SHCS01                      CS$(1)
     I              SHCS02                      CS$(2)
     I              SHCS03                      CS$(3)
     I              SHCS04                      CS$(4)
     I              SHCS05                      CS$(5)
     I              SHCS06                      CS$(6)
     I              SHCS07                      CS$(7)
     I              SHCS08                      CS$(8)
     I              SHCS09                      CS$(9)
     I              SHCS10                      CS$(10)
     I              SHCS11                      CS$(11)
     I              SHCS12                      CS$(12)
     I              SHCS13                      CS$(13)
      *
     I              SHLS01                      PS$(1)
     I              SHLS02                      PS$(2)
     I              SHLS03                      PS$(3)
     I              SHLS04                      PS$(4)
     I              SHLS05                      PS$(5)
     I              SHLS06                      PS$(6)
     I              SHLS07                      PS$(7)
     I              SHLS08                      PS$(8)
     I              SHLS09                      PS$(9)
     I              SHLS10                      PS$(10)
     I              SHLS11                      PS$(11)
     I              SHLS12                      PS$(12)
     I              SHLS13                      PS$(13)
      *
     I              SHCC01                      CC$(1)
     I              SHCC02                      CC$(2)
     I              SHCC03                      CC$(3)
     I              SHCC04                      CC$(4)
     I              SHCC05                      CC$(5)
     I              SHCC06                      CC$(6)
     I              SHCC07                      CC$(7)
     I              SHCC08                      CC$(8)
     I              SHCC09                      CC$(9)
     I              SHCC10                      CC$(10)
     I              SHCC11                      CC$(11)
     I              SHCC12                      CC$(12)
     I              SHCC13                      CC$(13)
      *
     I              SHLC01                      PC$(1)
     I              SHLC02                      PC$(2)
     I              SHLC03                      PC$(3)
     I              SHLC04                      PC$(4)
     I              SHLC05                      PC$(5)
     I              SHLC06                      PC$(6)
     I              SHLC07                      PC$(7)
     I              SHLC08                      PC$(8)
     I              SHLC09                      PC$(9)
     I              SHLC10                      PC$(10)
     I              SHLC11                      PC$(11)
     I              SHLC12                      PC$(12)
     I              SHLC13                      PC$(13)
      *
      * MAIN FLOW OF PROGRAM
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DESHFR        VSHFR
      *
     C     RSTRT         TAG
     C                   SETOFF                                       99
     C                   Z-ADD     0             ONHAND
     C                   Z-ADD     0             AVAIL
     C                   Z-ADD     0             AVAOPO
     C                   Z-ADD     0             AVGPRC
     C                   Z-ADD     0             MTDPRF
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       VITEM
     C                   MOVEL     *BLANKS       VSIZE
     C                   MOVEL     *BLANKS       VSHFR
     C                   MOVEL     'N'           VROLL
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102040
      *
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C     1             SUBST     VITEM:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     VITEM:2       IMLOOK
     C                   MOVEL     VSHFR         IMWHSE
     C                   MOVEL     VSIZE         IMSIZE
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
     C                   MOVEL     IMWHSE        VSHFR
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C                   MOVEL     VSIZE         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     VSIZE         SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       VSIZE
     C                   MOVEL     SZCODE        VSIZE
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C                   MOVEL     VSHFR         TST1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     VSHFR         VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         VSHFR
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     KEY18         CHAIN     FMINVT                             90
     C   90              SETON                                        10
     C   10              GOTO      RSTRTA
      *
     C     VSHFR         IFGT      *BLANKS
     C     VSHFR         CHAIN     FMWHSE                             91
     C   91              SETON                                        20
     C   20              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VROLL         IFNE      'Y'
     C     VROLL         ANDNE     'N'
     C                   SETON                                        40
     C   40              GOTO      RSTRTA
     C                   ENDIF
      *
     C                   EXSR      GETDES
     C                   EXSR      GETDTA
      *
     C     RSTRTB        TAG
     C                   MOVEL     VITEM         OLITEM           12
     C                   MOVEL     VSIZE         OLSIZE            3
     C                   MOVEL     VSHFR         OLSHFR            3
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       1030
     C                   SETOFF                                       40
      *
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              GOTO      EOJ
     C   KF              GOTO      RSTRT
      *
     C   KA              DO
     C     KEYC          CHAIN     FQDISC                             91
     C                   GOTO      RSTRTD
     C                   ENDDO
      *
     C   KB              DO
     C                   EXSR      SALES
     C                   ENDDO
      *
     C   KD              EXSR      GETLOT
     C   KH              GOTO      RSTRTI
     C   KE              GOTO      RSTRTJ
      *
     C     1             SUBST     VITEM:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     VITEM:2       IMLOOK
     C                   MOVEL     VSHFR         IMWHSE
     C                   MOVEL     VSIZE         IMSIZE
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
     C                   MOVEL     IMWHSE        VSHFR
     C*                    GOTO NXTB
     C                   ENDIF
      *
     C     VITEM         IFNE      OLITEM
     C     VSIZE         ORNE      OLSIZE
     C     VSHFR         ORNE      OLSHFR
     C                   EXSR      GETITM
     C   10              GOTO      NXTB
     C  N10              GOTO      RSTRTB
     C                   ENDIF
      *
     C                   GOTO      RSTRT
      *
     C     RSTRTD        TAG
      *
     C                   WRITE     SCRND
     C                   READ      SCRND                                  90
     C   KB              GOTO      RSTRTB
     C   KC
     COR KG              GOTO      EOJ
     C   KE              GOTO      RSTRTJ
     C   KF              GOTO      RSTRT
      *
     C                   GOTO      RSTRTB
      *
     C     RSTRTE        TAG
      *
     C                   WRITE     SCRNE
      *
     C                   READ      SCRNE                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C   KB              GOTO      RSTRTB
     C   KH              GOTO      RSTRTF
     C   KI              GOTO      RSTRTG
      *
     C   KA              DO
     C     KEYC          CHAIN     FQDISC                             91
     C                   GOTO      RSTRTD
     C                   ENDDO
      *
     C                   GOTO      RSTRTB
      *
     C     RSTRTF        TAG
      *
     C                   WRITE     SCRNF
     C                   READ      SCRNF                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C   KA              DO
     C     KEYC          CHAIN     FQDISC                             91
     C                   GOTO      RSTRTD
     C                   ENDDO
     C   KC
     COR KG              GOTO      EOJ
     C   KB              GOTO      RSTRTB
     C   KE              GOTO      RSTRTJ
     C   KF              GOTO      RSTRT
     C   KI              GOTO      RSTRTG
      *
     C                   GOTO      RSTRT
      *
     C     RSTRTG        TAG
      *
     C                   WRITE     SCRNG
      *
     C                   READ      SCRNG                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C   KA              DO
     C     KEYC          CHAIN     FQDISC                             91
     C                   GOTO      RSTRTD
     C                   ENDDO
     C   KB              GOTO      RSTRTB
     C   KE              GOTO      RSTRTJ
     C   KF              GOTO      RSTRTA
     C                   GOTO      RSTRTB
      *
     C     RSTRTI        TAG
     C                   MOVE      '1'           *IN80
     C                   WRITE     PORCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   SETOFF                                       90
      *
     C                   ADD       1             RECNO
     C                   WRITE     PORSFL
     C*                    GOTO NXTI
      *
     C*          DSPL      TAG
     C*          RECNO     IFEQ 0
     C*                    SETON                     8014
     C*                    GOTO RSTRT
     C*                    ENDIF
     C*                    ADD  2         RECNO
     C*                    Z-ADD0         OHORD#
     C*                    Z-ADD0         OHDTOR
     C*                    MOVEL*ZEROS    OICUST
     C*                    MOVEL*BLANKS   OIITEM
     C*                    MOVEL*BLANKS   OISIZE
     C*                    MOVEL*BLANKS   DESC
     C*                    MOVEL*BLANKS   OIUUOM
     C*                    MOVEL*BLANKS   OISHFR
     C*                    MOVEL*BLANKS   OIPHYT
     C*                    MOVEL*BLANKS   NAME
     C*                    Z-ADDTOTQTY    QTY
     C*                    Z-ADDTOTSHP    SHP
     C*                    Z-ADD0         OIDTRQ
     C*                    MOVEL*BLANKS   SHIPD
     C*                    MOVEL'* End of'DESC1  16
     C*                    MOVE ' Data * 'DESC1
     C*                    MOVELDESC1     NAME
     C*                    WRITERECSFL
     C*                    EXFMTRECCTL
     C   KC
     COR KG              GOTO      EOJ
     C                   GOTO      RSTRT
      *
     C     RSTRTJ        TAG
     C     LOCKEY        KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C     LOCKEY        SETLL     FMINVT
     C                   MOVE      '1'           *IN80
     C                   WRITE     LOCCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECN1             5 0
      *
     C                   SETOFF                                       90
      *
     C     NXTL          TAG
     C     LOCKEY        READE     FMINVT                                 90
     C   90              GOTO      DSPL2
     C     IMCOMP        IFNE      LCO                                                      #
     C                   GOTO      NXTL
     C                   ENDIF
      *
     C                   MOVEL     IMWHSE        WSE
     C     IMWHSE        CHAIN     FMWHSE                             91
     C                   MOVEL     WHDESC        WDES             12
     C                   Z-ADD     IMQTOH        WOH
     C                   Z-ADD     IMQTOO        WOO
     C                   Z-ADD     IMQTAL        WOSO
     C     WOH           SUB       WOSO          WAV
     C     WAV           ADD       WOO           WAOR
      *
     C                   ADD       WOH           TWOH             10 0
     C                   ADD       WOO           TWOO             10 0
     C                   ADD       WOSO          TWOSO            10 0
     C                   ADD       WAV           TWAV             10 0
     C                   ADD       WAOR          TWAOR            10 0
      *
     C                   ADD       1             RECN1
     C                   WRITE     LOCSFL
     C                   GOTO      NXTL
      *
     C     DSPL2         TAG
     C                   ADD       2             RECN1
     C                   Z-ADD     0             WOH
     C                   Z-ADD     0             WOO
     C                   Z-ADD     0             WOSO
     C                   Z-ADD     0             WAV
     C                   Z-ADD     0             WAOR
     C                   Z-ADD     TWOH          WOH
     C                   Z-ADD     TWOO          WOO
     C                   Z-ADD     TWOSO         WOSO
     C                   Z-ADD     TWAV          WAV
     C                   Z-ADD     TWAOR         WAOR
     C                   MOVEL     *BLANKS       WSE
     C                   MOVEL     *BLANKS       WDES
     C                   MOVEL     '** Total'    DESC1            12
     C                   MOVE      's **'        DESC1
     C                   MOVE      DESC1         WDES
     C                   WRITE     LOCSFL
     C                   ADD       1             PCNT              2 0
     C                   ADD       1             FCNT              2 0
     C                   EXFMT     LOCCTL
     C   KB              GOTO      RSTRTB
     C   KF              GOTO      RSTRT
     C                   GOTO      RSTRTB
      *
     C     EOJ           TAG
     C                   SETON                                        LR
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
     C                   MOVEL     DESCO         DESC             55
     C                   ENDSR
      *
      **********
      * GETDTA
      **********
      * SCRNB FIELDS
      *
     C     GETDTA        BEGSR
     C                   Z-ADD     IMQTAV        AVAIL            10 0
     C                   ADD       IMQTAV        AVAOPO           10 0
     C                   ADD       IMQTOO        AVAOPO
     C                   Z-ADD     IMQTOH        ONHAND           10 0
     C                   Z-ADD     IMQTOO        QTONPO           10 0
     C                   Z-ADD     IMQTAL        ALLOC            10 0
      *
     C                   Z-ADD     IMQMTD        MTDQTY           10 0
      *
     C     MTDQTY        IFGT      0
     C     IM$MTD        ANDGT     0
     C     IM$MTD        DIV       MTDQTY        AVGPRC            9 2
     C                   ENDIF
      *
     C                   Z-ADD     IMMREC        MTDREC           10 0
     C                   Z-ADD     IMISSU        MTDISS           10 0
     C                   Z-ADD     IMMADJ        MTDADJ           10 0
     C                   Z-ADD     IMQEOQ        MTDROP           10 0
     C                   Z-ADD     IMQREO        MTDROQ           10 0
      *
     C     IM$MTD        SUB       IMCMTD        MTDPRF            9 2
      *
     C                   Z-ADD     IMSEL1        SELPR1            7 2
     C                   Z-ADD     IMSEL2        SELPR2            7 2
     C                   Z-ADD     IMSEL3        SELPR3            7 2
     C                   Z-ADD     IMSEL4        SELPR4            7 2
     C                   Z-ADD     IMSEL5        SELPR5            7 2
      *
     C                   Z-ADD     IMQLB1        QTYBR1           10 0
     C                   Z-ADD     IMQLB2        QTYBR2           10 0
     C                   Z-ADD     IMQLB3        QTYBR3           10 0
     C                   Z-ADD     IMQLB4        QTYBR4           10 0
     C                   Z-ADD     IMQLB5        QTYBR5           10 0
      *
     C                   ENDSR
      *********
      * LOCSR
      *********
     C     LOCSR         BEGSR
     C                   MOVEL     VWHSE         WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       VWHSE
     C                   MOVEL     WHWHSE        VWHSE
     C                   MOVEL     WHDESC        VDESC            30
     C                   ENDSR
      *
      *********
      * SALES
      *********
     C     SALES         BEGSR
      *
     C                   Z-ADD     0             CAVG01
     C                   Z-ADD     0             CAVG02
     C                   Z-ADD     0             CAVG03
     C                   Z-ADD     0             CAVG04
     C                   Z-ADD     0             CAVG05
     C                   Z-ADD     0             CAVG06
     C                   Z-ADD     0             CAVG07
     C                   Z-ADD     0             CAVG08
     C                   Z-ADD     0             CAVG09
     C                   Z-ADD     0             CAVG10
     C                   Z-ADD     0             CAVG11
     C                   Z-ADD     0             CAVG12
     C                   Z-ADD     0             CAVG13
     C                   Z-ADD     0             LAVG01
     C                   Z-ADD     0             LAVG02
     C                   Z-ADD     0             LAVG03
     C                   Z-ADD     0             LAVG04
     C                   Z-ADD     0             LAVG05
     C                   Z-ADD     0             LAVG06
     C                   Z-ADD     0             LAVG07
     C                   Z-ADD     0             LAVG08
     C                   Z-ADD     0             LAVG09
     C                   Z-ADD     0             LAVG10
     C                   Z-ADD     0             LAVG11
     C                   Z-ADD     0             LAVG12
     C                   Z-ADD     0             LAVG13
     C                   Z-ADD     0             TCAVG
     C                   Z-ADD     0             TLAVG
      *
     C                   Z-ADD     LCO           SHCOMP
     C                   Z-ADD     0             SHCUST
     C                   MOVEL     VITEM         SHITEM
     C                   MOVEL     VSIZE         SHSIZE
     C                   MOVEL     *BLANKS       SHSLSM
     C     KEY25         KLIST
     C                   KFLD                    SHCUST
     C                   KFLD                    SHITEM
     C                   KFLD                    SHSIZE
     C                   KFLD                    SHSLSM
     C                   KFLD                    SHCOMP
     C     KEY25         CHAIN     FSHISTS                            92
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUEQ     13
     C     CS$(X)        IFGT      0
     C     PS$(X)        ANDGT     0
     C     CS$(X)        SUB       PS$(X)        DIFF              9 2
     C     DIFF          DIV       PS$(X)        PER               6 4
     C     PER           MULT      100           SVR(X)            6 2
     C                   ENDIF
     C     CS$(X)        IFGT      0
     C     PS$(X)        ANDEQ     0
     C                   Z-ADD     100.00        SVR(X)
     C                   ENDIF
     C     CS$(X)        IFEQ      0
     C     PS$(X)        ANDGT     0
     C                   Z-SUB     100.00        SVR(X)
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   Z-ADD     CS$(1)        SHCS01            9 2
     C                   Z-ADD     CS$(2)        SHCS02            9 2
     C                   Z-ADD     CS$(3)        SHCS03            9 2
     C                   Z-ADD     CS$(4)        SHCS04            9 2
     C                   Z-ADD     CS$(5)        SHCS05            9 2
     C                   Z-ADD     CS$(6)        SHCS06            9 2
     C                   Z-ADD     CS$(7)        SHCS07            9 2
     C                   Z-ADD     CS$(8)        SHCS08            9 2
     C                   Z-ADD     CS$(9)        SHCS09            9 2
     C                   Z-ADD     CS$(10)       SHCS10            9 2
     C                   Z-ADD     CS$(11)       SHCS11            9 2
     C                   Z-ADD     CS$(12)       SHCS12            9 2
     C                   Z-ADD     CS$(13)       SHCS13            9 2
      *
     C                   Z-ADD     PS$(1)        SHLS01            9 2
     C                   Z-ADD     PS$(2)        SHLS02            9 2
     C                   Z-ADD     PS$(3)        SHLS03            9 2
     C                   Z-ADD     PS$(4)        SHLS04            9 2
     C                   Z-ADD     PS$(5)        SHLS05            9 2
     C                   Z-ADD     PS$(6)        SHLS06            9 2
     C                   Z-ADD     PS$(7)        SHLS07            9 2
     C                   Z-ADD     PS$(8)        SHLS08            9 2
     C                   Z-ADD     PS$(9)        SHLS09            9 2
     C                   Z-ADD     PS$(10)       SHLS10            9 2
     C                   Z-ADD     PS$(11)       SHLS11            9 2
     C                   Z-ADD     PS$(12)       SHLS12            9 2
     C                   Z-ADD     PS$(13)       SHLS13            9 2
      *
     C                   Z-ADD     1             S                 2 0
     C     S             DOUEQ     13
     C     SVR(S)        IFEQ      100.00
     C     SVR(S)        OREQ      -100.00
     C                   Z-ADD     0             SVR(S)
     C                   ENDIF
     C                   ADD       1             S
     C                   ENDDO
      *
     C                   Z-ADD     SVR(1)        SV01
     C                   Z-ADD     SVR(2)        SV02
     C                   Z-ADD     SVR(3)        SV03
     C                   Z-ADD     SVR(4)        SV04
     C                   Z-ADD     SVR(5)        SV05
     C                   Z-ADD     SVR(6)        SV06
     C                   Z-ADD     SVR(7)        SV07
     C                   Z-ADD     SVR(8)        SV08
     C                   Z-ADD     SVR(9)        SV09
     C                   Z-ADD     SVR(10)       SV10
     C                   Z-ADD     SVR(11)       SV11
     C                   Z-ADD     SVR(12)       SV12
     C                   Z-ADD     SVR(13)       SV13
      *
     C                   Z-ADD     1             Y                 2 0
     C     Y             DOUEQ     13
     C     CSQ(Y)        IFGT      0
     C     PSQ(Y)        ANDGT     0
     C     CSQ(Y)        SUB       PSQ(Y)        DIFQ             11 1
     C     DIFQ          DIV       PSQ(Y)        PERQ              6 4
     C     PERQ          MULT      100           QVR(Y)            6 2
     C                   ENDIF
     C     CSQ(Y)        IFGT      0
     C     PSQ(Y)        ANDEQ     0
     C                   Z-ADD     100.00        QVR(Y)
     C                   ENDIF
     C     CSQ(Y)        IFEQ      0
     C     PSQ(Y)        ANDGT     0
     C                   Z-SUB     100.00        QVR(Y)
     C                   ENDIF
     C                   ADD       1             Y
     C                   ENDDO
      *
     C                   Z-ADD     CSQ(1)        SHCQ01            7 0
     C                   Z-ADD     CSQ(2)        SHCQ02            7 0
     C                   Z-ADD     CSQ(3)        SHCQ03            7 0
     C                   Z-ADD     CSQ(4)        SHCQ04            7 0
     C                   Z-ADD     CSQ(5)        SHCQ05            7 0
     C                   Z-ADD     CSQ(6)        SHCQ06            7 0
     C                   Z-ADD     CSQ(7)        SHCQ07            7 0
     C                   Z-ADD     CSQ(8)        SHCQ08            7 0
     C                   Z-ADD     CSQ(9)        SHCQ09            7 0
     C                   Z-ADD     CSQ(10)       SHCQ10            7 0
     C                   Z-ADD     CSQ(11)       SHCQ11            7 0
     C                   Z-ADD     CSQ(12)       SHCQ12            7 0
     C                   Z-ADD     CSQ(13)       SHCQ13            7 0
      *
     C                   Z-ADD     PSQ(1)        SHLQ01            7 0
     C                   Z-ADD     PSQ(2)        SHLQ02            7 0
     C                   Z-ADD     PSQ(3)        SHLQ03            7 0
     C                   Z-ADD     PSQ(4)        SHLQ04            7 0
     C                   Z-ADD     PSQ(5)        SHLQ05            7 0
     C                   Z-ADD     PSQ(6)        SHLQ06            7 0
     C                   Z-ADD     PSQ(7)        SHLQ07            7 0
     C                   Z-ADD     PSQ(8)        SHLQ08            7 0
     C                   Z-ADD     PSQ(9)        SHLQ09            7 0
     C                   Z-ADD     PSQ(10)       SHLQ10            7 0
     C                   Z-ADD     PSQ(11)       SHLQ11            7 0
     C                   Z-ADD     PSQ(12)       SHLQ12            7 0
     C                   Z-ADD     PSQ(13)       SHLQ13            7 0
      *
     C                   Z-ADD     1             Q                 2 0
     C     Q             DOUEQ     13
     C     QVR(Q)        IFEQ      100.00
     C     QVR(Q)        OREQ      -100.00
     C                   Z-ADD     0             QVR(Q)
     C                   ENDIF
     C                   ADD       1             Q
     C                   ENDDO
      *
     C                   Z-ADD     QVR(1)        QV01
     C                   Z-ADD     QVR(2)        QV02
     C                   Z-ADD     QVR(3)        QV03
     C                   Z-ADD     QVR(4)        QV04
     C                   Z-ADD     QVR(5)        QV05
     C                   Z-ADD     QVR(6)        QV06
     C                   Z-ADD     QVR(7)        QV07
     C                   Z-ADD     QVR(8)        QV08
     C                   Z-ADD     QVR(9)        QV09
     C                   Z-ADD     QVR(10)       QV10
     C                   Z-ADD     QVR(11)       QV11
     C                   Z-ADD     QVR(12)       QV12
     C                   Z-ADD     QVR(13)       QV13
      *
     C                   XFOOT     CS$           TCSLS
     C                   XFOOT     PS$           TPSLS
     C                   XFOOT     CSQ           TCQTY
     C                   XFOOT     PSQ           TLQTY
      *
     C     TCSLS         IFGT      0
     C     TPSLS         ANDGT     0
     C     TCSLS         SUB       TPSLS         TSDF              9 2
     C     TSDF          DIV       TPSLS         TSPR              6 4
     C     TSPR          MULT      100           TSV               6 2
     C                   ENDIF
     C     TCSLS         IFGT      0
     C     TPSLS         ANDEQ     0
     C                   Z-ADD     100.00        TSV
     C                   ENDIF
     C     TCSLS         IFEQ      0
     C     TPSLS         ANDGT     0
     C                   Z-SUB     100.00        TSV
     C                   ENDIF
      *
     C     TCQTY         IFGT      0
     C     TLQTY         ANDGT     0
     C     TCQTY         SUB       TLQTY         TQDF             11 1
     C     TQDF          DIV       TLQTY         TQPR              6 4
     C     TQPR          MULT      100           TQV               6 2
     C                   ENDIF
     C     TCQTY         IFGT      0
     C     TLQTY         ANDEQ     0
     C                   Z-ADD     100.00        TQV
     C                   ENDIF
     C     TCQTY         IFEQ      0
     C     TLQTY         ANDGT     0
     C                   Z-SUB     100.00        TQV
     C                   ENDIF
      *
     C                   Z-ADD     CC$(1)        SHCC01            9 2
     C                   Z-ADD     CC$(2)        SHCC02            9 2
     C                   Z-ADD     CC$(3)        SHCC03            9 2
     C                   Z-ADD     CC$(4)        SHCC04            9 2
     C                   Z-ADD     CC$(5)        SHCC05            9 2
     C                   Z-ADD     CC$(6)        SHCC06            9 2
     C                   Z-ADD     CC$(7)        SHCC07            9 2
     C                   Z-ADD     CC$(8)        SHCC08            9 2
     C                   Z-ADD     CC$(9)        SHCC09            9 2
     C                   Z-ADD     CC$(10)       SHCC10            9 2
     C                   Z-ADD     CC$(11)       SHCC11            9 2
     C                   Z-ADD     CC$(12)       SHCC12            9 2
     C                   Z-ADD     CC$(13)       SHCC13            9 2
      *
     C                   Z-ADD     PC$(1)        SHLC01            9 2
     C                   Z-ADD     PC$(2)        SHLC02            9 2
     C                   Z-ADD     PC$(3)        SHLC03            9 2
     C                   Z-ADD     PC$(4)        SHLC04            9 2
     C                   Z-ADD     PC$(5)        SHLC05            9 2
     C                   Z-ADD     PC$(6)        SHLC06            9 2
     C                   Z-ADD     PC$(7)        SHLC07            9 2
     C                   Z-ADD     PC$(8)        SHLC08            9 2
     C                   Z-ADD     PC$(9)        SHLC09            9 2
     C                   Z-ADD     PC$(10)       SHLC10            9 2
     C                   Z-ADD     PC$(11)       SHLC11            9 2
     C                   Z-ADD     PC$(12)       SHLC12            9 2
     C                   Z-ADD     PC$(13)       SHLC13            9 2
      *
      * CURRENT YEAR SALES
      *
     C                   Z-ADD     SHCS01        CS01              8 2
     C                   Z-ADD     SHCS02        CS02              8 2
     C                   Z-ADD     SHCS03        CS03              8 2
     C                   Z-ADD     SHCS04        CS04              8 2
     C                   Z-ADD     SHCS05        CS05              8 2
     C                   Z-ADD     SHCS06        CS06              8 2
     C                   Z-ADD     SHCS07        CS07              8 2
     C                   Z-ADD     SHCS08        CS08              8 2
     C                   Z-ADD     SHCS09        CS09              8 2
     C                   Z-ADD     SHCS10        CS10              8 2
     C                   Z-ADD     SHCS11        CS11              8 2
     C                   Z-ADD     SHCS12        CS12              8 2
     C                   Z-ADD     SHCS13        CS13              8 2
      *
      * CURRENT YEAR COSTS
      *
     C                   Z-ADD     SHCC01        CC01              8 2
     C                   Z-ADD     SHCC02        CC02              8 2
     C                   Z-ADD     SHCC03        CC03              8 2
     C                   Z-ADD     SHCC04        CC04              8 2
     C                   Z-ADD     SHCC05        CC05              8 2
     C                   Z-ADD     SHCC06        CC06              8 2
     C                   Z-ADD     SHCC07        CC07              8 2
     C                   Z-ADD     SHCC08        CC08              8 2
     C                   Z-ADD     SHCC09        CC09              8 2
     C                   Z-ADD     SHCC10        CC10              8 2
     C                   Z-ADD     SHCC11        CC11              8 2
     C                   Z-ADD     SHCC12        CC12              8 2
     C                   Z-ADD     SHCC13        CC13              8 2
      *
      * PRIOR YEAR SALES
      *
     C                   Z-ADD     SHLS01        LS01              8 2
     C                   Z-ADD     SHLS02        LS02              8 2
     C                   Z-ADD     SHLS03        LS03              8 2
     C                   Z-ADD     SHLS04        LS04              8 2
     C                   Z-ADD     SHLS05        LS05              8 2
     C                   Z-ADD     SHLS06        LS06              8 2
     C                   Z-ADD     SHLS07        LS07              8 2
     C                   Z-ADD     SHLS08        LS08              8 2
     C                   Z-ADD     SHLS09        LS09              8 2
     C                   Z-ADD     SHLS10        LS10              8 2
     C                   Z-ADD     SHLS11        LS11              8 2
     C                   Z-ADD     SHLS12        LS12              8 2
     C                   Z-ADD     SHLS13        LS13              8 2
      *
      * PRIOR YEAR COSTS
      *
     C                   Z-ADD     SHLC01        LC01              8 2
     C                   Z-ADD     SHLC02        LC02              8 2
     C                   Z-ADD     SHLC03        LC03              8 2
     C                   Z-ADD     SHLC04        LC04              8 2
     C                   Z-ADD     SHLC05        LC05              8 2
     C                   Z-ADD     SHLC06        LC06              8 2
     C                   Z-ADD     SHLC07        LC07              8 2
     C                   Z-ADD     SHLC08        LC08              8 2
     C                   Z-ADD     SHLC09        LC09              8 2
     C                   Z-ADD     SHLC10        LC10              8 2
     C                   Z-ADD     SHLC11        LC11              8 2
     C                   Z-ADD     SHLC12        LC12              8 2
     C                   Z-ADD     SHLC13        LC13              8 2
      *
     C     CS01          SUB       CC01          PL01              8 2
     C     CS02          SUB       CC02          PL02              8 2
     C     CS03          SUB       CC03          PL03              8 2
     C     CS04          SUB       CC04          PL04              8 2
     C     CS05          SUB       CC05          PL05              8 2
     C     CS06          SUB       CC06          PL06              8 2
     C     CS07          SUB       CC07          PL07              8 2
     C     CS08          SUB       CC08          PL08              8 2
     C     CS09          SUB       CC09          PL09              8 2
     C     CS10          SUB       CC10          PL10              8 2
     C     CS11          SUB       CC11          PL11              8 2
     C     CS12          SUB       CC12          PL12              8 2
     C     CS13          SUB       CC13          PL13              8 2
     C     LS01          SUB       LC01          PLL01             8 2
     C     LS02          SUB       LC02          PLL02             8 2
     C     LS03          SUB       LC03          PLL03             8 2
     C     LS04          SUB       LC04          PLL04             8 2
     C     LS05          SUB       LC05          PLL05             8 2
     C     LS06          SUB       LC06          PLL06             8 2
     C     LS07          SUB       LC07          PLL07             8 2
     C     LS08          SUB       LC08          PLL08             8 2
     C     LS09          SUB       LC09          PLL09             8 2
     C     LS10          SUB       LC10          PLL10             8 2
     C     LS11          SUB       LC11          PLL11             8 2
     C     LS12          SUB       LC12          PLL12             8 2
     C     LS13          SUB       LC13          PLL13             8 2
      *
     C                   XFOOT     CS$           TSLS              8 2
     C                   XFOOT     PS$           TPYSLS            8 2
     C                   XFOOT     CC$           TCCOS             8 2
     C                   XFOOT     PC$           TPCOS             8 2
      *
     C     TCSLS         SUB       TCCOS         TPL               8 2
     C     TPSLS         SUB       TPCOS         TPLL              8 2
      *
     C     SHCS01        IFNE      0
     C     SHCQ01        ANDNE     0
     C     SHCS01        DIV       SHCQ01        CAVG01            7 3
     C                   ENDIF
     C     SHCS02        IFNE      0
     C     SHCQ02        ANDNE     0
     C     SHCS02        DIV       SHCQ02        CAVG02            7 3
     C                   ENDIF
     C     SHCS03        IFNE      0
     C     SHCQ03        ANDNE     0
     C     SHCS03        DIV       SHCQ03        CAVG03            7 3
     C                   ENDIF
     C     SHCS04        IFNE      0
     C     SHCQ04        ANDNE     0
     C     SHCS04        DIV       SHCQ04        CAVG04            7 3
     C                   ENDIF
     C     SHCS05        IFNE      0
     C     SHCQ05        ANDNE     0
     C     SHCS05        DIV       SHCQ05        CAVG05            7 3
     C                   ENDIF
     C     SHCS06        IFNE      0
     C     SHCQ06        ANDNE     0
     C     SHCS06        DIV       SHCQ06        CAVG06            7 3
     C                   ENDIF
     C     SHCS07        IFNE      0
     C     SHCQ07        ANDNE     0
     C     SHCS07        DIV       SHCQ07        CAVG07            7 3
     C                   ENDIF
     C     SHCS08        IFNE      0
     C     SHCQ08        ANDNE     0
     C     SHCS08        DIV       SHCQ08        CAVG08            7 3
     C                   ENDIF
     C     SHCS09        IFNE      0
     C     SHCQ09        ANDNE     0
     C     SHCS09        DIV       SHCQ09        CAVG09            7 3
     C                   ENDIF
     C     SHCS10        IFNE      0
     C     SHCQ10        ANDNE     0
     C     SHCS10        DIV       SHCQ10        CAVG10            7 3
     C                   ENDIF
     C     SHCS11        IFNE      0
     C     SHCQ11        ANDNE     0
     C     SHCS11        DIV       SHCQ11        CAVG11            7 3
     C                   ENDIF
     C     SHCS12        IFNE      0
     C     SHCQ12        ANDNE     0
     C     SHCS12        DIV       SHCQ13        CAVG12            7 3
     C                   ENDIF
     C     SHCS13        IFNE      0
     C     SHCQ13        ANDNE     0
     C     SHCS13        DIV       SHCQ13        CAVG12            7 3
     C                   ENDIF
      *
     C     SHLS01        IFNE      0
     C     SHLQ01        ANDNE     0
     C     SHLS01        DIV       SHLQ01        LAVG01            7 3
     C                   ENDIF
     C     SHLS02        IFNE      0
     C     SHLQ02        ANDNE     0
     C     SHLS02        DIV       SHLQ02        LAVG02            7 3
     C                   ENDIF
     C     SHLS03        IFNE      0
     C     SHLQ03        ANDNE     0
     C     SHLS03        DIV       SHLQ03        LAVG03            7 3
     C                   ENDIF
     C     SHLS04        IFNE      0
     C     SHLQ04        ANDNE     0
     C     SHLS04        DIV       SHLQ04        LAVG04            7 3
     C                   ENDIF
     C     SHLS05        IFNE      0
     C     SHLQ05        ANDNE     0
     C     SHLS05        DIV       SHLQ05        LAVG05            7 3
     C                   ENDIF
     C     SHLS06        IFNE      0
     C     SHLQ06        ANDNE     0
     C     SHLS06        DIV       SHLQ06        LAVG06            7 3
     C                   ENDIF
     C     SHLS07        IFNE      0
     C     SHLQ07        ANDNE     0
     C     SHLS07        DIV       SHLQ07        LAVG07            7 3
     C                   ENDIF
     C     SHLS08        IFNE      0
     C     SHLQ08        ANDNE     0
     C     SHLS08        DIV       SHLQ08        LAVG08            7 3
     C                   ENDIF
     C     SHLS09        IFNE      0
     C     SHLQ09        ANDNE     0
     C     SHLS09        DIV       SHLQ09        LAVG09            7 3
     C                   ENDIF
     C     SHLS10        IFNE      0
     C     SHLQ10        ANDNE     0
     C     SHLS10        DIV       SHLQ10        LAVG10            7 3
     C                   ENDIF
     C     SHLS11        IFNE      0
     C     SHLQ11        ANDNE     0
     C     SHLS11        DIV       SHLQ11        LAVG11            7 3
     C                   ENDIF
     C     SHLS12        IFNE      0
     C     SHLQ12        ANDNE     0
     C     SHLS12        DIV       SHLQ12        LAVG12            7 3
     C                   ENDIF
     C     SHLS13        IFNE      0
     C     SHLQ13        ANDNE     0
     C     SHLS13        DIV       SHLQ13        LAVG12            7 3
     C                   ENDIF
      *
     C     TCSLS         IFNE      0
     C     TCQTY         ANDNE     0
     C     TCSLS         DIV       TCQTY         TCAVG             7 3
     C                   ENDIF
     C     TPSLS         IFNE      0
     C     TLQTY         ANDNE     0
     C     TPSLS         DIV       TLQTY         TLAVG             7 3
     C                   ENDIF
      *
     C                   GOTO      RSTRTE
     C                   ENDSR
      *********
      * GETLOT
      *********
     C     GETLOT        BEGSR
      *
     C                   MOVE      '1'           *IN80
     C                   WRITE     LOTCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECN2             5 0
      *
     C     REDKEY        KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C     REDKEY        SETLL     FDLOTRDR
     C     NXSFLR        TAG
     C     REDKEY        READE     RDLOTRD                                90
     C   90              GOTO      DSPLL
      *
     C  N90VWHSE         IFGT      *BLANKS
     C     LRWHSE        ANDNE     VWHSE
     C                   GOTO      NXSFLR
     C                   ENDIF
      *
     C                   Z-ADD     LRQTOH        LOTOH
     C                   Z-ADD     LRQTAL        LOTAL
     C     LOTOH         SUB       LOTAL         LOTAV
      *
     C                   Z-ADD     LRCRDY        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SHPDAT            6 0
      *
     C                   ADD       1             RECN2
     C                   WRITE     LOTSFL
      *
     C                   GOTO      NXSFLR
      *
     C     DSPLL         TAG
     C                   WRITE     LOTSFL
      *
     C     ENSFLR        ENDSR
      *********
      * GETITM
      *********
     C     GETITM        BEGSR
      *
EFD01C                   Z-ADD     0             AVGPRC
     C     KEY18         CHAIN     FMINVT                             90
     C   90              SETON                                        10
     C   10              GOTO      ENDITM
      *
     C                   EXSR      GETDES
     C                   EXSR      GETDTA
      *
     C     ENDITM        ENDSR
      *
      *********
      * *INZSR
      *********
     C     *INZSR        BEGSR
      *
     C     KEY18         KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C                   KFLD                    VSHFR
      *
     C     KEYC          KLIST
     C                   KFLD                    VSHFR
     C                   KFLD                    IMPCL3
      *
     C     LCO           CHAIN(N)  FMAPER                             90
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                        30
     C                   ENDIF
     C                   ENDSR
      *
