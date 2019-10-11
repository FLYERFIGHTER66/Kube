      *--------------------------------------------------------------
      *
      *   COPYRIGHT EFD ENTERPRISES INC.     1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       E F D ENTERPRISES INC. ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *       EFD ENTERPRISES INC.  215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- APR310
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- POST A/P VOUCHERS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFAPWK     UF   E           K DISK
     FFAPWKS    UF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFAPCTL    UF   E           K DISK
     FFAPCTLB   UF   E           K DISK
     FFMVEND    UF   E           K DISK
     FFAPFUT    UF A E           K DISK
     FFAPOPN    UF A E           K DISK
     FFAPDET    O  A E           K DISK
     FFAPDTP    O  A E           K DISK
     FFAPREC    UF A E           K DISK
     FFAPMTH    O  A E           K DISK
     FFUSETAX   O  A E           K DISK
     FAPR310    O    F  120        PRINTER OFLIND(*INOF)
      *
     D MSG             S             34    DIM(3) CTDATA PERRCD(1)
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
     D                UDS
     D  LCO                    1      2  0
     D  LUSER                  3     12
     D  LRPT                  13     13
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
      *
     C     LRPT          IFEQ      'Y'
     C                   SETON                                        86
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCORG                             88
     C   86              EXCEPT    HDG
      *
      * 88 = COMPANY RUNS G/L
      *
     C     LCO           CHAIN(N)  FAPCTL                             90
     C     AZGL          IFEQ      'N'
     C                   SETON                                        88
     C                   ELSE
     C                   SETOFF                                       88
     C                   ENDIF
      *
      * COMPANY DOES NOT RECONCILE CHECKS
      *
     C     AZREC         IFEQ      'Y'
     C                   SETON                                        87
     C                   ENDIF
      *
     C     NXT           TAG
     C                   SETOFF                                       312250
     C                   READ      FAPWK                                  90
     C   90              GOTO      END
      *
     C     AWSTAT        IFNE      'A'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     AWCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LUSER         IFGT      *BLANKS
     C     LUSER         ANDNE     AWUSER
     C                   GOTO      NXT
     C                   ENDIF
      *
      * GET VENDOR FILE
      *
     C     AWVEND        CHAIN     FMVEND                             22
      *
     C     AWUTAX        IFEQ      'Y'
     C     AWUTX$        ANDNE     0
     C                   SETON                                        50
     C                   ENDIF
      *
      * VERIFIY IF MANUAL CHECK
      *
     C     AWITYP        IFEQ      'M'
     C     AWITYP        orEQ      'W'
     C                   EXSR      MANUAL
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK IF VENDOR ALLOWS DUPLICATE INVOICES                      ORT
      *
     C     VMCDUP        IFEQ      'N'
     C                   GOTO      NODUP
     C                   ENDIF
      *
      * ADD RECORD TO A/P OPEN INVOICE FILE APOPN IF NO DUP RECORD
      *
     C     APKEY         KLIST
     C                   KFLD                    AWVEND
     C                   KFLD                    AWCOMP
     C                   KFLD                    AWVOUC
     C                   KFLD                    AWINV#
     C                   KFLD                    AWSEQ#
     C                   KFLD                    AWITYP
     C     APKEY         SETLL     FAPOPN
     C     APKEY         READE     FAPOPN                                 92
     C   92              GOTO      NODUP
     C                   MOVEL     MSG(2)        ERR              34
     C                   EXCEPT    DETL
     C                   SETON                                        99
     C                   GOTO      NXT
     C     NODUP         TAG
      *
      * IF FLAGGED FOR IMMEDIATE PAY, CALCULATE AMOUNT TO BE PAID
      * AND DISCOUNT (IF AVAILABLE) - FLAG TO BE PAID IN A/P OPEN
      *
     C                   Z-ADD     0             CDISCT            7 2
     C                   Z-ADD     0             DSCWK             9 2
      *
     C     AWITYP        IFEQ      'I'
     C                   SETON                                            32
     C                   ELSE
     C                   GOTO      NOIMM
     C                   ENDIF
      *
      * CHECK IF DISCOUNT IS AVAILABLE.
      *
     C                   Z-ADD     AWDCDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DISDTE            6 0
      *
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         TODAY             6 0
      *
     C     DISDTE        IFLT      TODAY
     C                   SETON                                        72
     C                   ENDIF
      *
      * CREDIT VOUCHER
      *
     C     AWITYP        IFEQ      'C'
     C                   SETON                                        73
     C                   ENDIF
      *
      * DISCOUNT PERCENT
      *
     C     AWTRAT        IFGT      0
     C                   SETON                                        74
     C                   ENDIF
      *
     C   74AWTRAT        MULT(H)   AW$AMT        CDISCT
      *
     C  N72              GOTO      NODIS
     C     AW$AMT        SUB       AWDAVL        AP$TOP
     C                   Z-ADD     AWDAVL        APDISC
     C   74              Z-ADD     CDISCT        APDISC
     C   74AW$AMT        SUB       CDISCT        AP$TOP
     C     NODIS         TAG
      *
     C   72
     CANN73              Z-ADD     AW$AMT        AP$TOP
     C   72
     CAN 73              Z-SUB     AW$AMT        AP$TOP
      *
     C     NOIMM         TAG
     C                   EXSR      UAPOPN
     C                   EXSR      UAPDET
     C                   EXSR      UPAPWK
     C                   EXSR      UPVEND
     C   50              EXSR      USETAX
      *
     C                   ADD       1             ACNT              4 0
     C                   ADD       1             LRACNT            4 0
     C                   ADD       AW$AMT        AVALU            13 2
     C                   ADD       AW$AMT        LRAVLU           13 2
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TLR
      ** GET CONTROL FILE RECORDS
     C     LUSER         IFGT      *BLANKS
     C                   SETON                                        55
     C                   END
     C     LCO           CHAIN     FAPCTL                             80
     C     CTLKEY        KLIST
     C                   KFLD                    ABCOMP
     C                   KFLD                    ABUSER
     C                   KFLD                    ABTYPE
     C                   MOVEL     'VOUCH'       ABTYPE
     C                   Z-ADD     LCO           ABCOMP
     C                   MOVEL     LUSER         ABUSER
     C                   MOVEL     'N'           AZOKP
     C                   MOVEL     'N'           OK                1
      ** ONLY UPDATE CONTROL FILE IF ALL USERS SELECTED
     C  N80
     CANN55              UPDATE    RAPCTL
      ** SELECTED USER
     C   55              DO
     C     CTLKEY        CHAIN     FAPCTLB                            81
     C                   MOVEL     OK            ABOK
     C  N81              UPDATE    RAPCTLB
     C                   ENDDO                                                  55 DO
      ** ALL USERS
     C  N55              DO
     C     LCO           SETLL     FAPCTLB
     C     NXTUSR        TAG
     C     LCO           READE     FAPCTLB                                81
     C   81              GOTO      ENDUSR
     C                   MOVEL     OK            ABOK
     C                   UPDATE    RAPCTLB
     C                   GOTO      NXTUSR
     C     ENDUSR        TAG
     C                   ENDDO                                                  N55 DO
     C                   SETON                                        LR
      *
      **********                                                       ***
      * MANUAL *                                                       ***
      **********                                                       ***
      *
     C     MANUAL        BEGSR
      *
     C                   SETOFF                                       60
      *
     C                   ADD       1             MCNT              4 0
     C                   ADD       1             LRMCNT            4 0
     C                   ADD       AW$AMT        MVALU            13 2
     C                   ADD       AW$AMT        LRMVLU           13 2
     C                   EXSR      UAPDET
     C                   EXSR      UPAPWK
     C                   EXSR      UPVEND
     C                   EXSR      UAPDTP
     C   50              EXSR      USETAX
     C                   EXSR      UAPMTH
     C   87              EXSR      UAPREC
     C                   MOVEL     'Y'           APCLCD
     C                   Z-ADD     AW$AMT        APPAID
     C                   EXSR      UAPOPN
     C                   MOVEL     *BLANKS       APCLCD
     C                   Z-ADD     0             APPAID
     C     ENDMAN        ENDSR
      *
      **********                                                       ***
      * UAPDET *                                                       ***
      **********                                                       ***
      *
      * ADD RECORD TO A/P DETAIL FILE - APDET
      * OUTPUT GL RECORD FROM APWK - EITHER AP OR CASH ACCOUNT
      *
     C     UAPDET        BEGSR
      *
     C                   MOVEL     AWSTAT        ADSTAT
     C                   Z-ADD     AWCOMP        ADCOMP
     C                   Z-ADD     AWVOUC        ADVOUC
     C                   Z-ADD     AWVEND        ADVEND
     C                   MOVEL     AWINV#        ADINV#
     C                   Z-ADD     AWSEQ#        ADSEQ#
     C                   MOVEL     AWITYP        ADITYP
     C                   MOVEL     AWVTYP        ADVTYP
     C                   MOVEL     APPONO        ADPONO
     C                   Z-ADD     APIVDT        ADIVDT
     C                   Z-ADD     AWDUDT        ADDUDT
     C                   Z-ADD     AWDCDT        ADDCDT
     C                   MOVEL     AWVTCD        ADVTCD
     C                   Z-ADD     AW$AMT        AD$AMT
     C                   Z-ADD     AWDAVL        ADDAVL
     C                   Z-ADD     AWTRAT        ADTRAT
     C                   Z-ADD     AWGLAC        ADGLAC
     C                   Z-ADD     AWTDAT        ADTDAT
     C                   Z-ADD     AWTTYP        ADTTYP
     C                   MOVEL     *BLANKS       ADMCIP
     C                   Z-ADD     AWCHEK        ADCHEK
     C                   Z-ADD     AWCKDT        ADCKDT
     C                   Z-ADD     AWBTCH        ADBTCH
     C                   MOVEL     *BLANKS       ADGLUD
     C                   Z-ADD     AWGLAC        ADGLA1
     C                   Z-SUB     AW$AMT        ADGL$1
     C                   Z-ADD     TDATE         ADDTLA
     C                   Z-ADD     TIMOD         ADTIME
     C                   MOVEL     USERID        ADUSER
     C                   Z-ADD     AWAPER        ADAPER
     C                   MOVEL     AWTDES        ADTDES
     C                   Z-ADD     AWPERD        ADPERD
     C                   MOVEL     *BLANKS       ADPAID
     C                   Z-ADD     0             ADPDPR
     C                   WRITE     RAPDET
      *
      * NOW GET APWKS RECORDS
      *
     C                   Z-ADD     0             SEQ               3 0
     C     WKSKEY        KLIST
     C                   KFLD                    AWCOMP
     C                   KFLD                    AWVOUC
     C                   KFLD                    AWVEND
     C                   KFLD                    AWINV#
     C                   KFLD                    AWITYP
     C                   KFLD                    SEQ
     C     WKKEYC        KLIST
     C                   KFLD                    AWCOMP
     C                   KFLD                    AWVOUC
     C                   KFLD                    AWVEND
     C                   KFLD                    AWINV#
     C                   KFLD                    AWITYP
     C     WKSKEY        SETLL     FAPWKS
     C     LOOP          TAG
     C                   SETOFF                                       80
     C     WKKEYC        READE     FAPWKS                                 80
     C   80              GOTO      PASS
     C     APSTAT        IFNE      'A'
     C                   GOTO      LOOP
     C                   END
     C     APPDTD        IFEQ      'P'
     C                   GOTO      LOOP
     C                   END
     C                   ADD       1             AWSEQ#
      *
      * OUTPUT GL RECORD FROM APWKS - EXPENSE RECORDS
      *
     C                   MOVEL     APSTAT        ADSTAT
     C                   Z-ADD     APCOMP        ADCOMP
     C                   Z-ADD     APVOUC        ADVOUC
     C                   Z-ADD     APVEND        ADVEND
     C                   MOVEL     APINV#        ADINV#
     C                   Z-ADD     APSEQ#        ADSEQ#
     C                   MOVEL     APITYP        ADITYP
     C                   MOVEL     APPONO        ADPONO
     C                   Z-ADD     APIVDT        ADIVDT
     C                   Z-ADD     AP$AMT        AD$AMT
     C                   Z-ADD     AWGLAC        ADGLAC
     C                   Z-ADD     APTDAT        ADTDAT
     C                   MOVEL     APVTYP        ADVTYP
     C                   MOVEL     AWTDES        ADTDES
     C                   Z-ADD     APAPER        ADAPER
     C                   Z-ADD     APPERD        ADPERD
     C                   Z-ADD     AWDUDT        ADDUDT
     C                   Z-ADD     AWDCDT        ADDCDT
     C                   MOVEL     AWVTCD        ADVTCD
     C                   Z-ADD     AWDAVL        ADDAVL
     C                   Z-ADD     AWTRAT        ADTRAT
     C                   Z-ADD     AWTTYP        ADTTYP
     C                   MOVEL     *BLANKS       ADMCIP
     C                   Z-ADD     AWCHEK        ADCHEK
     C                   Z-ADD     AWCKDT        ADCKDT
     C                   Z-ADD     AWBTCH        ADBTCH
     C                   MOVEL     *BLANKS       ADGLUD
     C                   Z-ADD     APGLAC        ADGLA1
     C                   Z-ADD     AP$AMT        ADGL$1
     C                   Z-ADD     TDATE         ADDTLA
     C                   Z-ADD     TIMOD         ADTIME
     C                   MOVEL     USERID        ADUSER
     C                   MOVEL     *BLANKS       ADPAID
     C                   Z-ADD     0             ADPDPR
     C                   WRITE     RAPDET
     C                   MOVEL     'P'           APPDTD
     C                   MOVEL     'D'           APSTAT
     C                   UPDATE    RAPWKS
     C                   GOTO      LOOP
     C     PASS          TAG
     C                   Z-ADD     0             GLDOLL           11 2
     C                   Z-SUB     AW$AMT        GLDOLL
      *
     C                   ENDSR
      **********                                                       ***
      * UAPOPN *                                                       ***
      **********                                                       ***
     C     UAPOPN        BEGSR
     C                   MOVEL     'A'           APSTAT
     C                   Z-ADD     AWVEND        APVEND
     C                   Z-ADD     AWCOMP        APCOMP
     C                   Z-ADD     AWVOUC        APVOUC
     C                   MOVEL     AWINV#        APINV#
     C                   Z-ADD     0             APSEQ#
     C                   MOVEL     AWITYP        APITYP
     C                   MOVEL     AWVTYP        APVTYP
     C                   MOVEL     AWPONO        APPONO
     C                   Z-ADD     AWIVDT        APIVDT
     C                   Z-ADD     AWDUDT        APDUDT
     C                   Z-ADD     AWDCDT        APDCDT
     C                   MOVEL     AWVTCD        APVTCD
     C                   Z-ADD     AW$AMT        AP$AMT
     C     AWITYP        IFEQ      'M'
     C     AWITYP        orEQ      'W'
     C                   Z-ADD     AW$AMT        APPAID
     C                   Z-ADD     0             APDUE$
     C                   ELSE
     C                   Z-ADD     0             APPAID
     C                   Z-ADD     AW$AMT        APDUE$
     C                   ENDIF
     C                   Z-ADD     AWDAVL        APDAVL
     C                   Z-ADD     AWTRAT        APTRAT
     C                   Z-ADD     0             APDTAK
     C                   Z-ADD     AWGLAC        APGLAC
     C                   Z-ADD     AWTDAT        APTDAT
     C                   Z-ADD     AWTTYP        APTTYP
     C                   MOVEL     AWTDES        APTDES
     C                   MOVEL     AWLOOK        APLOOK
     C                   Z-ADD     AWCHEK        APCHEK
     C                   Z-ADD     AWCKDT        APCKDT
     C     AWITYP        IFEQ      'I'
     C                   MOVEL     'Y'           APTBPD
     C                   Z-ADD     AWDAVL        APDISC
     C     AW$AMT        SUB       AWDAVL        NETAMT           11 2
     C                   Z-ADD     NETAMT        AP$TOP
     C                   ELSE
     C                   MOVEL     ' '           APTBPD
     C                   Z-ADD     0             APDISC
     C                   Z-ADD     0             AP$TOP
     C                   ENDIF
     C     AWTBPD        IFEQ      'H'
     C                   MOVEL     'H'           APTBPD
     C                   ENDIF
     C                   Z-ADD     TDATE         APDTLA
     C                   Z-ADD     TIMOD         APTIME
     C                   MOVEL     AWUSER        APUSER
     C                   Z-ADD     AWAPER        APAPER
     C     AWDUDT        MULT      10000.01      RVDATE            6 0
     C                   MOVEL     RVDATE        YR                2 0
     C     YR            IFGT      70
     C                   MOVEL     19            CYR               2 0
     C                   ELSE
     C                   MOVEL     20            CYR
     C                   ENDIF
     C                   MOVEL     CYR           APRVDU
     C                   MOVE      RVDATE        APRVDU
     C                   WRITE     RAPOPN
     C                   ENDSR
      **********                                                       ***
      * UAPDTP *                                                       ***
      **********                                                       ***
     C     UAPDTP        BEGSR
     C                   MOVEL     'A'           ATSTAT
     C                   Z-ADD     AWVEND        ATVEND
     C                   Z-ADD     AWCOMP        ATCOMP
     C                   Z-ADD     AWVOUC        ATVOUC
     C                   MOVEL     AWINV#        ATINV#
     C                   MOVEL     AWITYP        ATITYP
     C                   Z-ADD     AWDAVL        ATDTAK
     C                   Z-ADD     AW$AMT        ATPAID
     C                   Z-ADD     AWCHEK        ATCHEK
     C                   Z-ADD     AWCKDT        ATCKDT
     C                   MOVEL     AWTDES        ATDESC
     C                   MOVEL     AWLOOK        ATLOOK
     C     ATCKDT        MULT      10000.01      ATRVDT            6 0
     C                   MOVEL     ATRVDT        YR                2 0
     C     YR            IFGT      70
     C                   MOVEL     0             CENT              1 0
     C                   ELSE
     C                   MOVEL     1             CENT
     C                   ENDIF
     C                   MOVEL     CENT          ATCYMD
     C                   MOVE      ATRVDT        ATCYMD
     C                   WRITE     RAPDTP
     C                   ENDSR
      **********
      * UAPMTH *
      **********
     C     UAPMTH        BEGSR
     C                   MOVEL     'A'           AMSTAT
     C                   Z-ADD     AWCOMP        AMCOMP
     C                   Z-ADD     AWCHEK        AMCHEK
     C                   Z-ADD     AWCKDT        AMCKDT
     C                   Z-ADD     AWVEND        AMVEND
     C                   Z-ADD     AW$AMT        AM$AMT
     C*??                  Z-ADDDISC      AMDTAK
     C                   Z-ADD     AW$AMT        AM$NET
     C                   Z-ADD     AWTDAT        AMTDAT
     C                   MOVEL     MSG(3)        AMTDES
     C                   Z-ADD     AWAPER        AMPEDT
     C                   Z-ADD     TDATE         AMDTLA
     C                   Z-ADD     TIMOD         AMTIME
     C                   MOVEL     USERID        AMUSER
     C                   MOVEL     'M'           AMCTYP
     C                   MOVEL     'Y'           AMGLUD
     C                   WRITE     RAPMTH
     C                   ENDSR
      **********
      * UAPREC *
      **********
     C     UAPREC        BEGSR
     C     RECKEY        KLIST
     C                   KFLD                    AWCOMP
     C                   KFLD                    AWCHEK
     C     RECKEY        CHAIN     FAPREC                             77
     C   77              DO
     C                   MOVEL     'A'           AKSTAT
     C                   Z-ADD     AWCOMP        AKCOMP
     C                   Z-ADD     AWCHEK        AKCHEK
     C                   Z-ADD     AWCKDT        AKCKDT
     C                   Z-ADD     AWVEND        AKVEND
     C                   Z-ADD     AW$AMT        AK$AMT
     C                   Z-ADD     0             AKDTAK
     C                   Z-ADD     AW$AMT        AK$NET
     C                   Z-ADD     AWTDAT        AKTDAT
     C                   MOVEL     AWTDES        AKTDES
     C                   Z-ADD     AWAPER        AKPEDT
     C                   Z-ADD     TDATE         AKDTLA
     C                   Z-ADD     TIMOD         AKTIME
     C                   MOVEL     USERID        AKUSER
     C                   MOVEL     'M'           AKCTYP
     C                   WRITE     RAPREC
     C                   ENDDO                                                  77  DO
     C  N77              DO
     C                   ADD       AW$AMT        AK$AMT
     C                   ADD       AW$AMT        AK$NET
     C                   Z-ADD     TDATE         AKDTLA
     C                   Z-ADD     TIMOD         AKTIME
     C                   MOVEL     USERID        AKUSER
     C                   UPDATE    RAPREC
     C                   ENDDO                                                  N77  DO
     C                   ENDSR
      *
      **********                                                       ***
      * UPAPWK *                                                       ***
      **********                                                       ***
      *
      * INDICATE APWRK RECORD USED BY PUTTING 'P' IN 1ST POSITION
      *
     C     UPAPWK        BEGSR
     C                   MOVEL     'P'           AWSTAT
     C                   UPDATE    RAPWK
     C                   ENDSR
      *
      **********                                                       ***
      * UPVEND *                                                       ***
      **********                                                       ***
      * UPDATE VENDOR MASTER YTD PURCHASES AND YTD DISCOUNT AVAILABLE
      *
     C     UPVEND        BEGSR
     C                   Z-ADD     TDATE         VMDTLA
     C                   Z-ADD     TIMOD         VMTIME
     C                   MOVEL     USERID        VMUSER
     C                   Z-ADD     AWIVDT        VMDTLP
     C     AWITYP        IFEQ      'M'
     C     AWITYP        orEQ      'W'
     C                   Z-ADD     AWCKDT        VMDTPY
     C                   ENDIF
      ** CHECK IF FUTURE DATE
     C                   Z-ADD     AWAPER        TRNDAT
     C                   CALL      'GETAPER'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    TRNDAT            6 0
     C                   PARM                    ERR1              1 0
      **
     C     ACTPER        IFNE      99
     C                   ADD       AW$AMT        VMYPUR
     C                   ADD       AWDAVL        VMYDAV
     C   74              ADD       CDISCT        VMYDAV
     C     AWITYP        IFEQ      'M'
     C     AWITYP        orEQ      'W'
     C                   ADD       AW$AMT        VMPAID
     C                   ENDIF
     C                   ELSE
     C     AWVEND        CHAIN     FAPFUT                             97
     C   97              DO
     C                   CLEAR                   RAPFUT
     C                   Z-ADD     AWVEND        AFVEND
     C                   MOVEL     'A'           AFSTAT
     C                   ENDDO
     C                   ADD       AW$AMT        AFPURC
     C                   ADD       AWDAVL        AFDALO
     C   97              WRITE     RAPFUT
     C  N97              UPDATE    RAPFUT
     C                   END
     C  N22              UPDATE    RMVEND
     C                   ENDSR
      *
      **********                                                       ***
      * USETAX *                                                       ***
      **********                                                       ***
     C     USETAX        BEGSR
     C                   MOVEL     'A'           UXSTAT
     C                   Z-ADD     AWVEND        UXVEND
     C                   Z-ADD     AWCOMP        UXCOMP
     C                   Z-ADD     AWVOUC        UXVOUC
     C                   MOVEL     AWINV#        UXINV#
     C                   Z-ADD     0             UXSEQ#
     C                   Z-ADD     AW$AMT        UX$AMT
     C                   Z-ADD     AWUTX$        UXTAX$
     C                   MOVEL     AWTDES        UXTDES
     C                   Z-ADD     TDATE         UXDTLA
     C                   Z-ADD     TIMOD         UXTIME
     C                   MOVEL     AWUSER        UXUSER
     C                   Z-ADD     AWAPER        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        UXDATE
     C                   WRITE     RUSETAX
     C                   ENDSR
     OAPR310    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           61 'Accounts Payable'
     O                                           74 'Voucher Post'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           62 'Posting Summary -'
     O                                           75 'Error Report'
     O          E            HDG            1
     O                                           28 '- - - -  Vendor - - - -'
     O                                           60 'Invoice'
     O                                           75 'Invoice'
     O          E            HDG            0
     O                                            9 'Number'
     O                                           26 'Name'
     O                                           49 'Voucher'
     O                                           59 'Number'
     O                                           68 'Date'
     O                                           78 'Due Date'
     O                                           91 'Amount'
     O                                          113 'Error'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       AWVEND        Z      6
     O                 N22   VMNAME              37
     O                       AWVOUC        Z     44
     O                       AWINV#              55
     O                       AWIVDT        Y     64
     O                       AWDUDT        Y     73
     O                       AW$AMT        M     86
     O                       ERR                120
     O          E            TLR         2  1
     O               99                          54 '** No Action Has Been'
     O               99                          74 'Taken On The Listed'
     O               99                          88 'Line Items **'
     O          E            TLR            2
     O               99                          74 '** Check These Items and'
     O               99                          93 'Update As Required'
     O          E            TLR            2
     O              N99                          72 '** No Errors Found **'
     O          E            TLR            2
     O                                           51 'Total Open Accounts'
     O                                           60 'Payable:'
     O                       AVALU         K     78
     O          E            TLR            2
     O                                           60 'Total Manual Checks:'
     O                       MVALU         K     78
**  ERROR MESSAGES FOR REPORT
 ** Manual Check Number Used **                                                1
 ** Record Exists In Open A/P **                                               3
A/P Manual Check                                                               3
