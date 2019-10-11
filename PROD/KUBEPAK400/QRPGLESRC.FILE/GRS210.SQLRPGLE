      *----------------------------------------------------------      ----
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1996
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDE      RED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXC      EPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *       EFD ENTERPRISES INC.  215-643-5352
      *
      *----------------------------------------------------------      ----
      **PROGRAM NAME-------- GRS210
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **DESCRIPTION--------- ENTER DATE PLANT IS UNAVAILABLE UNTIL
      **
      *
      *    DATE----INIT-------DESCRIPTION
      *
     FGRS210FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMAVDTE   UF A E           K DISK
     FFMINVT    IF   E           K DISK
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        TDMDY             7 0
      *
     C     RSTRT         TAG
     C                   EXSR      CLRIT
     C                   EXSR      CLRIND
     C                   SETOFF                                       50
     C                   SETON                                        98
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       192026
     C                   SETOFF                                       272899
     C                   SETOFF                                       404132
     C                   SETOFF                                       454647
     C                   SETOFF                                       5748
     C                   Z-ADD     0             COUNT             2 0
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
     C                   ADD       1             FIRST
     C  N50              EXSR      SR100A
     C   99              GOTO      NXTA
     C   50FIRST         IFEQ      0
     C                   GOTO      NXTA
     C                   END
     C     FIRST         IFNE      0
     C                   EXSR      SR100B
     C                   END
      *ERROR
     C   99              GOTO      NXTA
      *KF ON SCREEN B
     C   87              GOTO      RSTRT
      *REDISPLAY SCREEN ON R D I
     C     CNTB          IFGT      1
     C                   SETOFF                                       88
     C                   END
      *
      * CHECK IF COUNT > 0 IF SO REDISPLAY ELSE UPDATE RECORDS
     C     COUNT         IFGT      0
     C                   GOTO      NXTA
     C                   ELSE
     C                   EXSR      OUTREC
     C                   GOTO      RSTRT
     C                   END                                                    COUNT>0
     C     END           TAG
     C   KC
     COR KG              SETON                                        LR
      *
      **************************
      ******     SR100A - TOP OF SCREEN
      **************************
     C     SR100A        BEGSR
      *
     C     VACT          COMP      'A'                                262621     ADD CODE
     C   26VACT          COMP      'C'                                262622     CHANGE/UPDATE
     C   26VACT          COMP      'D'                                262623     DELETE
      *
     C   26              SETON                                        99
     C   26              GOTO      E100A
      *
      ****   MUST HAVE ITEM AND SIZE
      *
     C     VALPHA        IFGT      *BLANKS
     C                   MOVEL     VALPHA        IMLOOK
     C                   MOVE      *BLANKS       SHPFR             3
     C                   CALL      'ITMALOOK'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     IMITEM        VITEM
     C                   MOVEL     IMSIZE        VSIZE
     C     ITMKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
     C     ITMKEY        CHAIN(N)  FMINVT                             90
     C                   MOVE      IMDES1        DESA             30
     C                   MOVE      IMDES2        DESB             30
     C     DESA          CAT       DESB:1        DES1             60
     C                   MOVE      IMDES3        DESC             30
     C                   MOVE      IMDES4        DESD             30
     C     DESC          CAT       DESD:1        DES2             60
     C     DES1          CAT       DES2:1        DESP             55
     C                   SETON                                        99
     C                   GOTO      E100A
     C                   ENDIF
      *
     C     VITEM         IFEQ      *BLANKS
     C                   SETON                                        1999
     C                   GOTO      E100A
     C                   ENDIF
      *
      ****   VALIDATE ITEM NUMBER
      *
     C     VSIZE         IFGT      *BLANKS
     C     IKEY          KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C     IKEY          CHAIN     FMINVT                             95
     C   95              SETON                                        1999
     C   19              GOTO      E100A
     C                   ELSE
     C     VITEM         CHAIN     FMINVT                             95
     C   95              SETON                                        1999
     C   19              GOTO      E100A
     C                   END
     C                   MOVE      IMDES1        DESA             30
     C                   MOVE      IMDES2        DESB             30
     C     DESA          CAT       DESB:1        DES1             60
     C                   MOVE      IMDES3        DESC             30
     C                   MOVE      IMDES4        DESD             30
     C     DESC          CAT       DESD:1        DES2             60
     C     DES1          CAT       DES2:1        DESP             55
      *
      *  READ AVAILABLE DATE FILE
      *
     C     AKEY          KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C     AKEY          CHAIN     FMAVDTE                            96
     C     VACT          IFEQ      'A'
     C  N96              SETON                                        9927
     C   99              GOTO      E100A
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C   96              SETON                                        9920
     C   99              GOTO      E100A
     C                   ENDIF
      *
     C  N99              SETON                                        50
      *
     C                   Z-ADD     0             FIRST             2 0
     C     E100A         TAG
      *
     C                   ENDSR
      *
      **************************
      ******     SR100B - BOTTOM OF SCREEN
      **************************
      *
     C     SR100B        BEGSR
      *
     C                   SETOFF                                       9045
     C                   SETOFF                                       464748
     C                   SETON                                        50
     C     VACT          IFEQ      'D'
     C                   SETON                                        3388
     C                   ADD       1             CNTB              2 0
     C                   GOTO      ENDB
     C                   ENDIF
      *
     C   KF              SETON                                        87
     C   KF              GOTO      ENDB
      *
     C   KC
     COR KG              GOTO      END
      *
     C     AVDMDY        IFEQ      *ZEROS
     C                   SETON                                        464599
     C   46              GOTO      ENDB
     C                   ENDIF
      *
     C                   MOVEL     AVDMDY        VMD               4 0
     C                   MOVE      AVDMDY        VYR               2 0
     C                   MOVE      AVDMDY        VYEAR             4 0
     C                   MOVEL     VMD           RDATE             6 0
     C                   MOVE      VYR           RDATE
      *
     C     AVDMDY        IFLT      999999
     C                   SETON                                        454899
     C   48              GOTO      ENDB
     C                   ENDIF
      *
     C                   MOVEL     RDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        454699
     C   46              GOTO      ENDB
     C                   END
      *
     C                   Z-ADD     ##CYMD        RMDY              7 0
     C     RMDY          IFLT      TDMDY
     C                   SETON                                        454799
     C   47              GOTO      ENDB
     C                   ENDIF
      *
     C     AVDMDY        IFNE      OMDY
     C                   ADD       1             COUNT
     C                   Z-ADD     AVDMDY        OMDY              8 0
     C                   ENDIF
      *
     C                   MOVEL     VYEAR         AVDYMD            8 0
     C                   MOVE      VMD           AVDYMD            8 0
      *
     C     AVCOMM        IFNE      OCOMM
     C                   ADD       1             COUNT
     C                   MOVEL     AVCOMM        OCOMM            30
     C                   ENDIF
      *
     C     ENDB          TAG
      *
      * WHAT ACTION NEXT IF COUNT>0 SET OF 98 IF 99 SET ON 98
      *
     C     COUNT         IFGT      0
     C                   SETOFF                                       98
     C                   ELSE
     C                   SETON                                        98
     C                   ENDIF
     C   99              SETON                                        98
     C                   ENDSR
      *
      *  **********
      *  * OUTREC *
      *  **********
     C     OUTREC        BEGSR
     C                   MOVEL     VITEM         AVITEM
     C                   MOVEL     VSIZE         AVSIZE
      /Free
        If not *In23 and *In96;  // On Write, populate 'created' info
          Exec SQL set :ENCCRTIME = current timestamp;
          Exec SQL set :ENCCRUSER = current user;
        ENDIF;
      /End-Free
     C  N23
     CAN 96              WRITE     RMAVDTE
     C  N23
     CANN96              UPDATE    RMAVDTE
     C   23
     CANN96              DELETE    RMAVDTE
     C                   ENDSR
      *
      ****   CLEAR INDICATORS
      *
     C     CLRIND        BEGSR
     C                   SETOFF                                       1920
     C                   SETOFF                                       212223
     C                   SETOFF                                       242526
     C                   SETOFF                                       272832
     C                   SETOFF                                       404150
     C                   SETOFF                                       333435
     C                   SETOFF                                       555657
     C                   SETOFF                                       808899
     C                   ENDSR
      *  **********
      *  * CLRIT  *
      *  **********
     C     CLRIT         BEGSR
     C                   SETOFF                                       289911
     C                   MOVE      *BLANKS       VACT
     C                   MOVE      *BLANKS       VITEM
     C                   MOVE      *BLANKS       VSIZE
     C                   MOVE      *BLANKS       AVCOMM
     C                   MOVE      *BLANKS       DESP
     C                   Z-ADD     *ZEROS        CNTB
     C                   Z-ADD     *ZEROS        AVDMDY
     C                   ENDSR
      *
      ********************************************************************@DT@A0
      * VALIDATE DATES. INDICATOR 90 IS ON IF ERROR. 91-92 ALWAYS SETOF.  @DT@A0
      * YY GE 00  MM 01-12 DAY 01-28/29/30/31                             @DT@A0
      * ##MDY INPUT DATE MMDDYY                                           @DT@A0
      * ##YMD OUTPUT DATE YYMMDD IF DATE IS OK. ELSE ZERO.                @DT@A0
     C     @DT@A0        BEGSR                                                                 @DT@A
     C                   MOVE      ##MDY         #02A              2 0          YY             @DT@A
   1 C                   MOVEL     ##MDY         #04               4 0          MMDD           @DT@A
   2 C                   MOVEL     ##MDY         #02B              2 0          MM             @DT@A
   3 C                   MOVE      #04           #02C              2 0          DD             @DT@A
   4 C                   Z-ADD     ##MDY         ##MDY             6 0  90      YY IS NEGATIVE @DT@A
   5 C  N90              Z-ADD     #02B          #02               2 0    90    MM LT 01 ERROR @DT@A
   6 C  N90#02B          COMP      12                                 90        MM GT 12 ERROR @DT@A
   7 C  N90#02C          COMP      01                                   90      DD LT 01 ERROR @DT@A
   8 C  N90#02C          COMP      31                                 90  91    DD GT OR EQ 31 @DT@A
   9 C     #02B          COMP      07                                 92        MM 08-12       @DT@A
     C   921             ADD       #02B          #02                            MAKE MM ODD    @DT@A
     C     #02           DIV       2             #02                                           @DT@A
     C                   MVR                     #02                  92        31 DAY MONTH   @DT@A
     C   91
     CANN92              SETON                                        90        MM EVEN DD 31  @DT@A
     C     #02B          COMP      02                                     91    FEB            @DT@A
     C  N91                                                                                    @DT@A
     COR 90              GOTO      @DT@AX                                       OK             @DT@A
     C     #02A          DIV       4             #02                            JUST FOR MVR   @DT@A
     C                   MVR                     #02                      91    LEAP YEAR      @DT@A
     C     #02C          COMP      29                                 90  92    DD GT 29 ERROR @DT@A
     C  N91
     CAN 92              SETON                                        90        NO LEAP DD 29  @DT@A
     C     @DT@AX        TAG                                                    GOOD DATE      @DT@A
     C                   MOVEL     #02A          ##YMD             6 0          YY----         @DT@A
     C                   MOVE      #04           ##YMD                          YYMMDD         @DT@A
     C   90              Z-ADD     0             ##YMD                          ERROR          @DT@A
     C                   SETOFF                                       9192                     @DT@A
     C                   ENDSR                                                                 @DT@A
      *                                                                ***@DT@A0
