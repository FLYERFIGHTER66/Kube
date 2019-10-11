    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- SCR410
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- INQUIRY INTO UNFILLED ORDERS FROM CART
      *                      SCANNERS AND PRINT SHEETS.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/28/02 ADD LOGIC FOR START SUBFILE AT SELECTED ITEM
      *  4/05/02 ADD CHANGE UPDATE TO PRINTED TO SCR401P.
      *  2/28/03 ADDED CONTROL NUMBER TO SCREEN FOR DEE.  CAB
      *
     FSCR410FM  CF   E             WORKSTN
     F                                     SFILE(ITMSFL:RECNO)
     F                                     SFILE(ORDSFL:RECN1)
     FFCALEN    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFPTORDC   UF   E           K DISK
     FFPUTORDS  IF   E           K DISK
     FFPUTORDI  IF   E           K DISK
     F                                     RENAME(RPUTORD:PUTORD)
     FFCARTCR   IF   E           K DISK
     FFPLGSCTL  IF   E           K DISK
      *
      * message array
CAB  D**                  MSG     1   2 30               MESSAGES
     D MSG             S             25    DIM(2) CTDATA PERRCD(1)              MESSAGES
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
     D  CRMDY                  1      6  0                                      ARC380
     D  CRCYMD                 7     13  0                                      ARC380
     D  CRYEAR                14     17  0                                      ARC380
     D  CRWEEK                18     19  0                                      ARC380
     D  NXMDY                 20     25  0                                      ARC380
     D  NXCYMD                26     32  0                                      ARC380
     D  NXYEAR                33     36  0                                      ARC380
     D  NXWEEK                37     38  0                                      ARC380
     D  LCANCL               133    133                                         ARC380

     D  PDITEM#        S                   Like(PDITEM)
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DftPrt
    ?D/COPY QFunctDefn,$ChgPrt

     C****
     C     CRTKEY        KLIST
     C                   KFLD                    CTSHDT
     C                   KFLD                    CTMAST
     C                   KFLD                    CTITEM
     C                   KFLD                    CTSIZE
     C                   KFLD                    CTORD#
      ***********************
      ** START HERE        **
      ***********************
     C                   MOVEL     'O'           OPNALL
     C                   MOVEL     'N'           SCHONL
     C     RSTART        TAG
     C                   UNLOCK    FPTORDC
      ** IF THURSDAY OR LATER USE NEXT WEEK ELSE USE THIS WEEK
     C*    TODAY         IFGE      4
