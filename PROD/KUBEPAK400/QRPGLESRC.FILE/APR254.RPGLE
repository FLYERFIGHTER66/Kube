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
      *****************************************************************
      *PROGRAM NAME--------- APR254
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *APPLICATION---------- VOID A PROCESSED CHECK
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 7/15/00 EFD01 CORRECT VOIDING ALL APDTP RECORDS
      *
      *
     FAPR254FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     F                                     SFILE(VOIDSFL:RECNO)
     FFAPREC    UF   E           K DISK
     FFAPCTL    IF   E           K DISK
     FFMVEND    UF   E           K DISK
     FFAPDTPCK  UF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFAPMTH    O  A E             DISK
     FFAPDET    O  A E             DISK
      *
      * MAPER ARRAYS
     D BEG             S              6  0 DIM(13)                              BEG DATES
     D DNE             S              6  0 DIM(13)                              END DATES
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FMAPER                             90
     C                   Z-ADD     BEG(1)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         YRBEG             5 0
     C     ACMPCN        IFEQ      'M'
     C                   Z-ADD     DNE(12)       ##MDY
     C                   ELSE
     C                   Z-ADD     DNE(13)       ##MDY
     C                   ENDIF
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         YREND             5 0
      *
     C     LCO           CHAIN     FAPCTL                             90
      *
      * VENDOR PAYMENT HISTORY
      *
     C     AZPAYH        IFEQ      'Y'
     C                   SETON                                        50
     C                   ENDIF
      *
      * DOES COMPANY RUN GENERAL LEDGER
      *
     C     AZGL          IFEQ      'N'
     C                   SETON                                        85
     C                   ENDIF
      *
     C     RSTRT         TAG
     C                   Z-ADD     1             FIRST             2 0
     C                   Z-ADD     0             VCHECK
     C                   Z-ADD     0             VACTP
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102021
     C                   SETOFF                                       222330
     C                   SETOFF                                       406077
     C                   Z-ADD     0             CNT               2 0
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO
      *
     C   KB              DO
     C                   Z-ADD     LCO           ACCOMP            2 0
     C                   CALL      'LKACTP'
     C                   PARM                    ACCOMP
     C                   PARM                    VACTP
     C                   GOTO      NXTA
     C                   ENDDO
      *
     C     VCHECK        IFEQ      *ZEROS
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     KEY8          KLIST
     C                   KFLD                    LCO
     C                   KFLD                    VCHECK
     C     KEY8          CHAIN     FAPREC                             92
     C   92              SETON                                        2022
     C   20
     CAN 22              GOTO      NXTA
      *
      * CHECK ALREADY RECONCILED - CAN'T VOID
      *
     C     AK$NET        IFEQ      0
     C                   SETON                                        2024
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     AKCTYP        IFEQ      '5'
     C                   SETON                                        2024
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     AKCKRC        IFEQ      'Y'
     C                   SETON                                        2023
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-SUB     AK$NET        CKTOT            11 2
      *
     C     VACTP         IFLE      *ZEROS                                                   K
     C     VACTP         ORGT      13                                                       K
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     LCO           CONO
     C                   Z-ADD     VACTP         ACTPER
     C                   CALL      'GETPDAT'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     BEGDAT        BDATE             6 0
     C                   Z-ADD     ENDDAT        EDATE             6 0
      *
     C                   Z-ADD     BDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ABDATE            5 0
     C                   Z-ADD     EDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         AEDATE            5 0
      *
     C                   Z-ADD     AKCKDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         CKDATE            5 0
      *
      * 85 = DOES NOT RUN G/L
      *
     C   85              GOTO      NOCK
      *
     C     CKDATE        IFLT      YRBEG
     C                   GOTO      NOCK
     C                   ENDIF
      *
     C     FIRST         IFEQ      1
     C     CKDATE        ANDLT     ABDATE
     C     CKDATE        ORGT      AEDATE
     C                   SETON                                        60
     C                   ADD       1             FIRST
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     NOCK          TAG
      *
