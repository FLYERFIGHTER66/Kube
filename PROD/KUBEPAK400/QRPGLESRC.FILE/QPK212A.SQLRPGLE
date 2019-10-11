      ***PROGRAM NAME------------------QPK212A
      ***PROGRAMMER--------------------JWM
      ***APPLICATION-------------------PRINT SOWING SCHEDULE
      **** CHANGES LOG ---
      *  9/23/98 EFD MAKE NATIVE AND PRINT ON *NAR.
      * 12/10/98 GD  INCLUDE ALL RECORDS EQ OR LESS THAN LDA DATE
      * 12/10/98 GD  - OR - INCLUDE SOW DATE ONLY
      * 12/15/00 EFD ADD REQ DATE TO COMPARE TO SPLIT-UP OVERLAP WEEKS
      *
     FFIORDRSP  UF   E           K DISK
     FFLABL     O  A E             DISK
     FFMCUST    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFPTABLE   IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCALEN    IF   E           K DISK
     FPRINT     O    F   80        PRINTER OFLIND(*INOF)
     FLBLCNT    O    F   80        PRINTER OFLIND(*INOV)

     D  Order          S              7S 0
     D  ToSow          S              7S 0

      ** PTABLE ARRAYS
     D PMN             S              7  0 DIM(12)                              MINIMUM
     D PMX             S              7  0 DIM(12)                              MAXIMUM
     D PUN             S              5  0 DIM(12)                              FACTOR UNITS
     D PPC             S              5  2 DIM(12)                              FACTOR %
      ************
      *  LDA     *
      ************
     D                UDS
     D  USERID                 1      8
     D  WSID                   9     10
     D  PLDATE                11     16  0
     D  POST                  17     17
     D  REMOVE                18     18
     D  LIDATE                19     19
     D  CONAM                 31     60
     D  LFRPC                 61     62
     D  LTOPC                 63     64
     D  SUMDET                65     65
     D  LQUERY                66     66  0
     D  LLABEL                67     67
     D  LPRTQY                68     68
     D  LCANCL               133    133
      *
     IRPTABLE
     I              PTBQ01                      PMN(1)
     I              PTBQ02                      PMN(2)
     I              PTBQ03                      PMN(3)
     I              PTBQ04                      PMN(4)
     I              PTBQ05                      PMN(5)
     I              PTBQ06                      PMN(6)
     I              PTBQ07                      PMN(7)
     I              PTBQ08                      PMN(8)
     I              PTBQ09                      PMN(9)
     I              PTBQ10                      PMN(10)
     I              PTBQ11                      PMN(11)
     I              PTBQ12                      PMN(12)
     I              PTEQ01                      PMX(1)
     I              PTEQ02                      PMX(2)
     I              PTEQ03                      PMX(3)
     I              PTEQ04                      PMX(4)
     I              PTEQ05                      PMX(5)
     I              PTEQ06                      PMX(6)
     I              PTEQ07                      PMX(7)
     I              PTEQ08                      PMX(8)
     I              PTEQ09                      PMX(9)
     I              PTEQ10                      PMX(10)
     I              PTEQ11                      PMX(11)
     I              PTEQ12                      PMX(12)
     I              PTUN01                      PUN(1)
     I              PTUN02                      PUN(2)
     I              PTUN03                      PUN(3)
     I              PTUN04                      PUN(4)
     I              PTUN05                      PUN(5)
     I              PTUN06                      PUN(6)
     I              PTUN07                      PUN(7)
     I              PTUN08                      PUN(8)
     I              PTUN09                      PUN(9)
     I              PTUN10                      PUN(10)
     I              PTUN11                      PUN(11)
     I              PTUN12                      PUN(12)
     I              PTPE01                      PPC(1)
     I              PTPE02                      PPC(2)
     I              PTPE03                      PPC(3)
     I              PTPE04                      PPC(4)
     I              PTPE05                      PPC(5)
     I              PTPE06                      PPC(6)
     I              PTPE07                      PPC(7)
     I              PTPE08                      PPC(8)
     I              PTPE09                      PPC(9)
     I              PTPE10                      PPC(10)
     I              PTPE11                      PPC(11)
     I              PTPE12                      PPC(12)
      ****************
      * START HERE   *
      ****************
     C     LIDATE        IFEQ      'Y'
     C                   SETON                                        35
     C                   ENDIF
     C     LIDATE        IFEQ      'N'
     C                   SETON                                        36
     C                   ENDIF
      *
     C                   Z-ADD     PLDATE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RDATE             5 0
     C                   Z-ADD     ##CYMD        KDATE             7 0
      *
     C     LIDATE        IFEQ      'Y'
     C     KDATE         SETLL     FIORDRSP
     C                   ENDIF
     C     NXT           TAG
     C     LIDATE        IFEQ      'Y'
     C     KDATE         READE     FIORDRSP                               90
     C   90              GOTO      END
     C                   ENDIF
      *
     C     LIDATE        IFEQ      'N'
     C                   READ      FIORDRSP                               90
     C   90              GOTO      END
     C                   ENDIF
      *
      ** SEE IF WE NEED THIS RECORD
      *
     C     LIDATE        IFEQ      'N'
     C                   Z-ADD     OISOW         ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         SDATE             5 0
     C                   ENDIF
     C     LIDATE        IFEQ      'N'
     C     SDATE         ANDGT     RDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OIPRCL        IFLT      LFRPC
     C     OIPRCL        ORGT      LTOPC
     C                   GOTO      NXT
     C                   END
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   END
     C   15OIPOST        IFEQ      'Y'
     C                   GOTO      NXT
     C                   END
     C     OIPOST        IFEQ      'Y'
     C     POST          ANDEQ     'N'
     C     REMOVE        ANDEQ     'N'
     C                   GOTO      NXT
     C                   END
     C     OIITYP        IFNE      ' '
     C     OILOTC        OREQ      'Y'
     C     OILOT#        andeq     *Blanks
     C     OISTA         OREQ      'Y'
     C                   GOTO      NXT
     C                   END
      ** SEE IF WE NEED LEVEL 3 BREAK
     C     OIPRCL        IFNE      OPRCL
     C                   EXSR      L1TOT
     C                   EXSR      L2TOTL
     C                   EXSR      L3TOTL
     C                   GOTO      NOL1
     C                   END
      ** SEE IF WE NEED LEVEL 1 BREAK   FOR ITEM AND SIZE
     C     OIITEM        IFNE      OITEM
     C     OISIZE        ORNE      OSIZE
     C     OIDTRQ        ORNE      ODTRQ
     C                   EXSR      L1TOT
     C                   END
      ** SEE IF WE NEED LEVEL 1 BREAK   REQ DATE
     C     OIDTRQ        IFNE      ODTRQ
     C     ODTRQ         ANDGT     0
     C                   EXSR      L1TOT
     C                   END
     C     NOL1          TAG
     C* TOTAL EACH ITEM
     C                   Z-ADD     OIQORD        WRKORD           10 1
     C                   ADD       WRKORD        ITOTAL            6 1
     C                   ADD       WRKORD        GRTOT            10 1
     C                   ADD       WRKORD        L2TOT            10 1
     C                   ADD       WRKORD        L3TOT            10 1
     C* CHECK CUST TYPE AND ACCUMLATE TOTAL
     C     OICUST        CHAIN     FMCUST                             21
     C  N21PTCTYP        IFNE      *BLANKS
     C     PTCTYP        IFEQ      CMCTYP
     C                   ADD       WRKORD        SKPTOT           10 1
     C                   END
     C                   END
     C                   Z-ADD     OIDTRQ        ODTRQ             6 0
      ** CHECK FOR FLAGS
     C   15              MOVEL     'Y'           OIPOST
     C   20              MOVE      *BLANKS       OIPOST
     C                   UPDATE    RIORDR
     C                   GOTO      NXT
     C* END
     C     END           TAG
     C                   EXSR      L1TOT
     C                   EXSR      L2TOTL
     C                   EXSR      L3TOTL
     C                   EXCEPT    LRTOTL
     C     LLABEL        IFEQ      'Y'
     C                   EXCEPT    LRTOLL
      *
     C                   END
     C                   SETON                                        LR
      *
      *********
      * L1TOT *
      *********
     C     L1TOT         BEGSR
     C     OITEM         IFGT      *BLANKS
     C                   Z-ADD     ITOTAL        SOWQTY            6 1
     C     SOWQTY        MULT      2             NUMLBL           10 1
     C                   Z-ADD     SOWQTY        SIGLBL           10 1
     C                   Z-ADD     SKPTOT        WRKSKP            5 0
     C     SOWQTY        SUB       WRKSKP        WRKQTY            5 1
     C     IMFTAB        IFEQ      '**'
     C                   GOTO      ENDPTB
     C                   END
     C* CALCULATE NUMBERR OF LABELS
     C                   DO        12            X                 2 0          OBSOLETE      961107
     C     WRKQTY        IFGE      PMN(X)                                       OBSOLETE      961107
     C     WRKQTY        IFLE      PMX(X)                                       OBSOLETE      961107
     C     PUN(X)        IFGT      0                                            OBSOLETE      961107
     C     WRKQTY        ADD       PUN(X)        WRKFLD            5 0          OBSOLETE      051202
     C                   ELSE                                                   OBSOLETE      961107
     C     PPC(X)        DIV(H)    100           PCTWK             5 4          OBSOLETE      961107
     C     1.00          ADD       PCTWK         PCTM              5 4          OBSOLETE      970110
     C     WRKQTY        MULT(H)   PCTM          WRKFLD                         OBSOLETE      961107
