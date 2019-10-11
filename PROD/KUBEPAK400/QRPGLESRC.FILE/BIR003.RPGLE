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
      *PROGRAM NAME-------- BIR003
      *APPLICATION--------- TERMS CODES MASTER FILE MAINTENANCE
      *DESCRIPTION--------- MAINTAIN RECORDS IN TERMS CODE FILE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMTERM    UF A E           K DISK
     FFMTERMAD  UF A E           K DISK
     FBIR003FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     D MSG             S             20    DIM(3) CTDATA PERRCD(1)
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
     D  LLIST                  1      1
     D  LCANCL               133    133
      *
      * PROGRAM MAINLINE
      *
     C     RSTRTA        TAG
     C                   EXSR      CLRIT
     C                   UNLOCK    FMTERM
     C                   UNLOCK    FMTERMAD
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       1314
     C                   SETOFF                                       151618
     C                   SETOFF                                       717273
     C                   SETOFF                                       909192
     C                   SETOFF                                       909192
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KM
     COR KG              GOTO      END
      *
      * TEST TERMS CODE
      *
     C                   MOVEL     VTERM         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     VTERM         TCTERM            2
     C                   CALL      'LKTERM'
     C                   PARM                    TCTERM
     C                   PARM                    TCDESC           30
     C                   MOVEL     *BLANKS       VTERM
     C                   MOVEL     TCTERM        VTERM
     C                   MOVEL     TCDESC        VDESC
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C     VACTOK        TAG
      *
     C     VTERM         IFEQ      *BLANKS
     C                   SETON                                        1114
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C                   MOVEL     VTERM         TCTERM            2
     C     KEY3          KLIST
     C                   KFLD                    TCTERM
     C     KEY3          CHAIN     FMTERM                             90
     C                   Clear                   TCTDGP
     C     KEY3          CHAIN     FMTERMAD                           93
      *
     C  N90VACT          IFEQ      'A'
     C                   SETON                                        1214
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C   90VACT          IFNE      'A'
     C                   SETON                                        1314
     C                   EXSR      CLRIT
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        16
     C                   ENDIF
      *
      * LOAD MODE FOR OUTPUT
      *
     C     VACT          IFEQ      'A'
     C                   MOVEL     MSG(1)        VMODE            10
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   MOVEL     MSG(2)        VMODE
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   MOVEL     MSG(3)        VMODE
     C                   ENDIF
      *
     C     TCTRTP        IFEQ      1
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     TCTRTP        IFEQ      2
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     TCTRTP        IFEQ      3
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
      * NO TYPE ENTERED ON AN ADD
      *
     C     VACT          IFEQ      'A'
     C                   SETON                                        18
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       404142
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              GOTO      END
     C   KF              DO
     C                   EXSR      CLRIT
     C                   GOTO      RSTRTA
     C                   ENDDO
      *
      * TEST TERMS DESCRIPTION
      *
     C     TCDESC        IFEQ      *BLANKS
     C                   SETON                                        10
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     TCDESC        IFNE      ODESC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     TCDESC        ODESC            30
      *
      * VALIDATE DAYS ENTERED
      *
     C     TCTDAS        IFEQ      *ZEROS
     C                   SETON                                        20
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     TCTDAS        IFNE      OTDAS
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TCTDAS        OTDAS             3 0
      *
      * VALIDATE DISCOUNT DAYS NOT GREATER THAN DUE DAYS
      *