CAB  C*                  Z-ADD     NXMDY         SHPDAT
CAB  C**                   Z-ADD030303    SHPDAT
     C*                  ELSE
     C*                  Z-ADD     CRMDY         SHPDAT
     C*                  END
      ** WRITE SCRNA
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG  DO
      ** CHECK INPUT
     C                   SETOFF                                       101112
     C                   SETOFF                                       202122
     C                   SETOFF                                       232425
     C                   SETOFF                                       3035
     C     SHPDAT        IFLE      0
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   END
     C     SHPDAT        CHAIN     FCALEN                             10
     C   10              DO
     C                   SETON                                        11
     C                   GOTO      NXTA
     C                   ENDDO                                                  10  DO
     C     CL#Y          IFNE      1
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     CLCYMD        SHPCYM            7 0
      ** CHECK ITEM
     C     VITEM         IFGT      *BLANKS
     C     1             SUBST     VITEM:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     VITEM:2       IMLOOK
     C                   MOVEL     VSIZE         IMSIZE
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
     C                   GOTO      NXTA
     C                   ENDIF
     C     ITMKY1        KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C     ITMKY1        CHAIN     FMINVT                             30
     C   30              GOTO      NXTA
     C                   END                                                    ITEM>' '
      *CHECK SIZE CODE
     C     VSIZE         IFGT      *BLANKS
     C     1             SUBST     VSIZE:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       VSIZE
     C                   MOVEL     SZCODE        VSIZE
     C                   GOTO      NXTA
     C                   ENDIF
     C     VSIZE         CHAIN     FMSIZE                             35
     C   35              GOTO      NXTA
     C                   END
      ** CHECK OPEN/ALL
     C     OPNALL        IFNE      'O'
     C     OPNALL        ANDNE     'A'
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   END
      ** CHECK SCHEDULED Y/N
     C     SCHONL        IFNE      'Y'
     C     SCHONL        ANDNE     'N'
     C                   SETON                                        25
     C                   GOTO      NXTA
     C                   END
      ***********************
      ** DISPLAY ITEM SFL  **
      ***********************
     C     RSTRSF        TAG
      *
     C                   If        Printer = *Blanks
     C                   Eval      Printer = $DftPrt(UserID:PROGID:'*PGM')
     C                   EndIf
      *
     C                   Eval      PAGE# = *Zero
     C                   EXSR      BLDSFL
     C     NXTSFL        TAG
     C     PAGE#         IFEQ      *ZERO
     C                   Z-ADD     LINE1         PAGE#
     C                   EndIf
     C     PAGE#         IFLE      0
     C     PAGE#         ORGT      LSTREC
     C                   Z-ADD     1             PAGE#
     C                   END
     C                   EXFMT     ITMCTL
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG  DO
      ** SEE IF ORDER DETAIL WANTED
     C   KA              DO
     C     LINE1         IFLT      1
     C     LINE1         ORGT      LSTREC
     C                   GOTO      NXTSFL
     C                   END
     C     LINE1         CHAIN     ITMSFL                             90
     C   90              GOTO      NXTSFL
     C                   Z-ADD     LINE1         PAGE#
     C                   EXSR      ORDER
     C                   GOTO      RSTRSF
     C                   ENDDO
     C     VITEM         IFGT      *BLANKS
     C     ITMKY1        CHAIN     FMINVT                             30
     C   30              GOTO      NXTSFL
     C                   END
      *
     C                   If        *InKL
     C                   Eval      Printer = $ChgPrt(UserID:PROGID:Printer)
     C                   ENDIF
      *
      ** CHECK IF NEW DUE REPORT WANTED
     C     *INKK         IfEq      *On
     C                   If        PRINT_LOCS = 'N'
     C*                  CALL      'PSR200'
     C                   CALL      'PSR200CL'
     C                   PARM                    SHPCYM
     C                   PARM                    SMASTER
     C                   PARM                    Include_RB
     C                   PARM                    PRINTER
     C                   Else
     C*                  CALL      'PSR201'
     C                   CALL      'PSR201CL'
     C                   PARM                    SHPCYM
     C                   PARM                    Include_RB
     C                   PARM                    PRINTER
     C                   EndIf
     C                   END

      *
      ** CHECK IF ANY CHANGES
     C                   EXSR      CHKSFL
     C                   GOTO      RSTRSF
      ** HARD RETURN
     C                   GOTO      RSTRSF
      ** END
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD ITEM SUBFILE *
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     ITMCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             RECSIZ            5 0
     C                   Z-ADD     0             RECITM            5 0
     C                   Z-ADD     0             PAGE#
     C                   Z-ADD     0             QTYORDT
     C                   Z-ADD     0             QTYRECT
     C                   Z-ADD     0             NEEDT
     C                   MOVE      *BLANKS       IMITEM
     C                   MOVE      *BLANKS       PRINT
     C                   MOVE      *BLANKS       DISP
     C     SHPKEY        KList
     C                   KFld                    SHPCYM
     C                   KFld                    SMASTER
     C     SHPKEY        SETLL     FPUTORDS
     C     NXTBLD        TAG
     C     SHPKEY        READE     FPUTORDS                               90
     C   90              GOTO      ENDBLD
