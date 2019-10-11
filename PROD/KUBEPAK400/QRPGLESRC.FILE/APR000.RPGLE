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
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- APR000
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- A/P CONTROL FILE MAINTENANCE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FAPR000FM  CF   E             WORKSTN
     FFMCORG    IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FFAPCTL    UF A E           K DISK
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      *  PROGRAM NAME
     D  PROGID                 1     10
      *  RUN LIBRARY
     D  RLIBR                 81     90
      *  USER I.D.
     D  USERID               254    261
      *  SOURCE LIBRARY
     D  SLIBR                314    323
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   MOVEL     *BLANKS       VCO
     C                   EXSR      CLRIT
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102021
     C                   SETOFF                                       222324
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C   10              GOTO      RSTRTA
     C     VACTOK        TAG
      *
     C     VCO           IFGT      0
     C     VCO           CHAIN     FMCORG                             90
     C   90              SETON                                        2021
     C   20              GOTO      RSTRTA
     C                   MOVEL     RGNAME        CNAME            30
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C     VCO           ANDGT     0
     C                   Z-ADD     0             CO                2 0
     C     CO            SETLL     FAPCTL
     C     CO            READE     FAPCTL                                 94                K
     C   94              SETON                                        2024
     C   24              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C     VCO           CHAIN     FAPCTL                             92                    K
     C  N92              SETON                                        2022
     C   22              GOTO      RSTRTA
     C                   EXSR      CLRIT
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C     VCO           CHAIN     FAPCTL                             92                    K
     C   92              SETON                                        2023
     C   23              GOTO      RSTRTA
     C     AZTMCD        CHAIN     FMTERM                             93
     C                   MOVEL     TCDESC        DESC
     C                   ENDIF
      *
     C     VCO           IFGT      0
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
      * COMPANY 00
      *
     C     RSTRTB        TAG
     C                   Z-ADD     0             CNT               2 0
     C                   WRITE     SCRNB
     C                   SETOFF                                       101520
     C                   SETOFF                                       3040
     C                   READ      SCRNB                                  90
      *
     C   KF              GOTO      RSTRTA
     C   KC
     COR KG              GOTO      END
      *
     C     AZPRCO        IFEQ      0
     C                   SETON                                        10
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     AZPRCO        CHAIN     FMCORG                             90
     C   90              SETON                                        10
     C   10              GOTO      RSTRTB
      *
     C     AZPRCO        IFNE      OPRCO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     AZPRCO        OPRCO             2 0
      *
     C     AZNMCO        IFEQ      0
     C                   SETON                                        15
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     AZVEND        IFEQ      *ZEROS
     C                   SETON                                        20
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     AZVEND        IFNE      OVEND
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     AZVEND        OVEND             6 0
      *
     C     AZMIS$        IFEQ      *ZEROS
     C                   SETON                                        30
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     AZMIS$        IFNE      OMIS$
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     AZMIS$        OMIS$             7 2
      *
     C     AZINT$        IFEQ      *ZEROS
     C                   SETON                                        40
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     AZINT$        IFNE      OINT$
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     AZINT$        OINT$             7 2
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C   98              GOTO      RSTRTB
     C                   ENDIF
      *
     C                   EXSR      CREC
     C                   SETOFF                                       98
     C                   GOTO      RSTRTA
      *
     C     RSTRTC        TAG
     C     AZLSCK        IFGT      0
     C                   Z-ADD     AZLSCK        LSCK
     C                   ELSE
     C     AZCHEK        SUB       1             LSCK
     C                   END
     C                   WRITE     SCRNC
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       353840
     C                   SETOFF                                       414243
     C                   SETOFF                                       445055
     C                   SETOFF                                       565758
     C                   SETOFF                                       606236
     C                   SETOFF                                       376667
      *
     C                   READ      SCRNC                                  90
      *
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRTA
      *
     C                   MOVEL     AZTMCD        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     AZTMCD        TCTERM            2
     C                   CALL      'LKTERM'
     C                   PARM                    TCTERM
     C                   PARM                    TCDESC           30
     C                   MOVEL     *BLANKS       AZTMCD
     C                   MOVEL     TCTERM        AZTMCD
     C                   MOVEL     TCDESC        DESC             30
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZGL          IFNE      'Y'
     C     AZGL          ANDNE     'N'
     C                   SETON                                        10
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZGL          IFNE      OGL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     AZGL          OGL               1
      *
     C     AZPRTR        IFEQ      *BLANKS
     C                   SETON                                        35
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZPRTR        IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     AZPRTR        OPRTR            10
      *
     C     AZPAYH        IFNE      'Y'
     C     AZPAYH        ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZPAYH        IFNE      OPAYH
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     AZPAYH        OPAYH             1
      *
     C     AZREC         IFNE      'Y'
     C     AZREC         ANDNE     'N'
     C                   SETON                                        20
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZREC         IFNE      OREC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     AZREC         OREC              1
      *
     C     AZVOUC        IFEQ      *ZEROS
     C                   SETON                                        37
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZVOUC        IFNE      OVOUC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     AZVOUC        OVOUC             6 0
      *
     C     AZAGPY        IFEQ      *ZEROS
     C                   SETON                                        4041
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZAGPY        IFNE      OAGPY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     AZAGPY        OAGPY             3 0
      *
     C     AZAGP2        IFLT      AZAGPY
     C                   SETON                                        42
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZAGP2        IFNE      OAGP2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     AZAGP2        OAGP2             3 0
      *
     C     AZAGP3        IFLT      AZAGP2
     C                   SETON                                        43
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZAGP3        IFNE      OAGP3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     AZAGP3        OAGP3             3 0
      *
     C     AZAGP4        IFLT      AZAGP3
     C                   SETON                                        44
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZAGP4        IFNE      OAGP4
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     AZAGP4        OAGP4             3 0
      *
     C     AZAPGL        IFNE      'Y'
     C     AZAPGL        ANDNE     'N'
     C                   SETON                                        5657
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZGL          IFEQ      'N'
     C     AZAPGL        ANDEQ     'Y'
     C                   SETON                                        5658
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZPSEL        IFNE      'Y'
     C     AZPSEL        ANDNE     'N'
     C                   SETON                                        55
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZPSEL        IFNE      OPSEL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     AZPSEL        OPSEL             1
      *
     C     AZCHEK        IFEQ      *ZEROS
     C                   SETON                                        60
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZCHEK        IFNE      OCHEK
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     AZCHEK        OCHEK             6 0
      *
     C     AZSTBL        IFEQ      *ZEROS
     C                   SETON                                        62
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZSTBL        IFNE      OSTBL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     AZSTBL        OSTBL             3 0
      *
     C     AZPRTC        IFEQ      *BLANKS
     C                   SETON                                        38
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZPRTC        IFNE      OPRTC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     AZPRTC        OPRTC            10
      *
     C     AZUSET        IFNE      'Y'
     C     AZUSET        ANDNE     'N'
     C                   SETON                                        66
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZUSET        IFEQ      'Y'
     C     AZUSEP        ANDLE     0.00
     C                   SETON                                        67
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     AZTMCD        CHAIN     FMTERM                             50
     C   50              GOTO      RSTRTC
      *
     C     AZTMCD        IFNE      OTMCD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     AZTMCD        OTMCD             2
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C   98              GOTO      RSTRTC
     C                   ENDIF
      *
     C                   EXSR      CREC
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     C     CREC          BEGSR
     C                   Z-ADD     VCO           AZCOMP
     C                   Z-ADD     TDATE         AZDTLA
     C                   Z-ADD     TIMOD         AZTIME
     C                   MOVEL     USERID        AZUSER
     C     VACT          IFEQ      'A'
     C                   WRITE     RAPCTL
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RAPCTL
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RAPCTL
     C                   ENDIF
     C                   ENDSR
      *********
      * CLRIT *
      *********
     C     CLRIT         BEGSR
     C                   Z-ADD     0             AZCOMP
     C                   Z-ADD     0             AZPRCO
     C                   MOVEL     *BLANKS       AZGL
     C                   MOVEL     *BLANKS       AZREC
     C                   MOVEL     *BLANKS       AZPAYH
     C                   Z-ADD     0             AZAGPY
     C                   Z-ADD     0             AZAGP2
     C                   Z-ADD     0             AZAGP3
     C                   Z-ADD     0             AZAGP4
     C                   MOVEL     *BLANKS       AZTMCD
     C                   Z-ADD     0             AZCRL$
     C                   MOVEL     'N'           AZUSET
     C                   Z-ADD     0             AZUSEP
     C                   MOVEL     *BLANKS       AZPSEL
     C                   Z-ADD     0             AZVEND
     C                   Z-ADD     0             AZVOUC
     C                   Z-ADD     0             AZCHEK
     C                   Z-ADD     0             AZVOID
     C                   MOVEL     *BLANKS       AZPRTR
     C                   MOVEL     *BLANKS       AZPRTC
     C                   MOVEL     *BLANKS       AZPRTL
     C                   Z-ADD     0             AZDTCK
     C                   Z-ADD     0             AZDTCP
     C                   Z-ADD     0             AZDTMC
     C                   Z-ADD     0             AZDTGL
     C                   Z-ADD     0             AZDTYC
     C                   Z-ADD     0             AZDT10
     C                   Z-ADD     0             AZLSCK
     C                   MOVEL     *BLANKS       AZOKP
     C                   MOVEL     *BLANKS       AZOKC
     C                   MOVEL     *BLANKS       AZPAYS
     C                   MOVEL     *BLANKS       AZOKSU
     C                   Z-ADD     0             AZMIS$
     C                   Z-ADD     0             AZINT$
     C                   ENDSR
