      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.    2000
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC..  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES INC.  215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR365
      *APPLICATION--------- ORDER ENTRY
      *DESCRIPTION--------- DETAIL SALES HISTORY UPDATE - DOP
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/25/99 EFD ADD LIST CODE TO SHIST
      *  3/20/00 EFD ADD CLEAR SHIST
      *  7/12/00 EFD01 DO NOT PRINT REPORT IF ALL POSTED
      *  3/08/01 EFD CHANGE WRITE TO ELIMINATE DUP KEYS.   EFD02
      *
      *
     FFDSALCIS  UF   E           K DISK
     FFSHIST    UF A E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMSALE    O  A E           K DISK
     FBIR365    O    F  120        PRINTER OFLIND(*INOF)
      *
      * SHIST ARRAYS
      *
     D CS$             S              9  2 DIM(13)
     D LS$             S              9  2 DIM(13)
     D CC$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D LSQ             S             11  1 DIM(13)
     D CLB             S             11  4 DIM(13)
      *
     D                UDS
     D  LCO                    1      2  0
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
     IRSHIST
     I              SICQ01                      CSQ(1)
     I              SICQ02                      CSQ(2)
     I              SICQ03                      CSQ(3)
     I              SICQ04                      CSQ(4)
     I              SICQ05                      CSQ(5)
     I              SICQ06                      CSQ(6)
     I              SICQ07                      CSQ(7)
     I              SICQ08                      CSQ(8)
     I              SICQ09                      CSQ(9)
     I              SICQ10                      CSQ(10)
     I              SICQ11                      CSQ(11)
     I              SICQ12                      CSQ(12)
     I              SICQ13                      CSQ(13)
      *
     I              SILQ01                      LSQ(1)
     I              SILQ02                      LSQ(2)
     I              SILQ03                      LSQ(3)
     I              SILQ04                      LSQ(4)
     I              SILQ05                      LSQ(5)
     I              SILQ06                      LSQ(6)
     I              SILQ07                      LSQ(7)
     I              SILQ08                      LSQ(8)
     I              SILQ09                      LSQ(9)
     I              SILQ10                      LSQ(10)
     I              SILQ11                      LSQ(11)
     I              SILQ12                      LSQ(12)
     I              SILQ13                      LSQ(13)
      *
     I              SICS01                      CS$(1)
     I              SICS02                      CS$(2)
     I              SICS03                      CS$(3)
     I              SICS04                      CS$(4)
     I              SICS05                      CS$(5)
     I              SICS06                      CS$(6)
     I              SICS07                      CS$(7)
     I              SICS08                      CS$(8)
     I              SICS09                      CS$(9)
     I              SICS10                      CS$(10)
     I              SICS11                      CS$(11)
     I              SICS12                      CS$(12)
     I              SICS13                      CS$(13)
      *
     I              SILS01                      LS$(1)
     I              SILS02                      LS$(2)
     I              SILS03                      LS$(3)
     I              SILS04                      LS$(4)
     I              SILS05                      LS$(5)
     I              SILS06                      LS$(6)
     I              SILS07                      LS$(7)
     I              SILS08                      LS$(8)
     I              SILS09                      LS$(9)
     I              SILS10                      LS$(10)
     I              SILS11                      LS$(11)
     I              SILS12                      LS$(12)
     I              SILS13                      LS$(13)
      *
     I              SICC01                      CC$(1)
     I              SICC02                      CC$(2)
     I              SICC03                      CC$(3)
     I              SICC04                      CC$(4)
     I              SICC05                      CC$(5)
     I              SICC06                      CC$(6)
     I              SICC07                      CC$(7)
     I              SICC08                      CC$(8)
     I              SICC09                      CC$(9)
     I              SICC10                      CC$(10)
     I              SICC11                      CC$(11)
     I              SICC12                      CC$(12)
     I              SICC13                      CC$(13)
      *
     I              SIC#01                      CLB(1)
     I              SIC#02                      CLB(2)
     I              SIC#03                      CLB(3)
     I              SIC#04                      CLB(4)
     I              SIC#05                      CLB(5)
     I              SIC#06                      CLB(6)
     I              SIC#07                      CLB(7)
     I              SIC#08                      CLB(8)
     I              SIC#09                      CLB(9)
     I              SIC#10                      CLB(10)
     I              SIC#11                      CLB(11)
     I              SIC#12                      CLB(12)
     I              SIC#13                      CLB(13)
      *
     C                   Z-ADD     1             FIRST             4 0
