      /COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1997
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- GRS360
      **COMPANY------------- EFD ENTERPRISES INC.
      **APPLICATION--------- TGMS
      **DESCRIPTION--------- LOT AVAILABILITY INQUIRY
      **
      *  DATE   INIT   DESCRIPTION
      *  2/22/99 EFD ADD ALPHA SEARCH AND SIZE CODE
      **********************************************************************
      *?               :---------------:
      *?               : Modifications :
      *?               :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   04/19/19   S.Uthaya     Added F9 Function key to Toggle by
      *                                 Location
     F**********************************************************************
     FGRS360FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFDLOTDSI  IF   E           K DISK
     FFDLOT     IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     F**********************************************************************
      * PROG DATA STRUCTURE *
     D**********************************************************************
SUD01DWkLoc            S              1A                                        Toggle Work Variable
SUD01DWkSkip           S              1A                                        Toggle Work Variable
     D                SDS
     D  PROGID                 1     10                                         PROGRAM NAME
     D  RLIBR                 81     90                                         RUN LIBRARY
     D  USERID               254    263                                         USER I.D.
     D  SLIBR                314    323                                         SOURCE LIBRARY
     D                UDS
     D  PASSEDPARMS          901    921                                         Monday Date
     D  PDATE                901    906  0                                      Monday Date
     D  PITEM                907    918                                         Item
     D  PSIZE                919    921                                         Size
    ? /COPY QFunctDefn,$_Dates
    ? /COPY QFunctDefn,$Monday
     D GRS231          PR                  ExtPgm('GRS231')
     D  #DATE                         6P 0
     D  #ITEM                        12A
     D  #SIZE                         3A
     D**************************************************************************
      *  MAIN FLOW OF PROGRAM
     C**************************************************************************
      /Free
        VDATE = $MDYDate($Monday($Date(0):'THU'));
      /End-Free
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       ALPHA
     C     RSTRTA        TAG
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       10
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
     C                   SETOFF                                       1020
      *
     C                   Z-ADD     VDATE         ##MDY             6 0
     C                   EXSR      @DT@A1
     C   90              SETON                                        10
     C   10              GOTO      RSTRTA
      *  Check Size Code
     C     SIZE          IFGT      *BLANKS
     C                   MOVEL     SIZE          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       SIZE
     C                   MOVEL     SZCODE        SIZE
     C                   END
     C     SIZE          CHAIN     FMSIZE                             20
     C   20              GOTO      NXTA
     C                   END
      *  Check Item Number
     C     SITEM         IFGT      *BLANKS
     C                   MOVEL     SITEM         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   Eval      SITEM = %Subst(SITEM:2:11) + ' '
     C                   CALL      'LKITEM'
     C                   PARM      SITEM         IMLOOK
     C                   PARM                    IMITEM
     C                   PARM      SIZE          IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    DESHFR            3
     C                   MOVEL     IMITEM        SITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   END
     C                   If        SIZE <> *Blanks
     C     ITEMSIZE      KList
     C                   KFld                    SITEM
     C                   KFld                    SIZE
     C     ITEMSIZE      CHAIN     FMINVT                             21
     C   21              GOTO      NXTA
     C                   EndIf
     C                   END
      **
     C  N90              MOVE      ##CYMD        LDATE             7 0
     C*
      * SET FDLOT BACK TO BEGINING OF DATE
      *
SUD01C                   MOVE      'N'           WkSkip
SUD01C                   MOVE      'N'           WkLoc
     C     RLOADB        TAG
     C                   Z-ADD     0             PAGE#             4 0
     C     LDATE         SETLL     FDLOTDSI
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C*
SUD01C* Read FDLOT Records
     C     RSTRTB        TAG
      *
     C                   SETOFF                                       9077
     C     LDATE         READE     FDLOTDSI                               90
     C   90              GOTO      DSPL
SUD01 *
  |  C     LRGLOC        IFNE      'R'
  |  C     WkLoc         ANDEQ     'Y'
  |  C                   GOTO      RSTRTB
