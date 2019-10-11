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
     FNCR220FM  CF   E             WORKSTN
     F                                     SFILE(CRTSFL:RECNO)
     FFCALEN    IF   E           K DISK
     FNCARTCI   IF   E           K DISK
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

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY

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
      ** Make the Date Tommorrow unless it's currently Saturday... then make it Next Monday
     C     TODAY         IFGE      6
     C                   Z-ADD     NXMDY         SHPDAT
     C                   ELSE
     C                   Eval      SHPDAT = $MDYDate($AddDate($Date(0):1))
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
     C*    CL#Y          IFNE      1
     C*                  SETON                                        1012
     C*                  GOTO      NXTA
     C*                  END
     C                   Z-ADD     CLCYMD        SHPCYM            7 0
     C                   SETOFF                                       5556
      ** NOW CHECK CART NUMBER
     C     CARTNO        IFLE      0
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   END
     C     CARTNO        CHAIN     NCARTCI                            20
     C   20              GOTO      NXTA
      ** CHECK IF MORE THAN ONE CART CONTROL
     C                   EXSR      BLDSFL
     C     RECNO         IFLE      2
     C                   Z-ADD     1             LINE01            4 0
     C     LINE01        CHAIN     CRTSFL                             91
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
     C                   CALL      'NCR230CL'
     C                   PARM                    CARTNO
     C                   PARM                    SHPCYM
     C                   PARM                    SMASTER
     C                   PARM                    CONTRL
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
     C     CARTNO        SETLL     NCARTCI
     C     NXTBLD        TAG
     C     CARTNO        READE     NCARTCI                                90
     C   90              GOTO      ENDBLD
     C                   If        CTSHDT <> $Date7($DateMDY(SHPDAT)) or
     C                             CTMSTR <> SMASTER
     C                   GoTo      NXTBLD
     C                   EndIf
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
     C                   ENDSR