EFD01C                   Z-ADD     1             CNT               6 0
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN(N)  FMCORG                             90
EFD01C*                    EXCPTHDG
      *
     C     NXT           TAG
     C                   SETOFF                                       30
     C                   READ      FDSALCIS                               90
     C   90              GOTO      END
      *
      * CHECK IF POSTED
      *
     C     SDDSFL        IFEQ      'P'
EFD  C     SDSTAT        OREQ      'P'
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK IF SAME COMPANY
      *
     C     SDCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   END
      *
      * CHECK IF ITEM BLANK
      *
     C     SDITEM        IFLE      *BLANKS
     C                   MOVEL     'P'           SDSTAT
     C                   MOVEL     'P'           SDDSFL
     C                   UPDATE    RDSALE
     C                   GOTO      NXT
     C                   ENDIF
      *
      * ? AFFECT S/A CREDIT MEMOS
      *
     C     SDAFSL        IFEQ      'N'
     C                   GOTO      NOSLS
     C                   ENDIF
      *
     C     FIRST         IFGT      1
     C     OLCUST        IFNE      SDCUST
     C     OLITEM        ORNE      SDITEM
     C     OLSIZE        ORNE      SDSIZE
     C     OLSLSM        ORNE      SDSLM1
     C                   EXSR      USHIST
     C                   ENDIF
     C                   ENDIF
     C     OLCUST        CHAIN     FMCUST                             90
     C                   MOVEL     CMLOOK        SICMAL
      *
      * IF FIRST TIME THRU GET SHIST REC
     C     FIRST         IFEQ      1
     C                   EXSR      GETHST
     C                   END
      *
     C     KEY18         KLIST
     C                   KFLD                    SDITEM
     C                   KFLD                    SDSIZE
     C     KEY18         CHAIN     FMINVT                             90
     C                   MOVEL     IMLOOK        SIITAL
     C     NOSLS         TAG
      *
      * ACCOUNTING PERIOD 99
      *
     C                   Z-ADD     SDCOMP        CONO              2 0
     C                   Z-ADD     SDTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TRNDAT            6 0
     C                   CALL      'GETAPER'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    TRNDAT            6 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     ACTPER        SDSHPR
     C                   EXSR      MSALE
     C                   WRITE     RMSALE
      *
EFD01C     SDSHPR        IFEQ      1
EFD01C     CNT           ANDEQ     1
EFD01C                   EXCEPT    HDG
EFD01C                   ENDIF
     C     SDSHPR        IFEQ      99
     C                   SETON                                        30
EFD01C   OF              EXCEPT    HDG
     C                   EXCEPT    DETL
EFD01C                   ADD       1             CNT
     C                   MOVEL     'P'           SDSTAT
     C                   UPDATE    RDSALE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SDAFSL        IFEQ      'N'
     C                   MOVEL     'P'           SDSTAT
     C                   UPDATE    RDSALE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     SDSHPR        P                 2 0
      *
     C                   ADD       SDQSHP        CSQ(P)                                     R
     C                   ADD       SDEXT$        CS$(P)
     C                   ADD       SDCST$        CC$(P)                                     AR
     C                   ADD       SDWGSH        CLB(P)                                     YR
      *
     C                   MOVEL     'D'           SDSTAT
      *
     C                   MOVEL     'P'           SDDSFL
     C                   UPDATE    RDSALE
     C                   ADD       1             FIRST
     C                   Z-ADD     SDCUST        OLCUST            6 0
     C                   Z-ADD     SDCOMP        OLCOMP            2 0
     C                   MOVEL     SDITEM        OLITEM           12
     C                   MOVEL     SDSIZE        OLSIZE            3
     C                   MOVEL     SDSLM1        OLSLSM            2
     C                   MOVEL     SDLIST        OLLIST            4
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C     FIRST         IFGT      1
     C                   EXSR      USHIST
     C                   END
     C                   SETON                                        LR
      *
     C     USHIST        BEGSR
     C                   XFOOT     CSQ           SICQTL
     C                   XFOOT     CS$           SICSTL
     C                   MOVEL     'A'           SISTAT
     C  N92              UPDATE    RSHIST
     C  N92              GOTO      NOADD
