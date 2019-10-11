     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *--------------------------------------------------------------
      *
      *
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ICR010
      *APPLICATION--------- MASTER FILES
      *DESCRIPTION--------- MAINTAIN RECORDS IN ITEM FILE
      *
      *
      * CHANGE--DATE-------DESCRIPTION
      *  8/18/00 EFD ADD SERIES XREF
      * 11/16/00 EFD ADD SOWING TYPE
      * 12/28/00 EFD RIGHT JUSTIFY MIX NUMBER
      *  3/29/01 EFD DO NOT ALLOW ADD IF NO SIZE CODE.
      *  5/03/02 EFD ADD LOGIC TO CALL MIX PROGRAM.
      * 10/12/05 WJB ADD LOGIC for MTITEMS.
      * 01/29/19 WJB PER BILL S. IF SIZE=SED, then UOM=MM otherwise EA
      *
     FFMINVT    UF A E           K DISK
     FFMINVTDESCUF A E           K DISK
     FFOINVT    UF A E           K DISK
     FFLKITM    UF A E           K DISK
     FFMINSER   UF A E           K DISK
WJB  FMTITEMS   UF A E           K DISK
WJB  FFMUPCITEM UF   E           K DISK
     FFSERIES   IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFMSIZC    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFPTABLE   IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMUNIT    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFSOWTYP   IF   E           K DISK
     FFSYSCTL   IF   E           K DISK
     FFMCDEF    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFLISTCD   IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFOECTL    IF   E             DISK
     FXATABL    IF   E           K DISK
     FICR010FM  CF   E             WORKSTN
      * MESSAGE ARRAY
     D MSG             S             10    DIM(14) CTDATA PERRCD(1)
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      * PROGRAM MAINLINE
      *
     D                UDS
     D  LLIST                  1      1
     D  LCANCL               133    133

wjb  D  VITEM                501    512
wjb  D  VSIZE                513    515
wjb  D  VACT                 516    516

wjb  D  IMSIZE19       S                   Like(IMSIZE)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Notes
    ?D/COPY QFunctDefn,$isIFSObj
      *
     C                   Z-ADD     0             COMP              2 0
     C     COMP          CHAIN     FOECTL                             90
     C     OCNMCO        IFEQ      1
     C                   Z-ADD     OCPRCO        IMCOMP
     C                   ELSE
     C                   Z-ADD     0             IMCOMP
     C                   ENDIF
      *
     C                   EXSR      GETHED
     C     USERID        CHAIN     FMUSER                             90
     C**N90                MOVELUSDEPT    VWHSE
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DESHFR        SHPFR
     C                   Z-ADD     1             FIRST             6 0
      *
     C                   TIME                    TIMWRK           12 0
     C                   MOVE      TIMWRK        TDATE             6 0
     C                   MOVE      TIMWRK        TDATE             6 0
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C  N90
     CANN97              MOVEL     DESHFR        VWHSE

     C                   If        VITEM <> *Blanks
     C                   Goto      SKIPA
     C                   EndIf

     C     RSTRTA        TAG
     C                   EXSR      CLRIT
     C                   UNLOCK    FMINVT
     C                   UNLOCK    FLKITM
     C                   SETOFF                                       09
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       161718
     C                   SETOFF                                       195055
     C                   SETOFF                                       707156
     C                   SETOFF                                       909192
     C                   SETOFF                                       959899
     C                   SETON                                        01
     C     OUTA          TAG
     C     FIRST         IFEQ      1
     C                   SETON                                        82
     C                   ELSE
     C                   SETON                                        83
     C                   ENDIF
     C                   WRITE     SCRNA
     C                   SETOFF                                       09
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       161718
     C                   SETOFF                                       195055
     C                   SETOFF                                       707156
     C                   SETOFF                                       909192
     C                   SETOFF                                       959899
     C                   READ      SCRNA                                  90
     C     SKIPA         Tag
     C                   ADD       1             FIRST
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
     C                   SETON                                        02
      *
      * SEE IF WE NEED ITEM SEARCH
      *
     C     VPC           IFGT      *BLANKS
     C                   GOTO      PCLOOK
     C                   ENDIF
      *
     C     1             SUBST     VITEM:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     VITEM:2       IMLOOK
     C                   MOVEL     VWHSE         IMWHSE
     C                   MOVEL     VSIZE         IMSIZE
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
     C                   MOVEL     IMITEM        VITEM
     C                   MOVEL     IMSIZE        VSIZE
     C                   MOVEL     IMWHSE        VWHSE
     C                   GOTO      OUTA
     C                   ENDIF
WJB   *
WJB  C     VITEM         IFEQ      '*NEW'
WJB  C                   CALL      'UNUSED'
WJB  C                   PARM                    VITEM
WJB  C                   GOTO      OUTA
WJB  C                   ENDIF
      *
     C     PCLOOK        TAG
     C                   MOVEL     VPC           TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     IMPCL1        PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VPC
     C                   MOVEL     PCPRCL        VPC
     C                   MOVEL     PCDESC        VDESC            30
     C                   GOTO      OUTA
     C                   ENDIF
     C     1             SUBST     VITEM:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C                   MOVEL     VPC           IMPCL1
     C     11            SUBST     VITEM:2       IMLOOK
     C                   CALL      'LKITPC'
     C                   PARM                    IMPCL1
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        VITEM
     C                   MOVEL     IMSIZE        VSIZE
     C                   MOVEL     IMWHSE        VWHSE
     C                   MOVEL     *BLANKS       VPC
     C                   GOTO      OUTA
     C                   ENDIF
      *
     C                   MOVEL     VSIZE         TST1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
WJB  C     VITEM         IFNE      *BLANKS
     C                   MOVE      *BLANKS       SZCODE            3
WJB  C                   CALL      'LKITSZ'
WJB  C                   PARM                    VITEM
WJB  C                   PARM                    SZCODE
WJB  C     SZCODE        IFNE      *BLANKS
WJB  C                   MOVEL     *BLANKS       VSIZE
WJB  C                   MOVEL     SZCODE        VSIZE
WJB  C                   ENDIF
WJB  C                   ELSE
     C                   MOVEL     VSIZE         SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       VSIZE
     C                   MOVEL     SZCODE        VSIZE
