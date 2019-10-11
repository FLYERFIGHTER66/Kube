      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      *PROGRAM NAME-------- ICC810
      *SYSTEM-------------- INVENTORY
      *DESCRIPTION--------- TRANSACTION REPORT PROMPT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMPRCL    IF   E           K DISK
     FICC810FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
     D                UDS
     D  LCO                    1      2  0
     D  LPC1                   3      4
     D  LPC2                   5      6
     D  BEGDAT                 7     12  0
     D  BEGCYM                13     19  0
     D  ENDDAT                20     25  0
     D  ENDCYM                26     32  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
      *
     C                   Z-ADD     1             VOUT
     C                   SETOFF                                       102021
     C                   SETOFF                                       606165
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CHK               5 0
     C                   Z-ADD     0             CNT               5 0
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       102021
     C                   SETOFF                                       606165
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
      *
     C     LPC1          IFEQ      *BLANKS
     C     LPC2          ANDEQ     *BLANKS
     C                   GOTO      NOPC
     C                   ENDIF
      *
     C     1             SUBST     LPC1:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LPC1          VPRCL             2
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         LPC1
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     1             SUBST     LPC2:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LPC2          VPRCL
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         LPC2
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LPC1          IFGT      *BLANKS
     C     LPC2          ANDEQ     *BLANKS
     C                   MOVEL     LPC1          LPC2
     C                   ENDIF
      *
     C     LPC1          CHAIN     FMPRCL                             90
     C   90              SETON                                        6061                  K
     C   61              GOTO      RSTRTA
      *
     C     LPC2          CHAIN     FMPRCL                             90
     C   90              SETON                                        65                    K
     C   65              GOTO      RSTRTA
      *
     C     LPC1          IFGT      LPC2
     C   90              SETON                                        6062                  K
     C   62              GOTO      RSTRTA
     C                   ENDIF
      *
     C     LPC1          IFNE      OPC1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPC1          OPC1              2
      *
     C     LPC2          IFNE      OPC2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPC2          OPC2              2
      *
     C     LPC1          IFNE      OPC1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPC1          OPC1              2
     C     LPC2          IFNE      OPC2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPC2          OPC2              2
      *
     C     NOPC          TAG
      *
     C     BEGDAT        IFGT      0
     C                   Z-ADD     BEGDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C                   END
     C                   Z-ADD     ##CYMD        BEGCYM
     C                   ELSE
     C                   Z-ADD     0             BEGCYM
     C                   END
     C     ENDDAT        IFGT      0
     C                   Z-ADD     ENDDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        20
     C                   GOTO      RSTRTA
     C                   END
     C                   Z-ADD     ##CYMD        ENDCYM
     C                   ELSE
     C                   Z-ADD     9999999       ENDCYM
     C                   END
     C     BEGCYM        IFGT      ENDCYM
     C                   SETON                                        2021
     C                   GOTO      RSTRTA
     C                   END
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      0                                                        OS
     C                   SETON                                        52
     C                   GOTO      RSTRTA
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
     C                   GOTO      RSTRTA
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
     C                   GOTO      RSTRTA
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
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
      *********
      * PCSR
      *********
     C     PCSR          BEGSR
     C                   MOVEL     VPRCL         PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VPRCL
     C                   MOVEL     PCPRCL        VPRCL
     C                   MOVEL     PCDESC        VDESC            30
     C                   ENDSR
