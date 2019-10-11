     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
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
      *PROGRAM NAME-------- APR010
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- VENDOR MASTER MAINTENANCE
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 10/17/99 GD LOG #4  ERROR IF MVPC = N AND SUMM = Y
      * 07/16/00 EFD01 CHECK IF OPEN PO ON DELETE
      *  9/26/01 EFD USE NMOFIL FOR ACCOUNT NUMBER.
      *  1/6/03  CAB  ADDED VCOM3 TO INCREASE SIZE OF COMMENTS.  C.BUCK
      *
      *
     FAPR010FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMVEND    UF A E           K DISK
     FFVENDCM   UF A E           K DISK
     FFAPCTL    UF   E           K DISK
     FFMSTAT    IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFAPOPN    IF   E           K DISK
     FFAPDTP    IF   E           K DISK
EFD01FFSYSCTL   IF   E             DISK
      *
     D MSG             S              9    DIM(4) CTDATA PERRCD(1)
     D MSGA            S             79    DIM(3) CTDATA PERRCD(1)
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
     D                UDS
     D  LCO                    1      2  0
     D  LVEND                172    177  0
     D  CALLD                178    178

      *? Function Prototypes
    ?D/COPY QFunctDefn,$isNote
    ?D/COPY QFunctDefn,$Notes

     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   UNLOCK    FAPCTL
     C                   UNLOCK    FMVEND
     C                   UNLOCK    FVENDCM
      *
      * OVERRIDE VENDOR NUMBER
      *
     C                   MOVE      '00'          AZCOMP
     C     AZCOMP        CHAIN(N)  FAPCTL                             90
      *
      * DOES CUSTOMER USE PURCHASE ORDERS
      *
EFD01C     LCO           CHAIN(N)  FSYSCTL                            90
EFD01C*          ZZPO      IFEQ 'Y'
EFD01C*                    SETON                     66
EFD01C*                    ENDIF
      *
      * CHECK IF CALLED
      *
     C     CALLD         IFEQ      'Y'
     C                   MOVEL     'A'           VACT
     C                   GOTO      CALLED
     C                   Else
     C     CALLD         IfNE      ' '
     C                   MOVEL     CALLD         VACT
     C                   Z-add     LVEND         VVEND
     C                   GOTO      CALLED
     C                   END
     C                   END
      *
      * PROGRAM MAINLINE
      *
     C     RSTRTA        TAG
      *
      * NON DISPLAY NEW ALPHA SEARCH
      *
     C                   SETOFF                                       44
     C                   EXSR      CLRIT
     C                   Eval      *In60 = *Off
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       09
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       161718
     C                   SETOFF                                       193650
     C                   SETOFF                                       7784
     C                   SETOFF                                       818248
     C                   SETOFF                                       909192
     C                   SETOFF                                       9598
     C                   READ      SCRNA                                  90
      *
     C   KM              CALL      'APC110CL'
     C   KC
     COR KM
     COR KG              GOTO      END
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C     VACT          OREQ      'I'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C                   GOTO      NXTA
     C     VACTOK        TAG
      *
     C     VVEND         IFEQ      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   Z-ADD     VMCONM        VMCOMP            2 0
     C                   MOVEL     VALPHA        VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        VVEND
     C                   MOVEL     VMNAME        VENNAM
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         IFEQ      *ZEROS
     C     SEARCH        ANDGT     *BLANKS
     C                   CALL      'LKVEND'
     C                   PARM                    SEARCH
     C                   PARM                    ACCOUNT           6
     C                   MOVEL     *BLANKS       SEARCH
     C                   MOVE      ACCOUNT       VVEND
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TEST VENDOR NUMBER ON ADD - SYSTEM ASSIGNED NUMBER
      *
     C     VACT          IFEQ      'A'
     C     VVEND         ANDGT     0
     C                   SETON                                        0914
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * COME HERE IF CALLED
      *
     C     CALLED        TAG
     C     VACT          IFEQ      'A'
     C     AZCOMP        CHAIN     FAPCTL                             97
     C                   Z-ADD     AZVEND        VMVEND                         GET NEXT VEND#
     C                   Z-ADD     AZVEND        VVEND                          GET NEXT VEND#
     C                   Z-ADD     AZVEND        LVEND                                      D#
     C                   ADD       1             AZVEND            6 0          UPDATE VEND#
     C                   Z-ADD     TDATE         AZDTLA
     C                   Z-ADD     TIMOD         AZTIME
     C                   MOVEL     USERID        AZUSER
     C                   UPDATE    RAPCTL
     C                   GOTO      ENDA
     C                   ENDIF
      *
      * BOTH FIELDS BLANK ON OTHER THAN ADD
      *
     C     VACT          IFNE      'A'
     C     VVEND         ANDEQ     0
     C     VALPHA        ANDEQ     *BLANKS
     C                   SETON                                        1714
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * ENTRIES IN BOTH FIELDS
      *
     C     VVEND         IFGT      0
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        1714
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C                   Z-ADD     VVEND         VMVEND            6 0
     C     VVEND         CHAIN     FMVEND                             90
     C   90              SETON                                        3614
     C   36              GOTO      NXTA
     C                   MOVEL     VMTMCD        VTMCD             2
     C                   MOVEL     VMTMCD        TCTERM            2
     C                   MOVEL     VMSTST        VSTATE
     C     KEY3          KLIST
     C                   KFLD                    TCTERM
     C     KEY3          CHAIN     FMTERM                             90
     C                   MOVEL     TCDESC        VTERM
     C                   ENDIF
      *
     C     VACT          IFEQ      'I'
     C                   SETON                                        77
     C                   GOTO      ENDA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        7050
     C                   SETON                                        8477
     C                   ENDIF
      *
      * ? IF OKAY TO DELETE VENDOR
      *
     C   84              DO
     C     VVEND         SETLL     FAPDTP                             94
     C     VVEND         READE     FAPDTP                                 94
     C   94              GOTO      CKOPEN
     C                   SETON                                        1418
     C   18              GOTO      NXTA
     C     CKOPEN        TAG
      *
     C     VVEND         SETLL     FAPOPN