WJB  C                   ENDIF
     C*                    MOVELSZDESC    VDESC  10
     C                   SETON                                        99
     C                   GOTO      OUTA
     C                   ENDIF
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C     VACT          OREQ      'R'
     C     VACT          OREQ      'I'
     C     VACT          OREQ      'P'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C   10              GOTO      OUTA
     C     VACTOK        TAG
      *
      * ITEM NUMBER ENTERED - NO ALPHA SEARCH
      *
     C     VITEM         IFGT      *BLANKS
     C                   GOTO      ITEMY
     C                   ENDIF
      *
     C     ITEMY         TAG
      *
      * ITEM NUMBER AND ALPHA BOTH BLANK
      *
     C     VITEM         IFEQ      *BLANKS
     C     VPC           ANDEQ     *BLANKS
     C                   SETON                                        1119
     C   11              GOTO      OUTA
     C                   ENDIF
      *
      * ENTRIES IN ALL FIELDS
      *
     C*          VITEM     IFGT *BLANKS
     C*          VPC       ANDGT*BLANKS
     C*                    SETON                     1119
     C*  17                GOTO OUTA
     C*                    ENDIF
      *
     C     VACT          IFEQ      'A'
     C                   MOVEL     VITEM         IMITEM           12
     C                   MOVEL     VSIZE         IMSIZE            3
     C                   MOVEL     VWHSE         IMWHSE            3
     C     KEY18         KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
     C     KEY18         CHAIN     FMINVT                             90
     C  N90              SETON                                        1219
     C   12              GOTO      OUTA

     C                   If        IMSIZE = 'CUT' or IMSIZE = 'SED'
     C                   If        IMSIZE = 'CUT'
     C                   Eval      IMSIZE19 = 'SED'
     C                   Else
     C                   If        IMSIZE = 'SED'
     C                   Eval      IMSIZE19 = 'CUT'
     C                   EndIf
     C                   EndIf
     C     KEY19         KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE19
     C                   KFLD                    IMWHSE
     C     KEY19         SETLL     FMINVT
     C                   If        %Equal(FMINVT)
     C                   SETON                                        1719
     C   17              GOTO      OUTA
     C                   EndIf
     C                   EndIf

     C                   ENDIF
      *
      * VALIDATE SIZE CODE
      *
     C     VACT          IFEQ      'A'
     C**         VSIZE     ANDGT*BLANKS
     C                   MOVEL     VSIZE         SZCODE            3
     C     SZCODE        CHAIN     FMSIZE                             90
     C   90              SETON                                        55
     C   55              GOTO      OUTA
     C                   ENDIF
      *
      * VALIDATE LOCATION
      *
     C     VWHSE         IFGT      *BLANKS
     C                   MOVEL     VWHSE         WHWHSE
     C     KEY3B         KLIST
     C                   KFLD                    WHWHSE
     C     KEY3B         CHAIN     FMWHSE                             90
     C   90              SETON                                        56
     C   56              GOTO      OUTA
     C                   ENDIF
      *
      * SAME ITEM NUMBER - DIFFERENT SIZE OR LOCATION
      *
     C     VACT          IFNE      'A'
     C                   GOTO      NOSAME
     C                   ENDIF
     C                   MOVEL     VITEM         IMITEM           12
     C     IMITEM        SETLL     FMINVT
     C     NXI           TAG
     C     IMITEM        READE(N)  FMINVT                                 90
     C   90              GOTO      NOSAME
     C     IMSTAT        IFNE      'A'
     C                   GOTO      NXI
     C                   END
     C     VITEM         IFNE      IMITEM
     C                   MOVEL     VITEM         IMITEM
     C                   MOVEL     VSIZE         IMSIZE
     C                   MOVEL     VWHSE         IMWHSE
     C                   EXSR      CLRIT
     C                   GOTO      NOSAME
     C                   ENDIF
      * GET QTY FIELDS TO ZERO
     C                   EXSR      CLRFLD
     C     VSIZE         IFNE      IMSIZE
     C                   MOVEL     VSIZE         IMSIZE
     C                   ENDIF
     C     VWHSE         IFNE      IMWHSE
     C                   MOVEL     VWHSE         IMWHSE
     C                   ENDIF
      *
     C     NOSAME        TAG
      *
     C     VACT          IFNE      'A'
     C                   MOVEL     VITEM         IMITEM           12
     C                   MOVEL     VSIZE         IMSIZE            3
     C                   MOVEL     VWHSE         IMWHSE            3
     C     KEY18         CHAIN     FMINVT                             90
     C   90              SETON                                        1319
     C   13              GOTO      OUTA
     C                   EXSR      LODITM
     C                   ENDIF
      *
     C     VACT          IFNE      'R'
     C     IMSTAT        ANDEQ     'D'
     C                   SETON                                        1419
     C                   GOTO      OUTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'R'
     C     IMSTAT        ANDNE     'D'
     C                   SETON                                        1514
     C                   GOTO      OUTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C     IMQTOH        ANDNE     *ZEROS
     C     IMQ2OH        ANDNE     *ZEROS
     C     IMQ3OH        ANDNE     *ZEROS
     C                   SETON                                        1614
     C   16
     CAN 99              GOTO      OUTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        7050
     C                   ENDIF
      *
     C     ENDA          TAG
      *
      * LOAD MODE FOR OUTPUT
      *
     C     VACT          IFEQ      'A'
     C                   MOVEL     MSG(1)        VMODE            10
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   MOVEL     MSG(2)        VMODE
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   MOVEL     MSG(3)        VMODE
     C                   SETON                                        50
     C                   ENDIF
     C     VACT          IFEQ      'R'
     C                   MOVEL     MSG(4)        VMODE
     C                   SETON                                        50
     C                   ENDIF
     C     VACT          IFEQ      'I'
     C                   MOVEL     MSG(5)        VMODE
     C                   SETON                                        50
     C                   ENDIF
     C     VACT          IFEQ      'P'
     C                   MOVEL     MSG(14)       VMODE
     C                   SETON                                        50
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C                   Z-ADD     01            IMCOMP
     C                   EXSR      GETDEF
     C                   MOVEL     'Y'           IMPRPL
     C**                   MOVEL*BLANKS   IMLOOK
     C**                   MOVEL*BLANKS   IMDES2
     C**                   MOVEL*BLANKS   IMDES3
     C**                   MOVEL*BLANKS   IMDES4
     C                   ENDIF
     C                   SETOFF                                       858687
      *
     C     ItemSize      Chain     FMINVTDESC
     C                   If        %Found(FMINVTDESC)
     C                   Eval      S_IDDATE = IDDATE
     C                   Else
     C                   Eval      S_IDDATE = $Date(0)
     C                   Eval      IDDATE = $Date(0)
     C                   Eval      IDITEM = IMITEM
     C                   Eval      IDSIZE = IMSIZE
     C                   Write     RMINVTDESC
     C                   EndIf
      * GET SERIES XREF
     C  N74IMITEM        CHAIN     FMINSER                            66
     C   66              DO
     C                   CLEAR                   RMINSER
     C                   MOVEL     IMITEM        ISITEM
     C   74              MOVE      SECODE        ISCODE
     C   74              SetOff                                       74
     C                   ENDDO
     C     RSTRTB        TAG
      /Free
         // Bill S. instructed me to change the program such that
         // IF SIZE=SED, then UOM = MM Pricing UOM = MM and converion =1000 otherwise use EA
         Select;
           When VSIZE = '700';
             // anything goes
           When VSIZE = 'SED';
             IMPUOM='EA';
             IMLBS#=1000;
             IMSUOM='MM';
             IMMUL2 = 0  ; // added 7/29/19 per Bill S. and Rob Jr.
             IM3UOM = ' '; // added 7/29/19 per Bill S. and Rob Jr.
             IMBPUM='MM';
            Other;
             IMPUOM='EA';
             IMLBS#=0;
             IMSUOM = ' '; // added 7/29/19 per Bill S. and Rob Jr.
             IMMUL2 = 0  ; // added 7/29/19 per Bill S. and Rob Jr.
             IM3UOM = ' '; // added 7/29/19 per Bill S. and Rob Jr.
             IMBPUM='EA';
           EndSl;
         // ItemOnly Pic
         If $isIFSObj(
            '/www/zendphp7/htdocs/PICTURES/'
            + %trim(VITEM) + '.jpg');
           *In72 = *On;
           else;
           *In72 = *Off;
         ENDIF;

         // ItemSize Pic
         If $isIFSObj(
            '/www/zendphp7/htdocs/PICTURES/'
            + %trim(VITEM) + '-' + %Trim(VSIZE) + '.jpg');
           *In73 = *On;
           else;
           *In73 = *Off;
         endif;
      /End-Free
     C     IMLIST        Chain     FLISTCD
     C                   If        %Found(FLISTCD)
     C                   If        GetPrices = 1
     C                   Eval      IMSEL1 = LCSEL1
     C                   Eval      IMSEL2 = LCSEL2
     C                   Eval      IMSEL3 = LCSEL3
     C                   Eval      IMSEL4 = LCSEL4
     C                   Eval      IMSEL5 = LCSEL5
     C                   EndIf
     C                   Else
     C                   If        IMLIST <> *Blanks
     C                   Eval      LCDESC = 'Price List Code ( ' + IMLIST +
     C                                      ' ) was not found on file.'
     C                   EndIf
     C                   EndIf
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       202122
     C                   SETOFF                                       232425
     C                   SETOFF                                       262728
     C                   SETOFF                                       295152
     C                   SETOFF                                       606162
     C                   SETOFF                                       634445
     C                   SETOFF                                       909899
     C                   SETOFF                                       848567
     C                   SETOFF                                       7475
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
     C   KI              EXSR      GETHST
     C   KN              EXSR      GETINV
     C     VIEWPIC       IFEQ      1                                            Item Only Pic View
     C                   Call      'DSPITMPIC'
     C                   Parm      VITEM         ITEMSIZE16       16
     C                   GOTO      RSTRTB
     C                   ENDIF
     C     VIEWPIC       IFEQ      2                                            Item Only Pic +Add
     C                   Call      'UPLITMPIC'
     C                   Parm      VITEM         ITEMSIZE16       16
     C                   GOTO      RSTRTB
     C                   ENDIF
     C     VIEWPIC       IFEQ      3                                            Item Size Pic View
     C                   Eval      ITEMSIZE16=%Trim(VITEM)+'-'+%trim(VSIZE)
     C                   Call      'DSPITMPIC'
     C                   Parm                    ITEMSIZE16       16
     C                   GOTO      RSTRTB
     C                   ENDIF
     C     VIEWPIC       IFEQ      4                                            Item Size Pic +Add
     C                   Eval      ITEMSIZE16=%Trim(VITEM)+'-'+%trim(VSIZE)
     C                   Call      'UPLITMPIC'
     C                   Parm                    ITEMSIZE16       16
     C                   GOTO      RSTRTB
     C                   ENDIF
     C     NOTES         IFEQ      1
     C                   CallP     $Notes('FMINVT':%Trim(IMITEM)+'-'+IMSIZE)
     C                   GOTO      RSTRTB
     C                   ENDIF
     C     GETPRICES     IFEQ      1
     C                   SetOn                                        75
     C                   GOTO      RSTRTB
     C                   ENDIF
      ** IF INQUIRY SKIP CHECK AND UPDATE
     C     VACT          IFEQ      'I'
     C                   GOTO      SKIPB
     C                   END
      *
     C     IMCOMP        IFEQ      *ZEROS                                                   K
     C                   SETON                                        20
     C   20              GOTO      RSTRTB
     C                   ENDIF
      *
     C*          IMCOMP    IFGT *ZEROS                                 K
     C*                    MOVEL'00'      MCCOMP
     C*          CKEY      KLIST
     C*                    KFLD           MCCOMP
     C     IMCOMP        CHAIN(N)  FMCOMP                             96
     C   96              SETON                                        20
     C   20              GOTO      RSTRTB
     C*                    ENDIF
      *
      *
      * TEST DESCRIPTION 1
      *
     C     IMDES1        IFEQ      *BLANKS
     C                   SETON                                        21
     C   21              GOTO      RSTRTB
     C                   ENDIF
      *
     C     IMDES1        IFNE      ODES1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     IMDES1        ODES1            30
      *
     C     IMDES2        IFNE      ODES2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     IMDES2        ODES2            30
      *
     C     IMLOOK        IFEQ      *BLANKS
     C                   SETON                                        2299
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     IMDES1        IFNE      ODES1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     IMDES1        ODES1            30
     C     IMDES2        IFNE      ODES2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     IMDES2        ODES2            30
      *
     C     IMLOOK        IFEQ      *BLANKS
     C                   SETON                                        2299
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     IMLOOK        IFNE      OLOOK
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     IMLOOK        OLOOK            15
      *
     C     IMDES2        IFNE      ODES2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     IMDES2        ODES2            30
      ** CHECK SERIES
     C                   MOVEL     ISCODE        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C     9             SUBST     ISCODE:2      SEDESC
     C                   CALL      'LKSERI'
     C                   PARM                    SEDESC
     C                   PARM                    SECODE
     C                   MOVE      *BLANKS       ISCODE
     C                   MOVEL     SECODE        ISCODE
     C                   SetOn                                        74
     C                   GOTO      RSTRTB
     C                   END
     C     ISCODE        IFGT      *BLANKS
     C     ISCODE        CHAIN     FSERIES                            67
     C   67              DO
     C                   MOVE      *BLANKS       SEDESC
     C                   GOTO      RSTRTB
     C                   ENDDO                                                  67 DO
     C                   END                                                    ISCODE>"   "
     C     IMLOTC        IFEQ      'Y'
     C     ISCODE        ANDLE     *BLANKS
     C                   SETON                                        67
     C                   GOTO      RSTRTB
     C                   END
      *
      * TEST UNITS OF MEASURE VALID
      *
     C     1             SUBST     IMPUOM:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     IMPUOM        VUNIT             2
     C                   EXSR      UOMSR
     C                   MOVEL     VUNIT         IMPUOM
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     IMPUOM        IFEQ      *BLANKS
     C                   SETON                                        2324
     C   23              GOTO      RSTRTB
     C                   ENDIF
      *
     C     IMPUOM        CHAIN     FMUNIT                             96
     C   96              SETON                                        2524
     C   25              GOTO      RSTRTB
      *
     C     1             SUBST     IMSUOM:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     IMSUOM        VUNIT             2
     C                   EXSR      UOMSR
     C                   MOVEL     VUNIT         IMSUOM
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     IMSUOM        IFGT      *BLANKS
     C     IMSUOM        CHAIN     FMUNIT                             96
     C   96              SETON                                        26
     C   26              GOTO      RSTRTB
