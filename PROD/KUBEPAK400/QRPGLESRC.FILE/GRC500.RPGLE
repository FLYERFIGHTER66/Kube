      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1995
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
      **PROGRAM NAME-------- GRC500
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- GD
      **APPLICATION--------- LOT AVAILABILITY REPORT PROMPT SCREEN
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  10/18/96  GD - ADD PRINTER FIELD
      *
      *
     FFMINVT    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FGRC500FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
     D                UDS
     D  LBEGDT                 1      6  0
     D  LENDDT                 7     12  0
     D  LPC1                  13     14
     D  LPC2                  15     16
     D  LSUM                  17     17
     D  LJOBQ                 18     18
     D  LFORM                 19     28
     D  LP1COP                29     30  0
     D  LPRTR                 31     39
     D  LBEGIT                89    103
     D  LCANCL               133    133
      *
      ****************************************************************
      ***  VALIDATE RESPONSES ON PROMPT SCREEN A
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        VPRTR             8
     C     VPRTR         IFLE      *BLANKS
     C                   MOVEL     'PRT01'       VPRTR
     C                   ENDIF
      *
     C                   MOVEL     '*NAR'        VFORM
     C                   MOVEL     'N'           VJOB
     C                   Z-ADD     1             VCOPY
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101119
     C                   SETOFF                                       151652
     C                   SETOFF                                       202921
     C                   SETOFF                                       304050
     C                   SETOFF                                       527071
     C                   SETOFF                                       99
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
      *** OPTION HELP
      *
     C                   MOVEL     *BLANKS       LCANCL
     C                   Z-ADD     VBDATE        LBEGDT
     C                   Z-ADD     VEDATE        LENDDT
     C                   MOVE      VPC1          LPC1
     C                   MOVE      VPC2          LPC2
     C                   MOVEL     VITEM         LBEGIT
     C                   MOVE      VSIZE         LBEGIT
     C                   MOVEL     VFORM         LFORM
     C                   Z-ADD     VCOPY         LP1COP
     C                   MOVE      VJOB          LJOBQ
     C                   MOVEL     VPRTR         LPRTR
      *
     C     1             SUBST     VITEM:1       VITST             1
     C     VITST         IFEQ      '?'
     C                   EXSR      ITMSRC
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VITEM         IFGT      *BLANKS
     C     ITMKEY        KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C     ITMKEY        CHAIN     FMINVT                             90
     C   90              SETON                                        10
     C   10              GOTO      RSTRTA
     C                   EXSR      GETDES
     C                   ENDIF
      *
     C     VPC1          IFEQ      '? '
     C                   SETON                                        70
     C                   MOVEL     VPC1          VPRCL             2
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         VPC1
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VPC2          IFEQ      '? '
     C                   SETON                                        71
     C                   MOVEL     VPC2          VPRCL
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         VPC2
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VPC1          IFEQ      *BLANKS                                                  K
     C     VPC2          ANDGT     *BLANKS                                                  K
     C                   SETON                                        2029
     C   20              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VPC1          IFGT      *BLANKS                                                  K
     C     VPC2          ANDEQ     *BLANKS                                                  K
     C                   SETON                                        2029
     C   20              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VPC1          IFGT      VPC2                                                     K
     C                   SETON                                        2129
     C   21              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBDATE        IFGT      *ZEROS                                                   K
     C     VEDATE        ANDEQ     *ZEROS                                                   K
     C                   SETON                                        1519
     C   15              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBDATE        IFEQ      *ZEROS                                                   K
     C     VEDATE        ANDGT     *ZEROS                                                   K
     C                   SETON                                        1519
     C   15              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBDATE        MULT      10000.01      BDATE             6 0                      K
     C     VEDATE        MULT      10000.01      EDATE             6 0                      K
     C     BDATE         IFGT      EDATE                                                    K
     C                   SETON                                        1619
     C   16              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        30
     C   30              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        40
     C   40              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VJOB          IFNE      'Y'                                                      Q
     C     VJOB          ANDNE     'N'
     C                   SETON                                        50
     C   50              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VPRTR         IFEQ      *BLANKS
     C                   SETON                                        52
     C   52              GOTO      RSTRTA
     C                   ENDIF
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      **
     C     ITMSRC        BEGSR
     C                   MOVEL     *BLANKS       DESHFR            3
     C                   MOVEL     *BLANKS       IMLOOK
     C                   SUBST     VITEM:2       IMLOOK
     C                   CALL      'ITMALOOK'
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
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC             50
     C                   ENDSR
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
     C                   SETON                                        99
     C                   ENDSR
