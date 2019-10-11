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
      **PROGRAM NAME-------- PSR190
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- BUILD WEEKLY PLUG LOCATION FILE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  2/28/02 EFD ADD DELETE ROUTINE IF ANY ORDERS CANCELLED
      *  2/28/02 EFD ONLY USE LOTC Y ITEMS.
      *  3/18/02 EFD DELETE BACK ORDERED ITEMS.
      *  3/22/02 EFD ADD NEW FIELDS TO PUTORD.
      *  5/06/04 WJB OPTIONALLY INCLUDE/OMMIT KP ORDERS
      *
     FFCALEN    IF   E           K DISK
     F                                     RENAME(RCALEN:CALEN)
     FFCALENCY  IF   E           K DISK
     FFIORDR    IF   E           K DISK
     F                                     RENAME(RIORDR:IORDR)
     FFIORDRSL  IF   E           K DISK
     FFIORDRPARTIF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFPPO      IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFPLGSCTL  UF   E           K DISK
     FFPUTORDA  UF   E           K DISK
     F                                     RENAME(RPUTORD:PUTORD)
     FFPUTORD   UF A E           K DISK
     FFPUTORDOK UF A E           K DISK
      *
    ? * WORK ARRAYS FOR LOCATION MOVE
     D LIN             S              1    DIM(8)                               LOCATION IN
     D LOUT            S              1    DIM(8)                               LOCATION OUT
      *
    ? ***********************
    ? * PROG DATA STRUCTURE *
    ? ***********************
     D                SDS
     D  PROGID                 1     10                                         PROGRAM NAME
     D  RLIBR                 81     90                                         RUN LIBRARY
     D  USERID               254    263                                         USER I.D.
     D  SLIBR                314    323                                         SOURCE LIBRARY
    ? ****************
    ? *   LDA        *
    ? ****************
     D                UDS
     D  PLDATE                11     16  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  RPRTR                134    143
WJB  D  LX1521               144    144
WJB  D  LMASTER              145    146S 0

WJB  D  CVTRBSEL             150    150
WJB  D  BLDRBORD             151    151
WJB  D  CRTHSORD             152    152

     D  Included       S               N
     D  OIITEMKey      S                   Like(OIITEM)
     D  SDateYMD7      S              7S 0                                      ?Ship Date YMD7
     D  modeSelected   S              1A                                        ?C=Count R=Run
     D  TrayCount      S              5S 0                                      ?Tray Count

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$AddDate


    ? ***********************
    ? ** START HERE        **
    ? ***********************

      * 12/13/2011 Use the Monday Friday Ready Bay date instead.
    ?C     PLDATE        CHAIN     FCALEN                             90
     C   90              Eval      *InLR = *On
     C   90              Return
     C  N90              Z-ADD     CLCYMD        WKCYMD            7 0
     C  N90              Z-ADD     CLCYMD        THRCYM            7 0
     C     *DTAARA       DEFINE                  PSC191            1 0
     C                   IN        PSC191
     C                   Eval      THRCYM =
     C                             $Date7($AddDate($date(CLCYMD):-1*PSC191))

    ? ** DELETE ANY UNNEEDED RECORDS
    ?C                   EXSR      DELCHK

    ? ** REBUILD
    ?C     WKCYMD        SETLL     FIORDRSL
     C     NXT           TAG
    ?C     WKCYMD        READE     FIORDRSL                               91
     C   91              GOTO      END
    ?C     ORDERKEY      SetLL     FIORDRPART
WJB  C                   If        %Equal(FIORDRPART)
WJB  C                   Eval      OIITEMKey = OIITEM
WJB  C                   Eval      OIITEM = %subst(OIITEM:1:11)+'P'
WJB  C                   Else
WJB  C                   Eval      OIITEMKey = OIITEM
WJB  C                   EndIf

    ? ** Test Record to verify inclusion...  if it fails a test go back to NXT tag.
    ? *  -  Check Customer
     C     OIITYP        IFGT      *BLANKS
     C     OICUST        OREQ      2730
WJB  C     OICUST        OREQ      1521
WJB  C     LX1521        ANDEQ     'Y'
WJB  C     OICUST        OREQ      8077
WJB  C     LX1521        ANDEQ     'Y'
WJB  C     OICUST        OREQ      7543
WJB  C     LX1521        ANDEQ     'Y'
     C                   GOTO      NXT
     C                   END

    ? *  -  Check Status
WJB  C     OISTAT        IFEQ      'D'
WJB  C                   GOTO      NXT
WJB  C                   EndIf

    ? *  -  Check Open Balance
     C     OIQORD        SUB       OIQSHP        OPEN             11 1
     C     OPEN          IFLE      0
     C                   GOTO      NXT
     C                   END

    ? *  -  Check Valid Item
     C     OIITEM        IFNE      IMITEM
     C     OISIZE        ORNE      IMSIZE
    ?C     ITMKEY        CHAIN     FMINVT                             92
     C   92              GOTO      NXT
