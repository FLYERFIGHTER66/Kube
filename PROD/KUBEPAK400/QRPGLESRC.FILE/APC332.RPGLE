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
      *PROGRAM NAME--------- APC330
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *APPLICATION---------- CHECK PRINT PROMPT SCREEN
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAPCTL    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFAPCHK    IF   E           K DISK
     FAPC332FM  CF   E             WORKSTN
      *
      * MAPER ARRAYS
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
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
     D                UDS
     D  LCO                    1      2  0
     D  LPROG                 29     36
     D  LNAME                 37     60
     D  LDATE                 61     66  0
     D  VCHECK                67     72  0
     D  LVOID                 73     74  0
     D  LRERUN                76     76
     D  LPRTR1                81     90
     D  LPRTR2               100    109
     D  LCOPY                114    115  0
     D  LJOB                 116    116
     D  LHOLD                117    120
     D  LSAVE                121    124
     D  LCANCL               133    133
     D  JAMRCV               150    150
      ** FIRST CHECK IN CURRENT RUN
     D  FSTCHK               151    156  0
      ** LAST CHECK IN CURRENT RUN
     D  LSTCHK               157    162  0
     D  LFORM1               163    172
     D  LFORM2               173    182
      ** LAST GOOD CHECK PRINTED
     D  LSTGDC               183    188  0
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
      *************************
      * CHECK LAST RUN STATUS *
      *************************
     C     AZCKR         IFNE      'Y'
     C                   WRITE     SCRNERR
     C                   READ      SCRNERR                                90
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDIF
      *
      *
      *
      ********************
      * START HERE       *
      ********************
      *
     C     NXTA          TAG
     C                   Z-ADD     0             CNT               2 0
      *
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C                   SETOFF                                       101112
     C                   SETOFF                                       202122
      ** CHECK CHECK NUMBERS
     C     LSTGDC        IFGT      LSTCHK
     C     LSTGDC        ORLT      FSTCHK
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   END
      *
     C     VCHECK        IFEQ      *ZEROS                                                   OS
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCHECK        IFLT      LSTGDC                                                   OS
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   ADD       1             FIRST
     C     VCHECK        SUB       LSTCHK        CKDIFF            6 0
     C     CKDIFF        IFGT      10
     C     FIRST         ANDEQ     1
     C                   SETON                                        96
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     0             LVOID
      *
     C     NXTB          TAG
     C                   Z-ADD     0             CNT               2 0
      *
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       202122
     C                   SETOFF                                       304050
     C                   SETOFF                                       5215
     C                   SETOFF                                       606296
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1011
     C                   GOTO      NXTB
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         SCDATE            5 0
      *
     C     AZGL          IFEQ      'Y'
     C     SCDATE        ANDLT     YRBEG
     C                   SETON                                        1015
     C                   GOTO      NXTB
     C                   ENDIF
      *
      *
      *
     C     LFORM1        IFEQ      *BLANKS                                                  K
     C                   SETON                                        30
     C   30              GOTO      NXTB
     C                   ENDIF
      *
     C     LPRTR1        IFEQ      *BLANKS                                                  K
     C                   SETON                                        52
     C   52              GOTO      NXTB
     C                   ENDIF
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        53
     C   53              GOTO      NXTB
     C                   ENDIF
      *
     C     VOUT          IFEQ      1
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*NO '        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      2
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      3
     C                   MOVEL     '*YES'        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     0             FSTCHK
     C                   Z-ADD     0             LSTCHK
     C                   Z-ADD     0             LSTGDC
     C                   MOVEL     'Y'           JAMRCV
     C     APCKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    ACCHEK
     C                   Z-ADD     0             ACCHEK
     C     APCKEY        SETLL     FAPCHK
     C     NXTINZ        TAG
     C     LCO           READE     FAPCHK                                 90
     C   90              GOTO      ENDINZ
     C     FSTCHK        IFLE      0
     C                   Z-ADD     ACCHEK        FSTCHK
     C                   END
     C                   GOTO      NXTINZ
     C     ENDINZ        TAG
     C                   Z-ADD     ACCHEK        LSTCHK
     C     LCO           CHAIN     FAPCTL                             90
      *
     C                   Z-ADD     0             VCHECK
     C                   MOVEL     AZPRTC        LPRTR1
     C                   MOVEL     AZPRTR        LPRTR2
      *
     C                   MOVEL     'APCHECK#'    LFORM1
     C                   MOVE      LCO           LFORM1
     C                   MOVEL     '*NAR'        LFORM2
     C                   Z-ADD     TDATE         LDATE
     C                   MOVEL     'N'           LRERUN
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     0             FIRST             2 0
      *
      *
      * GET EARLIEST AND LAST ACCTG PERIOD DATE
      *
     C     AZGL          IFEQ      'Y'
     C                   DO
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
      *
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
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      *
