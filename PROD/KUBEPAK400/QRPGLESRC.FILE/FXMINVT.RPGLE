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
      *PROGRAM NAME-------- FXMINVT
      *SYSTEM-------------- INVENTORY
      *APPLICATION--------- FIX MINVT - CHANGE FOR EACH FIX
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMINVT    UF   E           K DISK
     FFMINVTI   IF   F  900    18AIDISK    KEYLOC(2)
      ** MINVT ARRAYS
     D IGB             S              4  0 DIM(4)                               BEG WKS GERM 4
     D IGE             S              4  0 DIM(4)                               END WKS GERM 4
     D IGW             S              2  0 DIM(4)                               # OF WKS GERM
     IRMINVT
     I              IMBD1                       IGB(1)
     I              IMBD2                       IGB(2)
     I              IMBD3                       IGB(3)
     I              IMBD4                       IGB(4)
     I              IMED1                       IGE(1)
     I              IMED2                       IGE(2)
     I              IMED3                       IGE(3)
     I              IMED4                       IGE(4)
     I              IMWG1                       IGW(1)
     I              IMWG2                       IGW(2)
     I              IMWG3                       IGW(3)
     I              IMWG4                       IGW(4)
     I* GET NEEDED FIELDS FROM MINVT
     IFMINVTI   AA
     I                                655  684  VITM
      *
      ** GET NEXT RECORD
     C     NXT           TAG
     C                   READ      FMINVT                                 90
     C   90              GOTO      END
     C     IMSIZE        IFNE      'CUT'
     C                   GOTO      NXT
     C                   END
     C                   MOVEL     'P'           IMSTAT
     C                   MOVEL     IMITEM        KEY15            15
     C                   MOVE      '105'         KEY15
     C                   MOVE      IMWHSE        KEY18            18
     C                   MOVEL     KEY15         KEY18
     C     KEY18         CHAIN     FMINVTI                            91
     C   91              GOTO      NXT
     C                   MOVEL     VITM          IMVITM
     C                   UPDATE    RMINVT
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