rpdelC*          IMMULT    IFLE 0.0000
rpdelC*                    SETON                     51
rpdelC*                    GOTO RSTRTB
rpdelC*                    ENDIF
     C                   ENDIF
      *
     C     1             SUBST     IM3UOM:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     IM3UOM        VUNIT             2
     C                   EXSR      UOMSR
     C                   MOVEL     VUNIT         IM3UOM
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     IM3UOM        IFGT      *BLANKS
     C     IM3UOM        CHAIN     FMUNIT                             96
     C   96              SETON                                        27
     C   27              GOTO      RSTRTB
     C     IMMUL2        IFLE      0.0000
     C                   SETON                                        52
     C                   GOTO      RSTRTB
     C                   ENDIF
     C                   ENDIF
      *
     C     IMQLB2        IFGT      *ZEROS
     C     IMQLB2        ANDLT     IMQLB1
     C                   SETON                                        60
     C   60              GOTO      RSTRTB
     C                   ENDIF
      *
     C     IMQLB3        IFGT      *ZEROS
     C     IMQLB3        ANDLT     IMQLB2
     C                   SETON                                        61
     C   61              GOTO      RSTRTB
     C                   ENDIF
      *
     C     IMQLB4        IFGT      *ZEROS
     C     IMQLB4        ANDLT     IMQLB3
     C                   SETON                                        62
     C   62              GOTO      RSTRTB
     C                   ENDIF
      *
     C     IMQLB5        IFGT      *ZEROS
     C     IMQLB5        ANDLT     IMQLB4
     C                   SETON                                        63
     C   63              GOTO      RSTRTB
     C                   ENDIF
      *
     C     1             SUBST     IMBPUM:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     IMBPUM        VUNIT             2
     C                   EXSR      UOMSR
     C                   MOVEL     VUNIT         IMBPUM
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     IMBPUM        CHAIN     FMUNIT                             96
     C   96              SETON                                        2845
     C   45              GOTO      RSTRTB
      *
     C     IMBPUM        IFEQ      IMPUOM
     C                   GOTO      UMOK
     C                   ENDIF
     C     IMBPUM        IFEQ      IMSUOM
     C                   GOTO      UMOK
     C                   ENDIF
     C     IMBPUM        IFEQ      IM3UOM
     C                   GOTO      UMOK
     C                   ENDIF
     C                   SETON                                        2844
     C   44              GOTO      RSTRTB
     C     UMOK          TAG
     C     1             SUBST     IMLIST:1      LSTTST            1
     C     LSTTST        IFEQ      '?'
     C     LSTTST        OREQ      '/'
     C                   MOVEL     IMLIST        LCCODE
     C                   CALL      'LKLIST'
     C                   PARM                    LCCODE
     C                   PARM                    LCDESC           30
     C                   MOVEL     *BLANKS       IMLIST
     C                   MOVEL     LCCODE        IMLIST
     C                   SETON                                        99
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     IMLIST        IFEQ      *BLANKS
     C                   GOTO      NOLIST
     C                   ENDIF
     C     IMLIST        CHAIN     FLISTCD                            93
     C   93              SETON                                        80
     C   80              GOTO      RSTRTB
     C     NOLIST        TAG
      *  IF FRESH OR P.K. IN BRANCHES ONLY N ALLOWED
     C     VWHSE         IFEQ      'L  '
     C     TST1          IFEQ      'F'
     C     TST1          OREQ      'P'
     C                   MOVEL     'N'           IMORDD
     C                   ENDIF
     C                   ENDIF
     C     VWHSE         IFEQ      'D  '
     C     TST1          IFEQ      'F'
     C     TST1          OREQ      'P'
     C                   MOVEL     'N'           IMORDD
     C                   ENDIF
     C                   ENDIF
     C     IMORDD        IFNE      *BLANKS
     C     IMORDD        ANDNE     'N'
     C     IMORDD        ANDNE     'Y'
     C                   SETON                                        29
     C   29              GOTO      RSTRTB
     C                   ENDIF
      *
      *
      * UPDATE ITEM SERIES XREF
      *
     C     ISCODE        IFGT      *BLANKS
     C   66              WRITE     RMINSER
     C  N66              UPDATE    RMINSER
     C                   END
      *
     C     SKIPB         TAG
     C                   EXSR      GETDES
    ?C     ItemSize      Chain     MTITEMS
    ?C     ItemSize      KList
    ?C                   KFld                    IMITEM
    ?C                   KFld                    IMSIZE
     C                   If        %Found(MTITEMS)
     C                   Eval      NeedTags = 'Y'
     C                   Else
     C                   Eval      NeedTags = 'N'
     C                   EndIf
      *
     C     RSTRTC        TAG
     C                   If        IMVEND <> 0
     C     IMVEND        Chain     FMVEND
     C                   If        not %Found(FMVEND)
     C                   Eval      VMNAME = 'Vendor ' + %Char(IMVEND)
     C                             + ' not found on file.'
     C                   EndIf
     C                   EndIf
     C                   WRITE     SCRNC
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       303132
     C                   SETOFF                                       333435
     C                   SETOFF                                       363738
     C                   SETOFF                                       394041
     C                   SETOFF                                       424365
     C                   SETOFF                                       575859
     C                   SETOFF                                       80
     C                   SETOFF                                       909899
     C                   READ      SCRNC                                  90
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
     C   KB              GOTO      RSTRTB
     C   KI              EXSR      GETHST
     C   KN              EXSR      GETINV
      ** IF INQUIRY SKIP CHECK AND UPDATE
     C     VACT          IFEQ      'I'
     C                   GOTO      SKIPC
     C                   END
      *
     C     1             SUBST     IMPCL1:1      VIMPC1            1
     C     VIMPC1        IFEQ      '?'
     C     VIMPC1        OREQ      '/'
     C                   MOVEL     IMPCL1        PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       IMPCL1
     C                   MOVEL     PCPRCL        IMPCL1
     C                   MOVEL     PCDESC        VDESC            30
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     IMPCL1        IFEQ      *BLANKS
     C                   SETON                                        30
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     IMPCL1        CHAIN     FMPRCL                             96
     C   96              SETON                                        30
     C   30              GOTO      RSTRTC
      *
     C     1             SUBST     IMPCL2:1      VIMPC2            1
     C     VIMPC2        IFEQ      '?'
     C     VIMPC2        OREQ      '/'
     C                   MOVEL     IMPCL2        PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       IMPCL2
     C                   MOVEL     PCPRCL        IMPCL2
     C                   MOVEL     PCDESC        VDESC            30
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     IMPCL2        IFGT      *BLANKS
     C     IMPCL2        CHAIN     FMPRCL                             96
     C   96              SETON                                        31
     C   31              GOTO      RSTRTC
     C                   ENDIF
      *
     C     1             SUBST     IMPCL3:1      VIMPC3            1
     C     VIMPC3        IFEQ      '?'
     C     VIMPC3        OREQ      '/'
     C                   MOVEL     IMPCL3        PCPRCL            2
     C                   CALL      'LKDISC'
     C                   PARM                    VWHSE
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       IMPCL3
     C                   MOVEL     PCPRCL        IMPCL3
     C                   MOVEL     PCDESC        VDESC            30
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C*          IMPCL3    IFGT *BLANKS
     C*          IMPCL3    CHAINFMPRCL               96
     C*  96                SETON                     32
     C*  32                GOTO RSTRTC
     C*                    ENDIF
      *
     C     IMTXBL        IFNE      'Y'
     C     IMTXBL        ANDNE     'N'
     C                   SETON                                        33
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     IMTCD1        IFNE      'Y'
     C     IMTCD1        ANDNE     'N'
     C                   SETON                                        34
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     IMTCD2        IFNE      'Y'
     C     IMTCD2        ANDNE     'N'
     C                   SETON                                        35
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     IMTCD3        IFNE      'Y'
     C     IMTCD3        ANDNE     'N'
     C                   SETON                                        36
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     IMLOTC        IFNE      'Y'
     C     IMLOTC        ANDNE     'N'
     C                   SETON                                        37
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     IMSIZE        CHAIN     FMSIZC
      *
     C     IMLOTC        IFEQ      'Y'
     C     SCCATG        ANDNE     'PLUG'
     C                   Eval      Should = 'N'
     C                   ExFmt     SCRNCLOT
     C                   EndIf
     C     IMLOTC        IFNE      'Y'
     C     SCCATG        ANDEQ     'PLUG'
     C                   Eval      Should = 'Y'
     C                   ExFmt     SCRNCLOT
     C                   EndIf
      *
     C     IMDSHF        IFNE      'Y'
     C     IMDSHF        ANDNE     'N'
     C                   SETON                                        39
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     IMPRPL        IFNE      'Y'
     C     IMPRPL        ANDNE     'N'
     C                   SETON                                        40
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C*          IMCNSF    IFNE 'Y'
     C*          IMCNSF    ANDNE'N'
     C*                    SETON                     41
     C*                    GOTO RSTRTC
     C*                    ENDIF
      *
     C     IMBOOK        IFNE      'Y'
     C     IMBOOK        ANDNE     'N'
     C                   SETON                                        42
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C  NKD              GOTO      NOVEND
     C*                  MOVEL     VMNAME        VMLOOK
     C*                  CALL      'LKVENDOR'
     C*                  PARM                    VMLOOK
     C*                  PARM                    IMCOMP
     C*                  PARM                    VMVEND
     C*                  PARM                    VMNAME
     C*                  MOVEL     VMVEND        IMVEND
     C                   CALL      'ICR013'
     C                   PARM                    IMITEM
     C                   PARM                    IMVEND
     C                   PARM                    IMVITM
     C                   GOTO      RSTRTC
     C     NOVEND        TAG
      *
     C     IMVEND        IFGT      *ZEROS
     C                   Z-ADD     IMVEND        KEY6              6 0
     C     KEY6          CHAIN     FMVEND                             96
     C  N96VMSTAT        COMP      'D'                                    96
     C   96              SETON                                        43
     C   43              GOTO      RSTRTC
     C                   ENDIF
      *
     C     IMVEND        IFEQ      *ZEROS
     C     IMROYL        ANDGT     *ZEROS
     C                   SETON                                        65
     C   65              GOTO      RSTRTC
     C                   ENDIF
      *
