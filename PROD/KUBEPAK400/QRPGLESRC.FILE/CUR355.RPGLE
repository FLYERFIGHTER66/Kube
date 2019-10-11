    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      **PROGRAM NAME-------- CUR355
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- UPDATE CUTTING NEEDS WITH CONFIRMATIONS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FCUR355FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFCUTORDN  IF   E           K DISK
     FFMVEND    IF   E           K DISK
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$Week#
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$MDYDate

      * MESSAGE ARRAY
     D MSG             S             30    DIM(5) CTDATA PERRCD(1)              MESSAGES
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
      * LDA          *
      ****************
     D                UDS
      ** ORDER NUMBER
     D  ORDNO                  1      6  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
WJB   *
WJB  D  Vendor         S                   Like(VMVEND)
      ****************
      * START HERE   *
      ****************
     C     RSTART        TAG
      *
      ** GET SUB FILE
     C     RSTRTB        TAG
     C                   EXSR      BLDSFL

     C     NXTSFL        TAG

     C     PAGE#         IFLE      0
     C                   Z-ADD     1             PAGE#
     C                   END

     C                   EXFMT     RECCTL

     C                   SETOFF                                       57

      ** KC to Exit
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG DO

      ** KF to Restart
     C   KF              GOTO      RSTART

      ** NO OPTIONS GET LINE#
     C                   If        Line > 0
     C     Line          Chain     RECSFL
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf
     C                   GOTO      NXTSFL

      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ********************
      ** BUILD SUB FILE **
      ********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     RECCTL
     C                   SETOFF                                       8015
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             PAGE#
WJB  C     Vendor        SETLL     FCUTORDN
     C     NXTBLD        TAG
WJB  C     Vendor        READE     FCUTORDN                               90
     C   90              GOTO      ENDBLD
      ** GET SCREEN FIELDS
     C                   If        COSTAT = ' '
     C                   ADD       1             RECNO
     C                   Eval      SupVend = %Trim(SMNAME) + ' (' +
     C                             %Char(SMVEND) + ')'
     C                   If        COSVND <> *Zero and
     C                             COSVND <> SMVEND
     C     COSVND        Chain     FMVEND
     C                   Eval      SupVend = %Trim(VMNAME) + ' (' +
     C                             %Char(VMVEND) + ')'
     C                   EndIf
     C                   WRITE     RECSFL
     C     PAGE#         IFLE      0
     C                   Z-ADD     RECNO         PAGE#
     C                   END
     C                   EndIf
     C     VendOrd#      KList
     C                   KFld                    Vendor
     C                   KFld                    COORD#
     C                   If        COSTAT = ' '
WJB  C     VendOrd#      SetGT     FCUTORDN
     C                   EndIf
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   SETON                                        15
     C                   Eval      COORD# = *Zero
     C                   Eval      COSOWD = *Zero
     C                   Eval      COORDD = *Zero
     C                   Eval      SUPVEND = '*** End of Data ***'
     C                   WRITE     RECSFL
     C                   SETOFF                                       15
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
WJB  C     *Entry        PList
WJB  C                   Parm                    Vendor
WJB  C                   Parm                    COORD#
WJB  C     Vendor        Chain     FMVEND
     C                   Eval      SMVEND = VMVEND
     C                   Eval      SMNAME = VMNAME
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
** Messages



  *** End of Data ***                          4
