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
      *PROGRAM NAME-------- SAC380
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- SALES ANALYSIS BY CUSTOMER/PRODUCT CLASS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMCUST    IF   E           K DISK
     FFMCTYP    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FSAR380FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
     D                UDS
     D  LCO                    1      2  0
     D  LSDTE                  3      6  0
     D  LEDTE                  7     10  0
     D  LSTYPE                11     12
     D  LETYPE                13     14
     D  LSPC                  15     16
     D  LEPC                  17     18
     D  LPROG                 29     36
     D  LNAME                 37     66
     D*                                      50  550LCUST
     D  LPRTR                100    109
     D  LFORM                110    113
     D  LCOPY                114    115  0
     D  LJOB                 116    116
     D  LHOLD                117    120
     D  LSAVE                121    124
     D  LCANCL               133    133
      *
     C                   SETOFF                                       98
     C                   Z-ADD     01            VCO
     C                   MOVEL     '*NAR'        VFORMS
     C                   Z-ADD     01            VCOPY
     C                   MOVEL     'N'           VJOB
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       606170
     C                   SETOFF                                       622172
     C                   SETOFF                                       202122
     C                   SETOFF                                       203040
     C                   SETOFF                                       909825
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C                   MOVEL     *BLANKS       LCANCL
      *
     C                   Z-ADD     VSDTE         LSDTE
     C                   Z-ADD     VEDTE         LEDTE
     C                   Z-ADD     VCO           LCO
     C                   MOVEL     VFORMS        LFORM
     C                   Z-ADD     VCOPY         LCOPY
     C                   MOVE      VJOB          LJOB
     C                   MOVEL     VSTYPE        LSTYPE
     C                   MOVEL     VETYPE        LETYPE
     C                   Z-ADD     VCUST         LCUST
     C                   MOVEL     VSPC          LSPC
     C                   MOVEL     VEPC          LEPC
      *
     C     VSDTE         IFEQ      *ZEROS
     C                   SETON                                        1011
     C   11              GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     VSDTE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         BDATE             5 0
      *
     C     VEDTE         IFEQ      *ZEROS
     C                   SETON                                        21
     C   21              GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     VEDTE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        21
     C                   GOTO      NXTA
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EDATE             5 0
      *
     C     BDATE         IFGT      EDATE
     C                   SETON                                        2510
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VSTYPE        IFEQ      *BLANKS
     C                   GOTO      NOTYPE
     C                   ENDIF
      *
     C     VSTYPE        IFEQ      '?'
     C                   MOVEL     VSTYPE        CTTYPE            2
     C                   CALL      'LKTYPE'
     C                   PARM                    CTTYPE
     C                   PARM                    CTDESC           30
     C                   MOVEL     *BLANKS       VSTYPE
     C                   MOVEL     CTTYPE        VSTYPE
     C                   MOVEL     CTDESC        VDESC            30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VSTYPE        CHAIN     FMCTYP                             90
     C   90              SETON                                        65
     C   65              GOTO      NXTA
      *
     C     VETYPE        IFEQ      '?'
     C                   MOVEL     VETYPE        CTTYPE            2
     C                   CALL      'LKTYPE'
     C                   PARM                    CTTYPE
     C                   PARM                    CTDESC           30
     C                   MOVEL     *BLANKS       VETYPE
     C                   MOVEL     CTTYPE        VETYPE
     C                   MOVEL     CTDESC        VDESC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VETYPE        CHAIN     FMCTYP                             90
     C   90              SETON                                        66
     C   66              GOTO      NXTA
      *
     C     VSTYPE        IFGT      VETYPE
     C   90              SETON                                        65
     C   65              GOTO      NXTA
     C                   ENDIF
     C     NOTYPE        TAG
      *
     C     VSPC          IFEQ      *BLANKS
     C                   GOTO      NOPC
     C                   ENDIF
      *
     C     VSPC          IFEQ      '? '
     C                   MOVEL     VSPC          PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VSPC
     C                   MOVEL     PCPRCL        VSPC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VSPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        70
     C   70              GOTO      NXTA
      *
     C     VEPC          IFEQ      '? '
     C                   MOVEL     VEPC          PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VEPC
     C                   MOVEL     PCPRCL        VEPC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VEPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        72
     C   72              GOTO      NXTA
      *
     C     VSPC          IFGT      VEPC
     C                   SETON                                        70
     C   70              GOTO      NXTA
     C                   ENDIF
      *
     C     NOPC          TAG
      *
     C     VCUST         IFGT      *ZEROS
     C     VSTYPE        ANDGT     *BLANKS
     C                   SETON                                        6062
     C   62              GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         IFGT      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        6061
     C   61              GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         IFEQ      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   MOVEL     VALPHA        CMLOOK
     C                   CALL      'CSTALOOK'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     CMCUST        VCUST
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         IFGT      *ZEROS
     C     VCUST         CHAIN     FMCUST                             90
     C   90              SETON                                        6061
     C   60
     CAN 61              GOTO      NXTA
     C                   ENDIF
      *
     C     VCO           IFEQ      *ZEROS                                                   K
     C                   SETON                                        15
     C   15              GOTO      NXTA
     C                   ENDIF
      *
     C     VCO           CHAIN     FMCOMP                             90                    K
     C   90              SETON                                        15
     C   15              GOTO      NXTA
      *
     C     VCO           IFEQ      OCO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VCO           OCO               2 0
      *
     C     VFORMS        IFEQ      *BLANKS                                                  K
     C                   SETON                                        20
     C   20              GOTO      NXTA
     C                   ENDIF
      *
     C     VFORMS        IFNE      OFORMS
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VFORMS        OFORMS            4
      *
     C     VCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        30
     C   30              GOTO      NXTA
     C                   ENDIF
      *
     C     VCOPY         IFNE      OCOPY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VCOPY         OCOPY             2 0
      *
     C     VJOB          IFNE      'Y'                                                      Q
     C     VJOB          ANDNE     'N'
     C                   SETON                                        40
     C   40              GOTO      NXTA
     C                   ENDIF
      *
     C     VJOB          IFNE      OJOB
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VJOB          OJOB              1
      *
     C     END           TAG
     C                   SETON                                        LR
      *
