     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      **PROGRAM NAME-------- ORDLAV
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- ORDER LIST AVAILABLE SCREENS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FORDLAVFM  CF   E             WORKSTN
     F                                     SFILE(VLSTSFL:RECNO)
     F                                     SFILE(HLSTSFL:RECN1)
     FORDLAVP   O    E             PRINTER USROPN OFLIND(*IN01)
     FFMORLH    IF   E           K DISK
     FFMORLSQ   IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFLKITM    IF   E           K DISK
     FFMINVTLS  IF   E           K DISK
     F                                     RENAME(RMINVT:MINLIS)
     FFMINVTPC  IF   E           K DISK
     F                                     RENAME(RMINVT:MINPC)
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FXATABE1   IF   E           K DISK                                         ?Table File
      *
     D MSG             S             50    DIM(10) CTDATA PERRCD(1)             MESSAGES
     D SZE             S              3    DIM(6)                               SIZES
     D QORD            S              7  0 DIM(6)                               QTY ORD SCREEN
     D QAVL            S              7  0 DIM(6)                               QTY AVAIL
     D PRC             S              8  2 DIM(6)                               PRICE
     D SQ              S              3  0 DIM(6)                               OLD SEQ #'S
     D DEI             S              1    DIM(30)                              DESC WORK ARRAY
     D DEO             S              1    DIM(20)                              DESC WORK ARRAY
     D Today           S              6S 0                                      Today's Date
     D OldSize         S              3A                                        Work Field Old Size
     D TOTAV           S                   like(QTYAV)                          Work Field Old Size
     D OVRPRTF         S            256A
     D FIND            S             30A
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D* UseNote        S               N   Inz(*On)  Per Bill S. on 4/9/18 use R.C. instead of notes
     D  UseNote        S               N   Inz(*Off)
     D  HideZeros      S               N   Inz(*Off)
     D  Loop           S              6S 0 Inz(*Zero)

     D/COPY QFunctDefn,$_Dates
     D/COPY QFunctDefn,$DFTPRT
     D/COPY QFunctDefn,$CHGPRT
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,QCMDEXC

     I**                                      1   10LDAPTO                ARC380
      /Free
    ? /COPY QFunctDefn,LASTUSEDCB
      /End-Free
      ***********************
      ** MAIN LINE CODE    **
      ***********************
     C                   Z-add     -5            Offset
      /Free
         PRINTER = $DftPrt($User():'*NONE':'*USER');
      /End-Free
     C                   CALL      'LKORLS'
     C                   PARM                    LIST              6
     C                   PARM                    NDESC            30
     C     RSTART        TAG
     C                   MOVE      *ZEROS        *IN
     C**                   CLEARSCRNA
     C                   Eval      *In30 = UseNote
     C                   MOVE      *BLANKS       LISTID
     C                   MOVE      *BLANKS       OLIST             6
     C                   MOVE      *BLANKS       HLDESC
     C                   Z-add     *Zero         TOTAV
     C                   If        LIST <> *Blanks
     C                   Eval      LISTID = LIST
     C                   Eval      LIST = *Blanks
     C                   ENDIF
     C     NXTA          TAG
     C                   Eval      PUTSFLRRN = 1
     C                   If        LISTID = *Blanks
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   SETOFF                                       102012
     C                   SETOFF                                       9913
     C                   EndIF
      ** CHECK FOR ALPHA SEARCH
     C                   MOVEL     LISTID        SRC               1
     C     SRC           IFEQ      '?'
     C     SRC           OREQ      '/'
     C     GETL          TAG
     C                   MOVE      *BLANKS       DPT               1
     C                   MOVE      LISTID        SLIST             5
     C                   MOVE      *BLANKS       LSTALP            6
     C***                  MOVELSLIST     LSTALP
     C                   CALL      'LKORLS'
     C                   PARM                    LIST              6
     C                   PARM                    NDESC            30
     C     LIST          IFEQ      *BLANKS
     C                   MOVE      *BLANKS       NDESC
     C                   GOTO      NXTA
     C                   END
     C                   MOVEL     LIST          LISTID
     C                   GOTO      SKIPA
     C                   END
     C     LISTID        IFLE      *BLANKS
     C                   MOVE      *BLANKS       NDESC
     C                   SETON                                        1099
     C                   MOVE      *BLANKS       OLIST             6
     C                   GOTO      NXTA
     C                   END
     C     SKIPA         TAG
     C                   Z-add     *Zero         TOTAV
      ** CHAIN LIST FILE
     C     LISTID        CHAIN     FMORLH                             91
     C   91              MOVE      *BLANKS       NDESC
     C   91              CLEAR                   RMORLH
     C   91              MOVEL     LISTID        HLLIST
     C   91              SETON                                        101299
     C   91              GOTO      NXTA
      *** IF ASSORTMENT GET PRICE FOT ALL ITEMS
     C     HLASST        IFEQ      'Y'
     C                   MOVE      *BLANKS       IMITEM
     C                   MOVEL     LISTID        IMITEM
     C                   MOVEL     'AST'         IMSIZE
     C                   Z-ADD     IMSEL1        APRICE            7 2
     C                   END                                                    HLASST = Y
     C     RSTRTB        TAG
      *** IF ASSORTMENT CHECK IF IN ORDER
     C     HLASST        IFEQ      'Y'
     C                   MOVE      *BLANKS       IMITEM
     C                   MOVEL     LISTID        IMITEM
     C                   MOVEL     'AST'         IMSIZE
     C                   END
      ** NOW GET LIST TYPE
     C     HLFORM        IFEQ      'V'
     C                   EXSR      GETV
     C     NXTGTV        TAG
     C                   If        PUTSFLRRN <= 0
     C                   Eval      PUTSFLRRN = 1
     C                   EndIf
     C                   EXFMT     VLSTCTL
     C   KC              GOTO      END
     C   KH              Do
     C                   If        UseNote
     C                   Eval      UseNote = *Off
     C                   Else
     C                   Eval      UseNote = *On
     C                   EndIf
     C                   Eval      *In30 = UseNote
     C                   Eval      PUTSFLRRN = SFLCSRRRN
     C                   Goto      SKIPA
     C                   EndDo
     C   KB              Do
     C                   If        HideZeros
     C                   Eval      HideZeros = *Off
     C                   Else
     C                   Eval      HideZeros = *On
     C                   EndIf
     C                   Eval      *In31 = HideZeros
     C                   Eval      PUTSFLRRN = SFLCSRRRN
     C                   Goto      SKIPA
     C                   EndDo
     C   KD              Do
      /Free
         OVRPRTF = 'OVRPRTF FILE(ORDLAVP) FORMTYPE(*NAR) ' +
          //'DEV(' + %trim(PRINTER) + ') DEVTYPE(*AFPDS) CORNERSTPL(*TOPLEFT) ' +
          'CPI(10) PAGRTT(0) OVRSCOPE(*JOB) ' +
          'OUTQ(' + %trim(PRINTER) + ') ';
         QCmdExc(OVRPRTF : %len(%trim(OVRPRTF)));
         If not %open(ORDLAVP);
           Open ORDLAVP;
         ENDIF;
         Write VLSTCTLP;
         For Loop = 1 to (LSTREC+1);
           Chain Loop VLSTSFL;
           Write VLSTSFLP;
           If *In01;  // Overflow
             Write VLSTCTLP;
             *In01 = *Off;
           ENDIF;
         ENDFOR;
         If %open(ORDLAVP);
           Close ORDLAVP;
         ENDIF;
      /End-Free
     C                   ENDDO
     C   KM              Do
      /Free
         PRINTER = $ChgPrt($User():'*NONE':'*USER');
      /End-Free
     C                   ENDDO
     C   KK              Do
     C     SFLCSRRRN     Chain     VLSTSFL
     C                   If        SFLCSRRRN <> 0
     C                   Eval      Today = $MDYDate($AddDate($Date(0):+Offset))
     C                   Call      'BIR265ICL'
     C                   Parm                    ITEM
     C                   Parm                    SIZE
     C                   Parm                    Today
     C                   Parm      '2'           Type              1
     C                   Eval      PUTSFLRRN = SFLCSRRRN
     C                   EndIf
     C                   Goto      SKIPA
     C                   EndDo
     C   KG              Do
     C     SFLCSRRRN     Chain     VLSTSFL
     C                   If        SFLCSRRRN <> 0
     C                   Call      'VIEWITEM'
     C                   Parm                    ITEM
     C                   Parm                    SIZE
     C                   Eval      PUTSFLRRN = SFLCSRRRN
     C                   EndIf
     C                   Goto      SKIPA
     C                   EndDo
     C   KF              Do                                                     F6 =Item Master
     C     SFLCSRRRN     Chain     VLSTSFL
     C                   If        SFLCSRRRN <> 0
     C                   Call      'ICR010ICL'
     C                   Parm                    ITEM
     C                   Parm                    SIZE
     C                   Parm      'C'           Mode              1
     C                   Eval      PUTSFLRRN = SFLCSRRRN
     C                   EndIf
     C                   Goto      SKIPA
     C                   EndDo
     C   KI              Do                                                     F9 =Inventory
     C     SFLCSRRRN     Chain     VLSTSFL
     C                   If        SFLCSRRRN <> 0
     C                   Call      'ICR200CL'
     C                   Parm                    ITEM
     C                   Parm                    SIZE
     C                   Eval      PUTSFLRRN = SFLCSRRRN
     C                   EndIf
     C                   Goto      SKIPA
     C                   EndDo
     C   KJ              Do
     C                   Call      'ORDBLD'
     C                   Parm                    LISTID
     C                   Goto      SKIPA
     C                   EndDo
      /Free
         If *InKL;  // F12=Find
           Chain SFLCSRRRN VLSTSFL;
           FIND = 'FIND ''' + %trim(ITEM) + ' ' + %trim(Size) + '''';
           QCmdExc(FIND : %len(%trim(FIND)));
         ENDIF;
      /End-Free
     C   KE              DO
     C     HLASST        IFNE      'Y'
     C                   GOTO      GETL
     C                   ELSE
     C                   WRITE     SCRNNCG
     C                   READ      SCRNNCG                                90
     C                   GOTO      NXTGTV
     C                   END
     C                   ENDDO
     C                   ExSr      GETV
     C                   GOTO      NXTGTV
     C                   ELSE
     C                   EXSR      GETH
     C     NXTGTH        TAG
     C                   EXFMT     HLSTCTL
     C   KF              GOTO      RSTRTB
     C   KC              GOTO      END
     C   KG              GOTO      END
     C   KK              Do
     C                   If        UseNote
     C                   Eval      UseNote = *Off
     C                   Else
     C                   Eval      UseNote = *On
     C                   EndIf
     C                   Eval      *In30 = UseNote
     C                   Eval      PUTSFLRRN = SFLCSRRRN
     C                   Goto      SKIPA
     C                   EndDo
     C   KE              DO
     C     HLASST        IFNE      'Y'
     C                   GOTO      GETL
     C                   ELSE
     C                   WRITE     SCRNNCG
     C                   READ      SCRNNCG                                90
     C                   GOTO      NXTGTH
     C                   END
     C                   ENDDO
     C                   GOTO      NXTGTH
     C                   END
      *
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
     C*                    MOVEA'0'       *IN
     C*                    RETRN
      ***********************
      ** GET VERTICAL LIST **
      ***********************
     C     GETV          BEGSR
     C                   SETON                                        8040
     C                   WRITE     VLSTCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             TOTAV
     C                   EXSR      LODSCR
     C                   SETOFF                                       57
      ** IF SELECTED LIST
     C     HLTYPE        IFEQ      'S'
     C     HLLIST        SETLL     FMORLSQ
     C     NXTVS         TAG
     C     HLLIST        READE     FMORLSQ                                90
     C   90              GOTO      ENDV
     C                   ExSr      NOTERDYCSR
     C     ITMKEY        KLIST
     C                   KFLD                    OLITEM
     C                   KFLD                    OLSIZE
     C                   KFLD                    OLWHSE
     C     ITMKEY        CHAIN(N)  FLKITM                             91
     C  N91IMSTAT        COMP      'D'                                    91
     C   91              GOTO      NXTVS
     C     LKPOH         SUB       LKPAL         QTYAV
      /Free
         QTYAV = *Zero;
         Exec SQL
           Select IMQTAV
           into  :QTYAV
           from   FMINVT
           where  IMITEM = :OLITEM
             and  IMSIZE = :OLSIZE
             and  IMWHSE = :OLWHSE;
      /End-Free
     C     HLASST        IFNE      'Y'
     C                   Z-ADD     LKUPRI        PRICE
     C                   ELSE
     C                   Z-ADD     APRICE        PRICE
     C                   END
     C                   MOVEL     LKITEM        ITEM
     C                   MOVEL     LKITEM        ITEM5
     C                   MOVEL     LKSIZE        SIZE
     C                   MOVEL     LKDES1        DESC
     C                   If        %Len(%Trim(SelSearch)) = *Zero
     C                   Eval      SelSearch = '@@@@@@@@@@@@@@@'
     C                   ENDIF
     C                   If        (ITEM5 = SelITEM or SelITEM = *Blank) and
     C                             (SIZE  = SelSize or SelSIZE = *Blank) and
     C                             (%Scan(%Trim(SelSearch):DESC) > *Zero or
     C                              SelSearch =  '@@@@@@@@@@@@@@@')
     C                   If        not HideZeros or QTYAV <> 0
     C                   add       QTYAV         TOTAV
     C                   ADD       1             RECNO
      /Free
        If Size <> OldSize;
          *In40 = not *In40;
          OldSize = Size;
        ENDIF;
      /End-Free
     C                   WRITE     VLSTSFL
     C                   ENDIF
     C                   ENDIF
     C                   If        SelSearch = '@@@@@@@@@@@@@@@'
     C                   Eval      SelSearch = *Blanks
     C                   ENDIF
     C                   GOTO      NXTVS
     C                   END
      ** IF PRODUCT CLASS
     C     HLTYPE        IFEQ      'P'
     C     HLPRDC        SETLL     FMINVTPC
     C     NXTVP         TAG
     C     HLPRDC        READE     FMINVTPC                               90
     C   90              GOTO      ENDV
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXTVP
     C                   END
     C     HLSNTS        IFEQ      'I'
     C     IMSIZE        ANDLE     *BLANKS
     C                   GOTO      NXTVP
     C                   END
     C                   Z-ADD     1             X
     C     IMSIZE        LOOKUP    SZE(X)                                 92
     C   92HLSNTS        IFEQ      'O'
     C                   GOTO      NXTVP
     C                   END
     C  N92HLSNTS        IFEQ      'I'
     C                   GOTO      NXTVP
     C                   END
     C     ITMKEY        CHAIN(N)  FLKITM                             91
     C     LKPOH         SUB       LKPAL         QTYAV
      /Free
         QTYAV = *Zero;
         Exec SQL
           Select IMQTAV
           into  :QTYAV
           from   FMINVT
           where  IMITEM = :OLITEM
             and  IMSIZE = :OLSIZE
             and  IMWHSE = :OLWHSE;
      /End-Free
     C     HLASST        IFNE      'Y'
     C                   Z-ADD     LKUPRI        PRICE
     C                   ELSE
     C                   Z-ADD     APRICE        PRICE
     C                   END
     C                   MOVEL     LKITEM        ITEM
     C                   MOVEL     LKITEM        ITEM5
     C                   MOVEL     LKSIZE        SIZE
     C                   MOVEL     LKDES1        DESC
     C                   add       QTYAV         TOTAV
     C                   ADD       1             RECNO
     C                   WRITE     VLSTSFL
     C                   GOTO      NXTVP
     C                   END
      ** IF LIST CODE
     C     HLTYPE        IFEQ      'L'
     C                   z-add     *zero         TOTAV
     C     HLLSTC        SETLL     FMINVTLS
     C     NXTVL         TAG
     C     HLLSTC        READE     FMINVTLS                               90
     C   90              GOTO      ENDV
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXTVL
     C                   END
     C                   Z-ADD     1             X
     C     IMSIZE        LOOKUP    SZE(X)                                 92
     C   92HLSNTS        IFEQ      'O'
     C                   GOTO      NXTVL
     C                   END
     C  N92HLSNTS        IFEQ      'I'
     C                   GOTO      NXTVL
     C                   END
     C     ITMKEY        CHAIN(N)  FLKITM                             91
     C     LKPOH         SUB       LKPAL         QTYAV
      /Free
         QTYAV = *Zero;
         Exec SQL
           Select IMQTAV
           into  :QTYAV
           from   FMINVT
           where  IMITEM = :OLITEM
             and  IMSIZE = :OLSIZE
             and  IMWHSE = :OLWHSE;
      /End-Free
     C     HLASST        IFNE      'Y'
     C                   Z-ADD     LKUPRI        PRICE
     C                   ELSE
     C                   Z-ADD     APRICE        PRICE
     C                   END
     C                   MOVEL     LKITEM        ITEM
     C                   MOVEL     LKITEM        ITEM5
     C                   MOVEL     LKSIZE        SIZE
     C                   MOVEL     LKDES1        DESC
     C                   add       QTYAV         TOTAV
     C                   ADD       1             RECNO
     C                   WRITE     VLSTSFL
     C                   GOTO      NXTVL
     C                   END
     C     ENDV          TAG
     C                   Z-ADD     0             QTYAV
     C                   Z-ADD     0             PRICE
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       ITEM5
     C                   MOVE      *BLANKS       SIZE
     C                   z-add     TOTAV         QTYAV
     C                   MOVEL     MSG(2)        DESC
     C                   Eval      NOTERDYC = *Blanks
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   SETON                                        57
     C                   WRITE     VLSTSFL
     C                   SETOFF                                       57
     C                   ENDSR
      ************************
      ** GET HORIZONAL LIST **
      ************************
     C     GETH          BEGSR
     C                   SETON                                        80
     C                   WRITE     HLSTCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECN1             5 0
     C                   EXSR      LODSCR
     C     HLTYPE        IFEQ      'S'
     C     HLLIST        SETLL     FMORLSQ
     C                   END
     C     HLTYPE        IFEQ      'P'
     C     HLPRDC        SETLL     FMINVTPC
     C                   END
     C     HLTYPE        IFEQ      'L'
     C     HLLSTC        SETLL     FMINVTLS
     C                   END
     C     NXTH          TAG
      ** IF SELECTED LIST
     C     HLTYPE        IFEQ      'S'
     C     HLLIST        READE     FMORLSQ                                90
     C   90              GOTO      ENDH
     C                   ExSr      NOTERDYCSR
     C                   SETON                                        212223
     C                   SETON                                        242526
     C                   SETOFF                                       27
     C     OLITEM        SETLL     FMINVT
     C     NXTHSI        TAG
     C     OLITEM        READE(N)  FMINVT                                 91
     C   91              GOTO      CHKHSI
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXTHSI
     C                   END
     C                   Z-ADD     1             X                 2 0
     C     IMSIZE        LOOKUP    SZE(X)                                 71
     C  N71              GOTO      NXTHSI
     C                   SETON                                        27
     C     IMQTOH        SUB       IMQTAL        QAVL(X)
     C     ITMKEY        CHAIN(N)  FLKITM                             91
     C     HLASST        IFNE      'Y'
     C                   Z-ADD     LKUPRI        PRICE
     C                   ELSE
     C                   Z-ADD     APRICE        PRICE
     C                   END
     C                   MOVEL     IMITEM        ITEM#
     C     DESCH         IFLE      *BLANKS
     C                   EXSR      GETDEH
     C                   END
     C                   ADD       20            X
     C                   MOVEL     '0'           *IN(X)
     C                   GOTO      NXTHSI
     C                   END                                                    HLTYPE=S
      ** IF PRODUCT CLASS
     C     HLTYPE        IFEQ      'P'
     C                   SETON                                        212223
     C                   SETON                                        242526
     C                   SETOFF                                       27
     C                   MOVE      *BLANKS       OITEM            12
     C     NXTHP         TAG
     C     HLPRDC        READE     FMINVTPC                               90
     C   90              DO
     C                   GOTO      CHKHSI
     C                   ENDDO
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXTHP
     C                   END
     C     IMITEM        IFNE      OITEM
     C                   GOTO      CHKHSI
     C     NXTHPI        TAG
     C   90              GOTO      ENDH
     C                   SETON                                        212223
     C                   SETON                                        242526
     C                   SETOFF                                       27
     C                   MOVEL     IMITEM        OITEM
     C                   END
     C                   Z-ADD     1             X                 2 0
     C     IMSIZE        LOOKUP    SZE(X)                                 71
     C  N71              GOTO      NXTHP
     C                   SETON                                        27
     C     IMQTOH        SUB       IMQTAL        QAVL(X)
     C     ITMKEY        CHAIN(N)  FLKITM                             91
     C     HLASST        IFNE      'Y'
     C                   Z-ADD     LKUPRI        PRICE
     C                   ELSE
     C                   Z-ADD     APRICE        PRICE
     C                   END
     C                   MOVEL     IMITEM        ITEM#
     C     DESCH         IFLE      *BLANKS
     C                   EXSR      GETDEH
     C                   END
     C                   ADD       20            X
     C                   MOVEL     '0'           *IN(X)
     C                   GOTO      NXTHP
     C                   END                                                    HLTYPE=P
      ** IF LIST CODE
     C     HLTYPE        IFEQ      'L'
     C     NXTHL         TAG
     C     HLLSTC        READE     FMINVTLS                               90
     C   90              DO
     C                   GOTO      CHKHSI
     C                   ENDDO
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXTHL
     C                   END
     C     IMITEM        IFNE      OITEM
     C                   GOTO      CHKHSI
     C     NXTHLI        TAG
     C   90              GOTO      ENDH
     C                   SETON                                        212223
     C                   SETON                                        242526
     C                   SETOFF                                       27
     C                   MOVEL     IMITEM        OITEM
     C                   END
     C                   Z-ADD     1             X
     C     IMSIZE        LOOKUP    SZE(X)                                 71
     C  N71              GOTO      NXTHL
     C                   SETON                                        27
     C     IMQTOH        SUB       IMQTAL        QAVL(X)
     C     ITMKEY        CHAIN(N)  FLKITM                             91
     C     HLASST        IFNE      'Y'
     C                   Z-ADD     LKUPRI        PRICE
     C                   ELSE
     C                   Z-ADD     APRICE        PRICE
     C                   END
     C                   MOVEL     IMITEM        ITEM#
     C     DESCH         IFLE      *BLANKS
     C                   EXSR      GETDEH
     C                   END
     C                   ADD       20            X
     C                   MOVEL     '0'           *IN(X)
     C                   GOTO      NXTHL
     C                   END                                                    HLTYPE=L
      ** SEE IF ANY RECORDS SELECTED
     C     CHKHSI        TAG
     C   27              DO
     C                   Z-ADD     QAVL(1)       QTYAV1
     C                   Z-ADD     PRC(1)        PRIC1
     C                   Z-ADD     QAVL(2)       QTYAV2
     C                   Z-ADD     PRC(2)        PRIC2
     C                   Z-ADD     QAVL(3)       QTYAV3
     C                   Z-ADD     PRC(3)        PRIC3
     C                   Z-ADD     QAVL(4)       QTYAV4
     C                   Z-ADD     PRC(4)        PRIC4
     C                   Z-ADD     QAVL(5)       QTYAV5
     C                   Z-ADD     PRC(5)        PRIC5
     C                   Z-ADD     QAVL(6)       QTYAV6
     C                   Z-ADD     PRC(6)        PRIC6
     C                   Z-ADD     SQ(1)         OLSQ1
     C                   Z-ADD     SQ(2)         OLSQ2
     C                   Z-ADD     SQ(3)         OLSQ3
     C                   Z-ADD     SQ(4)         OLSQ4
     C                   Z-ADD     SQ(5)         OLSQ5
     C                   Z-ADD     SQ(6)         OLSQ6
     C                   ADD       1             RECN1
*     *** TEST ONLY
*    C**         RECN1     IFGT 500
*    C**                   GOTO ENDH
*    C**                   END
*     *** TEST ONLY
      ** GET TOTAL
     C                   WRITE     HLSTSFL
     C                   Z-ADD     0             PRC
     C                   Z-ADD     0             QAVL
     C                   Z-ADD     0             QORD
     C                   Z-ADD     0             SQ
     C                   ENDDO
     C                   MOVE      *BLANKS       DESCH
     C     HLTYPE        IFEQ      'P'
     C                   GOTO      NXTHPI
     C                   END
     C     HLTYPE        IFEQ      'L'
     C                   GOTO      NXTHLI
     C                   END
     C                   GOTO      NXTH
     C     ENDH          TAG
     C**                   MOVE *BLANKS   ITEM#
     C**                   MOVELMSG,2     DESCH
     C**                   ADD  1         RECN1
     C**                   WRITEHLSTSFL
     C                   Z-ADD     RECN1         LSTREC
     C                   ENDSR
      ***********************
      ** LOAD SCREENS      **
      ***********************
     C     LODSCR        BEGSR
      ** GET ORDER INFO
     C                   MOVEL     HLSIZ1        SZE(1)
     C                   MOVEL     HLSIZ2        SZE(2)
     C                   MOVEL     HLSIZ3        SZE(3)
     C                   MOVEL     HLSIZ4        SZE(4)
     C                   MOVEL     HLSIZ5        SZE(5)
     C                   MOVEL     HLSIZ6        SZE(6)
     C                   MOVEL     HLHDG1        HDG1
     C                   MOVEL     HLHDG2        HDG2
     C                   MOVEL     HLHDG3        HDG3
     C                   MOVEL     HLHDG4        HDG4
     C                   MOVEL     HLHDG5        HDG5
     C                   MOVEL     HLHDG6        HDG6
     C                   ENDSR
      **
      * GET DESCRIPTION HORIZONTAL
      **
      ** STRIP THE SIZE NUMBERS FROM THE DESCRIPTION.
     C     GETDEH        BEGSR
     C                   MOVE      *BLANKS       DEI
     C                   MOVE      *BLANKS       DEO
     C                   MOVEL     LKDES1        DESC
     C                   MOVEA     DESC          DEI
     C                   Z-ADD     0             I                 2 0
     C                   Z-ADD     0             O                 2 0
     C     NXTDEH        TAG
     C                   ADD       1             I
     C     I             IFGT      30
     C                   GOTO      FINDEH
     C                   END
     C     DEI(I)        IFLE      'Z'
     C     DEI(I)        ANDNE     '"'
     C     DEI(I)        ANDNE     '.'
     C     DEI(I)        ANDNE     *BLANKS
     C                   GOTO      FINDEH
     C                   END
     C                   GOTO      NXTDEH
      ** NOW MOVE THE REST
     C     FINDEH        TAG
     C                   ADD       1             O
     C                   MOVEL     DEI(I)        DEO(O)
     C                   ADD       1             I
     C     I             IFLE      30
     C     O             ANDLT     20
     C                   GOTO      FINDEH
     C                   END
      ** MOVE THE ARRAY INTO THE DESCRIPTION
     C                   MOVEA     DEO           DESCH
     C                   ENDSR
      **************************
      ** PUT HORIZIONTAL LIST **
      **************************
     C     NOTERDYCSR    BEGSR
     C                   If        UseNote
     C                   Eval      NOTERDYC = OLNOTE
     C                   Else
     C                   Eval      NOTERDYC = OLRDYC
     C                   Eval      Table   = 'RC'
     C                   Eval      TableCd = OLRDYC
    ?C     TableKey      KList
    ?C                   KFld                    Table             2
    ?C                   KFld                    TableCd           6
    ?C     TableKey      Chain     XATABE1                                      ?
     C                   If        %Found(XATABE1)
     C                   Eval      NOTERDYC = TBSHRT
     C                   EndIf
     C                   EndIf
     C                   If        OLNOTE <> ''
     C                   Eval      *In31 = *On
     C                   Else
     C                   Eval      *In31 = *Off
     C                   EndIf
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     USERID        CHAIN     FMUSER                             90
     C   90              MOVE      '999'         USDEPT            3
     C     USDEPT        CHAIN     FMDEPT                             90
     C                   Z-ADD     0             LSTISQ            3 0
     C                   ENDSR
** MESSAGE ARRAY
                                                          1
End of List *********                                     2
