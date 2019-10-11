      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1997
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
      **PROGRAM NAME-------- GRS230
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- UPDATE WEEKLY AVAILABILTY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  1/19/01 EFD ADD SIZE CARRY OVER FROM LAST ENTRY PER CHRIS
      *
     FGRS230FS  CF   E             WORKSTN
     F                                     SFILE(AVLSFL:RECNO)
     FFDLOTDSI  UF   E           K DISK
     F                                     RENAME(RDLOTRD:LOTRD)
     FFDLOTRD   UF A E           K DISK
     FFDLOT     UF A E           K DISK
     FFLCSTAT   UF A E           K DISK
     FFMINVT    IF   E           K DISK
     FFCALEN    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:ICALEN)
      * DATE ARRAYS
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND
      * MESSAGE ARRAY
     D MSG             S             30    DIM(2) CTDATA PERRCD(1)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10
      ** RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      ** SOURCE LIBRARY
     D  SLIBR                314    323
      ***********************
      ** START OR RESTART  **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     0             FRMDAT
     C                   Z-ADD     0             BEGYY
     C                   Z-ADD     0             BEGWW
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                       9899
     C                   MOVEL     MSG(2)        DES
      ** DISPLAY SCREEN
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                         99
      ** CHECK INPUT
      **
      ** CHECK DATE
     C     FRMDAT        IFLE      0
     C     BEGYY         ANDLE     0
     C     BEGWW         ANDLE     0
     C                   SETON                                        10  99
     C                   GOTO      NXTA
     C                   ENDIF
      **
     C     FRMDAT        IFGT      0
     C                   Z-ADD     FRMDAT        ##MDY
     C                   EXSR      @DT@A1
     C  N90              EXSR      @DT@B1
     C  N90              Z-ADD     ##CYMD        STRDAT            7 0
     C  N90              EXSR      @DAYWK
     C   90              DO
     C                   SETON                                        1099
     C                   GOTO      NXTA
     C                   ENDDO
     C     #Y            IFNE      1
     C                   SETON                                        101199
     C                   GOTO      NXTA
     C                   END
     C     FRMDAT        CHAIN     FCALEN                             92
     C                   MOVEL     CLCENT        BEGYY
     C                   MOVE      CLYEAR        BEGYY
     C                   Z-ADD     CLWEEK        BEGWW
     C                   ELSE                                                   FRMDAT > 0
     C                   MOVEL     BEGYY         CLCENT
     C                   MOVE      BEGYY         CLYEAR
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    BEGWW
     C                   KFLD                    CL#Y
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             92
     C   92              DO
     C                   SETON                                        2099
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        FRMDAT
     C                   Z-ADD     FRMDAT        ##MDY
     C                   EXSR      @DT@A1
     C  N90              EXSR      @DT@B1
     C                   Z-ADD     ##CYMD        STRDAT            7 0
     C                   END                                                    FRMDAT > 0
      ** IF FIRST TIME REDISPLAY
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   END
     C                   SETOFF                                       98
      *** BUILD SUB FILE
     C     RSTRTB        TAG
     C                   EXSR      BLDSFL
     C     NXTB          TAG
     C   99              SETOFF                                       98
     C                   SETOFF                                       23
     C                   EXFMT     AVLCTL
      ** CHECK F KEYS
     C   KX              DO
     C                   SETON                                        23
     C     NXTDLS        TAG
     C                   EXFMT     AVLCTL
     C   KF              DO
     C                   SETOFF                                       23
     C                   GOTO      NXTB
     C                   ENDDO                                                  KF DO
     C  NKX              GOTO      NXTDLS
     C   KX              DO
     C                   EXSR      DELWK
     C                   GOTO      RSTART
     C                   ENDDO                                                  KX DO LAST
     C                   ENDDO                                                  KX DO FIRST
     C   KF              GOTO      RSTART
      ** CHECK SUB FILE
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTB
      ** VERIFY SCREEN
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   END
      ** IF OK UPDATE FILE
     C   KA              DO
     C                   EXSR      PUTSFL
     C                   GOTO      RSTART
     C                   ENDDO
      ** IF NOT F1 REDISPLAY SCREEN
     C                   GOTO      NXTB
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   MOVEL     '1'           *IN(80)
     C                   WRITE     AVLCTL
     C                   MOVEL     '01'          *IN(80)
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             LSTOLD            5 0
     C                   SETOFF                                       18
     C     STRDAT        SETLL     FDLOTDSI
     C                   SETON                                        15
     C     NXTBLD        TAG
     C     STRDAT        READE(N)  FDLOTDSI                               90
     C   90              GOTO      ENDBLD
     C     LRGLOC        IFEQ      'R'
     C                   GOTO      NXTBLD
     C                   END
     C                   MOVEL     LRITEM        VITEM
     C                   MOVEL     LRSIZE        VSIZE
     C     IMKEY         KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C     IMKEY         CHAIN     FMINVT                             91
     C     LRQTAL        ADD       LRQTOH        QTYOH
     C                   Z-ADD     LRQTAL        QTYAL
     C                   Z-ADD     LRQTOH        NEWQTY
     C                   Z-ADD     LRQTOH        OLDQTY
     C                   MOVEL     'Y'           OLDLOT
     C                   ADD       1             RECNO
     C                   WRITE     AVLSFL
     C                   Z-ADD     RECNO         LSTOLD
     C                   GOTO      NXTBLD
      ** END OF BUILD ROUTINE
     C     ENDBLD        TAG
     C                   SETOFF                                       15
     C     RECNO         ADD       50            TOREC             5 0
     C                   MOVE      *BLANKS       VITEM
     C                   MOVE      *BLANKS       VSIZE
     C                   Z-ADD     0             QTYOH
     C                   Z-ADD     0             QTYAL
     C                   Z-ADD     0             NEWQTY
     C                   Z-ADD     0             OLDQTY
     C                   MOVE      *BLANKS       IMDES1
     C                   MOVE      *BLANKS       OLDLOT
     C     NXTBLE        TAG
     C                   ADD       1             RECNO
     C                   WRITE     AVLSFL
     C     RECNO         IFLE      TOREC
     C                   GOTO      NXTBLE
     C                   END
     C                   SETON                                        18
     C                   MOVEL     MSG(1)        IMDES1
     C                   ADD       1             RECNO
     C                   WRITE     AVLSFL
     C                   MOVE      *BLANKS       IMDES1
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   SETOFF                                       1518
     C                   ENDSR
      ***********************
      ** CHECK SUB FILE    **
      ***********************
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       111299
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     AVLSFL                             90
     C   90              GOTO      NXTCHK
     C                   SETOFF                                       101518
     C                   SETOFF                                       19
      ** GET ODL SIZE IF ENTERED
     C     VSIZE         IFGT      *BLANKS
     C                   MOVEL     VSIZE         OSIZE             3
     C                   END
      ** IF AN OLD LOT NOTHING TO CHECK SET ON PROTECT INDICATOR
     C     OLDLOT        IFEQ      'Y'
     C                   SETON                                        15
     C                   UPDATE    AVLSFL
     C                   GOTO      NXTCHK
     C                   END
      ** CHECK IF ANYTHING ENTERED
     C     VITEM         IFLE      *BLANKS
     C     VSIZE         ANDLE     *BLANKS
     C                   GOTO      NXTCHK
     C                   END
      ** CHECK IF ITEM ENTERED WITH NO SIZE IF SO USE LAST SIZE
     C     VITEM         IFGT      *BLANKS
     C     VSIZE         ANDLE     *BLANKS
     C                   MOVEL     OSIZE         VSIZE
     C                   END
      ** CHECK IF SIZE SEARCH NEEDED
     C                   MOVEL     VSIZE         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       VSIZE
     C                   MOVEL     SZCODE        VSIZE
     C                   END
      ** CHECK ITEM SEARCH
     C                   MOVEL     VITEM         TST1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       DESHFR            3
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     VITEM:2       IMLOOK
     C                   MOVEL     VSIZE         IMSIZE
     C                   CALL      'LKITEM'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    DESHFR
     C                   MOVEL     IMITEM        VITEM
     C                   MOVEL     IMSIZE        VSIZE
     C                   END
      ** CHECK ITEM
     C     IMKEY         CHAIN     FMINVT                             10
     C   10              SETON                                        1199
     C  N10IMSTAT        IFEQ      'D'
     C                   SETON                                        101199
     C                   END
      * CHECK QTY  IF ADDED ITEM NEED QTY
     C     NEWQTY        IFLE      0
     C                   SETON                                        121999
     C                   END
     C                   UPDATE    AVLSFL
     C                   GOTO      NXTCHK
      ** SEE IF WE NEED MORE LINES
     C     ENDCHK        TAG
     C                   SETOFF                                       101518
     C                   SETOFF                                       19
     C   KE              DO
     C     LSTREC        CHAIN     AVLSFL                             90
     C     RECNO         ADD       50            TOREC             5 0
     C                   MOVE      *BLANKS       VITEM
     C                   MOVE      *BLANKS       VSIZE
     C                   Z-ADD     0             QTYOH
     C                   Z-ADD     0             QTYAL
     C                   Z-ADD     0             NEWQTY
     C                   Z-ADD     0             OLDQTY
     C                   MOVE      *BLANKS       IMDES1
     C                   MOVE      *BLANKS       OLDLOT
     C  N90              UPDATE    AVLSFL
     C     NXTBLC        TAG
     C                   ADD       1             RECNO
     C                   WRITE     AVLSFL
     C     RECNO         IFLE      TOREC
     C                   GOTO      NXTBLC
     C                   END
     C                   SETON                                        18
     C                   MOVEL     MSG(1)        IMDES1
     C                   ADD       1             RECNO
     C                   WRITE     AVLSFL
     C                   MOVE      *BLANKS       IMDES1
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   SETOFF                                       1518
     C                   ENDDO
     C  N99              SETON                                        98
      **
     C                   ENDSR
      ***********************
      **   PUT SUB FILE    **
      ***********************
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     AVLSFL                             90
     C   90              GOTO      NXTPUT
      ** CHECK IF ANYTHING ENTERED
     C     VITEM         IFLE      *BLANKS
     C     VSIZE         ANDLE     *BLANKS
     C                   GOTO      NXTPUT
     C                   END
     C     NEWQTY        IFEQ      OLDQTY
     C                   GOTO      NXTPUT
     C                   END
      ** CHECK ITEM
     C     IMKEY         CHAIN     FMINVT                             10
     C                   EXSR      UPDLOT
     C                   GOTO      NXTPUT
      ** SEE IF WE NEED MORE LINES
     C     ENDPUT        TAG
      ** UPDATE STATUS FILE
     C                   Z-ADD     01            LSCONO
     C     LSCONO        CHAIN     FLCSTAT                            71
     C     LSFXCY        IFLT      STRDAT
     C                   Z-ADD     STRDAT        LSFXCY
     C                   Z-ADD     FRMDAT        LSFXMD
     C                   Z-ADD     BEGYY         LSFXYY
     C                   Z-ADD     BEGWW         LSFXWW
     C                   END
     C  N71              UPDATE    RLCSTAT
     C   71              WRITE     RLCSTAT
      **
     C                   ENDSR
      ***********************
      *  UPDATE LOT RECORDS *
      ***********************
     C     UPDLOT        BEGSR
     C                   CLEAR                   RDLOTRD
     C                   CLEAR                   RDLOT
     C                   CALL      'GETGERM'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C*                  PARM                    FRMDAT
     C                   PARM                    STRDAT
     C                   PARM                    SOWDAT            7 0
      ** GET SOW DATE FORMAT
     C*                  Z-ADD     SOWDAT        ##MDY
     C*                  EXSR      @DT@A1
     C                   Z-ADD     SOWDAT        ##CYMD
     C                   Z-ADD     ##CYMD        LRSOWD
     C                   Z-ADD     ##CYMD        LDSOWD
      ** GET READY DATE FORMAT
     C                   Z-ADD     FRMDAT        ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        LDCRDY
     C                   Z-ADD     ##CYMD        LRCRDY
     C                   Z-ADD     ##CYMD        LDSHPD
     C     RDKEY         KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    LRSOWD
     C                   KFLD                    LRCRDY
     C                   KFLD                    LRGLOC
     C                   KFLD                    LRCLOC
     C                   KFLD                    LRCODE
     C                   KFLD                    LRCUST
     C                   MOVEL     'A'           LRCODE
     C                   Z-ADD     0             LRCUST
     C     LOTKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
     C                   KFLD                    LDSOWD
     C                   KFLD                    LDGLOC
     C     RDKEY         CHAIN     FDLOTRD                            55
     C   55              DO
     C                   MOVEL     'A'           LRCODE
     C                   MOVEL     IMITEM        LRITEM
     C                   MOVEL     IMSIZE        LRSIZE
     C                   MOVEL     IMWHSE        LRWHSE
     C                   MOVEL     IMLOOK        LRALPH
     C                   MOVEL     IMDES1        LRDESC
     C                   MOVEL     IMPCL1        LRPRCL
     C                   Z-ADD     IMCOMP        LRCOMP
     C                   ENDDO
     C     LOTKEY        CHAIN     FDLOT                              56
     C   56              DO
     C                   MOVEL     'A'           LDSTAT
     C                   MOVEL     IMITEM        LDITEM
     C                   MOVEL     IMSIZE        LDSIZE
     C                   MOVEL     IMWHSE        LDWHSE
     C                   MOVEL     IMLOOK        LDALPH
     C                   MOVEL     IMDES1        LDDESC
     C                   MOVEL     IMPCL1        LDPRCL
     C                   Z-ADD     IMCOMP        LDCOMP
     C                   ENDDO
     C*                  MOVEL     'Y'           LDFIXD
     C                   MOVEL     'N'           LDFIXD
     C                   ADD       NEWQTY        LDQTOH
     C                   Z-ADD     NEWQTY        LRQTOH
     C     LDQTOH        SUB       LDQTAL        LDQTAV
     C     LRQTOH        SUB       LRQTAL        LRQTAV
     C                   Z-ADD     TIMOD         LDTIME
     C                   Z-ADD     TDATE         LDDTLA
     C                   MOVEL     USERID        LDUSER
     C                   Z-ADD     TIMOD         LRTIME
     C                   Z-ADD     TDATE         LRDTLA
     C                   MOVEL     USERID        LRUSER
      ** OUTPUT FILES
     C   55              WRITE     RDLOTRD
     C  N55              UPDATE    RDLOTRD
     C   56              WRITE     RDLOT
     C  N56              UPDATE    RDLOT
     C                   ENDSR
      ***********************
      ** DELETE WEEK       **
      ***********************
     C     DELWK         BEGSR
     C     STRDAT        SETLL     FDLOTDSI
     C                   SETON                                        15
     C     NXTWKD        TAG
     C     STRDAT        READE     FDLOTDSI                               90
     C   90              GOTO      ENDWKD
     C     LRGLOC        IFNE      'R  '
     C                   DELETE    LOTRD
     C                   END
     C                   GOTO      NXTWKD
     C     ENDWKD        ENDSR
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
0006 C********************************************************************
0007 C* FIGURES OUT DAY OF THE WEEK THAT ENTERED DATE IS.
0008 C* ##DDD INPUT DATE DDDDD - RESULT FROM @DT@B2
0009 C* #Y OUTPUT INDEX REFLECTING DAY OF WEEK
0011 C********************************************************************
0003 CSR   @DAYWK        BEGSR
0285 CSR   ##DDD         DIV       7.0000        #WKS             10 5
0286 CSR                 MOVE      #WKS          ##R               5 5
0287 CSR   ##R           MULT(H)   7             #Y                1 0
     C*