WJB  C     WRKQTY        MULT(H)   PCTM          WRKFLDdec         9 9          OBSOLETE      051202
WJB  C     WRKFLDdec     IFLT      .5                                           OBSOLETE      051202
WJB  C     WRKFLDdec     ANDGT     0                                            OBSOLETE      051202
WJB  C                   ADD       1             WRKFLD                         OBSOLETE      051202
WJB  C                   END                                                    OBSOLETE      051202
     C                   END                                                    OBSOLETE      961107
     C     WRKFLD        ADD       WRKSKP        WRKFLD                         OBSOLETE      970110
     C     WRKFLD        MULT      2             NUMLBL           10 1          OBSOLETE      990618
     C                   Z-ADD     WRKFLD        SIGLBL           10 1          OBSOLETE      990618
     C                   END                                                    OBSOLETE      961106
     C                   END                                                    OBSOLETE      961106
     C                   EndDo                                                  OBSOLETE      061011
     C                   MOVE      SIGLBL        TEST1             1 0          OBSOLETE      980917
     C     TEST1         IFGT      0                                            OBSOLETE      980917
     C     SIGLBL        ADD       1             LALBQT            6 0          OBSOLETE      980917
     C                   ELSE                                                   OBSOLETE      980917
     C                   Z-ADD     SIGLBL        LALBQT                         OBSOLETE      980917
     C                   Z-ADD     SIGLBL        LALBQT                         OBSOLETE      980917
     C                   END                                                    OBSOLETE      980917
      /Free
         Exec SQL
           SELECT  sum(OIQORD)
           INTO   :Order
           FROM    FIORDR
           WHERE   OISOW  = :OSOW
             and   OIITEM = :OITEM
             and   OISIZE = :OSIZE
             and   OISTAT = 'A'
             and   OIITYP = ' ';
      /End-Free
     C                   Call      '#SOWFACTOR'
     C                   Parm                    IMITEM
     C                   Parm                    IMSIZE
     C                   Parm                    IMFTAB
     C                   Parm                    Order
     C                   Parm                    ToSow
     C                   Eval      Order = WRKQTY
     C                   Z-ADD     *Zero         Scheduled        10 1
      /Free
         If LQUERY <> 3;
           Exec SQL
             SELECT  sum(SOSOWT)
             INTO   :Scheduled
             FROM    FSOWSCH
             WHERE   SOSOWD = :OSOW
               and   SOSTAT <> 'D'
               and   SOITEM = :OITEM
               and   SOSIZE = :OSIZE;

           ToSow -= Scheduled;
           If ToSow < 0;
             ToSow = 0;
           EndIf;
         EndIf;
      /End-Free

     C                   Eval      LALBQT = ToSow
     C                   Eval      SIGLBL = ToSow
     C*
     C*  GET WEEK OF YEAR
     C     PLDATE        CHAIN     FCALEN                             90
     C                   Z-ADD     CLWEEK        SHPWK             2 0
     C     ENDPTB        TAG
     C     NUMLBL        DIV       2             PRTSOW           10 1
