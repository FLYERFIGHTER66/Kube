      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- SAR820
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- ANNUAL SALES HISTORY UPDATE
      *DESCRIPTION--------- THIS PROGRAM WILL UPDATE SALES HISTORY
      *                     (SHIST) USING UNPOSTED MSALE RECORDS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/16/01 EFD CLEAR SHIST RECORD IF NO HIT.    EFD01
      *
      *
     FFMSALCIS  UF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFSHIST    UF A E           K DISK
     FSAR820    O    F  122        PRINTER OFLIND(*INOF)
      *
     D CS$             S              9  2 DIM(13)
     D LS$             S              9  2 DIM(13)
     D CC$             S              9  2 DIM(13)
     D LC$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D LSQ             S             11  1 DIM(13)
     D CLB             S             11  4 DIM(13)
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
     D                UDS
     D  LCO                    1      2  0
     D  LCANCL               133    133
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
     I              SILC01                      LC$(1)
     I              SILC02                      LC$(2)
     I              SILC03                      LC$(3)
     I              SILC04                      LC$(4)
     I              SILC05                      LC$(5)
     I              SILC06                      LC$(6)
     I              SILC07                      LC$(7)
     I              SILC08                      LC$(8)
     I              SILC09                      LC$(9)
     I              SILC10                      LC$(10)
     I              SILC11                      LC$(11)
     I              SILC12                      LC$(12)
     I              SILC13                      LC$(13)
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   SETON                                        50
      *
     C     LCO           CHAIN     FMCORG                             88
      *
     C                   EXCEPT    HDG
     C                   Z-ADD     1             FIRST             5 0
      *
     C     NXTA          TAG
     C                   READ      FMSALCIS                               90
     C   90              GOTO      END
      *
     C     MSSTAT        IFEQ      'D'
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     MSCOMP        IFNE      LCO
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     MSSHPR        IFNE      99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     MSTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TRNDAT            6 0
     C                   Z-ADD     MSCOMP        CONO              2 0
     C                   CALL      'GETAPER'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    TRNDAT            6 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     ACTPER        P                 2 0
      *
     C     P             IFEQ      99
     C                   SETON                                        30
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   MOVEL     'A'           MSSTAT
     C                   MOVEL     ' '           MSARUD
     C                   UPDATE    RMSALE
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     ACTPER        MSSHPR
      *
      * ? AFFECT S/A CREDIT MEMOS
      *
     C     MSAFSL        IFEQ      'N'
     C                   MOVEL     'P'           MSARUD
     C                   UPDATE    RMSALE
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     MSCUST        CHAIN     FMCUST                             90
     C  N90CMDSHF        IFEQ      'N'
     C                   MOVEL     'P'           MSARUD
     C                   UPDATE    RMSALE
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     FIRST         IFGT      1
     C     OLCUST        IFNE      MSCUST
     C     OLITEM        ORNE      MSITEM
     C     OLSIZE        ORNE      MSSIZE
     C     OLSLSM        ORNE      MSSLM1
     C                   EXSR      USHIST
     C                   ENDIF
     C                   ENDIF
      *
      * IF FIRST TIME THRU GET SHIST REC
     C     FIRST         IFEQ      1
     C                   EXSR      GETHST
     C                   END
      *
     C                   ADD       MSQSHP        CSQ(P)                                     R
     C                   ADD       MSEXT$        CS$(P)
     C                   ADD       MSCST$        CC$(P)                                     AR
     C                   ADD       MSWGSH        CLB(P)                                     YR
      *
     C                   ADD       1             FIRST
     C                   Z-ADD     MSCUST        OLCUST            6 0
     C                   MOVEL     MSITEM        OLITEM           12
     C                   MOVEL     MSSIZE        OLSIZE            3
     C                   MOVEL     MSSLM1        OLSLSM            2
     C                   Z-ADD     MSCOMP        OLCOMP            2 0
     C                   MOVEL     'P'           MSARUD
     C                   UPDATE    RMSALE
      *
     C     OLCUST        CHAIN     FMCUST                             90
     C                   MOVEL     CMLOOK        SICMAL
      *
     C     KEY18         KLIST
     C                   KFLD                    OLITEM
     C                   KFLD                    OLSIZE
     C     KEY18         CHAIN     FMINVT                             90
     C                   MOVEL     IMLOOK        SIITAL
      *
     C                   GOTO      NXTA
      *
     C     END           TAG
     C     FIRST         IFGT      1
     C                   EXSR      USHIST
     C                   END
     C  N30              EXCEPT    TLR
     C                   SETON                                        LR
      *********
      * GETHST
      *********
     C     GETHST        BEGSR
     C                   Z-ADD     MSCUST        SICUST
     C                   Z-ADD     MSCOMP        SICOMP
     C                   MOVEL     MSITEM        SIITEM
     C                   MOVE      MSSIZE        SISIZE
     C                   MOVEL     MSSLM1        SISLSM
     C     KEY25         KLIST
     C                   KFLD                    SICUST
     C                   KFLD                    SIITEM
     C                   KFLD                    SISIZE
     C                   KFLD                    SISLSM
     C                   KFLD                    SICOMP
     C     KEY25         CHAIN     FSHIST                             92
