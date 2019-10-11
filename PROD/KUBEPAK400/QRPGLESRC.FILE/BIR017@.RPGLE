      *----------------------------------------------------------      ----
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1993
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDE      RED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXC      EPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *       EFD ENTERPRISES INC.  215-643-5352
      *
      *----------------------------------------------------------      ----
      **PROGRAM NAME-------- BIR017
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **DESCRIPTION--------- ENTER/UPDATE FREIGHT CODES.
      **
      *            *******************************
      *            **     PROGRAM CHANGE LOG    **
      *            *******************************
      *
      *    DATE----INIT-------DESCRIPTION
      *
     FBIR017FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFFPERC    UF A E           K DISK
      *
     D @@NM            S              1    DIM(30)
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
      *
     D                UDS
     D  LCO                    1      2  0
     D  LLIST                  3      3
     D  LCANCL               133    133
      *
     C     RSTRT         TAG
     C                   EXSR      CLRIT
     C                   EXSR      CLRIND
     C                   Z-ADD     LCO           FPCONO
     C     NXTA          TAG
     C                   SETON                                        50
     C                   WRITE     SCRNA
     C                   SETOFF                                       212223
     C                   SETOFF                                       242526
     C                   SETOFF                                       192827
     C                   READ      SCRNA                                  90
      *
     C   KM              CALL      'QPK120CL'
     C   KC
     COR KM
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
     C                   EXSR      SR100A
     C   99              GOTO      NXTA
     C                   EXSR      SR100B
     C                   GOTO      RSTRT
      *
     C     END           TAG
     C   KC
     COR KM
     COR KG              SETON                                        LR
      *
      **************************
      ******     SR100A - TOP OF SCREEN
      **************************
      *
     C     SR100A        BEGSR
     C                   SETOFF                                       99
      *
      ****   TEST ACTION CODE
     C     VACT          COMP      'A'                                262621     ADD C      ODE
     C   26VACT          COMP      'C'                                262622     CHANG      E/UPDATE
     C   26VACT          COMP      'D'                                262623     DELET      E
      *
     C   26              SETON                                        99
     C   26              GOTO      E100A
      *
      *
     C                   MOVEL     FPCODE        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       FPCODE
     C                   CALL      'LKFRCD'
     C                   PARM                    FPCONO
     C                   PARM                    FPCODE
     C                   SETON                                        99
     C                   GOTO      E100A
     C                   ENDIF
      *
      ****   MUST HAVE FREIGHT CODE
      *
     C     FPCODE        IFLE      *BLANKS
     C                   SETON                                        9919
     C                   GOTO      E100A
     C                   ENDIF
      *
      ****   VALIDATE FREIGHT CODE
      *
     C     CKEY8         KLIST
     C                   KFLD                    FPCONO
     C                   KFLD                    FPCODE
     C     CKEY8         CHAIN     FFPERC                             98
     C     VACT          IFEQ      'A'
     C  N98              SETON                                        9927
     C   99              GOTO      E100A
     C                   ENDIF
     C  N98              EXSR      HIT
     C   98              EXSR      MISS
     C   99              GOTO      E100A
      *
     C     E100A         TAG
      *
     C                   ENDSR
      *
      **************************
      ******     SR100B - BOTTOM OF SCREEN
      **************************
      *
     C     SR100B        BEGSR
      *
      ****  DELETE OR REACTIVATE RECORD
      *
     C                   SETOFF                                       50
     C     VACT          IFEQ      'D'
     C                   SETON                                        33
     C                   END
      *
     C     NXTB          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      *
     C   KF              GOTO      RSTRT
      *
     C   33              EXSR      DELE
      *
     C   33
     COR 34
     COR 35              GOTO      RSTRT
     C   KC
     COR KG              GOTO      END
      *
      ****   TYPE REQUIRED
      *
     C                   SETOFF                                       995758
     C     FPTYPE        IFEQ      *BLANKS
     C                   SETON                                        9957
     C                   ENDIF
      *
     C   99
     CAN 57              GOTO      NXTB
      *
      ****   NO PERCENT ALLOWED WITH TYPE "F"
      *
     C                   SETOFF                                       9955
     C     FPTYPE        IFEQ      'F'
     C     FPCHRG        IFGT      0.00
     C                   SETON                                        9955
     C                   ENDIF
     C                   ENDIF
      *
      ****   MAXIMUM CAN NOT BE LESS THAN MINIMUM
      *
     C     FPMIN         IFGT      0
     C     FPMAX         ANDGT     0
     C     FPMAX         ANDLT     FPMIN
     C                   SETON                                        9958
     C                   END
      *
     C   99              GOTO      NXTB
      *
      ****   PERCENT REQUIRED WITH TYPE "P"
      *
     C                   SETOFF                                       9956
     C     FPTYPE        IFEQ      'P'
     C     FPCHRG        IFEQ      0.00
     C                   SETON                                        9956
     C                   ENDIF
     C                   ENDIF
      *
     C   99
     CAN 56              GOTO      NXTB
      *
     C   21              WRITE     RFPERC
     C   22              UPDATE    RFPERC
      *
     C     E300B         ENDSR
      *
      *  HIT - THIS SUBROUTINE PROCESSES OPTIONS OFF OF A FREIGHT
      *        CODE THAT HAS BEEN FOUND
      *
     C     HIT           BEGSR
     C   22FPSTAT        COMP      'D'                                    99
     C   23FPSTAT        COMP      'D'                                    99
     C   24FPSTAT        COMP      'A'                                    99
     C   25FPSTAT        COMP      'D'                                    99
     C   99              SETON                                        80
     C                   ENDSR
      *
      ****   CLEAR INDICATORS
      *
     C     CLRIND        BEGSR
     C                   SETOFF                                       555099
     C                   SETOFF                                       333435
     C                   SETOFF                                       272819
     C                   SETOFF                                       212223
     C                   SETOFF                                       242526
     C                   SETOFF                                       278020
     C                   SETOFF                                       5657
     C                   ENDSR
      *
      *  MISS - THIS SUBROUTINE PROCESSES OPTIONS ON NO HIT TO A
      *         FREIGHT CODE
      *
     C     MISS          BEGSR
      *
     C   21              MOVEL     'A'           FPSTAT
      *
     C   22
     COR 23              SETON                                        9920
     C                   ENDSR
      *
      *  CLRIT - THIS SUBROUTINE CLEARS FIELDS ON RESTARTS AND
      *     ON THE COMPLETION OF SUCCESSFUL MAINTENANCE ACTIVITY       S
      *
     C     CLRIT         BEGSR
     C                   SETOFF                                       289911
     C                   MOVE      ' '           VACT
     C                   MOVE      *BLANKS       FPCODE
     C                   Z-ADD     *ZEROS        FPCHRG
     C                   MOVE      ' '           FPTYPE
     C                   ENDSR
      *
      *  ***********
      *  * DELETE  *
      *  ***********
      *
     C     DELE          BEGSR
     C                   MOVE      'D'           FPSTAT
     C                   UPDATE    RFPERC
     C                   ENDSR
      *
