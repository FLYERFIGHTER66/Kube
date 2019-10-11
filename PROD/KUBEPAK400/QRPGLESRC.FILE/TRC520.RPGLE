    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- TRC520
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- TRUCK SCHEDULE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FTRC520FM  CF   E             WORKSTN
     FFTRHDRH1  IF   E           K DISK
     F                                     RENAME(RTRHDRH:TRHDRL1)
     FFTRHDRH   IF   E           K DISK
     F                                     RENAME(RTRHDRH:TRHDRH)
     FFTRHDRHD  IF   E           K DISK
      *
      *

      *? Function Prototypes
    ?D/COPY QFunctDefn,$isPrinter
      *
      *? Data Structures
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LCO                    1      2  0                                      ARC380
     D  LDATE                  3      8  0
     D  LSDATE                 9     15  0
     D  LTRUCK                16     19
     D  LROUT                 20     21
     D  LDIR                  22     22
     D  FILE                  23     32
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LVOUT                134    134  0
     D  LTRKMAN              135    135

     D  LPRTR1               140    149
     D  LPRTR2               150    159
     D  LPRTR3               160    169
     D  LPRTR4               170    179
     D  LPRTR5               180    189

      *? Data Areas
     D Printers        DS                  DTAARA(TRC520)
     D  PRT_1                        10A                                        ?Printer to Use #1
     D  PRT_2                        10A                                        ?Printer to Use #2
     D  PRT_3                        10A                                        ?Printer to Use #3
     D  PRT_4                        10A                                        ?Printer to Use #4
     D  PRT_5                        10A                                        ?Printer to Use #5

      *******************
      * START HERE      *
      *******************
      ** IF LPRTR IS GREATER THAN BLANK WE ARE ON NEXT RUN.
     C     LPRTR1        IFGT      *BLANKS
     C                   Z-ADD     LVOUT         VOUT
     C                   GOTO      NORST
     C                   END
     C                   If        LDATE = *Zero
     C                   Z-ADD     TDATE         LDATE
     C                   EndIf
     C*                  MOVE      *BLANKS       LTRUCK
     C     RSTART        TAG
     C                   MOVE      *BLANKS       LROUT
     C                   Z-ADD     1             VOUT
     C*                  MOVEL     'Q1      '    LPRTR1
     C*                  MOVEL     'P9      '    LPRTR2
     C*                  MOVEL     'Q7      '    LPRTR3
     C*                  MOVEL     'R3      '    LPRTR4
     C*                  MOVEL     'R6      '    LPRTR5
WJB  C                   In        Printers
WJB  C                   MOVEL     PRT_1         LPRTR1
WJB  C                   MOVEL     PRT_2         LPRTR2
WJB  C                   MOVEL     PRT_3         LPRTR3
WJB  C                   MOVEL     PRT_4         LPRTR4
WJB  C                   MOVEL     PRT_5         LPRTR5

     C                   MOVEL     '*NAR    '    LFORM
     C                   Z-ADD     1             LCOPY
     C                   MOVEL     'Y'           LJOBQ
     C                   Z-ADD     1             VOUT
     C     NORST         TAG