1    C     PDITEM        IFNE      IMITEM_Old
|2   C     IMITEM        IFGT      *BLANKS
||3  C     PTDISP        IFEQ      'N'
|||  C     SCHONL        OREQ      'Y'
|||  C     QTYREC        ANDEQ     0
|||  C                   GOTO      N1
||E  C                   END
||   C     QTYORD        SUB       QTYREC        NEED
||3  C     NEED          IFGT      0
|||  C     OPNALL        OREQ      'A'
|||  C                   ADD       1             RECNO
|||  C                   WRITE     ITMSFL
||E  C                   END                                                    NEED><0
 E   C                   END                                                    IMITEM>' '
     C     N1            TAG
     C                   Z-ADD     0             QTYORD
     C                   Z-ADD     0             QTYREC
     C     ITMKEY        KLIST
     C                   KFLD                    PDITEM#
     C                   KFLD                    PDSIZE
     C                   Eval      PDITEM# = %SUBST(PDITEM:1:11)
     C     ITMKEY        CHAIN     FMINVT                             91
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     PDITEM        IMITEM_Old       12
     C                   If        %SUBST(PDITEM:12:1) = 'P'
     C                   Eval      P = 'P'
     C                   Else
     C                   Eval      P = *Blanks
     C                   EndIf
      ** GET PTORDC
     C     PITMKY2       CHAIN(N)  FPTORDC                            90
     C     PITMKY2       KLIST
     C                   KFLD                    SHPCYM
     C                   KFLD                    PDMAST
     C                   KFLD                    PDITEM
     C                   KFLD                    PDSIZE
     C                   END                                                    PDITEM><IMIT
      ** SEE IF WE NEED PAGE#
     C     VSIZE         IFGT      *BLANKS
     C     RECSIZ        ANDLE     0
     C     PDSIZE        ANDEQ     VSIZE
     C     RECNO         ADD       1             RECSIZ
     C                   END
     C     VITEM         IFGT      *BLANKS
     C     VSIZE         ANDEQ     PDSIZE
     C     VITEM         ANDEQ     PDITEM
     C     RECNO         ADD       1             RECITM
     C                   END
     C                   ADD       PDQORD        QTYORD
     C                   ADD       PDQORD        QTYORDT
     C                   ADD       PDQSCH        QTYREC
     C                   ADD       PDQSCH        QTYRECT
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C     PTDISP        IFEQ      'N'
     C     SCHONL        OREQ      'Y'
     C     QTYREC        ANDEQ     0
     C                   GOTO      N2
     C                   END
     C     IMITEM        IFGT      *BLANKS
     C     QTYORD        SUB       QTYREC        NEED
     C     NEED          IFGT      0
     C                   ADD       1             RECNO
     C                   WRITE     ITMSFL
     C                   END                                                    NEED><0
     C                   END                                                    IMITEM>' '
     C     N2            TAG
     C                   Z-ADD     0             QTYORD
     C                   Z-ADD     0             QTYREC
     C                   Z-ADD     0             NEED
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       IMSIZE
     C                   MOVE      *BLANKS       IMDES1
     C                   MOVEL     MSG(1)        IMDES1
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   WRITE     ITMSFL
     C     RECITM        IFGT      0
     C                   Z-ADD     RECITM        PAGE#
     C                   ELSE
     C     RECSIZ        IFGT      0
     C                   Z-ADD     RECSIZ        PAGE#
     C                   END
     C                   END
     C     QTYORDT       SUB       QTYRECT       NEEDT
     C                   ENDSR
      ***********************
      ** CHECK ITEM SFILE  **
      ***********************
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     ITMSFL                             90
     C   90              GOTO      NXTCHK
      ** CHECK FOR NO DISPLAY
     C     DISP          IFEQ      'N'
     C     PITMKY        CHAIN     FPTORDC                            91
     C                   MOVEL     'N'           PTDISP
     C  N91              UPDATE    RPTORDC
     C                   END
      ** CHECK FOR PRINT
     C     PRINT         IFEQ      'P'
     C     *INKD         OREQ      '1'
     C     PITMKY        CHAIN(N)  FPTORDC                            91
     C**                   MOVEL'Y'       PTPRTD
     C**N91                UPDATRPTORDC
     C                   CALL      'SCR410CL'
     C                   PARM                    SHPCYM
     C                   PARM                    SMASTER
     C                   PARM                    IMITEM_Old
     C                   PARM                    IMSIZE
     C                   PARM                    PRINT_RB
     C                   PARM                    PRINTER
     C                   END
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C                   UNLOCK    FPTORDC
     C                   ENDSR
      ***********************
      ** DISPLAY ORDER SFL **
      ***********************
     C     ORDER         BEGSR
     C                   SETON                                        80
     C                   WRITE     ORDCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECN1             5 0
     C                   Z-ADD     0             TOTORD            6 0
     C                   Z-ADD     0             TOTREC            6 0
     C                   Z-ADD     0             TOTNED            6 0
     C                   MOVEL     IMITEM        ITEM
     C     MINKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C     MINKEY        CHAIN     FMINVT                             90
     C     PITMKY        KLIST
     C                   KFLD                    SHPCYM
     C                   KFLD                    SMASTER
     C                   KFLD                    IMITEM_OLD
     C                   KFLD                    IMSIZE
     C     PITMKY        SETLL     FPUTORDI
     C     NXTORD        TAG
     C     PITMKY        READE     FPUTORDI                               90
     C   90              GOTO      ENDORD
     C     PDORD#        CHAIN     FHORDR                             90
     C                   Z-ADD     PDQORD        QTYORD
     C                   Z-ADD     PDQSCH        QTYREC
