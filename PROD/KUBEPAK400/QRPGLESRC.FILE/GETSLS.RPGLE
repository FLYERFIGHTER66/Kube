      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      *PROGRAM NAME-------- GETSLS
      *SYSTEM-------------- ORDER ENTRY
      *DESCRIPTION--------- SHIPPED ORDERS VS. OPEN ORDERS PROMPT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMSIZE    IF   E           K DISK
     FFMCTYP    IF   E           K DISK
     FGETSLSFM  CF   E             WORKSTN
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
     D  LCO                    1      2  0
     D  SOFROM                 3      8  0
     D  SOFCYM                 9     15  0
     D  SOTO                  16     21  0
     D  SOTCYM                22     28  0
     D  OOFROM                29     34  0
     D  OOFCYM                35     41  0
     D  OOTO                  42     47  0
     D  OOTCYM                48     54  0
     D  CTYP1                 55     56
     D  CTYP2                 57     58
     D  CTYP3                 59     60
     D  CTYP4                 61     62
     D  SIZE1                 63     65
     D  SIZE2                 66     68
     D  SIZE3                 69     71
     D  SIZE4                 72     74
     D  SIZE5                 75     77
     D  SIZE6                 78     80
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
     C                   Z-ADD     0             SOFROM
     C                   Z-ADD     0             SOTO
     C                   Z-ADD     0             OOFROM
     C                   Z-ADD     0             OOTO
     C                   MOVE      *BLANKS       CTYP1
     C                   MOVE      *BLANKS       CTYP2
     C                   MOVE      *BLANKS       CTYP3
     C                   MOVE      *BLANKS       CTYP4
     C                   MOVE      *BLANKS       SIZE1
     C                   MOVE      *BLANKS       SIZE2
     C                   MOVE      *BLANKS       SIZE3
     C                   MOVE      *BLANKS       SIZE4
     C                   MOVE      *BLANKS       SIZE5
     C                   MOVE      *BLANKS       SIZE6
     C                   MOVE      *BLANKS       LCANCL
     C                   MOVEL     'XERPRT01'    LPRTR
     C                   MOVEL     '*NAR'        LFORM
     C                   Z-ADD     1             LCOPY
     C                   MOVEL     'N'           LJOBQ
     C                   Z-ADD     1             VOUT
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
     C                   Z-ADD     0             CNT               4 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       15
     C                   SETOFF                                       202122
     C                   SETOFF                                       25
     C                   SETOFF                                       303132
     C                   SETOFF                                       34
     C                   SETOFF                                       404142
     C                   SETOFF                                       434445
     C                   SETOFF                                       465051
     C                   SETOFF                                       525354
     C                   SETOFF                                       98
      *  CHECK HISTORY DATES
     C                   Z-ADD     SOFROM        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     ##CYMD        SOFCYM
      *
     C     SOFROM        IFNE      OSOF
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     SOFROM        OSOF              6 0
      *
     C                   Z-ADD     SOTO          ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        15
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     ##CYMD        SOTCYM
      *
     C     SOTCYM        IFLT      SOFCYM
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     SOTO          IFNE      OSOT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     SOTO          OSOT              6 0
      *
      *  CHECK OPEN ORDER DATES
     C                   Z-ADD     OOFROM        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     ##CYMD        OOFCYM
      *
     C     OOFROM        IFNE      OOOF
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     OOFROM        OOOF              6 0
      *
     C                   Z-ADD     OOTO          ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        25
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     ##CYMD        OOTCYM
      *
     C     OOTCYM        IFLT      OOFCYM
     C                   SETON                                        2022
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     OOTO          IFNE      OOOT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     OOTO          OOOT              6 0
      *
      * CHECK CUSTOMER TYPES
     C     1             SUBST     CTYP1:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   EXSR      TYPSR
     C                   MOVEL     CTTYPE        CTYP1
     C                   ENDIF
      *
     C     1             SUBST     CTYP2:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   EXSR      TYPSR
     C                   MOVEL     CTTYPE        CTYP2
     C                   ENDIF
      *
     C     1             SUBST     CTYP3:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   EXSR      TYPSR
     C                   MOVEL     CTTYPE        CTYP3
     C                   ENDIF
      *
     C     1             SUBST     CTYP4:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   EXSR      TYPSR
     C                   MOVEL     CTTYPE        CTYP4
     C                   ENDIF
      * NOW CHECK IF ANY ENTERED ARE VALID
     C     CTYP1         IFGT      *BLANKS
     C     CTYP1         CHAIN     FMCTYP                             31
     C   31              GOTO      NXTA
     C                   END
      *
     C     CTYP2         IFGT      *BLANKS
     C     CTYP2         CHAIN     FMCTYP                             32
     C   32              GOTO      NXTA
     C                   END
      *
     C     CTYP3         IFGT      *BLANKS
     C     CTYP3         CHAIN     FMCTYP                             33
     C   33              GOTO      NXTA
     C                   END
      *
     C     CTYP4         IFGT      *BLANKS
     C     CTYP4         CHAIN     FMCTYP                             34
     C   34              GOTO      NXTA
     C                   END
      *
      *  MUST ENTER AT LEAST 1 CUST TYPE
     C     CTYP1         IFLE      *BLANKS
     C     CTYP2         ANDLE     *BLANKS
     C     CTYP3         ANDLE     *BLANKS
     C     CTYP4         ANDLE     *BLANKS
     C                   SETON                                        3031
     C                   GOTO      NXTA
     C                   END
      *
     C     CTYP1         IFNE      OCTYP1
     C     CTYP2         ORNE      OCTYP2
     C     CTYP3         ORNE      OCTYP3
     C     CTYP4         ORNE      OCTYP4
     C                   ADD       1             CNT
     C                   MOVEL     CTYP1         OCTYP1            2
     C                   MOVEL     CTYP2         OCTYP2            2
     C                   MOVEL     CTYP3         OCTYP3            2
     C                   MOVEL     CTYP4         OCTYP4            2
     C                   ENDIF
      *
      * NOW CHECK SIZE CODES
     C     1             SUBST     SIZE1:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   EXSR      SIZSR
     C                   MOVEL     SZCODE        SIZE1
     C                   ENDIF
      *
     C     1             SUBST     SIZE2:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   EXSR      SIZSR
     C                   MOVEL     SZCODE        SIZE2
     C                   ENDIF
      *
     C     1             SUBST     SIZE3:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   EXSR      SIZSR
     C                   MOVEL     SZCODE        SIZE3
     C                   ENDIF
      *
     C     1             SUBST     SIZE4:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   EXSR      SIZSR
     C                   MOVEL     SZCODE        SIZE4
     C                   ENDIF
      *
     C     1             SUBST     SIZE5:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   EXSR      SIZSR
     C                   MOVEL     SZCODE        SIZE5
     C                   ENDIF
      *
     C     1             SUBST     SIZE6:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   EXSR      SIZSR
     C                   MOVEL     SZCODE        SIZE6
     C                   ENDIF
      * NOW CHECK ENTERED FIELDS
     C     SIZE1         IFGT      *BLANKS
     C     SIZE1         CHAIN     FMSIZE                             41
     C   41              GOTO      NXTA
     C                   END
      *
     C     SIZE2         IFGT      *BLANKS
     C     SIZE2         CHAIN     FMSIZE                             42
     C   42              GOTO      NXTA
     C                   END
      *
     C     SIZE3         IFGT      *BLANKS
     C     SIZE3         CHAIN     FMSIZE                             43
     C   43              GOTO      NXTA
     C                   END
      *
     C     SIZE4         IFGT      *BLANKS
     C     SIZE4         CHAIN     FMSIZE                             44
     C   44              GOTO      NXTA
     C                   END
      *
     C     SIZE5         IFGT      *BLANKS
     C     SIZE5         CHAIN     FMSIZE                             45
     C   45              GOTO      NXTA
     C                   END
      *
     C     SIZE6         IFGT      *BLANKS
     C     SIZE6         CHAIN     FMSIZE                             46
     C   46              GOTO      NXTA
     C                   END
      * NEED AT LEAST 1 SIZE CODE
     C     SIZE1         IFLE      *BLANKS
     C     SIZE2         ANDLE     *BLANKS
     C     SIZE3         ANDLE     *BLANKS
     C     SIZE4         ANDLE     *BLANKS
     C     SIZE5         ANDLE     *BLANKS
     C     SIZE6         ANDLE     *BLANKS
     C                   SETON                                        4041
     C                   GOTO      NXTA
     C                   ENDIF
     C     SIZE1         IFNE      OSIZE1
     C                   ADD       1             CNT
     C                   MOVEL     SIZE1         OSIZE1            3
     C                   ENDIF
     C     SIZE2         IFNE      OSIZE2
     C                   ADD       1             CNT
     C                   MOVEL     SIZE2         OSIZE2            3
     C                   ENDIF
     C     SIZE3         IFNE      OSIZE3
     C                   ADD       1             CNT
     C                   MOVEL     SIZE3         OSIZE3            3
     C                   ENDIF
     C     SIZE4         IFNE      OSIZE4
     C                   ADD       1             CNT
     C                   MOVEL     SIZE4         OSIZE4            3
     C                   ENDIF
     C     SIZE5         IFNE      OSIZE5
     C                   ADD       1             CNT
     C                   MOVEL     SIZE5         OSIZE5            3
     C                   ENDIF
     C     SIZE6         IFNE      OSIZE6
     C                   ADD       1             CNT
     C                   MOVEL     SIZE6         OSIZE6            3
     C                   ENDIF
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      NXTA
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
     C                   GOTO      NXTA
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
     C                   GOTO      NXTA
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
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
      *********
      * TYPSR
      *********
     C     TYPSR         BEGSR
     C                   MOVE      *BLANKS       CTTYPE
     C                   CALL      'LKTYPE'
     C                   PARM                    CTTYPE
     C                   PARM                    CTDESC
     C                   ENDSR
      *
      *********
      * SIZSR
      *********
     C     SIZSR         BEGSR
     C                   MOVE      *BLANKS       SZCODE
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC
     C                   ENDSR
      *
