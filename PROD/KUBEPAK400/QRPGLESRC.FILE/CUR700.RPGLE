     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
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
      **PROGRAM NAME-------- CUR400
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- INQUIRE INTO CUTTING LOT FILE
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 10/17/02 EFD CHANGE FROM 84 TO 105 TRAYS.
      * 11/12/02 EFD TAKE OUT MULT BY 1.05 THEY ENTER CORRECT NUMBER.
      *
      *
     FCUR700FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFCALEN    IF   E           K DISK
     F                                     RENAME(RCALEN:CALENI)
     FFCALEX    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     F                                     RENAME(RMINVT:MINVTI)
     FFMINVTAL  IF   E           K DISK
     FFCUTVEND  IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFCUTLOT   UF A E           K DISK
     FFCUTORD   O  A E           K DISK
     FFCUTCTL   UF   E           K DISK
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(5) CTDATA PERRCD(1)              MESSAGES
      * ALPHA ARRAY
     D ALP             S              1    DIM(15)                              ALPHA SEARCH
      * SCREEN ARRAY
     D OQT             S              7  0 DIM(10)                              QUANTITIES ORIGINAL
     D QTY             S              7  0 DIM(10)                              QUANTITIES
     D TOT             S              7  0 DIM(10)                              TOTAL QTYS
     D SWD             S              7  0 DIM(10)                              SOWDATE CYMD
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
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY

     D SavITEMI2       S                   Like(ITEMI2)
     D SavALPHA2       S                   Like(ALPHA2)
     D LAST_ITEM       S                   Like(IMITEM)
     D LAST_SIZE       S                   Like(IMSIZE)

      * REDEFINE RECSFL
     IRECSFL
     I              QTY1                        QTY(1)
     I              QTY2                        QTY(2)
     I              QTY3                        QTY(3)
     I              QTY4                        QTY(4)
     I              QTY5                        QTY(5)
     I              QTY6                        QTY(6)
     I              QTY7                        QTY(7)
     I              QTY8                        QTY(8)
     I              QTY9                        QTY(9)
     I              QTY10                       QTY(10)
     I              OQT1                        OQT(1)
     I              OQT2                        OQT(2)
     I              OQT3                        OQT(3)
     I              OQT4                        OQT(4)
     I              OQT5                        OQT(5)
     I              OQT6                        OQT(6)
     I              OQT7                        OQT(7)
     I              OQT8                        OQT(8)
     I              OQT9                        OQT(9)
     I              OQT10                       OQT(10)
      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
      ****************
      * START HERE   *
      ****************
     C     RSTART        TAG
     C*                  Z-ADD     0             SOWDAT
     C                   Z-ADD     0             SOWCYM
     C                   Z-ADD     0             YEAR
     C                   Z-ADD     0             WEEK
     C                   Z-ADD     0             OSOWD             6 0
     C                   Z-ADD     0             OYEAR             4 0
     C                   Z-ADD     0             OWEEK             2 0
     C                   MOVE      *BLANKS       ALPHA
     C                   MOVE      *BLANKS       ITEMI
     C                   SETOFF                                       1011
     C                   SETOFF                                       404145
     C                   SETOFF                                       489899
     C                   SETOFF                                       3031
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG DO
     C                   SETOFF                                       1011
     C                   SETOFF                                       303143
     C                   SETOFF                                       404145
     C                   SETOFF                                       489899
      * CHECK VENDOR SEARCH
     C     SVEND         IFEQ      *Zeros
     C                   Call      'CUR999'
     C                   Parm                    SVEND
     C                   GOTO      NXTA
     C                   END                                                    ALPHA>" "
     C     SVEND         IFNE      *Zeros
     C     SVEND         SetLL     FCUTVEND
     C                   If        %Equal(FCUTVEND)
     C     SVEND         Chain     FMVEND
     C                   Eval      *In43 = *Off
     C                   Else
     C                   Eval      *In43 = *On
     C                   GOTO      NXTA
     C                   END                                                    ALPHA>" "
     C                   END                                                    ALPHA>" "
