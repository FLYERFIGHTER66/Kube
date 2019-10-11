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
     FFIOROY    IF   E           K DISK
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    ORCOMP
     C                   PARM                    ORORD#
     C                   PARM                    ORSEQ#
     C                   PARM                    QTYOPN           11 1
     C                   PARM                    DESC             60
     C                   PARM                    ORUPRI
     C                   PARM                    OREXT$
      ** CHECK FOR END PROGRAM
     C     ORORD#        IFEQ      999999
     C     ORSEQ#        ANDEQ     999
     C                   GOTO      ENDLR
     C                   END
      ********
     C                   MOVE      *BLANKS       DESC
     C                   Z-ADD     0             ORUPRI
     C                   Z-ADD     0             OREXT$
     C     ROYKEY        KLIST
     C                   KFLD                    ORORD#
     C                   KFLD                    ORSEQ#
     C     ROYKEY        CHAIN     FIOROY                             95
     C   95              GOTO      END
      ** GET OPEN AMOUNT ROYALTY DUE
     C                   MOVEL     *BLANKS       DESCO            60
     C*                    MOVEL'I'       TYPE    1
     C*                    MOVE *BLANKS   IMWHSE  3
     C*                    CALL 'GETDESC'
     C*                    PARM           ORITEM
     C*                    PARM           ORSIZE
     C*                    PARM           IMWHSE
     C*                    PARM           TYPE
     C*                    PARM           DESCO
     C*                    MOVELDESCO     DESC
     C                   MOVEL     ORDES1        DESC
      ** QTYOPN IS THE QTY WE ARE  CALC EXT AMT FOR
     C     QTYOPN        MULT(H)   ORUPRI        OREXT$
     C     END           TAG
     C                   MOVEA     '0'           *IN
     C                   RETURN
      *** END PROGRAM
     C     ENDLR         TAG
     C                   SETON                                        LR
