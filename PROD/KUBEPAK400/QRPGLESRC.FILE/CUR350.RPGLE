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
      **PROGRAM NAME-------- CUR350
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- UPDATE CUTTING NEEDS WITH CONFIRMATIONS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FCUR350FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFCALEN    IF   E           K DISK
     F                                     RENAME(RCALEN:CALENI)
     FFCALENCY  IF   E           K DISK
     FFCUTCTL   UF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCUTORDD  IF   E           K DISK
     F                                     RENAME(RCUTORD:CUTORD)
     FFCUTORDN  UF   E           K DISK
     FFCUTLOT   UF   E           K DISK
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
     C                   MOVEL     'X'           LCANCL
     C                   Z-ADD     0             ORDDAT
     C                   Z-ADD     0             ORDNO
      *
     C                   SETOFF                                       404110
     C                   SETOFF                                       58
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       58
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG DO
     C   KD              DO
     C                   EXSR      GetORD
     C                   If        COORD# = 0
     C                   SETON                                        58
     C                   GoTo      NxtA
     C                   EndIf
     C                   ENDDO
     C                   SETOFF                                       404110
     C                   SETOFF                                       58
      * CHECK FOR ORDER NUMBER
     C     ORDNO         IFGT      0
     C     VendOrd#      KList
     C                   KFld                    Vendor
     C                   KFld                    ORDNO
WJB  C     VendOrd#      SetLL     FCUTORDN
WJB  C     VendOrd#      ReadE     FCUTORDN
WJB  C                   Eval      *In10 = *On
WJB  C                   DoW       not %EOF(FCUTORDN)
     C     COSTAT        IFNE      ' '
WJB  C     VendOrd#      ReadE     FCUTORDN
     C                   Else
     C                   Eval      *In10 = *Off
     C                   Leave
     C                   END
     C                   EndDo
     C   10              GOTO      NXTA
WJB  C                   Else
     C                   EXSR      GetORD
     C                   If        COORD# = 0
     C                   SETON                                        58
     C                   GoTo      NxtA
     C                   EndIf
WJB  C                   EndIf

      ** GET SUB FILE
     C     RSTRTB        TAG
     C                   EXSR      BLDSFL

     C     NXTSFL        TAG
     C                   MOVEL     ALPHA         OALPHA           15

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

      ** KB to Post and restart
     C   KB              DO
     C                   EXSR      PUTSFL
     C                   GOTO      RSTART
     C                   ENDDO                                                  KB  DO

      ** KD POST TO ONHAND
     C   KD              DO
     C                   EXSR      PUTSFL
     C                   MOVE      *BLANKS       LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KD  DO

      ** KA MOVE NEED TO ORDER
     C   KA              DO
     C                   EXSR      RELALL
     C                   GOTO      NXTSFL
     C                   ENDDO                                                  KA  DO

      ** KH Zero Line
     C   KH              DO
     C                   ExSr      DelLine
     C                   GOTO      NXTSFL
     C                   ENDDO                                                  KA  DO

      ** KG DELETE
     C   KJ              DO
     C                   EXSR      DELSFL
     C                   GOTO      RSTART
     C                   ENDDO                                                  KJ  DO

      ** SEE IF ALPHA CHANGED
     C     ALPHA         IFNE      OALPHA
     C                   EXSR      GETPAG
     C                   GOTO      NXTSFL
     C                   ENDIF                                                  ALPHA><OALPH

      ** NO OPTIONS GOTO NXTSFL
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
WJB  C*    ORDNO         SETLL     FCUTORDN
WJB  C     VendOrd#      SETLL     FCUTORDN
     C     NXTBLD        TAG
WJB  C*    ORDNO         READE     FCUTORDN                               90
WJB  C     VendOrd#      READE     FCUTORDN                               90
     C   90              GOTO      ENDBLD
      ** GET SCREEN FIELDS
     C                   If        COSTAT = ' '
     C                   MOVEL     COITEM        ITEM
     C     ITMKEY        KLIST
     C                   KFLD                    COITEM
     C                   KFLD                    COSIZE
     C     ITMKEY        CHAIN     FMINVT                             81
     C   81              MOVEL     MSG(1)        IMDES1
     C                   Z-ADD     COSOWD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SOWD
     C                   Z-ADD     COQTRC        ORDER
     C                   ADD       COQTOO        ORDERED           7 0
     C                   Eval      Week = $Week#($DateMDY(SOWD))
     C                   Call      'GETREADY'    GETREADY
     C                   Eval      SHIPDATE = $MDYDate($Date(REQDAT))
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C     PAGE#         IFLE      0
     C     COLOOK        ANDGE     ALPHA
     C                   Z-ADD     RECNO         PAGE#
     C                   END
     C                   EndIf
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       COSIZE
     C                   MOVE      *BLANKS       IMDES1
     C                   Z-ADD     0             SOWD
     C                   Z-ADD     0             WEEK
     C                   Z-ADD     0             SHIPDATE
     C                   Z-ADD     0             ORDER
     C                   Z-ADD     ORDERED       COQTOO
     C                   MOVEL     MSG(4)        IMDES1
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   SETON                                        15
     C                   WRITE     RECSFL
     C                   SETOFF                                       15
     C     COSVND        Chain     FMVEND
     C                   Eval      SupVend = %Trim(VMNAME) + ' (' +
     C                             %Char(VMVEND) + ')'
     C                   ENDSR
      ********************
      **   GET ORDER    **
      ********************
     C     GETORD        BEGSR
