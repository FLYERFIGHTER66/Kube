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
      *PROGRAM NAME-------- ICC110
      *SYSTEM-------------- INVENTORY
      *DESCRIPTION--------- ITEM MASTER LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMINVT    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FICC110FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
     D                UDS
     D  LCO                    1      2  0
     D  LBITEM                 3     14
     D  LEITEM                15     26
     D  LBSIZE                27     29
     D  LESIZE                30     32
     D  LBLOC                 33     35
     D  LELOC                 36     38
     D  LBVEND                39     44  0
     D  LEVEND                45     50  0
     D  LPC1                  51     52
     D  LPC2                  53     54
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
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     0             LBVEND
     C                   Z-ADD     0             LEVEND
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       1015
     C                   SETOFF                                       2025
     C                   SETOFF                                       3035
     C                   SETOFF                                       4042
     C                   SETOFF                                       6065
     C                   SETOFF                                       707172
     C                   SETOFF                                       737478
     C                   SETOFF                                       79
     C                   Z-ADD     0             CNT               2 0
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
     C     LBITEM        IFEQ      *BLANKS
     C     LEITEM        ANDEQ     *BLANKS
     C                   GOTO      NITEM
     C                   ENDIF
      *
     C                   MOVEL     LBITEM        VITEM            12
     C     1             SUBST     LBITEM:1      VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   EXSR      ITMSRC
     C                   MOVEL     VITEM         LBITEM
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C                   MOVEL     LEITEM        VITEM            12
     C     1             SUBST     LEITEM:1      VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   EXSR      ITMSRC
     C                   MOVEL     VITEM         LEITEM
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBITEM        IFEQ      *BLANKS
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C                   MOVEL     LBITEM        VVITEM
     C     ITMKEY        KLIST
     C                   KFLD                    VVITEM           12
     C     ITMKEY        SETLL     FMINVT
     C                   READ      FMINVT                                 90
     C   90              SETON                                        10
     C   10              GOTO      RSTRTA
     C     LBITEM        IFNE      IMITEM
     C                   SETON                                        10
     C   10              GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBITEM        IFGT      *BLANKS
     C     LEITEM        ANDEQ     *BLANKS
     C                   MOVEL     LBITEM        LEITEM
     C                   ENDIF
      *
     C                   MOVEL     LEITEM        VVITEM
     C     ITMKEY        SETLL     FMINVT
     C                   READ      FMINVT                                 90
     C   90              SETON                                        15
     C   15              GOTO      RSTRTA
     C     LEITEM        IFNE      IMITEM
     C                   SETON                                        15
     C   15              GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBITEM        IFGT      LEITEM
     C                   SETON                                        10
     C   10              GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBITEM        IFNE      OBITEM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBITEM        OBITEM           12
     C     LEITEM        IFNE      OEITEM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LEITEM        OEITEM           12
      *
     C     NITEM         TAG
      *
     C     LBSIZE        IFEQ      *BLANKS
     C     LESIZE        ANDEQ     *BLANKS
     C                   GOTO      NSIZE
     C                   ENDIF
      *
     C     1             SUBST     LBSIZE:1      VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       LBSIZE
     C                   MOVEL     SZCODE        LBSIZE
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     1             SUBST     LESIZE:1      VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       LESIZE
     C                   MOVEL     SZCODE        LESIZE
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBSIZE        IFGT      *BLANKS
     C     LESIZE        ANDEQ     *BLANKS
     C                   MOVEL     LBSIZE        LESIZE
     C                   ENDIF
      *
     C     LBSIZE        CHAIN     FMSIZE                             90
     C   90              SETON                                        20
     C   20              GOTO      RSTRTA
      *
     C     LESIZE        CHAIN     FMSIZE                             90
     C   90              SETON                                        25
     C   25              GOTO      RSTRTA
      *
     C     LBSIZE        IFGT      LESIZE
     C                   SETON                                        20
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBSIZE        IFNE      OBSIZE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBSIZE        OBSIZE            3
     C     LESIZE        IFNE      OESIZE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LESIZE        OESIZE            3
      *
     C     NSIZE         TAG
      *
     C     LBLOC         IFEQ      *BLANKS
     C     LELOC         ANDEQ     *BLANKS
     C                   GOTO      NOLOC
     C                   ENDIF
      *
     C     1             SUBST     LBLOC:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     LBLOC         VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         LBLOC
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     1             SUBST     LELOC:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     LELOC         VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         LELOC
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBLOC         CHAIN(N)  FMWHSE                             90
     C   90              SETON                                        30                    K
     C   30              GOTO      RSTRTA
      *
     C     LBLOC         IFGT      *BLANKS
     C     LELOC         ANDEQ     *BLANKS
     C                   MOVEL     LBLOC         LELOC
     C                   ENDIF
      *
     C     LELOC         CHAIN     FMWHSE                             90
     C   90              SETON                                        35                    K
     C   35              GOTO      RSTRTA
      *
     C     LBLOC         IFGT      LELOC
     C                   SETON                                        30                    K
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBLOC         IFNE      OBLOC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBLOC         OBLOC             3
     C     LELOC         IFNE      OELOC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LELOC         OELOC             3
      *
     C     NOLOC         TAG
      *
     C   KB              DO
     C                   Z-ADD     LCO           VMCOMP            2 0
     C                   MOVEL     *BLANKS       VMLOOK
     C                   MOVEL     'A'           VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       VALPHA           15
     C                   MOVEL     *BLANKS       VMLOOK           15
     C                   Z-ADD     VMVEND        LBVEND
     C                   GOTO      RSTRTA
     C                   ENDDO
      *
     C   KD              DO
     C                   Z-ADD     LCO           VMCOMP            2 0
     C                   MOVEL     *BLANKS       VMLOOK
     C                   MOVEL     'A'           VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        LEVEND
     C                   GOTO      RSTRTA
     C                   ENDDO
      *
     C     LBVEND        IFEQ      0
     C     LEVEND        ANDEQ     0
     C                   GOTO      NOVEND
     C                   ENDIF
      *
     C     LBVEND        IFGT      0
     C     LEVEND        ANDEQ     0
     C                   MOVEL     LBVEND        LEVEND
     C                   ENDIF
      *
     C     LBVEND        CHAIN(N)  FMVEND                             90
     C   90              SETON                                        40                    K
     C   40              GOTO      RSTRTA
      *
     C     LEVEND        CHAIN     FMVEND                             90
     C   90              SETON                                        45                    K
     C   45              GOTO      RSTRTA
      *
     C     LBVEND        IFGT      LEVEND
     C                   SETON                                        40                    K
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBVEND        IFNE      OBVEND
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LBVEND        OBVEND            6 0
     C     LEVEND        IFNE      OEVEND
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LEVEND        OEVEND            6 0
      *
     C     NOVEND        TAG
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
      *********
      * ITMSRC
      *********
      *
     C     ITMSRC        BEGSR
     C                   MOVEL     *BLANKS       DESHFR            3
     C                   MOVEL     *BLANKS       IMLOOK
     C                   SUBST     VITEM:2       IMLOOK
     C                   CALL      'LKITEM'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    DESHFR
     C                   MOVEL     IMITEM        VITEM
     C                   ENDSR
      *
      *********
      * LOCSR
      *********
     C     LOCSR         BEGSR
     C                   MOVEL     VWHSE         WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       VWHSE
     C                   MOVEL     WHWHSE        VWHSE
     C                   ENDSR
      *
