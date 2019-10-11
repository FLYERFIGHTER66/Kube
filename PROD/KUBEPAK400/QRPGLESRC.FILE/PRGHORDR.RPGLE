    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

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
      **PROGRAM NAME-------- PRGHORDR
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **DESCRIPTION--------- THIS PROGRAM CHECKS IF HORDR OR IORDR
      **                     RECORDS SHOULD BE MARKED AS CLOSED.       S
      **
      *            **     PROGRAM CHANGE LOG    **
      *
      *
     FFIORDR    UF   E           K DISK
     FFHORDR    UF   E           K DISK
     FFHORDRHISTO  A E           K DISK
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$TimeStamp

      ****************
      *   LDA        *
      ****************
      *
      * GET FIORDR
      *
     C     NXT           TAG
     C                   READ      FIORDR                                 90
     C   90              GOTO      NXTH1
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      * IF NO HEADER DELETE
     C     OIORD#        CHAIN     FHORDR                             91
     C   91              DELETE    RIORDR
     C                   GOTO      NXT
      *
      *
      *
      * GET FHORDR
      *
     C     NXTH1         TAG
     C                   Z-ADD     0             OHORD#
     C     OHORD#        SETLL     FHORDR
     C     NXTH          TAG
     C                   READ      FHORDR                                 90
     C   90              GOTO      END
      * IF NO DETAIL DELETE
     C     OHORD#        CHAIN     FIORDR                             91
     C   91              DELETE    RHORDR
     C                   Eval      HSTUSER    = $User()
     C                   Eval      HSTPROGRAM = 'PRGORDR_D'
     C                   Eval      HSTTIME    = $Timestamp()
     C   91              Write     RHORDRHIST
     C   91              GOTO      NXTH
      *
     C     OHSTAT        IFEQ      'D'
     C                   GOTO      NXTH
     C                   ENDIF
      ** SEE IF ANY OPEN NON COMMENT RECORDS
     C     OHORD#        SETLL     FIORDR
     C                   Z-ADD     0             OPEN              5 0
     C                   Z-ADD     0             OPENC             5 0
     C     NXTCHK        TAG
     C     OHORD#        READE     FIORDR                                 92
     C   92              GOTO      ENDCHK
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXTCHK
     C                   END
     C                   ADD       1             OPEN
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
      * IF NOTHING OPEN CLOSE ORDER
     C     OPEN          IFEQ      0
     C                   MOVEL     'D'           OHSTAT
     C                   MOVEL     'Y'           OHCOFL
     C                   UPDATE    RHORDR
     C                   Eval      HSTUSER    = $User()
     C                   Eval      HSTPROGRAM = 'PRGHORDR_U'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
     C                   END
      *
     C                   GOTO      NXTH
      *
     C     END           TAG
     C                   SETON                                        LR
      *
