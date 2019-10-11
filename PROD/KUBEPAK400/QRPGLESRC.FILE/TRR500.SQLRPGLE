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
      **PROGRAM NAME-------- TRR500
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- FINAL TRUCK SCHEDULE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  2/15/02 EFD DO NOT ASSIGN STOPS. PER BILL
      *
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   10/18/18   S.Uthaya     Added New History file for Truck Schedule File
      *                                 to track Modified records
      * SUD02   12/12/18   S.Uthaya     Replaced Codes Values by using New
      *                                 Direction file
      *                                 Replaced SCRNH by using DIR010 Program
      * SUD03   03/19/19   S.Uthaya     Issue Fix in Directions
      //--------------------------------------------------------------------
     FTRR500FM  CF   E             WORKSTN
     F                                     SFILE(DETSFL:RECNO)
     FTRR500P   O    E             PRINTER USROPN
     FFTRHDRHR  UF   E           K DISK
     FFTRHDRHE  UF A E           K DISK
     F                                     RENAME(RTRHDRH:TRHDRH)
     FFTRSCHDT  UF   E           K DISK
     F                                     RENAME(RTRSCHD:TRSCHR)
SUD02F                                     INFDS(RRNDS)
SUD01FFTRSCHDHSTUF A E           K DISK
     FFTRSCHDS  UF A E           K DISK
     FFTRSTAT   UF   E           K DISK
     FFHORDR    UF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFCUSTCOM  IF   E           K DISK
     FFOECTL    IF   E           K DISK
     FFCALENCY  IF   E           K DISK
     F                                     RENAME(RCALEN:CALEN)
     FFCALEX    IF   E           K DISK
SUD02F*FCMDIR    UF A E           K DISK
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$_Dates
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$User
SUD02D*/COPY QFunctDefn,$NeedDir
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$isNote
    ?D/COPY QFunctDefn,$Notes
    ?D/COPY QFunctDefn,$DotW
SUD02D/COPY QFunctDefn,$ChkDir

      *MESSAGE ARRAYS
     D MSG             S              9    DIM(7) CTDATA PERRCD(1)              DAY NAMES
     D categ           S              4    DIM(6) CTDATA PERRCD(1)              CATEGORIES
      *SCREEN C ARRAYS
     D DAY             S              1  0 DIM(9)                               DAY #
     D ROT             S              4    DIM(9)                               TRUCK #
     D STP             S              2  0 DIM(9)                               STOP #
     D Q1              S              4  0 DIM(9)                               QTY1
     D Q2              S              4  0 DIM(9)                               QTY2
     D Q3              S              3  1 DIM(9)                               QTY3
     D Q4              S              4  0 DIM(9)                               QTY4
     D Q5              S              4  0 DIM(9)                               QTY5
     D Q6              S              4  1 DIM(9)                               QTY6
      *DATE ARRAY
     D DAT             S              7  0 DIM(9)                               DATES CYMD FOR WK
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D SystemDS       SDS
     D  PROGID                 1     10                                         PROGRAM NAME
     D  RLIBR                 81     90                                         RUN LIBRARY
     D  USERID               254    263                                         USER I.D.
     D  SLIBR                314    323                                         SOURCE LIBRARY
     D  EXCP_DATA             91    170
SUD01D  WORKSTN              244    253
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

     D   SAVEADR       DS
     D  CMADD2h                            Like(CMADD2)
     D  CMADD3h                            Like(CMADD3)
     D  CMADD4h                            Like(CMADD4)
     D  CMCITYh                            Like(CMCITY)
     D  CMSTSTh                            Like(CMSTST)
     D  CMZIPh                             Like(CMZIP)

     D   ADDRESS       DS
     D  CMADD2
     D  CMADD3
     D  CMADD4
     D  CMCITY
     D  CMSTST
     D  CMZIP

     D  TRQTY_DS       DS                  Inz
     D  TRQTY1
     D  TRQTY2
     D  TRQTY3
     D  TRQTY4
     D  TRQTY5
     D  TRQTY6
     D  TRQTY                              Like(TRQTY1) Dim(6) Overlay(TRQTY_DS)

     D  OrdQTYTot      S                   Like(TRQTY1)
     D  OrdQTY_DS      DS                  Inz
     D  OrdQTY1                            Like(TRQTY1)
     D  OrdQTY2                            Like(TRQTY2)
     D  OrdQTY3                            Like(TRQTY3)
     D  OrdQTY4                            Like(TRQTY4)
     D  OrdQTY5                            Like(TRQTY5)
     D  OrdQTY6                            Like(TRQTY6)
     D  OrdQTY                             Like(OrdQTY1) Dim(6)
     D                                     Overlay(OrdQTY_DS)

     D  COL1           S              1S 0 Inz(1)
     D  COL2           S              1S 0 Inz(1)
     D  COL3           S              1S 0 Inz(1)
     D  COL4           S              1S 0 Inz(1)
     D  COL5           S              1S 0 Inz(1)
     D  COL6           S              1S 0 Inz(1)

     D  HDG5           S              4A   Inz('N/A')
     D  HDG6           S              4A   Inz('OVRC')

     D  IN04           S               N   Inz(*Off)


     D  Calculate      S               N   Inz(*Off)

     D  FirstHash      S              3S 0 Inz(0)
     D  SecondHash     S              3S 0 Inz(0)
     D  Length         S              3S 0 Inz(0)
     D  NewDate        S               N
     D  OldDate        S                   Like(TRSHDT)                         Old Ship Date Move
     D  LastTruck      S                   Like(TRUCK)
SUD01D  WkFlag         S              1A
SUD02D  WkQty1         S              4P 0
  |  D  WkQty2         S              4P 0
  |  D  WkQty3         S              3P 1
  |  D  WkQty4         S              4P 0
  |  D  WkQty5         S              4P 0
  |  D  WkQty6         S              7P 1
  |  D  WkSeq          S              2P 0
  |  D  WkSeq#         S              3P 0
SUD02D  IN28           S               N
      /Free
SUD02  Dcl-Ds RRNDS;
  |       RecRrn  Uns(10) Pos(397);
