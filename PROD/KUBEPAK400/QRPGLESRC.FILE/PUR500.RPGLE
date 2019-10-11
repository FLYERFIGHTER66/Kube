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
      **PROGRAM NAME-------- PUR500
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- FINAL TRUCK SCHEDULE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  2/15/02 EFD DO NOT ASSIGN STOPS. PER BILL
      *
     FPUR500FM  CF   E             WORKSTN
     F                                     SFILE(DETSFL:RECNO)
     FFPUHDRHR  UF   E           K DISK
     FFPUHDRHE  UF A E           K DISK
     F                                     RENAME(RPUHDRH:TRHDRH)
     FFPUSCHDT  UF   E           K DISK
     F                                     RENAME(RPUSCHD:TRSCHR)
     FFPUSCHDS  UF A E           K DISK
     FFPUSTAT   UF   E           K DISK
     FFHORDR    UF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFCUSTCOM  IF   E           K DISK
     FFOECTL    IF   E           K DISK
     FFCALENCY  IF   E           K DISK
     F                                     RENAME(RCALEN:CALEN)
     FFCALEX    IF   E           K DISK
     FFCMDIR    UF A E           K DISK
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$NeedDir
    ?D/COPY QFunctDefn,$isNote
    ?D/COPY QFunctDefn,$Notes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$MDYDate

      *MESSAGE ARRAYS
     D MSG             S              9    DIM(7) CTDATA PERRCD(1)              DAY NAMES
      *SCREEN C ARRAYS
     D DAY             S              1  0 DIM(9)                               DAY #
     D ROT             S              4    DIM(9)                               TRUCK #
     D STP             S              2  0 DIM(9)                               STOP #
     D Q1              S              4  0 DIM(9)                               QTY1
     D Q2              S              4  0 DIM(9)                               QTY2
     D Q3              S              4  0 DIM(9)                               QTY3
     D Q4              S              4  0 DIM(9)                               QTY4
      *DATE ARRAY
     D DAT             S              7  0 DIM(9)                               DATES CYMD FOR WK
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
     D  LCO                    1      2  0                                      ARC380
WJB01D  UDSEXT              1000   1000                                         External Parms Provi
WJB01D  UDSDAT              1001   1004P 0                                      External Date
WJB01D  UDSTRK              1005   1008                                         External Truck

     D                 DS
     D  HDG1
     D  HDG2
     D  HDG3
     D  HDG4
     D  HDG1A                              Like(HDG1) Overlay(HDG1)
     D  HDG2A                              Like(HDG2) Overlay(HDG2)
     D  HDG3A                              Like(HDG3) Overlay(HDG3)
     D  HDG4A                              Like(HDG4) Overlay(HDG4)

     D  SaveCNAME      S                   Like(CNAME)

     D  PrevName       S                   Like(CNAME)
     D  NewSeq         S                   Like(SEQ)
     D  Y              S              4S 0

     D   SFLREC_SORT   S                   Like(SFLREC) Dim(250) ASCEND
     D   SFLREC        DS                  Inz
     D  CNAME
     D  TRSEQ#
     D  TRSHDT
     D  TRCUST
     D  TRDLVC
     D  TRDLVN
     D  TRDLVT
     D  TRDLVU
     D  TRCODC
     D  TRCODN
     D  TRCODT
     D  TRCODU
     D  TRCOD$
     D  CMCUST
     D  CMNAME
     D  CMADD2
     D  CMADD3
     D  CMADD4
     D  CMCITY
     D  CMSTST
     D  CMZIP
     D  THDRIV
     D  THSTOP
     D  OPTION
     D  SEQ
     D  TRORD#
     D  TRCUST4
     D  CMFILL
     D  CODES
     D  CITY
     D  QTY1
     D  QTY2
     D  QTY4
     D  QTY3

      ** TRUCK HEADER RENAME FOR ADD
     ITRHDRH
     I              THTRK#                      NTRK#
     I              THSHDT                      NSHDT
     I              THDRIV                      NDRIV
     I              THSTOP                      NSTOP
     I              THROUT                      NROUT
     I              THCOMM                      NCOMM
      ** SCREEN C
     ISCRNC
     I              DAY1                        DAY(1)
     I              DAY2                        DAY(2)
     I              DAY3                        DAY(3)
     I              DAY4                        DAY(4)
     I              DAY5                        DAY(5)
     I              DAY6                        DAY(6)
     I              DAY7                        DAY(7)
     I              DAY8                        DAY(8)
     I              DAY9                        DAY(9)
     I              ROUT1                       ROT(1)
     I              ROUT2                       ROT(2)
     I              ROUT3                       ROT(3)
     I              ROUT4                       ROT(4)
     I              ROUT5                       ROT(5)
     I              ROUT6                       ROT(6)
     I              ROUT7                       ROT(7)
     I              ROUT8                       ROT(8)
     I              ROUT9                       ROT(9)
     I              STOP1                       STP(1)
     I              STOP2                       STP(2)
     I              STOP3                       STP(3)
     I              STOP4                       STP(4)
     I              STOP5                       STP(5)
     I              STOP6                       STP(6)
     I              STOP7                       STP(7)
     I              STOP8                       STP(8)
     I              STOP9                       STP(9)
     I              QTY11                       Q1(1)
     I              QTY12                       Q1(2)
     I              QTY13                       Q1(3)
     I              QTY14                       Q1(4)
     I              QTY15                       Q1(5)
     I              QTY16                       Q1(6)
     I              QTY17                       Q1(7)
     I              QTY18                       Q1(8)
     I              QTY19                       Q1(9)
     I              QTY21                       Q2(1)
     I              QTY22                       Q2(2)
     I              QTY23                       Q2(3)
     I              QTY24                       Q2(4)
     I              QTY25                       Q2(5)
     I              QTY26                       Q2(6)
     I              QTY27                       Q2(7)
     I              QTY28                       Q2(8)
     I              QTY29                       Q2(9)
     I              QTY31                       Q3(1)
     I              QTY32                       Q3(2)
     I              QTY33                       Q3(3)
     I              QTY34                       Q3(4)
     I              QTY35                       Q3(5)
     I              QTY36                       Q3(6)
     I              QTY37                       Q3(7)
     I              QTY38                       Q3(8)
     I              QTY39                       Q3(9)
     I              QTY41                       Q4(1)
     I              QTY42                       Q4(2)
     I              QTY43                       Q4(3)
     I              QTY44                       Q4(4)
     I              QTY45                       Q4(5)
     I              QTY46                       Q4(6)
     I              QTY47                       Q4(7)
     I              QTY48                       Q4(8)
     I              QTY49                       Q4(9)
      ***********************
      ** SCREEN A ROUTINE  **
      ***********************
     C     RSTART        TAG
     C                   UNLOCK    FPUHDRHR
     C                   UNLOCK    FPUHDRHE
     C                   UNLOCK    FPUSCHDT
     C                   UNLOCK    FPUSCHDS
     C                   UNLOCK    FPUSTAT
     C                   CLEAR                   *IN
     C     NXTA          TAG
     C                   If        UDSEXT <> ' '