EFD01C     NXTOPN        TAG
     C     VVEND         READE     FAPOPN                                 93
EFD01C   93              GOTO      ENDOPN
EFD01C     APCLCD        IFEQ      'Y'
EFD01C                   GOTO      NXTOPN
EFD01C                   ENDIF
     C                   SETON                                        1416
     C   16              GOTO      NXTA
EFD01C     ENDOPN        TAG
      *
EFD01C*                    MOVEL*BLANKS   ERROR   1
EFD01C*  66                CALL 'APR012'
EFD01C*                    PARM           VVEND
EFD01C*                    PARM           ERROR
EFD01C*          ERROR     IFEQ 'X'
EFD01C*                    SETON                     1419
EFD01C*                    ENDIF
EFD01C*  19                GOTO NXTA
     C                   ENDDO
      *
     C     ENDA          TAG
      *
      * LOAD MODE FOR OUTPUT
      *
     C     VACT          IFEQ      'A'
     C                   MOVEL     MSG(1)        VMODE             9
     C                   MOVEL     *BLANKS       VMNAME
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   MOVEL     MSG(2)        VMODE
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   MOVEL     MSG(3)        VMODE
     C                   SETON                                        50
     C                   ENDIF
     C     VACT          IFEQ      'I'
     C                   MOVEL     MSG(4)        VMODE
     C                   SETON                                        50
     C                   ENDIF
      *
     C                   MOVEL     MSGA(1)       MESAGE
     C     VACT          IFNE      'A'
     C                   MOVEL     VMLOOK        OLOOK            15
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   Move      *Blanks       KEYFLD
     C                   MoveL     VMVEND        KEYFLD
     C                   Eval      *In60 = $isNote('FMVEND':KEYFLD)
     C     VVEND         CHAIN     FVENDCM                            88
     C     VACT          IFEQ      'A'
     C                   MOVEL     AZTMCD        VTMCD
     C                   Z-ADD     AZCRL$        VMCRLM
     C     VTMCD         CHAIN     FMTERM                             90
     C                   MOVEL     TCDESC        VTERM
     C                   MOVEL     'Y'           VMCDUP
     C                   MOVEL     'Y'           VMMVPC
     C                   MOVEL     'N'           VMSUMM
     C                   MOVEL     'N'           VMWIRE
     C                   ENDIF
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       0945
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       161718
     C                   SETOFF                                       192021
     C                   SETOFF                                       222324
     C                   SETOFF                                       252627
     C                   SETOFF                                       282933
     C                   SETOFF                                       313450
     C                   SETOFF                                       5455
     C                   SETOFF                                       707148
     C                   SETOFF                                       909192
     C                   SETOFF                                       9598
     C                   READ      SCRNB                                  90
      *
     C                   If        NOTES = 1 or NOTES = 2
     C                   CallP     $Notes('FMVEND':KEYFLD)
     C                   GOTO      RSTRTB
     C                   EndIf

     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
      *
      * DELETE VENDOR
      *