WJB01 * CHECK ALPHA SEARCH
WJB01C*    ALPHA         IFGT      *BLANKS
WJB01C*                  MOVEL     ALPHA         TST1              1
WJB01C*    TST1          IFEQ      '?'
WJB01C*    TST1          OREQ      '/'
WJB01C*                  MOVEL     *BLANKS       IMLOOK
WJB01C*    14            SUBST     ALPHA:2       IMLOOK
WJB01C*                  MOVEL     '105'         IMSIZE
WJB01C*                  MOVE      *BLANKS       SHPFR
WJB01C*                  CALL      'LK84'
WJB01C*                  PARM                    IMLOOK
WJB01C*                  PARM                    IMITEM
WJB01C*                  PARM                    IMSIZE
WJB01C*                  PARM                    NWLOOK           15
WJB01C*                  MOVEL     NWLOOK        ALPHA
WJB01C*                  GOTO      NXTA
WJB01C*                  END                                                    TST1=? /
WJB01C*                  END                                                    ALPHA>" "
      * CHECK ITEM NUMBER
     C     ITEMI         IFGT      *BLANKS
     C                   MOVEL     ITEM          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     ITEMI:2       IMLOOK
     C*                  MOVEL     'CUT'         IMSIZE
     C                   MOVE      *BLANKS       SHPFR
     C                   CALL      'LKITAL'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        ITEMI
     C                   GOTO      NXTA
     C                   END                                                    TST1=? /
     C     ITMKEY        KLIST
     C                   KFLD                    CLITEM
     C                   KFLD                    CLSIZE
     C                   MOVEL     ITEMI         CLITEM
     C*                  MOVEL     'CUT'         CLSIZE
     C     ITMKEY        CHAIN     FMINVT                             10
     C   10              GOTO      NXTA
     C                   END                                                    ITEM>" "
      ** CHECK THAT EITHER ALPHA OR ITEM NUMBER ENTERED
     C*    ALPHA         IFLE      *BLANKS
     C*    ITEMI         ANDLE     *BLANKS
     C*                  SETON                                        30
     C*                  GOTO      NXTA
     C*                  END
      ** NOT BOTH
     C     ALPHA         IFGT      *BLANKS
     C     ITEMI         ANDGT     *BLANKS
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   END
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
      ** SOW DATE MUST BE ENTERED
     C     SOWCYM        IFLE      0
     C                   SETON                                        31
     C                   GOTO      NXTA
     C                   END
     C                   Eval      ITEMI2 = ITEMI
     C                   Eval      ALPHA2 = ALPHA
      *
      ** GET SUB FILE
     C     RSTRTB        TAG
     C                   Eval      SavITEMI2 = ITEMI2
     C                   Eval      SavALPHA2 = ALPHA2
     C                   If        ALPHA = *Blanks
     C                   Eval      *In16 = *On
     C                   Else
     C                   Eval      *In16 = *On
     C                   EndIf
     C                   EXSR      BLDSFL
     C     NXTSFL        TAG
     C     PAGE#         IFLE      0
     C                   Z-ADD     1             PAGE#
     C                   END
     C                   WRITE     RECFTR
     C                   EXFMT     RECCTL
     C                   Read      RECFTR
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG DO
     C   KF              GOTO      RSTART
     C   KD              DO
     C                   EXSR      PUTSFL
     C                   GOTO      RSTRTB
     C                   ENDDO                                                  KD DO
     C                   If        *In08 or *In09
     C                   EXSR      PUTSFL
     C   08              Eval      SOWDAT = $MDYDate(
     C                                 $AddDate($DateMDY(SOWDAT):Weeks*-7))
     C   09              Eval      SOWDAT = $MDYDate(
     C                                 $AddDate($DateMDY(SOWDAT):Weeks*+7))
     C                   GOTO      RSTRTB
     C                   EndIf                                                  KD DO
     C                   If        ITEMI2 <> SavITEMI2 or ALPHA2 <> SavALPHA2
     C                   EXSR      PUTSFL
     C                   Eval      ITEMI  =  ITEMI2
     C                   Eval      ALPHA  =  ALPHA2
     C                   GOTO      RSTRTB
     C                   EndIf                                                  KD DO
      ** NO OPTIONS GOTO NXTSFL
     C                   EXSR      GETTOT
     C                   GOTO      NXTSFL
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      *********************
      * BUILD SUB FILE
      *********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     RECCTL
     C                   SETOFF                                       80  01
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             TOT
     C                   EVAL      LAST_ITEM = *Blanks
     C                   EVAL      LAST_SIZE = *Blanks
      ** GET HEADINGS ETC
     C                   EXSR      GETHED
     C     ALPHA         SETLL     FMINVTAL
     C     NXTBLD        TAG
     C                   READ      FMINVTAL                               90
     C   90              GOTO      ENDBLD
     C     IMVEND        IFNE      SVEND