EFD02C**                   Z-ADDOLCUST    SICUST
EFD02C**                   Z-ADDOLCOMP    SICOMP
EFD02C**                   MOVELOLITEM    SIITEM
EFD02C**                   MOVELOLSIZE    SISIZE
EFD02C**                   MOVELOLSLSM    SISLSM
EFD02C**                   MOVELOLLIST    SILIST
     C                   MOVEL     CMTERR        SITERR
     C                   MOVEL     IMPCL1        SIPCL1
     C                   MOVEL     IMPCL2        SIPCL2
     C                   MOVEL     IMPCL3        SIPCL3
     C                   Z-ADD     TDATE         SIDTLA
     C                   Z-ADD     TIMOD         SITIME
     C                   MOVEL     USERID        SIUSER
     C                   MOVEL     'D'           SIDSCD
     C                   MOVEL     *BLANKS       SIITYP
     C                   MOVEL     CMCTYP        SICUTP
     C                   WRITE     RSHIST
     C     NOADD         TAG
     C                   Z-ADD     0             CS$
     C                   Z-ADD     0             LS$
     C                   Z-ADD     0             CSQ
     C                   Z-ADD     0             LSQ
     C                   Z-ADD     0             CLB
     C                   Z-ADD     0             CC$
     C                   EXSR      GETHST
     C                   ENDSR
      *
     C     GETHST        BEGSR
     C                   Z-ADD     SDCUST        SICUST
     C                   Z-ADD     SDCOMP        SICOMP
     C                   MOVEL     SDITEM        SIITEM
     C                   MOVE      SDSIZE        SISIZE
     C                   MOVEL     SDSLM1        SISLSM
     C     KEY25         KLIST
     C                   KFLD                    SICUST
     C                   KFLD                    SIITEM
     C                   KFLD                    SISIZE
     C                   KFLD                    SISLSM
     C                   KFLD                    SICOMP
     C     KEY25         CHAIN     FSHIST                             92
     C   92              DO
     C                   CLEAR                   RSHIST
     C                   Z-ADD     SDCUST        SICUST
     C                   Z-ADD     SDCOMP        SICOMP
     C                   MOVEL     SDITEM        SIITEM
     C                   MOVE      SDSIZE        SISIZE
     C                   MOVEL     SDSLM1        SISLSM
