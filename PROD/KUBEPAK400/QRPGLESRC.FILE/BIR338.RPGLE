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
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- BIR338
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- INVOICE BY ORDER INQUIRY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR338FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFHORDR    IF   E           K DISK
     FFHORWOR   IF   E           K DISK
     FFHORCWI   IF   E           K DISK
      *
      *MESSAGE
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)
      *
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
      *
      *******************
      * GET ORDER NUMBER
      *******************
     C     *Entry        PList
     C                   Parm                    ParmOrder        15 5
     C                   If        ParmOrder <> 0
     C                   Eval      ORDER = ParmOrder
     C                   SETOFF                                       10KF
     C                   Goto      EditA
     C                   EndIf
     C     RSTART        TAG
     C                   SETOFF                                       10
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C     EDITA         TAG
     C                   SETOFF                                       1011
     C   KC
     COR KG              GOTO      END
     C                   If        *InKF and ParmOrder <> 0
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf
     C   KF              GOTO      RSTART
     C     ORDER         IFLE      0
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
     C     ORDER         CHAIN     FHORDR                             91
     C   91              DO
     C                   MOVEL     MSG(1)        OHSLD1
     C                   ENDDO
      ***** SUB FILE
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             VLINE
     C     ORDER         SETLL     FHORWOR
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTX          TAG
     C                   SETOFF                                       50
     C     ORDER         READE     FHORWOR                                50
     C   50              GOTO      DSPL
      *
     C                   SETOFF                                       21        RI CRMEMO
     C                   Z-ADD     0             CHCRM#
     C                   MOVE      *BLANKS       TYPE
     C                   ADD       1             RECNO
     C                   ADD       1             VLINE
     C                   WRITE     RECSFL
     C                   EXSR      GETCRD
     C                   GOTO      NXTX
      *
     C     DSPL          TAG
     C     RECNO         IFLE      0
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   END
     C                   SETON                                        57
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       2             RECNO
     C                   Z-ADD     0             VLINE
     C                   Z-ADD     *ZEROS        WHCOMP
     C                   Z-ADD     *ZEROS        WHBLCU
     C                   Z-ADD     *ZEROS        WHINV#
     C                   Z-ADD     *ZEROS        WHINDT
     C                   Z-ADD     *ZEROS        WH$AMT
     C                   MOVEL     *BLANKS       WHPOS
     C                   MOVEL     *BLANKS       WHSHFR
     C                   MOVEL     *BLANKS       WHNAME
     C                   WRITE     RECSFL
     C                   SETOFF                                       57
      *
     C     NXTFMT        TAG
     C                   Z-ADD     0             LINE#
     C                   Z-ADD     0             LINE
     C                   EXFMT     RECCTL
     C   KC
     COR KG              GOTO      END
     C                   If        *InKF and ParmOrder <> 0
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf
     C   KF              GOTO      RSTART
      ** SEE IF ON A SUBFILE LINE
     C     LINE#         IFGT      0
     C     LINE#         ANDLE     LSTREC
     C     LINE#         CHAIN     RECSFL                             90
     C   90              GOTO      NXTFMT
     C     TYPE          IFEQ      'Credit'
     C                   MOVEL     'CM'          TYPO              2
     C                   Z-ADD     CHCRM#        INVINI           15 5
     C                   ELSE
     C                   MOVEL     'IN'          TYPO
     C                   Z-ADD     WHINV#        INVINI           15 5
     C                   END
     C                   CALL      'BIR337CL'
     C                   PARM                    INVINI
     C                   PARM                    TYPO
     C                   GOTO      NXTFMT
     C                   END
     C     LINE          IFEQ      0
     C                   GOTO      NXTFMT
     C                   END
     C     LINE          IFGT      LSTREC
     C                   SETON                                        90
     C                   GOTO      NXTFMT
     C                   END
     C   KKLINE          IFGT      0
     C     LINE          ANDLE     LSTREC
     C     LINE          CHAIN     RECSFL                             90
     C   90              GOTO      NXTFMT
     C     TYPE          IFEQ      'Credit'
     C                   MOVEL     'CM'          TYPO              2
     C                   Z-ADD     CHCRM#        INVINI           15 5
     C                   ELSE
     C                   MOVEL     'IN'          TYPO
     C                   Z-ADD     WHINV#        INVINI           15 5
     C                   END
     C                   CALL      'BIR337CL'
     C                   PARM                    INVINI
     C                   PARM                    TYPO
     C                   GOTO      NXTFMT
     C                   END
     C                   GOTO      NXTFMT
     C     END           TAG
     C                   SETON                                        LR
      ********************
      * GET CREDIT MEMOS *
      ********************
     C     GETCRD        BEGSR
     C     CRDKEY        KLIST
     C                   KFLD                    WHBLCU
     C                   KFLD                    HLDINV
     C                   Z-ADD     WHINV#        HLDINV            6 0
     C                   Z-ADD     0             WHINV#
     C                   SETON                                        21
     C                   MOVEL     'Credit'      TYPE
     C     CRDKEY        SETLL     FHORCWI
     C     NXTCRD        TAG
     C     CRDKEY        READE     FHORCWI                                90
     C   90              GOTO      ENDCRD
     C                   Z-ADD     CHDTOR        WHINDT
     C                   Z-ADD     CHTOT$        WH$AMT
     C                   MOVEL     CHPOS         WHPOS
     C                   MOVEL     CHSHFR        WHSHFR
     C                   MOVEL     CHNAME        WHNAME
     C                   ADD       1             RECNO
     C                   ADD       1             VLINE
     C                   WRITE     RECSFL
     C                   GOTO      NXTCRD
     C     ENDCRD        TAG
     C                   Z-ADD     HLDINV        WHINV#
     C                   SETOFF                                       21
     C                   MOVE      *BLANKS       TYPE
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
** MESSAGE
Original Order Not Found                   1