WJB01C*    IMFRSZ        ORNE      'CUT'
WJB01C     IMSTAT        ORNE      'A'
     C                   GOTO      NXTBLD
     C                   END
     C     IMITEM        IFNE      ITEMI
     C     ITEMI         ANDGT     *BLANKS
     C                   GOTO      NXTBLD
     C                   END
     C     IMITEM        IFEQ      LAST_ITEM
     C     IMSIZE        ANDEQ     LAST_SIZE
     C                   GOTO      NXTBLD
     C                   ELSE
     C                   EVAL      LAST_ITEM = IMITEM
     C                   EVAL      LAST_SIZE = IMSIZE
     C                   END
      ** NO ALPHA ENTERED DISPLAY RECORD
     C   16              GOTO      ALOK
      ** NOW CHECK REST OF FIELDS
     C                   If        %SubSt(IMLOOK:1:%Len(%Trim(ALPHA)))
     C                             <> %Trim(ALPHA)
     C                   GOTO      NXTBLD
     C                   Else
     C                   GOTO      ALOK
     C                   EndIf
     C                   GOTO      ENDBLD
     C     ALOK          TAG
     C     LOTKEY        KLIST
     C                   KFLD                    SVEND
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    SWD(X)
     C                   Z-ADD     0             QTY
     C                   Z-ADD     0             OQT
     C                   Z-ADD     0             X                 2 0
     C*                  MOVEL     'CUT'         IMSIZE
     C     NXTBX         TAG
     C                   ADD       1             X
     C     X             IFGT      10
     C                   GOTO      ENDBX
     C                   END
     C     LOTKEY        CHAIN     FCUTLOT                            81
     C   81              GOTO      NXTBX
     C                   Z-ADD     CLQTOH        QTY(X)
     C                   Z-ADD     CLQTOH        OQT(X)
     C                   ADD       CLQTOH        TOT(X)
     C                   GOTO      NXTBX
     C     ENDBX         TAG
     C     ITKEY         KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C     ITKEY         CHAIN     FMINVT                             82
     C   82              MOVEL     MSG(1)        IMDES1
     C                   MOVEL     IMITEM        ITEM
      ** GET SCREEN FIELDS
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C     PAGE#         IFLE      0
     C                   Z-ADD     1             PAGE#
     C                   END
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       IMDES1
     C                   Z-ADD     TOT           QTY
     C                   MOVEL     MSG(4)        IMDES1
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   SETON                                        01
     C                   WRITE     RECSFL
     C                   SETOFF                                       01
     C                   ENDSR
      ********************
      ** GET TOTALS     **
      ********************
     C     GETTOT        BEGSR
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             TOT
     C     NXTTOT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDTOT
     C                   END
     C     RECNO         CHAIN     RECSFL                             90
     C  N90              ADD       QTY           TOT
     C                   GOTO      NXTTOT
     C     ENDTOT        TAG
     C     RECNO         CHAIN     RECSFL                             90
     C                   MOVEL     MSG(4)        IMDES1
     C                   SETON                                        01
     C                   Z-ADD     TOT           QTY
     C  N90              UPDATE    RECSFL
     C                   SETOFF                                       01
     C                   ENDSR
      ********************
      ** PUT SFILE      **
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
     C                   Z-ADD     0             X
     C     NXTPX         TAG
     C                   ADD       1             X
     C     X             IFGT      10
     C                   GOTO      NXTPUT
     C                   END
     C     LOTKEY        CHAIN     FCUTLOT                            77
     C   77QTY(X)        IFLE      0
     C                   GOTO      NXTPX
     C                   END

     C   77              DO
     C                   CLEAR                   RCUTLOT
     C                   MOVEL     'A'           CLSTAT
     C                   MOVEL     IMITEM        CLITEM
     C                   MOVEL     VMVEND        CLVEND
     C                   MOVEL     IMSIZE        CLSIZE
     C                   Z-ADD     SWD(X)        CLSOWD
     C                   ENDDO

     C                   Z-ADD     QTY(X)        CLQTOH
     C                   Eval      CLQTAV = CLQTOH + CLQTOO - CLQTSL
     C                   MOVEL     IMLOOK        CLLOOK
     C   77              WRITE     RCUTLOT
     C  N77              UPDATE    RCUTLOT
     C     QTY(X)        SUB       OQT(X)        CHANGE            7 0
     C                   IF        CHANGE <> 0
    ?C     CompVend      KList
    ?C                   KFld                    Company           2 0
    ?C                   KFld                    CLVEND
     C                   Eval      Company = 1
    ?C     CompVend      CHAIN     FCUTCTL                            93
     C                   Eval      COORD#  = CCNXTM
     C                   Eval      CCNXTM =  CCNXTM + 1
    ?C  N93              Update    RCUTCTL
     C                   EVAL      COVEND  =  CLVEND
     C                   EVAL      COSVND  =  CLVEND
     C                   EVAL      COSTAT  =  '9'
     C                   EVAL      COITEM  =  CLITEM
     C                   EVAL      COSIZE  =  CLSIZE
     C                   EVAL      COUSEC  =  CLUSEC
     C                   EVAL      COORDD  =  $Date7($Date(0))
     C                   EVAL      COSOWD  =  CLSOWD
     C                   EVAL      CORDYD  =  CLRDYD
     C                   EVAL      COLOOK  =  CLLOOK
     C                   EVAL      COVNAL  =  'Manual Change'
     C                   EVAL      COVITM  =  'Adj: ' + $USER()
     C                   EVAL      COQTOO  =  CHANGE
     C                   EVAL      COQTRC  =  CHANGE
     C                   EVAL      COPRTD  =  'N'
     C                   EVAL      COTRAN  =  'Y'
     C                   Write     RCUTORD
     C                   ENDIF
     C                   GOTO      NXTPX
     C     ENDPUT        TAG
     C                   ENDSR
      ********************
      ** GET HEADINGS   **
      ********************
     C     GETHED        BEGSR
     C     SOWDAT        CHAIN     FCALEN                             92
     C                   Z-ADD     CLWEEK        WEEK1
     C                   MOVEL     CLDATE        DATE1
     C                   Z-ADD     CLCYMD        SWD(1)
     C                   Z-ADD     CLCYMD        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
      ** WEEK 2
     C                   ADD       7             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##MDY         CHAIN     FCALEN                             92
     C                   Z-ADD     CLWEEK        WEEK2
     C                   MOVEL     CLDATE        DATE2
     C                   Z-ADD     CLCYMD        SWD(2)
      ** WEEK 3
     C                   ADD       7             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##MDY         CHAIN     FCALEN                             92
     C                   Z-ADD     CLWEEK        WEEK3
     C                   MOVEL     CLDATE        DATE3
     C                   Z-ADD     CLCYMD        SWD(3)
      ** WEEK 4
     C                   ADD       7             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##MDY         CHAIN     FCALEN                             92
     C                   Z-ADD     CLWEEK        WEEK4
     C                   MOVEL     CLDATE        DATE4
     C                   Z-ADD     CLCYMD        SWD(4)
      ** WEEK 5
     C                   ADD       7             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##MDY         CHAIN     FCALEN                             92
     C                   Z-ADD     CLWEEK        WEEK5
     C                   MOVEL     CLDATE        DATE5
     C                   Z-ADD     CLCYMD        SWD(5)
      ** WEEK 6
     C                   ADD       7             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##MDY         CHAIN     FCALEN                             92
     C                   Z-ADD     CLWEEK        WEEK6
     C                   MOVEL     CLDATE        DATE6
     C                   Z-ADD     CLCYMD        SWD(6)
      ** WEEK 7
     C                   ADD       7             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##MDY         CHAIN     FCALEN                             92
     C                   Z-ADD     CLWEEK        WEEK7
     C                   MOVEL     CLDATE        DATE7
     C                   Z-ADD     CLCYMD        SWD(7)
      ** WEEK 8
     C                   ADD       7             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##MDY         CHAIN     FCALEN                             92
     C                   Z-ADD     CLWEEK        WEEK8
     C                   MOVEL     CLDATE        DATE8
     C                   Z-ADD     CLCYMD        SWD(8)
      ** WEEK 9
     C                   ADD       7             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##MDY         CHAIN     FCALEN                             92
     C                   Z-ADD     CLWEEK        WEEK9
     C                   MOVEL     CLDATE        DATE9
     C                   Z-ADD     CLCYMD        SWD(9)
      ** WEEK 10
     C                   ADD       7             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##MDY         CHAIN     FCALEN                             92
     C                   Z-ADD     CLWEEK        WEEK10
     C                   MOVEL     CLDATE        DATE10
     C                   Z-ADD     CLCYMD        SWD(10)
     C                   ENDSR
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
     C     CLLOOK        ANDGE     ALPHA
     C                   Z-ADD     RECNO         PAGE#
     C                   GOTO      ENDPAG
     C                   END
     C                   GOTO      NXTPAG
     C     ENDPAG        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
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
     C                   Z-ADD     BEGDAT        SOWDAT
     C                   Z-ADD     10            WEEKS
     C                   ENDSR
** Messages
No Item Number Found                           1
Alphabetic Sequence                            2
Numeric Sequence                               3
  *** Total On-Hand ***                        4