EFD01C   KX              DO
EFD01C                   DELETE    RMVEND
EFD01C                   GOTO      RSTRTA
EFD01C                   ENDDO
      *
      * F1 = GOTO PRIMARY CONTACT SCREEN
      *
     C   KA              GOTO      RSTRTE
      *
      * F4 = GOTO PURCHASE DATE SCREEN
      *
     C   KD              GOTO      RSTRTC
      *
     C   84              ADD       1             CNT
     C   77              GOTO      NOCHK

      * F2 = GOTO NOTES
      *
      * TEST VENDOR NAME
      *
     C     VMNAME        IFEQ      *BLANKS
     C                   SETON                                        20
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VMNAME        IFNE      ONAME
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMNAME        ONAME            30
      *
     C     VMLOOK        IFEQ      *BLANKS
     C                   SETON                                        24
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C     VMLOOK        ANDNE     OLOOK
     C                   ADD       1             CNT
     C                   SETON                                        44
     C                   ENDIF
     C                   MOVEL     VMLOOK        OLOOK            15
      *
     C     VMADD2        IFNE      OADD2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMADD2        OADD2            30
      *
     C     VMADD3        IFNE      OADD3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMADD3        OADD3            30
      *
     C     VMADD4        IFNE      OADD4
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMADD4        OADD4            30
      *
     C     VMCITY        IFNE      OCITY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMCITY        OCITY            18
      *
      * VALIDATE STATE CODE
      *
     C                   MOVEL     VSTATE        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   CALL      'LKSTAT'
     C                   PARM                    VSTATE
     C                   PARM                    STNAME           30
     C                   MOVEL     *BLANKS       VSTATE
     C                   MOVEL     STCODE        VSTATE
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VSTATE        IFGT      *BLANKS
     C     VSTATE        CHAIN     FMSTAT                             96
     C   96              SETON                                        2233
     C   22              GOTO      NXTB
     C                   ENDIF
      *
     C     VMCOUN        IFEQ      *BLANKS
     C     VSTATE        ANDEQ     *BLANKS
     C                   SETON                                        2234
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VSTATE        IFGT      *BLANKS
     C     VSTATE        ANDNE     OSTST
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VSTATE        OSTST             2
      *
     C     VMZIPD        IFNE      OZIP
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMZIPD        OZIP              9
      *
     C     VMVCON        IFNE      OVCON
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMVCON        OVCON            30
      *
     C     VMPHON        IFNE      OPHON
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VMPHON        OPHON            10 0
      *
     C     VMFAX         IFNE      OFAX
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VMFAX         OFAX             10 0
      *
     C                   MOVEL     VTMCD         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     VTMCD         TCTERM            2
     C                   CALL      'LKTERM'
     C                   PARM                    TCTERM
     C                   PARM                    TCDESC           30
     C                   MOVEL     *BLANKS       VTMCD
     C                   MOVEL     TCTERM        VTMCD
     C                   MOVEL     TCDESC        VTERM
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VTMCD         IFEQ      *ZEROS
     C                   SETON                                        23
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C                   MOVEL     VTMCD         TCTERM            2
     C     KEY3          CHAIN     FMTERM                             90
     C   90              SETON                                        23
     C   23              GOTO      NXTB
      *
     C     VMCDUP        IFNE      'Y'
     C     VMCDUP        ANDNE     'N'
     C                   SETON                                        26
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VMMVPC        IFNE      'Y'
     C     VMMVPC        ANDNE     'N'
     C                   SETON                                        2754
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C   KB              DO
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          VMGLAC
     C                   GOTO      NXTB
     C                   ENDDO
      *
     C     VMGLAC        IFGT      0
     C                   MOVEL     LCO           GCCOMP            2 0
     C                   MOVEL     VMGLAC        GCGLNO            8 0
     C     KEYG          KLIST
     C                   KFLD                    GCCOMP
     C                   KFLD                    GCGLNO
     C     KEYG          CHAIN     FMGLCH                             90
     C   90              SETON                                        45
     C   45              GOTO      NXTB
     C                   ENDIF
      *
     C     VMSUMM        IFNE      'Y'
     C     VMSUMM        ANDNE     'N'
     C                   SETON                                        28
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VMMVPC        IFEQ      'N'
     C     VMSUMM        ANDEQ     'Y'
     C                   SETON                                        2755
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VMTXID        IFGT      *BLANKS
     C     VMTXCD        ANDNE     'F'
     C     VMTXCD        ANDNE     'S'
     C                   SETON                                        29
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VMWIRE        IFNE      'Y'
     C     VMWIRE        ANDNE     'N'
     C                   SETON                                        31
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VMFLAG        IFEQ      4
     C                   SETON                                        30
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     NOCHK         TAG
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C   98
     CANN84              MOVEL     MSGA(2)       MESAGE
     C   98
     CAN 84              MOVEL     MSGA(3)       MESAGE
     C                   Z-ADD     0             CNT
     C   98              GOTO      NXTB
     C                   ENDIF
      *
     C                   MOVEL     VTMCD         VMTMCD
     C                   MOVEL     VSTATE        VMSTST
     C     VACT          IFEQ      'A'
     C                   MOVEL     'A'           VMSTAT
     C                   Z-ADD     LCO           VMCONM
     C                   Z-ADD     TDATE         VMDTLA
     C                   Z-ADD     TIMOD         VMTIME
     C                   MOVEL     USERID        VMUSER
     C                   WRITE     RMVEND
     C                   ENDIF
      *
     C     VACT          IFEQ      'C'
     C                   MOVEL     'A'           VMSTAT
     C                   Z-ADD     LCO           VMCONM
     C                   UPDATE    RMVEND
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   MOVEL     'D'           VMSTAT
     C                   UPDATE    RMVEND
     C                   ENDIF
      *
     C     CALLD         IFNE      ' '
     C                   GOTO      END
     C                   ELSE
     C                   GOTO      RSTRTA
     C                   END
      *
     C     RSTRTC        TAG
     C                   WRITE     SCRNC
     C                   READ      SCRNC                                  90
      *
     C   KC
     COR KG              GOTO      END
     C*  KB                GOTO RSTRTB
     C                   GOTO      RSTRTB
      *
     C     RSTRTE        TAG
     C                   SETON                                        89
     C                   WRITE     SCRNE
     C                   SETOFF                                       98
     C                   Z-ADD     0             CNT               2 0
     C                   READ      SCRNE                                  90
      *
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
      *
     C                   If        NOTES = 1 or NOTES = 2
     C                   MoveL     VMVEND        KEYFLD           25
     C                   CallP     $Notes('FMVEND':KEYFLD)
     C                   Eval      *In60 = *On
     C                   GOTO      RSTRTE
     C                   EndIf
      *
     C     VMPTTL        IFNE      OPTTL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMPTTL        OPTTL             8
      *
     C     VMFNAM        IFNE      OFNAM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMFNAM        OFNAM            12
      *
     C     VMLNAM        IFNE      OLNAM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMLNAM        OLNAM            20
      *
     C     VMBTTL        IFNE      OBTTL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMBTTL        OBTTL            30
      *
     C     VMEML         IFNE      OEMAL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMEML         OEMAL            33
      *
     C     VMURL         IFNE      OURL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMURL         OURL             50
      *
     C     VMCOM1        IFNE      OCOM1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMCOM1        OCOM1            50
      *
     C     VMCOM2        IFNE      OCOM2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMCOM2        OCOM2            50
      *