WJB  C                   Z-Add     ToSow         PRTSOW
     C                   Z-ADD     PRTSOW        SOWQTY
     C                   MOVEL     OITEM         LAITEM
     C                   MOVEL     OSIZE         LASIZE
     C                   MOVEL     IMWHSE        LAWHSE
     C                   MOVEL     IMDES1        LADESC
QRY>>C                   Z-ADD     ITOTAL        LAQSOW
QRY>>C                   Z-ADD     PRTSOW        LALAB2
     C                   Z-ADD     OSOW6         LASOWD
     C                   Z-ADD     ODTRQ         LAREQD
     C                   Z-ADD     SHPWK         LAWEEK
     C                   Z-ADD     SIGLBL        LALAB1
     C                   MOVEL     IMPCL1        LAPDCL
     C                   MOVEL     IMLOOK        LALOOK
     C                   MOVEL     IMTPSW        LASOWT
     C                   MOVEL     IMMSCX        LAMIXT
     C                   MOVEL     IMSOWC        LASOWC
     C                   Z-ADD     LALBQT        LALABL
     C                   MOVEL     IMTRYC        LASEDR
     C                   MOVEL     *BLANKS       LAORFC
     C                   MOVE      IMALTP        LAORFC
     C                   WRITE     RLABL
     C                   MOVE      *ZEROS        SKPTOT
     C                   ADD       PRTSOW        L2SOW            10 1
     C   OF              DO
     C                   EXCEPT    HEAD
     C     LLABEL        IFEQ      'Y'
     C                   EXCEPT    HEADL
     C                   END
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF DO
     C                   EXCEPT    DETL
     C     LLABEL        IFEQ      'Y'
     C                   EXCEPT    DETLL
     C                   END
     C                   ENDIF                                                  OITEM> " "
     C                   Z-ADD     0             ITOTAL
     C                   Z-ADD     0             PRTSOW
      ** AT L1 TIME GET SOW FACTOR RECORD
     C     MINKEY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C     MINKEY        CHAIN     FMINVT                             90
     C   90              MOVEL     '**NO KEY'    IMDES1
     C   90              MOVE      *BLANKS       IMFTAB
     C     IMFTAB        IFLE      *BLANKS
     C                   MOVEL     '01'          IMFTAB
     C                   END
     C     IMFTAB        IFEQ      '00'
     C                   MOVEL     '01'          IMFTAB
     C                   END
     C     IMFTAB        IFNE      '**'
     C     IMFTAB        CHAIN     FPTABLE                            70
     C                   END
     C                   MOVEL     OIITEM        OITEM            12
     C                   MOVEL     OISIZE        OSIZE             3
     C                   Z-ADD     OISOW         OSOW              7 0
     C                   Z-ADD     OISOW         OSOW6             6 0
     C                   Z-ADD     0             ODTRQ
     C                   ENDSR
     C**************
     C* L2TOTL     *
     C**************
     C     L2TOTL        BEGSR
     C                   ADD       L2SOW         L3SOW            10 1
     C                   Z-ADD     0             L2SOW
     C                   ENDSR
     C**************
     C* L3TOTL     *
     C**************
     C     L3TOTL        BEGSR
     C                   ADD       L3SOW         LRSOW            10 1
     C     OPRCL         IFGT      *BLANKS
     C   OF              DO
     C                   EXCEPT    HEAD
     C     LLABEL        IFEQ      'Y'
     C                   EXCEPT    HEADL
     C                   END
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF DO
     C                   EXCEPT    TL3
     C     LLABEL        IFEQ      'Y'
     C                   EXCEPT    TL3L
     C                   END
     C                   END
     C                   MOVEL     OIPRCL        OPRCL             2
     C                   SETON                                        OF
     C                   Z-ADD     0             L3SOW
     C                   ENDSR
     C*
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     POST          COMP      'Y'                                    15
     C     REMOVE        COMP      'Y'                                    20
     C     SUMDET        COMP      'S'                                    77
     C                   Z-ADD     01            MCCOMP
     C     MCCOMP        CHAIN     FMCOMP                             90
     C   15
     COR 20              SETON                                        25
     C                   SETON                                        OF
     C                   ENDSR
      ********************
      * REPORT SPECS     *
      ********************
     OPRINT     E            HEAD           1 03
     O                                            7 'QPK212A'
     O                                           18 'From P.C.-'
     O                       LFRPC               21
     O                                           30 'T0 P.C.-'
     O                       LTOPC               33
     O                       MCNAME              55
     O                     15                    62 'Posted'
     O                     20                    72 'Remove Post Flag'
     O                    N25                    72 'Information Only'
     O                       PAGE          Z     80
     O                                           76 'Page'
     O          E            HEAD           2
     O                                            8 'Run Date'
     O                       TDATE         Y     17
     O                                           31 'SOWING'
     O                                           52 'SCHEDULE FOR WEEK OF'
     O                       PLDATE        Y     61
     O                                           70 'Time'
     O                       TIMOD               79 '  :  :  '
     O          E            HEAD           2
     O                                           16 'Item #      Size'
     O                                           28 'Description'
     O                                           58 'Ord. Qty'
     O                                           69 'Sow Qty'
     O                                           79 'Req Ship'
     O          EF           DETL           1
     O                       OITEM               12
     O                       OSIZE               16
     O                       IMDES1              47
     O                       ITOTAL        4     58
     O                       PRTSOW        4     69
     O                       ODTRQ         Y     79
      ** ALL SAME SOW DATE NOT NEED THIS
     O*       T 12     L2
     O*                        L2TOT 4   68
     O*                        L2SOW 4   79
     O*                                  20 'TOTAL SOW DATE -'
     O*                        OISOW Y   29
     O          E            TL3         1  2
     O                       L3TOT         4     58
     O                       L3SOW         4     69
     O                                           25 'Total Product Class -'
     O                       OPRCL               28
     O*
     O          E            LRTOTL      2
     O                                           15 'Grand Total'
     O                       GRTOT         4     58
     O                       LRSOW         4     69
     OLBLCNT    E            HEADL          1 03
     O                                            7 'QPK212A'
     O                       MCNAME              55
     O                     15                    62 'Posted'
     O                     20                    72 'Remove Post Flag'
     O                    N25                    72 'Information Only'
     O                       PAGE          Z     80
     O                                           76 'Page'
     O          E            HEADL          2
     O                                            8 'Run Date'
     O                       TDATE         Y     17
     O                                           40 'LABEL COUNT'
     O                                           52 'FOR WEEK OF'
     O                       PLDATE        Y     61
     O                                           70 'Time'
     O                       TIMOD               79 '  :  :  '
     O          E            HEADL          2
     O                                           16 'Item #      Size'
     O                                           28 'Description'
     O                                           58 'Ord. Qty'
     O                                           69 'Sow Qty'
     O                                           79 'Req Ship'
     O          EF           DETLL          1
     O                       OITEM               12
     O                       OSIZE               16
     O                       IMDES1              47
     O                       ITOTAL        4     58
     O                       PRTSOW        4     69
     O                       ODTRQ         Y     79
     O          E            TL3L        1  2
     O                       L3TOT         4     58
     O                       L3SOW         4     69
     O                                           25 'Total Product Class -'
     O                       OPRCL               28
     O*
     O          E            LRTOLL      2
     O                                           15 'Grand Total'
     O                       GRTOT         4     58
     O                       LRSOW         4     69
