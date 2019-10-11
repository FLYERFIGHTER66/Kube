    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *--------------------------------------------------------------
      **PROGRAM NAME-------- GETLOT
      **SYSTEM-------------- TGMS
      **APPLICATION--------- ASSIGN A SPEC ORDER ORDER TO A LOT.
      *--------------------------------------------------------------

     FGETLOTFM  CF   E             WORKSTN SFILE(LOTSFL:RECNO)
      *---------------------------------------------------------------------------------------------
     FFMINVT    IF   E           K DISK
     FFMCUST    IF   E           K DISK
      *---------------------------------------------------------------------------------------------
     FFDLOT     UF   E           K DISK
     FFDLOTRDIDCUF   E           K DISK
     FFDLOTRDCLTIF   E           K DISK    Rename(RDLOTRD:SumLRQTAL) Prefix(A_)
     FFALITEML2 UF A E           K DISK
      *---------------------------------------------------------------------------------------------

      * SYSTEM DATA STRUCTURE
     D                SDS
     D  PROGID                 1     10                                         PROGRAM NAME
     D  RLIBR                 81     90                                         RUN LIBRARY
     D  USERID               254    263                                         USER I.D.
     D  SLIBR                314    323                                         SOURCE LIBRARY

      * MESSAGE ARRAY
     D MSG             S             50    DIM(5) CTDATA PERRCD(1)

      * Function Prototypes
     D/COPY QFunctDefn,$Now
     D/COPY QFunctDefn,$Date
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$Date7
     D/COPY QFunctDefn,$DateMDY
     D/COPY QFunctDefn,$MDYDate

      * Field Definitions
     D  Decrease       S               N   Inz(*Off)
     D  Forced         S               N   Inz(*Off)
     D  NotAvailable   S               N   Inz(*Off)
     D  ShowScreen     S               N   Inz(*On)
     D  FullAuto       S               N   Inz(*Off)
     D  Records        S              6S 0 Inz(*Zero)
     D  ALQTY2         S                   Like(ALQTY)
     D  YesImSure      S              1A   Inz(*Blanks)
     D  Lot2Del        S                   Like(Inv2Del)
     D  RDOH           S                   Like(Inv2Del)
     D  ChangedAL      S                   Like(LRQTAL)

      ** BUILD SUB FILE
     C                   EXSR      BLDSFL
      ** Process Screen
     C     NXTA          TAG
     C                   If        ShowScreen or Forced or
     C                             not Decrease or Records > 1
     C                   Eval      FullAuto = *Off

     C                   EXFMT     LOTCTL

     C                   Else
     C                   Eval      FullAuto = *On
     C                   EndIf
     C                   If        NotAvailable
     C                   Eval      *In04 = *On
     C                   ENDIF
      ** CANCEL PRESSED (F24)
     C   KY              DO
     C                   SETOFF                                       101199
     C   24              MOVE      'N'           FLAG
     C   24              GOTO      END
     C  N24              SETON                                        24
     C                   GOTO      NXTA
     C                   ENDDO
     C                   SETOFF                                       24
     C                   EXSR      CHKSFL
     C   99              Eval      Forced = *On
     C   99
     CANN20              GOTO      NXTA
     C                   EXSR      PUTSFL
     C                   MOVE      'Y'           FLAG
     C                   GOTO      END
     C                   GOTO      NXTA
      ** ALL DONE
     C     END           TAG
      *   Recalculate the TOTAL ALLOCATED for this order
     C                   ExSr      OrdAlloc
     C                   SETON                                        LR
      *   ......................................................................
      *   :              BUILD SUB FILE                                        :
      *   :....................................................................:
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     LOTCTL
     C                   SETOFF                                       809924
     C                   SETOFF                                       101112
     C                   SETOFF                                       2030
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             LRCUST
     C*                  Eval      RDOH = *Zero
     C     ItemSize      SETLL     FDLOTRDIDC
     C     NXTBLD        TAG
     C     ItemSize      READE     FDLOTRDIDC                             90
     C   90              GOTO      ENDBLD
     C     LRCUST        IfEq      999990
     C                   GoTo      NxtBld
     C                   EndIf
     C     LRGLOC        IfEq      'N'
     C                   GoTo      NxtBld
     C                   EndIf
      ** GET AVAILABLE
     C                   Z-ADD     LRQTOH        DQTOH
      ** ALLOW ALOCATE AGAINST COMMITTED
    ?C     LRCUST        IFGT      0
    ?C     DQTOH         IFEQ      0
    ?C     LRQTCM        SUB       LRQTSL        TSLFT            11 1
    ?C     TSLFT         IFGT      0
    ?C                   Z-ADD     TSLFT         DQTOH
    ?C                   END
    ?C                   END
    ?C                   END
    ?C                   Z-ADD     LRQTCM        DPCQT
     C                   Z-ADD     LRQTAL        DQTAL
      ** SEE IF ANY ALLOCATED FOR THIS ORDER/LOT
     C                   ExSr      GETALOC
     C*                   SUB       ALQTY         DQTAL
     C                   SUB       AIQTOA        DQTAL
     C     DQTOH         SUB       DQTAL         DQTAV
     C                   If        DQTAV <> 0 or
     C                             DQTAL <> 0 or
     C                             DQTOH <> 0
     C                   ADD       1             RECNO
     C                   ExSr      GetScrnFlds
     C                   WRITE     LOTSFL
     C                   EndIf
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   SETON                                        30
     C                   ADD       2             RECNO
     C                   MOVEL     MSG(1)        CNAME
     C                   WRITE     LOTSFL
     C     RECNO         IFGT      17
     C                   SETON                                        20
     C                   ELSE
     C                   SETOFF                                       20
     C                   END
     C                   ENDSR
      *   ......................................................................
      *   :              GET FIELD VALUES                                      :
      *   :....................................................................:
     C     GetScrnFlds   BEGSR
      *   We are going to skip these unless the SFL record is to be written
     C                   Eval      READDT = $MDYDate($Date(LRCRDY))
      ** GET CUSTOMER NAME
     C     LRCUST        IFLE      0
     C                   MOVE      *BLANKS       CNAME
     C                   Else
     C     LRCUST        CHAIN     FMCUST                             73
     C  N73              MOVEL     CMNAME        CNAME
     C   73              MOVE      *BLANKS       CNAME
     C                   END

      *  Block "QTY" Field on N/A transactions if no QTY.  (i.e. No Changes, Just Deletes)
     C                   If        NotAvailable and ALQTY = *Zero
     C                   Eval      *In31 = *On
     C                   Else
     C                   Eval      *In31 = *Off
     C                   ENDIF

     C                   ENDSR
      *   ......................................................................
      *   :              Set Screen Mode                                       :
      *   :....................................................................:
     C     SetScrnMode   BEGSR

     C                   If        QtyORD < QtyAL
     C                   Eval      Decrease = *On
     C                   Eval      ShowScreen = *Off
     C                   ENDIF

     C                   If        Flag = 'V'
     C                   Eval      Forced = *Off
     C                   Eval      ShowScreen = *Off
     C                   Eval      NotAvailable = *On
     C                   Eval      Flag = *Blanks
     C                   ENDIF

     C                   If        Flag = 'F'
     C                   Eval      Forced = *On
     C                   Eval      ShowScreen = *On
     C                   Eval      Flag = *Blanks
     C                   ENDIF

     C                   If        Records > 1
     C                   Eval      ShowScreen = *On
     C                   ENDIF

     C                   ENDSR
      *   ......................................................................
      *   :              get allocations                                       :
      *   :....................................................................:
     C     GETALOC       BEGSR

      ** SEE IF ANY ALLOCATED FOR THIS ORDER/LOT
     C                   Eval      ALQTY  = *Zero
     C                   Eval      AIQTOA = *Zero
     C     ALKEY         SETLL     FALITEML2
     C     ALKEY         READE     FALITEML2                              70
     C                   DoW       not %EOF(FALITEML2)
      ** IF THERE IS ONLY ONE ALLOCATION RECORD, PRESUME THIS IS THE LINE THE USER WANTS TO CHANGE
     C                   If        Records = 1
     C                   Eval      ALQTY  = QTYORD
      **     OTHERWISE JUST POPULATE WITH THE ACTUAL ALLOCATION AND LET THEM CHANGE WHAT THEY WANT
     C                   Else
     C                   Eval      ALQTY  = AIQTOA
     C                   EndIf
     C     ALKEY         READE     FALITEML2                              70
     C                   EndDo
     C
     C                   ENDSR
      *   ......................................................................
      *   :              CHECK SUB FILE                                        :
      *   :....................................................................:
     C     CHKSFL        BEGSR
     C                   Z-ADD     1             RECNO
     C                   SETOFF                                       101112
     C                   SETOFF                                       13
     C                   SETOFF                                       243099
     C                   Z-ADD     0             QTYAL
     C     NXTCHK        TAG
     C                   SETOFF                                       101112
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     LOTSFL                             91
     C   91              ADD       1             RECNO
     C   91              GOTO      NXTCHK
     C     ALQTY         IFNE      0
     C     ALQTY         IFGT      DQTAV
     C                   SETON                                        129913
     C                   UPDATE    LOTSFL
     C                   ELSE
     C                   ADD       ALQTY         QTYAL
     C                   UPDATE    LOTSFL
     C                   END
     C                   ELSE
     C                   UPDATE    LOTSFL
     C                   END
     C                   ADD       1             RECNO
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C  N99QTYAL         IFGT      QTYORD
     C                   SETON                                        1099
     C                   END
     C  N99QTYAL         IFLT      QTYORD
     C                   SETON                                        1199
     C                   END
     C                   ENDSR
      *   ......................................................................
      *   :              PUT SUB FILE                                          :
      *   :....................................................................:
     C     PUTSFL        BEGSR
     C                   Eval      YesImSure = *Blanks
     C                   MOVE      'Y'           FLAG
     C                   Z-ADD     1             RECNO
     C                   SETOFF                                       101112
     C                   SETOFF                                       13
     C                   SETOFF                                       243099
     C                   Z-ADD     0             QTYAL

     C     NXTPUT        TAG
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     LOTSFL                             91
     C                   EXSR      BLKFIT
     C   91              ADD       1             RECNO
     C   91              GOTO      NXTPUT
     C                   Eval      ChangedAL = (DQTAL + ALQTY) - LRQTAL
     C                   If        ChangedAL <> *Zero or ALQTY <> *Zero
     C     OUTKEYIDC     CHAIN     FDLOTRDIDC                         90
     C                   If        %Found(FDLOTRDIDC)
     C                   Eval      LRQTAL = LRQTAL + ChangedAL
     C                   ADD       ALQTY         QTYAL
     C                   If        ChangedAL < 0
     C   54              ExSr      REDUCEOH
     C                   EndIf
     C     LRQTOH        SUB       LRQTAL        LRQTAV
     C                   MOVEL     USERID        LRUSER
     C                   Z-ADD     TDATE         LRDTLA
     C                   Z-ADD     TIMOD         LRTIME
     C                   UPDATE    RDLOTRD
     C                   EndIf
     C     ALKEY         CHAIN     FALITEML2                          67
     C   67              DO
     C                   CLEAR                   RALITEM
     C                   Z-ADD     OIORD#        AIORD#
     C                   Z-ADD     OISEQ#        AIOSEQ
     C                   Z-ADD     LRCRDY        AICRDY
     C                   Z-ADD     LRSOWD        AISOWD
     C                   Z-ADD     LRCUST        AICUST
     C                   Z-ADD     LRCOMP        AICOMP
     C                   MOVE      'A'           AISTAT
     C                   MOVEL     IMITEM        AIITEM
     C                   MOVEL     IMSIZE        AISIZE
     C                   MOVEL     LRGLOC        AIGLOC
     C                   MOVEL     LRPHYT        AIPHYT
     C                   MOVEL     IMPCL1        AIPRCL
     C                   ENDDO
     C                   Z-ADD     REQDAT7       AISHPD
     C                   Z-ADD     ALQTY         AIQTOA
     C                   MOVEL     USERID        AIUSER
     C                   Z-ADD     TDATE         AIDTLA
     C                   Z-ADD     TIMOD         AITIME
     C   67              WRITE     RALITEM
     C  N67              UPDATE    RALITEM
     C                   EndIf
     C                   ExSr      UPDFDLOT
      ** GOTO NEXT SFL RECORD
     C                   ADD       1             RECNO
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
     C                   EXSR      DELFIT
     C                   MOVE      'Y'           FLAG
     C                   ENDSR
      *   ......................................................................
      *   :              RECALCULATE FDLOT ALLOCATED/AVAILABLE                 :
      *   :....................................................................:
     C     UPDFDLOT      BEGSR

     C     LOTKey        Chain     FDLOT
     C                   If        %Found(FDLOT)
     C                   Eval      LDQTAL = *Zero
     C     LOTRDKey2     SetLL     FDLOTRDCLT
     C     LOTRDKey2     ReadE     FDLOTRDCLT
     C                   DoW       not %Eof(FDLOTRDCLT)
     C                   Eval      LDQTAL = LDQTAL + A_LRQTAL
     C     LOTRDKey2     ReadE     FDLOTRDCLT
     C                   ENDDO
     C                   Eval      LDQTAV = LDQTOH - LDQTAL
     C                   Eval      LDUSER = $User()
     C                   Eval      LDDTLA = $MDYDate($Date(0))
     C                   Eval      LDTIME = $Now()
     C                   Update    RDLOT
     C                   ENDIF

     C                   ENDSR
      *   ......................................................................
      *   :              REDUCE ONHAND QTY                                     :
      *   :....................................................................:
     C     REDUCEOH      BEGSR

      *         Only Reduce On-hand if quantity is being reduced and the user has selected F4
     C                   If        *In54 and *In04

      *         Make sure this is what we want to do
     C                   If        YesImSure = *Blanks
     C                   If        NotAvailable
     C                   Eval      YesImSure = *On
     C                   Else
     C                   ExFmt     AreYouSure
     C                   Eval      YesImSure = *In16
     C                   EndIf
     C                   EndIf

      *         If we're sure, adjust the On-Hand on the LOTRD record and go adjust LOT by the same
     C                   If        YesImSure = *On
     C                   Eval      LRQTOH = LRQTOH + ChangedAL
     C     LOTKey        Chain     FDLOT
     C                   Eval      LDQTOH = LDQTOH + ChangedAL
     C                   Eval      LDQTAJ = LDQTAJ - ChangedAL
     C                   If        %Found(FDLOT)
     C                   Update    RDLOT
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDSR
      *   ......................................................................
      *   :              BLANK OUT FALITEM for SPECIFIC LOT ONLY               :
      *   :....................................................................:
     C     BLKFIT        BEGSR
     C     ALKEY         SETLL     FALITEML2
     C     ALKEY         READE     FALITEML2                              70
     C                   DoW       not %EOF(FALITEML2)
     C                   Z-ADD     0             AIQTOA
     C                   UPDATE    RALITEM
     C     ALKEY         READE     FALITEML2                              70
     C                   EndDo
     C     ENDFIT        ENDSR
      *   ......................................................................
      *   :              DELETE UNUSED FALITEM                                 :
      *   :....................................................................:
     C     DELFIT        BEGSR
     C     Ord#Seq#      SETLL     FALITEML2
     C     NXTDEL        TAG
     C     Ord#Seq#      READE     FALITEML2                              70
     C   70              GOTO      ENDDEL
     C     AIQTOA        IFEQ      0
     C                   DELETE    RALITEM
     C                   END
     C                   GOTO      NXTDEL
     C     ENDDEL        ENDSR
      *   ......................................................................
      *   :              Calculate Order Allocated                             :
      *   :....................................................................:
     C     OrdAlloc      BEGSR

     C                   Eval      QTYAL = *Zero
     C                   Eval      Records = *Zero
     C     Ord#Seq#      SETLL     FALITEML2
     C     Ord#Seq#      READE     FALITEML2
     C                   DoW       not %EOF(FALITEML2)
     C     AIITEM        IFNE      IMITEM
     C     AISIZE        ORNE      IMSIZE
     C                   DELETE    RALITEM
     C                   Else
     C                   Eval      Records = Records + 1
     C                   Eval      QTYAL = QTYAL + AIQTOA
     C                   EndIf
     C     Ord#Seq#      READE     FALITEML2
     C                   EndDo

     C                   ENDSR
      *   ......................................................................
      *   :              INITIALIZATION SUBROUTINE                             :
      *   :....................................................................:
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    OIORD#            6 0
     C                   PARM                    OISEQ#            3 0
     C                   PARM                    OIDTRQ            6 0
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    QTYORD
     C                   PARM                    QTYAL
     C                   PARM                    FLAG              1

     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0

     C     ItemSize      CHAIN     FMINVT                             60

      *   Trust no-one... recalculate the ALLOCATED right here and now!
     C                   ExSr      OrdAlloc

     C                   If        QTYORD < QTYAL
     C                   Eval      *In54 = *On
     C                   Eval      Inv2Del = QTYAL - QTYORD
     C                   Else
     C                   Eval      *In54 = *Off
     C                   ENDIF

     C                   EXSR      SetScrnMode

     C                   Eval      REQDAT7 = $Date7($DateMDY(OIDTRQ))
     C                   Eval      REQDAT  = $MDYDate($DateMDY(OIDTRQ))
     C                   If        FLAG = 'N'
     C                   Call      'GETGERM'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    REQDAT7           7 0          CYMD
     C                   PARM                    SOWDAT7           7 0          CYMD
     C                   EVAL      SOWDAT = $MDYDATE($DATE(SOWDAT7))
     C                   If        $Date(SOWDAT7) > $Date(0)
     C                   Eval      FLAG = ' '
     C                   Return
     C                   EndIf
     C                   EndIf

      ** SET FLAG TO BLANK  OK
     C                   MOVE      *BLANKS       FLAG

      *----Program Key Lists---------------------------------------------------------------------
     C     ItemSize      KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C     Ord#Seq#      KLIST
     C                   KFLD                    OIORD#
     C                   KFLD                    OISEQ#
     C     LOTRDKey      Klist
     C                   KFld                    LRITEM
     C                   KFld                    LRSIZE
     C                   KFld                    LRCRDY
     C                   KFld                    LRCUST
     C                   KFld                    LRSOWD
     C     LOTRDKey2     Klist
     C                   KFld                    LRITEM
     C                   KFld                    LRSIZE
     C                   KFld                    LRWHSE
     C                   KFld                    LRSOWD
     C                   KFld                    LRCRDY
     C     LOTKey        Klist
     C                   KFld                    LRITEM
     C                   KFld                    LRSIZE
     C                   KFld                    LRWHSE
     C                   KFld                    LRSOWD
     C                   KFld                    LRGLOC
     C                   KFld                    LRCRDY
     C     OUTKEYIDC     KLIST
     C                   KFLD                    LRITEM
     C                   KFLD                    LRSIZE
     C                   KFLD                    LRCRDY
     C                   KFLD                    LRCUST
     C                   KFLD                    LRSOWD
     C                   KFLD                    LRGLOC
     C                   KFLD                    LRCLOC
     C                   KFLD                    LRCODE
     C     ALKEY         KLIST
     C                   KFLD                    OIORD#
     C                   KFLD                    OISEQ#
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    LRSOWD
     C                   KFLD                    LRGLOC
     C                   KFLD                    LRCUST
     C                   KFLD                    LRCRDY
      *----Program Key Lists---------------------------------------------------------------------

     C                   ENDSR

**  MESSAGE ARRAY
-------- END OF DATA ---------