WJB01C                   SUB       1000000       UDSDAT
WJB01C     100.0001      MULT      UDSDAT        SHPDAT
WJB01C                   MOVE      UDSTRK        TRUCK
WJB01C                   MOVE      *Blanks       UDSEXT
     C                   Else
WJB01C                   WRITE     SCRNA
WJB01C                   READ      SCRNA                                  90
     C                   EndIf
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC              GOTO      END
     C                   SETOFF                                       102030
      ** CHECK DATE
     C                   Z-ADD     SHPDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     ##CYMD        THSHDT
     C     TRUCK         IFLE      *BLANKS
     C                   SETON                                        2030
     C                   GOTO      NXTA
     C                   END
      ** SEE IF SEARCH NEEDED
     C                   MOVEL     TRUCK         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C**                   Z-ADDSHPDAT    WKDATE  60
     C                   CALL      'PUR220'
     C                   PARM                    SHPDAT
     C                   PARM                    TRUCK             4
     C                   PARM                    ROUT              2
     C     TRUCK         IFLE      *BLANKS
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     SHPDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        THSHDT
     C                   ENDIF
      ** NOW SEE IF ROUT  ENTERED
     C     ROUTKY        KLIST
     C                   KFLD                    THSHDT
     C                   KFLD                    TRUCK
     C     ROUTKY        CHAIN(N)  FPUHDRHR                           30
     C   30
     CAN KD              DO
      ** ADD A TRUCK
     C                   CLEAR                   TRHDRH
     C                   Z-ADD     THSHDT        NSHDT
     C                   MOVEL     TRUCK         NROUT
     C                   MOVEL     TRUCK         NTRK#
