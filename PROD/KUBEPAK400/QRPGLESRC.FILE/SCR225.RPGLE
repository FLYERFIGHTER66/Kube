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
      **PROGRAM NAME-------- SCR225
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CALCEL CART PUT DOWN SHEET
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  4/04/02 EFD DO NOT USE SHIP DATE AS PART OF PUTORD KEY.
      *
     FSCR225FM  CF   E             WORKSTN
     F                                     SFILE(CRTSFL:RECNO)
     F                                     SFILE(TRYSFL:RECN1)
     FFCALEN    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCARTCI   IF   E           K DISK
     F                                     RENAME(RCART:CARTI)
     FFCARTCC   UF   E           K DISK
     FFPUTORD   UF   E           K DISK
     FFPLGSCTL  IF   E           K DISK
     FFTRAY     IF   E           K DISK
     FFTRAYPS   UF   E           K DISK    PREFIX(PS_)
     FFTRAYTRN  O    E           K DISK
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)              MESSAGE
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
     D  PROGID                 1     10                                         PROGRAM NAME
     D  RLIBR                 81     90                                         RUN LIBRARY
     D  USERID               254    263                                         USER I.D.
     D  SLIBR                314    323                                         SOURCE LIBRARY
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

     D  CTITEMKey      S                   LIKE(CTITEM)
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Timestamp

      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
      ** IF WEDNESDAY OR LATER USE NEXT WEEK ELSE USE THIS WEEK
     C*    TODAY         IFGE      3
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
     C     CARTKEY       KLIST
     C                   KFld                    SHPCYM
     C                   KFld                    SMASTER
     C                   KFld                    CARTNO
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
      ** DISPLAY TRAYS AND FLAG DELETES
     C                   EXSR      BLDTRY
     C     NXTFM2        TAG
     C                   EXFMT     TRYCTL
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG  DO
     C   KJ              DO
     C                   EXSR      CANALL
     C                   GOTO      RSTART
     C                   ENDDO
      ** CHECK IF ANY DELETED
     C                   EXSR      CHKTRY
     C   25              GOTO      NXTFM2
     C                   GOTO      RSTART
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
      ** BUILD TRAY SUBFILE *
      ***********************
     C     BLDTRY        BEGSR
     C                   SETON                                        80
     C                   WRITE     TRYCTL
     C                   SETOFF                                       8055
     C                   Z-ADD     0             RECN1             5 0
     C                   Z-ADD     CTCNTL        CONTRL            6 0
     C     CRTKEY2       KLIST
     C                   KFld                    SHPCYM
     C                   KFld                    SMASTER
     C                   KFLD                    CARTNO
     C                   KFLD                    CONTRL
     C     CRTKEY2       SETLL     FCARTCC
     C     NXTTRY        TAG
     C     CRTKEY2       READE     FCARTCC                                90
     C   90              GOTO      ENDTRY
     C     CTSTAT        IFEQ      'D'
     C                   GOTO      NXTTRY
     C                   END
WJB  C                   If        %SUBST(CTITEM:12:1) = 'P'
WJB  C                   Eval      CTITEMKey = %SUBST(CTITEM:1:11) + ' '
WJB  C                   Else
WJB  C                   Eval      CTITEMKey = CTITEM
WJB  C                   EndIf
     C                   MOVE      *BLANKS       CODE
     C     ITMKEY        KLIST