SUD02  End-Ds;

       Dcl-s FindAddress Char(180);
       Dcl-s RouteZips Char(180);
       Dcl-s LastTRSTP# Like(TRSTP#);
       Dcl-s ThisZip Like(OHSHZP);
       Dcl-s LastZip Like(OHSHZP);
       Dcl-s ThisStop Like(TRSTP#);
       Dcl-s LastRECNO Like(RECNO);

       Dcl-Pr Google_Adr Extpgm('GOOGLE_ADR');
         FindAddress  Char(180);
       End-Pr;
       Dcl-Pr Google_Dir Extpgm('GOOGLE_DIR');
         FindAddress Char(180);
       End-Pr;
       Dcl-Pr Google_Rte Extpgm('GOOGLE_RTE');
         RouteZips   Char(180);
       End-Pr;
       Dcl-Pr editCust Extpgm('ARR010CLC');
         Customer# packed(6:0);
       End-Pr;

SUD02 *?Procedure Prototype Declaration : Call ShipTo Directions Program
  |     Dcl-Pr DIR010 ExtPgm;
  |        PCust Packed(6:0);
  |        PSeq# Packed(3:0);
SUD02   End-Pr;
      *
      /End-Free

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
     I              QTY51                       Q5(1)
     I              QTY52                       Q5(2)
     I              QTY53                       Q5(3)
     I              QTY54                       Q5(4)
     I              QTY55                       Q5(5)
     I              QTY56                       Q5(6)
     I              QTY57                       Q5(7)
     I              QTY58                       Q5(8)
     I              QTY59                       Q5(9)
     I              QTY61                       Q6(1)
     I              QTY62                       Q6(2)
     I              QTY63                       Q6(3)
     I              QTY64                       Q6(4)
     I              QTY65                       Q6(5)
     I              QTY66                       Q6(6)
     I              QTY67                       Q6(7)
     I              QTY68                       Q6(8)
     I              QTY69                       Q6(9)
      ***********************
      ** SCREEN A ROUTINE  **
      ***********************
     C     RSTART        TAG
     C                   UNLOCK    FTRHDRHR
     C                   UNLOCK    FTRHDRHE
     C                   UNLOCK    FTRSCHDT
     C                   UNLOCK    FTRSCHDS
     C                   UNLOCK    FTRSTAT
     C                   CLEAR                   *IN
     C     NXTA          TAG
     C                   If        UDSEXT <> ' '
WJB01C                   SUB       1000000       UDSDAT
WJB01C     100.0001      MULT      UDSDAT        SHPDAT
WJB01C                   MOVE      UDSTRK        TRUCK
WJB01C                   MOVE      *Blanks       UDSEXT
     C                   Else
     C                   If        SHPDAT = *Zero
     C                   Eval      SHPDAT = $MDYDate($AddDate($Date(0):1))
     C                   EndIf
     C                   If        $isDate#(SHPDAT:'*MDY')
     C                   Eval      DOTW = $DotW($DateMDY(SHPDAT))
     C                   EndIf
WJB01C                   WRITE     SCRNA
WJB01C                   READ      SCRNA                                  90
     C                   If        $isDate#(SHPDAT:'*MDY')
     C                   Eval      DOTW = $DotW($DateMDY(SHPDAT))
     C                   EndIf
     C                   EndIf
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC              GOTO      END
     C                   SETOFF                                       102030
     C                   SETOFF                                       16
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
      ** Check Date Navigation
     C                   Select
     C                   When      *In08
     C                   Eval      SHPDAT =
     C                             $MDYDate($AddDate($DateMDY(SHPDAT):-7))
     C                   GOTO      NXTA
     C                   When      *In09
     C                   Eval      SHPDAT =
     C                             $MDYDate($AddDate($DateMDY(SHPDAT):+7))
     C                   GOTO      NXTA
     C                   When      *In06
     C                   Eval      SHPDAT =
     C                             $MDYDate($AddDate($DateMDY(SHPDAT):-1))
     C                   GOTO      NXTA
     C                   When      *In07
     C                   Eval      SHPDAT =
     C                             $MDYDate($AddDate($DateMDY(SHPDAT):+1))
     C                   GOTO      NXTA
     C                   When      *In11
      /Free
       Monitor;
         THSHDT = $Date7($DateMDY(SHPDAT));
         On-Error;
         SHPDAT = $MDYDate($Date(0));
         THSHDT = $Date7($DateMDY(SHPDAT));
       ENDMON;

       LastTruck = TRUCK;
       Exec SQL  // Get Next truck for this day
         select      THTRK#
         into        :TRUCK
         from        FTRHDRH
         where       THSHDT = :THSHDT
           and       THTRK# > :LastTruck
         order by    THTRK#;
       If TRUCK = LastTRUCK;
         TRUCK = *Blanks;
       ENDIF;
      /End-Free
     C                   GOTO      NXTA
     C                   EndSL
      ** CHECK TRUCK
     C*     TRUCK         IFLE      *BLANKS
     C*                   SETON                                        2030
     C*                   GOTO      NXTA
     C*                   END
      ** SEE IF SEARCH NEEDED
     C                   MOVEL     TRUCK         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C**                   Z-ADDSHPDAT    WKDATE  60
     C*                   CALL      'TRR220'
     C                   CALL      'TRR221'
     C                   PARM                    SHPDAT
     C                   PARM                    TRUCK             4
     C                   PARM                    ROUT              2
     C*    TRUCK         IFLE      *BLANKS
     C*                  GOTO      NXTA
     C*                  END
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
     C*                  Monitor
     C     ROUTKY        CHAIN(E)  FTRHDRHR                           30
     C                   If        %Error() and %Status = 01218
     C                   Eval      *In16 = *On
      /Free
        FirstHash = %scan('/':EXCP_DATA:1);
        SecondHash = %scan('/':EXCP_DATA:%scan('/':EXCP_DATA:1)+1);
        Length = SecondHash - FirstHash - 1;
        SLockedBy = %Subst(EXCP_DATA:FirstHash+1:Length);
      /End-Free
     C                   Goto      NXTA
     C                   EndIf
     C                   UNLOCK    FTRHDRHR
     C*   30
     C*AN KD              DO
     C                   If        *In30 and *InKD and TRUCK <> ' '
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
     C     ROUTKY        CHAIN(N)  FTRHDRHR                           30
     C*                   ENDDO                                                  30 KD  DO
     C                   EndIf
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
     C   46ROUTKY        CHAIN     FTRHDRHR                           30
     C  N46ROUTKY        CHAIN(N)  FTRHDRHR                           30
     C                   SETOFF                                       59
     C     PAGE#         IFLE      0
     C                   Z-ADD     1             PAGE#
     C                   END
     C                   EXFMT     DETCTL
     C                   Eval      Calculate = *Off
     C   46              UPDATE    RTRHDRH
      *  GOOGRTE
     C                   If        *InKY or GOOGRTE = 1
     C                   ExSr      GetRouteZips
      /Free
       Google_Rte(RouteZips);
      /End-Free
     C                   GOTO      NXTFMT
     C                   EndIf
      *
      ** CHECK F KEYS
     C   KF              DO
     C                   If        TRTRK# <> ' '
     C                   Move      TRSHDT        TRSHDT@           7
     C*                  Call      'TRR502CL'
     C                   Call      'TRR502'
     C                   Parm                    TRTRK#
     C                   Parm                    TRSHDT@
     C                   EndIf
     C                   GOTO      RSTART
     C                   ENDDO
     C   KC              GOTO      END
      ** MOVE TO NEW ROUT
     C   KH              DO
     C                   EXSR      MVRT
     C                   GOTO      RSTART
     C                   END
      ** Print Truck Master
     C   KM              DO
     C                   Eval      TDate@ = %Editw(SHPDAT:'0     ')
     C                   Call      'TRC520CL'
     C                   Parm      '    '        TTruck            4
     C                   Parm                    TDate@            6
     C                   GOTO      RSTART
     C                   END
      ** Swith between Edit and View Mode (*IN46) *on=edit *off=inquiry
     C   KN              DO
     C                   If        *In46
     C                   Eval      *In46 = *Off
     C                   EXSR      BLDSFL
     C                   Else
     C                   Eval      *In46 = *On
     C                   EXSR      BLDSFL
      /Free
         //  3/25/2019 Bill S. requested to position to SFL bottom on entering Edit Mode
        PAGE# = LastRECNO;
       If (PAGE#/16) = %int(PAGE#/16);
         PAGE# = LastRECNO + 1;
       ENDIF;
      /End-Free
     C                   ENDIF
     C                   GOTO      NXTFMT
     C                   ENDDO
      ** Google the Address
     C   KP              DO                                                     F15=Google Map it
     C                   Exsr      Google
     C                   GOTO      NXTFMT
     C                   ENDDO
      ** Google the Directions
     C   KQ              DO                                                     F16=Google Direction
     C                   Exsr      Google
     C                   GOTO      NXTFMT
     C                   ENDDO
      ** Left Mouse Button
     C   KR              DO                                                     MOUBTN(*ULP *ULR 17)
     C                   Exsr      Google
     C                   GOTO      NXTFMT
     C                   ENDDO
      ** Right Mouse Button
     C   KS              DO                                                     MOUBTN(*ULP *ULR 18)
     C                   Exsr      Google
     C                   GOTO      NXTFMT
     C                   ENDDO
      ** Calculate
     C   KA              DO
     C                   Eval      Calculate = *On
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
      ** delivery confirmation
     C   KK              DO
     C                   EXSR      DELCONF
     C                   EXSR      CHKSFL
     C                   EXSR      BLDSFL
     C                   GOTO      NXTFMT
     C                   END
      ** COD confirmation
     C   KI              DO
     C                   EXSR      CODCONF
     C                   GOTO      NXTFMT
     C                   END
      ** Get Directions
     C   KG              DO
     C     LINE          CHAIN     DETSFL                             90
      *?Direction file replaced
SUD02C*                  EXSR      DIRECTIONS
  |  C                   EXSR      CHKDIRSR
SUD02C                   EXSR      GETDIRSR
     C                   EXSR      BLDSFL
     C                   GOTO      NXTFMT
     C                   END
      ** Override/Un-Override Carts
     C   KD              DO
     C                   If        USERID <> 'VAC'
     C                   Eval      MF4='This user pressed the F4 Key in TRR500'
     C                   Call      '#NOTIFY'
     C                   Parm      'VICKY1    '  TOMSGQ           10
     C                   Parm                    MF4             480
     C                   Call      '#NOTIFY'
     C                   Parm      'VICKY2    '  TOMSGQ           10
     C                   Parm                    MF4             480
     C                   Call      '#NOTIFY'
     C                   Parm      'VICKY3    '  TOMSGQ           10
     C                   Parm                    MF4             480
     C                   EndIf
     C     LINE          CHAIN     DETSFL                             90
     C                   If        IN04 = *Off
     C*                  Eval      TRQTY6 = QTY3
     C*                  Eval        QTY6 = QTY3
     C                   Eval      TRQTY6 = 1
     C                   Eval        QTY6 = 1
     C*                  If         QTY3 = *Zero
     C*                  Eval      TRQTY6 = 99.9
     C*                  Eval        QTY6 = 99.9
     C*                  EndIf
     C                   Eval       IN04 = *On
     C                   Eval      *IN04 = *On
     C                   Else
     C                   Eval      TRQTY6 = *Zero
     C                   Eval        QTY6 = *Zero
     C                   Eval       IN04 = *Off
     C                   Eval      *IN04 = *Off
     C                   EndIf
     C                   Update    DETSFL
     C                   EXSR      CHKSFL
     C                   EXSR      BLDSFL
     C                   GOTO      NXTFMT
     C                   EndDo
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
     C                   If        TRTRK# <> ' '
     C                   Move      TRSHDT        TRSHDT@           7
     C*                  Call      'TRR502CL'
     C                   Call      'TRR502'
     C                   Parm                    TRTRK#
     C                   Parm                    TRSHDT@
     C                   EndIf
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
      /Free
         Exec SQL
           SELECT POENTR into :ENTEREDBY FROM FPPO WHERE POORD# = :TRORD#;
      /End-Free
     C                   Else
     C                   Eval      VIEW_ORDER = 'No Order Available'
     C                   EndIf
     C                   If        not *In90 and TRCUST <> *Zero
     C                   Eval      OPTION = ' '

     C                   Eval      KEYVAL = *Blanks
     C                   MoveL     TRCUST        KEYVAL           25
SUD02 *?Direction file replaced
  |  C*                  Eval      *In28 = $NeedDir(TRCUST)
SUD02C                   Exsr      ChkDirSr
SUD03C                   If        IN28 = '1'
  |  C                   Eval      *In28 = *Off
  |  C                   Else
  |  C                   Eval      *In28 = *On
SUD02C                   Endif
     C                   Eval      *In29 = $isNote('FMCUST':KEYVAL)

     C                   If        TRDLVU = *Blanks
     C                   Eval      TRDLVT = $TimeStamp()
     C                   Eval      TRDLVU = $User()
     C                   EndIf
     C                   Move      TRDLVT        DLVTDATE
     C                   Move      TRDLVT        DLVTTIME

     C     DSPDEL        TAG
     C                   If        %Subst(Codes:1:1) <> 'D'
     C                   Eval      *In95 = *On
     C                   Else
     C                   Eval      *In95 = *Off
     C                   EndIf
     C  N90              EXFMT     CONFDEL

     C                   Select

     C                   When      GETDIR = 1 or GETDIR = 2
SUD02 *?Direction file replaced
  |  C*                  ExSR      DIRECTIONS
  |  C                   ExSR      ChkDirSR
  |  C                   EXSR      GetDirSR
  |  C*                  If        not $NeedDir(TRCUST)
SUD02C                   If        *In28 = *On
     C                   Eval      %subst(CODES:1:1)='D'
     C                   EndIf
     C                   Goto      DSPDEL

     C*                  When      GETORD = 1
     C                   When      GETORD = 1 or *InKK
     C                   Call      'BIR100CLO'
     C                   Parm                    TRORD#
     C                   Parm                    SEQ#              3 0
     C                   Goto      DSPDEL

     C                   When      GETNOTES = 1 or GETNOTES = 2
     C                   Eval      KEYVAL = *Blanks
     C                   MoveL     TRCUST        KEYVAL           25
     C                   CallP     $Notes('FMCUST':KEYVAL)
     C                   Goto      DSPDEL

     C*                  When      *InKL
     C                   When      *InKL or *InKC
     C                   Eval      *In90 = *On

     C*                  When      *InKH
     C                   When      *InKG
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
      ** Directions
      ***********************
SUD02C*    DIRECTIONS    BEGSR
  |  C*    RSTRTH        TAG
  |  C*    CMCUST        CHAIN     FCMDIR                             94
  |  C*  94              DO
  |  C*                  MOVE      *BLANKS       CMCOR1
  |  C*                  MOVE      *BLANKS       CMCOR2
  |  C*                  MOVE      *BLANKS       CMDR01
  |  C*                  MOVE      *BLANKS       CMDR02
  |  C*                  MOVE      *BLANKS       CMDR03
  |  C*                  MOVE      *BLANKS       CMDR04
  |  C*                  MOVE      *BLANKS       CMDR05
  |  C*                  MOVE      *BLANKS       CMDR06
  |  C*                  MOVE      *BLANKS       CMDR07
  |  C*                  MOVE      *BLANKS       CMDR08
  |  C*                  MOVE      *BLANKS       CMDR09
  |  C*                  MOVE      *BLANKS       CMDR10
  |  C*                  MOVE      *BLANKS       CMDR11
  |  C*                  ENDDO
  |  C*
  |  C*                  WRITE     SCRNH
  |  C*                  Z-ADD     0             CNT               2 0
  |  C*                  READ      SCRNH                                  90
  |  C*
  |  C*  KC              SETON                                        LR
  |  C*  KC              GOTO      END
  |  C*
  |  C*                  MOVEL     'A'           CMSTAT
  |  C*  94CMCOR1        IFGT      *BLANKS
  |  C*    CMCOR2        ORGT      *BLANKS
  |  C*    CMDR01        ORGT      *BLANKS
  |  C*    CMDR02        ORGT      *BLANKS
  |  C*    CMDR03        ORGT      *BLANKS
  |  C*    CMDR04        ORGT      *BLANKS
  |  C*    CMDR05        ORGT      *BLANKS
  |  C*    CMDR06        ORGT      *BLANKS
  |  C*    CMDR07        ORGT      *BLANKS
  |  C*    CMDR08        ORGT      *BLANKS
  |  C*    CMDR09        ORGT      *BLANKS
  |  C*    CMDR10        ORGT      *BLANKS
  |  C*    CMDR11        ORGT      *BLANKS
  |  C*                  WRITE     RCMDIR
  |  C*                  ENDIF
  |  C* N94              UPDATE    RCMDIR
  |   *
SUD02C*                  ENDSR
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
     C                   CLEAR                   SAVEADR
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
     C                   SETOFF                                       101102
     C                   SETOFF                                       2021
     C                   SETOFF                                       3031
     C                   SETOFF                                       4041
     C                   MOVE      *BLANKS       OPTION
     C                   Z-ADD     1             NXTSTP            5 0
      ** SETLL ON FILE
     C     TRKKEY        SETLL     FTRSCHDT
     C     NXTBLD        TAG
     C     TRKKEY        READE(N)  FTRSCHDT                               90
     C   90              GOTO      ENDBLD
SUD02 *? Move Physical file RRN to history file
  |  C                   IF        *IN90=*OFF
  |  C                   MOVE      RecRRN        H01RecRRN
  |  C                   Else
  |  C                   MOVE      *Zeros        H01RecRRN
SUD02C                   ENDIF
     C                   If        TRORD# <> *Zero                              If 0 ignore like bad
     C     TRORD#        CHAIN(N)  FHORDR                             96
     C                   Else
     C                   Eval      *In96 = *On
     C                   EndIf
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

     C                   If        ADDRESS <> SAVEADR
     C                   Add       1             STOP#
     C                   Eval      SAVEADR = ADDRESS
     C                   EndIf
     C                   Z-Add     STOP#         TRSTP#

     C                   MOVEL     CMNAME        CNAME
     C*                  MOVEL     CMCITY        CITY
     C*                  Eval      CITY = %Trim(%Subst(CMCITY:1:%Len(CITY)-3))+
     C*                                   ',' + CMSTST
      /Free
       CITYSTZIP = %trim(CMCITY) + ', ' + CMSTST + ' ' + %subst(CMZIP:1:5);
      /End-Free

     C                   If        *In91 and *In96
     C                   MOVE      *BLANKS       CNAME
     C                   MOVEL     '*UNKNOWN'    CNAME

     C*                  MOVE      *BLANKS       CITY
     C                   MOVE      *BLANKS       CITYSTZIP
     C                   MOVE      *BLANKS       CODES
     C                   MOVE      *BLANKS       CMSTST
     C                   MOVE      *BLANKS       CMFILL
     C                   Z-ADD     0             CMPHON
     C                   EndIf                                                   91 DO

     C                   Clear                   RCUSTCOM
     C                   Eval      CCSEQ = 1
     C     COMKEY        KList
     C                   KFld                    TRCUST
     C                   KFld                    CCSEQ
     C     COMKEY        CHAIN     FCUSTCOM

      *  Codes ....................
     C                   Eval      Codes = *Blanks
SUD02C*                  If        not $NeedDir(TRCUST)
  |  C                   Exsr      ChkDirSr
SUD02C                   If        IN28
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
     C                   Z-ADD     TRQTY(COL1)   QTY1
     C                   Z-ADD     TRQTY(COL2)   QTY2
     C                   Z-ADD     TRQTY(COL3)   QTY3                           #3 ALWAYS Carts
     C                   Z-ADD     TRQTY(COL4)   QTY4
     C                   Z-ADD     TRQTY(COL5)   QTY5
     C                   Eval      *In04 = *Off
     C                   Eval       In04 = *Off
     C                   If        TRQTY(COL6) <> 0
     C*                  Z-ADD     TRQTY(COL6)   QTY3
     C*                  If        TRQTY(COL6) = 99.9
     C*                  Z-ADD     *Zero         QTY3
     C*                  EndIf
     C                   Eval      *In04 = *On
     C                   Eval       In04 = *On
     C                   EndIf
     C                   Z-ADD     TRQTY(COL6)   QTY6
     C                   ADD       1             RECNO
     C                   If        TRORD# <> 0
     C                   If        $DateMDY(SHPDAT) > $Date(0) and Calculate
     C                   If        TRQTY6 = 0
    ?C                   Call      'TRR105'
    ?C                   Parm      TRORD#        Order#            6 0
    ?C                   Parm      TRSHDT        ShipDate          7 0
    ?C     OrdQTY1       Parm      0             OrdPLUG           7 1
    ?C     OrdQTY2       Parm      0             OrdFLAT           7 1
    ?C     OrdQTY4       Parm      0             OrdHBPT           7 1
    ?C     OrdQTY5       Parm      0             OrdPOIN           7 1
     C                   If        OrdQty1 + OrdQty2 + OrdQty4 + OrdQty5 = 0
    ?C                   Call      'TRR106'
    ?C                   Parm      TRORD#        Order#            6 0
    ?C     OrdQTY1       Parm      0             OrdPLUG           7 1
    ?C     OrdQTY2       Parm      0             OrdFLAT           7 1
    ?C     OrdQTY4       Parm      0             OrdHBPT           7 1
    ?C     OrdQTY5       Parm      0             OrdPOIN           7 1
     C                   EndIf
     C                   SetOff                                       434445
      *  As of 9/13/2012 the logic was that for each column, the quantity was replaced ONLY
      *  if the calculated quantity for that column was greater than zero.  Effective
      *  immediately, per Bill, if any of the quantities are greater than zero, all should
      *  use the quantities calculated.  The program will no loger retain artificial quantities.
     C                   Eval      OrdQTYTot = OrdQTY(Col1)
     C                                       + OrdQTY(Col2)
     C                                       + OrdQTY(Col4)
     C                   If        OrdQTY(COL1)  > 0  or OrdQTYTot > 0
     C                   Eval      *In43 = *On
     C                   Z-ADD     OrdQTY(COL1)  QTY1
     C                   EndIf
     C                   If        OrdQTY(COL2)  > 0  or OrdQTYTot > 0
     C                   Eval      *In44 = *On
     C                   Z-ADD     OrdQTY(COL2)  QTY2
     C                   EndIf
     C                   If        OrdQTY(COL4)  > 0  or OrdQTYTot > 0
     C                   Eval      *In45 = *On
     C                   Z-ADD     OrdQTY(COL4)  QTY4
     C                   EndIf

     C                   EndIf                                                  TRQTY6 = 0
     C                   Goto      NoCarts
     C                   Eval      ShipMDY  = OHDTCN
    ?C                   Call      'BIR103'
    ?C                   Parm                    SHIPMDY           7 0
    ?C                   Parm                    TRORD#
    ?C                   Parm                    CARTS             5 2
    ?C                   Parm                    SHOWYN            1

    ?C                   Z-Add     *Zero         MonCARTS          5 2
     C                   If        $MDYDate($Monday($DateMDY(OHDTCN):'SAT'))
     C                             <>            OHDTCN
     C                   Eval      ShipMDY  =
     C                             $MDYDate($Monday($DateMDY(OHDTCN):'SAT'))
    ?C                   Call      'BIR103'
    ?C                   Parm                    SHIPMDY           7 0
    ?C                   Parm                    TRORD#
    ?C                   Parm                    MonCARTS          5 2
    ?C                   Parm                    SHOWYN            1
     C                   EndIf
     C                   If        CARTS + MonCARTS > *Zero
     C                   Eval      QTY3  = CARTS + MonCARTS
     C                   If        QTY3 <> CARTS + MonCARTS
     C                   Eval      QTY3 = QTY3 + .1
     C                   EndIf
     C                   EndIf
     C*                  If        QTY6 <> *Zero
     C*                  Eval      QTY3 = QTY6
     C*                  If        QTY6 = 99.9
     C*                  Eval      QTY3 = *Zero
     C*                  EndIf
     C*                  EndIf
     C                   EndIf
     C     NoCarts       Tag

     C                   SetOn                                        15
     C                   Else
     C                   SetOff                                       15
     C                   EndIf
     C                   ADD       QTY1          TOTC1
     C                   ADD       QTY2          TOTC2
     C                   ADD       QTY3          TOTC3
     C                   ADD       QTY4          TOTC4
     C                   ADD       QTY5          TOTC5
     C                   ADD       QTY6          TOTC6
     C                   WRITE     DETSFL
     C                   SETOFF                                       25
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Eval      LastRECNO = RECNO
     C                   If        *in46
     C                   Eval      *In02 = *on
     C                   else
     C                   Eval      *In02 = *off
     C                   ENDIF
     C                   Eval      *In04 = *Off
     C                   Eval       In04 = *Off
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
     C*     WRKR          IFLT      12
     C*     WRKR          ADD       12            CROW
     C*                   ELSE
     C*                   Z-ADD     12            CROW
     C*                   END
     C*                   Z-ADD     2             CCOL
     C                   Z-ADD     0             TRSEQ#
     C                   Z-ADD     0             STOP#
     C                   Z-ADD     0             TRCUST
     C                   MOVE      *BLANKS       CMFILL
     C                   Z-ADD     0             SEQ
SUD02C                   MOVE      *Zeros        H01RecRRN
     C                   MOVE      *BLANKS       CNAME
     C*                  MOVE      *BLANKS       CITY
     C                   MOVE      *BLANKS       CITYSTZIP
     C                   MOVE      *BLANKS       OHSHP2
     C                   MOVE      *BLANKS       OHSHP3
     C                   MOVE      *BLANKS       OHSHP4
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
     C                   Z-ADD     0             QTY5
     C                   Z-ADD     0             QTY6
     C                   SETOFF                                       15
     C                   SetOff                                       434445
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
     C     OPTION        ANDNE     '0'
     C     OPTION        ANDNE     'M'
     C     OPTION        ANDNE     'D'
     C     OPTION        ANDNE     'C'
     C     OPTION        ANDNE     'R'
     C     OPTION        ANDNE     'O'
     C                   SETON                                        101199
     C                   END
     C                   END
      ** ADD A LINE
     C     OPTION        IFEQ      'A'
     C     OPTION        OREQ      '0'
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
     C     OPTION        OREQ      '0'
     C     TRSEQ#        IFLE      0
     C                   EXSR      ADDLIN
     C                   GOTO      NXTCK2
     C                   END
     C                   END
      ** EDIT ORDER
     C     OPTION        IFEQ      'O'
     C     TRORD#        IFNE      0
     C                   Call      'BIR100CLO'
     C                   Parm                    TRORD#
     C                   Parm                    SEQ#              3 0
     C                   GOTO      NXTCK2
     C                   END
     C                   END
      ** RELEASE ORDER
     C     OPTION        IFEQ      'R'
     C     TRORD#        IFNE      0
     C                   Move      TRORD#        POrder
     C                   Move      SHPDAT        PDate
     C                   Call      'BIR237CLP'
     C                   Parm                    POrder            6
     C                   Parm                    PDate             6
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
     C     SCDKEY        CHAIN     FTRSCHDS                           91
     C     RECNO         CHAIN     DETSFL                             90
     C  N91              DO
SUD01C                   Exsr      CheckQty
     C                   If        TRDLVN <> *Blanks and TRDLVN <> 'VOICEMAIL'
     C                   Eval      TRDLVC =  'Y'
     C                   EndIf
     C                   Z-ADD     SEQ           TRSTOP
     C                   Z-ADD     QTY1          TRQTY(COL1)
     C                   Z-ADD     QTY2          TRQTY(COL2)
     C                   Z-ADD     QTY3          TRQTY(COL3)
     C                   Z-ADD     QTY4          TRQTY(COL4)
     C                   Z-ADD     QTY5          TRQTY(COL5)
     C                   Z-ADD     QTY6          TRQTY(COL6)
     C     TRORD#        CHAIN     FHORDR
     C                   If        %Found(FHORDR)
     C                   Eval      OHDTCN = $MDYDate($Date(TRSHDT))
     C                   Eval      OHROUT = TRTRK#
     C                   Eval      OHSTOP = TRSTP#
     C                   Update    RHORDR
     C                   EndIf
     C                   UPDATE    RTRSCHD
SUD01 /Free
  |         If WkFlag = 'Y';
  |            TRACTN = 'CHANGE';
  |            Exsr UpdateHst;
  |         Endif;
SUD01 /End-Free
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
     C                   Z-ADD     0             OQTY3             3 1
     C                   Z-ADD     0             OQTY4             4 0
     C                   Z-ADD     0             OQTY5             4 0
     C                   Z-ADD     0             OQTY6             4 1
     C                   Z-ADD     TRCUST4       OCUST
     C                   Z-ADD     STOP          OSTOP
     C                   Z-ADD     QTY1          OQTY1
     C                   Z-ADD     QTY2          OQTY2
     C                   Z-ADD     QTY3          OQTY3
     C                   Z-ADD     QTY4          OQTY4
     C                   Z-ADD     QTY5          OQTY5
     C                   Z-ADD     QTY6          OQTY6
     C     TRCUST4       IFGT      0
     C                   Z-ADD     TRCUST4       CMCUST
     C     CMCUST        CHAIN     FMCUST                             60
     C                   ELSE
     C                   Z-ADD     0             CMCUST
     C                   END
     C                   If        TRORD# <> 0
     C                   CALL      'TRR106'
    ?C                   Parm      TRORD#        Order#            6 0
    ?C     OrdQTY1       Parm      0             OrdPLUG           7 1
    ?C     OrdQTY2       Parm      0             OrdFLAT           7 1
    ?C     OrdQTY4       Parm      0             OrdHBPT           7 1
    ?C     OrdQTY5       Parm      0             OrdPOIN           7 1
     C                   Z-ADD     OrdQTY(COL1)  QTY1
     C                   Z-ADD     OrdQTY(COL2)  QTY2
     C                   Z-ADD     OrdQTY(COL4)  QTY4
     C                   CALL      'BIR103F'
    ?C                   Parm      TRORD#        Order#            6 0
     C                   Parm                    Qty_Carts         5 2           Number of Carts
     C                   Parm      'N'           Show_YN           1             Show Screen Y/N
     C*                  eval      QTY3 = Qty_Carts        5/15/18 Bill says DO NOT calc carts
     C                   EndIf
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
     C                   Z-ADD     0             QTY5
     C                   Z-ADD     0             QTY6
     C                   GOTO      ENDADD
     C                   END
     C     TRORD#        IFGT      0
     C     TRORD#        CHAIN(N)  FHORDR                             91
     C                   If        %Found(FHORDR) and OHSTAT = 'A'
     C                   Eval      CMCUST = OHCUST
     C                   Eval      TRCUST = OHCUST
     C     CMCUST        CHAIN     FMCUST                             60
     C                   If        TRORD# <> Order#
     C                   CALL      'TRR106'
    ?C                   Parm      TRORD#        Order#            6 0
    ?C     OrdQTY1       Parm      0             OrdPLUG           7 1
    ?C     OrdQTY2       Parm      0             OrdFLAT           7 1
    ?C     OrdQTY4       Parm      0             OrdHBPT           7 1
    ?C     OrdQTY5       Parm      0             OrdPOIN           7 1
     C                   CALL      'BIR103F'
    ?C                   Parm      TRORD#        Order#            6 0
     C                   Parm                    Qty_Carts         5 2           Number of Carts
     C                   Parm      'N'           Show_YN           1             Show Screen Y/N
     C                   eval      QTY3 = Qty_Carts
     C                   Z-ADD     OrdQTY(COL1)  QTY1
     C                   Z-ADD     OrdQTY(COL2)  QTY2
     C                   Z-ADD     OrdQTY(COL4)  QTY4
     C                   EndIf
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
     C                   ADD       QTY5          TSTQTY
     C                   ADD       QTY6          TSTQTY
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
     C     QTY5          ORNE      OQTY5
     C     QTY6          ORNE      OQTY6
     C                   Z-ADD     CMCUST        OCUST
     C                   Z-ADD     STOP          OSTOP
     C                   Z-ADD     QTY1          OQTY1
     C                   Z-ADD     QTY2          OQTY2
     C                   Z-ADD     QTY3          OQTY3
     C                   Z-ADD     QTY4          OQTY4
     C                   Z-ADD     QTY5          OQTY5
     C                   Z-ADD     QTY6          OQTY6
     C                   GOTO      NXTADD
     C                   ENDIF
     C     ENDADD        TAG
      ** CHECK FOR NOT RESTART THEN UPDATE SUBFILE FIELDS
     C                   MOVE      *BLANKS       OPTION
     C                   Z-ADD     CMCUST        TRCUST
     C                   Z-ADD     CMCUST        TRCUST4
     C                   MOVEL     CMNAME        CNAME
     C*                  MOVEL     CMCITY        CITY
     C*                  Eval      CITY = %Trim(%Subst(CMCITY:1:%Len(CITY)-3))+
     C*                                   ',' + CMSTST
      /Free
       CITYSTZIP = %trim(CMCITY) + ', ' + CMSTST + ' ' + %subst(CMZIP:1:5);
      /End-Free
     C                   Z-ADD     STOP          SEQ
     C     CMFILL        IFEQ      'NT'
     C                   SETON                                        25
     C                   ELSE
     C                   SETOFF                                       25
     C                   END
     C**                   UPDATDETSFL
     C                   SETOFF                                       25
     C  NKF              DO
     C     DAT(1)        CHAIN     FTRSTAT                            90
     C                   Z-ADD     STNSEQ        TRSEQ#
     C                   ADD       1             STNSEQ
SUD02C  N91              UPDATE    RTRSTAT
     C                   MOVEL     THTRK#        TRTRK#
     C                   MOVEL     THROUT        TRROUT
     C                   Z-ADD     THSHDT        TRSHDT
     C                   Z-ADD     STOP          TRSTOP
     C                   Z-ADD     QTY1          TRQTY(COL1)
     C                   Z-ADD     QTY2          TRQTY(COL2)
     C                   Z-ADD     QTY3          TRQTY(COL3)
     C                   Z-ADD     QTY4          TRQTY(COL4)
     C                   Z-ADD     QTY5          TRQTY(COL5)
     C                   Z-ADD     QTY6          TRQTY(COL6)
     C                   WRITE     RTRSCHD
SUD01C                   MOVE      *Blanks       TRACTN
  |  C                   MOVEL     'WRITE'       TRACTN
SUD01C                   EXSR      UpdateHst
     C                   Z-ADD     CMCUST        TRCUST4
     C                   Z-ADD     STOP          SEQ
     C                   MOVE      *BLANKS       OPTION
     C                   MOVEL     CMNAME        CNAME
     C*                  MOVEL     CMCITY        CITY
     C*                  Eval      CITY = %Trim(%Subst(CMCITY:1:%Len(CITY)-3))+
     C*                                   ',' + CMSTST
      /Free
       CITYSTZIP = %trim(CMCITY) + ', ' + CMSTST + ' ' + %subst(CMZIP:1:5);
      /End-Free
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
     C     SCDKEY        CHAIN     FTRSCHDS                           91
     C  N91              DELETE    RTRSCHD
SUD01C                   MOVEL     'DELETE'      TRACTN
SUD01C                   EXSR      UpdateHst
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
     C     TRKKEY        SETLL     FTRSCHDT
     C     NXTDTK        TAG
     C     TRKKEY        READE     FTRSCHDT                               90
     C   90              GOTO      ENDDTK
     C                   DELETE    TRSCHR
     C                   GOTO      NXTDTK
     C     ENDDTK        TAG
     C     ROUTKY        CHAIN     FTRHDRHR                           30
     C  N30              DELETE    RTRHDRH
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
     C                   Z-ADD     0             Q4
     C                   Z-ADD     0             Q5
     C                   Z-ADD     0             Q6
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
     C                   Z-ADD     QTY5          Q5(1)
     C                   Z-ADD     QTY6          Q6(1)
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
     C                   XFOOT     Q5            TOTQ5
     C                   XFOOT     Q6            TOTQ6
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
     C     Q5(X)         ORGT      0
     C     Q6(X)         ORGT      0
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
     C     Q5(X)         ANDLE     0
     C     Q6(X)         ANDLE     0
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
     C*                   CALL      'TRR220'
     C                   CALL      'TRR221'
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
     C     RTTSTK        CHAIN     FTRHDRHE                           90
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
     C                   XFOOT     Q5            TOTQ5
     C                   XFOOT     Q6            TOTQ6
     C     TOTQ1         IFNE      QTY1
     C     TOTQ2         ORNE      QTY2
     C     TOTQ3         ORNE      QTY3
     C     TOTQ4         ORNE      QTY4
     C     TOTQ5         ORNE      QTY5
     C     TOTQ6         ORNE      QTY6
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
     C     SCDKEY        CHAIN     FTRSCHDS                           91
      /Free
       If not %Open(TRR500P);
         Open TRR500P;
       ENDIF;
       OldDate = TRSHDT;
       Write Header;
      /End-Free
     C  N91              DELETE    RTRSCHD
SUD01C                   MOVEL     'DELETE'      TRACTN
SUD01C                   EXSR      UpdateHst
      ** NOW OUTPUT RECORDS
     C                   Z-ADD     1             X
     C     NXOUT         TAG
     C     ROT(X)        IFGT      *BLANKS
     C                   Z-ADD     DAY(X)        D
     C                   Eval      NSHDT6 = $MDYDate($Date(DAT(D)))
4/12 C     RTTSTK        CHAIN(N)  FTRHDRHE                           90
     C   90              DO
     C                   CLEAR                   TRHDRH
     C                   Z-ADD     DAT(D)        NSHDT
     C                   MOVEL     ROT(X)        NROUT
     C                   MOVEL     ROT(X)        NTRK#
wjb  C*  Removed per     MOVEL     'ADDED FO'    WRK16            16
wjb  C*  Bill S.         MOVE      'R MOVE  '    WRK16
wjb  C*  06/07/2004      MOVEL     WRK16         NCOMM
wjb  C                   MOVE      *Blanks       NCOMM
wjb  C                   MOVEL     ' 8:00am*'    THSTOP
wjb  C                   MOVEL     ' 8:00am*'    NSTOP
wjb  C                   MOVE      '*New* '      THDRIV
     C                   WRITE     TRHDRH
     C                   ENDDO
     C     DAT(1)        CHAIN     FTRSTAT                            90
     C                   Z-ADD     STNSEQ        TRSEQ#
     C                   ADD       1             STNSEQ
     C  N90              UPDATE    RTRSTAT
     C                   MOVEL     ROT(X)        TRTRK#
     C                   Z-ADD     DAT(D)        TRSHDT
     C                   Z-ADD     CMCUST        TRCUST
     C                   Z-ADD     STP(X)        TRSTOP
     C                   Z-ADD     Q1(X)         TRQTY(COL1)
     C                   Z-ADD     Q2(X)         TRQTY(COL2)
     C                   Z-ADD     Q3(X)         TRQTY(COL3)
     C                   Z-ADD     Q4(X)         TRQTY(COL4)
     C                   Z-ADD     Q5(X)         TRQTY(COL5)
     C                   Z-ADD     Q6(X)         TRQTY(COL6)
     C                   MOVEL     ROT(X)        TRROUT
      /Free
         NEWQ1 = Q1(X);
         NEWQ2 = Q2(X);
         NEWQ3 = Q3(X);
         NEWQ4 = Q4(X);
         Write Detail;
         If TRSHDT <> OldDate;
           Clear TRDLVC;
           Clear TRDLVN;
           Clear TRDLVT;
         ENDIF;
      /End-Free
     C                   WRITE     RTRSCHD
SUD01C                   MOVE      *Blanks       TRACTN
  |  C                   MOVEL     'WRITE'       TRACTN
SUD01C                   EXSR      UpdateHst
     C                   END
     C                   ADD       1             X
     C     X             IFLE      9
     C                   GOTO      NXOUT
     C                   END
     C                   CLEAR                   DETSFL
      /Free
       If %Open(TRR500P);
         Write Footer;
         Close TRR500P;
       ENDIF;
      /End-Free
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
     C*                   CALL      'TRR220'
     C                   CALL      'TRR221'
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
     C     ROUTKN        CHAIN(N)  FTRHDRHR                           30
     C   30
     CANNKD              GOTO      NXTVRT
      ** SEE IF CHANGED
     C     NTRK#         IFEQ      TRUCK
     C     NSHPDT        ANDEQ     SHPDAT
     C                   SETON                                        102021
     C                   SETON                                        99
     C                   GOTO      NXTVRT
     C                   END
      /Free
       If NSHPDT <> OSHPDT;
         NewDate = *On;
        Else;
         NewDate = *Off;
       ENDIF;
      /End-Free
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
     C     ROUTKY        CHAIN     FTRHDRHR                           31
     C  N31              DELETE    RTRHDRH
      ** ADD NEW TRUCK
     C   30              DO
     C*                  CLEAR                   TRHDRH
     C                   Z-ADD     DAT(DAY#)     NSHDT
WJB  C                   Z-ADD     NewDate7      NSHDT
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
     C     SCDKEY        CHAIN     FTRSCHDS                           91
     C  N91              DO
     C                   MOVEL     NROUT         TRROUT
     C                   MOVEL     NTRUCK        TRROUT
     C                   MOVEL     NTRUCK        TRTRK#
     C                   Z-ADD     DAT(DAY#)     TRSHDT
WJB  C                   Z-ADD     NewDate7      TRSHDT
      /Free
       If NewDate;
         Clear TRDLVC;
         Clear TRDLVN;
         Clear TRDLVT;
       ENDIF;
      /End-Free
     C                   UPDATE    RTRSCHD
SUD01C                   MOVEL     'CHANGE'      TRACTN
SUD01C                   EXSR      UpdateHst
     C                   ENDDO
     C                   GOTO      NXTVR1
      ** END MOVE
     C     ENDVRT        ENDSR
      **************************
      ** GET TRUCK INTO DETAIL *
      **************************
     C*          GETTRK    BEGSR
     C*          ROTKEY    SETLLFTRSCHDR
     C*          NXTTRK    TAG
     C*          ROTKEY    READEFTRSCHDR                 90
     C*  90                GOTO ENDTRK
     C*                    MOVELTHTRK#    TRTRK#
     C*                    UPDATTRSCHR
     C*                    GOTO NXTTRK
     C*          ENDTRK    ENDSR
      /Free
       BegSr Google;
         CHAIN Line DETSFL;
         If TRORD# <> *Zero;
           FindAddress =
            %trim(OHSHP2)+','+%trim(OHSHP3)+','+%trim(OHSHP4)+','+CITYSTZIP;

           Select;
             When *INKP; // F15=Google Map it
               Google_Adr(FindAddress);
             When *INKQ; // F16=Google Direction
               Google_Dir(FindAddress);
             When *INKR  // MOUBTN(*ULP *ULR CF17) Left Mouse Click on CITYSTZIP
              and  CSRFLD = 'CITYSTZIP';
               Google_Adr(FindAddress);
             When *INKR  // MOUBTN(*ULP *ULR CF17) Left Mouse Click on CITYSTZIP
              and  CSRFLD = 'TRCUST4';
               editCust(TRCUST);
             When *INKS  // MOUBTN(*ULP *ULR CF18) Right Mouse Click on CITYSTZIP
              and  CSRFLD = 'CITYSTZIP';
               Google_Dir(FindAddress);
           ENDSL;

         EndIf;
       ENDSR;

       BegSr GetRouteZips;
         SQLState = '00000';
         LastTRSTP# = 0;
         RouteZips = ' ';
         DoW SQLState = '00000';
           ThisStop = *Zeros;
           Exec SQL  // Get each unique Stop on the Truck
             select  TRSTP#
              into  :ThisStop
             from    FTRSCHD
             where   TRSHDT = :THSHDT
               and   TRTRK# = :THTRK#
               and   TRSTP# > :LastTRSTP#
             order by TRTRK#, TRSTP#
             Fetch First Row Only;

           LastTRSTP# = ThisStop;

           If ThisStop <> *Zeros;
             ThisZip = *Blanks;
             LastZip = *Blanks;
             Exec SQL // Get zip for this stop
               Select OHSHZP
                 into :ThisZip
                 from ftrschd join FHORDR
                                on TRORD# = OHORD#
                where   TRSHDT = :THSHDT
                  and   TRTRK# = :THTRK#
                  and   TRSTP# = :ThisStop
               Fetch first row only;
             If SQLState = '00000';
               If ThisZip <> *Blanks and ThisZip <> LastZip;
                 RouteZips = %Trim(RouteZips) + %subst(ThisZip:1:5) + '/';
                 LastZip = ThisZip;
               ENDIF;
              Else;
               SQLState = '00000';
             ENDIF;
           ENDIF;
         ENDDO;

       ENDSR;

      /End-Free

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
     C                   MOVEL     OCHDG3        HDG3                           #3 ALWAYS "CART"
     C                   MOVEL     OCHDG4        HDG4
     C                   MOVEL     'N/A'         HDG5
     C                   MOVEL     'N/A'         HDG6                           #6 Override Carts

     C                   Eval      COL1 = 1
     C                   Eval      COL2 = 1
     C                   Eval      COL3 = 1
     C                   Eval      COL4 = 1
     C                   Eval      COL5 = 5
     C                   Eval      COL6 = 6

     C     HDG1          LOOKUP    CATEG(COL1)                            33
     C     HDG2          LOOKUP    CATEG(COL2)                            34
     C     HDG3          LOOKUP    CATEG(COL3)                            35
     C     HDG4          LOOKUP    CATEG(COL4)                            36
     C*    HDG5          LOOKUP    CATEG(COL5)                            37
     C*    HDG6          LOOKUP    CATEG(COL6)                            38
     C                   If        COL1 <> 1 and COL2 <> 1 and COL4 <> 1
     C                   Eval      COL5 = 1
     C                   EndIf
     C                   If        COL1 <> 2 and COL2 <> 2 and COL4 <> 2
     C                   Eval      COL5 = 2
     C                   EndIf
     C                   If        COL1 <> 4 and COL2 <> 4 and COL4 <> 4
     C                   Eval      COL5 = 4
     C                   EndIf
     C                   If        COL1 <> 5 and COL2 <> 5 and COL4 <> 5
     C                   Eval      COL5 = 5
     C                   EndIf

     C                   Eval      *In46 = *Off
     C                   Eval      *In03 = *on
     C                   Eval      TRUCK = '?'

     C                   ENDSR
SUD01 //--------------------------------------------------------------------
  |   *?                :----------------------:
  |   *?                : UpdateHst Subroutine :
  |   *?                :----------------------:
  |   *
  |   *?Logic : Update Truck Schedule History File With Audit Stamp
  |   *?
  |   /Free
  |
  |   *?  // Update Truck Schedule History File With Audit Stamp
  |       Begsr UpdateHst;
SUD01
SUD02 *?     // Move Quantity Value
  |          If TRACTN = 'CHANGE';
  |             TRQTY1 = WkQty1;
  |             TRQTY2 = WkQty2;
  |             TRQTY3 = WkQty3;
  |             TRQTY4 = WkQty4;
  |             TRQTY5 = WkQty5;
  |             TRQTY6 = WkQty6;
  |             TRSTOP = WkSeq;
SUD02        Endif;
  |
  |   *?     // Audit Stamp
SUD02        TRRRN# = H01RecRRN;
SUD01        TRUSER = USERID;
  |          TRPROG = PROGID;
  |          TRWKST = WORKSTN;
  |          TRTMST = %TimeStamp;
  |          Write RTRSCHDHST;
  |
  |       Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :---------------------:
  |   *?                : CheckQty Subroutine :
  |   *?                :---------------------:
  |   *
  |   *?Logic : Check quantity before and after to update History
  |
  |       Begsr CheckQty;
  |
  |   *?     // Compare Screen and File quantity
  |          WkFlag = 'N';
  |          If Qty1 <> TRQTY1 Or Qty2 <> TRQTY2  Or Qty3 <> TRQTY3
SUD01           Or Qty4 <> TRQTY4 Or Qty5 <> TRQTY5  Or Qty6 <> TRQTY6;
SUD02           WkQty1 = TRQTY1;
  |             WkQty2 = TRQTY2;
  |             WkQty3 = TRQTY3;
  |             WkQty4 = TRQTY4;
  |             WkQty5 = TRQTY5;
  |             WkQty6 = TRQTY6;
SUD02           WkSeq  = TRSTOP;
SUD01           WkFlag = 'Y';
  |          Endif;
SUD01
SUD02        If Seq <> TRSTOP;
  |             WkFlag = 'Y';
  |             WkSeq  = TRSTOP;
  |          Endif;
  |
SUD01     Endsr;
SUD02 //--------------------------------------------------------------------
  |   *?                :---------------------:
  |   *?                : GetDirSr Subroutine :
  |   *?                :---------------------:
  |   *
  |   *?Logic : Get Directions from the New Direction File
  |
  |       Begsr GetDirSr;
  |
  |   *?     // Call Direction Program
  |          If TrCust <> *Zeros;
  |             DIR010(TRCust:WkSEQ#);
  |          Endif;
  |
  |       Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :---------------------:
  |   *?                : ChkDirSr Subroutine :
  |   *?                :---------------------:
  |   *
  |   *?Logic : Get Seq# for the Customer and Order from ShipTo History File
  |
  |       Begsr ChkDirSr;
  |
  |   *?     // Get Seq# from Order Header Ship-to File
  |          WkSeq# = 0;
  |          Exec SQL
  |            SELECT OSSEQ# Into :WkSeq# from FHORDRSHTO Where OSORD# = :TRORD#
  |            and OSCUST = :TRCUST;
  |            In28 = $ChkDir(TRCUST:WkSEQ#);
  |            *In28 = IN28;
  |
SUD02     Endsr;
      /End-Free

** DAY NAMES
Monday
Tuesday
Wednesday
Thursday
Friday
Saturday
Sunday
** DAY NAMES
PLUG
FLAT
CART
HBPT
POIN
OVRC
