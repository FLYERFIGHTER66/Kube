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
      **PROGRAM NAME-------- CUR300
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- UPDATE CUTTING NEEDS WITH ORDER QTYS.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * VV01    11/20/18   Vimala       Include Supplier Quantity in Subfile
      //--------------------------------------------------------------------
      *
      *
     FCUR300FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFCALEN    IF   E           K DISK
     F                                     RENAME(RCALEN:CALENI)
     FFCALEX    IF   E           K DISK
     FFCUTCTL   IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCUTNEDA  IF   E           K DISK
     F                                     RENAME(RCUTNEED:CUTNED)
     FFCUTNEED  UF   E           K DISK
     FFMVEND    IF   E           K DISK
      *
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
      ** REPORT ONLY  Y/N
     D  RPTONL                 1      1
      ** SEQUENCE  A=ALPHA  N=NUMERIC
     D  RPTSEQ                 2      2
      ** SHOW ALL Y/N
     D  SHOALL                 3      3
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
      *
     D  Vendor         S                   Like(VMVEND)
VV01 D  WkVend         S                   Like(CNVEND)
VV01 D  WkItem         S                   Like(CNITEM)
VV01 D  WkDate         S               D
VV01 D  WkDateN        S              8P 0

     D  Tot_CNQTSL     S                   Like(CNQTSL)
     D  Tot_CNQTND     S                   Like(CNQTND)
     D  Tot_ORDER      S                   Like(ORDER )
VV01 D  Tot_SupQ       S                   Like(SUPQTY)
VV01 D  NullInd        S              5I 0                                      Null Indicator
VV01 D  NullValue      S              5I 0 Inz(-1)
      *
VV01  * Below statements commented as program is not compiling when program type is changed to
VV01  * is changed to SQLRPGLE from RPGLE
      */Free
    ? *  /COPY QFunctDefn,LASTUSEDCB
      */End-Free
      ****************
      * START HERE   *
      ****************
     C     RSTART        TAG
     C                   Z-ADD     0             SOWDAT
     C                   Z-ADD     0             SOWCYM
     C                   Z-ADD     0             YEAR
     C                   Z-ADD     0             WEEK
     C                   Z-ADD     0             OSOWD             6 0
     C                   Z-ADD     0             OYEAR             4 0
     C                   Z-ADD     0             OWEEK             2 0
     C                   MOVE      *BLANKS       ALPHA
     C                   MOVEL     'A'           CNSTAT
WJB  C*    CNSTAT        SETLL     FCUTNEED
WJB  C     VendStat      SETLL     FCUTNEED
WJB  C*    CNSTAT        READE     FCUTNEED                               98
WJB  C     VendStat      READE     FCUTNEED                               98
      ** 98 ON NO OPEN NEEDS FILE
     C   98              DO
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
     C                   Z-ADD     CNRYMD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         RPTDAT
      *
     C                   SETOFF                                       404145
     C                   SETOFF                                       489899
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG DO
     C                   SETOFF                                       404145
     C                   SETOFF                                       489899
      * CHECK FOR SOW DATE
     C     SOWDAT        IFGT      0
     C     SOWDAT        CHAIN     FCALEN                             40
     C   40              DO
     C                   SETON                                        99
     C                   Z-ADD     0             SOWCYM
     C                   Z-ADD     0             YEAR
     C                   Z-ADD     0             WEEK
     C                   GOTO      NXTA
     C                   ENDDO                                                  40 DO
     C     CL#Y          IFNE      1
     C                   SETON                                        404199
     C                   GOTO      NXTA
     C                   END                                                    CL#Y><1
     C                   MOVEL     CLCENT        YEAR
     C                   MOVE      CLYEAR        YEAR
     C                   Z-ADD     CLWEEK        WEEK
     C                   Z-ADD     CLCYMD        SOWCYM            7 0
     C                   END                                                    SOWDAT>0
      * SEE IF WEEK NUMBER ENTERED
     C     SOWDAT        IFLE      0
     C     YEAR          ANDGT     0
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
     C                   MOVEL     YEAR          CLCENT
     C                   MOVE      YEAR          CLYEAR
     C                   Z-ADD     WEEK          CLWEEK
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             45
     C   45              DO
     C                   SETON                                        99
     C                   Z-ADD     0             SOWCYM
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        SOWDAT
     C                   Z-ADD     CLCYMD        SOWCYM
     C                   END                                                    SOWDAT=0
      *
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
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG DO
     C   KF              GOTO      RSTART
      *  Check For Supply Vendor Inquiry
     C                   If        SNSVND = *Zero
     C                   Call      'CUR999'
     C                   Parm                    SNSVND
     C                   EndIf
      *  Check New Supply Vendor
     C                   If        SNSVND <> CNSVND
     C     SNSVND        Chain     FMVEND
     C                   If        %Found(FMVEND)
     C                   Eval      SNSVND  = VMVEND
     C                   Eval      CNSVNAM = VMNAME
     C                   Else
     C                   Eval      SNSVND  = SMVEND
     C                   Eval      CNSVNAM = SMNAME
     C                   GoTo      NXTSFL
     C                   EndIf
     C                   EndIf

     C   KB              DO
     C                   EXSR      PUTSFL
     C                   GOTO      RSTART
     C                   ENDDO                                                  KB  DO
      ** KD POST TO ONHAND
     C   KD              DO
      ** NOT ALLOWED IF UNTRANSFERED FILE EXISTS
     C*    01            CHAIN(N)  FCUTCTL                            93
     C     CompVend      CHAIN(N)  FCUTCTL                            93
     C     CCTXFR        IFEQ      'N'
     C                   SETON                                        57
     C                   GOTO      NXTSFL
     C                   END                                                    CCTXFR=N
     C                   EXSR      PUTSFL
     C                   GOTO      END
     C                   ENDDO                                                  KD  DO
      ** KA MOVE NEED TO ORDER
     C   KA              DO
     C                   EXSR      RELALL
     C                   GOTO      NXTSFL
     C                   ENDDO                                                  KA  DO
      ** KG DELETE
     C   KJ              DO
     C                   EXSR      DELSFL
     C     DEL           IFEQ      'Y'
     C                   GOTO      RSTART
     C                   ELSE
     C                   GOTO      NXTSFL
     C                   END
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
     C                   MOVEL     'A'           CNSTAT