SUD01C                   ENDIF
      *
     C     LRGLOC        IFEQ      'N'
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LRSTAT        IFEQ      'D'
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LRCUST        IFEQ      999990
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   If        LRQTOH-LRQTAL = *Zero
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LRCUST        IFEQ      1521
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     SIZE          IFNE      *Blanks
     C     SIZE          andNE     LRSIZE
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     SITEM         IFNE      *Blanks
     C     SITEM         andNE     LRITEM
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   Select
     C                   When      LRCUST = 999997
     C                   Z-Add     *Zero         Pt_Dec            7 2
     C                   Z-Add     *Zero         Pt_Pct            5 0
     C*                  Eval      LRCUST@ = 'PARTIAL'
      /Free
         Exec SQL // Get Partial %
           Select sum(LDPRTT)
           Into  :Pt_Dec
           From   FLOSSLOT
           Where  LDITEM = :LRITEM
             and  LDSIZE = :LDSIZE
             and  LDSOWD = :LRSOWD
             and  LDREDY = :LRCRDY;
         LRCUST@ = 'Partial';
         Pt_Pct = Pt_Dec * 100;
         If Pt_Pct <> 0;
           LRCUST@ = %editw(Pt_Pct:'    0%');
         EndIf;
      /End-Free
     C                   When      LRCUST = 999998
     C                   Eval      LRCUST@ = 'OVERRUN'
     C                   When      LRCUST = 0
     C                   Eval      LRCUST@ = ' '
     C                   Other
     C                   Eval      LRCUST@ = %CHAR(LRCUST)
     C                   EndSl
      *
     C     KEY18         KLIST
     C                   KFLD                    LRITEM
     C                   KFLD                    LRSIZE
     C                   KFLD                    LRWHSE
     C     KEY18         CHAIN     FMINVT                             90
     C**                   EXSR GETDES
     C                   MOVEL     IMDES1        DESC
      *
     C                   If        ALPHA <> *Blanks  and
     C                             %Scan(%Trim(ALPHA):IMLOOK) = 0 and
     C                             %Scan(%Trim(ALPHA):IMDES1) = 0
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   Z-ADD     LRQTOH        QTOH
     C                   Z-ADD     LRQTAL        QTAL
     C     LOTKEY        KLIST
     C                   KFLD                    LRITEM
     C                   KFLD                    LRSIZE
     C                   KFLD                    LRWHSE
     C                   KFLD                    LRSOWD
     C                   KFLD                    LRGLOC
     C     LOTKEY        CHAIN     FDLOT                              70
     C   70              DO
     C                   Z-ADD     0             LDSOWN
     C                   MOVEL     'N'           LDFIXD
     C                   ENDDO
     C     LDFIXD        IFEQ      'Y'
     C                   SETON                                        57
     C                   ELSE
     C                   SETOFF                                       57
     C                   END
     C*          LRCUST    IFEQ 0
     C*                    Z-ADDLDSOWN    QTSOW
     C*                    MOVEL'S'       TYPE
     C     LRQTOH        SUB       LRQTAL        QTAV
     C*                    ELSE
     C*                    Z-ADDLRQTCM    QTSOW
     C*                    MOVEL'C'       TYPE
     C*  57      LRQTOH    SUB  LRQTAL    QTAV
     C* N57      QTSOW     SUB  LRQTAL    QTAV
     C*          QTSOW     SUB  LRQTAL    QTAV
     C*                    SUB  LRQTSL    QTAV
     C*                    END
     C***        LRQTOH    SUB  LRQTAL    QTAV
      *
     C                   MOVEL     LRITEM        ITEM
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C     PAGE#         IFLE      0
     C     IMSIZE        IFEQ      SIZE
     C     IMLOOK        ANDGE     ALPHA
     C                   Z-ADD     RECNO         PAGE#
     C                   END
     C     SIZE          IFEQ      *BLANKS
     C     IMLOOK        ANDGE     ALPHA
     C                   Z-ADD     RECNO         PAGE#
     C                   END
     C                   END
     C                   GOTO      RSTRTB
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   MOVEL     *BLANKS       TYPE
     C                   MOVEL     *BLANKS       LRITEM
     C                   MOVEL     *BLANKS       LRSIZE
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       ITEM
     C                   Z-ADD     0             LRCUST
     C                   Z-ADD     0             QTOH
     C                   Z-ADD     0             QTAL
     C                   Z-ADD     0             QTAV
     C**                   Z-ADD0         QTSOW
     C                   MOVEL     '* End of'    DESC1            16
     C                   MOVE      ' Data * '    DESC1
     C                   MOVEL     DESC1         DESC
     C                   Eval      LRCUST@ = ' '
     C                   Eval      LRGLOC  = ' '
     C                   SETOFF                                       57
     C     PAGE#         IFLE      0
     C                   Z-ADD     1             PAGE#
     C                   END
     C                   WRITE     RECSFL
     C                   EXFMT     RECCTL
     C*************************************************************
    ?C* F3/F7 Exit from program
     C   KC
     COR KG              GOTO      EOJ
     C*************************************************************
    ?C* F8 Adjust RB Inventory
     C   KH              Do
      /FREE
       Chain SFLCSRRRN RECSFL;
       If %found();
         PITEM = Item;
         CallP GRS231(VDATE:PITEM:LRSIZE);
       EndIf;
      /END-FREE
     C                   GOTO      RLOADB
     C   KH              EndDo
     C*************************************************************
    ?C* F4 Legend Function Key
     C   KD              Do
    ?C                   Call      'XATABLE'
    ?C                   Parm      'LO'          TABID             2
    ?C                   Parm                    #KEYP#            2
    ?C                   Parm                    #EELM#            6
     C                   GOTO      RSTRTB
     C   KD              EndDo