NEW  C     AKDTAK        IFNE      0
NEW  C                   SETON                                        77
NEW  C*          GLDFK     CHAINFGLDF                10
NEW  C* N10                Z-ADDGDAPCH    ADGLA1
NEW  C                   ENDIF
      *
     C     AKVEND        CHAIN(N)  FMVEND                             90
     C                   MOVEL     VMNAME        VNAME            16
      *
      *
     C                   EXSR      BLDSFL
     C     NXTSFL        TAG
     C                   EXFMT     VOIDCTL
     C   KF              GOTO      RSTRT
     C   KB              DO
     C     LINE          CHAIN     VOIDSFL                            90
     C                   EXSR      LOOK
     C                   UPDATE    VOIDSFL
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
      **********
      * BLDSFL *
      **********
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     VOIDCTL
     C                   SETOFF                                       80
     C                   SETOFF                                       1030
     C                   Z-ADD     AK$NET        BAL              11 2
     C                   Z-ADD     0             GLNO
     C                   Z-ADD     0             DEBIT
     C                   Z-ADD     0             CREDIT
     C                   Z-ADD     0             RECNO                          NEW
     C                   MOVE      *BLANKS       DESC
     C     NXTBLD        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      50
     C                   GOTO      ENDBLD
     C                   ENDIF
     C                   WRITE     VOIDSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ENDSR
      *
      **********
      * CHKSFL *
      **********
      *
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     AK$NET        BAL
     C                   SETOFF                                       103040
     C                   SETOFF                                       99
     C     NXTCHK        TAG
     C                   SETOFF                                       103031
     C                   SETOFF                                       32
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   ENDIF
     C     RECNO         CHAIN     VOIDSFL                            90
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
     C                   UPDATE    VOIDSFL
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C     BAL           IFNE      0
     C                   SETON                                        4099
     C                   ENDIF
     C                   ENDSR
      *
      **********
      * PUTSFL *
      **********
      *
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPT
     C                   ENDIF
     C     RECNO         CHAIN     VOIDSFL                            90
     C   90              GOTO      NXTPUT
      *
     C     GLNO          IFEQ      0
     C                   GOTO      NXTPUT
     C                   ENDIF
     C                   MOVEL     '01'          TYPE              2
     C     GLDFK         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    TYPE
     C     RECNO         IFEQ      1
     C     GLDFK         CHAIN     FGLDF                              10
     C  N10              Z-ADD     GDAPCH        ADGLA1
     C                   MOVEL     'A'           ADSTAT
     C                   Z-ADD     AKCOMP        ADCOMP
     C                   Z-ADD     AKCHEK        ADVOUC
     C                   Z-ADD     AKVEND        ADVEND
     C                   MOVEL     'Void Che'    I1               10
     C                   MOVE      'ck'          I1
     C                   MOVEL     I1            ADINV#
     C                   Z-ADD     0             ADSEQ#
     C                   MOVEL     *BLANKS       ADITYP
     C                   MOVEL     *BLANKS       ADVTYP
     C                   MOVEL     *BLANKS       ADPONO
     C                   Z-ADD     AKTDAT        ADIVDT
     C                   Z-ADD     AKTDAT        ADDUDT
     C                   Z-ADD     AKTDAT        ADDCDT
     C                   MOVEL     *BLANKS       ADVTCD
     C*                    Z-ADDAK$AMT    AD$AMT           OLD
     C                   Z-ADD     AK$NET        AD$AMT                         NEW
     C                   Z-ADD     0             ADDAVL
     C                   Z-ADD     0             ADTRAT
     C*?                   Z-ADDGCAPPY    ADGLAC
     C                   Z-ADD     AKTDAT        ADTDAT
     C                   Z-ADD     0             ADTRAT
     C                   MOVEL     *BLANKS       ADTTYP
     C                   MOVEL     *BLANKS       ADMCIP
     C                   Z-ADD     AKCHEK        ADCHEK
     C                   Z-ADD     AKCKDT        ADCKDT
     C                   Z-ADD     0             ADBTCH
     C                   MOVEL     ' '           ADGLUD
     C*                    Z-ADDAK$AMT    ADGL$1           OLD
     C                   Z-ADD     AK$NET        ADGL$1                         NEW
     C                   Z-ADD     TDATE         ADDTLA
     C                   Z-ADD     TIMOD         ADTIME
     C                   MOVEL     USERID        ADUSER
     C                   Z-ADD     EDATE         ADAPER
     C                   MOVEL     'A/P Void'    D1               16
     C                   MOVE      ' Existin'    D1
     C                   MOVEL     'g Check'     D2                7
     C                   MOVEL     D1            D3               23
     C                   MOVE      D2            D3
     C                   MOVEL     D3            ADTDES
     C                   MOVE      AKCHEK        ADTDES
     C                   Z-ADD     VACTP         ADPERD
     C                   MOVEL     ' '           ADPAID
     C                   Z-ADD     VACTP         ADPDPR
     C                   WRITE     RAPDET
     C                   ENDIF
      *
     C                   MOVEL     'A'           ADSTAT
     C                   Z-ADD     AKCOMP        ADCOMP
     C                   Z-ADD     AKCHEK        ADVOUC
     C                   Z-ADD     AKVEND        ADVEND
     C                   MOVEL     'Void Che'    I1               10
     C                   MOVE      'ck'          I1
     C                   MOVEL     I1            ADINV#
     C                   Z-ADD     0             ADSEQ#
     C                   MOVEL     *BLANKS       ADITYP
     C                   MOVEL     *BLANKS       ADVTYP
     C                   MOVEL     *BLANKS       ADPONO
     C                   Z-ADD     AKTDAT        ADIVDT
     C                   Z-ADD     AKTDAT        ADDUDT
     C                   Z-ADD     AKTDAT        ADDCDT
     C                   MOVEL     *BLANKS       ADVTCD
     C                   Z-ADD     AK$NET        AD$AMT
     C                   Z-ADD     0             ADDAVL
     C                   Z-ADD     0             ADTRAT
     C                   Z-ADD     0             ADGLAC
     C                   Z-ADD     AKTDAT        ADTDAT
     C                   Z-ADD     0             ADTRAT
     C                   MOVEL     *BLANKS       ADTTYP
     C                   MOVEL     *BLANKS       ADMCIP
     C                   Z-ADD     AKCHEK        ADCHEK
     C                   Z-ADD     AKCKDT        ADCKDT
     C                   Z-ADD     0             ADBTCH
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
     C                   MOVEL     'A/P Void'    D1               16
     C                   MOVE      ' Existin'    D1
     C                   MOVEL     'g Check'     D2                7
     C                   MOVEL     D1            D3               23
     C                   MOVE      D2            D3
     C                   MOVEL     D3            ADTDES
     C                   MOVE      AKCHEK        ADTDES
     C                   Z-ADD     VACTP         ADPERD
     C                   MOVEL     ' '           ADPAID
     C                   Z-ADD     VACTP         ADPDPR
      *
     C                   WRITE     RAPDET
     C                   GOTO      NXTPUT
      *
     C     ENDPT         TAG
      *
     C                   EXSR      UAPREC
     C                   EXSR      UAPMTH
      *
      * UPDATE MVEND WITH VOIDED CHECK DATA
      *
     C     AKVEND        CHAIN     FMVEND                             90
     C                   SUB       AK$AMT        VMYPUR
     C                   SUB       AK$NET        VMPAID
     C                   SUB       AKDTAK        VMYDIT
     C                   UPDATE    RMVEND
      *
      * UPDATE APDTP WITH VOIDED CHECK DATA
      *
