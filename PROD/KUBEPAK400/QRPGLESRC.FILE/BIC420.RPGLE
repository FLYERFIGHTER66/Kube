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
      *PROGRAM NAME-------- BIC420
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- PRINT ORDER ACKNOWLEDGEMENTS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFHORDR    IF   E           K DISK
     FBIC420FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
      * REPRINT Y OR N
     D  LCO                    1      2  0
     D  LREPRT                 3      3
     D  LBDATE                 4      9  0
     D  LEDATE                10     15  0
     D  LBORD                 16     21  0
     D  LEORD                 22     27  0
     D  BDATE                 28     32  0
     D  EDATE                 33     37  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     D  LPLUG                172    172
     D  LSHIP2               180    185  0
     D  LBILL2               186    191  0
     D  LSHPDT               192    197  0
      *
     C     RSTRT         TAG
     C     LBORD         IFGT      0
     C                   Z-ADD     LBORD         LSTORD
     C                   SETON                                        87
     C                   ELSE
     C                   SETOFF                                       87
     C                   END
     C  N87              MOVEL     'N'           LREPRT
     C   87              MOVEL     'Y'           LREPRT
     C                   Z-ADD     0             LBORD
     C                   Z-ADD     0             LEORD
     C                   Z-ADD     0             LBDATE
     C                   Z-ADD     0             LEDATE
     C                   If        LPLUG = *Blanks
     C                   MOVE      'P'           LPLUG
     C                   EndIf
     C                   Z-ADD     1             VOUT
     C   87              GOTO      RSTRTB
     C                   MOVEL     '*NAR'        LFORM
     C                   MOVEL     '*PDF    '    LPRTR
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       1098
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
      *
     C     LREPRT        IFNE      'Y'                                                      Q
     C     LREPRT        ANDNE     'N'
     C                   SETON                                        10
     C   10              GOTO      RSTRTA
     C                   ENDIF
      *
     C     LREPRT        IFEQ      'N'
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LREPRT        IFEQ      'Y'
     C                   Eval      LSHPDT = 0
     C                   Eval      LSHIP2 = 0
     C                   Eval      LBILL2 = 0
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       15
     C                   SETOFF                                       202122
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
      *
     C     LBDATE        IFEQ      0
     C     LEDATE        ANDEQ     0
     C                   GOTO      NODATE
     C                   ENDIF
      *
     C                   Z-ADD     LBDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1011
     C                   GOTO      RSTRTB
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         BDATE             5 0
      *
     C     LBDATE        IFGT      0
     C     LEDATE        ANDEQ     0
     C                   Z-ADD     LBDATE        LEDATE
     C                   ENDIF
      *
     C                   Z-ADD     LEDATE        ##MDY             6 0                      K
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        15
     C                   GOTO      RSTRTB
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EDATE             5 0
      *
     C     BDATE         IFGT      EDATE                                                    K
     C                   SETON                                        10
     C   10              GOTO      RSTRTB
     C                   ENDIF
      *
     C     LBDATE        IFNE      OBDATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LBDATE        OBDATE            6 0
      *
     C     LEDATE        IFNE      OEDATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LEDATE        OEDATE            6 0
      *
     C     NODATE        TAG
      *
      * VALIDATE ORDER NUMBERS
      *
     C     LBORD         IFEQ      0
     C     LEORD         ANDEQ     0
     C                   GOTO      NOORD
     C                   ENDIF
      *
     C     LBORD         IFGT      0
     C     LEORD         ANDEQ     0
     C                   Z-ADD     LBORD         LEORD
     C                   ENDIF
      *
     C     LBORD         IFGT      LEORD
     C                   SETON                                        2021
     C   21              GOTO      RSTRTB
     C                   ENDIF
      *
     C     LBORD         IFNE      OBORD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LBORD         OBORD             6 0
      *
     C     LEORD         IFNE      OEORD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LEORD         OEORD             6 0
      *
     C     NOORD         TAG
      *
     C     LBDATE        IFGT      0
     C     LBORD         ANDGT     0
     C                   SETON                                        1012
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LCOPY         IFNE      OCOPY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LCOPY         OCOPY             2 0
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        53
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LJOBQ         IFNE      OJOBQ
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LJOBQ         OJOBQ             1
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VOUT          IFNE      OOUT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VOUT          OOUT              1 0
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
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   GOTO      END
      *
     C     RSTRTC        TAG
     C                   WRITE     SCRNC
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101115
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C                   READ      SCRNC                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
      *
     C     LBORD         IFEQ      0                                                        OS
     C                   SETON                                        1011
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     LEORD         IFEQ      0                                                        OS
     C                   Z-ADD     LBORD         LEORD
     C                   ENDIF
      *
     C     LBORD         IFGT      LEORD
     C                   SETON                                        1013
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     LBORD         CHAIN     FHORDR                             90
     C  N90OHSTAT        IFEQ      'D'
     C     OHCOFL        OREQ      'Y'
     C                   SETON                                        1012
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     LEORD         CHAIN     FHORDR                             90
     C  N90OHSTAT        IFEQ      'D'
     C     OHCOFL        OREQ      'Y'
     C                   SETON                                        15
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     LBORD         IFNE      OBORD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LBORD         OBORD             6 0
      *
     C     LEORD         IFNE      OEORD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LEORD         OEORD             6 0
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      0                                                        OS
     C                   SETON                                        52
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     LCOPY         IFNE      OCOPY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LCOPY         OCOPY             2 0
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        53
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     LJOBQ         IFNE      OJOBQ
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LJOBQ         OJOBQ             1
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     VOUT          IFNE      OOUT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VOUT          OOUT              1 0
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
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