WJB  C*                  KFLD                    CTITEM
WJB  C                   KFLD                    CTITEMKey
     C                   KFLD                    CTSIZE
     C     ITMKEY        CHAIN     FMINVT                             91
     C                   ADD       1             RECN1
     C                   WRITE     TRYSFL
     C                   Z-ADD     RECN1         LSTRC1            5 0
     C                   GOTO      NXTTRY
     C     ENDTRY        TAG
     C                   SETON                                        55
     C                   MOVEL     MSG(1)        IMDES1
     C                   ADD       1             RECN1
     C                   WRITE     TRYSFL
     C                   SETOFF                                       55
     C                   ENDSR
      ***********************
      * CHECK TRAY SUBFILE **
      ***********************
     C     CHKTRY        BEGSR
     C                   Z-ADD     0             RECN1             5 0
     C                   SETON                                        25
     C     NXTCHK        TAG
     C                   ADD       1             RECN1
     C     RECN1         IFGT      LSTRC1
     C                   GOTO      ENDCHK
     C                   END
     C     RECN1         CHAIN     TRYSFL                             90
     C   90              GOTO      NXTCHK
     C     CODE          IFNE      'D'
     C                   GOTO      NXTCHK
     C                   END
      ** IF HERE A RECORD TO DELETE
     C                   SETOFF                                       25
     C     CRTKY1        KLIST
     C                   KFld                    SHPCYM
     C                   KFld                    SMASTER
     C                   KFLD                    CARTNO
     C                   KFLD                    CONTRL
     C                   KFLD                    CTITEM
     C                   KFLD                    CTSIZE
     C                   KFLD                    CTCSEQ
     C     CRTKY1        CHAIN     FCARTCC                            60
     C                   Z-add     CTSEQ#        CTSEQ#5           5 0
     C     PUTKEY        CHAIN     FPUTORD                            61
     C                   Z-ADD     0             CTORD#
     C                   Z-ADD     0             CTSEQ#
     C                   MOVEL     'D'           CTSTAT
     C                   MOVE      *BLANKS       CTLOC
     C                   MOVE      *BLANKS       CTSTA
     C                   MOVE      *BLANKS       CTLOTC
     C  N60              UPDATE    RCART
     C     PUTKEY        KLIST
     C                   KFLD                    CTORD#
     C*                  KFLD                    CTSEQ#
     C                   KFLD                    CTSEQ#5
     C                   KFld                    SHPCYM
     C                   KFld                    SMASTER
     C***                  KFLD           CTSHDT
     C                   SUB       1             PDQSCH
     C     PDQSCH        IFLT      0
     C                   Z-ADD     0             PDQSCH
     C                   END
     C  N61              UPDATE    RPUTORD
     C                   ExSr      CanTag
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C                   ENDSR
      ***********************
      * CANCEL ALL         **
      ***********************
     C     CANALL        BEGSR
     C                   Z-ADD     0             RECN1             5 0
     C     NXTCAN        TAG
     C                   ADD       1             RECN1
     C     RECN1         IFGT      LSTRC1
     C                   GOTO      ENDCAN
     C                   END
     C     RECN1         CHAIN     TRYSFL                             90
     C   90              GOTO      NXTCAN
     C     CRTKY1        CHAIN     FCARTCC                            60
     C                   Z-add     CTSEQ#        CTSEQ#5           5 0
     C     PUTKEY        CHAIN     FPUTORD                            61
     C                   Z-ADD     0             CTORD#
     C                   Z-ADD     0             CTSEQ#
     C                   MOVEL     'D'           CTSTAT
     C                   MOVE      *BLANKS       CTLOC
     C                   MOVE      *BLANKS       CTSTA
     C                   MOVE      *BLANKS       CTLOTC
     C  N60              UPDATE    RCART
     C                   SUB       1             PDQSCH
     C     PDQSCH        IFLT      0
     C                   Z-ADD     0             PDQSCH
     C                   END
     C  N61              UPDATE    RPUTORD
     C                   ExSr      CanTag
     C                   GOTO      NXTCAN
     C     ENDCAN        TAG
     C                   ENDSR
      ***********************
      ** cancel tag checkin**
      ***********************
     C     CANTAG        BEGSR
      /Free
         Chain (CTTAG#) FTRAYPS;
         If %Found(FTRAYPS);
           Delete RTRAYPS;
           Clear RTRAY;
           Chain (CTTAG#) FTRAY;
           TRTRNU = $USER()      ;
           TRTRNP = 'SCR225'     ;
           TRTRNT = $Timestamp() ;
           TRTRND = 'Tag removed from Order ' + %editw(CTORD#:'     0');
           Write RTRAYTRN;
         EndIf;
      /End-Free
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
** MESSAGE ARRAY
End Of Cart List ******                    1
