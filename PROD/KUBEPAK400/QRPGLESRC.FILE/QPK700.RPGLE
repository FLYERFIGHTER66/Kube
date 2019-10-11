      *----------------------------------------------------------      ----
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1998
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
      **PROGRAM NAME-------- QPK700
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **DESCRIPTION--------- UPDATE GERMINATION WEEKS IN MINVT
      **
      *
      *    DATE----INIT-------DESCRIPTION
      *
     FQPK700FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMPRCL    IF   E           K DISK
     FFMINVTPC  UF   E           K DISK
      *
     C     RSTRT         TAG
     C                   MOVEL     *BLANKS       VPC
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       PCDESC
     C                   Z-ADD     0             CNT
     C                   SETOFF                                       98
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       1020
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
      *
     C     1             SUBST     VPC:1         VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     VPC           PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VPC
     C                   MOVEL     PCPRCL        VPC
     C                   MOVEL     PCDESC        VDESC
     C                   SETON                                        99
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * MUST HAVE PRODUCT CLASS
      *
     C     VPC           IFEQ      *BLANKS
     C                   SETON                                        9910
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * VALIDATE PRODUCT CLASS
      *
     C     VPC           CHAIN     FMPRCL                             96
     C  N96              MOVEL     PCDESC        VDESC
      *
     C     VALPHA        IFEQ      *BLANKS
     C   96              SETON                                        10
     C   10              GOTO      NXTA
     C                   ENDIF
      *
     C     VALPHA        IFEQ      *BLANKS
     C                   SETON                                        20
     C   20              GOTO      NXTA
     C                   ENDIF
      *                                                    ABCDEFG
     C                   MOVEL     VALPHA        A1                1            A
     C                   MOVE      VALPHA        AL6               6            BCDEFG
     C                   MOVEL     AL6           A2                1            B
     C                   MOVE      VALPHA        AL5               5            CDEFG
     C                   MOVEL     AL5           A3                1            C
     C                   MOVE      VALPHA        AL4               4            DEFG
     C                   MOVEL     AL4           A4                1            D
     C                   MOVE      VALPHA        AL3               3            EFG
     C                   MOVEL     AL3           A5                1            E
     C                   MOVE      VALPHA        AL2               2            FG
     C                   MOVEL     AL2           A6                1            F
     C                   MOVE      VALPHA        AL1               1            G
     C                   MOVEL     AL1           A7                1            G
     C                   MOVEL     VALPHA        CAL4              4            ABCD
      *
     C     AL4           IFEQ      *BLANKS
     C                   SETON                                        20
     C   20              GOTO      NXTA
     C                   ENDIF
      *
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       303132
     C                   SETOFF                                       333435
     C                   SETOFF                                       4041
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              GOTO      END
      *
     C                   ADD       1             CNT               2 0
      *
     C     VB1           IFEQ      0
     C                   SETON                                          3040
     C   30
     CAN 40              GOTO      NXTB
     C                   ENDIF
      *
     C     VE1           IFEQ      0
     C                   SETON                                          31
     C   31              GOTO      NXTB
     C                   ENDIF
      *
     C     VWK1          IFEQ      0
     C                   SETON                                          32
     C   32              GOTO      NXTB
     C                   ENDIF
      *
     C     VB2           IFEQ      0
     C     VE2           ANDGT     0
     C                   SETON                                          33
     C   33              GOTO      NXTB
     C                   ENDIF
      *
     C     VB2           IFGT      0
     C     VE2           ANDEQ     0
     C                   SETON                                          33
     C   33              GOTO      NXTB
     C                   ENDIF
      *
     C     VB2           IFGT      0
     C     VWK2          ANDEQ     0
     C                   SETON                                          33
     C   33              GOTO      NXTB
     C                   ENDIF
      *
     C     VB3           IFEQ      0
     C     VE3           ANDGT     0
     C                   SETON                                          34
     C   34              GOTO      NXTB
     C                   ENDIF
      *
     C     VB3           IFGT      0
     C     VE3           ANDEQ     0
     C                   SETON                                          34
     C   34              GOTO      NXTB
     C                   ENDIF
      *
     C     VB3           IFGT      0
     C     VWK3          ANDEQ     0
     C                   SETON                                          34
     C   34              GOTO      NXTB
     C                   ENDIF
      *
     C     VB4           IFEQ      0
     C     VE4           ANDGT     0
     C                   SETON                                          35
     C   35              GOTO      NXTB
     C                   ENDIF
      *
     C     VB4           IFGT      0
     C     VE4           ANDEQ     0
     C                   SETON                                          35
     C   35              GOTO      NXTB
     C                   ENDIF
      *
     C     VB4           IFGT      0
     C     VWK4          ANDEQ     0
     C                   SETON                                          35
     C   34              GOTO      NXTB
     C                   ENDIF
      *
     C     CNT           IFEQ      1
     C                   SETON                                          98
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VPC           SETLL     FMINVTPC
     C     NXTI          TAG
     C     VPC           READE     FMINVTPC                               97
     C   97              GOTO      RSTRT
      *
     C                   MOVEL     IMLOOK        IAL7              7
     C                   MOVEL     IMLOOK        IAL4              4
     C                   MOVE      IAL7          IAL3              3
      *
     C     IAL4          IFNE      CAL4
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     AL3           IFGT      *BLANKS
     C     IAL3          ANDNE     AL3
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C                   Z-ADD     VB1           IMBD1
     C                   Z-ADD     VB2           IMBD2
     C                   Z-ADD     VB3           IMBD3
     C                   Z-ADD     VB4           IMBD4
     C                   Z-ADD     VE1           IMED1
     C                   Z-ADD     VE2           IMED2
     C                   Z-ADD     VE3           IMED3
     C                   Z-ADD     VE4           IMED4
     C                   Z-ADD     VWK1          IMWG1
     C                   Z-ADD     VWK2          IMWG2
     C                   Z-ADD     VWK3          IMWG3
     C                   Z-ADD     VWK4          IMWG4
      *
     C                   UPDATE    RMINVT
     C                   GOTO      NXTI
      *
     C     END           TAG
     C                   SETON                                        LR
      *
