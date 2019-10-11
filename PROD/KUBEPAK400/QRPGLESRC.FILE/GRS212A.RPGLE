      ***PROGRAM NAME------------------GRS212A
      ***PROGRAMMER--------------------EFD
      ***APPLICATION-------------------BUILD SEED SEASON FILE.
      **** CHANGES LOG ---
      *
      *
      *
     FFIORDRSP  IF   E           K DISK
     FFOLABL    O  A E             DISK
     FFMCUST    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFPTABLE   IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCALEN    IF   E           K DISK
      *
      ** PTABLE ARRAYS
     D PMN             S              7  0 DIM(12)                              MINIMUM
     D PMX             S              7  0 DIM(12)                              MAXIMUM
     D PUN             S              5  0 DIM(12)                              FACTOR UNITS
     D PPC             S              5  2 DIM(12)                              FACTOR %
      ************
      *  LDA     *
      ************
     D                UDS
     D  PLDATE                 3      8  0
     D  TODATE                 9     14  0
      ** SOW OR SHIP
     D  DORS                  40     40
     D  LTOPC                 63     64
     D  SUMDET                65     65
     D  LQUERY                66     66
     D  LLABEL                67     67
     D  LCANCL               133    133
      *
WJB ?D  Item           S                   Like(IMITEM)
WJB ?D  Size           S                   Like(IMSIZE)
WJB ?D  Table          S                   Like(IMFTAB)
WJB ?D  Order          S              7S 0
WJB ?D  ToSow          S              7S 0
WJB ?D  PLDATE7        S              7S 0

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
     C***        PLDATE    SETLLFIORDRSP
      /Free
         PLDATE7 = %int(%char(%date(PLDATE:*MDY):*CYMD0));
         // SETLL (PLDATE7) FIORDRSP;
      /End-Free
     C
     C     NXT           TAG
     C                   READ      FIORDRSP                               90
     C   90              GOTO      END
     C     OISIZE        IFNE      '512'
     C     OISIZE        ANDNE     '288'
     C     OISIZE        ANDNE     '162'
     C     OISIZE        ANDNE     '105'
     C     OISIZE        ANDNE     '102'
     C     OISIZE        ANDNE     '52 '
     C     OISIZE        ANDNE     '51 '
     C     OISIZE        ANDNE     '50 '
     C     OISIZE        ANDNE     '48 '
     C     OISIZE        ANDNE     '72 '
     C                   GOTO      NXT
     C                   ENDIF
     C     DORS          IFEQ      'S'
     C**                   Z-ADDOISOW     ##MDY
     C**                   EXSR @DT@A1
     C                   Z-ADD     OISOW         ##CYMD
     C     ##CYMD        IFGT      TOTEST
     C     ##CYMD        ORLT      FRTEST
     C                   GOTO      NXT
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   EXSR      @DT@A1
     C     ##CYMD        IFGT      TOTEST
     C     ##CYMD        ORLT      FRTEST
     C                   GOTO      NXT
     C                   ENDIF
     C                   END
      ** SEE IF WE NEED THIS RECORD
     C**         OIPRCL    IFLT LFRPC
     C**         OIPRCL    ORGT LTOPC
     C**                   GOTO NXT
     C**                   END
     C     OIITYP        IFNE      ' '
     C     OILOTC        OREQ      'Y'
     C     OILOT#        AndNe     'CustomOrdr'
     C     OISTA         OREQ      'Y'
     C     OISTAT        OREQ      'D'
     C                   GOTO      NXT
     C                   END
      ** SEE IF WE NEED LEVEL 3 BREAK
     C     OIPRCL        IFNE      OPRCL
     C                   EXSR      L1TOT
     C                   EXSR      L2TOTL
     C                   EXSR      L3TOTL
     C                   END
      ** SEE IF WE NEED LEVEL 2 BREAK
     C     DORS          IFEQ      'S'
