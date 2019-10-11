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
      *PROGRAM NAME-------- ICR630
      *SYSTEM-------------- INVENTORY
      *APPLICATION--------- CLEAR PHYSICAL INVENTORY COUNTS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FICR630FM  CF   E             WORKSTN
     FFMINVT    UF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
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
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       202122
     C                   SETOFF                                       25
     C                   SETOFF                                       404142
     C                   SETOFF                                       45
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   END
      *
     C     LBLOC         IFEQ      *BLANKS
     C     LELOC         ANDEQ     *BLANKS
     C                   GOTO      NOLOC
     C                   ENDIF
      *
     C     1             SUBST     LBLOC:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LBLOC         VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         LBLOC
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     1             SUBST     LELOC:1       VTST1             1
     C     VTST1         IFEQ      '?'
     C     VTST1         OREQ      '/'
     C                   MOVEL     LELOC         VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         LELOC
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBLOC         CHAIN     FMWHSE                             90
     C   90              SETON                                        2021                  K
     C   21              GOTO      RSTRTA
      *
     C     LELOC         IFEQ      *BLANKS
     C                   MOVEL     LBLOC         LELOC
     C                   ENDIF
      *
     C     LELOC         CHAIN     FMWHSE                             90
     C   90              SETON                                        25                    K
     C   25              GOTO      RSTRTA
      *
     C     LBLOC         IFGT      LELOC
     C                   SETON                                        2022                  K
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBLOC         IFNE      OBLOC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBLOC         OBLOC             3
      *
     C     LELOC         IFNE      OELOC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LELOC         OELOC             3
      *
     C     NOLOC         TAG
      *
      * CHECK PC
      *
     C     LBPC          IFEQ      *BLANKS
     C                   GOTO      NOPC
     C                   ENDIF
      *
     C     1             SUBST     LBPC:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LBPC          VPRCL             2
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         LBPC
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     1             SUBST     LEPC:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LEPC          VPRCL
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         LEPC
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBPC          IFGT      *BLANKS
     C     LEPC          ANDEQ     *BLANKS
     C                   MOVEL     LBPC          LEPC
     C                   ENDIF
      *
     C     LBPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        4041                  K
     C   41              GOTO      RSTRTA
      *
     C     LEPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        45                    K
     C   45              GOTO      RSTRTA
      *
     C     LBPC          IFGT      LEPC
     C                   SETON                                        4042                  K
     C   22              GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBPC          IFNE      OBPC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBPC          OBPC              2
      *
     C     LEPC          IFNE      OEPC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LEPC          OEPC              2
      *
     C     NOPC          TAG
      *
     C     LBCODE        IFNE      OBCODE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBCODE        OBCODE            2
      *
     C     LECODE        IFNE      OECODE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LECODE        OECODE            2
      *
     C     LBLIST        IFNE      OBLIST
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBLIST        OBLIST            4
      *
     C     LELIST        IFNE      OELIST
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LELIST        OELIST            4
      *
      ** CHECK IF CHANGES
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTA
     C                   END
      *
     C     LBCODE        IFGT      *BLANKS
     C                   SETON                                        01
     C                   ENDIF
     C     LBLOC         IFGT      *BLANKS
     C     LELOC         ORGT      *BLANKS
     C                   SETON                                        02
     C                   ENDIF
     C     LBLIST        IFGT      *BLANKS
     C                   SETON                                        03
     C                   ENDIF
     C     LBPC          IFGT      *BLANKS
     C                   SETON                                        04
     C                   ENDIF
      *
     C                   UNLOCK    FMINVT
     C                   MOVEL     *BLANKS       VITEM            12
     C     VITEM         SETLL     FMINVT
      *
     C     NXTM          TAG
     C                   SETOFF                                       90
     C                   READ      FMINVT                                 90
     C   90              GOTO      END
      *
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXTM
     C                   ENDIF
      *
     C     IMCOMP        IFNE      LCO
     C                   GOTO      NXTM
     C                   ENDIF
      *
     C   01IMCYCD        IFLT      LBCODE                                                      ARC38
     C     IMCYCD        ORGT      LECODE                                                      ARC38
     C                   GOTO      NXTM
     C                   ENDIF
      *
     C   02IMWHSE        IFLT      LBLOC                                                       ARC38
     C     IMWHSE        ORGT      LELOC                                                       ARC38
     C                   GOTO      NXTM
     C                   ENDIF
      *
     C   03IMLIST        IFLT      LBLIST
     C     IMLIST        ORGT      LELIST
     C                   GOTO      NXTM
     C                   ENDIF
      *
     C   04IMPCL1        IFLT      LBPC
     C     IMPCL1        ORGT      LEPC
     C                   GOTO      NXTM
     C                   ENDIF
      *
     C                   Z-ADD     0             IMQPHY
     C                   UPDATE    RMINVT
      *
     C                   GOTO      NXTM
      *
     C     END           TAG
     C                   SETON                                        LR
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
      * LOCSR
      *********
     C     LOCSR         BEGSR
     C                   MOVEL     VWHSE         WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       VWHSE
     C                   MOVEL     WHWHSE        VWHSE
     C                   MOVEL     WHDESC        VDESC            30
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
     C                   ENDSR