wjb15C**   TCTDAS        IFLT      TCTDAY
wjb15C**                 SETON                                        4041
wjb15C**                 GOTO      RSTRTB
wjb15C**                 ENDIF
      *
     C     TCTDAY        IFEQ      *ZEROS
     C     TCTRAT        ANDGT     *ZEROS
     C                   SETON                                        4042
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     TCTRAT        IFEQ      *ZEROS
     C     TCTDAY        ANDGT     *ZEROS
     C                   SETON                                        30
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     TCTRAT        IFNE      OTRAT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TCTRAT        OTRAT             4 2
      *
     C     TCTDAY        IFNE      OTDAY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TCTDAY        OTDAY             3 0
      *
     C  N16CNT           IFGE      1
     C                   SETON                                        98
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODLB
     C                   ENDIF
      *
     C  NKX              GOTO      RSTRTA
      *
     C     NODLB         TAG
     C                   EXSR      UFILE
     C                   EXSR      CLRIT
     C                   GOTO      RSTRTA
      *
     C     RSTRTC        TAG
     C                   WRITE     SCRNC
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       404142
     C                   SETOFF                                       505152
     C                   SETOFF                                       606162
     C                   SETOFF                                       7080
     C                   READ      SCRNC                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
     C   KF              DO
     C                   EXSR      CLRIT
     C                   GOTO      RSTRTA
     C                   ENDDO
      *
      * TEST TERMS DESCRIPTION
      *
     C     TCDESC        IFEQ      *BLANKS
     C                   SETON                                        10
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     TCDESC        IFNE      ODESC
     C                   ADD       1             CNT
     C                   ENDIF
      *
     C     TCDESC        IFNE      ODESC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     TCDESC        ODESC            30
      *
      * VALIDATE CUTOFF DAYS
      *
     C     TCCUTO        IFLT      1
     C     TCCUTO        ORGT      31
     C                   SETON                                        20
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     TCCUTO        IFNE      OCUTO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TCCUTO        OCUTO             2 0
      *
     C     TCTRAT        IFEQ      0
     C     TCDBCO        ANDGT     0
     C                   SETON                                        30
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     TCTRAT        IFEQ      0
     C     TCDACO        ANDGT     0
     C                   SETON                                        30
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     TCTRAT        IFNE      OTRAT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TCTRAT        OTRAT             4 2
      *
     C     TCMBCO        IFGT      12
     C                   SETON                                        40
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     TCMBCO        IFNE      OMBCO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TCMBCO        OMBCO             2 0
      *
     C     TCMACO        IFGT      12
     C                   SETON                                        41
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     TCMACO        IFNE      OMACO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TCMACO        OMACO             2 0
      *
     C     TCDBCO        IFGT      31
     C                   SETON                                        5051
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     TCDBCO        IFNE      ODBCO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TCDBCO        ODBCO             2 0
      *
     C     TCTRAT        IFGT      0
     C     TCDBCO        ANDEQ     0
     C                   SETON                                        5052
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     TCDACO        IFGT      31
     C                   SETON                                        6061
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     TCTRAT        IFGT      0
     C     TCMACO        ANDGT     0
     C     TCDACO        ANDEQ     0
     C                   SETON                                        5052
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     TCDACO        IFNE      ODACO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TCDACO        ODACO             2 0
      *
     C     TCNBCO        IFLT      1
     C     TCNBCO        ORGT      31
     C                   SETON                                        70
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     TCNBCO        IFNE      ONBCO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TCNBCO        ONBCO             2 0
      *
     C     TCMACO        IFGT      0
     C     TCNACO        ANDLT     1
     C     TCNACO        ORGT      31
     C                   SETON                                        80
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     TCNACO        IFNE      ONACO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TCNACO        ONACO             2 0
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODLC
     C                   ENDIF
      *
     C  NKX              GOTO      RSTRTA
      *
     C     NODLC         TAG
     C                   EXSR      UFILE
     C                   EXSR      CLRIT
     C                   GOTO      RSTRTA
      *
     C     RSTRTD        TAG
     C                   WRITE     SCRND
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       313233
     C                   SETOFF                                       4050
     C                   READ      SCRND                                  90
      *
     C   KC
     COR KG              GOTO      END
     C   KF              DO
     C                   EXSR      CLRIT
     C                   GOTO      RSTRTA
     C                   ENDDO
      *
      * TEST TERMS DESCRIPTION
      *
     C     TCDESC        IFEQ      *BLANKS
     C                   SETON                                        10
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     TCDESC        IFNE      ODESC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     TCDESC        ODESC            30
      *
     C     TCDDUE        IFGT      *ZEROS
     C     TCTRAT        ANDEQ     *ZEROS
     C                   SETON                                        20
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     TCDDUE        IFEQ      0
     C                   GOTO      NOCKD
     C                   ENDIF
      *
     C                   Z-ADD     TCDDUE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        3031
     C                   GOTO      RSTRTD
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DDATE             5 0
      *
     C     NOCKD         TAG
      *
     C     TCTRAT        IFGT      *ZEROS
     C     TCDDUE        ANDEQ     *ZEROS
     C                   SETON                                        3032
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     TCTRAT        IFNE      OTRAT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TCTRAT        OTRAT             4 2
      *
     C     TCDDUE        IFNE      ODDUE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TCDDUE        ODDUE             6 0
      *
     C                   Z-ADD     TCNDUE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        50
     C                   GOTO      RSTRTD
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         NDATE             5 0
      *
     C     DDATE         IFGT      0
     C     DDATE         ANDGT     NDATE
     C                   SETON                                        3033
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     TCNDUE        IFNE      ONDUE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     TCNDUE        ONDUE             6 0
      *
     C     CNT           IFGE      1
     C                   SETON                                        98
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODLD
     C                   ENDIF
      *
     C  NKX              GOTO      RSTRTA
      *
     C     NODLD         TAG
     C                   EXSR      UFILE
     C                   EXSR      CLRIT
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      * ADD, UPDATE OR DELETE FMTERM
      *
     C     UFILE         BEGSR
      *
     C     VACT          IFEQ      'A'
     C                   WRITE     RMTERM
     C                   WRITE     RMTERMAD
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RMTERM
     C                   DELETE    RMTERMAD
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RMTERM
     C   93              WRITE     RMTERMAD
     C  N93              UPDATE    RMTERMAD
     C                   ENDIF
     C                   ENDSR
      *
      * CLRIT - THIS SUBROUTINE PROCESSES RESTART AND UPDATE OPTIONS
      *
     C     CLRIT         BEGSR
     C                   MOVE      *BLANKS       VACT
     C                   MOVE      *BLANKS       VTERM
     C                   MOVE      *BLANKS       VDESC
     C                   MOVE      *BLANKS       TCDESC
     C                   MOVE      *BLANKS       TCTRTP
     C                   MOVE      *ZEROS        TCTDAY
     C                   MOVE      *ZEROS        TCTDAS
     C                   MOVE      *ZEROS        TCTRAT
     C                   MOVE      *ZEROS        TCCUTO
     C                   MOVE      *ZEROS        TCMBCO
     C                   MOVE      *ZEROS        TCDBCO
     C                   MOVE      *ZEROS        TCNBCO
     C                   MOVE      *ZEROS        TCMACO
     C                   MOVE      *ZEROS        TCDACO
     C                   MOVE      *ZEROS        TCNACO
     C                   MOVE      *ZEROS        TCDDUE
     C                   MOVE      *ZEROS        TCNDUE
     C                   SETOFF                                       98
     C     ECLR          ENDSR
      *
**
   Add
  Change
  Delete