WJB  C                   Eval      IMITEM = OIITEM
     C                   MOVE      IMBIN#        LOC               1
     C                   END

    ? *  -  Check Lot Control
     C     IMLOTC        IFNE      'Y'
     C                   GOTO      NXT
     C                   END

    ? *  -  Check Order Header
    ?C     OIORD#        CHAIN     FHORDR                             93
     C   93              GOTO      NXT
     C                   If        OHSTAT <> 'A'
     C                   GOTO      NXT
     C                   EndIf

    ? *  -  Check Multiple Master
WJB  C* Always check!    If        LMASTER <> 0
     C                   Eval      OKORDOK = ' '
     C     OKKEY         KList
     C                   KFld                    WKCYMD
     C                   KFld                    LMASTER
     C                   KFld                    OHORD#
    ?C     OKKEY         Chain     FPUTORDOK
     C                   If        not %Found(FPUTORDOK)
    ?C                   Call      'MMR015'
    ?C                   Parm      OHORD#        ORDER             6 0
    ?C                   Parm      LMASTER       PMASTER           2 0
    ?C                   Parm      OIRVDT        SDateYMD7         7 0
    ?C                   Parm                    Included
     C                   Eval      OKORD# = OHORD#
     C                   If        Included = *On
     C                   Eval      OKORDOK  = 'Y'
     C                   Else
     C                   Eval      OKORDOK  = 'N'
     C                   EndIf
     C                   Eval      OKSHPD = WKCYMD
     C                   Eval      OKMAST = LMASTER
     C                   Write     RPUTORDOK
     C                   Else
     C                   If        OKORDOK = 'Y'
     C                   Eval      Included = *On
     C                   Else
     C                   Eval      Included = *Off
     C                   EndIf
     C                   EndIf
     C                   If        not Included
     C                   Goto      NXT
     C                   EndIf
