      ***PROGRAM NAME------------------SED212A
      ***PROGRAMMER--------------------EFD
      ***APPLICATION-------------------BUILD SSEED SEASON FILE.
      **** CHANGES LOG ---
      *
      *
      *
     FFIORDRSP  IF   E           K DISK
     FFSLABL    O  A E             DISK
     FFMCUST    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFPTABLE   IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCALEN    IF   E           K DISK
      *
     D  Order          S              7S 0
     D  ToSow          S              7S 0
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
     D  LTOPC                 63     64
     D  SUMDET                65     65
     D  LQUERY                66     66
     D  LLABEL                67     67
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
     C***        PLDATE    SETLLFIORDRSP
     C     NXT           TAG
     C                   READ      FIORDRSP                               90
     C   90              GOTO      END
     C*                    Z-ADDOISOW     ##MDY
     C*                    CALL '@DT@A1'
     C*                    PARM           ##MDY   60       DATE MDY
     C*                    PARM           ##CYMD  70       DATE CYYMMDD
     C*                    PARM           ##ERR   1        ERROR IF = Y
     C                   Z-ADD     OISOW         ##CYMD
     C     ##CYMD        IFGT      TOTEST
     C     ##CYMD        ORLT      FRTEST
     C                   GOTO      NXT
     C                   END
      ** SEE IF WE NEED THIS RECORD
     C**         OIPRCL    IFLT LFRPC
     C**         OIPRCL    ORGT LTOPC
     C**                   GOTO NXT
     C**                   END
     C     OIITYP        IFNE      ' '
     C     OILOTC        OREQ      'Y'
     C     OISTA         OREQ      'Y'
     C                   GOTO      NXT
     C                   END
      ** SEE IF WE NEED LEVEL 3 BREAK
     C     OIPRCL        IFNE      OPRCL
     C                   EXSR      L1TOT
     C                   EXSR      L2TOTL
     C                   EXSR      L3TOTL
     C                   END
      ** SEE IF WE NEED LEVEL 2 BREAK
     C     OISOW         IFNE      OSOW
     C                   EXSR      L1TOT
     C                   EXSR      L2TOTL
     C                   END
      ** SEE IF WE NEED LEVEL 1 BREAK
     C     OIITEM        IFNE      OITEM
     C     OISIZE        ORNE      OSIZE
     C     OIDTRQ        ORNE      ODTRQ
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
     C                   EXSR      LBLRTN
     C     NUMLBL        DIV       2             PRTSOW            7 1
     C                   Z-ADD     PRTSOW        SOWQTY
     C                   MOVEL     OITEM         LAITEM
     C                   MOVEL     OSIZE         LASIZE
     C                   MOVEL     IMWHSE        LAWHSE
     C                   MOVEL     IMDES1        LADESC
     C                   Z-ADD     ITOTAL        LAQSOW
     C                   Z-ADD     PRTSOW        LALAB2
     C                   CALL      '@DTCNV'
     C                   PARM                    OSOW
     C                   PARM                    LASOWD
     C                   PARM                    ##ERR             1            ERROR IF = Y
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
     C                   MOVEL     IMALTP        LAORFC
     C                   WRITE     RLABL
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
     C     SOWQTY        MULT      2             NUMLBL            7 1
     C                   Z-ADD     SOWQTY        SIGLBL            7 1
     C                   Z-ADD     SKPTOT        WRKSKP            5 0
     C     SOWQTY        SUB       WRKSKP        WRKQTY            5 1
     C     IMFTAB        IFEQ      '**'
     C                   GOTO      ENDPTB
     C                   END
     C* CALCULATE NUMBERR OF LABELS
     C                   DO        12            X                 2 0
     C     WRKQTY        IFGE      PMN(X)
     C     WRKQTY        IFLE      PMX(X)
     C     PUN(X)        IFGT      0
     C     WRKQTY        ADD       PUN(X)        WRKFLD            5 1
     C                   ELSE
     C     PPC(X)        DIV(H)    100           PCTWK             5 4
     C     1.00          ADD       PCTWK         PCTM              5 4
     C     WRKQTY        MULT(H)   PCTM          WRKFLD
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
     C                   Eval      Order = WRKQTY
WJB ?C                   Call      '#SOWFACTOR'
WJB ?C                   Parm                    IMITEM
WJB ?C                   Parm                    IMSIZE
WJB ?C                   Parm                    IMFTAB
WJB ?C                   Parm                    Order
WJB ?C                   Parm                    ToSow
     C                   Eval      LALBQT = ToSow
     C*
     C*  GET WEEK OF YEAR
     C     PLDATE        CHAIN     FCALEN                             90
     C                   Z-ADD     CLWEEK        SHPWK             2 0
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
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        FRTEST            7 0
     C                   Z-ADD     TODATE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        TOTEST            7 0
     C                   ENDSR