SUD01C******************************************************************
  | ?C* F9 Toggle By Location
  |  C   KI              Do
  |  C                   If        WkSkip = 'N'
  |  C                   Eval      WkLoc  = 'Y'
  |  C                   Eval      WkSkip = 'Y'
  |  C                   Else
  |  C                   Eval      WkLoc  = 'N'
  |  C                   Eval      WkSkip = 'N'
  |  C                   Endif
  |  C                   GOTO      RLOADB
  |  C   KI              EndDo
  |  C******************************************************************
SUD01C* F5 Refresh Function Key - Goto to Main Screen
     C   KE              Do
     C                   Eval      LRCUST = *Zero
     C     SFLCSRRRN     Chain     RECSFL                             90
     C                   If        LRCUST <> 0
    ?C                   Call      'BIR245CLC'
    ?C                   Parm                    LRCUST            6 0
     C                   EndIf
     C                   GOTO      RLOADB
     C   KE              EndDo
     C                   GOTO      RSTRTA
      *
     C     EOJ           TAG
     C                   SETON                                        LR
     C******************************************************************
      * GETDES
     C******************************************************************
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC
     C                   ENDSR
      *
      ********************************************************************@DT@A1
      * VALIDATE DATES. INDICATOR 90 IS ON IF ERROR. 91-92 ALWAYS SETOF.  @DT@A1
      * YY GE 00  MM 01-12 DAY 01-28/29/30/31                             @DT@A1
      * ##MDY INPUT DATE MMDDYY                                           @DT@A1
      * ##CYMD OUTPUT DATE CYYMMDD IF DATE IS OK. ELSE ZERO.              @DT@A1
      * C IDENTIFIES 20 OR 21 CENTURY. C=0 FOR YY 70-99. C=1 FOR YY 00-69.@DT@A1
     C     @DT@A1        BEGSR                                                                 @DT@A
     C                   MOVE      ##MDY         #03A              3 0          MYY            @DT@A
     C                   MOVEL     0             #03A                           CYY            @DT@A
     C                   MOVEL     ##MDY         #04               4 0          MMDD           @DT@A
     C                   MOVEL     ##MDY         #02B              2 0          MM             @DT@A
     C                   MOVE      #04           #02C              2 0          DD             @DT@A
     C                   Z-ADD     ##MDY         ##MDY             6 0  90      YY IS NEGATIVE @DT@A
     C  N90              Z-ADD     #02B          #02               2 0    90    MM LT 01 ERROR @DT@A
     C  N90#02B          COMP      12                                 90        MM GT 12 ERROR @DT@A
     C  N90#02C          COMP      01                                   90      DD LT 01 ERROR @DT@A
     C  N90#02C          COMP      31                                 90  91    DD GT OR EQ 31 @DT@A
     C     #02B          COMP      07                                 92        MM 08-12       @DT@A
     C   921             ADD       #02B          #02                            MAKE MM ODD    @DT@A
     C     #02           DIV       2             #02                                           @DT@A
     C                   MVR                     #02                  92        31 DAY MONTH   @DT@A
     C   91
     CANN92              SETON                                        90        MM EVEN DD 31  @DT@A
     C     #02B          COMP      02                                     91    FEB            @DT@A
     C  N91                                                                                    @DT@A
     COR 90              GOTO      @DT@AX                                                      @DT@A
     C     #03A          DIV       4             #03               3 0          JUST FOR MVR   @DT@A
     C                   MVR                     #02                      91    LEAP YEAR      @DT@A
     C     #02C          COMP      29                                 90  92    DD GT 29 ERROR @DT@A
     C  N91
     CAN 92              SETON                                        90        NO LEAP DD 29  @DT@A
     C     @DT@AX        TAG                                                    GOOD DATE      @DT@A
     C                   MOVEL     #03A          ##CYMD            7 0          CYY----        @DT@A
     C                   MOVE      #04           ##CYMD                         CYYMMDD        @DT@A
     C     #03A          COMP      070                                  91                     @DT@A
     C   91              MOVEL     1             ##CYMD                         21ST CENTURY   @DT@A
     C   90              Z-ADD     0             ##CYMD                         ERROR          @DT@A
     C                   SETOFF                                       9192                     @DT@A
     C                   ENDSR                                                                 @DT@A