EFD01C   92              DO
EFD01C                   CLEAR                   RSHIST
EFD01C                   Z-ADD     MSCUST        SICUST
EFD01C                   Z-ADD     MSCOMP        SICOMP
EFD01C                   MOVEL     MSITEM        SIITEM
EFD01C                   MOVE      MSSIZE        SISIZE
EFD01C                   MOVEL     MSSLM1        SISLSM
EFD01C                   ENDDO
     C                   ENDSR
      *********
      * USHIST
      *********
     C     USHIST        BEGSR
     C                   XFOOT     CSQ           SICQTL
     C                   XFOOT     CS$           SICSTL
     C                   MOVEL     'A'           SISTAT
     C  N92              UPDATE    RSHIST
     C  N92              GOTO      NOADD
EFD01C*                    Z-ADDOLCUST    SICUST
EFD01C*                    Z-ADDOLCOMP    SICOMP
EFD01C*                    MOVELOLITEM    SIITEM
EFD01C*                    MOVELOLSIZE    SISIZE
EFD01C*                    MOVELOLSLSM    SISLSM
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
     C                   Z-ADD     0             LC$
     C                   EXSR      GETHST
     C                   ENDSR
      *                                                                ***
     OSAR820    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           61 'Sales History '
     O                                           75 'Record Update'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           62 'Records Unable to be Pos'
     O                                           82 'ted to Sales History'
     O          E            HDG            1
     O                                            8 'Customer'
     O                                           23 '--Invoice--'
     O                                           36 'Item'
     O                                           66 'Line Item'
     O                                           80 'Transaction'
     O                                           88 'Qty'
     O                                          104 'Unit'
     O                                          122 'Extended'
     O          E            HDG            1
     O                                            7 'Number'
     O                                           23 'Number Suff'
     O                                           37 'Number'
     O                                           52 'Location'
     O                                           63 'Seq'
     O                                           77 'Date'
     O                                           90 'Shipped'
     O                                          104 'Price'
     O                                          122 'Amount'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       MSCUST        Z      7
     O                       MSINV#        Z     18
     O                       MSSUFF              22
     O                       MSITEM              42
     O                       MSWHSE              48
     O                       MSSEQ#              63 ' 0. '
     O                       MSTDAT        Y     79
     O                       MSQSHP        M     93
     O                       MSUPRI        L    106
     O                       MSEXT$        L    122
     O          E            TLR         2
     O                                           57 '** All Monthly Sales Rec'
     O                                           81 'ords Posted For This Com'
     O                                           88 'pany **'
      *