WJB  C*    CNSTAT        SETLL     FCUTNEDA
WJB  C     VendStat      SETLL     FCUTNEDA
     C     NXTBLD        TAG
WJB  C*    CNSTAT        READE     FCUTNEDA                               90
WJB  C     VendStat      READE     FCUTNEDA                               90
     C   90              GOTO      ENDBLD
     C     CNSOWD        IFNE      SOWCYM
     C     SOWCYM        ANDGT     0
     C                   GOTO      NXTBLD
     C                   END
     C                   If        SNSVND <> CNSVND
     C     CNSVND        Chain     FMVEND
     C                   If        %Found(FMVEND)
     C                   Eval      SNSVND  = VMVEND
     C                   Eval      CNSVNAM = VMNAME
     C                   EndIf
     C                   EndIf
      ** GET SCREEN FIELDS
     C                   MOVEL     CNITEM        ITEM
     C     ITMKEY        KLIST
     C                   KFLD                    CNITEM
     C                   KFLD                    CNSIZE
     C     ITMKEY        CHAIN     FMINVT                             81
     C   81              MOVEL     MSG(1)        IMDES1_29
     C  N81              MOVEL     IMDES1        IMDES1_29
     C                   Z-ADD     CNSOWD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SOWD
     C                   Z-ADD     CNQTSH        ORDER
      *
VV01  /Free
VV01      WkDateN  =  %Dec(%Char(%Date(SOWD:*mdy):*ISO0):8:0);
VV01      WkDate  = %Date(WkDateN:*ISO);
VV01      WkVend  = CNVEND;
VV01      WkItem  = CNITEM;
VV01      SUPQTY  = *Zeros;
VV01      Exec Sql
VV01         Select SUPPLIER_QUANTITY_AVAILABLE into :SUPQTY :NullInd
VV01            from WSSUPINVL1
VV01            where Vendor_Number = :WkVend
VV01              and Kube_Pak_Item = :WkItem
VV01              and AVAILABLE_DATE = :WkDate;
VV01         If NullInd = NullValue;
VV01            SUPQTY = 0;
VV01         Endif;
VV01         If SqlCod = 0;
VV01            If SUPQTY < CNQTND;
VV01               *IN58 = *ON;
VV01            Else;
VV01               *IN58 = *OFF;
VV01            Endif;
VV01         Endif;
VV01  /End-Free
      *
     C                   ADD       1             RECNO
     C                   add       CNQTSL        Tot_CNQTSL
     C                   add       CNQTND        Tot_CNQTND
     C                   add       ORDER         Tot_ORDER