wjb  C* Removed per Bill MOVEL     'ADDED TR'    WRK16            16
wjb  C*   06/07/2004     MOVE      'UCK     '    WRK16
wjb  C                   MOVEL     *Blanks       NCOMM
wjb  C                   MOVEL     '8:00am'      THSTOP
wjb  C                   MOVEL     '8:00am'      NSTOP
     C                   WRITE     TRHDRH
     C     ROUTKY        CHAIN(N)  FPUHDRHR                           30
     C                   ENDDO                                                  30 KD  DO
     C   30              GOTO      NXTA
      ** IF HERE ALL OK ON SCRNA
     C     THSHDT        CHAIN     FCALENCY                           90
     C                   Z-ADD     CL#Y          DAY#              1 0
     C                   MOVEL     MSG(DAY#)     DAYNM
      ** BUILD DATE ARRAY FOR ADDS
     C                   Z-ADD     0             DAT
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    D
     C                   Z-ADD     0             D                 1 0
     C     D             DOUEQ     7
     C                   ADD       1             D
     C     CALKEY        CHAIN     FCALEX                             90
     C                   Z-ADD     CLCYMD        DAT(D)
     C                   ENDDO
     C                   If        CLWEEK = 1
     C                   Eval      CLWEEK = 55
     C                   Eval      CLYEAR = CLYEAR - 1
     C                   EndIf
     C                   Eval      D = 6
     C                   DoU       not *In90 or CLWEEK < 1
     C                   Eval      CLWEEK = CLWEEK - 1
     C     CALKEY        CHAIN     FCALEX                             90
     C                   EndDo
     C                   Z-ADD     CLCYMD        DAT(8)
     C                   Eval      D = 7
     C     CALKEY        CHAIN     FCALEX                             90
     C                   Z-ADD     CLCYMD        DAT(9)
     C                   EXSR      BLDSFL
     C*****      ROUTKY    CHAINFTRHDRHR             30
     C     NXTFMT        TAG
     C     ROUTKY        CHAIN     FPUHDRHR                           30
     C                   SETOFF                                       59
     C     PAGE#         IFLE      0
     C                   Z-ADD     1             PAGE#
     C                   END
     C                   EXFMT     DETCTL
     C                   UPDATE    RPUHDRH
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC              GOTO      END
      ** MOVE TO NEW ROUT
     C   KK              DO
     C                   EXSR      MVRT
     C                   GOTO      RSTART
     C                   END
      ** ADD A LINE
     C   KE              DO
     C                   EXSR      ADDLIN
     C                   EXSR      BLDSFL
     C                   GOTO      NXTFMT
     C                   END
      ** delivery confirmation
     C   KL              DO
     C                   EXSR      DELCONFA
     C                   EXSR      CHKSFL
     C                   EXSR      BLDSFL
     C                   GOTO      NXTFMT
     C                   END
      ** CF07 Alphabetize
     C   KG              DO
     C                   EXSR      ALPHASORT
     C                   GOTO      NXTFMT
     C                   END
      ** CF08 Resequence
     C   KH              DO
     C                   EXSR      RESEQ
     C                   EXSR      CHKSFL
     C                   EXSR      BLDSFL
     C                   GOTO      NXTFMT
     C                   END
      ** COD confirmation
     C   KI              DO
     C                   EXSR      CODCONF
     C                   GOTO      NXTFMT
     C                   END
      ** DELETE ROUT?
     C   KJ              DO
     C     NOTKJ         TAG
     C                   SETON                                        59
     C                   EXFMT     DETCTL
     C   KF              GOTO      RSTART
     C  NKJ              GOTO      NOTKJ
     C                   EXSR      DELTRK
     C                   GOTO      RSTART
     C                   ENDDO                                                  KJ DO
      ** CHECK SUB FILE
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTFMT
     C                   EXSR      BLDSFL
      ** DO NOT NEED CAN'T CHANGE TRUCK NUMBER HERE
     C**                   EXSR GETTRK
     C                   GOTO      NXTFMT
      ** END JOB
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** delivery confir all Lines
      ***********************
     C     DELCONFA      BEGSR
     C                   Eval      Line = 1
     C                   DoW       Line <= LSTREC
     C                   ExSr      DELCONF
     C                   Eval      Line = Line + 1
     C                   EndDo
     C                   ENDSR
      ***********************
      ** delivery confirmation
      ***********************
     C     DELCONF       BEGSR
     C     LINE          CHAIN     DETSFL                             90
     C                   If        TRORD# <> *Zero
     C                   Eval      VIEW_ORDER = 'View Order ' + %Char(TRORD#)
     C                   Else
     C                   Eval      VIEW_ORDER = 'No Order Available'
     C                   EndIf
     C                   If        not *In90 and TRCUST <> *Zero
     C                   Eval      OPTION = ' '

     C                   Eval      KEYVAL = *Blanks
     C                   MoveL     TRCUST        KEYVAL           25
     C                   Eval      *In28 = $NeedDir(TRCUST)
     C                   Eval      *In29 = $isNote('FMCUST':KEYVAL)

     C                   If        TRDLVU = *Blanks
     C                   Eval      TRDLVT = $TimeStamp()
     C                   Eval      TRDLVU = $User()
     C                   EndIf
     C                   Move      TRDLVT        DLVTDATE
     C                   Move      TRDLVT        DLVTTIME

     C     DSPDEL        TAG
     C  N90              EXFMT     CONFDEL

     C                   Select

     C                   When      GETORD = 1
     C                   Call      'BIR100CLO'
     C                   Parm                    TRORD#
     C                   Parm                    SEQ#              3 0
     C                   Goto      DSPDEL

     C                   When      GETNOTES = 1 or GETNOTES = 2
     C                   Eval      KEYVAL = *Blanks
     C                   MoveL     TRCUST        KEYVAL           25
     C                   CallP     $Notes('FMCUST':KEYVAL)
     C                   Goto      DSPDEL

     C                   When      MOVEDAY <> 0
     C                   Z-ADD     SEQ           STOP
     C                   EXSR      MOVESR
     C                   Goto      DSPDEL

     C                   When      *InKL
     C                   Eval      *In90 = *On

     C                   When      *InKH
     C                   Eval      TRDLVN = 'VOICEMAIL'
     C                   Goto      UPDDELCONF

     C                   When      *InKB
     C                   Goto      UPDDELCONF

     C                   Other
     C                   Goto      DSPDEL

     C                   EndSl

     C     UPDDELCONF    TAG
     C                   If        TRDLVN <> *Blanks
     C                   Eval      TRDLVT = $TimeStamp()
     C                   Eval      TRDLVU = $User()
     C                   If        TRDLVN = 'VOICEMAIL'
     C                   Eval      TRDLVC = ' '
     C                   Eval      %Subst(Codes:2:1)='V'
     C                   Else
     C                   Eval      TRDLVC = 'Y'
     C                   Eval      %Subst(Codes:2:1)='C'
     C                   EndIf
     C                   Else
     C                   Eval      TRDLVC = *Blanks
     C                   Clear                   TRDLVT
     C                   Eval      TRDLVU = *Blanks
     C                   EndIf

     C                   If        %subst(CODES:1:1)<>'D' or
     C                             %subst(CODES:2:1)<>'C'
     C                   Eval      *In97 = *On
     C                   Else
     C                   Eval      *In97 = *Off
     C                   EndIf
     C  N90              Update    DETSFL
     C                   EndIf
     C                   ENDSR
      ***********************
      ** Alpha -  Alphabetize Subroutine
      ***********************
     C     ALPHASORT     BEGSR
     C                   Eval      RECNO = 1
     C                   Clear                   SFLREC_SORT
     C     RECNO         Chain     DETSFL
     C                   DoW       %FOUND(PUR500FM)
     C                   Eval      SFLREC_SORT(RECNO) = SFLREC
     C                   Eval      RECNO = RECNO + 1
     C     RECNO         Chain     DETSFL
     C                   EndDo
     C                   SortA     SFLREC_SORT
      *  Find first non-blank array element and reload the subfile from there.
     C                   Eval      Y = 1
     C                   DoW       %Subst(SFLREC_SORT(Y):1:10) = *Blanks
     C                   Eval      Y = Y + 1
     C                   EndDo
      *  Now Reload the Subfile from the Array
     C                   Eval      RECNO = 1
     C     RECNO         Chain     DETSFL
     C                   DoW       Y <= %Elem(SFLREC_SORT)
     C                   Eval      SFLREC = SFLREC_SORT(Y)
     C                   Update    DETSFL
     C                   Eval      RECNO = RECNO + 1
     C                   Eval      Y = Y + 1
     C     RECNO         Chain     DETSFL
     C                   EndDo
     C                   ENDSR
      ***********************
      ** Resequence - Resequence Subroutine
      ***********************
     C     RESEQ         BEGSR
     C                   Eval      RECNO = 1
     C                   Eval      NewSeq = 0
     C                   Eval      PrevName = *Blanks
     C     RECNO         Chain     DETSFL
     C                   DoW       %FOUND(PUR500FM)
     C                   If        CNAME <> PrevName
     C                   If        NewSeq < 99
     C                   Eval      NewSeq = NewSeq + 1
     C                   EndIf
     C                   Eval      PrevName = CNAME
     C                   EndIf
     C                   Eval      SEQ = NewSeq
     C                   Update    DETSFL
     C                   Eval      RECNO = RECNO + 1
     C     RECNO         Chain     DETSFL
     C                   EndDo
     C                   ENDSR
      ***********************
      ** Directions
      ***********************
     C     DIRECTIONS    BEGSR
     C     RSTRTH        TAG
     C     CMCUST        CHAIN     FCMDIR                             94
     C   94              DO
     C                   MOVE      *BLANKS       CMCOR1
     C                   MOVE      *BLANKS       CMCOR2
     C                   MOVE      *BLANKS       CMDR01
     C                   MOVE      *BLANKS       CMDR02
     C                   MOVE      *BLANKS       CMDR03
     C                   MOVE      *BLANKS       CMDR04
     C                   MOVE      *BLANKS       CMDR05
     C                   MOVE      *BLANKS       CMDR06
     C                   MOVE      *BLANKS       CMDR07
     C                   MOVE      *BLANKS       CMDR08
     C                   MOVE      *BLANKS       CMDR09
     C                   MOVE      *BLANKS       CMDR10
     C                   MOVE      *BLANKS       CMDR11
     C                   ENDDO
      *
     C                   WRITE     SCRNH
     C                   Z-ADD     0             CNT               2 0
     C                   READ      SCRNH                                  90
      *
     C   KC              SETON                                        LR
     C   KC              GOTO      END
      *
     C                   MOVEL     'A'           CMSTAT
     C   94CMCOR1        IFGT      *BLANKS
     C     CMCOR2        ORGT      *BLANKS
     C     CMDR01        ORGT      *BLANKS
     C     CMDR02        ORGT      *BLANKS
     C     CMDR03        ORGT      *BLANKS
     C     CMDR04        ORGT      *BLANKS
     C     CMDR05        ORGT      *BLANKS
     C     CMDR06        ORGT      *BLANKS
     C     CMDR07        ORGT      *BLANKS
     C     CMDR08        ORGT      *BLANKS
     C     CMDR09        ORGT      *BLANKS
     C     CMDR10        ORGT      *BLANKS
     C     CMDR11        ORGT      *BLANKS
     C                   WRITE     RCMDIR
     C                   ENDIF
     C  N94              UPDATE    RCMDIR
      *
     C                   ENDSR
      ***********************
      ** COD confirmation
      ***********************
     C     CODCONF       BEGSR
     C     LINE          CHAIN     DETSFL                             90
     C                   If        TRCODU = *Blanks
     C                   Eval      TRCODT = $TimeStamp()
     C                   Eval      TRCODU = $User()
     C                   EndIf
     C                   Move      TRCODT        CODTDATE
     C                   Move      TRCODT        CODTTIME
     C     DSPCOD        TAG
     C  N90              EXFMT     CONFCOD
     C                   Eval      *In92 = *Off
     C                   If        *InKL
     C                   Eval      *In90 = *On
     C                   Else
     C                   If        TRCODN <> *Blanks
     C                   If        TRCOD$ <> *Zero
     C                   Eval      TRCODT = $TimeStamp()
     C                   Eval      TRCODU = $User()
     C                   Else
     C                   Eval      *In92 = *On
     C                   Goto      DSPCOD
     C                   EndIf
     C                   Else
     C                   Eval      TRCODC = *Blanks
     C                   Clear                   TRDLVT
     C                   Eval      TRCODU = *Blanks
     C                   Eval      TRCOD$ = *Zeros
     C                   EndIf
     C                   EndIf
     C  N90              Update    DETSFL
     C  N90              EXSR      CHKSFL
     C                   EXSR      BLDSFL
     C                   ENDSR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     DETCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             STOP#             3 0
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             TOTC1
     C                   Z-ADD     0             TOTC2
     C                   Z-ADD     0             TOTC3
     C                   Z-ADD     0             TOTC4
     C                   Z-ADD     0             PAGE#
     C                   Z-ADD     0             CROW
     C                   Z-ADD     0             CCOL
     C     TRKKEY        KLIST
     C                   KFLD                    THTRK#
     C                   KFLD                    THSHDT
     C                   SETOFF                                       1011
     C                   SETOFF                                       2021
     C                   SETOFF                                       3031
     C                   SETOFF                                       4041
     C                   MOVE      *BLANKS       OPTION
     C                   Z-ADD     1             NXTSTP            5 0
      ** SETLL ON FILE
     C     TRKKEY        SETLL     FPUSCHDT
     C     NXTBLD        TAG
     C     TRKKEY        READE(N)  FPUSCHDT                               90
     C   90              GOTO      ENDBLD

     C     TRORD#        CHAIN(N)  FHORDR                             96
     C     TRCUST        CHAIN     FMCUST                             91

     C                   If        Not *In96
     C                   Eval      CMNAME  = OHNAME
     C                   Eval      CMADD2  = OHSHP2
     C                   Eval      CMADD3  = OHSHP3
     C                   Eval      CMADD4  = OHSHP4
     C                   Eval      CMCITY  = OHSHCT
     C                   Eval      CMSTST  = OHSHST
     C                   Eval      CMZIP   = OHSHZP
     C                   EndIf

     C                   MOVEL     CMNAME        CNAME
     C                   MOVEL     CMCITY        CITY
     C                   Eval      CITY = %Trim(%Subst(CMCITY:1:%Len(CITY)-3))+
     C                                    ',' + CMSTST

     C                   If        *In91 and *In96
     C                   MOVE      *BLANKS       CNAME
     C                   MOVEL     '*UNKNOWN'    CNAME
     C                   MOVE      *BLANKS       CITY
     C                   MOVE      *BLANKS       CODES
     C                   MOVE      *BLANKS       CMSTST
     C                   MOVE      *BLANKS       CMFILL
     C                   Z-ADD     0             CMPHON
     C                   EndIf                                                   91 DO

     C                   If        SaveCNAME <> CNAME
     C                   Add       1             STOP#
     C                   Eval      SaveCNAME =  CNAME
     C                   EndIf
     C                   Z-Add     STOP#         TRSTP#

     C                   Clear                   RCUSTCOM
     C                   Eval      CCSEQ = 1
     C     COMKEY        KList
     C                   KFld                    TRCUST
     C                   KFld                    CCSEQ
     C     COMKEY        CHAIN     FCUSTCOM

      *  Codes ....................
     C                   Eval      Codes = *Blanks
     C                   If        not $NeedDir(TRCUST)
     C                   Eval      %subst(CODES:1:1)='D'
     C                   EndIf
     C                   If        TRDLVC <> *Blanks
     C                   Eval      %subst(CODES:2:1)='C'
     C                   EndIf
     C                   If        TRDLVN =  'VOICEMAIL'
     C                   Eval      %subst(CODES:2:1)='V'
     C                   EndIf
     C                   If        TRCOD$ <> *Zeros
     C                   Eval      %subst(CODES:3:1)='$'
     C                   EndIf
     C                   If        %subst(CODES:1:1)<>'D' or
     C                             %subst(CODES:2:1)<>'C'
     C                   Eval      *In97 = *On
     C                   Else
     C                   Eval      *In97 = *Off
     C                   EndIf

     C     CMFILL        IFEQ      'NT'
     C                   SETON                                        25
     C                   ELSE
     C                   SETOFF                                       25
     C                   END
     C                   Z-ADD     TRCUST        TRCUST4
     C                   Z-ADD     TRSTOP        SEQ
     C**         SEQ       IFLE 0
     C**                   Z-ADDNXTSTP    SEQ
     C**                   END
     C     SEQ           ADD       1             NXTSTP
     C                   Z-ADD     TRQTY1        QTY1
     C                   Z-ADD     TRQTY2        QTY2
     C                   Z-ADD     TRQTY3        QTY3
     C                   Z-ADD     TRQTY4        QTY4
     C                   ADD       QTY1          TOTC1
     C                   ADD       QTY2          TOTC2
     C                   ADD       QTY3          TOTC3
     C                   ADD       QTY4          TOTC4
     C                   ADD       1             RECNO
     C                   If        TRORD# <> 0
     C                   SetOn                                        15
     C                   Else
     C                   SetOff                                       15
     C                   EndIf
     C                   WRITE     DETSFL
     C                   SETOFF                                       25
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C     RECNO         ADD       15            LSTREC            5 0
     C     RECNO         IFLE      12
     C                   Z-ADD     1             PAGE#
     C                   Z-ADD     RECNO         WRKR
     C                   ELSE
     C                   Z-ADD     RECNO         WRKR
     C     NWRKR         TAG
     C                   SUB       12            WRKR              5 0
     C     WRKR          IFLE      12
     C     WRKR          SUB       11            PAGE#
     C                   ELSE
     C                   GOTO      NWRKR
     C                   END                                                    WRKR<=12
     C                   END                                                    RECNO<=12
     C     WRKR          IFLT      12
     C     WRKR          ADD       12            CROW
     C                   ELSE
     C                   Z-ADD     12            CROW
     C                   END
     C                   Z-ADD     2             CCOL
     C                   Z-ADD     0             TRSEQ#
     C                   Z-ADD     0             STOP#
     C                   Z-ADD     0             TRCUST
     C                   MOVE      *BLANKS       CMFILL
     C                   Z-ADD     0             SEQ
     C                   MOVE      *BLANKS       CNAME
     C                   MOVE      *BLANKS       CITY
     C                   MOVE      *BLANKS       CODES
     C                   MOVE      *BLANKS       CMSTST
     C                   MOVE      *BLANKS       CMFILL
     C                   Z-ADD     0             CMPHON
     C                   Z-ADD     0             TRORD#
     C                   Z-ADD     0             TRCUST4
     C                   Z-ADD     0             QTY1
     C                   Z-ADD     0             QTY2
     C                   Z-ADD     0             QTY3
     C                   Z-ADD     0             QTY4
     C                   SETOFF                                       15
     C     NXTOVR        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFLE      LSTREC
     C                   WRITE     DETSFL
     C                   GOTO      NXTOVR
     C                   END
     C                   ENDSR
      ***********************
      ** CHECK SUB FILE    **
      ***********************
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             PAGE#
     C                   SETOFF                                       102030
     C                   SETOFF                                       40
     C                   SETOFF                                       112131
     C                   SETOFF                                       121314
     C                   SETOFF                                       41  99
      ** CHECK IF ALL INPUT OK THEN DO FUNCTIONS SELECTED
     C     NXTCK1        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCK1
     C                   END
     C     RECNO         CHAIN     DETSFL                             90
     C   90              GOTO      NXTCK1
     C                   SETOFF                                       102030
     C                   SETOFF                                       40
      ** CHECK OPTION
     C     OPTION        IFGT      *BLANKS
     C     OPTION        IFNE      'A'
     C     OPTION        ANDNE     'M'
     C     OPTION        ANDNE     'D'
     C     OPTION        ANDNE     'C'
     C                   SETON                                        101199
     C                   END
     C                   END
      ** ADD A LINE
     C     OPTION        IFEQ      'A'
     C     TRSEQ#        IFGT      0
     C                   SETON                                        101299
     C                   END
     C                   END
      ** MOVE/SPLIT A LINE
     C     OPTION        IFEQ      'M'
     C     TRSEQ#        IFLE      0
     C                   SETON                                        101399
     C                   END
     C                   END
      ** CONFIRM A LINE
     C     OPTION        IFEQ      'C'
     C     TRSEQ#        IFLE      0
     C                   SETON                                        101399
     C                   END
     C                   END
      ** DELETE A LINE
     C     OPTION        IFEQ      'D'
     C     TRSEQ#        IFEQ      0
     C                   SETON                                        101399
     C                   END
     C                   END
     C     CMFILL        IFEQ      'NT'
     C                   SETON                                        25
     C                   ELSE
     C                   SETOFF                                       25
     C                   END
     C                   UPDATE    DETSFL
     C                   SETOFF                                       25
     C                   GOTO      NXTCK1
     C     ENDCK1        TAG
     C   99              GOTO      ENDCK2
      ** IF ALL INPUT OK THEN DO FUNCTIONS SELECTED
     C                   Z-ADD     0             RECNO
     C     NXTCK2        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCK2
     C                   END
     C     RECNO         CHAIN     DETSFL                             90
     C   90              GOTO      NXTCK2
      ** CONFIRM A LINE
     C     OPTION        IFEQ      'C'
     C                   Eval      LINE = RECNO
     C                   EXSR      DELCONF
     C                   Eval      OPTION = ' '
     C                   GOTO      NXTCK2
     C                   END
      ** ADD A LINE
     C     OPTION        IFEQ      'A'
     C     TRSEQ#        IFLE      0
     C                   EXSR      ADDLIN
     C                   GOTO      NXTCK2
     C                   END
     C                   END
      ** MOVE/SPLIT A LINE
     C     OPTION        IFEQ      'M'
     C     TRSEQ#        IFGT      0
     C** 4/11/02           Z-ADDTRSEQ#    STOP
     C                   Z-ADD     SEQ           STOP
     C                   EXSR      MOVESR
     C                   GOTO      NXTCK2
     C                   END
     C                   END
      ** DELETE A LINE
     C     OPTION        IFEQ      'D'
     C     TRSEQ#        IFGT      0
     C                   Z-ADD     TRSEQ#        STOP
     C                   EXSR      DELE
     C                   GOTO      NXTCK2
     C                   END
     C                   END
     C                   GOTO      NXTCK2
      ** OUTPUT RECORDS
     C     ENDCK2        TAG
     C                   Z-ADD     0             RECNO
     C     NXTCK3        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCK3
     C                   END
     C     RECNO         CHAIN     DETSFL                             90
     C   90              GOTO      NXTCK3
     C*          PAGE#     IFLE 0
     C*          TRSEQ#    ANDLE0
     C*                    Z-ADDRECNO     PAGE#
     C*                    END
     C     SCDKEY        CHAIN     FPUSCHDS                           91
     C     RECNO         CHAIN     DETSFL                             90
     C  N91              DO
     C                   If        TRDLVN <> *Blanks and TRDLVN <> 'VOICEMAIL'
     C                   Eval      TRDLVC =  'Y'
     C                   EndIf
     C                   Z-ADD     SEQ           TRSTOP
     C                   Z-ADD     QTY1          TRQTY1
     C                   Z-ADD     QTY2          TRQTY2
     C                   Z-ADD     QTY3          TRQTY3
     C                   Z-ADD     QTY4          TRQTY4
     C     TRORD#        CHAIN     FHORDR
     C                   If        %Found(FHORDR)
     C                   Eval      OHDTCN = $MDYDate($Date(TRSHDT))
     C                   Eval      OHROUT = TRTRK#
     C                   Eval      OHSTOP = TRSTP#
     C                   Update    RHORDR
     C                   EndIf
     C                   UPDATE    RPUSCHD
     C                   ENDDO
     C                   GOTO      NXTCK3
     C     ENDCK3        TAG
     C                   ENDSR
      ***********************
      ** ADD LINE ROUTINE  **
      ***********************
     C     ADDLIN        BEGSR
     C                   SETOFF                                       606162
     C                   MOVE      *BLANKS       CMNAME
     C                   MOVE      *BLANKS       CMCITY
     C                   MOVE      *BLANKS       CMSTST
     C                   MOVE      *BLANKS       CMFILL
     C                   CLEAR                   TRDLVC
     C                   CLEAR                   TRDLVU
     C                   CLEAR                   TRDLVN
     C                   CLEAR                   TRDLVT
     C                   CLEAR                   TRCODC
     C                   CLEAR                   TRCODU
     C                   CLEAR                   TRCODN
     C                   CLEAR                   TRCODT
     C                   CLEAR                   TRCOD$
     C                   Z-ADD     SEQ           STOP
     C                   Z-ADD     0             OCUST             6 0
     C                   Z-ADD     0             OSTOP             2 0
     C                   Z-ADD     0             OQTY1             4 0
     C                   Z-ADD     0             OQTY2             4 0
     C                   Z-ADD     0             OQTY3             4 0
     C                   Z-ADD     0             OQTY4             4 0
     C                   Z-ADD     TRCUST4       OCUST
     C                   Z-ADD     STOP          OSTOP
     C                   Z-ADD     QTY1          OQTY1
     C                   Z-ADD     QTY2          OQTY2
     C                   Z-ADD     QTY3          OQTY3
     C                   Z-ADD     QTY4          OQTY4
     C     TRCUST4       IFGT      0
     C                   Z-ADD     TRCUST4       CMCUST
     C     CMCUST        CHAIN     FMCUST                             60
     C                   ELSE
     C                   Z-ADD     0             CMCUST
     C                   END
     C     NXTADD        TAG
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C                   SETOFF                                       606162
      ** CHECK FOR RESTART
     C   KF              DO
     C                   MOVE      *BLANKS       OPTION
     C                   Z-ADD     0             TRSEQ#
     C                   Z-ADD     0             TRCUST
     C                   Z-ADD     0             SEQ
     C                   MOVE      *BLANKS       CMFILL
     C                   MOVE      *BLANKS       CMNAME
     C                   MOVE      *BLANKS       CMCITY
     C                   MOVE      *BLANKS       CMSTST
     C                   Z-ADD     0             TRCUST4
     C                   Z-ADD     0             CMPHON
     C                   Z-ADD     0             QTY1
     C                   Z-ADD     0             QTY2
     C                   Z-ADD     0             QTY3
     C                   Z-ADD     0             QTY4
     C                   GOTO      ENDADD
     C                   END
     C     TRORD#        IFGT      0
     C     TRORD#        CHAIN(N)  FHORDR                             91
     C                   If        %Found(FHORDR) and OHSTAT = 'A'
     C                   Eval      CMCUST = OHCUST
     C                   Eval      TRCUST = OHCUST
     C     CMCUST        CHAIN     FMCUST                             60
     C                   Else
     C                   Eval      TRORD# = *Zeros
     C                   Eval      CMCUST = *Zeros
     C                   Eval      CMNAME = 'The order# is not Valid'
     C                   Eval      CMCITY = *Blanks
     C                   Eval      CMSTST = *Blanks
     C                   Eval      CMFILL = *Blanks
     C                   GoTo      NXTADD
     C                   EndIf
     C                   Else
      ** CHECK CUSTOMER NUMBER
     C     CMCUST        IFGT      0
     C     CMCUST        CHAIN     FMCUST                             60
     C   60              GOTO      NXTADD
     C                   MOVE      *BLANKS       ALPHA
     C                   END
     C     ALPHA         IFGT      *BLANKS
     C                   MOVEL     ALPHA         CMLOOK           15
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       ALPHA
     C                   GOTO      NXTADD
     C                   ENDIF
     C                   ENDIF
      ** CHECK STOP
     C     STOP          IFLE      0
     C                   SETON                                        62
     C                   GOTO      NXTADD
     C                   END
      *** CHECK QTY'S
     C     QTY1          ADD       QTY2          TSTQTY            5 0
     C                   ADD       QTY3          TSTQTY
     C                   ADD       QTY4          TSTQTY
     C*          TSTQTY    IFLE 0
     C*                    SETON                     63
     C*                    GOTO NXTADD
     C*                    END
      ** SEE IF REDISPLAY
     C     CMCUST        IFNE      OCUST
     C     STOP          ORNE      OSTOP
     C     QTY1          ORNE      OQTY1
     C     QTY2          ORNE      OQTY2
     C     QTY3          ORNE      OQTY3
     C     QTY4          ORNE      OQTY4
     C                   Z-ADD     CMCUST        OCUST
     C                   Z-ADD     STOP          OSTOP
     C                   Z-ADD     QTY1          OQTY1
     C                   Z-ADD     QTY2          OQTY2
     C                   Z-ADD     QTY3          OQTY3
     C                   Z-ADD     QTY4          OQTY4
     C                   GOTO      NXTADD
     C                   ENDIF
     C     ENDADD        TAG
      ** CHECK FOR NOT RESTART THEN UPDATE SUBFILE FIELDS
     C                   MOVE      *BLANKS       OPTION
     C                   Z-ADD     CMCUST        TRCUST
     C                   Z-ADD     CMCUST        TRCUST4
     C                   MOVEL     CMNAME        CNAME
     C                   MOVEL     CMCITY        CITY
     C                   Eval      CITY = %Trim(%Subst(CMCITY:1:%Len(CITY)-3))+
     C                                    ',' + CMSTST
     C                   Z-ADD     STOP          SEQ
     C     CMFILL        IFEQ      'NT'
     C                   SETON                                        25
     C                   ELSE
     C                   SETOFF                                       25
     C                   END
     C**                   UPDATDETSFL
     C                   SETOFF                                       25
     C  NKF              DO
     C     DAT(1)        CHAIN     FPUSTAT                            90
     C                   Z-ADD     STNSEQ        TRSEQ#
     C                   ADD       1             STNSEQ
     C                   UPDATE    RPUSTAT
     C                   MOVEL     THTRK#        TRTRK#
     C                   MOVEL     THROUT        TRROUT
     C                   Z-ADD     THSHDT        TRSHDT
     C                   Z-ADD     STOP          TRSTOP
     C                   Z-ADD     QTY1          TRQTY1
     C                   Z-ADD     QTY2          TRQTY2
     C                   Z-ADD     QTY3          TRQTY3
     C                   Z-ADD     QTY4          TRQTY4
     C                   WRITE     RPUSCHD
     C                   Z-ADD     CMCUST        TRCUST4
     C                   Z-ADD     STOP          SEQ
     C                   MOVE      *BLANKS       OPTION
     C                   MOVEL     CMNAME        CNAME
     C                   MOVEL     CMCITY        CITY
     C                   Eval      CITY = %Trim(%Subst(CMCITY:1:%Len(CITY)-3))+
     C                                    ',' + CMSTST
     C                   ENDDO
     C                   ENDSR
      ***********************
      ** DELETE   ROUTINE  **
      ***********************
     C     DELE          BEGSR
     C                   Z-ADD     TRCUST4       CMCUST
     C     CMCUST        CHAIN     FMCUST                             60
     C     NXTDEL        TAG
     C                   WRITE     SCRND
     C                   READ      SCRND                                  90
      ** CHECK F KEYS
     C   KF              DO
     C                   MOVE      *BLANKS       OPTION
     C                   UPDATE    DETSFL
     C                   GOTO      ENDDEL
     C                   ENDDO
     C  NKJ              GOTO      NXTDEL
      ** IF HERE DELETE LINE
     C     SCDKEY        KLIST
     C                   KFLD                    TRSHDT
     C                   KFLD                    TRSEQ#
     C     SCDKEY        CHAIN     FPUSCHDS                           91
     C  N91              DELETE    RPUSCHD
     C                   CLEAR                   DETSFL
     C                   SETON                                        01
     C                   UPDATE    DETSFL
     C                   SETOFF                                       01
     C     ENDDEL        ENDSR
      ***********************
      ** DELETE TRUCK      **
      ***********************
     C     DELTRK        BEGSR
      ** SETLL ON FILE
     C     TRKKEY        SETLL     FPUSCHDT
     C     NXTDTK        TAG
     C     TRKKEY        READE     FPUSCHDT                               90
     C   90              GOTO      ENDDTK
     C                   DELETE    TRSCHR
     C                   GOTO      NXTDTK
     C     ENDDTK        TAG
     C     ROUTKY        CHAIN     FPUHDRHR                           30
     C  N30              DELETE    RPUHDRH
     C                   ENDSR
      ***********************
      ** MOVE/SPLIT LINE   **
      ***********************
     C     MOVESR        BEGSR
     C                   Z-ADD     TRCUST4       CMCUST
     C                   Z-ADD     TRSEQ#        OTRSEQ
     C     CMCUST        CHAIN     FMCUST                             60
     C     CMFILL        IFEQ      'NT'
     C                   SETON                                        25
     C                   ELSE
     C                   SETOFF                                       25
     C                   END
     C                   Z-ADD     0             STP
     C                   Z-ADD     0             Q1
     C                   Z-ADD     0             Q2
     C                   Z-ADD     0             Q3
     C                   Z-ADD     0             DAY
     C                   MOVE      *BLANKS       ROT
     C                   Z-ADD     DAY#          DAY(1)
     C*                    MOVELTRROUT    ROT,1
     C                   MOVEL     TRTRK#        ROT(1)
     C                   Z-ADD     STOP          STP(1)
     C                   Z-ADD     QTY1          Q1(1)
     C                   Z-ADD     QTY2          Q2(1)
     C                   Z-ADD     QTY3          Q3(1)
     C                   Z-ADD     QTY4          Q4(1)
      ** RESET INDICATORS
     C                   MOVEA     '00000000'    *IN(50)
     C                   MOVEA     '00000000'    *IN(58)
     C                   MOVEA     '00000000'    *IN(66)
     C                   MOVEA     '00000000'    *IN(74)
     C                   MOVEA     '00000000'    *IN(82)
     C                   SETOFF                                       9899
     C     NXTMOV        TAG
     C   99              SETOFF                                       98
     C                   XFOOT     Q1            TOTQ1
     C                   XFOOT     Q2            TOTQ2
     C                   XFOOT     Q3            TOTQ3
     C                   XFOOT     Q4            TOTQ4
     C                   WRITE     SCRNC
     C                   READ      SCRNC                                  90
      ** CHECK F KEYS
     C   KF              DO
     C                   MOVE      *BLANKS       OPTION
     C                   UPDATE    DETSFL
     C                   GOTO      ENDMOV
     C                   ENDDO
      ** RESET INDICATORS
     C                   MOVEA     '00000000'    *IN(50)
     C                   MOVEA     '00000000'    *IN(58)
     C                   MOVEA     '00000000'    *IN(66)
     C                   MOVEA     '00000000'    *IN(74)
     C                   MOVEA     '00000000'    *IN(82)
     C                   SETOFF                                       99
      ** CHECK FIELDS
     C                   Z-ADD     0             X                 2 0
     C                   Z-ADD     0             X5                2 0
     C                   Z-ADD     0             X6                2 0
     C                   Z-ADD     0             X7                2 0
     C                   Z-ADD     0             X8                2 0
     C     NXTX          TAG
     C                   ADD       1             X
     C     X             IFLE      9
      ** IF QTY MUST HAVE ROUT AND STOP
     C     Q1(X)         IFGT      0
     C     Q2(X)         ORGT      0
     C     Q3(X)         ORGT      0
     C     Q4(X)         ORGT      0
     C     ROT(X)        IFLE      *BLANKS
     C     X             ADD       60            X6
     C                   MOVE      '1'           *IN(X6)
     C                   SETON                                        99
     C                   ENDIF                                                  ROT=" "
     C     DAY(X)        IFLE      0
     C     DAY(X)        ORGT      9
     C     X             ADD       50            X5
     C                   MOVE      '1'           *IN(X5)
     C                   SETON                                        99
     C                   ENDIF                                                  DAY=0
     C     STP(X)        IFLE      0
     C     X             ADD       70            X7
     C                   MOVE      '1'           *IN(X7)
     C                   MOVE      '1'           *IN(70)
     C                   SETON                                        99
     C                   ENDIF                                                  STP = 0
     C                   ENDIF                                                  QTY > 0
      ** IF ROUT AND STOP MUST HAVE QTY
     C     DAY(X)        IFGT      0
     C     ROT(X)        ORGT      *BLANKS
     C     STP(X)        IFLE      0
     C     70            ADD       X             X7
     C                   MOVEL     '1'           *IN(X7)
     C                   MOVEL     '1'           *IN(70)
     C                   SETON                                        99
     C                   ENDIF                                                  STP=0
     C     Q1(X)         IFLE      0
     C     Q2(X)         ANDLE     0
     C     Q3(X)         ANDLE     0
     C     Q4(X)         ANDLE     0
     C     80            ADD       X             X8
     C                   MOVEL     '1'           *IN(X8)
     C                   MOVEL     '1'           *IN(80)
     C                   SETON                                        99
     C                   ENDIF                                                  QTY=0
     C                   ENDIF                                                  TRK/ROT>0
      ** SEE IF WE NEED LOOK UP
     C                   MOVEL     ROT(X)        TST1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   Z-ADD     SHPDAT        WKDATE            6 0
     C                   CALL      'PUR220'
     C                   PARM                    WKDATE
     C                   PARM                    TRUCK             4
     C                   PARM                    ROUT              2
     C     ROUT          IFGT      *BLANKS
     C                   MOVEL     TRUCK         ROT(X)
     C                   Z-ADD     WKDATE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
     C                   Z-ADD     #Y            DAY(X)
     C     X             ADD       50            X5
     C                   MOVE      '0'           *IN(X5)
     C                   ELSE
     C                   MOVE      *BLANKS       ROT(X)
     C                   END                                                    ROUT>' '
     C                   END                                                    TST1='?'
     C                   GOTO      NXTX
     C                   ENDIF                                                  X < 9
     C   99              GOTO      NXTMOV
      ** CHECK IF ROUTS EXIST
     C                   MOVEL     '0'           S60               1
     C   60              MOVEL     '1'           S60               1
     C                   SETOFF                                       60
     C                   Z-ADD     1             X
     C     NXRCK         TAG
     C     ROT(X)        IFGT      *BLANKS
     C     RTTSTK        KLIST
     C                   KFLD                    DAT(D)
     C                   KFLD                    ROT(X)
     C                   Z-ADD     DAY(X)        D
     C     RTTSTK        CHAIN     FPUHDRHE                           90
     C   90              DO
     C     X             ADD       60            X6
     C                   MOVE      '1'           *IN(X6)
     C                   SETON                                        60
     C                   ENDDO
     C                   END                                                    ROT,X>" "
     C                   ADD       1             X
     C     X             IFLE      9
     C                   GOTO      NXRCK
     C                   END
     C                   XFOOT     Q1            TOTQ1
     C                   XFOOT     Q2            TOTQ2
     C                   XFOOT     Q3            TOTQ3
     C                   XFOOT     Q4            TOTQ4
     C     TOTQ1         IFNE      QTY1
     C     TOTQ2         ORNE      QTY2
     C     TOTQ3         ORNE      QTY3
     C     TOTQ4         ORNE      QTY4
     C                   SETON                                        80
     C                   END
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTMOV
     C                   ENDDO
     C   80
     CANNKD              GOTO      NXTMOV
     C   60
     CANNKD              GOTO      NXTMOV
      ** NOW OUTPUT ANY CHANGES OR ADDS
      ** FIRST GET RID OF ORIGINAL RECORD
     C                   Z-ADD     OTRSEQ        TRSEQ#
     C     SCDKEY        CHAIN     FPUSCHDS                           91
     C  N91              DELETE    RPUSCHD
      ** NOW OUTPUT RECORDS
     C                   Z-ADD     1             X
     C     NXOUT         TAG
     C     ROT(X)        IFGT      *BLANKS
     C                   Z-ADD     DAY(X)        D
4/12 C     RTTSTK        CHAIN(N)  FPUHDRHE                           90
     C   90              DO
     C                   CLEAR                   TRHDRH
     C                   Z-ADD     DAT(D)        NSHDT
     C                   MOVEL     ROT(X)        NROUT
     C                   MOVEL     ROT(X)        NTRK#
wjb  C*  Removed per     MOVEL     'ADDED FO'    WRK16            16
wjb  C*  Bill S.         MOVE      'R MOVE  '    WRK16
wjb  C*  06/07/2004      MOVEL     WRK16         NCOMM
wjb  C                   MOVE      *Blanks       NCOMM
     C                   WRITE     TRHDRH
     C                   ENDDO
     C     DAT(1)        CHAIN     FPUSTAT                            90
     C                   Z-ADD     STNSEQ        TRSEQ#
     C                   ADD       1             STNSEQ
     C  N90              UPDATE    RPUSTAT
     C                   MOVEL     ROT(X)        TRTRK#
     C                   Z-ADD     DAT(D)        TRSHDT
     C                   Z-ADD     CMCUST        TRCUST
     C                   Z-ADD     STP(X)        TRSTOP
     C                   Z-ADD     Q1(X)         TRQTY1
     C                   Z-ADD     Q2(X)         TRQTY2
     C                   Z-ADD     Q3(X)         TRQTY3
     C                   Z-ADD     Q4(X)         TRQTY4
     C                   MOVEL     ROT(X)        TRROUT
     C                   WRITE     RPUSCHD
     C                   END
     C                   ADD       1             X
     C     X             IFLE      9
     C                   GOTO      NXOUT
     C                   END
     C                   CLEAR                   DETSFL
     C     ENDMOV        ENDSR
      **************************
      ** MOVE ALL TO NEW TRUCK *
      **************************
     C     MVRT          BEGSR
     C                   Z-ADD     SHPDAT        NSHPDT
     C                   SETOFF                                       101112
     C                   SETOFF                                       202130
     C                   SETOFF                                       9998
     C                   Z-ADD     0             OSHPDT            6 0
     C                   MOVE      *BLANKS       OROUT             2
     C                   MOVE      *BLANKS       NROUT
     C                   MOVE      *BLANKS       OTRUCK            4
     C                   MOVE      *BLANKS       NTRUCK
     C     NXTVRT        TAG
     C                   WRITE     SCRNT
     C   99              SETOFF                                       98
     C                   READ      SCRNT                                  90
      ** CHECK F KEYS
     C   KF              GOTO      ENDVRT
     C                   SETOFF                                       101112
     C                   SETOFF                                       202130
     C                   SETOFF                                       99
      ** CHECK DATE
     C                   Z-ADD     NSHPDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1099
     C                   Z-ADD     0             OSHPDT
     C                   GOTO      NXTVRT
     C                   END
      ** CAN'T BE LESS THAN last saturday
     C                   Z-add     ##CYMD        NewDate7          7 0
     C     ##CYMD        IFLT      DAT(8)
     C                   SETON                                        101199
     C                   Z-ADD     0             OSHPDT
     C                   GOTO      NXTVRT
     C                   END
     C                   Z-ADD     ##CYMD        NSCYMD            7 0
      ** CHECK IF WE NEED SEARCH
     C                   MOVEL     NROUT         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   CALL      'PUR220'
     C                   PARM                    NSHPDT
     C                   PARM                    TRUCK             4
     C                   PARM                    NROUT
     C     NTRUCK        IFLE      *BLANKS
     C                   GOTO      NXTVRT
     C                   END
     C                   Z-ADD     NSHPDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        NSCYMD            7 0
     C                   ENDIF
      ** NOW SEE IF ROUT  ENTERED
     C     NSCYMD        CHAIN     FCALENCY                           90
     C                   Z-ADD     CL#Y          DAY#              1 0
     C                   MOVEL     MSG(DAY#)     DAYNM
     C     ROUTKN        KLIST
     C                   KFLD                    NSCYMD
     C                   KFLD                    NTRUCK
     C     ROUTKN        CHAIN(N)  FPUHDRHR                           30
     C   30
     CANNKD              GOTO      NXTVRT
      ** SEE IF CHANGED
     C     NTRK#         IFEQ      TRUCK
     C     NSHPDT        ANDEQ     SHPDAT
     C                   SETON                                        102021
     C                   SETON                                        99
     C                   GOTO      NXTVRT
     C                   END
     C     NTRUCK        IFNE      OTRUCK
     C     NSHPDT        ORNE      OSHPDT
     C                   SETOFF                                       98
     C                   MOVEL     NTRUCK        OTRUCK
     C                   Z-ADD     NSHPDT        OSHPDT
     C                   END
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTVRT
     C                   ENDDO
      ** DELETE OLD TRUCK
     C     ROUTKY        CHAIN     FPUHDRHR                           31
     C  N31              DELETE    RPUHDRH
      ** ADD NEW TRUCK
     C   30              DO
     C                   CLEAR                   TRHDRH
     C                   Z-ADD     DAT(DAY#)     NSHDT
     C                   Z-ADD     NewDate7      NSHDT
     C                   MOVEL     NTRUCK        NROUT
     C                   MOVEL     NTRUCK        NTRK#
wjb  C                   MOVE      THDRIV        NDRIV
wjb  C                   MOVE      THSTOP        NSTOP
wjb  C                   MOVE      THCOMM        NCOMM
wjb  C* removed per      MOVEL     'ADDED FO'    WRK16            16
wjb  C*   Bill S.        MOVE      'R MOVE  '    WRK16
wjb  C* 06/07/2004       MOVEL     WRK16         NCOMM
     C                   WRITE     TRHDRH
     C                   ENDDO
      ** GET SUB FILE AND UPDATE RECORDS
     C                   Z-ADD     0             RECNO
     C     NXTVR1        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDVRT
     C                   END
     C     RECNO         CHAIN     DETSFL                             90
     C   90              GOTO      NXTVR1
     C     SCDKEY        CHAIN     FPUSCHDS                           91
     C  N91              DO
     C                   MOVEL     NROUT         TRROUT
     C                   MOVEL     NTRUCK        TRROUT
     C                   MOVEL     NTRUCK        TRTRK#
     C                   Z-ADD     DAT(DAY#)     TRSHDT
     C                   Z-ADD     NewDate7      TRSHDT
     C                   UPDATE    RPUSCHD
     C                   ENDDO
     C                   GOTO      NXTVR1
      ** END MOVE
     C     ENDVRT        ENDSR
      **************************
      ** GET TRUCK INTO DETAIL *
      **************************
     C*          GETTRK    BEGSR
     C*          ROTKEY    SETLLFPUSCHDR
     C*          NXTTRK    TAG
     C*          ROTKEY    READEFPUSCHDR                 90
     C*  90                GOTO ENDTRK
     C*                    MOVELTHTRK#    TRTRK#
     C*                    UPDATTRSCHR
     C*                    GOTO NXTTRK
     C*          ENDTRK    ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     01            CHAIN     FOECTL                             90
     C                   MOVEL     OCHDG1        HDG1
     C                   MOVEL     OCHDG2        HDG2
     C                   MOVEL     OCHDG3        HDG3
     C                   MOVEL     OCHDG4        HDG4
     C                   ENDSR
** DAY NAMES
Monday
Tuesday
Wednesday
Thursday
Friday
Saturday
Sunday