???  C     OISOW         IFNE      OSOW
     C                   EXSR      L1TOT
     C                   EXSR      L2TOTL
     C                   ENDIF
     C                   ELSE
     C     OIDTRQ        IFNE      ODTRQ
     C                   EXSR      L1TOT
     C                   EXSR      L2TOTL
     C                   ENDIF
     C                   END
      ** SEE IF WE NEED LEVEL 1 BREAK
     C     OIITEM        IFNE      OITEM
     C     OISIZE        ORNE      OSIZE
     C                   EXSR      L1TOT
     C                   END
     C* TOTAL EACH ITEM
     C                   Z-ADD     OIQORD        WRKORD            7 1
     C                   ADD       WRKORD        ITOTAL            6 1
     C                   ADD       WRKORD        GRTOT             7 1
     C                   ADD       WRKORD        L2TOT             7 1
     C                   ADD       WRKORD        L3TOT             7 1
     C* CHECK CUST TYPE AND ACCUMLATE TOTAL
     C                   EXSR      GETCUS
     C  N21PTCTYP        IFNE      *BLANKS
     C     PTCTYP        IFEQ      CMCTYP
     C                   ADD       WRKORD        SKPTOT            7 1
     C                   END
     C                   END
     C                   Z-ADD     OIDTRQ        ODTRQ             6 0
     C*  GET WEEK OF YEAR
     C     DORS          IFEQ      'S'
EFD  C                   Z-ADD     OISOW         ##CYMD
EFD  C                   CALL      '@DTCNV'
EFD  C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
EFD  C                   PARM                    ##MDY             6 0          DATE MMDDYY
EFD  C                   PARM                    ##ERR             1            ERROR IF = Y
EFD  C                   Z-ADD     ##MDY         SOW               6 0
     C     SOW           CHAIN     FCALEN                             90
     C                   ELSE
     C     OIDTRQ        CHAIN     FCALEN                             90
     C                   END
     C                   Z-ADD     CLWEEK        SHPWK             2 0
     C                   GOTO      NXT
     C* END
     C     END           TAG
     C                   EXSR      L1TOT
     C                   EXSR      L2TOTL
     C                   EXSR      L3TOTL
     C                   SETON                                        LR
     C*
     C**************
     C* L1TOT      *
     C**************
     C     L1TOT         BEGSR
     C     OITEM         IFGT      *BLANKS
     C*                  EXSR      LBLRTN
     C     NUMLBL        DIV       2             PRTSOW            7 1
WJB ?C                   Call      '#SOWFACTOR'
WJB ?C                   Parm                    IMITEM
WJB ?C                   Parm                    IMSIZE
WJB ?C                   Parm                    IMFTAB
WJB ?C                   Parm      ITOTAL        Order
WJB ?C     PRTSOW        Parm                    ToSow
WJB  C                   Z-add     PRTSOW        LALBQT
     C                   Z-ADD     PRTSOW        SOWQTY
     C                   MOVEL     OITEM         LOITEM
     C                   MOVEL     OSIZE         LOSIZE
     C                   MOVEL     IMWHSE        LOWHSE
     C                   MOVEL     IMDES1        LODESC
     C                   Z-ADD     LALBQT        LOQSOW
     C                   Z-ADD     OSOW          LOSYMD
     C                   Z-ADD     OSOW          ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         LOSOWD
     C                   Z-ADD     ODTRQ         LOREQD
     C                   Z-ADD     ODTRQ         ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        LORYMD
     C                   Z-ADD     SHPWK         LOWEEK
     C                   MOVEL     IMPCL1        LOPDCL
     C                   MOVEL     IMLOOK        LOLOOK
     C                   WRITE     ROLABL
     C                   END
     C                   MOVE      *ZEROS        SKPTOT
     C                   ADD       PRTSOW        L2SOW             7 1
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
     C                   ENDSR
     C**************
     C* L2TOTL     *
     C**************
     C     L2TOTL        BEGSR
     C                   ADD       L2SOW         L3SOW             7 1
     C                   Z-ADD     0             L2SOW
     C                   Z-ADD     OISOW         OSOW              7 0
     C                   Z-ADD     OIDTRQ        ODTRQ             6 0
     C                   ENDSR
     C**************
     C* L3TOTL     *
     C**************
     C     L3TOTL        BEGSR
     C                   ADD       L3SOW         LRSOW             7 1
     C                   MOVEL     OIPRCL        OPRCL             2
     C                   SETON                                        OF
     C                   Z-ADD     0             L3SOW
     C                   ENDSR
     C**************
     C* GETCUS     *
     C**************
     C     GETCUS        BEGSR
     C     OICUST        CHAIN     FMCUST                             21
     C                   ENDSR
     C*
     C**************
     C* LBLRTN     *
     C**************
     C     LBLRTN        BEGSR
     C                   Z-ADD     ITOTAL        SOWQTY            6 1
     C                   Z-ADD     ITOTAL        LALBQT
     C     SOWQTY        MULT      2             NUMLBL            7 1
     C                   Z-ADD     SOWQTY        SIGLBL            7 1
     C                   Z-ADD     SKPTOT        WRKSKP            5 0
     C     SOWQTY        SUB       WRKSKP        WRKQTY            5 1
     C     IMFTAB        IFEQ      '**'
     C                   GOTO      ENDPTB
     C                   END
     C* CALCULATE NUMBER OF LABELS
     C                   DO        12            X                 2 0
     C     WRKQTY        IFGE      PMN(X)
     C     WRKQTY        IFLE      PMX(X)
     C     PUN(X)        IFGT      0
     C     WRKQTY        ADD       PUN(X)        WRKFLD            5 1
     C                   ELSE
     C     PPC(X)        DIV(H)    100           PCTWK             5 4
     C     1.00          ADD       PCTWK         PCTM              5 4
     C     WRKQTY        MULT(H)   PCTM          WRKFLD
