    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DftActGrp(*No)
    ?H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
    ?H DatFmt(*Usa)
    ? *--------------------------------------------------------------

     FUPC010FM  CF   E             WORKSTN
     FFMINVT    IF   E           K DISK
     FFMSIZD    IF   E           K DISK
     FFMUPCUPC  IF   E           K DISK
     FFMUPCITEM IF   E           K DISK    Rename(RMUPC:RMUPCITEM)
     FFUPCLABL  UF A E           K DISK

    ? ***********************
    ? * PROG DATA STRUCTURE *
    ? ***********************
     D                SDS
     D  PROGID                 1     10                                         PROGRAM NAME
     D  RLIBR                 81     90                                         RUN LIBRARY
     D  USERID               254    263                                         USER I.D.
     D  SLIBR                314    323                                         SOURCE LIBRARY

     D RMSIZSL       E DS                  EXTNAME(FMSIZSL)

    ? *   Fields
     D  LFILE          S             10
     D  LCOPY          S              2  0
     D  LCANCL         S              1
     D  LPRTR          S             10
     D  RPRTR          S             10

      *? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Center

    ? *****************
    ? ** START HERE  **
    ? *****************
    ?C     RSTART        TAG
     C                   SETOFF                                       101112
     C                   SETOFF                                       203013
     C                   Eval      CopyUPC = *Zero
    ?C     NXTA          TAG
    ?C                   WRITE     SCRNA
    ?C                   READ      SCRNA                                  90
     C                   Eval      *In13 = *Off
    ? ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
     C                   SETOFF                                       101112
     C                   SETOFF                                       2030
     C   KH              DO
     C                   If        *In40
     C                   Eval      *In40 = *Off
     C                   Else
     C                   Eval      *In40 = *On
     C                   EndIf
     C                   GOTO      RSTART
     C                   EndDo
    ?C                   If        *In40                                         Copy UPC !!!
    ?C     CopyUPC       Chain     FMUPCUPC                                      Copy UPC !!!
     C                   If        not %Found(FMUPCUPC)
     C                   Eval      *In13 = *On
     C                   GOTO      RSTART
     C                   Else
     C                   Eval      *In40 = *Off
     C                   Eval      ITEM = UPCITEM
     C                   Eval      SIZE = UPCSIZE
     C                   EndIf
     C                   EndIf
    ? ** CHECK ITEM
     C     1             SUBST     ITEM:1        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     ITEM:2        IMLOOK
     C                   MOVEL     SIZE          IMSIZE
    ?C                   CALL      'LKITAL'
    ?C                   PARM                    IMLOOK
    ?C                   PARM                    IMITEM
    ?C                   PARM                    IMSIZE
    ?C                   PARM                    IMWHSE
    ?C                   PARM                    IMDES1
    ?C                   PARM                    IMDES2
    ?C                   PARM                    IMDES3
    ?C                   PARM                    IMDES4
    ?C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   GOTO      NXTA
     C                   ENDIF
    ?C     MINKEY        KLIST
    ?C                   KFLD                    ITEM
    ?C                   KFLD                    SIZE
    ?C     MINKEY        CHAIN     FMINVT                             20
     C   20              GOTO      NXTA
    ?C                   Clear                   RMUPCITEM
    ?C     MINKEY        CHAIN     FMUPCITEM                          20
     C                   Eval      CopyUPC = UPCCODE
     C                   Eval      ULUPC#  = UPCCODE
     C                   Eval      ULDES1  = $Center(%Trim(UPCDES1):25)
     C                   Eval      ULDES2  = $Center(%Trim(UPCDES2):25)
     C                   Eval      ULITMS  = %SubSt(%Trim(ITEM)+ '('
     C                              + %Trim(SIZE)+')        ':1:%Len(ULITMS))
    ?C                   Clear                   RMSIZD
    ?C     SIZE          CHAIN     FMSIZD
     C                   Eval      ULSIZ1  = $Center(%Subst(SZCTRD:01:15):15)
     C                   Eval      ULSIZ2  = $Center(%Subst(SZCTRD:16:15):15)
    ? ** IF HERE ALL OK
      /Free
         SLLABL = LABL     ;
         SLGBLT = ULGBLT   ;
         SLGBNM = ULGBNM   ;
         SLGLOC = ULGLOC   ;
         Exec SQL Select * Into :RMSIZSL from FMSIZSL Where SLCODE = :SIZE;
         LABL   = SLLABL   ;
         ULGBLT = SLGBLT   ;
         ULGBNM = SLGBNM   ;
         ULGLOC = SLGLOC   ;
      /End-Free
     C                   SETOFF                                       102071
     C                   SETOFF                                         9899
     C                   Z-ADD     0             OLAB              4 0
     C                   MOVEL     LPRTR         OPRTR            10
    ?C     NXTB          TAG
     C   99              SETOFF                                           98
    ?C                   WRITE     SCRNB
    ?C                   READ      SCRNB                                  90
    ? ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
     C   71              GOTO      NXTB
     C                   SETOFF                                       1020
     C                   SETOFF                                           99
    ? ** CHECK NUMBER OF LABELS
     C     NUMLAB        IFLE      0
     C                   SETON                                        1099
     C                   GOTO      NXTB
     C                   END
    ? ** CHECK PRINTER
     C     LPRTR         IFLE      *BLANKS
     C                   SETON                                        2099
     C                   GOTO      NXTB
     C                   END
    ? ** CHECK FOR CHANGES
     C     NUMLAB        IFNE      OLAB
     C     LPRTR         ORNE      OPRTR
     C                   Z-ADD     NUMLAB        OLAB
     C                   MOVEL     LPRTR         OPRTR
     C                   SETOFF                                       98
     C                   END
    ? ** REDISPLAY
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   END
    ? ** IF HERE PRINT LABELS
     C                   MOVEL     'P'           LCANCL

     C                   Move      Across        Across@
     C                   If        Across <= 0
     C                   Eval      Across = 1
     C                   EndIf
     C     NUMLAB        Div(H)    Across        NUMLAB

     C                   Do        NUMLAB
    ?C                   Write     RUPCLABL
     C                   EndDo

     C                   GOTO      END
     C                   GOTO      RSTART
    ? *** END JOB
    ?C     END           TAG
     C                   SETON                                        LR
    ? ***********************
    ? ** START UP ROUTINE  **
    ? ***********************
    ?C     *INZSR        BEGSR
    ?C     *Entry        PList
    ?C                   Parm                    LCANCL
    ?C                   Parm                    LPRTR
    ?C                   Parm                    SIZE
    ?C                   Parm                    Across@           2
    ?C                   Parm                    LABL
    ?C                   Parm                    ULGBLT
    ?C                   Parm                    ULGBNM
    ?C                   Parm                    ULGLOC
     C                   Move      Across@       Across
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-add     1             NUMLAB
    ?C                   ENDSR
