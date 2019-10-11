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
      **PROGRAM NAME-------- SCR250
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- REPRINT CART PUT DOWN SHEET
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FSCR220FM  CF   E             WORKSTN
     F                                     SFILE(CRTSFL:RECNO)
     FFCALEN    IF   E           K DISK
     FFCARTCI   IF   E           K DISK
     FFPLGSCTL  IF   E           K DISK
      *
      *
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
     C     RSTART        TAG
      ** IF WEDNESDAY OR LATER USE NEXT WEEK ELSE USE THIS WEEK
     C     TODAY         IFGE      3
     C                   Z-ADD     NXMDY         SHPDAT
     C                   ELSE
     C                   Z-ADD     CRMDY         SHPDAT
     C                   END
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
     C                   SETOFF                                       5556
      ** NOW CHECK CART NUMBER
     C     CARTNO        IFLE      0
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   END
     C     CARTKEY       CHAIN     FCARTCI                            20
     C   20              GOTO      NXTA
      ** CHECK IF MORE THAN ONE CART CONTROL
     C                   EXSR      BLDSFL
     C     RECNO         IFLE      2
     C                   GOTO      ONECRT
     C                   END
      ** MORE THAN 1 SELECT WHICH
     C     NXTFMT        TAG
     C                   EXFMT     CRTCTL
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG  DO
     C     LINE          IFLE      LSTREC
     C     LINE          CHAIN     CRTSFL                             91
     C   91              GOTO      NXTFMT
     C                   GOTO      ONECRT
     C                   END
     C                   GOTO      NXTFMT
     C     ONECRT        TAG
     C                   Z-ADD     CTCNTL        CONTRL            6 0
     C                   CALL      'SCR230CL'
     C                   PARM                    CARTNO
     C                   PARM                    SHPCYM
     C                   PARM                    SMASTER
     C                   PARM                    CONTRL
     C                   PARM      ' '           MODE              1
     C**                   GOTO RSTART
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD CART SUBFILE *
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     CRTCTL
     C                   SETOFF                                       8055
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             OCNTL             6 0
     C     CARTKEY       KLIST
     C                   KFld                    SHPCYM
     C                   KFld                    SMASTER
     C                   KFld                    CARTNO
     C     CARTKEY       SETLL     FCARTCI
     C     NXTBLD        TAG
     C     CARTKEY       READE     FCARTCI                                90
     C   90              GOTO      ENDBLD
     C     CTCNTL        IFNE      OCNTL
     C                   ADD       1             RECNO
     C                   WRITE     CRTSFL
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   Z-ADD     CTCNTL        OCNTL
     C                   END
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   SETON                                        55
     C                   ADD       1             RECNO
     C                   WRITE     CRTSFL
     C                   SETOFF                                       55
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
