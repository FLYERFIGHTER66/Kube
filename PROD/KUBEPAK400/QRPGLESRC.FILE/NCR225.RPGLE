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
     FNCR225FM  CF   E             WORKSTN
     F                                     SFILE(CRTSFL:RECNO)
     F                                     SFILE(TRYSFL:RECN1)
     FFCALEN    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FNCARTCI   IF   E           K DISK
     F                                     RENAME(RCART:CARTI)
     FNCARTCC   UF   E           K DISK
     FNPUTORD   UF   E           K DISK
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)              MESSAGE
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

     D  CTITEMKey      S                   LIKE(CTITEM)
     D  Skip2Scr03     S               N                                         Skip 2 Screen 03
     D  ShipDate       S              7S 0

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate

      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
      ** WRITE SCRNA
     C     NXTA          TAG
     C                   If        not Skip2Scr03
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
     C     1             CHAIN     CRTSFL
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
     C                   EndIf
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
     C     CARTNO        SETLL     NCARTCI
     C     NXTBLD        TAG
     C     CARTNO        READE     NCARTCI                                90
     C   90              GOTO      ENDBLD
     C                   If        CTMSTR <> SMASTER
     C                   Goto      NXTBLD
     C                   EndIf
     C                   If        CTSHDT <> SHPCYM
     C                   Goto      NXTBLD
     C                   EndIf
     C     CTCNTL        IFNE      OCNTL
     C     CTSHDT        ANDEQ     SHPCYM
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
     C     CRTKEY        KLIST
     C                   KFLD                    CARTNO
     C                   KFLD                    CONTRL
     C     CRTKEY        SETLL     NCARTCC
     C     NXTTRY        TAG
     C     CRTKEY        READE     NCARTCC                                90
     C   90              GOTO      ENDTRY
     C     CTSTAT        IFEQ      'D'
     C                   GOTO      NXTTRY
     C                   END
     C                   If        CTSHDT <> SHPCYM
     C                   Goto      NXTTRY
     C                   EndIf
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
     C                   KFLD                    CARTNO
     C                   KFLD                    CONTRL
     C                   KFLD                    CTSHDT
     C                   KFLD                    CTMSTR
     C                   KFLD                    CTITEM
     C                   KFLD                    CTSIZE
     C                   KFLD                    CTCSEQ
     C     CRTKY1        CHAIN     NCARTCC                            60
     C     PUTKEY        CHAIN     NPUTORD                            61
     C                   Z-ADD     0             CTORD#
     C                   Z-ADD     0             CTSEQ#
     C                   MOVEL     'D'           CTSTAT
     C                   MOVE      *BLANKS       CTLOC
     C                   MOVE      *BLANKS       CTSTA
     C                   MOVE      *BLANKS       CTLOTC
     C  N60              UPDATE    RCART
     C     PUTKEY        KLIST
     C                   KFLD                    CTORD#
     C                   KFLD                    CTSEQ#
     C***                  KFLD           CTSHDT
     C                   SUB       1             PDQSCH
     C     PDQSCH        IFLT      0
     C                   Z-ADD     0             PDQSCH
     C                   END
     C  N61              UPDATE    RPUTORD
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
     C     CRTKY1        CHAIN     NCARTCC                            60
     C     PUTKEY        CHAIN     NPUTORD                            61
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
     C                   GOTO      NXTCAN
     C     ENDCAN        TAG
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR

     C     *Entry        PList
     C                   Parm                    @CARTNO           8
     C                   Parm                    @ShipDate         7
     C                   Parm                    @CTCNTL           6

     C                   Eval      CARTNO   = %int(@CARTNO)
     C                   Eval      ShipDate = %int(@ShipDate)
     C                   Eval      CTCNTL   = %int(@CTCNTL)

     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     TDATE         CHAIN     FCALEN                             90
     C                   Z-ADD     CL#Y          TODAY             1 0
     C                   MOVE      *BLANKS       LCANCL
     C                   If        ShipDate > *Zeros
     C                   Eval      SHPDAT = $MDYDate($Date(ShipDate))
     C                   Eval      Skip2Scr03 = *On
     C                   Else
      ** Make the Date Tommorrow unless it's currently Saturday... then make it Next Monday
     C     TODAY         IFGE      6
     C                   Z-ADD     NXMDY         SHPDAT
     C                   ELSE
     C                   Eval      SHPDAT = $MDYDate($AddDate($Date(0):1))
     C                   END
     C                   EndIf
     C                   ENDSR
** MESSAGE ARRAY
End Of Cart List ******                    1