WJB  C     WRKQTY        MULT(H)   PCTM          WRKFLDdec         9 9
WJB  C     WRKFLDdec     IFLT      .5
WJB  C     WRKFLDdec     ANDGT     0
WJB  C                   ADD       1             WRKFLD
WJB  C                   END
     C                   END
     C     WRKFLD        ADD       WRKSKP        WRKFLD
     C     WRKFLD        MULT      2             NUMLBL            7 1
     C                   Z-ADD     WRKFLD        SIGLBL            7 1
     C                   END
     C                   END
     C*
     C                   END
     C                   MOVE      SIGLBL        TEST1             1 0
     C     TEST1         IFGT      0
     C     SIGLBL        ADD       1             LALBQT            6 0
     C                   ELSE
     C                   Z-ADD     SIGLBL        LALBQT
     C                   END
     C*
     C     ENDPTB        TAG
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     01            MCCOMP
     C     MCCOMP        CHAIN     FMCOMP                             90
     C                   Z-ADD     PLDATE        ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        FRTEST            7 0
     C                   Z-ADD     TODATE        ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        TOTEST            7 0
     C                   ENDSR
      ********************************************************************
      * VALIDATE DATES. INDICATOR 90 IS ON IF ERROR. 91-92 ALWAYS SETOF.
      * YY GE 00  MM 01-12 DAY 01-28/29/30/31
      * ##MDY INPUT DATE MMDDYY
      * ##CYMD OUTPUT DATE CYYMMDD IF DATE IS OK. ELSE ZERO.
      * C IDENTIFIES 20 OR 21 CENTURY. C=0 FOR YY 70-99. C=1 FOR YY 00-69.
     C     @DT@A1        BEGSR
     C                   MOVE      ##MDY         #03A              3 0          MYY
     C                   MOVEL     0             #03A                           CYY
     C                   MOVEL     ##MDY         #04               4 0          MMDD
     C                   MOVEL     ##MDY         #02B              2 0          MM
     C                   MOVE      #04           #02C              2 0          DD
     C                   Z-ADD     ##MDY         ##MDY             6 0  90      YY IS NEGATIVE
     C  N90              Z-ADD     #02B          #02               2 0    90    MM LT 01 ERROR
     C  N90#02B          COMP      12                                 90        MM GT 12 ERROR
     C  N90#02C          COMP      01                                   90      DD LT 01 ERROR
     C  N90#02C          COMP      31                                 90  91    DD GT OR EQ 31
     C     #02B          COMP      07                                 92        MM 08-12
     C   921             ADD       #02B          #02                            MAKE MM ODD
     C     #02           DIV       2             #02
     C                   MVR                     #02                  92        31 DAY MONTH
     C   91
     CANN92              SETON                                        90        MM EVEN DD 31
     C     #02B          COMP      02                                     91    FEB
     C  N91
     COR 90              GOTO      @DT@AX
     C     #03A          DIV       4             #03               3 0          JUST FOR MVR
     C                   MVR                     #02                      91    LEAP YEAR
     C     #02C          COMP      29                                 90  92    DD GT 29 ERROR
     C  N91
     CAN 92              SETON                                        90        NO LEAP DD 29
     C     @DT@AX        TAG                                                    GOOD DATE
     C                   MOVEL     #03A          ##CYMD            7 0          CYY----
     C                   MOVE      #04           ##CYMD                         CYYMMDD
     C     #03A          COMP      070                                  91
     C   91              MOVEL     1             ##CYMD                         21ST CENTURY
     C   90              Z-ADD     0             ##CYMD                         ERROR
     C                   SETOFF                                       9192
     C                   ENDSR