WJB  C*                  EndIf
    ? *  ---------------------------------------------------------End Inclusion Check



     C                   Z-ADD     OISEQ#        OISEQ#5           5 0
    ?C     PUTKEY        CHAIN     FPUTORD                            94
    ?C   94              DO
     C                   CLEAR                   RPUTORD
     C                   Z-ADD     OHORD#        PDORD#
     C                   Z-ADD     OISEQ#        PDSEQ#
     C                   Z-ADD     WKCYMD        PDSHPD
     C                   Z-ADD     LMASTER       PDMAST
    ?C                   ENDDO                                                  94 DO
     C     LOC           IFLE      *BLANKS
     C                   MOVEL     OHLOC         PDLOC
     C                   ELSE
    ?C     OIORD#        CHAIN     FPPO                               71
     C     LOC           IFEQ      '1'
     C                   MOVEL     POLOWC        PDLOC
     C                   ELSE
     C                   MOVEL     POLOWF        PDLOC
     C                   END
     C                   END

    ? ** RIGHT JUSTIFY LOCATION
     C                   MOVE      *BLANKS       LIN
     C                   MOVE      *BLANKS       LOUT
     C                   MOVEA     PDLOC         LIN
     C                   Z-ADD     8             X                 2 0
     C                   Z-ADD     8             Y                 2 0
     C     NXTX          TAG
     C     LIN(X)        IFGT      *BLANKS
    ? ** CHECK IF WE NEED A ZERO FOR POST
     C     Y             IFEQ      7
     C     LIN(X)        ANDLT     '0'
     C     LOUT(8)       ANDGE     '0'
     C                   MOVE      '0'           LOUT(Y)
     C                   SUB       1             Y
     C                   END                                                    Y=7
     C                   MOVE      LIN(X)        LOUT(Y)
     C                   SUB       1             Y
     C                   END                                                    LIN,X>" "
     C                   SUB       1             X
     C     X             IFGT      0
     C                   GOTO      NXTX
     C                   END
     C                   MOVE      *BLANKS       PDLOC
     C                   MOVEA     LOUT          PDLOC
     C                   Z-ADD     OHCUST        PDCUST
     C                   Z-ADD     OHORDY        PDORDY
     C                   MOVEL     OIITEM        PDITEM
     C                   MOVEL     OISIZE        PDSIZE
     C                   Z-ADD     OPEN          PDQORD
     C                   MOVEL     IMLOOK        PDLOOK
     C                   MOVEL     OILOTC        PDLOTC

    ? ** CHECK STA
     C     OHSTA         IFEQ      'Y'
     C                   MOVEL     'Y'           PDSTA
     C                   ELSE
     C                   MOVE      *BLANKS       PDSTA
     C                   END

    ? ** CHECK IF READY BAY ORDER
     C     PDORDY        IFGE      THRCYM
     C     OHSHPC        andNE     '38'                                         |Search & Rescue
     C                   MOVEL     'Y'           PDRDYB
     C                   ELSE
     C                   MOVE      *BLANKS       PDRDYB
     C                   END                                                    PDORDY>THRCY

    ? ** CHECK BACKORDER
     C     OIPRBO        IFEQ      'B'
     C     OIBOLN        OREQ      'B'
     C                   MOVEL     'B'           PDBORD
     C                   ELSE
     C                   MOVE      *BLANKS       PDBORD
     C                   END                                                    OIPRBO=B
     C   94              WRITE     RPUTORD
     C  N94              UPDATE    RPUTORD
     C                   GOTO      NXT

    ? *** END PROGRAM
     C     END           TAG

     C                   Z-ADD     0             PSCOMP
    ?C     PSCOMP        CHAIN     FPLGSCTL                           59
     C     WKCYMD        IFGT      PSFILD
     C                   Z-ADD     WKCYMD        PSFILD
     C                   Z-ADD     LMASTER       PSFILM
     C                   END
     C                   Z-ADD     TIMOD         PSTIME
     C                   Z-ADD     TDATE         PSDTLA
     C                   MOVEL     USERID        PSUSER
     C  N59              UPDATE    RPLGSCTL

     C                   If        CVTRBSEL = 'Y'
     C                   Call      'GRS610'
     C                   Parm      WKCYMD        SdateYMD7
     C                   EndIf
     C                   If        BLDRBORD = 'Y'
     C                   Call      'GRS620'
     C                   Parm      WKCYMD        SdateYMD7
     C                   Parm                    LMaster
     C                   EndIf
     C                   If        CRTHSORD = 'Y'
     C                   Call      'GRS630'
     C                   Parm      WKCYMD        SdateYMD7
     C                   Parm                    LMaster
     C                   Parm      'R'           modeSelected
     C                   Parm                    TrayCount
     C                   EndIf

     C                   SETON                                        LR


    ? *   ..................................................................................
    ? *   : CHECK FOR DELETES **                                                           :
    ? *   :................................................................................:

      /Free

       Begsr DELCHK;

         // Clear ALL Order OK Records for Given Wk/Master
         Setll (WKCYMD: LMASTER) FPUTORDOK;
         ReadE (WKCYMD: LMASTER) FPUTORDOK;
         DoW not %EOF(FPUTORDOK);
           Delete RPUTORDOK;
           ReadE (WKCYMD: LMASTER) FPUTORDOK;
         EndDo;

         // Read Existing PUT records and find Deletions
         SETLL (WKCYMD:LMASTER) FPUTORDA;
         READE (WKCYMD:LMASTER) FPUTORDA;
         DoW not %EOF(FPUTORDA);
           If PDSEQ# <= 999;
             Chain (PDORD#: PDSEQ#) FIORDR;
            Else;
             Chain (PDORD#: 0) FIORDR;
           EndIf;
           If %Found(FIORDR);
             SetLL (PDORD#: PDSEQ#) FIORDRPART;  // Check to see if Partial
             If %Equal(FIORDRPART);
               OIITEM = %subst(OIITEM:1:11)+'P' ;
             ENDIF;
             If  PDSHPD <> OIRVDT or
                 PDITEM <> OIITEM or
                 PDSIZE <> OISIZE or
                 OISTAT = 'D';
               Exec SQL
                 Update  FTRORD
                 Set     TOORD# = 0,
                         TOSEQ# = 0
                 Where   TOSHDT = :PDSHPD
                   and   TOMAST = :LMASTER
                   and   TOORD# = :PDORD#
                   and   TOSEQ# = :PDSEQ# ;
               Delete PUTORD;
             ENDIF;
           ENDIF;
           READE (WKCYMD:LMASTER) FPUTORDA;
         ENDDO;

       ENDSR;

      /End-Free

    ? ***********************
    ? ** START UP ROUTINE  **
    ? ***********************
    ?C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
    ?C     ORDERKEY      KLIST
    ?C                   KFLD                    OIORD#
    ?C                   KFLD                    OISEQ#
    ?C     ITMKEY        KLIST
    ?C                   KFLD                    OIITEMKey
    ?C                   KFLD                    OISIZE
    ?C     PUTKEY        KLIST
    ?C                   KFLD                    OIORD#
    ?C*                  KFLD                    OISEQ#
    ?C                   KFLD                    OISEQ#5
    ?C                   KFLD                    WKCYMD
    ?C                   KFLD                    LMASTER
    ?C*    TROKEY        KLIST
    ?C*                  KFLD                    PDSHPD
    ?C*                  KFLD                    PDORD#
    ?C*                  KFLD                    PDSEQ#
    ?C                   ENDSR
