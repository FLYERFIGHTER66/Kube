      *--------------------------------------------------------------
      *
      *   COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      *PROGRAM NAME--------- APC999
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *APPLICATION---------- GLOBAL PROMPT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAPCTL    IF   E           K DISK
     FAPC999FM  CF   E             WORKSTN USROPN
     F                                     DEVID(WSID)
      *
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
      * GLR870 LDA
     D  GLCO                 201    202  0                                      ARC380
      * POST G/L Y/N
     D  GLPST                203    203
      * PRINT REPORT Y/N (ONLY IF POST = N)
     D  PRTRPT               204    204
      * APPLICATION
     D  APPL                 205    207
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     0             COMP              2 0
     C     COMP          CHAIN     FAPCTL                             90
     C                   Z-ADD     AZPRCO        LCO
     C                   Z-ADD     AZPRCO        GLCO
     C                   MOVEL     AZGL          GLPST
     C                   MOVEL     'A/P'         APPL
     C     AZNMCO        IFEQ      1
     C                   GOTO      ONECO
     C                   END
      *
     C     RSTRT         TAG
     C                   SETOFF                                       50
     C                   If        LCANCL <> 'B'
     C                   If        not %Open(APC999FM)
     C                   Open      APC999FM
     C                   EndIf
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       105051
     C                   SETOFF                                       525354
     C                   READ      SCRNA                                  90
     C                   EndIf
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C     LCO           IFEQ      *ZEROS
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     ONECO         TAG
     C     LCO           CHAIN     FAPCTL                             90
     C   90              SETON                                        10
     C   10              GOTO      RSTRT
      *
     C                   Z-ADD     LCO           GLCO
     C     LCO           CHAIN     FAPCTL                             90
     C                   MOVEL     AZPRTR        LPRTR
     C                   MOVEL     AZGL          GLPST
     C                   Z-ADD     1             LCOPY
     C                   MOVEL     'N'           LJOBQ
     C                   MOVEL     '*NAR'        LFORM
     C                   Z-ADD     1             VOUT
     C                   SETOFF                                       55
      ** IF NO GL FORCE REPORT
     C     LPROG         IFEQ      'APC550'
     C     GLPST         IFEQ      'N'
     C                   SETON                                        55
     C                   MOVEL     'Y'           PRTRPT
     C                   END
     C                   END
      *
     C     RSTRTB        TAG
     C                   If        LCANCL <> 'B'
     C                   If        not %Open(APC999FM)
     C                   Open      APC999FM
     C                   EndIf
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       505152
     C                   SETOFF                                       535456
     C                   READ      SCRNB                                  90
     C                   EndIf
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        53
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C   55PRTRPT        IFNE      'Y'                                                      OS
     C     PRTRPT        ANDNE     'N'                                                      OS
     C                   SETON                                        55
     C                   GOTO      RSTRTB
     C                   ENDIF
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
     C     END           TAG
     C                   SETON                                        LR
     C                   If        %Open(APC999FM)
     C                   Close     APC999FM
     C                   EndIf
      *