0288 CSR   #Y            IFGT      7
0289 CSR   #Y            SUB       7             #Y
     CSR                 END
     C*
     CSR   #Y            IFEQ      0
     CSR                 Z-ADD     7             #Y
     CSR                 END
     C*
0293 CSR                 ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
      ********************************************************************
      * CONVERT CYYMMDD TO DAY OF CENTURY DDDDD. INDICATOR 90 MINUS DATE
      * ##CYMD INPUT DATE CYYMMDD
      * ##DDD OUTPUT DAY OF CENTURY DDDDD. BASE DATE IS 01/01/1900
      * INDICATORS USED 90-92.
      ********************************************************************
     C     @DT@B1        BEGSR
     C                   Z-ADD     ##CYMD        ##CYMD            7 0  90      NEG DATE
      * CONVERT YEAR TO DAYS
     C                   MOVEL     ##CYMD        #03               3 0          YY
     C     #03           MULT      365           ##DDD             5 0          FIRST LEAP
     C     #03           DIV       4             #03                      93    # OF LEAPS
     C                   MVR                     #02A              2 0    91    LEAP YEAR
     C   91
     CANN93#03           SUB       1             #03
     C     #03           ADD       ##DDD         ##DDD                          DAYS FOR LEAP
      * CONVERT MONTH TO DAYS
     C                   MOVE      ##CYMD        #04               4 0          MMDD
     C                   MOVEL     #04           #02A                           MM
     C     #DY(#02A)     ADD       ##DDD         ##DDD                          DAY OF YEAR
     C     #02A          COMP      02                                 92        GT FEB
     C   91
     CAN 92
     CANN931             ADD       ##DDD         ##DDD                          LP YR MM 3-12
      * ADD DAY OF MONTH
     C                   MOVE      ##CYMD        #02               2 0          DD
     C     #02           ADD       ##DDD         ##DDD                          ADD DAYS
     C   90              Z-ADD     0             ##DDD
     C                   SETOFF                                       919293
     C                   ENDSR
      ********************************************************************
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
** MESSAGE ARRAY
END OF LIST   F5 TO ADD MORE                            1
       SPECULATION ONLY                                 1