EFD02C                   MOVEL     SDLIST        SILIST
     C                   ENDDO
     C                   ENDSR
      *********
      * MSALE
      *********
     C     MSALE         BEGSR
     C                   MOVEL     SDSTAT        MSSTAT
     C                   Z-ADD     SDCUST        MSCUST
     C                   MOVEL     SDCODE        MSCTYP
     C                   Z-ADD     SDINV#        MSINV#
     C                   MOVEL     SDSUFF        MSSUFF
     C                   MOVEL     SDITEM        MSITEM
     C                   MOVEL     SDSIZE        MSSIZE
     C                   Z-ADD     SDSEQ#        MSSEQ#
     C                   Z-ADD     SDTDAT        MSTDAT
     C                   Z-ADD     SDQSHP        MSQSHP
     C                   MOVEL     SDUUOM        MSUUOM
     C                   Z-ADD     SDUPRI        MSUPRI
     C                   Z-ADD     SDUCST        MSUCST
     C                   MOVEL     SDCTCD        MSCTCD
     C                   MOVEL     SDSLM1        MSSLM1
     C                   Z-ADD     SDCOM1        MSCOM1
     C                   MOVEL     SDSLM2        MSSLM2
     C                   Z-ADD     SDCOM2        MSCOM2
     C                   MOVEL     SDTERR        MSTERR
     C                   MOVEL     SDPCL1        MSPCL1
     C                   MOVEL     SDPCL2        MSPCL2
     C                   MOVEL     SDSTST        MSSTST
     C                   MOVEL     SDTXST        MSTXST
     C                   MOVEL     SDTXJU        MSTXJU
     C                   Z-ADD     0             MSFET$
     C                   Z-ADD     SDPCT1        MSPCT1
     C                   Z-ADD     SDPCT2        MSPCT2
     C                   Z-ADD     SDPCT3        MSPCT3
     C                   Z-ADD     SDCOMP        MSCOMP
     C                   Z-ADD     SDDIS1        MSDIS1
     C                   Z-ADD     SDTRDC        MSTRDC
     C                   Z-ADD     SDORD#        MSORD#
     C                   MOVEL     SDPONO        MSPONO
     C                   Z-ADD     SDGSLS        MSGSLS
     C                   MOVEL     SDSHUD        MSARUD
     C                   MOVEL     SDIVUD        MSIVUD
     C                   MOVEL     SDWHSE        MSWHSE
     C                   Z-ADD     SDDTLA        MSDTLA
     C                   Z-ADD     SDTIME        MSTIME
     C                   MOVEL     SDUSER        MSUSER
     C                   MOVEL     SDITYP        MSITYP
     C                   Z-ADD     SDTTYP        MSTTYP
     C                   MOVEL     SDAFSL        MSAFSL
     C                   MOVEL     SDAFIV        MSAFIV
     C                   MOVEL     SDIOCD        MSIOCD
     C                   Z-ADD     SDEXT$        MSEXT$
     C                   Z-ADD     SDCST$        MSCST$
     C                   Z-ADD     SDSHPR        MSSHPR
     C                   MOVEL     SDCUFL        MSCUFL
     C                   MOVEL     SDITFL        MSITFL
     C                   MOVEL     SDSLFL        MSSLFL
     C                   MOVEL     SDROUT        MSROUT
     C                   Z-ADD     SDSTOP        MSSTOP
     C                   MOVEL     SDCWTF        MSCWTF
     C                   Z-ADD     0             MSLBS#
     C                   Z-ADD     SDWGSH        MSWGSH
     C                   Z-ADD     SDARCU        MSARCU
     C                   Z-ADD     SDSHCU        MSSHCU
     C                   Z-ADD     SDBLCU        MSBLCU
     C                   MOVEL     SDRSCD        MSRSCD
     C                   MOVEL     SDPRAL        MSPRAL
     C                   MOVEL     SDBUOM        MSBUOM
     C                   MOVEL     SDBLUM        MSBLUM
     C                   Z-ADD     SDMUL2        MSMUL2
     C                   MOVEL     SDJOCD        MSJOCD
     C                   Z-ADD     SDQCRD        MSQCRD
     C                   Z-ADD     SDUWGT        MSUWGT
     C                   MOVEL     SDPCL3        MSPCL3
     C                   MOVEL     SDLOTC        MSLOTC
     C                   MOVEL     SDSHFR        MSSHFR
     C                   MOVEL     SDLIST        MSLIST
     C                   ENDSR
      *
     OBIR365    E            HDG            1 03
     O                       PROGID              10
     O                                           25 'Requested by:'
     O                       USERID              36
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          1    120
     O                                          117 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           71 'Daily Sales Not Posted'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           14 'Invoice  Cust.'
     O                                           59 'Invoice'
     O                                           65 'Sales'
     O                                           71 'Prod'
     O                                           78 'Order'
     O                                           91 'Item Number'
     O                                          103 'Seq UM'
     O                                          118 'Quantity'
     O          E            HDG            0
     O                                           15 'Number  Number'
     O                                           39 'N   A   M   E'
     O                                           57 'Date'
     O                                           66 'Person'
     O                                           72 'Class'
     O                                           79 'Number'
     O                                          117 'Shipped'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       SDINV#        Z      6
     O                       SDSUFF               8
     O                       SDCUST        Z     15
     O                       CMNAME              50
     O                       SDTDAT        Y     59
     O                       SDSLM1              62
     O                       SDSLM2              65
     O                       SDPCL1              69
     O                       SDPCL2              72
     O                       SDORD#        Z     79
     O                       SDITEM              95
     O                       SDSEQ#             100 ' 0. '
     O                       SDUUOM             103
     O                       SDQSHP        M    117
