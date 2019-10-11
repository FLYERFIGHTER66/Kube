      *--------------------------------------------------------------
      *
      *   COPYRIGHT EFD ENTERPRISES, INC.     1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *****************************************************************
      *PROGRAM NAME-------- ICR605
      *SYSTEM-------------- INVENTORY
      *DESCRIPTION--------- ENTER PHYSICAL INVENTORY COUNT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FICR605FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFMPRCL    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFLISTCD   IF   E           K DISK
     FFMINVT    UF   E           K DISK
     FFTINVT    O  A E             DISK
      *
     D MSG             S             30    DIM(2) CTDATA PERRCD(1)
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
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   UNLOCK    FMINVT
      *
     C     RSTRTA        TAG
     C                   SETOFF                                       8182
     C                   MOVEL     *BLANKS       LMETH
     C                   MOVEL     *BLANKS       LBLOC
     C                   MOVEL     *BLANKS       LELOC
     C                   MOVEL     *BLANKS       LBPC
     C                   MOVEL     *BLANKS       LEPC
     C                   MOVEL     *BLANKS       LBCODE
     C                   MOVEL     *BLANKS       LECODE
     C                   MOVEL     *BLANKS       LBLIST
     C                   MOVEL     *BLANKS       LELIST
     C                   MOVEL     *BLANKS       DESP
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       10
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      ENDP
      *
     C     LMETH         IFLT      1
     C     LMETH         ORGT      2
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LMETH         IFEQ      1
     C                   SETON                                        81
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LMETH         IFEQ      2
     C                   SETON                                        82
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       202122
     C                   SETOFF                                       25
     C                   SETOFF                                       303132
     C                   SETOFF                                       35
     C                   SETOFF                                       404142
     C                   SETOFF                                       45
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      ENDP
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
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     1             SUBST     LELOC:1       VTST1             1
     C     VTST1         IFEQ      '?'
     C     VTST1         OREQ      '/'
     C                   MOVEL     LELOC         VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         LELOC
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LBLOC         CHAIN     FMWHSE                             90
     C   90              SETON                                        2021                  K
     C   21              GOTO      RSTRTB
      *
     C     LELOC         IFEQ      *BLANKS
     C                   MOVEL     LBLOC         LELOC
     C                   ENDIF
      *
     C     LELOC         CHAIN     FMWHSE                             90
     C   90              SETON                                        25                    K
     C   25              GOTO      RSTRTB
      *
     C     LBLOC         IFGT      LELOC
     C                   SETON                                        2022                  K
     C                   GOTO      RSTRTB
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
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     1             SUBST     LEPC:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LEPC          VPRCL
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         LEPC
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LBPC          IFGT      *BLANKS
     C     LEPC          ANDEQ     *BLANKS
     C                   MOVEL     LBPC          LEPC
     C                   ENDIF
      *
     C     LBPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        4041                  K
     C   41              GOTO      RSTRTB
      *
     C     LEPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        45                    K
     C   45              GOTO      RSTRTB
      *
     C     LBPC          IFGT      LEPC
     C                   SETON                                        4042                  K
     C   22              GOTO      RSTRTB
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
     C     LBLIST        IFEQ      *BLANKS
     C     LELIST        ANDEQ     *BLANKS
     C                   GOTO      NOLIST
     C                   ENDIF
      *
     C     1             SUBST     LBLIST:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LBLIST        LCCODE
     C                   CALL      'LKLIST'
     C                   PARM                    LCCODE
     C                   PARM                    LCDESC           30
     C                   MOVEL     *BLANKS       LBLIST
     C                   MOVEL     LCCODE        LBLIST
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     1             SUBST     LELIST:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LELIST        LCCODE
     C                   CALL      'LKLIST'
     C                   PARM                    LCCODE
     C                   PARM                    LCDESC           30
     C                   MOVEL     *BLANKS       LELIST
     C                   MOVEL     LCCODE        LELIST
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LBLIST        CHAIN     FLISTCD                            90
     C   90              SETON                                        3031                  K
     C   31              GOTO      RSTRTB
      *
     C     LELIST        IFEQ      *BLANKS
     C                   MOVEL     LBLIST        LELIST
     C                   ENDIF
      *
     C     LELIST        CHAIN     FLISTCD                            90
     C   90              SETON                                        35                    K
     C   35              GOTO      RSTRTB
      *
     C     LBLIST        IFGT      LELIST
     C                   SETON                                        3032                  K
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     NOLIST        TAG
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
     C     LBCODE        IFGT      *BLANKS
     C                   SETON                                        01
     C                   ENDIF
      *
     C     LBLOC         IFGT      *BLANKS
     C     LELOC         ORGT      *BLANKS
     C                   SETON                                        02
     C                   ENDIF
      *
     C     LBLIST        IFGT      *BLANKS
     C                   SETON                                        03
     C                   ENDIF
      *
     C     LBPC          IFGT      *BLANKS
     C                   SETON                                        04
     C                   ENDIF
      *
     C                   GOTO      RSTRT
      *
     C     RSTRTC        TAG
      *
     C                   MOVEL     *BLANKS       VITEM
     C                   MOVEL     *BLANKS       VSIZE
     C                   MOVEL     *BLANKS       VLOC
     C                   MOVEL     *BLANKS       VUOM
     C                   MOVEL     *BLANKS       ITTREF
     C                   MOVEL     *BLANKS       DESP
     C                   MOVEL     *BLANKS       VALPHA
     C                   Z-ADD     0             VQTY
     C                   SETOFF                                       98
      *
     C     NXTC          TAG
     C                   WRITE     SCRNC
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       40
     C                   READ      SCRNC                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      ENDP
     C   KF              Z-ADD     0             COUNT
     C   KF              GOTO      RSTRTA
      *
     C     VITEM         IFEQ      *BLANKS
     C     VALPHA        ANDGT     *BLANKS
     C                   MOVEL     VALPHA        IMLOOK
     C                   MOVEL     '   '         SHPFR
     C                   CALL      'LKITAL'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        VITEM
     C                   MOVEL     IMSIZE        VSIZE
     C                   MOVEL     IMWHSE        VLOC
     C                   MOVEL     *BLANKS       VALPHA
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     1             SUBST     VLOC:1        VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     *BLANKS       WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       VLOC
     C                   MOVEL     WHWHSE        VLOC
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     1             SUBST     VUOM:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     IMPUOM        VUNIT             2
     C                   EXSR      UOMSR
     C                   MOVEL     VUNIT         VUOM
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     KEY18         KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C                   KFLD                    VLOC
     C     KEY18         CHAIN     FMINVT                             90
     C   90              SETON                                        10
     C   90              SETOFF                                       98
     C   10              GOTO      NXTC
     C                   EXSR      GETDES
      *
     C     VQTY          IFEQ      0
     C                   SETON                                        20
     C                   SETOFF                                       98
     C   10              GOTO      NXTC
     C                   ENDIF
      *
     C     VUOM          IFNE      IMPUOM
     C                   SETON                                        30
     C                   SETOFF                                       98
     C   10              GOTO      NXTC
     C                   ENDIF
      *
     C     VITEM         IFNE      OITEM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VITEM         OITEM            12
     C     VSIZE         IFNE      OSIZE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VSIZE         OSIZE             3
     C     VLOC          IFNE      OLOC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VLOC          OLOC              3
     C     VUOM          IFNE      OUOM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VUOM          OUOM              2
     C     VQTY          IFNE      OQTY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VQTY          OQTY             10 0
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C                   ADD       VQTY          IMQPHY
     C                   Z-ADD     TDATE         IMDTLA
     C                   Z-ADD     TIMOD         IMTIME
     C                   MOVEL     USERID        IMUSER
     C                   UPDATE    RMINVT
      *
     C                   MOVEL     VITEM         IMITEM
     C                   MOVEL     VSIZE         IMSIZE
     C                   MOVEL     VLOC          IMWHSE
     C                   Z-ADD     VQTY          COUNT
     C                   EXSR      UTINVT
      *
     C                   GOTO      RSTRTC
      *
     C     RSTRT         TAG
     C                   EXSR      BLDSFL
     C     NXTSFL        TAG
     C                   EXFMT     RECCTL
     C   KF              GOTO      RSTRTA
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTSFL
     C   KA              DO
     C                   EXSR      PUTSFL
     C*                    GOTO NXTA
     C                   ENDDO
     C  NKA              GOTO      NXTSFL
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
      ***********
      * BLDSFL
      ***********
     C     BLDSFL        BEGSR
     C                   SETOFF                                       1030
     C                   MOVEL     *BLANKS       VITEM            12
     C     VITEM         SETLL     FMINVT
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
      *
     C     NXTBLD        TAG
     C                   SETOFF                                       90
     C                   READ      FMINVT                                 90
     C   90              GOTO      ENDBLD
      *
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXTBLD
     C                   ENDIF
      *
     C     IMLOTC        IFEQ      'Y'
     C                   GOTO      NXTBLD
     C                   ENDIF
      *
     C   01IMCYCD        IFLT      LBCODE                                                      ARC38
     C     IMCYCD        ORGT      LECODE                                                      ARC38
     C                   GOTO      NXTBLD
     C                   ENDIF
      *
     C   02IMWHSE        IFLT      LBLOC                                                       ARC38
     C     IMWHSE        ORGT      LELOC                                                       ARC38
     C                   GOTO      NXTBLD
     C                   ENDIF
      *
     C   03IMLIST        IFLT      LBLIST
     C     IMLIST        ORGT      LELIST
     C                   GOTO      NXTBLD
     C                   ENDIF
      *
     C   04IMPCL1        IFLT      LBPC
     C     IMPCL1        ORGT      LEPC
     C                   GOTO      NXTBLD
     C                   ENDIF
      *
     C                   EXSR      GETDES
     C                   Z-ADD     IMQPHY        PCOUNT
      *
     C                   ADD       1             RECNO
     C     RECNO         IFGT      5000
     C                   GOTO      ENDBLD
     C                   ENDIF
     C                   WRITE     RECSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ENDSR
      *
      ***********
      * CHKSFL
      ***********
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       303199
     C     NXTCHK        TAG
     C                   SETOFF                                       3031
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   ENDIF
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTCHK
      *
     C                   UPDATE    RECSFL
     C                   GOTO      NXTCHK
      *
     C     ENDCHK        TAG
     C                   ENDSR
      ***********
      * PUTSFL
      ***********
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTPUT        TAG
     C                   SETOFF                                       88
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   ENDIF
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTPUT
      *
     C     RECKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
     C     RECKEY        CHAIN     FMINVT                             90
     C                   ADD       COUNT         IMQPHY
     C                   Z-ADD     TDATE         IMDTLA
     C                   Z-ADD     TIMOD         IMTIME
     C                   MOVEL     USERID        IMUSER
     C                   UPDATE    RMINVT
     C                   EXSR      UTINVT
      *
     C                   GOTO      NXTPUT
      *
     C     ENDPUT        ENDSR
      *********
      * GETDES
      *********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             40
     C                   MOVEL     DESCO         DESC             30
     C                   ENDSR
      *
      *********
      * UTINVT
      *********
     C     UTINVT        BEGSR
     C     COUNT         IFEQ      0
     C                   GOTO      NTINVT
     C                   ENDIF
     C                   MOVEL     'A'           ITSTAT
     C                   MOVEL     IMITEM        ITITEM
     C                   MOVEL     IMSIZE        ITSIZE
     C                   MOVEL     IMWHSE        ITTWSE
     C   81              MOVEL     IMPUOM        ITTUOM
     C   82              MOVEL     VUOM          ITTUOM
     C                   Z-ADD     IMCOMP        ITTCOM
     C                   Z-ADD     0             ITFCOM
     C                   MOVEL     'P'           ITTYPE
     C                   MOVEL     'Y'           ITGLUD
     C                   Z-ADD     COUNT         ITTQTY
     C                   MOVEL     MSG(1)        ITDESC
     C                   Z-ADD     TDATE         ITTDAT
     C                   Z-ADD     0             ITTRAN
     C                   Z-ADD     0             ITLBS#
     C                   Z-ADD     0             ITYWGT
     C                   Z-ADD     0             ITVEND
     C                   Z-ADD     0             ITCOST
     C                   Z-ADD     0             ITCOAV
     C                   Z-ADD     0             ITUPC
     C                   Z-ADD     0             ITULC
     C                   Z-ADD     0             ITUIC
     C                   Z-ADD     0             ITORD#
     C                   Z-ADD     0             ITSEQ#
     C                   Z-ADD     TDATE         ITDTLA
     C                   Z-ADD     TIMOD         ITTIME
     C                   MOVEL     USERID        ITUSER
     C                   Z-ADD     TDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ITYDAT
     C                   WRITE     RTINVT
     C     NTINVT        TAG
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
     C                   ENDSR
      *********
      * UOMSR
      *********
     C     UOMSR         BEGSR
     C                   MOVEL     VUNIT         UNCODE            2
     C                   CALL      'LKUOM'
     C                   PARM                    UNCODE
     C                   PARM                    UNDESC           30
     C                   MOVEL     *BLANKS       VUNIT
     C                   MOVEL     UNCODE        VUNIT
     C                   ENDSR
      *
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
**
Physical Inventory Count