VV01 C                   add       SUPQTY        Tot_SUPQ
     C                   WRITE     RECSFL
     C     PAGE#         IFLE      0
     C     CNLOOK        ANDGE     ALPHA
     C                   Z-ADD     RECNO         PAGE#
     C                   END
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       IMDES1_29
     C                   MOVE      *BLANKS       IMSIZE
     C                   Z-ADD     0             SOWD
     C                   Z-ADD     0             ORDER
     C                   Z-ADD     0             CNQTND
     C                   Z-ADD     0             CNQTSL
     C                   Z-ADD     0             CNQTSH
VV01 C                   z-add     0             SUPQTY
     C                   z-add     Tot_CNQTSL    CNQTSL
     C                   z-add     Tot_CNQTND    CNQTND
     C                   z-add     Tot_ORDER     ORDER
VV01 C                   z-add     Tot_SUPQ      SUPQTY
     C                   MOVEL     MSG(4)        IMDES1_29
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   SETON                                        15
     C                   WRITE     RECSFL
     C                   SETOFF                                       15
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
     C     NEDKEY        KLIST
     C                   KFLD                    Vendor
     C                   KFLD                    CNSTAT
     C                   KFLD                    CNRYMD
     C                   KFLD                    CNITEM
     C                   KFLD                    CNSIZE
     C                   KFLD                    CNSOWD
     C     NEDKEY        CHAIN     FCUTNEED                           81
     C                   Z-ADD     ORDER         CNQTSH
     C                   Z-ADD     SNSVND        CNSVND
     C  N81              UPDATE    RCUTNEED
     C                   GOTO      NXTPUT
     C     ENDPUT        ENDSR
      ********************
      **DELETE SUB FILE **
      ********************
     C     DELSFL        BEGSR
     C                   Z-ADD     0             TOTREC            9 0
     C                   MOVEL     'A'           CNSTAT
WJB  C     VendStat      KList
WJB  C                   KFld                    Vendor
WJB  C                   KFld                    CNSTAT
WJB  C*    CNSTAT        SETLL     FCUTNEED
WJB  C     VendStat      SETLL     FCUTNEED
     C     NXTDL1        TAG
WJB  C*    CNSTAT        READE(N)  FCUTNEED                               90
WJB  C     VendStat      READE(N)  FCUTNEED                               90
     C   90              GOTO      ENDDL1
     C                   ADD       CNQTSH        TOTREC
     C                   GOTO      NXTDL1
     C     ENDDL1        TAG
     C                   WRITE     SCRND
     C                   READ      SCRND                                  90
     C  NKF
     CANNKJ              GOTO      ENDDL1
     C   KF              DO
     C                   MOVE      *BLANKS       DEL               1
     C                   GOTO      ENDDEL
     C                   ENDDO
      ** IF HERE DELETE FILE
     C                   MOVEL     'Y'           DEL               1
     C                   MOVEL     'A'           CNSTAT
WJB  C*    CNSTAT        SETLL     FCUTNEED
WJB  C     VendStat      SETLL     FCUTNEED
     C     NXTDEL        TAG
WJB  C*    CNSTAT        READE     FCUTNEED                               90
WJB  C     VendStat      READE     FCUTNEED                               90
     C   90              GOTO      ENDDEL
     C                   DELETE    RCUTNEED
     C                   GOTO      NXTDEL
     C     ENDDEL        ENDSR
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
     C     CNLOOK        ANDGE     ALPHA
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
     C     CNLOOK        ANDGE     ALPHA
     C                   Z-ADD     RECNO         PAGE#
     C                   END
     C                   Z-ADD     CNQTND        ORDER
     C                   UPDATE    RECSFL
     C                   GOTO      NXTREL
     C     ENDREL        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR

     C     *Entry        PList
     C                   Parm                    Vendor

     C                   Z-Add     1             Company           2 0
     C     CompVend      KList
     C                   KFld                    Company
     C                   KFld                    Vendor
     C     CompVend      CHAIN(N)  FCUTCTL                            93

WJB  C     Vendor        Chain     FMVEND
     C                   Eval      SMVEND =  VMVEND
     C                   Eval      SMNAME  = VMNAME
     C                   Eval      SNSVND =  VMVEND
     C                   Eval      CNSVNAM = VMNAME
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      ** GET LOWEST SOW DATE (THIS WEEK)
     C     TDATE         CHAIN     FCALEN                             90
     C                   Z-ADD     CLCYMD        RPTCYM            7 0
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             90
     C                   Z-ADD     CLCYMD        BEGSCY            7 0
     C                   Z-ADD     CLDATE        BEGDAT            6 0
     C                   ENDSR
** Messages
No Item Number Found                           1
Alphabetic Sequence                            2
Numeric Sequence                               3
  *** End of Data ***                          4
