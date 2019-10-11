      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      *PROGRAM NAME-------- APR270
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- DELETE AN OPEN ACCOUNTS PAYABLE.
      *DESCRIPTION-
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FAPR270FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFAPOPN    UF   E           K DISK
     FFMVEND    UF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFAPCTL    IF   E           K DISK
     FFAPDET    O  A E             DISK
     FAPR270    O    F  120        PRINTER OFLIND(*INOF)
      *
      * MAPER ARRAYS
      *
     D BEG             S              6  0 DIM(13)                              BEG DATES
     D DNE             S              6  0 DIM(13)                              END DATES
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
     D  USERID               254    261
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
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
     IRMAPER
     I              ACST01                      BEG(1)
     I              ACST02                      BEG(2)
     I              ACST03                      BEG(3)
     I              ACST04                      BEG(4)
     I              ACST05                      BEG(5)
     I              ACST06                      BEG(6)
     I              ACST07                      BEG(7)
     I              ACST08                      BEG(8)
     I              ACST09                      BEG(9)
     I              ACST10                      BEG(10)
     I              ACST11                      BEG(11)
     I              ACST12                      BEG(12)
     I              ACST13                      BEG(13)
     I              ACEN01                      DNE(1)
     I              ACEN02                      DNE(2)
     I              ACEN03                      DNE(3)
     I              ACEN04                      DNE(4)
     I              ACEN05                      DNE(5)
     I              ACEN06                      DNE(6)
     I              ACEN07                      DNE(7)
     I              ACEN08                      DNE(8)
     I              ACEN09                      DNE(9)
     I              ACEN10                      DNE(10)
     I              ACEN11                      DNE(11)
     I              ACEN12                      DNE(12)
     I              ACEN13                      DNE(13)
      *
     C     RSTRT         TAG
     C                   Z-ADD     0             VVEND
     C                   Z-ADD     0             VVOUCH
     C                   Z-ADD     0             VACTP
     C                   MOVEL     *BLANKS       VINV#
     C                   MOVEL     *BLANKS       VTYPE
     C                   MOVEL     *BLANKS       VMNAME
     C                   SETOFF                                       98
      *
     C     NXTA          TAG
     C                   Z-ADD     0             CNT
     C                   WRITE     SCRNA
     C                   SETOFF                                       101213
     C                   SETOFF                                       203035
     C                   SETOFF                                       515260
     C                   SETOFF                                       1198
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
      *
     C     VVEND         IFEQ      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   Z-ADD     LCO           VMCOMP            2 0
     C                   MOVEL     VALPHA        VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        VVEND
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         IFEQ      *ZEROS
     C   10              SETON                                        1011
     C   10              GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         CHAIN     FMVEND                             90
     C   90              SETON                                        1011
     C   10              GOTO      NXTA
      *
     C     OVEND         IFNE      VVEND
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VVEND         OVEND             6 0
      *
     C                   MOVEL     VMNAME        VNAME            26
     C                   Z-ADD     VMGLAC        VGL               8 0
      *
     C   KD              DO
     C                   Z-ADD     VVEND         APVEND
     C                   CALL      'LKAPOPN'
     C                   PARM                    APVEND            6 0
     C                   PARM                    VCO               2 0
     C                   PARM                    APVOUC            6 0
     C                   PARM                    APINV#           10
     C                   PARM                    APITYP            1
     C                   PARM                    APSEQ#            3 0
     C                   PARM                    APTDES           30
     C                   MOVEL     APVOUC        VVOUCH
     C                   MOVEL     APINV#        VINV#
     C                   MOVEL     APITYP        VTYPE
     C                   Z-ADD     APSEQ#        VSEQ              3 0
     C                   GOTO      NXTA
     C                   ENDDO
      *
     C   KB              DO
     C                   Z-ADD     LCO           VCO               2 0
     C                   CALL      'LKACTP'
     C                   PARM                    VCO
     C                   PARM                    VACTP
     C                   GOTO      NXTA
     C                   ENDDO
      *
     C     VVOUCH        IFEQ      *ZEROS
     C                   SETON                                        20
     C   20              GOTO      NXTA
     C                   ENDIF
      *
     C     OVOUC         IFNE      VVOUCH
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VVOUCH        OVOUC             6 0
      *
     C     VINV#         IFEQ      *BLANKS
     C                   SETON                                        30
     C   30              GOTO      NXTA
     C                   ENDIF
      *
     C     OVINV#        IFNE      VINV#
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VINV#         OVINV#           10
      *
     C     VTYPE         IFNE      ' '
     C     VTYPE         ANDNE     'F'
     C     VTYPE         ANDNE     'C'
     C     VTYPE         ANDNE     'I'                                                      Y
     C                   SETON                                        40
     C   40              GOTO      NXTA
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCORG                             90
      *
     C     OTYPE         IFNE      VTYPE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VTYPE         OTYPE             1
      *
     C  N88              DO
     C     VACTP         IFLT      1
     C     VACTP         ORGT      13
     C                   SETON                                        60
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C                   Z-ADD     VACTP         X                 2 0
     C                   Z-ADD     BEG(X)        BDATE             6 0
     C                   Z-ADD     DNE(X)        EDATE             6 0
     C                   ENDDO
      *
      * CHECK IF RECORD EXISTS IN FAPOPN
      *
     C     APKEY         KLIST
     C                   KFLD                    VVEND
     C                   KFLD                    LCO
     C                   KFLD                    VVOUCH
     C                   KFLD                    VINV#
     C                   KFLD                    VSEQ
     C                   KFLD                    VTYPE
     C     APKEY         CHAIN     FAPOPN                             92
     C   92              SETON                                        1211
     C   12              GOTO      NXTA
      *
     C     APCLCD        IFEQ      'Y'
     C                   SETON                                        1112
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     APDUE$        IFEQ      0
     C                   SETON                                        1311
     C   13              GOTO      NXTA
     C                   ENDIF
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C   98              GOTO      NXTA
     C                   ENDIF
      *
     C  N88              GOTO      RSTRTS
     C   OF              DO
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    DETAIL
     C     APKEY         CHAIN     FAPOPN                             92
     C                   MOVEL     'D'           APSTAT
     C                   MOVEL     'Y'           APCLCD
     C                   Z-ADD     0             APDUE$
     C                   UPDATE    RAPOPN
     C                   GOTO      RSTRT
      *
      *
     C     RSTRTS        TAG
     C                   Z-ADD     0             CNT
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
      *
     C                   EXSR      BLDSFL
     C     NXTSFL        TAG
     C                   EXFMT     RECCTL
     C   KF              GOTO      RSTRT
     C   KB              DO
     C     LINE          CHAIN     RECSFL                             90
     C                   EXSR      LOOK
     C                   UPDATE    RECSFL
     C                   ENDDO
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTSFL
     C   KA              DO
     C                   EXSR      PUTSFL
     C                   GOTO      RSTRT
     C                   ENDDO
     C                   GOTO      NXTSFL
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      ***********
      * BLDSFL
      ***********
     C     BLDSFL        BEGSR
     C                   SETOFF                                       1030
     C                   Z-ADD     APDUE$        BAL
     C                   Z-ADD     0             GLNO
     C                   Z-ADD     0             DEBIT
     C                   Z-ADD     0             CREDIT
     C                   Z-ADD     VGL           GLNO
     C     APDUE$        IFGT      0
     C                   Z-ADD     APDUE$        CREDIT
     C                   ELSE
     C                   Z-SUB     APDUE$        DEBIT
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       DESC
     C     NXTBLD        TAG
     C     RECNO         IFGE      1
     C                   Z-ADD     0             GLNO
     C                   Z-ADD     0             DEBIT
     C                   Z-ADD     0             CREDIT
     C                   ENDIF
     C                   ADD       1             RECNO
     C     RECNO         IFGT      50
     C                   GOTO      ENDBLD
     C                   ENDIF
     C                   WRITE     RECSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ENDSR
      *
      ***********
      * CHKSFL
      ***********
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     APDUE$        BAL
     C                   SETOFF                                       103099
     C                   SETOFF                                       40
     C     NXTCHK        TAG
     C                   SETOFF                                       103031
     C                   SETOFF                                       32
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   ENDIF
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTCHK
     C     GLNO          IFLE      0
     C     DEBIT         ANDLE     0
     C     CREDIT        ANDLE     0
     C                   MOVE      *BLANKS       DESC
     C                   GOTO      NXTCHK
     C                   ENDIF
     C     GLKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GLNO
     C     GLKEY         CHAIN     FMGLCH                             10
     C   10              SETON                                        99
     C   10              MOVE      *BLANKS       DESC
     C  N10              MOVEL     GCDESC        DESC
     C  N10              DO
     C     DEBIT         IFLE      0
     C     CREDIT        ANDLE     0
     C                   SETON                                        303199
     C                   ENDIF
     C     DEBIT         IFGT      0
     C     CREDIT        ANDGT     0
     C                   SETON                                        303299
     C                   ENDIF
     C                   ADD       DEBIT         BAL
     C                   SUB       CREDIT        BAL
     C                   ENDDO
     C                   UPDATE    RECSFL
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C     BAL           IFNE      0
     C                   SETON                                        4099
     C                   ENDIF
     C                   ENDSR
      ***********
      * PUTSFL
      ***********
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   ENDIF
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTPUT
      *
     C     GLNO          IFEQ      0
     C                   GOTO      NXTPUT
     C                   ENDIF
      *
     C                   ADD       1             CNT
     C     CNT           IFEQ      1
     C                   EXCEPT    HDG
     C                   ENDIF
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    DETAIL
      *
     C                   MOVEL     'A'           ADSTAT
     C                   Z-ADD     APCOMP        ADCOMP
     C                   Z-ADD     APVOUC        ADVOUC
     C                   Z-ADD     APVEND        ADVEND
     C                   MOVEL     APINV#        ADINV#
     C                   Z-ADD     APSEQ#        ADSEQ#
     C                   MOVEL     APITYP        ADITYP
     C                   MOVEL     APVTYP        ADVTYP
     C                   MOVEL     APPONO        ADPONO
     C                   Z-ADD     APIVDT        ADIVDT
     C                   Z-ADD     APDUDT        ADDUDT
     C                   Z-ADD     APDCDT        ADDCDT
     C                   MOVEL     APVTCD        ADVTCD
     C                   Z-ADD     APDUE$        AD$AMT
     C                   Z-ADD     0             ADDAVL
     C                   Z-ADD     0             ADTRAT
     C                   Z-ADD     APGLAC        ADGLAC
     C                   Z-ADD     APTDAT        ADTDAT
     C                   Z-ADD     0             ADTRAT
     C                   MOVEL     APTTYP        ADTTYP
     C                   MOVEL     *BLANKS       ADMCIP
     C                   Z-ADD     APCHEK        ADCHEK
     C                   Z-ADD     APCKDT        ADCKDT
     C                   Z-ADD     APBTCH        ADBTCH
     C                   MOVEL     ' '           ADGLUD
     C                   Z-ADD     GLNO          ADGLA1
     C     CREDIT        IFNE      0
     C                   Z-SUB     CREDIT        ADGL$1
     C                   ELSE
     C                   Z-ADD     DEBIT         ADGL$1
     C                   ENDIF
     C                   Z-ADD     TDATE         ADDTLA
     C                   Z-ADD     TIMOD         ADTIME
     C                   MOVEL     USERID        ADUSER
     C                   Z-ADD     EDATE         ADAPER
     C                   MOVEL     'Deleted '    D1               16
     C                   MOVE      'Open Pay'    D1
     C                   MOVEL     'able'        D2                4
     C                   MOVEL     D1            D3               20
     C                   MOVE      D2            D3
     C                   MOVEL     D3            ADTDES
     C                   Z-ADD     VACTP         ADPERD
     C                   MOVEL     ' '           ADPAID
     C                   Z-ADD     VACTP         ADPDPR
      *
     C                   EXCEPT    GLDETL
     C                   WRITE     RAPDET
     C                   GOTO      NXTPUT
      *
     C     ENDPUT        TAG
      *
      * RECORD FOR A/P ACCOUNT NUMBER
      *
     C                   MOVEL     '01'          TYPE              2
     C                   Z-ADD     APGLAC        ADGLA1
     C                   MOVEL     'A'           ADSTAT
     C                   Z-ADD     APCOMP        ADCOMP
     C                   Z-ADD     APVOUC        ADVOUC
     C                   Z-ADD     APVEND        ADVEND
     C                   MOVEL     APINV#        ADINV#
     C                   Z-ADD     APSEQ#        ADSEQ#
     C                   MOVEL     APITYP        ADITYP
     C                   MOVEL     APVTYP        ADVTYP
     C                   MOVEL     APPONO        ADPONO
     C                   Z-ADD     APIVDT        ADIVDT
     C                   Z-ADD     APDUDT        ADDUDT
     C                   Z-ADD     APDCDT        ADDCDT
     C                   MOVEL     APVTCD        ADVTCD
     C                   Z-ADD     APDUE$        AD$AMT
     C                   Z-ADD     0             ADDAVL
     C                   Z-ADD     0             ADTRAT
     C                   Z-ADD     APGLAC        ADGLAC
     C                   Z-ADD     APTDAT        ADTDAT
     C                   Z-ADD     0             ADTRAT
     C                   MOVEL     APTTYP        ADTTYP
     C                   MOVEL     *BLANKS       ADMCIP
     C                   Z-ADD     APCHEK        ADCHEK
     C                   Z-ADD     APCKDT        ADCKDT
     C                   Z-ADD     APBTCH        ADBTCH
     C                   MOVEL     ' '           ADGLUD
     C                   Z-ADD     APDUE$        ADGL$1
     C                   Z-ADD     TDATE         ADDTLA
     C                   Z-ADD     TIMOD         ADTIME
     C                   MOVEL     USERID        ADUSER
     C                   Z-ADD     EDATE         ADAPER
     C                   MOVEL     'Deleted '    D1               16
     C                   MOVE      'Open Pay'    D1
     C                   MOVEL     'able'        D2                4
     C                   MOVEL     D1            D3               20
     C                   MOVE      D2            D3
     C                   MOVEL     D3            ADTDES
     C                   Z-ADD     VACTP         ADPERD
     C                   MOVEL     ' '           ADPAID
     C                   Z-ADD     VACTP         ADPDPR
     C                   WRITE     RAPDET
      *
     C     APKEY         CHAIN     FAPOPN                             92
     C                   MOVEL     'D'           APSTAT
     C                   MOVEL     'Y'           APCLCD
     C                   UPDATE    RAPOPN
     C                   EXCEPT    GLDETT
      *
     C                   SUB       APDUE$        VMYPUR
     C                   SUB       APDAVL        VMYDAV
     C                   UPDATE    RMVEND
     C                   ENDSR
      ********
      * LOOK *
      ********
     C     LOOK          BEGSR
     C                   MOVEL     *BLANKS       GCLOOK
     C                   Z-ADD     0             GLNO
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    LCO
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   Z-ADD     GCGLNO        GLNO
     C                   MOVEL     GCDESC        DESC
     C                   ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FAPCTL                             90
     C     AZGL          IFEQ      'N'
     C                   SETON                                        88
     C                   ENDIF
      *
     C                   Z-ADD     0             CNT               4 0
     C                   Z-ADD     LCO           VCO               2 0
     C                   ENDSR
      *
     OAPR270    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              77
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           64 'Deleted Accounts'
     O                                           80 'Payable Listing'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           45 'Voucher'
     O                                           56 'Invoice'
     O                                           65 'Invoice'
     O                                          101 '**** G/L'
     O                                          119 'Distribution ****'
     O          E            HDG            1
     O                                            6 'Vendor'
     O                                           20 'Name'
     O                                           45 'Number'
     O                                           56 'Number'
     O                                           64 'Date'
     O                                           79 'Amount'
     O                                          100 'Account #'
     O                                          120 'Amount'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETAIL      1  0
     O                       APVEND        Z      6
     O                       VMNAME              37
     O                       APVOUC        Z     45
     O                       APINV#              56
     O                       APIVDT        Y     65
     O                       APITYP              68
     O                       APDUE$        L     80
     O          EF           GLDETL         1
     O                       GLNO               100 '    -    '
     O                       ADGL$1        L    120
     O          EF           GLDETT         1
     O                                           31 '*** Deleted From Account'
     O                                           44 'ing Period - '
     O                       VACTP         Z     46
     O*                        GDAPPY   100 '    -    '
     O                       APGLAC             100 '    -    '
     O                       APDUE$        L    120