CAB  C                   MOVEL     OHNAME        NAME
      ** GET PTORDC
CAB  C                   Z-ADD     0             CNTL#             6 0
CAB  C                   MOVE      SHPCYM        CTSHDT
CAB  C                   MOVE      PDITEM        CTITEM
CAB  C                   MOVE      PDSIZE        CTSIZE
CAB  C                   Z-ADD     PDORD#        CTORD#
CAB  C     CRTKEY        CHAIN     FCARTCR                            90
     C**
CAB  C                   MOVEL     CTCNTL        CNTL#
     C**
     C     QTYORD        SUB       QTYREC        NEED
     C                   ADD       1             RECN1
     C                   WRITE     ORDSFL
     C                   ADD       QTYORD        TOTORD
     C                   ADD       QTYREC        TOTREC
     C                   If        Need > 0
     C                   ADD       NEED          TOTNED
     C                   EndIf
     C                   Z-ADD     0             QTYORD
     C                   Z-ADD     0             QTYREC
     C                   GOTO      NXTORD
     C     ENDORD        TAG
     C                   Z-ADD     TOTORD        QTYORD
     C                   Z-ADD     TOTREC        QTYREC
     C                   Z-ADD     TOTNED        NEED
     C                   Z-ADD     0             PDORD#
C0B  C                   Z-ADD     0             CNTL#             6 0
     C                   MOVE      *BLANKS       PDLOC
     C                   MOVE      *BLANKS       PDSTA
     C                   MOVE      *BLANKS       PDBORD
CAB  C**                   MOVE *BLANKS   OHNAME
CAB  C                   MOVE      *BLANKS       NAME
CAB  C**                   MOVELMSG,2     OHNAME
CAB  C                   MOVEL     MSG(2)        NAME             24
     C                   ADD       2             RECN1
     C                   WRITE     ORDSFL
     C                   EXFMT     ORDCTL
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     TDATE         CHAIN     FCALEN                             90
     C                   Z-ADD     CL#Y          TODAY             1 0
     C                   MOVE      *BLANKS       LCANCL
      /Free

         Chain (0) FPLGSCTL;
         If %Found(FPLGSCTL);
           SHPDAT = $MDYDate($Date(PSFILD));
           SMASTER = PSFILM;
         ENDIF;

      /End-Free
     C                   ENDSR
** MESSAGE
End of Items ********                     1
End of Orders *******                     2