CAB  C     VMCOM3        IFNE      OCOM3
CAB  C                   ADD       1             CNT
CAB  C                   ENDIF
CAB  C                   MOVEL     VMCOM3        OCOM3            50
      *
     C     CNT           IFGT      0
     C     VACT          ANDNE     'I'
     C                   SETON                                        98
     C                   GOTO      RSTRTE
     C                   ENDIF
      *
     C     VMPTTL        IFEQ      *BLANKS
     C     VMFNAM        ANDEQ     *BLANKS
     C     VMLNAM        ANDEQ     *BLANKS
     C     VMBTTL        ANDEQ     *BLANKS
     C     VMEML         ANDEQ     *BLANKS
     C     VMURL         ANDEQ     *BLANKS
     C     VMCOM1        ANDEQ     *BLANKS
     C     VMCOM2        ANDEQ     *BLANKS
CAB  C     VMCOM3        ANDEQ     *BLANKS
     C                   SETOFF                                       89
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C   89              WRITE     RVENDCM
     C                   ENDIF
      *
     C     VACT          IFEQ      'C'
     C  N88              UPDATE    RVENDCM
     C   88
     CAN 89              WRITE     RVENDCM
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C  N88              DELETE    RVENDCM
     C                   ENDIF
      *
     C                   GOTO      RSTRTB
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      **********
      * CLRIT  *
      **********
      *
     C     CLRIT         BEGSR
     C                   SETOFF                                       515253
     C                   MOVE      *BLANKS       VACT
     C                   Z-ADD     0             VVEND
     C                   MOVE      *BLANKS       VALPHA
     C                   MOVE      *BLANKS       VMNAME
     C                   MOVE      *BLANKS       VMLOOK
     C                   MOVE      *BLANKS       VMADD2
     C                   MOVE      *BLANKS       VMADD3
     C                   MOVEL     *BLANKS       VMADD4
     C                   MOVEL     *BLANKS       VMCITY
     C                   MOVEL     *BLANKS       VSTATE
     C                   MOVEL     *BLANKS       VMZIPD
     C                   MOVEL     *BLANKS       VMCOUN
     C                   MOVE      *BLANKS       VMTYPE
     C                   MOVE      *BLANKS       VMTXID
     C                   MOVEL     *BLANKS       VMTMCD
     C                   MOVEL     *BLANKS       VMOFIL
     C                   Z-ADD     0             VMCRLM
     C                   Z-ADD     0             VMCONM
     C                   Z-ADD     0             VMGLAC
     C                   MOVE      *BLANKS       VMPTTL
     C                   MOVE      *BLANKS       VMFNAM
     C                   MOVE      *BLANKS       VMLNAM
     C                   MOVE      *BLANKS       VMBTTL
     C                   MOVE      *BLANKS       VMEML
     C                   MOVE      *BLANKS       VMMVPC
     C                   MOVE      *BLANKS       VMCDUP
     C                   MOVE      *BLANKS       VMFLAG
     C                   MOVE      *BLANKS       VMSUMM
     C                   MOVE      *BLANKS       VMTXCD
     C                   MOVE      *BLANKS       VMWIRE
     C                   MOVE      *BLANKS       VMVCON
     C                   MOVE      *BLANKS       VMMSG
     C                   Z-ADD     0             VMPHON
     C                   Z-ADD     0             VMFAX
      *
     C     ECLR          ENDSR
      *
      **********
      *  LOOK  *
      **********
     C     LOOK          BEGSR
     C                   MOVEL     *BLANKS       GCLOOK
     C                   Z-ADD     LCO           VCO               2 0
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    VCO
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   MOVEL     GCGLNO        GLNO              8 0
     C                   ENDSR
      *
**
  Add
 Change
 Delete
 Inquire
**  BOTTOM OF SCREEN MESSAGES
_
                Validate Data - Change or Press Enter to Accept
            Press F23 to Delete - or F6 to Restart without Delete