WJB  C                   Eval      COORD# = *Zeros
WJB  C                   Call      'CUR355'
WJB  C                   Parm                    Vendor
WJB  C                   Parm                    COORD#
WJB  C                   If        COORD# <> 0
WJB  C                   Eval      *In10 = *Off
WJB  C                   Eval      ORDNO = COORD#
WJB  C                   EndIf
     C                   ENDSR
      ********************
      **   PUT SUB FILE **
      ********************
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTPUT
     C     ORDKEY        KLIST
WJB  C                   KFLD                    Vendor
     C                   KFLD                    COORD#
     C                   KFLD                    COSOWD
     C                   KFLD                    COVNAL
     C                   KFLD                    COLOOK
     C                   KFLD                    COITEM
     C                   KFLD                    COSIZE
     C     ORDKEY        CHAIN     FCUTORDN                           81
     C                   Z-ADD     ORDER         COQTRC
     C  N81              UPDATE    RCUTORD
     C                   GOTO      NXTPUT
     C     ENDPUT        ENDSR
      ********************
      ** GET PAGE NUMB  **
      ********************
     C     GETPAG        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             PAGE#
     C     NXTPAG        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPAG
     C                   END
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTPAG
     C     PAGE#         IFLE      0
     C     COLOOK        ANDGE     ALPHA
     C                   Z-ADD     RECNO         PAGE#
     C                   GOTO      ENDPAG
     C                   END
     C                   GOTO      NXTPAG
     C     ENDPAG        ENDSR
      ********************
      ** RELEASE ALL    **
      ********************
     C     RELALL        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             PAGE#
     C     NXTREL        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDREL
     C                   END
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTREL
     C     PAGE#         IFLE      0
     C     COLOOK        ANDGE     ALPHA
     C                   Z-ADD     RECNO         PAGE#
     C                   END
     C                   Z-ADD     COQTOO        ORDER
     C                   UPDATE    RECSFL
     C                   GOTO      NXTREL
     C     ENDREL        ENDSR
      ********************
      **DELETE SUB FILE **
      ********************
     C     DELSFL        BEGSR
     C                   Z-ADD     1             Line
     C                   DoU       not %Found(CUR350FM)
     C                   ExSr      DelLine
     C                   Eval      Line = Line + 1
     C                   EndDo
     C                   ENDSR
      ***********************
      ** Delete Line       **
      ***********************
     C     DELLINE       BegSr
     C     Line          Chain     RECSFL
     C                   If        %Found(CUR350FM)
     C     ORDKEY        CHAIN     FCUTORDN                           81
     C                   Z-ADD     *Zero         COQTRC
     C                   Move      'D'           COSTAT
     C     LOTKEY        Chain     FCUTLOT
     C     LOTKEY        KLIST
     C                   KFLD                    Vendor
     C                   KFLD                    COITEM
     C                   KFLD                    COSIZE
     C                   KFLD                    COSOWD
     C                   If        %Found(FCUTLOT) and not *In81
     C                   Eval      CLQTOO = CLQTOO - COQTOO
     C                   If        CLQTOO < 0
     C                   Eval      CLQTOO = *Zeros
     C                   EndIf
     C                   Eval      CLQTAV = CLQTOH + CLQTOO - CLQTSL
     C                   Update    RCUTLOT
     C                   EndIf
     C  N81              UPDATE    RCUTORD
     C                   Eval      *In60 = *On
     C                   UPDATE    RECSFL
     C                   Eval      *In60 = *Off
     C                   EndIf
     C                   EndSr
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
WJB  C     *Entry        PList
WJB  C                   Parm                    Vendor
WJB  C     Vendor        Chain     FMVEND
     C                   Eval      SMVEND = VMVEND
     C                   Eval      SMNAME = VMNAME
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
    ?C     GETREADY      PList
    ?C                   Parm                    IMITEM
    ?C                   Parm                    IMSIZE
    ?C                   Parm                    IMWHSE
    ?C                   Parm                    REQDAT            7 0          CYMD
    ?C                   Parm                    COSOWD
     C                   ENDSR
** Messages
No Item Number Found                           1
Alphabetic Sequence                            2
Numeric Sequence                               3
  *** End of Data ***                          4
