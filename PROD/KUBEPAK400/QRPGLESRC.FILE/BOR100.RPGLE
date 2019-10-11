    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

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
      **PROGRAM NAME-------- BOR100
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SELECT BACKORDERED ITEMS FOR SHIPMENT
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/02/99 EFD UPDATE ROUT/STOP IF REQ. DATE CHANGES
      *  9/26/01 EFD USE TDATE FOR REQ DATE IF CANCELLED. PER BILL
      *  5/24/02 EFD DELETE COMMENTS IF ONLY THING ON THE ORDER.
      *
     FBOR100FM  CF   E             WORKSTN
     F                                     SFILE(ORDSFL:RECNO)
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFMSVIA    IF   E           K DISK
     FFCUSTCOM  IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFHORDR    UF   E           K DISK
     FFHORDRHISTO  A E           K DISK
     FFIORDR    UF A E           K DISK
     FFMINVT    UF   E           K DISK
     FFLKITM    UF   E           K DISK
      *
     D MSG             S             50    DIM(1) CTDATA PERRCD(1)              MESSAGE ARRAY
      ** MCUST ARRAYS
     D RT              S              2    DIM(7)                               ROUTE M THR S
     D ST              S              3  0 DIM(7)                               STOP #
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
      ** COMPANY
     D  LCONO                  1      2  0
      ** BEGINING ORDER NUMBER
     D  LBORD                 30     35  0
      ** ENDING ORDER NUMBER
     D  LEORD                 36     41  0
      ** BEGINING DATE
     D  LBEGDT                44     49  0
      ** ENDING DATE
     D  LENDDT                50     55  0
      ** SELECTION PICK SLIP
     D  LSELEC                56     56  0
      ** PRODUCT CLASS 1
     D  LPC1                  57     58
      ** PRODUCT CLASS 2
     D  LPC2                  59     60
      ** ROUTE 1
     D  LRTE1                 61     62
      ** ROUTE 2
     D  LRTE2                 63     64
      ** PHYTO 1
     D  LPHY1                 65     65
      ** PHYTO 2
     D  LPHY2                 66     66
      ** PREV. PRINTED
     D  LPREV                 67     67
      ** SHIP 1
     D  LSHP1                 68     69
      ** SHIP 2
     D  LSHP2                 70     71
      ** LOCATION 1
     D  LLOC1                 72     74
      ** LOCATION 2
     D  LLOC2                 75     77
      ** TAG
     D  LTAG                  78     78  0
      ** DATE
     D  LSTDAT                79     84  0
      ** SALE I.D.
     D  LSALE                 85     87
      ** DEPARTMENT
     D  LDEPT                 88     90
      ** SALE DATE
     D  TYCENB                91     95  0
      ** PRINTER ID
     D  LPRTR                100    109
      ** FORMS NUMBER
     D  LFORM                110    119
      ** NUMBER OF COPIES
     D  LCOPY                120    121  0
      ** JOBQ Y/N
     D  LJOBQ                122    122
      ** CANCEL  X=CANCEL
     D  LCANCL               133    133
      ** PRINTER ID PICK SLIP 2
     D  LP2ID                134    143
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$TimeStamp

     IRMCUST
     I              CMRTE1                      RT(1)
     I              CMRTE2                      RT(2)
     I              CMRTE3                      RT(3)
     I              CMRTE4                      RT(4)
     I              CMRTE5                      RT(5)
     I              CMRTE6                      RT(6)
     I              CMRTE7                      RT(7)
     I              CMSTP1                      ST(1)
     I              CMSTP2                      ST(2)
     I              CMSTP3                      ST(3)
     I              CMSTP4                      ST(4)
     I              CMSTP5                      ST(5)
     I              CMSTP6                      ST(6)
     I              CMSTP7                      ST(7)
      ****************
      * START HERE   *
      ****************
      ** CHECK FOR VALID USER ID
     C     USERID        CHAIN     FMUSER                             90
     C  N90USDEPT        CHAIN     FMDEPT                             90
     C*          DESHFR    IFEQ *BLANKS
     C*                    WRITESCRNE
     C*                    READ SCRNE                    90
     C*                    MOVEL'X'       LCANCL
     C*                    GOTO END
     C*                    END
      ** LOAD LDA
     C     DEPPCK        IFLE      *BLANKS
     C                   MOVEL     'PRT01'       DEPPCK
     C                   END
     C     DEPPC2        IFLE      *BLANKS
     C                   MOVEL     'PRT01'       DEPPC2
     C                   END
     C                   MOVEL     DEPPCK        LPRTR
     C                   MOVEL     '*NAR    '    LFORM
     C                   MOVEL     DEPPC2        LP2ID
     C                   MOVEL     '1'           LSELEC
     C                   Z-ADD     1             LTAG
     C                   MOVEL     'Y'           LPREV
     C                   Z-ADD     01            LCONO
     C                   Z-ADD     0             LBEGDT
     C                   Z-ADD     0             LENDDT
     C                   MOVE      *BLANKS       LPC1
     C                   MOVE      *BLANKS       LPC2
     C                   MOVE      *BLANKS       LRTE1
     C                   MOVE      *BLANKS       LRTE2
     C                   MOVE      *BLANKS       LPHY1
     C                   MOVE      *BLANKS       LPHY2
     C                   MOVE      *BLANKS       LSHP1
     C                   MOVE      *BLANKS       LSHP2
     C                   MOVEL     'N'           LABHUN            1
     C                   MOVEL     DESHFR        LDEPT
     C                   MOVEL     DESHFR        LLOC1
     C                   MOVEL     DESHFR        LLOC2
     C                   MOVE      *BLANKS       LCANCL
     C**                   Z-ADD0         LDAORD
     C**                   Z-ADD0         VRQDTE
     C     RSTART        TAG
     C                   MOVEA     '0'           *IN
     C                   MOVE      *BLANKS       LCANCL
     C                   UNLOCK    FHORDR
     C                   UNLOCK    FIORDR
     C                   UNLOCK    FMINVT
     C                   UNLOCK    FLKITM
      ***************
      * SCREEN A    *
      ***************
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      *C   99
      *COR 98                GOTO RSTART
      ** CHECK F KEYS
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C   KF              GOTO      RSTART
      ** CHECK ORDER NUMBER
     C                   SETOFF                                       101312
     C     VORDER        IFLE      0
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
     C     VORDER        CHAIN     FHORDR                             10
     C   10              GOTO      NXTA
     C     OHSTAT        IFEQ      'D'
     C     OHCOFL        OREQ      'Y'
     C                   SETON                                        1013
     C                   GOTO      NXTA
     C                   ENDIF
     C     OHSHFR        IFNE      DESHFR
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   ENDIF
     C                   EXSR      CHKORD
      ** 99 ON IF CONFIRMED NOT INVOICED   98 OF IF NO OPEN ITEMS.
     C   99
     COR 98              GOTO      NXTA
     C                   EXSR      LOADB
     C                   Z-ADD     0             RETRN             1 0
      *******************
      * SCREEN B        *
      *******************
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C                   SETOFF                                       102035
     C                   SETOFF                                       99
      ** F6 ONLY ALLOWED 1ST CYCLE
     C   KFRETRN         IFLE      0
     C                   GOTO      RSTART
     C                   ELSE
     C                   GOTO      NXTSFL
     C                   END
      ** CHECK DATE
     C     NEWSHP        IFLE      0
     C                   SETON                                        1099
     C                   GOTO      NXTB
     C                   END
     C                   Z-ADD     NEWSHP        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   END
     C                   Z-ADD     ##CYMD        NEWREV            6 0
     C   10              DO
     C                   SETON                                          99
     C                   GOTO      NXTB
     C                   ENDDO                                                  10 DO
      ** GET ROUTE AND STOP
     C     NEWSHP        IFNE      OHDTRQ
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
     C                   Z-ADD     ST(#Y)        OHSTOP
     C                   MOVEL     RT(#Y)        OHROUT
     C                   END
      ** CHECK P.O. IF NEEDED
     C     OHPONO        IFLE      *BLANKS
     C     CMPORQ        ANDEQ     'Y'
     C                   SETON                                        20
     C                   GOTO      NXTB
     C                   ENDIF
      ** CHECK SHIP VIA
     C                   MOVEL     OHSHPC        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       SVCODE            2
     C                   CALL      'LKSVIA'
     C                   PARM                    SVCODE
     C                   PARM                    SVDESC
     C                   MOVEL     *BLANKS       OHSHPC
     C                   MOVEL     SVCODE        OHSHPC
     C                   GOTO      NXTB
     C                   ENDIF
     C     OHSHPC        CHAIN     FMSVIA                             35
     C   35              GOTO      NXTB
     C     OHSHPC        IFNE      OSHPC
     C     OHPONO        ORNE      OPONO
     C     OHSPIN        ORNE      OSPIN
     C     OHSHIN        ORNE      OSHIN
     C     OHLOC         ORNE      OLOC
     C     OHROUT        ORNE      OROUT
     C     OHSTOP        ORNE      OSTOP
     C     OHDTRQ        ORNE      NEWSHP
     C                   MOVEL     OHSHPC        OSHPC             2
     C                   MOVEL     OHPONO        OPONO            15
     C                   MOVEL     OHSPIN        OSPIN            30
     C                   MOVEL     OHSHIN        OSHIN            30
     C                   MOVEL     OHLOC         OLOC              8
     C                   MOVEL     OHROUT        OROUT             2
     C                   Z-ADD     OHSTOP        OSTOP             3 0
     C                   Z-ADD     NEWSHP        OHDTRQ
     C                   GOTO      NXTB
     C                   ENDIF
      * IF HERE UPDATE FILE AND CHAIN
     C                   MOVE      *BLANKS       OHPLPT
     C                   UPDATE    RHORDR
     C                   Eval      HSTUSER    = $User()
     C                   Eval      HSTPROGRAM = 'BOR100_1'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
     C     VORDER        CHAIN     FHORDR                             10
      *
     C                   EXSR      BLDSFL
     C                   SETOFF                                       98
      *******************
      * SUB FILE SCREEN *
      *******************
     C     NXTSFL        TAG
     C   99              SETOFF                                       98
     C                   EXFMT     ORDCTL
      *** CHECK F KEYS
     C   KL              DO
     C                   Z-ADD     1             RETRN
     C                   GOTO      NXTB
     C                   ENDDO                                                  KL DO
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C   KF              GOTO      RSTART
      ** CANCEL ALL
     C   KA              EXSR      CANALL
      ** CHECK SUB FILE IF ERRORS RE-DISPLAY
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTSFL
      ** IF F2 UPDATE ORDER AND PRINT PICK
     C   KB              DO
     C                   EXSR      PUTSFL
     C*          TOTLIN    IFGT 0
     C                   Z-ADD     VORDER        LBORD
     C                   Z-ADD     VORDER        LEORD
     C                   Z-ADD     NEWSHP        LBEGDT
     C                   Z-ADD     NEWSHP        LENDDT
     C                   MOVE      *BLANKS       LCANCL
     C*                    GOTO END
     C*                    ELSE
     C*                    END
     C                   GOTO      RSTART
     C                   ENDDO                                                  F4 DO
     C                   GOTO      NXTSFL
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** CHECK ORDER       **
      ***********************
     C     CHKORD        BEGSR
     C     VORDER        SETLL     FIORDR
     C                   SETOFF                                       99         NOT BILLED
     C                   SETOFF                                       98         NO OPEN
     C     NXTC          TAG
     C     VORDER        READE     FIORDR                                 90
     C   90              GOTO      ENDC
WJB  C                   Eval      OITEM5 = %SUBST(OIITEM:1:5)
     C     OISTAT        IFEQ      'D'
     C     OIITYP        ORNE      ' '
     C                   GOTO      NXTC
     C                   ENDIF
      *** CHECK IF CONFIRMED AND NOT BILLED
     C     OIQINV        IFGT      0.0
     C                   SETON                                            99
     C                   GOTO      ENDC
     C                   END
     C     OIQORD        SUB       OIQSHP        QTYOPN
     C     QTYOPN        IFLE      0
     C                   GOTO      NXTC
     C                   END
      ** IF HERE SOME OPEN
     C                   SETOFF                                       98
     C                   GOTO      NXTC
      **
     C     ENDC          ENDSR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     ORDCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C     VORDER        SETLL     FIORDR
     C     NXTBLD        TAG
     C     VORDER        READE     FIORDR                                 90
     C   90              GOTO      ENDBLD
WJB  C                   Eval      OITEM5 = %SUBST(OIITEM:1:5)
     C     OISTAT        IFEQ      'D'
     C     OIITYP        ORNE      ' '
     C                   GOTO      NXTBLD
     C                   ENDIF
     C     OIQORD        SUB       OIQSHP        QTYOPN
     C     QTYOPN        IFLE      0
     C                   GOTO      NXTBLD
     C                   END
     C     MINKEY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     MINKEY        CHAIN     FMINVT                             90
     C                   EXSR      GETDES
     C                   Z-ADD     OIQORD        QTYORD
     C                   Z-ADD     OIQSHP        QTYINV
     C                   Z-ADD     0             QTYSHP
     C                   MOVE      *BLANKS       CANCOD
     C     OIQDDC        DIV       100           WRKDSC            4 4
     C     1.00          SUB       WRKDSC        DSCNEW            5 4
     C     OIUPRI        MULT(H)   DSCNEW        UPRIC
     C                   Z-ADD     0             EXTAMT
     C                   MOVE      *BLANKS       COMNT
     C                   MOVEL     OIDES1        VDESC
     C                   ADD       1             RECNO
     C                   WRITE     ORDSFL
     C                   GOTO      NXTBLD
      ** END OF ITEMS
     C     ENDBLD        TAG
     C                   Z-ADD     0             QTYORD
     C                   Z-ADD     0             QTYINV
     C                   Z-ADD     0             QTYSHP
     C                   MOVE      *BLANKS       CANCOD
     C                   Z-ADD     0             UPRIC
     C                   Z-ADD     0             EXTAMT
     C                   MOVE      *BLANKS       COMNT
     C                   MOVE      *BLANKS       OIITEM
     C                   MOVE      *BLANKS       OITEM5
     C                   MOVE      *BLANKS       OISIZE
     C                   MOVEL     MSG(1)        VDESC
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   WRITE     ORDSFL
     C                   ENDSR
      *******************
      * CHECK SUB FILE  *
      *******************
     C     CHKSFL        BEGSR
     C                   SETOFF                                       222324
     C                   SETOFF                                       252632
     C                   SETOFF                                       33  99
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             TOTLIN            5 0
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C                   SETOFF                                       132131
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTCHK
      ** CHECK CANCEL CODE
     C     CANCOD        IFEQ      '?'
     C     CANCOD        OREQ      '/'
     C                   EXSR      GETCOD
     C                   ENDIF
     C     CANCOD        IFNE      'C'
     C     CANCOD        ANDNE     'O'
     C     CANCOD        ANDNE     ' '
     C                   SETON                                        212299
     C                   ENDIF
      ** CHECK QTYS
     C     QTYSHP        IFGT      0
     C     QTYSHP        IFLT      QTYOPN
     C     CANCOD        ANDNE     'C'
     C                   SETON                                        132199
     C                   SETON                                        23
     C                   END
     C     QTYSHP        IFGT      QTYOPN
     C     CANCOD        ANDNE     'O'
     C                   SETON                                        132199
     C                   SETON                                        24
     C                   END
     C     QTYSHP        IFEQ      QTYOPN
     C     CANCOD        ANDEQ     'O'
     C                   SETON                                        132199
     C                   SETON                                        25
     C                   END
     C     QTYSHP        IFEQ      QTYOPN
     C     CANCOD        ANDEQ     'C'
     C                   SETON                                        132199
     C                   SETON                                        25
     C                   END
     C                   END                                                    QTYSHP>0
      ** CHECK COMMENT CODE
     C     COMNT         IFGT      *BLANKS
     C     QTYSHP        ANDLE     0
     C                   SETON                                        313299
     C                   ENDIF
     C                   ADD       QTYSHP        TOTLIN
     C     CANCOD        IFEQ      'C'
     C                   ADD       1             TOTLIN
     C                   END
     C                   UPDATE    ORDSFL
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C     TOTLIN        IFLE      0
     C                   SETON                                        3399
     C                   ELSE
     C  N99              SETON                                        98
     C                   END
     C                   ENDSR
      *******************
      *   PUT SUB FILE  *
      *******************
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             TOTLIN            5 0
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTPUT
      ** GET IORDR RECORD
     C     IORKEY        KLIST
     C                   KFLD                    VORDER
     C                   KFLD                    OISEQ#
     C     IORKEY        CHAIN     FIORDR                             91
     C   91              GOTO      NXTPUT
WJB  C                   Eval      OITEM5 = %SUBST(OIITEM:1:5)
      ** CANCEL ENTIRE LINE
     C     CANCOD        IFEQ      'C'
     C     QTYSHP        ANDLE     0
     C                   MOVEL     'D'           OISTAT
     C                   MOVEL     'Y'           OICOFL
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     TIMOD         OITIME
     C                   Z-ADD     TDATE         OIDTLA
     C                   UPDATE    RIORDR
     C     OIQORD        SUB       OIQSHP        DELQTY           11 1
     C                   EXSR      UNALLO
     C                   GOTO      CHKPUT
     C                   ENDIF                                                  CANC ENT LIN
      ** SHIP SOME CANCEL REST
     C     CANCOD        IFEQ      'C'
     C     QTYSHP        ANDGT     0
     C     OIQORD        SUB       OIQSHP        DELQTY
     C                   SUB       QTYSHP        DELQTY
     C                   EXSR      UNALLO
     C     OIQSHP        ADD       QTYSHP        OIQORD
     C                   Z-ADD     QTYSHP        OIQBOO
     C                   Z-ADD     TDATE         OIDTRQ
     C                   Z-ADD     TDCYMD        OIRVDT
     C                   MOVE      *BLANKS       OIPLPT
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     TIMOD         OITIME
     C                   Z-ADD     TDATE         OIDTLA
     C                   UPDATE    RIORDR
     C                   ADD       QTYSHP        TOTLIN
     C                   GOTO      CHKPUT
     C                   ENDIF                                                  SHP SOME XLC
      ** SHIP MORE THAN ORDERED
     C     CANCOD        IFEQ      'O'
     C     QTYSHP        ANDGT     0
     C     OIQORD        SUB       OIQSHP        TSTOPN           11 1
     C     QTYSHP        SUB       TSTOPN        NEWQTY           11 1
     C                   EXSR      ALLO
     C     OIQSHP        ADD       QTYSHP        OIQORD
     C                   Z-ADD     QTYSHP        OIQBOO
     C                   Z-ADD     NEWSHP        OIDTRQ
     C                   Z-ADD     NEWREV        OIRVDT
     C                   MOVE      *BLANKS       OIPLPT
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     TIMOD         OITIME
     C                   Z-ADD     TDATE         OIDTLA
     C                   UPDATE    RIORDR
     C                   ADD       QTYSHP        TOTLIN
     C                   GOTO      CHKPUT
     C                   ENDIF                                                  SHIP MORE
      ** SHIP WHAT WAS ORDERED
     C     QTYSHP        IFGT      0
     C                   Z-ADD     NEWSHP        OIDTRQ
     C                   Z-ADD     NEWREV        OIRVDT
     C                   MOVE      *BLANKS       OIPLPT
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     TIMOD         OITIME
     C                   Z-ADD     TDATE         OIDTLA
     C                   UPDATE    RIORDR
     C                   ADD       QTYSHP        TOTLIN
     C                   GOTO      CHKPUT
     C                   ENDIF                                                  SHIP ORIG
     C     CHKPUT        TAG
      ** SEE IF WE NEED COMMENT LINE
     C     COMNT         IFGT      *BLANKS
     C                   ADD       1             OISEQ#
     C     IORKEY        CHAIN     FIORDR                             91
     C  N91              DO
WJB  C                   Eval      OITEM5 = %SUBST(OIITEM:1:5)
     C     OIITYP        IFNE      'C'
     C                   GOTO      NXTPUT
     C                   END
     C                   ENDDO                                                  N91 DO
     C                   MOVEL     'C'           OIITYP
     C                   MOVEL     COMNT         OIDES1
     C                   MOVE      *BLANKS       OIDES2
     C                   MOVE      *BLANKS       OIITEM
     C                   MOVE      *BLANKS       OITEM5
     C                   MOVE      *BLANKS       OISIZE
     C                   MOVE      *BLANKS       OIWHSE
     C                   MOVE      *BLANKS       OIUUOM
     C                   Z-ADD     0             OIMULT
     C                   Z-ADD     0             OIUCST
     C                   Z-ADD     0             OIUPRI
     C                   Z-ADD     0             OIQDDC
     C                   Z-ADD     0             OIEXT$
     C                   Z-ADD     0             OIQORD
     C                   Z-ADD     0             OIQSHP
     C                   Z-ADD     0             OIQBOO
     C**                   Z-ADD0         OIFET$
     C                   Z-ADD     0             OIAMT1
     C                   Z-ADD     0             OIAMT2
     C                   Z-ADD     0             OIAMT3
     C                   Z-ADD     0             OIDISC
     C                   Z-ADD     0             OITRDC
     C                   Z-ADD     0             OIQINV
     C                   Z-ADD     0             OILBS#
     C                   Z-ADD     0             OIWGSH
     C                   Z-ADD     0             OISEQP
     C                   Z-ADD     0             OIINV#
     C                   Z-ADD     0             OIQTAL
     C                   Z-ADD     0             OISOW
     C                   MOVE      *BLANKS       OILOTC
     C                   MOVEL     'A'           OISTAT
     C   91              WRITE     RIORDR
     C  N91              UPDATE    RIORDR
     C                   END                                                    COMNT > ' '
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
      ** SEE IF WE SHOULD CLOSE ORDER
     C                   SETOFF                                       7071
     C     TOTLIN        IFLE      0
     C     VORDER        SETLL     FIORDR
     C     NXTPT1        TAG
     C     VORDER        READE     FIORDR                                 90
     C   90              GOTO      ENDPT1
WJB  C                   Eval      OITEM5 = %SUBST(OIITEM:1:5)
     C     OISTAT        IFEQ      'A'
     C     OIITYP        ANDEQ     'C'
     C                   SETON                                        71
     C                   GOTO      NXTPT1
     C                   END
     C     OISTAT        IFEQ      'A'
     C                   SETON                                        70
     C                   GOTO      ENDPT1
     C                   END
     C                   GOTO      NXTPT1
     C     ENDPT1        TAG
     C  N70              DO
      ** IF COMMENTS LEFT DELETE THEM
     C   71              DO
     C     VORDER        SETLL     FIORDR
     C     NXTPT2        TAG
     C     VORDER        READE     FIORDR                                 90
     C   90              GOTO      ENDPT2
WJB  C                   Eval      OITEM5 = %SUBST(OIITEM:1:5)
     C                   MOVEL     'D'           OISTAT
     C                   MOVEL     'Y'           OICOFL
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     TIMOD         OITIME
     C                   Z-ADD     TDATE         OIDTLA
     C                   UPDATE    RIORDR
     C                   GOTO      NXTPT2
     C                   ENDDO                                                   71  DO
     C     ENDPT2        TAG
     C     VORDER        CHAIN     FHORDR                             90
     C                   MOVEL     'D'           OHSTAT
     C                   MOVEL     'Y'           OHCOFL
     C                   UPDATE    RHORDR
     C                   Eval      HSTUSER    = $User()
     C                   Eval      HSTPROGRAM = 'BOR100_2'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
     C                   ENDDO                                                  N70  DO
     C                   END                                                    TOTLIN=<0
     C                   SETOFF                                       98
     C                   ENDSR
      *******************
      * CANCEL ALL OPEN *
      *******************
     C     CANALL        BEGSR
     C                   SETOFF                                       222324
     C                   SETOFF                                       252632
     C                   SETOFF                                       33  99
     C                   Z-ADD     0             RECNO
     C     NXTCAN        TAG
     C                   ADD       1             RECNO
     C                   SETOFF                                       132131
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCAN
     C                   END
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTCAN
      ** FORCEC INTO CANCEL CODE
     C                   MOVEL     'C'           CANCOD
     C                   UPDATE    ORDSFL
     C                   GOTO      NXTCAN
     C     ENDCAN        TAG
     C                   ENDSR
      *******************
      * DE-ALLOCATE     *
      *******************
     C     UNALLO        BEGSR
     C     MINKEY        CHAIN     FMINVT                             90
     C                   SUB       DELQTY        IMQTAL
     C     IMQTAL        IFLE      0
     C                   Z-ADD     0             IMQTAL
     C                   END
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C  N90              UPDATE    RMINVT
     C     MINKEY        CHAIN     FLKITM                             90
     C                   SUB       DELQTY        LKPAL
     C     LKPAL         IFLE      0
     C                   Z-ADD     0             LKPAL
     C                   END
     C  N90              UPDATE    RLKITM
     C                   ENDSR
      *******************
      *    ALLOCATE     *
      *******************
     C     ALLO          BEGSR
     C     MINKEY        CHAIN     FMINVT                             90
     C                   ADD       NEWQTY        IMQTAL
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C  N90              UPDATE    RMINVT
     C     MINKEY        CHAIN     FLKITM                             90
     C                   SUB       NEWQTY        LKPAL
     C  N90              UPDATE    RLKITM
     C                   ENDSR
      *******************
      * GET CODE        *
      *******************
     C     GETCOD        BEGSR
     C                   SETOFF                                       66
     C     NXTCOD        TAG
     C                   WRITE     SCRNCOD
     C                   READ      SCRNCOD                                90
     C     BLNK          IFGT      *BLANKS
     C                   MOVE      *BLANKS       CANCOD
     C                   GOTO      ENDCOD
     C                   END
     C     CODC          IFGT      *BLANKS
     C                   MOVEL     'C'           CANCOD
     C                   GOTO      ENDCOD
     C                   END
     C     CODO          IFGT      *BLANKS
     C                   MOVEL     'O'           CANCOD
     C                   GOTO      ENDCOD
     C                   END
      ** IF HERE NO SELECTION MADE
     C                   SETON                                        66
     C                   GOTO      NXTCOD
     C     ENDCOD        TAG
     C                   SETOFF                                       66
     C                   ENDSR
      *******************
      * LOAD B SCREEN   *
      *******************
     C     LOADB         BEGSR
     C                   MOVEL     OHSHZP        VZIPA1
     C                   MOVE      OHSHZP        VZIPA2
     C                   MOVEL     OHSLZP        VZIPB1
     C                   MOVE      OHSLZP        VZIPB2
     C     OHSHPC        CHAIN     FMSVIA                             90
     C     OHCUST        CHAIN     FCUSTCOM                           90
     C   90              CLEAR                   RCUSTCOM
     C     OHSHFR        CHAIN     FMWHSE                             90
     C     OHCUST        CHAIN     FMCUST                             90
     C                   MOVEL     OHSHPC        OSHPC
     C                   MOVEL     OHPONO        OPONO
     C                   MOVEL     OHSPIN        OSPIN
     C                   MOVEL     OHSHIN        OSHIN
     C                   MOVEL     OHLOC         OLOC
     C                   MOVEL     OHROUT        OROUT
     C                   Z-ADD     OHSTOP        OSTOP
     C                   Z-ADD     OHDTRQ        NEWSHP
     C                   ENDSR
      *******************
      * GET DESCRIPTION *
      *******************
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVE      *BLANKS       VDESC
     C                   MOVEL     'I'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         VDESC
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    TDATE                          DATE MDY
     C                   PARM                    TDCYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   MOVE      *BLANKS       DESHFR
     C                   ENDSR
** MESSAGE
      ** End of Order **
