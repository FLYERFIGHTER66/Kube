    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

    ? *?                                                              ?
    ? *??|                                                            |?
    ? *??|       Cuttings Inquiry Program                             |?
    ? *?|                                                            |?


     FCUR410FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFCALEN    IF   E           K DISK
     F                                     RENAME(RCALEN:CALENI)
     FFCUTLOT   IF   E           K DISK
     FFCUTORDIO IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     FFMINVT    IF   E           K DISK

    ? *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$isNote
    ?D/COPY QFunctDefn,$Notes

    ? * MESSAGE ARRAY
     D MSG             S             30    DIM(5) CTDATA PERRCD(1)              MESSAGES

    ? ***********************
    ? * PROG DATA STRUCTURE *
    ? ***********************
     D                SDS
    ? * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
    ? * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
    ? * USER I.D.
     D  USERID               254    263                                         ARC380
    ? * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380

     D  Vendor         S                   Like(VMVEND)

     D  Tot_COQTOO     S                   Like(COQTOO)
     D  Tot_COQTRC     S                   Like(COQTRC)
     D  Tot_ONORDER    S                   Like(ONORDER)
      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
    ? ****************
    ? * START HERE   *
    ? ****************
     C     RSTART        TAG
    ?C     ITMKEY        KLIST
    ?C                   KFLD                    CLITEM
    ?C                   KFLD                    CLSIZE
    ?C     ITMKEY        CHAIN     FMINVT                             10
    ? ** GET SUB FILE
     C     RSTRTB        TAG
     C                   EXSR      BLDSFL
     C     NXTSFL        TAG
     C     PAGE#         IFLE      0
     C                   Z-ADD     1             PAGE#
     C                   END
     C                   EXFMT     RECCTL
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG DO
     C   KF              GOTO      RSTART
      *  Check for Notes request
     C                   If        NOTES = 1 or NOTES = 2
     C                   MoveL     *Blanks       KEYFLD           25
     C                   Eval      KeyFld = %EditW(CLVEND:'0     ')
     C                                    +        CLITEM5
     C                                    +        CLSIZE
     C                                    + %EditW(CLSOWD:' -  /  /  ')
     C                   CallP     $Notes('FCUTLOT':KEYFLD)
     C                   Eval      *In60 = *On
     C                   GOTO      RSTRTB
     C                   EndIf
      *
    ? ** NO OPTIONS GOTO NXTSFL
     C                   GOTO      NXTSFL
    ? ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
    ? ********************
    ? ** BUILD SUB FILE **
    ? ********************
     C     BLDSFL        BEGSR
     C                   Z-ADD     0             Tot_COQTOO
     C                   Z-ADD     0             Tot_COQTRC
     C                   Z-ADD     0             Tot_ONORDER
     C                   SETON                                        80
    ?C                   WRITE     RECCTL
     C                   SETOFF                                       8025
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             PAGE#
     C     LotKey        SETLL     FCUTORDIO
     C     NXTBLD        TAG
     C     LotKey        READe     FCUTORDIO                              90
     C                   If        *In90
     C                   GOTO      ENDBLD
     C                   EndIf
    ? ** GET SCREEN FIELDS
     C                   Eval      ONORDER = *Zero
     C                   Eval      Tot_COQTRC = Tot_COQTRC + COQTRC
     C                   Eval      Tot_COQTOO = Tot_COQTOO + COQTOO
     C                   If        COSTAT = ' '
     C                   Eval      ONORDER = COQTOO
     C                   Eval      Tot_ONORDER = Tot_ONORDER + COQTOO
     C                   EndIf
     C                   ADD       1             RECNO
    ?C                   WRITE     RECSFL
     C     PAGE#         IFLE      0
     C                   Z-ADD     RECNO         PAGE#
     C                   END
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Clear                   RECSFL
     C                   Z-ADD     Tot_COQTRC    COQTRC
     C                   Z-ADD     Tot_COQTOO    COQTOO
     C                   Z-ADD     Tot_ONORDER   ONORDER
     C                   MOVEL     MSG(4)        COVITM
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   Eval      *In51 = *On
    ?C                   WRITE     RECSFL
     C                   Eval      *In51 = *Off
     C                   ENDSR
    ? ********************
    ? ** GET PAGE NUMB  **
    ? ********************
     C     GETPAG        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             PAGE#
     C     NXTPAG        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPAG
     C                   END
    ?C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTPAG
     C     PAGE#         IFLE      0
     C                   Z-ADD     RECNO         PAGE#
     C                   GOTO      ENDPAG
     C                   END
     C                   GOTO      NXTPAG
     C     ENDPAG        ENDSR
    ? ***********************
    ? ** START UP ROUTINE  **
    ? ***********************
     C     *INZSR        BEGSR
    ?C     *Entry        PList
    ?C                   Parm                    Vendor
    ?C                   Parm                    CLITEM
    ?C                   Parm                    CLSIZE
    ?C                   Parm                    CLSOWD
    ?C     LOTKEY        KList
    ?C                   KFld                    Vendor
    ?C                   KFld                    CLITEM
    ?C                   KFld                    CLSIZE
    ?C                   KFld                    CLSOWD

     C                   Eval      CLITEM5 = %Subst(CLITEM:1:5)
     C                   MoveL     *Blanks       KEYFLD           25
     C                   Eval      KeyFld = %EditW(Vendor:'0     ')
     C                                    +        CLITEM5
     C                                    +        CLSIZE
     C                                    + %EditW(CLSOWD:' -  /  /  ')
     C                   Eval      *In60 = $isNote('FCUTLOT':KEYFLD)

    ?C     Vendor        Chain     FMVEND
    ?C     LOTKEY        Chain     FCUTLOT
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0

     C                   ENDSR

** Messages
No Item Number Found                           1
Alphabetic Sequence                            2
Numeric Sequence                               3
* End of Data *                                4
