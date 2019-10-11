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
      **PROGRAM NAME-------- SCR400
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- INQUIRY INTO UNFILLED ORDERS FROM CART
      *                      SCANNERS.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/28/02 ADD LOGIC FOR START SUBFILE AT SELECTED ITEM
      *
     FSCR400FM  CF   E             WORKSTN
     F                                     SFILE(ITMSFL:RECNO)
     F                                     SFILE(ORDSFL:RECN1)
     FFCALEN    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFPUTORDS  IF   E           K DISK
     FFPUTORDI  IF   E           K DISK
     F                                     RENAME(RPUTORD:PUTORD)
     FFPLGSCTL  IF   E           K DISK
      *
      * message array
     D MSG             S             30    DIM(2) CTDATA PERRCD(1)              MESSAGES
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
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
      ***********************
      ** START HERE        **
      ***********************
     C                   MOVEL     'O'           OPNALL
     C     RSTART        TAG
      ** IF THURSDAY OR LATER USE NEXT WEEK ELSE USE THIS WEEK
     C*    TODAY         IFGE      4
     C*                  Z-ADD     NXMDY         SHPDAT
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
     C                   SETOFF                                       2324
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
      ***********************
      ** DISPLAY ITEM SFL  **
      ***********************
     C     RSTRSF        TAG
     C                   EXSR      BLDSFL
     C     NXTSFL        TAG
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
     C     LINE          IFLT      1
     C     LINE          ORGT      LSTREC
     C                   GOTO      NXTSFL
     C                   END
     C     LINE          CHAIN     ITMSFL                             90
     C   90              GOTO      NXTSFL
     C                   Z-ADD     LINE          PAGE#
     C                   EXSR      ORDER
     C                   GOTO      RSTRSF
     C                   ENDDO
     C     VITEM         IFGT      *BLANKS
     C     ITMKY1        CHAIN     FMINVT                             30
     C   30              GOTO      NXTSFL
     C                   END
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
     C                   MOVE      *BLANKS       IMITEM
     C     SHPCYM        SETLL     FPUTORDS
     C     NXTBLD        TAG
     C     SHIPKEY       KLIST
     C                   KFld                    SHPCYM
     C                   KFld                    SMASTER
     C     SHIPKEY       READE     FPUTORDS                               90
     C   90              GOTO      ENDBLD
     C     PDITEM        IFNE      IMITEM
     C     IMITEM        IFGT      *BLANKS
     C     QTYORD        SUB       QTYREC        NEED
     C     NEED          IFNE      0
     C     OPNALL        OREQ      'A'
     C                   ADD       1             RECNO
     C                   WRITE     ITMSFL
     C                   END                                                    NEED><0
     C                   END                                                    IMITEM>' '
     C                   Z-ADD     0             QTYORD
     C                   Z-ADD     0             QTYREC
     C     ITMKEY        KLIST
     C                   KFLD                    PDITEM
     C                   KFLD                    PDSIZE
     C     ITMKEY        CHAIN     FMINVT                             91
     C                   MOVEL     IMITEM        ITEM
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
     C                   ADD       PDQSCH        QTYREC
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C     IMITEM        IFGT      *BLANKS
     C     QTYORD        SUB       QTYREC        NEED
     C     NEED          IFNE      0
     C                   ADD       1             RECNO
     C                   WRITE     ITMSFL
     C                   END                                                    NEED><0
     C                   END                                                    IMITEM>' '
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
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C     PITMKY        SETLL     FPUTORDI
     C     NXTORD        TAG
     C     PITMKY        READE     FPUTORDI                               90
     C   90              GOTO      ENDORD
     C     PDORD#        CHAIN     FHORDR                             90
     C                   Z-ADD     PDQORD        QTYORD
     C                   Z-ADD     PDQSCH        QTYREC
     C     QTYORD        SUB       QTYREC        NEED
     C                   ADD       1             RECN1
     C                   WRITE     ORDSFL
     C                   ADD       QTYORD        TOTORD
     C                   ADD       QTYREC        TOTREC
     C                   ADD       NEED          TOTNED
     C                   Z-ADD     0             QTYORD
     C                   Z-ADD     0             QTYREC
     C                   GOTO      NXTORD
     C     ENDORD        TAG
     C                   Z-ADD     TOTORD        QTYORD
     C                   Z-ADD     TOTREC        QTYREC
     C                   Z-ADD     TOTNED        NEED
     C                   Z-ADD     0             PDORD#
     C                   MOVE      *BLANKS       PDLOC
     C                   MOVE      *BLANKS       PDSTA
     C                   MOVE      *BLANKS       PDBORD
     C                   MOVE      *BLANKS       OHNAME
     C                   MOVEL     MSG(2)        OHNAME
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
