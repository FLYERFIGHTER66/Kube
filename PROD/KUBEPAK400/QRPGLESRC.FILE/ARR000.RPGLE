      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1998
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
      *PROGRAM NAME-------- ARR000
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- A/R CONTROL FILE MAINTENANCE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FARR000FM  CF   E             WORKSTN
     FFMCORG    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFARCTL    UF A E           K DISK
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      *  PROGRAM NAME
     D  PROGID                 1     10
      *  RUN LIBRARY
     D  RLIBR                 81     90
      *  USER I.D.
     D  USERID               254    261
      *  SOURCE LIBRARY
     D  SLIBR                314    323
      *
     C     RSTRT         TAG
     C                   MOVEL     *BLANKS       VCO
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131416
     C                   SETOFF                                       172023
     C                   SETOFF                                       2122
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              DO
     C                   SETON                                        LR
     C                   GOTO      END
     C                   ENDDO
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C   10              GOTO      RSTRTA
     C     VACTOK        TAG
      *
     C     VCO           CHAIN     FMCORG                             90
     C   90              SETON                                        2021
     C   20              GOTO      RSTRTA
      *
     C     VACT          IFEQ      'A'
     C     VCO           CHAIN     FARCTL                             92                    K
     C  N92              SETON                                        2022
     C   22              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C     VCO           CHAIN     FARCTL                             92                    K
     C   92              SETON                                        2023
     C   23              GOTO      RSTRTA
     C                   MOVEL     ACBANK        VBANK
     C                   ENDIF
      *
     C     VCO           IFGT      0
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
      * COMPANY 00
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       102090
     C                   SETOFF                                       303132
     C                   READ      SCRNB                                  90
      *
     C   KF              GOTO      RSTRT
     C   KC
     COR KG              GOTO      END
      *
     C     ACPRCO        IFEQ      0
     C                   SETON                                        10
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     ACPRCO        CHAIN     FMCORG                             90
     C   90              SETON                                        10
     C   10              GOTO      RSTRTB
      *
     C     ACNMCO        IFEQ      0
     C                   SETON                                        20
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     ACNCUS        IFEQ      0
     C                   SETON                                        3031
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     ACNCUS        CHAIN     FMCUST                             90
     C  N90              SETON                                        3032
     C   32              GOTO      RSTRTB
      *
     C                   EXSR      CREC
     C                   GOTO      RSTRT
      *
     C     RSTRTC        TAG
     C                   WRITE     SCRNC
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       103855
     C                   SETOFF                                       202122
     C                   SETOFF                                       232425
     C                   SETOFF                                       262728
     C                   SETOFF                                       272829
     C                   SETOFF                                       303536
     C                   SETOFF                                       404142
     C                   SETOFF                                       434450
     C                   SETOFF                                       31
      *
     C                   READ      SCRNC                                  90
      *
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
      *
     C     1             SUBST     VBANK:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VBANK         BACODE            3
     C                   CALL      'LKBANK'
     C                   PARM                    BACODE
     C                   PARM                    BADESC           30
     C                   MOVEL     *BLANKS       VBANK
     C                   MOVEL     BACODE        VBANK
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     ACGL          IFNE      'Y'
     C     ACGL          ANDNE     'N'
     C                   SETON                                        10
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     ACGL          IFNE      OGL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     ACGL          OGL               1
      *
     C     ACSTMP        IFEQ      *BLANKS
     C                   SETON                                        35
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     ACSTMP        IFNE      OSTMP
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     ACSTMP        OSTMP            10
      *
     C     ACPAR         IFNE      'Y'
     C     ACPAR         ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     ACPAR         IFNE      OPAR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     ACPAR         OPAR              1
      *
     C     ACRPTP        IFEQ      *BLANKS
     C                   SETON                                        36
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     ACRPTP        IFNE      ORPTP
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     ACRPTP        ORPTP            10
      *
     C     ACAGPY        IFEQ      *ZEROS
     C                   SETON                                        4041
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     ACAGPY        IFNE      OAGPY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ACAGPY        OAGPY             3 0
      *
     C     ACAGP2        IFLT      ACAGPY
     C                   SETON                                        42
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     ACAGP2        IFNE      OAGP2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ACAGP2        OAGP2             3 0
      *
     C     ACAGP3        IFLT      ACAGP2
     C                   SETON                                        43
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     ACAGP3        IFNE      OAGP3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ACAGP3        OAGP3             3 0
      *
     C     ACAGP4        IFLT      ACAGP3
     C                   SETON                                        44
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     ACAGP4        IFNE      OAGP4
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ACAGP4        OAGP4             3 0
      *
     C     ACPLC         IFNE      'Y'
     C     ACPLC         ANDNE     'N'
     C                   SETON                                        55
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     ACPLC         IFNE      OPLC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     ACPLC         OPLC              1
      *
     C     ACLC          IFNE      'Y'
     C     ACLC          ANDNE     'N'
     C                   SETON                                        29
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     ACLC          IFNE      OLC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     ACLC          OLC               1
      *
     C     ACLC          IFEQ      'N'
     C                   GOTO      NOLC
     C                   ENDIF
      *
     C     ACLCPC        IFEQ      0
     C                   SETON                                        24
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     ACLCPC        IFNE      OLCPC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ACLCPC        OLCPC             4 2
      *
     C     ACLCMN        IFNE      OLCPC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ACLCPC        OLCPC             4 2
      *
     C     ACLCD#        IFEQ      0
     C                   SETON                                        25
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     ACLCD#        IFNE      OLCD#
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ACLCD#        OLCD#             3 0
      *
     C     ACLCLC        IFNE      'Y'
     C     ACLCLC        ANDNE     'N'
     C                   SETON                                        31
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     ACLCLC        IFNE      OLCLC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     ACLCLC        OLCLC             1
      *
     C     NOLC          TAG
      *
     C     ACGL          IFEQ      'Y'
     C     VBANK         ANDEQ     *BLANKS
     C                   SETON                                        26
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     VBANK         IFNE      OBANK
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VBANK         OBANK             3
      *
     C     CNT           IFGT      1
     C                   SETON                                        98
     C                   GOTO      RSTRTC
     C                   ENDIF
     C                   SETOFF                                       98
      *
     C     VACT          IFEQ      'D'
     C                   EXSR      CREC
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     RSTRTD        TAG
      *
     C     NXTD          TAG
     C                   WRITE     SCRND
     C                   Z-ADD     0             CNT
     C                   SETOFF                                       272830
     C                   SETOFF                                       323334
     C                   READ      SCRND                                  90
      *
     C   KF              GOTO      RSTRTA
     C   KC
     COR KG              GOTO      END
     C   KD              GOTO      RSTRTC
      *
     C   KB              DO
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          ACRCGL
     C                   GOTO      RSTRTD
     C                   ENDDO
      *
     C     ACPCOM        IFNE      'Y'
     C     ACPCOM        ANDNE     'N'
     C                   SETON                                        27
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     ACPCOM        IFNE      OPCOM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     ACPCOM        OPCOM             1
      *
     C     ACPCOM        IFEQ      'Y'
     C     ACPCMO        ANDNE     'I'
     C     ACPCMO        ANDNE     'P'
     C                   SETON                                        28
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     ACPCMO        IFNE      OPCMO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     ACPCMO        OPCMO             1
      *
     C     ACSTTP        IFLT      1
     C     ACSTTP        ORGT      3
     C                   SETON                                        30
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     ACSTTP        IFNE      OSTTP
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ACSTTP        OSTTP             1 0
      *
     C     ACRCKC        IFGT      0
     C     ACGL          ANDEQ     'Y'
     C     ACRCGL        ANDEQ     0
     C                   SETON                                        3233
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     ACRCGL        IFGT      0
     C     GLKEY         KLIST
     C                   KFLD                    VCO
     C                   KFLD                    ACRCGL
     C     GLKEY         CHAIN     FMGLCH                             90
     C   90              SETON                                        3234
     C   34              GOTO      RSTRTD
     C                   ENDIF
      *
     C     ACRCGL        IFNE      ORCGL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     ACRCGL        ORCGL             8 0
      *
     C     CNT           IFGT      1
     C                   SETON                                        98
     C                   GOTO      RSTRTD
     C                   ENDIF
     C                   SETOFF                                       98
      *
     C                   EXSR      CREC
     C                   GOTO      RSTRT
      *
     C     END           TAG
     C                   SETON                                        LR
      ********
      * CREC *
      ********
     C     CREC          BEGSR
     C                   MOVEL     VBANK         ACBANK
     C     VACT          IFEQ      'A'
     C                   MOVEL     'A'           ACSTAT
     C                   Z-ADD     VCO           ACCOMP
     C                   WRITE     RARCTL
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RARCTL
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RARCTL
     C                   ENDIF
     C                   ENDSR
      *
      **********
      *  LOOK  *
      **********
     C     LOOK          BEGSR
     C                   MOVEL     *BLANKS       GCLOOK
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    VCO
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   MOVEL     GCGLNO        GLNO              8 0
     C                   ENDSR
      *