wjb  C                   Eval      TRK_OR_MAN = 'T'
     C                   MOVE      *BLANKS       LCANCL
     C                   SETOFF                                       102030
     C                   SETOFF                                       404158
     C                   SETOFF                                       505152
     C                   SETOFF                                       535498
     C                   SETOFF                                       555657
      *
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       4041
     C                   SETOFF                                       505152
     C                   SETOFF                                       535455
     C                   SETOFF                                       565758
     C   KC
     COR KG              DO
     C                   MOVE      'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
      *
     C                   Eval      LPRTR1 = %Trim(LPRTR1)
     C                   Eval      LPRTR2 = %Trim(LPRTR2)
     C                   Eval      LPRTR3 = %Trim(LPRTR3)
     C                   Eval      LPRTR4 = %Trim(LPRTR4)
     C                   Eval      LPRTR5 = %Trim(LPRTR5)
      *
     C   13              DO
     C     *Lock         In        Printers
     C                   Eval      PRT_1 = LPRTR1
     C                   Eval      PRT_2 = LPRTR2
     C                   Eval      PRT_3 = LPRTR3
     C                   Eval      PRT_4 = LPRTR4
     C                   Eval      PRT_5 = LPRTR5
     C                   Out       Printers
     C                   GOTO      NXTA
     C                   ENDDO
      *
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10  99
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     ##CYMD        LSDATE
      ** CHECK IF DATE EXISTS
     C     DTEKEY        CHAIN     TRHDRL1                            41
     C     *IN41         IFEQ      *ON
     C                   MOVE      *ON           *IN99
     C                   GOTO      NXTA
     C                   END
      *
     C     LDATE         IFNE      ODATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LDATE         ODATE             6 0
      *
      * TRUCK ENTERED
     C     LTRUCK        IFGT      *BLANKS
     C                   MOVEL     LTRUCK        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       TRUCK
     C                   MOVE      *BLANKS       ROUT
     C                   Z-ADD     LDATE         WKDATE            6 0
     C                   CALL      'TRR220'
     C                   PARM                    WKDATE
     C                   PARM                    TRUCK             4
     C                   PARM                    ROUT              2
     C                   MOVEL     TRUCK         LTRUCK
     C                   MOVEL     ROUT          LROUT
     C                   GOTO      NXTA
     C                   END
      ** CHECK IF EXISTS
     C     TRKKEY        KLIST
     C                   KFLD                    LTRUCK
     C                   KFLD                    LSDATE
     C     TRKKEY        CHAIN     FTRHDRH                            20
     C   20              SETON                                        99
     C   20              GOTO      NXTA
     C                   END
      *
     C     LTRUCK        IFNE      OTRUCK
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LTRUCK        OTRUCK            4
      *
      * ROUT  ENTERED
     C     LROUT         IFGT      *BLANKS
     C                   MOVEL     LROUT         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       TRUCK
     C                   MOVE      *BLANKS       ROUT
     C                   Z-ADD     LDATE         WKDATE            6 0
     C                   CALL      'TRR220'
     C                   PARM                    WKDATE
     C                   PARM                    TRUCK             4
     C                   PARM                    ROUT              2
     C                   MOVEL     TRUCK         LTRUCK
     C                   MOVEL     ROUT          LROUT
     C                   GOTO      NXTA
     C                   END
      ** CHECK IF EXISTS
     C     ROTKEY        KLIST
     C                   KFLD                    LSDATE
     C                   KFLD                    LROUT
     C     ROTKEY        CHAIN     FTRHDRHD                           30
     C   30              SETON                                        99
     C   30              GOTO      NXTA
     C                   END
      *
     C     LROUT         IFNE      OROUT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LROUT         OROUT             2
      *
     C     LPRTR1        IFEQ      *BLANKS                                                  K
     C                   SETON                                        50  99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LPRTR1        IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR1        OPRTR            10
      *
     C     LPRTR2        IFNE      OPRTR2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR2        OPRTR2           10
      *
     C     LPRTR3        IFNE      OPRTR3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR3        OPRTR3           10
      *
     C     LPRTR4        IFNE      OPRTR4
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR4        OPRTR4           10
      *
     C     LPRTR5        IFNE      OPRTR5
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR5        OPRTR5           10
      *
     C                   If        LPRTR1 <> *Blanks and not $isPrinter(LPRTR1)
     C                   ADD       1             CNT
     C                   SETON                                        55  99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   If        LPRTR2 <> *Blanks and not $isPrinter(LPRTR2)
     C                   ADD       1             CNT
     C                   SETON                                        56  99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   If        LPRTR3 <> *Blanks and not $isPrinter(LPRTR3)
     C                   ADD       1             CNT
     C                   SETON                                        57  99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   If        LPRTR4 <> *Blanks and not $isPrinter(LPRTR4)
     C                   ADD       1             CNT
     C                   SETON                                        58  99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   If        LPRTR5 <> *Blanks and not $isPrinter(LPRTR5)
     C                   ADD       1             CNT
     C                   SETON                                        59  99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51  99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52  99
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
     C                   SETON                                        53  99
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
     C                   SETON                                        54  99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VOUT          IFNE      OOUT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VOUT          OOUT              1 0
     C                   Z-ADD     VOUT          LVOUT
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
     C   98              GOTO      NXTA
     C                   ENDIF
      *
     C                   Eval      LTRKMAN = TRK_OR_MAN
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
     C     DTEKEY        KLIST
     C                   KFLD                    LSDATE
      ** BUILD FILE
     C                   MOVE      TIMOD         FILE
     C                   MOVEL     'TRHD'        FILE
     C                   ENDSR
