      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1997
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
      **PROGRAM NAME-------- GETROY
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS DISTRIBUTION.
      **PROGRAMMER---------- EFD
      **APPLICATION--------- GET ROYALTY AMOUNT ETC.
      *                      (THIS IS A CALLED PROGRAM)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  2/09/98 EFD ADD LOGIC FOR RETRN/LR
      *
     FFMINVT    IF   E           K DISK
     FFIOROY    UF A E           K DISK
     FFMSIZE    IF   E           K DISK
     FFMVEND    IF   E           K DISK
      **
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    ORCOMP
     C                   PARM                    ORORD#
     C                   PARM                    ORSEQ#
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    QTYORD           11 1
     C                   PARM                    QTYSHP           11 1
     C                   PARM                    DESC             60
     C                   PARM                    ORUPRI
     C                   PARM                    OREXT$
      ** CHECK FOR END PROGRAM
     C     IMITEM        IFEQ      '99999999'
     C     IMSIZE        ANDEQ     '999'
     C                   GOTO      ENDLR
     C                   END
      ********
     C                   MOVE      *BLANKS       DESC
     C                   Z-ADD     0             ORUPRI
     C                   Z-ADD     0             OREXT$
      ** CHECK IF WE NEED ROYALTY
     C     MINKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
     C     MINKEY        CHAIN     FMINVT                             96
     C  N96IMROYL        IFEQ      0
     C     IMVEND        OREQ      0
     C                   SETON                                        96
     C                   ENDIF
     C                   MOVE      IMROYL        WK44              5 4
     C                   MOVE      ' /Cell'      WK10             10
     C                   MOVEL     WK44          WK10
     C                   MOVEL     '.'           WK10
      ** 96 NO ROTALTY NEEDED
     C     ROYKEY        KLIST
     C                   KFLD                    ORORD#
     C                   KFLD                    ORSEQ#
     C     ROYKEY        CHAIN     FIOROY                             95
     C   96
     CANN95              Z-ADD     0             ORUPRI
     C   96
     CANN95              Z-ADD     0             OREXT$
     C   96
     CANN95              MOVE      *BLANKS       ORDES1
     C   96
     CANN95              DELETE    RIOROY
     C   96              GOTO      END
     C     IMSIZE        CHAIN     FMSIZE                             96
     C   96              GOTO      END
     C     IMROYL        MULT(H)   SZSALE        ORUPRI
      ** IF HERE WE NEED ROYALTY
     C                   MOVE      *BLANKS       ROYITM
     C     MINROY        KLIST
     C                   KFLD                    ROYITM
     C                   KFLD                    ROYSIZ
     C                   MOVEL     IMVEND        ROYITM           12
     C                   MOVE      'ROY'         ROYSIZ            3
     C                   MOVEL     IMVEND        ORITEM
     C     MINROY        CHAIN     FMINVT                             97
     C   97              DO
     C     IMVEND        CHAIN     FMVEND                             98
     C                   MOVEL     VMNAME        NAM20            20
     C                   MOVEL     MSG(1)        ORDES1
     C                   MOVE      NAM20         ORDES1
     C                   MOVEL     ORDES1        DESC
     C                   ENDDO
     C  N97              DO
     C*                    MOVEL*BLANKS   DESCO  60
     C*                    MOVEL'I'       TYPE    1
     C*                    CALL 'GETDESC'
     C*                    PARM           IMITEM
     C*                    PARM           IMSIZE
     C*                    PARM           IMWHSE
     C*                    PARM           TYPE
     C*                    PARM           DESCO
     C*                    MOVELDESCO     DESC
     C                   MOVEL     IMDES1        WK19             19
     C                   MOVE      WK19          DESC30           30
     C                   MOVEL     WK10          DESC30
     C                   MOVEL     DESC30        DESC
     C                   MOVEL     DESC          ORDES1
     C                   ENDDO
     C                   MOVEL     'ROY'         ORSIZE
     C                   MOVE      'A'           ORSTAT
     C     QTYORD        SUB       QTYSHP        OPEN             11 1
     C     OPEN          MULT(H)   ORUPRI        OREXT$
     C                   Z-ADD     QTYORD        ORQORD
     C                   Z-ADD     QTYSHP        ORQSHP
     C   95              WRITE     RIOROY
     C  N95              UPDATE    RIOROY
     C     END           TAG
     C                   MOVEA     '0'           *IN
     C                   UNLOCK    FIOROY
     C                   RETURN
      *** END PROGRAM
     C     ENDLR         TAG
     C                   SETON                                        LR
**
Royalty -