WJB  C                   If        NEEDTAGS <> 'Y' and
WJB  C                             NEEDTAGS <> 'N' and
WJB  C                             NEEDTAGS <> ' '
WJB  C                   Eval      *In68 = *On
WJB  C                   GoTo      RSTRTC
WJB  C                   Else
WJB ?C                   Select
WJB ?C                   When      %Found(MTITEMS) and
WJB  C                             (NeedTags = ' ' or NeedTags = 'N')
WJB ?C                   Delete    RTITEMS
WJB ?C                   When      not %Found(MTITEMS) and
WJB ?C                             NeedTags = 'Y'
WJB  C                   Eval      MTITEM = IMITEM
WJB  C                   Eval      MTSIZE = IMSIZE
WJB ?C                   Write     RTITEMS
WJB ?C                   EndSl
WJB  C                   EndIf
      *
     C   KJ              DO
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          IMMERC
     C                   GOTO      RSTRTC
     C                   ENDDO
      *
     C     IMMERC        IFGT      *ZEROS
     C                   Z-ADD     IMCOMP        GCCOMP
     C                   Z-ADD     IMMERC        GCGLNO
     C     GKEY          KLIST
     C                   KFLD                    GCCOMP
     C                   KFLD                    GCGLNO
     C     GKEY          CHAIN     FMGLCH                             90
     C   90              SETON                                        57
     C   57              GOTO      RSTRTC
     C                   ENDIF
      *
     C   KK              DO
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          IMCOGS
     C                   GOTO      RSTRTC
     C                   ENDDO
      *
     C     IMCOGS        IFGT      *ZEROS
     C                   Z-ADD     IMCOMP        GCCOMP
     C                   Z-ADD     IMCOGS        GCGLNO
     C     GKEY          CHAIN     FMGLCH                             90
     C   90              SETON                                        58
     C   58              GOTO      RSTRTC
     C                   ENDIF
      *
     C   KL              DO
     C                   EXSR      LOOK
     C                   Z-ADD     GLNO          IMINVN
     C                   GOTO      RSTRTC
     C                   ENDDO
      *
     C     IMINVN        IFGT      *ZEROS
     C                   Z-ADD     IMCOMP        GCCOMP
     C                   Z-ADD     IMINVN        GCGLNO
     C     GKEY          CHAIN     FMGLCH                             90
     C   90              SETON                                        59
     C   59              GOTO      RSTRTC
     C                   ENDIF
      *
      *  VALIDATE LIST CODE
      *
      *
      * IF NOT A GROWER SKIP GROW PARMS
      *
     C     SKIPC         TAG
     C     ZZTYPE        IFEQ      'D'
     C                   GOTO      UPADD
     C                   END
      *
     C     RSTRTD        TAG
      *
     C                   Eval      TBLONGSAO = *Blanks
     C     IMALTP        IFNE      *BLANKS
     C                   SetOff                                       47
    ?C                   Select
    ?C                   When      IMTRYC = 'D'
     C                   Eval      IMLOC_Key  = 'DC' + IMSIZE + IMALTP           Drum Code
     C     IMLOC_Key     CHAIN     XATABL                             47
    ?C                   When      IMTRYC = 'R'
     C                   Eval      IMLOC_Key  = 'NC' + IMSIZE + IMALTP           Needle Code
     C     IMLOC_Key     CHAIN     XATABL                             47
    ?C                   EndSL
     C  N47              Eval      TBLONGSAO = TBLONG
     C   47              Eval      TBLONGSAO =
     C                               'Seeder / Orifice Combination not found'
     C                   EndIf
      *   GET UPC/SKU Info
    ?C     ItemSize      Chain     FMUPCITEM
     C                   If        not %Found(FMUPCITEM)
    ?C                   Call      'CRTSKU'
    ?C                   Parm                    IMITEM
    ?C                   Parm                    IMSIZE
    ?C                   Parm                    IMDES1
    ?C                   Parm                    SKU_to_Use        5 0
    ?C     ItemSize      Chain     FMUPCITEM
     C                   EndIf
    ?C     *Like         Define    UPCDES1       Sav_UPCDES1
     C                   Eval      Sav_UPCDES1 = UPCDES1
    ?C     *Like         Define    UPCDES2       Sav_UPCDES2
     C                   Eval      Sav_UPCDES2 = UPCDES2
    ?C     *Like         Define    UPCKPIN       Sav_UPCKPIN
     C                   Eval      Sav_UPCKPIN = UPCKPIN

     C     IMSIZE        CHAIN     FMSIZC
     C     IMSIZE        Chain     FMSIZE
     C     Key18         Chain     FOINVT
     C                   If        not %Found(FOINVT)
     C                   Eval      OVSALE = *Zero
     C                   EndIf
     C                   WRITE     SCRND
     C                   Z-ADD     0             CNT               2 0
     C                   READ      SCRND                                  90
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       16
     C                   SETOFF                                       202122
     C                   SETOFF                                       232425
     C                   SETOFF                                       303132
     C                   SETOFF                                       333435
     C                   SETOFF                                       404142
     C                   SETOFF                                       434445
     C                   SETOFF                                       808199
     C                   SETOFF                                       9248
     C                   SETOFF                                       464753
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
     C   KB              GOTO      RSTRTC
     C   KI              EXSR      GETHST
     C   KN              EXSR      GETINV
     C   KK              EXSR      WEBSTUFF
      ** IF INQUIRY SKIP CHECK AND UPDATE
     C     VACT          IFEQ      'I'
     C                   GOTO      ENDALL
     C                   END
      *
      * UPDATE OVERRIDE SALEABLE CELLS
      *
    ?C                   Select
    ?C                   When      %Found(FOINVT)
    ?C                             and SZSALE = OVSALE
    ?C                             or %Found(FOINVT)
    ?C                             and OVSALE = 0
    ?C                   Delete    ROINVT
    ?C                   When      %Found(FOINVT)
    ?C                             and SZSALE <> OVSALE
    ?C                             and OVSALE <> 0
    ?C                   Update    ROINVT
    ?C                   When      not %Found(FOINVT)
    ?C                             and SZSALE <> OVSALE
    ?C                             and OVSALE <> 0
     C                   Eval      OVITEM = IMITEM
     C                   Eval      OVSIZE = IMSIZE
     C                   Eval      OVWHSE = IMWHSE
    ?C                   Write     ROINVT
    ?C                   EndSL
      *
      * UPDATE SKU DESCRIPTION
      *
     C                   If        %Found(FMUPCITEM)
     C                   If        Sav_UPCDES1 <> UPCDES1 or
     C                             Sav_UPCDES2 <> UPCDES2 or
     C                             Sav_UPCKPIN <> UPCKPIN
     C                   Eval      UPCUSER = $User()
     C                   Time                    UPCTIME
    ?C                   Update    RMUPC
     C                   EndIf
     C                   EndIf
      *
      * VALIDATE PRODUCTION WEEKS
      *
     C     IMBD1         IFGT      0
     C     IMBD1         IFLT      100
     C     IMBD1         IFGT      53
     C                   SETON                                        1013
     C                   GOTO      RSTRTD
     C                   END                                                    IMBD1>53
     C     IMED1         IFGT      100
     C     IMED1         ORLE      0
     C                   SETON                                        1114
     C                   GOTO      RSTRTD
     C                   END                                                    IMED1>100
     C                   ELSE                                                   IMBD1<100
     C                   MOVEL     IMBD1         MTST              2 0
     C                   MOVE      IMBD1         DTST              2 0
     C     MTST          IFGT      12
     C     DTST          ORLE      0
     C     DTST          ORGT      31
     C                   SETON                                        1013
     C                   GOTO      RSTRTD
     C                   END                                                    BAD DATE
     C     IMED1         IFLT      100
     C                   SETON                                        1114
     C                   GOTO      RSTRTD
     C                   END                                                    IMED1<100
     C                   END                                                    IMBD1<100
     C     IMWG1         IFLE      0
     C                   SETON                                        12
     C                   GOTO      RSTRTD
     C                   END                                                    IMWG1<1
     C                   END                                                    IMBD1>0
      *WEEK 2
     C     IMBD2         IFGT      0
     C     IMBD2         IFLT      100
     C     IMBD2         IFGT      53
     C                   SETON                                        2023
     C                   GOTO      RSTRTD
     C                   END                                                    IMBD2>53
     C     IMED2         IFGT      100
     C     IMED2         ORLE      0
     C                   SETON                                        2124
     C                   GOTO      RSTRTD
     C                   END                                                    IMED2>100
     C                   ELSE                                                   IMBD2<100
     C                   MOVEL     IMBD2         MTST              2 0
     C                   MOVE      IMBD2         DTST              2 0
     C     MTST          IFGT      12
     C     DTST          ORLE      0
     C     DTST          ORGT      31
     C                   SETON                                        2023
     C                   GOTO      RSTRTD
     C                   END                                                    BAD DATE
     C     IMED2         IFLT      100
     C                   SETON                                        2124
     C                   GOTO      RSTRTD
     C                   END                                                    IMED2<100
     C                   END                                                    IMBD2<100
     C     IMWG2         IFLE      0
     C                   SETON                                        22
     C                   GOTO      RSTRTD
     C                   END                                                    IMWG2<1
     C                   END                                                    IMBD2>0
      *WEEK 3
     C     IMBD3         IFGT      0
     C     IMBD3         IFLT      100
     C     IMBD3         IFGT      53
     C                   SETON                                        3033
     C                   GOTO      RSTRTD
     C                   END                                                    IMBD3>53
     C     IMED3         IFGT      100
     C     IMED3         ORLE      0
     C                   SETON                                        3134
     C                   GOTO      RSTRTD
     C                   END                                                    IMED3>100
     C                   ELSE                                                   IMBD3<100
     C                   MOVEL     IMBD3         MTST              2 0
     C                   MOVE      IMBD3         DTST              2 0
     C     MTST          IFGT      12
     C     DTST          ORLE      0
     C     DTST          ORGT      31
     C                   SETON                                        3033
     C                   GOTO      RSTRTD
     C                   END                                                    BAD DATE
     C     IMED3         IFLT      100
     C                   SETON                                        3134
     C                   GOTO      RSTRTD
     C                   END                                                    IMED3<100
     C                   END                                                    IMBD3<100
     C     IMWG3         IFLE      0
     C                   SETON                                        32
     C                   GOTO      RSTRTD
     C                   END                                                    IMWG3<1
     C                   END                                                    IMBD3>0
      *WEEK 4
     C     IMBD4         IFGT      0
     C     IMBD4         IFLT      100
     C     IMBD4         IFGT      53
     C                   SETON                                        3033
     C                   GOTO      RSTRTD
     C                   END                                                    IMBD4>53
     C     IMED4         IFGT      100
     C     IMED4         ORLE      0
     C                   SETON                                        3134
     C                   GOTO      RSTRTD
     C                   END                                                    IMED4>100
     C                   ELSE                                                   IMBD4<100
     C                   MOVEL     IMBD4         MTST              2 0
     C                   MOVE      IMBD4         DTST              2 0
     C     MTST          IFGT      12
     C     DTST          ORLE      0
     C     DTST          ORGT      31
     C                   SETON                                        4043
     C                   GOTO      RSTRTD
     C                   END                                                    BAD DATE
     C     IMED4         IFLT      100
     C                   SETON                                        4144
     C                   GOTO      RSTRTD
     C                   END                                                    IMED4<100
     C                   END                                                    IMBD4<100
     C     IMWG4         IFLE      0
     C                   SETON                                        42
     C                   GOTO      RSTRTD
     C                   END                                                    IMWG4<1
     C                   END                                                    IMBD4>0
      *
      *  VALIDATE MIX NUMBER
      *
     C                   MOVEL     IMMSCX        TST1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   CALL      'XATABLE'
     C                   PARM      'MX'          TABLE             2
     C                   PARM      *Blanks       TableCd           2
     C                   PARM      *Blanks       IMMSCX
     C                   SETON                                        99
     C                   GOTO      RSTRTD
     C                   Else
      * GET MIX NUMBER RIGHT JUSTIFIED
     C                   MOVE      IMMSCX        TST1              1
     C     TST1          IFLE      *BLANKS
     C                   MOVEL     IMMSCX        TST1
     C                   MOVE      *BLANKS       IMMSCX
     C                   MOVE      TST1          IMMSCX
     C                   END
     C                   ENDIF
      *
     C                   Move      *Blanks       IMMSCX_Key        8
     C     IMMSCX        IFNE      *BLANKS
     C                   Eval      IMMSCX_Key = 'MX' + IMMSCX
     C     IMMSCX_Key    CHAIN     XATABL                             46
     C   46              GOTO      RSTRTD
     C                   EndIf
      *
      *  VALIDATE SOWING TYPE
      *
     C     IMTPSW        IFEQ      *BLANKS
     C                   GOTO      NOSW
     C                   ENDIF
      *
     C     IMTPSW        IFEQ      '?'
     C     IMTPSW        OREQ      '/'
     C                   MOVEL     *BLANKS       STCODE
     C                   CALL      'LKSOWT'
     C                   PARM                    STCODE
     C                   PARM                    STDESC
     C                   MOVEL     *BLANKS       IMTPSW
     C                   MOVEL     STCODE        IMTPSW
     C                   SETON                                        99
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     IMTPSW        CHAIN     FSOWTYP                            16
     C   16              GOTO      RSTRTD
     C     NOSW          TAG
      *
      *  VALIDATE Seeder/Orifice
      *
     C     IMALTP        IFEQ      '?'
     C     IMALTP        OREQ      '/'
     C                   SETON                                        99
    ?C                   Select
    ?C                   When      IMTRYC = 'D'
     C                   CALL      'XATABLE'
     C                   PARM      'DC'          TABLE             2
     C                   PARM      *Blanks       TableCd           2
     C                   PARM      *Blanks       DrumOrif          4
    ?C                   When      IMTRYC = 'R'
     C                   CALL      'XATABLE'
     C                   PARM      'NC'          TABLE             2
     C                   PARM      *Blanks       TableCd           2
     C                   PARM      *Blanks       DrumOrif          4
    ?C                   When      IMTRYC = ' '
     C                   Move      *Blanks       DrumOrif          4
    ?C                   EndSL
     C                   Eval      IMALTP = %SubSt(DrumOrif:4:1)
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     IMALTP        IFNE      *BLANKS
    ?C                   Select
    ?C                   When      IMTRYC = 'D'
     C                   Eval      IMLOC_Key  = 'DC' + IMSIZE + IMALTP           Drum Code
     C     IMLOC_Key     CHAIN     XATABL                             47
    ?C                   When      IMTRYC = 'R'
     C                   Eval      IMLOC_Key  = 'NC' + IMSIZE + IMALTP           Needle Code
     C     IMLOC_Key     CHAIN     XATABL                             47
    ?C                   EndSL
     C  N47              Eval      TBLONGSAO = TBLONG
     C   47              Eval      TBLONGSAO =
     C                               'Seeder / Orifice Combination not found'
     C   47              GOTO      RSTRTD
     C                   EndIf
      *
      *  VALIDATE LOCATION CODE
      *
     C                   MOVEL     IMLOC         TST1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   CALL      'XATABLE'
     C                   PARM      'LC'          TABLE             2
     C                   PARM      *Blanks       TableCd           2
     C                   PARM      *Blanks       IMLOC
     C                   SETON                                        99
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C                   Move      *Blanks       IMLOC_Key         8
     C     IMLOC         IFNE      *BLANKS
     C                   Eval      IMLOC_Key  = 'LC' + IMLOC
     C     IMLOC_Key     CHAIN     XATABL                             53
     C   53              GOTO      RSTRTD
     C                   EndIf
      *
      *  VALIDATE FACTOR TABLE ID
      *
     C     IMFTAB        IFEQ      *BLANKS
     C     IMFTAB        OREQ      '**'
     C                   GOTO      NOFT
     C                   ENDIF
      *
     C                   SUBST     IMFTAB:1      TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       PTABID            2
     C                   CALL      'LKFACT'
     C                   PARM                    PTABID            2
     C                   PARM                    PTDESC           30
     C                   MOVEL     *BLANKS       IMFTAB
     C                   MOVEL     PTABID        IMFTAB
     C                   SETON                                        99
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     IMFTAB        CHAIN     FPTABLE                            92
     C   92              SETON                                        48
     C   48              GOTO      RSTRTD
     C     NOFT          TAG
      *
      *  VALIDATE TRANSPLANT SOW FROM SIZE CODE
      *
     C                   MOVEL     IMFRSZ        TST1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     VSIZE         SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       IMFRSZ
     C                   MOVEL     SZCODE        IMFRSZ
     C                   SETON                                        99
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     IMFRSZ        IFEQ      *BLANKS
     C                   GOTO      NOSIZE
     C                   ENDIF
     C     IMFRSZ        CHAIN     FMSIZE                             90
     C   90              SETON                                        81
     C   81              GOTO      RSTRTD
     C     NOSIZE        TAG
      *
      * UPDATE ITEM MASTER FILE ON DISK
      *
     C                   If        S_IDDATE <> IDDATE
     C     ItemSize      Chain     FMINVTDESC
     C                   Eval      IDDATE =  S_IDDATE
     C                   Update    RMINVTDESC
     C                   EndIf
     C     UPADD         TAG
     C     VACT          IFEQ      'I'
     C                   GOTO      ENDALL
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   MOVEL     'D'           IMSTAT
     C                   UPDATE    RMINVT
     C                   GOTO      ENDALL
     C                   ENDIF
     C     VACT          IFEQ      'P'
     C                   MOVEL     'P'           IMSTAT
     C                   UPDATE    RMINVT                                       CK BILL
     C                   GOTO      ENDALL
     C                   ENDIF
     C     VACT          IFEQ      'R'
     C                   MOVEL     'A'           IMSTAT
     C                   UPDATE    RMINVT
     C                   GOTO      ENDALL
     C                   ENDIF
     C     VACT          IFEQ      'A'
     C                   MOVEL     'A'           IMSTAT
     C                   Z-ADD     TDATE         IMDTLA
     C                   Z-ADD     TIMOD         IMTIME
     C                   WRITE     RMINVT
     C*                    MOVEL'A'       IMTYPE
     C*                    WRITERINADD
     C                   EXSR      ITML
     C*                    EXSR ADDWHS
     C                   GOTO      ENDALL
     C                   ENDIF
     C*          VACT      IFEQ 'R'
     C*                    MOVEL'A'       IMSTAT
     C*                    MOVEL'R'       IMTYPE
     C*                    WRITERINADD
     C*                    ENDIF                           VACT=R
     C*          VACT      IFEQ 'D'
     C*                    MOVEL'D'       IMSTAT
     C*                    MOVEL'D'       IMTYPE
     C*                    WRITERINADD
     C*                    ENDIF                           VACT=D
     C*          VACT      IFEQ 'C'
     C*          IMSEL1    IFNE IMOLSP
     C*          IMLOOK    ORNE IMOLOK
     C*                    MOVEL'C'       IMTYPE
     C*                    WRITERINADD
     C*                    ENDIF
     C                   Z-ADD     TDATE         IMDTLA
     C                   Z-ADD     TIMOD         IMTIME
     C                   UPDATE    RMINVT
     C                   EXSR      ITML
      ** PUT CALL HERE FOR IM#SED EQ 99
     C     IM#SED        IFEQ      99
     C                   MOVEL     IMITEM        ITEMP
     C                   MOVEL     IMSIZE        SIZEP
     C                   CALL      'ICR01M'
     C                   PARM                    ITEMP            12
     C                   PARM                    SIZEP             3
     C                   END
     C     ENDALL        TAG
     C                   EXSR      CLRIT
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C                   SETON                                        LR
      *
      *  CLRIT - THIS SUBROUTINE PROCESSES RESTART AND UPDATE OPTIONS
      *
     C     CLRIT         BEGSR
     C                   MOVE      *BLANKS       VITEM
     C**                   MOVE *BLANKS   VSIZE
     C*                    MOVE *BLANKS   VWHSE
     C*                    MOVE *BLANKS   IMITEM
     C                   MOVE      *BLANKS       IMSTAT
     C*                    MOVE *BLANKS   IMSIZE
     C                   MOVE      *BLANKS       IMLOOK
     C*                    MOVE *BLANKS   IMWHSE
     C                   MOVE      *BLANKS       IMDES1
     C                   MOVE      *BLANKS       IMDES2
     C                   MOVE      *BLANKS       IMDES3
     C                   MOVE      *BLANKS       IMDES4
     C                   MOVE      *BLANKS       IMBIN#
     C                   MOVE      *BLANKS       IMPUOM
     C                   MOVE      *BLANKS       IMSUOM
     C                   MOVE      *BLANKS       IM3UOM
     C                   MOVE      *BLANKS       IMBPUM
     C*                    MOVE *BLANKS   IMOLOK
     C*                    MOVE *BLANKS   IMPFLG
     C                   Z-ADD     *ZEROS        IMMULT
     C                   Z-ADD     *ZEROS        IMMUL2
     C                   Z-ADD     *ZEROS        IMUWGT
     C                   Z-ADD     *ZEROS        IMUCST
     C                   Z-ADD     *ZEROS        IMLCST
     C*                    Z-ADD*ZEROS    IMOLSP
     C                   Z-ADD     *ZEROS        IMSEL1
     C                   Z-ADD     *ZEROS        IMSEL2
     C                   Z-ADD     *ZEROS        IMSEL3
     C                   Z-ADD     *ZEROS        IMSEL4
     C                   Z-ADD     *ZEROS        IMSEL5
     C                   Z-ADD     *ZEROS        IMBCS1
     C                   Z-ADD     *ZEROS        IMBCS2
     C                   Z-ADD     *ZEROS        IMBCS3
     C                   Z-ADD     *ZEROS        IMBCS4
     C                   Z-ADD     *ZEROS        IMBCS5
     C                   Z-ADD     *ZEROS        IMQLB1
     C                   Z-ADD     *ZEROS        IMQLB2
     C                   Z-ADD     *ZEROS        IMQLB3
     C                   Z-ADD     *ZEROS        IMQLB4
     C                   Z-ADD     *ZEROS        IMQLB5
     C                   Z-ADD     *ZEROS        IMDIS1
     C                   Z-ADD     *ZEROS        IMDIS2
     C                   Z-ADD     *ZEROS        IMDIS3
     C                   Z-ADD     *ZEROS        IMDIS4
     C                   Z-ADD     *ZEROS        IMDIS5
     C                   MOVE      *BLANKS       IMTXBL
     C                   MOVE      'Y'           IMTCD1
     C                   MOVE      'N'           IMTCD2
     C                   MOVE      'N'           IMTCD3
     C***                  Z-ADD*ZEROS    IMFET$
     C                   Z-ADD     *ZEROS        IMVEND
     C                   Z-ADD     *ZEROS        IMSDST
     C                   MOVE      *BLANKS       IMPTYP
     C                   MOVE      *BLANKS       IMBMFL
     C                   Z-ADD     *ZEROS        IMQTSO
     C                   MOVE      *BLANKS       IMPPFG
     C                   MOVE      *BLANKS       IMLOTC
     C                   MOVE      *BLANKS       IMPCL1
     C                   MOVE      *BLANKS       IMPCL2
     C                   MOVE      *BLANKS       IMPCL3
     C                   Z-ADD     *ZEROS        IM#ORD
     C                   Z-ADD     *ZEROS        IMDTLO
     C                   Z-ADD     *ZEROS        IMQEOQ
     C                   Z-ADD     *ZEROS        IMQREO
     C                   Z-ADD     *ZEROS        IMLEAD
     C                   Z-ADD     *ZEROS        IMCOMM
     C                   Z-ADD     *ZEROS        IMQTOH
     C                   Z-ADD     *ZEROS        IMQ2OH
     C                   Z-ADD     *ZEROS        IMQ3OH
     C                   Z-ADD     *ZEROS        IMQTOO
     C                   Z-ADD     *ZEROS        IMQTAL
     C                   Z-ADD     *ZEROS        IMALC2
     C                   Z-ADD     *ZEROS        IMALC3
     C                   Z-ADD     *ZEROS        IMQTAV
     C                   Z-ADD     *ZEROS        IMQTA2
     C                   Z-ADD     *ZEROS        IMQTA3
     C                   Z-ADD     *ZEROS        IMQTBO
     C                   Z-ADD     *ZEROS        IMQMTD
     C                   Z-ADD     *ZEROS        IMQM01
     C                   Z-ADD     *ZEROS        IMQM02
     C                   Z-ADD     *ZEROS        IMQM03
     C                   Z-ADD     *ZEROS        IMQM04
     C                   Z-ADD     *ZEROS        IMQM05
     C                   Z-ADD     *ZEROS        IMQM06
     C                   Z-ADD     *ZEROS        IMQM07
     C                   Z-ADD     *ZEROS        IMQM08
     C                   Z-ADD     *ZEROS        IMQM09
     C                   Z-ADD     *ZEROS        IMQM10
     C                   Z-ADD     *ZEROS        IMQM11
     C                   Z-ADD     *ZEROS        IMQM12
     C                   Z-ADD     *ZEROS        IMQM13
     C                   Z-ADD     *ZEROS        IM$MTD
     C                   Z-ADD     *ZEROS        IM$M01
     C                   Z-ADD     *ZEROS        IM$M02
     C                   Z-ADD     *ZEROS        IM$M03
     C                   Z-ADD     *ZEROS        IM$M04
     C                   Z-ADD     *ZEROS        IM$M05
     C                   Z-ADD     *ZEROS        IM$M06
     C                   Z-ADD     *ZEROS        IM$M07
     C                   Z-ADD     *ZEROS        IM$M08
     C                   Z-ADD     *ZEROS        IM$M09
     C                   Z-ADD     *ZEROS        IM$M10
     C                   Z-ADD     *ZEROS        IM$M11
     C                   Z-ADD     *ZEROS        IM$M12
     C                   Z-ADD     *ZEROS        IM$M13
     C                   Z-ADD     *ZEROS        IMCMTD
     C                   Z-ADD     *ZEROS        IMCM01
     C                   Z-ADD     *ZEROS        IMCM02
     C                   Z-ADD     *ZEROS        IMCM03
     C                   Z-ADD     *ZEROS        IMCM04
     C                   Z-ADD     *ZEROS        IMCM05
     C                   Z-ADD     *ZEROS        IMCM06
     C                   Z-ADD     *ZEROS        IMCM07
     C                   Z-ADD     *ZEROS        IMCM08
     C                   Z-ADD     *ZEROS        IMCM09
     C                   Z-ADD     *ZEROS        IMCM10
     C                   Z-ADD     *ZEROS        IMCM11
     C                   Z-ADD     *ZEROS        IMCM12
     C                   Z-ADD     *ZEROS        IMCM13
     C                   Z-ADD     *ZEROS        IMDTLS
     C                   Z-ADD     *ZEROS        IMMERC
     C                   Z-ADD     *ZEROS        IMMADJ
     C                   Z-ADD     *ZEROS        IMISSU
     C                   Z-ADD     *ZEROS        IMQPHY
     C                   Z-ADD     *ZEROS        IMQPH2
     C                   Z-ADD     *ZEROS        IMQPH3
     C                   Z-ADD     *ZEROS        IMBPOH
     C                   MOVEL     *BLANKS       IMCYCD
     C                   MOVEL     *BLANKS       IMLIST
     C                   MOVEL     *BLANKS       IMFRSZ
     C                   Z-ADD     *ZEROS        IMROYL
     C                   MOVEL     *BLANKS       IMUSER
     C                   MOVEL     *BLANKS       IMCDFL
     C                   MOVEL     *BLANKS       IMBOOK
     C                   MOVEL     *BLANKS       IMVITM
     C                   Z-ADD     *ZEROS        IMMERC
     C                   Z-ADD     *ZEROS        IMCOGS
     C                   Z-ADD     *ZEROS        IMINVN
     C                   MOVEL     *BLANKS       IMCWTF
     C                   MOVEL     *BLANKS       IMPRPL
     C                   Z-ADD     *ZEROS        IMCUBE
     C                   Z-ADD     *ZEROS        IMFCST
     C                   Z-ADD     *ZEROS        IMLBS#
     C                   MOVEL     *BLANKS       IMDSHF
     C                   MOVEL     *BLANKS       IMLHST
     C                   Z-ADD     *ZEROS        IMQPH#
     C                   Z-ADD     *ZEROS        IM3CS1
     C                   Z-ADD     *ZEROS        IM3CS2
     C                   Z-ADD     *ZEROS        IM3CS3
     C                   Z-ADD     *ZEROS        IM3CS4
     C                   Z-ADD     *ZEROS        IM3CS5
     C                   MOVEL     *BLANKS       IMCNSF
     C                   Z-ADD     *ZEROS        IMBD1
     C                   Z-ADD     *ZEROS        IMBD2
     C                   Z-ADD     *ZEROS        IMBD3
     C                   Z-ADD     *ZEROS        IMBD4
     C                   Z-ADD     *ZEROS        IMED1
     C                   Z-ADD     *ZEROS        IMED2
     C                   Z-ADD     *ZEROS        IMED3
     C                   Z-ADD     *ZEROS        IMED4
     C                   Z-ADD     *ZEROS        IMWG1
     C                   Z-ADD     *ZEROS        IMWG2
     C                   Z-ADD     *ZEROS        IMWG3
     C                   Z-ADD     *ZEROS        IMWG4
     C                   MOVEL     *BLANKS       IMSOWC
     C                   MOVEL     *BLANKS       IMTRYC
     C                   MOVEL     *BLANKS       IMLOC
     C                   Z-ADD     *ZEROS        IM#SED
     C                   MOVEL     *BLANKS       IMTPSW
     C                   MOVEL     *BLANKS       IMMSCX
     C                   MOVEL     *BLANKS       IMORDD
     C                   MOVEL     *BLANKS       ISITEM
     C                   MOVEL     *BLANKS       ISCODE
     C                   Z-ADD     *ZEROS        ISVEND
     C*                    Z-ADD*ZEROS    IMGERM
     C                   ENDSR
      *
      *  CLRFLD  THIS SUBROUTINE PROCESSES RESTART AND UPDATE OPTIONS
      *
     C     CLRFLD        BEGSR
     C                   Z-ADD     *ZEROS        IM#ORD
     C                   Z-ADD     *ZEROS        IMDTLO
     C                   Z-ADD     *ZEROS        IMQTOH
     C                   Z-ADD     *ZEROS        IMQ2OH
     C                   Z-ADD     *ZEROS        IMQ3OH
     C                   Z-ADD     *ZEROS        IMQTOO
     C                   Z-ADD     *ZEROS        IMQTAL
     C                   Z-ADD     *ZEROS        IMALC2
     C                   Z-ADD     *ZEROS        IMALC3
     C                   Z-ADD     *ZEROS        IMQTAV
     C                   Z-ADD     *ZEROS        IMQTA2
     C                   Z-ADD     *ZEROS        IMQTA3
     C                   Z-ADD     *ZEROS        IMQTBO
     C                   Z-ADD     *ZEROS        IMQMTD
     C                   Z-ADD     *ZEROS        IMQM01
     C                   Z-ADD     *ZEROS        IMQM02
     C                   Z-ADD     *ZEROS        IMQM03
     C                   Z-ADD     *ZEROS        IMQM04
     C                   Z-ADD     *ZEROS        IMQM05
     C                   Z-ADD     *ZEROS        IMQM06
     C                   Z-ADD     *ZEROS        IMQM07
     C                   Z-ADD     *ZEROS        IMQM08
     C                   Z-ADD     *ZEROS        IMQM09
     C                   Z-ADD     *ZEROS        IMQM10
     C                   Z-ADD     *ZEROS        IMQM11
     C                   Z-ADD     *ZEROS        IMQM12
     C                   Z-ADD     *ZEROS        IMQM13
     C                   Z-ADD     *ZEROS        IM$MTD
     C                   Z-ADD     *ZEROS        IM$M01
     C                   Z-ADD     *ZEROS        IM$M02
     C                   Z-ADD     *ZEROS        IM$M03
     C                   Z-ADD     *ZEROS        IM$M04
     C                   Z-ADD     *ZEROS        IM$M05
     C                   Z-ADD     *ZEROS        IM$M06
     C                   Z-ADD     *ZEROS        IM$M07
     C                   Z-ADD     *ZEROS        IM$M08
     C                   Z-ADD     *ZEROS        IM$M09
     C                   Z-ADD     *ZEROS        IM$M10
     C                   Z-ADD     *ZEROS        IM$M11
     C                   Z-ADD     *ZEROS        IM$M12
     C                   Z-ADD     *ZEROS        IM$M13
     C                   Z-ADD     *ZEROS        IMCMTD
     C                   Z-ADD     *ZEROS        IMCM01
     C                   Z-ADD     *ZEROS        IMCM02
     C                   Z-ADD     *ZEROS        IMCM03
     C                   Z-ADD     *ZEROS        IMCM04
     C                   Z-ADD     *ZEROS        IMCM05
     C                   Z-ADD     *ZEROS        IMCM06
     C                   Z-ADD     *ZEROS        IMCM07
     C                   Z-ADD     *ZEROS        IMCM08
     C                   Z-ADD     *ZEROS        IMCM09
     C                   Z-ADD     *ZEROS        IMCM10
     C                   Z-ADD     *ZEROS        IMCM11
     C                   Z-ADD     *ZEROS        IMCM12
     C                   Z-ADD     *ZEROS        IMCM13
     C                   Z-ADD     *ZEROS        IMMADJ
     C                   Z-ADD     *ZEROS        IMISSU
     C                   Z-ADD     *ZEROS        IMQPHY
     C                   Z-ADD     *ZEROS        IMQPH2
     C                   Z-ADD     *ZEROS        IMQPH3
     C                   Z-ADD     *ZEROS        IMBPOH
     C                   MOVEL     *BLANKS       IMUSER
     C**                   MOVEL*BLANKS   IMVITM
     C**                   MOVEL*BLANKS   IMCWTF
     C**                   MOVEL*BLANKS   IMPRPL
     C                   Z-ADD     *ZEROS        IMCUBE
     C                   Z-ADD     *ZEROS        IMFCST
     C                   Z-ADD     *ZEROS        IMLBS#
     C**                   MOVEL*BLANKS   IMDSHF
     C**                   MOVEL*BLANKS   IMLHST
     C                   Z-ADD     *ZEROS        IMQPH#
     C                   ENDSR
      *
      *  ADDWHS  THIS SUBROUTINE ADDS RECORDS TO ALL WHSES
      *
     C*          ADDWHS    BEGSR
     C*                    TIME           IMTIME
     C*                    Z-ADD0         IMOLSP
     C*                    MOVE *BLANKS   IMOLOK
     C*                    MOVELIMLOOK    HLDLOK 15
     C*          VWHSE     IFEQ 'F  '
     C*          VWHSE     OREQ 'S  '
     C*          VWHSE     OREQ 'P  '
     C*                    MOVEL'L  '     IMWHSE
     C*          KEY18     CHAINFMINVT               85
     C*  85                DO
     C*                    EXSR CLRFLD
     C*                    MOVELHLDLOK    LOOK14 14
     C*                    MOVELFCODE     IMLOOK
     C*                    MOVE LOOK14    IMLOOK
     C*          FCODE     IFEQ 'P'
     C*          FCODE     OREQ 'F'
     C*                    MOVEL'N'       IMORDD
     C*                    ENDIF
     C*                    Z-ADDTDATE     IMDTLA
     C*                    Z-ADDTIMOD     IMTIME
     C*                    WRITERMINVT
     C*                    MOVEL'A'       IMTYPE
     C*                    WRITERINADD
     C*                    EXSR ITML
     C*                    ENDDO
     C*                    MOVEL'D  '     IMWHSE
     C*          KEY18     CHAINFMINVT               85
     C*  85                DO
     C*                    EXSR CLRFLD
     C*                    MOVELHLDLOK    LOOK14 14
     C*                    MOVELFCODE     IMLOOK
     C*                    MOVE LOOK14    IMLOOK
     C*          FCODE     IFEQ 'P'
     C*          FCODE     OREQ 'F'
     C*                    MOVEL'N'       IMORDD
     C*                    ENDIF
     C*                    Z-ADDTDATE     IMDTLA
     C*                    Z-ADDTIMOD     IMTIME
     C*                    WRITERMINVT
     C*                    MOVEL'A'       IMTYPE
     C*                    WRITERINADD
     C*                    EXSR ITML
     C*                    ENDDO
     C*                    GOTO ENDADD
     C*                    ENDIF
     C*          VWHSE     IFEQ 'L  '
     C*                    MOVEL'D  '     IMWHSE
     C*          KEY18     CHAINFMINVT               85
     C*  85                DO
     C*                    EXSR CLRFLD
     C*                    MOVELHLDLOK    IMLOOK
     C*                    Z-ADDTDATE     IMDTLA
     C*                    Z-ADDTIMOD     IMTIME
     C*                    WRITERMINVT
     C*                    MOVEL'A'       IMTYPE
     C*                    WRITERINADD
     C*                    EXSR ITML
     C*                    ENDDO
     C*                    MOVE *BLANKS   IMWHSE
     C*                    MOVELFCODE     IMWHSE
     C*          KEY18     CHAINFMINVT               85
     C*  85                DO
     C*                    EXSR CLRFLD
     C*                    MOVE HLDLOK    LOOK14 14
     C*                    MOVE *BLANKS   IMLOOK
     C*                    MOVELLOOK14    IMLOOK
     C*          FCODE     IFEQ 'P'
     C*          FCODE     OREQ 'F'
     C*                    MOVEL'N'       IMORDD
     C*                    ENDIF
     C*                    Z-ADDTDATE     IMDTLA
     C*                    Z-ADDTIMOD     IMTIME
     C*                    WRITERMINVT
     C*                    MOVEL'A'       IMTYPE
     C*                    WRITERINADD
     C*                    EXSR ITML
     C*                    ENDDO
     C*                    GOTO ENDADD
     C*                    ENDIF
     C*          VWHSE     IFEQ 'D  '
     C*                    MOVEL'L  '     IMWHSE
     C*          KEY18     CHAINFMINVT               85
     C*  85                DO
     C*                    EXSR CLRFLD
     C*                    MOVELHLDLOK    IMLOOK
     C*                    Z-ADDTDATE     IMDTLA
     C*                    Z-ADDTIMOD     IMTIME
     C*                    WRITERMINVT
     C*                    MOVEL'A'       IMTYPE
     C*                    WRITERINADD
     C*                    EXSR ITML
     C*                    ENDDO
     C*                    MOVE *BLANKS   IMWHSE
     C*                    MOVELFCODE     IMWHSE
     C*          KEY18     CHAINFMINVT               85
     C*  85                DO
     C*                    EXSR CLRFLD
     C*                    MOVELHLDLOK    LOOK14 14
     C*                    MOVE *BLANKS   IMLOOK
     C*                    MOVELLOOK14    IMLOOK
     C*          FCODE     IFEQ 'P'
     C*          FCODE     OREQ 'F'
     C*                    MOVEL'N'       IMORDD
     C*                    ENDIF
     C*                    Z-ADDTDATE     IMDTLA
     C*                    Z-ADDTIMOD     IMTIME
     C*                    WRITERMINVT
     C*                    MOVEL'A'       IMTYPE
     C*                    WRITERINADD
     C*                    EXSR ITML
     C*                    ENDDO
     C*                    GOTO ENDADD
     C*                    ENDIF
     C*          ENDADD    ENDSR
      *
      *  LODITM - LOAD FIELDS INTO OLD FIELDS
      *
     C     LODITM        BEGSR
     C                   MOVEL     IMLOOK        OLOOK            15
     C*                    MOVELIMLOOK    IMOLOK
     C*                    Z-ADDIMSEL1    IMOLSP
     C                   ENDSR
      *
      * ITML - UPDATE FLKITM FILE (ALPHA SEARCH)
      *
     C     ITML          BEGSR
      ** GET RECORD
     C     KEY18         CHAIN     FLKITM                             77
      ** TAKE CARE OF DELETES
     C     IMSTAT        IFEQ      'D'
     C     IMPRPL        OREQ      'N'
     C  N77              DELETE    RLKITM
     C                   GOTO      ENDLKI
     C                   END
      ** NOW ALL OTHERS
     C                   Z-ADD     0             #OPRC             9 4
     C                   Z-ADD     0             OIQDDC            4 2
     C                   Z-ADD     0             OHBLCU            6 0
     C                   Z-ADD     0             OHORD#            6 0
     C                   Z-ADD     1             QTYORD            8 1
     C                   MOVEL     '1'           PRICD             1
     C                   MOVEL     'N'           OICTCD            1
     C                   MOVEL     'N'           OIFRQD            1
     C                   Z-ADD     0             VOLDSC            4 2
     C                   CALL      '#PRICE'
     C                   PARM                    OHBLCU
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMBPUM
     C                   PARM                    QTYORD
     C                   PARM                    PRICD
     C                   PARM                    #OPRC
     C                   PARM                    OIQDDC
     C                   PARM                    OICTCD
     C                   PARM                    VOLDSC
     C                   PARM                    OIFRQD
     C                   PARM                    OHORD#
     C                   PARM                    IMORDD
     C                   Z-ADD     #OPRC         LKUPRI
      * GET DESCRIPTION
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         LKDES1
     C                   MOVEL     IMITEM        LKITEM
     C                   MOVEL     IMSIZE        LKSIZE
     C                   MOVEL     IMWHSE        LKWHSE
     C                   Z-ADD     IMCOMP        LKCOMP
     C                   MOVEL     IMITEM        LKITEM
     C                   Z-ADD     IMQTOH        LKPOH
     C                   Z-ADD     IMQTAL        LKPAL
      * GET NEXT LATER
     C   77              Z-ADD     0             LKNOH
     C   77              Z-ADD     0             LKNAL
     C                   MOVEL     IMLOOK        LKLOOK
     C   77              WRITE     RLKITM
     C  N77              UPDATE    RLKITM
     C     ENDLKI        ENDSR
      *
      * GETHED - THIS SUBROUTINE GETS HEADINGS BY SYSCTL TYPE
      *
     C     GETHED        BEGSR
     C                   READ      FSYSCTL                                90
     C     ZZTYPE        IFEQ      'D'
     C                   MOVEL     MSG(10)       DES1
     C                   MOVEL     MSG(11)       DES2
     C                   MOVEL     MSG(12)       DES3
     C                   MOVEL     MSG(13)       DES4
     C                   ELSE
     C                   MOVEL     MSG(6)        DES1
     C                   MOVEL     MSG(7)        DES2
     C                   MOVEL     MSG(8)        DES3
     C                   MOVEL     MSG(9)        DES4
     C                   ENDIF
     C                   ENDSR
      *
      *  GETDEF - THIS SUBROUTINE GETS DEFAULT DATA FROM MCDEF ON ADD
      *
     C     GETDEF        BEGSR
     C                   SETOFF                                       49        EFD
     C     IMCOMP        CHAIN     FMCDEF                             98
     C                   MOVEL     CDBOOK        IMBOOK
     C                   MOVEL     CDLOTC        IMLOTC
     C                   MOVEL     CDPDSL        IMDSHF
     C                   MOVEL     CDCNSF        IMCNSF
     C                   MOVE      CDTXBL        IMTXBL
     C     CDTXBL        IFEQ      'N'
     C                   MOVE      'N'           IMTCD1
     C                   MOVE      'N'           IMTCD2
     C                   MOVE      'N'           IMTCD3
     C                   ENDIF
     C     GDFKEY        KLIST                                                  EFD
     C                   KFLD                    IMCOMP                          
     C                   KFLD                    GDTYP                           
     C                   MOVEL     '01'          GDTYP             2             
     C     GDFKEY        CHAIN     FGLDF                              49         
     C  N49              Z-ADD     GDSALE        IMMERC                          
     C  N49              Z-ADD     GDINVN        IMINVN                          
     C  N49              Z-ADD     GDCOGS        IMCOGS                         EFD
     C                   ENDSR
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC             60
     C                   ENDSR
      *
      *********
      * UOMSR
      *********
     C     UOMSR         BEGSR
     C                   MOVEL     VUNIT         UNCODE            2
     C                   CALL      'LKUOM'
     C                   PARM                    UNCODE
     C                   PARM                    UNDESC           30
     C                   MOVEL     *BLANKS       VUNIT
     C                   MOVEL     UNCODE        VUNIT
     C                   ENDSR
      *
      *********
      * LOOK  *
      *********
     C     LOOK          BEGSR
     C                   Z-ADD     IMCOMP        GCCOMP
     C                   MOVEL     *BLANKS       GCLOOK
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    GCCOMP
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   MOVEL     GCGLNO        GLNO              8 0
     C                   ENDSR
      *
      ****************************************************************
      *     Populate Website Descriptions                            *
      ****************************************************************
     C     WebStuff      BEGSR
     C     ItemSize      Chain     FMINVTDESC
     C                   Eval      IDITEM = IMITEM
     C                   Eval      IDSIZE = IMSIZE
     C     RSTRTE        TAG
     C                   ExFmt     SCRNE
     C                   If        *InKB or *InKF
     C                   LeaveSR
     C                   EndIf
     C                   ExFmt     SCRNF
     C   KB              Goto      RSTRTE
     C   KF              LeaveSR
     C                   If        %Found(FMINVTDESC)
     C                   Update    RMINVTDESC
     C                   Else
     C                   Write     RMINVTDESC
     C                   EndIF
     C                   ENDSR
      *
      ****************************************************************
      *     CALL ITEM HISTORY INQUIRY PROGRAM                        *
      ****************************************************************
     C     GETHST        BEGSR
     C                   MOVEL     DESC          IMDESC           30
     C                   CALL      'KP0023R'
     C                   PARM                    IMITEM           12
     C                   PARM                    IMSIZE            3
     C                   PARM                    IMDESC
     C                   PARM                    EOJ               1
     C                   ENDSR
     C     GETINV        BEGSR
     C                   MOVEL     DESC          IMDESC           30
     C                   CALL      'KP0022R'
     C                   PARM                    IMITEM           12
     C                   PARM                    IMSIZE            3
     C                   PARM                    IMDESC
     C                   PARM                    EOJ               1
     C                   ENDSR
      *
**
   Add                                                     1
  Change                                                   2
  Delete                                                   3
Reactivate                                                 4
 Inquiry                                                   5
  Genus:                                                   6
Species:                                                   7
Variety:                                                   8
 Common:                                                   9
Desc. 1:                                                  10
Desc. 2:                                                  11
Desc. 3:                                                  12
Desc. 4:                                                  13
  Purge                                                   14