EFD01C* N50                GOTO ENDPUT
     C     KEYPH         KLIST
EFD01C                   KFLD                    LCO
     C                   KFLD                    AKVEND
     C                   KFLD                    AKCHEK
     C*          KEYPH     CHAINFAPDTPCK             90
EFD01C     KEYPH         SETLL     FAPDTPCK
EFD01C     NXTPH         TAG
EFD01C     KEYPH         READE     FAPDTPCK                               90
     C   90              GOTO      ENDPUT
     C                   MOVEL     *BLANKS       ATDESC
     C                   MOVEL     '* Check '    DESC1            16
     C                   MOVE      'Voided *'    DESC1
     C                   MOVEL     DESC1         ATDESC
     C                   Z-ADD     0             ATPAID
     C                   UPDATE    RAPDTP
EFD01C                   GOTO      NXTPH
      *
     C     ENDPUT        ENDSR
      *
      ********
      * LOOK *
      ********
     C     LOOK          BEGSR
     C                   MOVEL     *BLANKS       GCLOOK
     C                   Z-ADD     0             GLNO
     C                   Z-ADD     LCO           VCO               2 0
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    VCO
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   Z-ADD     GCGLNO        GLNO
     C                   MOVEL     GCDESC        DESC
     C                   ENDSR
      *
      *******************************
      * UAPREC  UPDATE APREC FILE   *
      *******************************
     C     UAPREC        BEGSR
     C                   MOVEL     *BLANKS       AKTDES
     C                   MOVEL     '* Check '    DESCA            16
     C                   MOVE      'Voided *'    DESCA
     C                   MOVEL     DESCA         AKTDES
     C                   Z-ADD     *ZEROS        AKPEDT
     C                   Z-ADD     *ZEROS        AKPSDT
     C                   MOVEL     'Y'           AKGLUD
     C                   MOVEL     'Y'           AKVUPD
     C                   Z-ADD     TDATE         AKDTLA
     C                   Z-ADD     TIMOD         AKTIME
     C                   MOVEL     USERID        AKUSER
     C                   MOVEL     'Y'           AKCKRC
     C                   Z-ADD     *ZEROS        AKDTRC
     C                   MOVEL     '5'           AKCTYP
     C                   UPDATE    RAPREC
     C                   ENDSR
      *
      **********
      * UAPMTH *
      **********
     C     UAPMTH        BEGSR
     C                   MOVEL     'A'           AMSTAT
     C                   Z-ADD     LCO           AMCOMP
     C                   Z-ADD     VCHECK        AMCHEK
     C                   Z-ADD     AKCKDT        AMCKDT                         EFD 11/18
     C                   Z-ADD     AKVEND        AMVEND
     C                   Z-SUB     AK$AMT        AM$AMT
     C                   Z-SUB     AKDTAK        AMDTAK
     C                   Z-SUB     AK$NET        AM$NET                         EFD
     C                   Z-ADD     TDATE         AMTDAT
     C                   MOVEL     *BLANKS       AMTDES
     C                   MOVEL     '* Check '    DESCB            16
     C                   MOVE      'Voided *'    DESCB
     C                   MOVEL     DESCB         AMTDES                         EFD 11/18
     C                   Z-ADD     EDATE         AMPEDT
     C                   Z-ADD     *ZEROS        AMPSDT
     C                   MOVEL     'Y'           AMGLUD
     C                   MOVEL     ' '           AMVUPD
     C                   Z-ADD     TDATE         AMDTLA
     C                   Z-ADD     TIMOD         AMTIME
     C                   MOVEL     USERID        AMUSER
     C                   MOVEL     '5'           AMCTYP                         EFD
     C                   WRITE     RAPMTH
     C                   ENDSR
      *
