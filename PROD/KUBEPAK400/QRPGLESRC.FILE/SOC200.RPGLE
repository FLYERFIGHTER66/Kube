      *--------------------------------------------------------------          1
      *                                                                        1
      *  COPYRIGHT EFD ENTERPRISES, INC.    1995
      *                                                                        1
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- SOC200
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- THE GREENHOUSE MANAGEMENT SYSTEM
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SHIPPED ORDER HISTORY REPORT.
      **DATE WRITTEN-------- 08/03/95
      **DESCRIPTION--------- GET REQUESTED PARAMETERS FOR REPORT.
      **
      **
      **
      **
      **
      **
      **
      *            *******************************
      *            **     PROGRAM CHANGE LOG    **
      *            *******************************
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 8/24/95 EFD ADD REPORT TYPE AND PRINTER ID
      * 1/16/99 JJP AS400 NATIVE CREATION OF SAME PROGRAM
      *             PLUS TAKE OUT FUNCTIONALITY OF WIDE VS NON WIDE REPORTING
      *             THIS REPORT WILL ONLY PRINT OUT ON GREEN BAR- CPI-15(198)
      *             FOR CUSTOMER SEARCH CALL NEW NATIVE: CSTALOOK
      * 2/10/99 GD  REDO TO EFD 400 SPECS
      * 2/20/99 JJP AS400 NATIVE CREATION OF SAME PROGRAM
      *             PLUS TAKE OUT FUNCTIONALITY OF WIDE VS NON WIDE REPORTING
      *             THIS REPORT WILL ONLY PRINT OUT ON GREEN BAR- CPI-15(198)
      *             FOR CUSTOMER SEARCH CALL NEW NATIVE: CSTALOOK
      *------------------------------------------------------------------------
     FFMCUST    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FSOC200FM  CF   E             WORKSTN
      *-------------------------------------------------------------------------
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
     D                UDS
     D  LUSER                  1      8
     D  LCUST                  9     14  0
     D  LBDATE                15     20  0
     D  LBCYMD                21     27  0
     D  LEDATE                28     33  0
     D  LECYMD                34     40  0
     D  LBPC                  41     42
     D  LEPC                  43     44
     D  LPRTR                 45     54
     D  LCO                   55     56  0
     D  ENDDAT               100    105  0
     D  CANCEL               133    133
     C*
     C*--------- MAINLINE CALCS
     C                   Z-ADD     01            VCO
     C**
     C** COME HERE ON RESTART
     C     RSTART        TAG
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TIMWRK           12 0
     C                   MOVE      TIMWRK        TDATE             6 0
     C                   Z-ADD     0             LCUST
     C                   Z-ADD     0             LBDATE
     C                   Z-ADD     0             LBCYMD
     C                   Z-ADD     0             LEDATE
     C                   Z-ADD     0             LECYMD
     C                   Z-ADD     0             CUST#
     C                   MOVE      *BLANKS       CANCEL
     C                   SETOFF                                       101120
     C                   SETOFF                                       212223
     C                   SETOFF                                       606162
     C                   SETOFF                                       635377
     C*
     C     NXTA          TAG
     C                   EXFMT     SCRNA                                        OUTPUT PANEL
      *--
     C   KF              DO
     C                   EXSR      CLRFLD
     C                   GOTO      RSTART
     C                   END
     C   KC
     COR KG              DO
     C                   MOVE      'X'           CANCEL
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       101120
     C                   SETOFF                                       212223
     C                   SETOFF                                       606162
     C                   SETOFF                                       635377
     C                   Z-ADD     0             COUNT             4 0
      *
     C                   MOVEL     USERID        LUSER
     C                   Z-ADD     CUST#         LCUST
     C                   Z-ADD     VBDATE        LBDATE
     C                   Z-ADD     VEDATE        LEDATE
     C                   MOVEL     VBPC          LBPC
     C                   MOVEL     VEPC          LEPC
     C                   MOVEL     VPRTR         LPRTR
     C                   Z-ADD     VCO           LCO
     C*
      * CHECK CUSTOMER NUMBER.
      *
     C     CUST#         IFEQ      0
     C     CALPHA        ANDGT     *BLANKS
     C                   EXSR      GETCUS
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     CUST#         IFGT      0
     C     CUST#         CHAIN     RMCUST                             10
     C**
     C     *IN10         IFEQ      '1'
     C                   MOVE      *BLANKS       CMNAME
     C                   MOVE      '1'           *IN99
     C                   Z-ADD     0             LCUST
     C                   GOTO      NXTA
     C                   END
     C*
     C     CUST#         IFNE      LCUST
     C                   ADD       1             COUNT
     C                   Z-ADD     CUST#         LCUST
     C                   END
     C                   MOVE      *BLANKS       CALPHA
     C                   END
     C** IF HERE AND CUST# IS 0
     C     CUST#         IFEQ      0
     C                   SETON                                        101199
     C                   GOTO      NXTA
     C                   ENDIF
      *
      *  CHECK PRODUCT CLASSES
      *
     C     VBPC          IFEQ      '? '
     C     VBPC          OREQ      '/ '
     C                   MOVEL     VBPC          VPRCL             2
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         VBPC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VEPC          IFEQ      '? '
     C     VEPC          OREQ      '/ '
     C                   MOVEL     VEPC          VPRCL
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         VEPC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VBPC          IFGT      *BLANKS
     C     VBPC          CHAIN     FMPRCL                             91
     C   91              SETON                                        2021
     C   21              GOTO      NXTA
     C                   ENDIF
      *
     C     VEPC          IFGT      *BLANKS
     C     VEPC          CHAIN     FMPRCL                             91
     C   91              SETON                                        22
     C   22              GOTO      NXTA
     C                   ENDIF
      *
     C     VBPC          IFGT      *BLANKS
     C     VEPC          ANDEQ     *BLANKS
     C                   MOVEL     VBPC          VEPC
     C                   ENDIF
      *
     C     VBPC          IFGT      *BLANKS                                                  K
     C     VBPC          ANDGT     VEPC
     C                   SETON                                        2023
     C   23              GOTO      NXTA
     C                   ENDIF
     C**
     C     VBPC          IFNE      LBPC
     C                   ADD       1             COUNT
     C                   MOVE      VBPC          LBPC
     C                   END
     C**
     C**
     C     VEPC          IFNE      LEPC
     C                   ADD       1             COUNT
     C                   MOVE      VEPC          LEPC
     C                   END
     C**
      *
      * NOW CHECK DATES
      *
     C     VBDATE        IFEQ      *ZEROS                                                   K
     C     VEDATE        ANDEQ     *ZEROS                                                   K
     C                   SETON                                        6061
     C   61              GOTO      NXTA
     C                   ENDIF
      *
     C     VBDATE        IFEQ      *ZEROS                                                   K
     C     VEDATE        ANDGT     *ZEROS                                                   K
     C                   SETON                                        6061
     C   61              GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     VBDATE        ##MDY             6 0                      K
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        6062
     C                   GOTO      NXTA
     C                   END
      *
      * GET DAY OF CENTURY
      *
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         BDATE             5 0
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
      *
      * GET TO A MONDAY DATE
      *
     C     #Y            IFNE      1
     C                   SUB       1             #Y
     C                   SUB       #Y            ##DDD
     C                   END
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        LBCYMD
     C                   Z-ADD     ##MDY         LBDATE
      *
      * ENDING DATE
      *
     C                   Z-ADD     VEDATE        ##MDY             6 0                      K
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        70
     C                   GOTO      NXTA
     C                   END
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EDATE             5 0
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
      *
      * GET TO A MONDAY DATE
      *
     C     #Y            IFNE      1
     C                   SUB       1             #Y
     C                   SUB       #Y            ##DDD
     C                   END
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         ENDDAT            6 0
      *
      * GET SUNDAY DATE IN LDAYYMMDD FOR SORT
      *
     C                   ADD       6             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        LECYMD
      *
     C     BDATE         IFGT      EDATE                                                    K
     C                   SETON                                        6064
     C   64              GOTO      NXTA
     C                   ENDIF
     C*                    Z-ADDBDATE     LBEGDT
     C*                    Z-ADDEDATE     LENDDT
      *
      * CHECK PRINTER ID
      *
     C     VPRTR         IFLE      *BLANKS
     C                   SETON                                        53
     C   53              GOTO      NXTA
     C                   ENDIF
     C**
     C     VPRTR         IFNE      LPRTR
     C                   ADD       1             COUNT
     C                   MOVE      VPRTR         LPRTR
     C                   END
     C**
      *
      * CHECK COMPANY NUMBER
      *
     C     VCO           IFEQ      *ZEROS
     C                   SETON                                        77
     C   77              GOTO      NXTA
     C                   ENDIF
      *
     C     VCO           CHAIN     FMCOMP                             90
     C   90              SETON                                        77
     C   77              GOTO      NXTA
     C**
     C     VCO           IFNE      LCO
     C                   ADD       1             COUNT
     C                   MOVE      VCO           LCO
     C                   END
     C**
      *
     C* SEE IF ANY CHANGES
     C     COUNT         IFGT      0
     C                   GOTO      NXTA
     C                   END
     C*   END PROGRAM
     C     END           TAG
     C**
     C                   SETON                                        LR
      **************                                                      QPK220
      * GET CUSTOMER                                                      QPK220
      **************                                                      QPK220
     C     GETCUS        BEGSR
     C** WRONG ONE         CALL 'CSTALOOK'
     C                   CALL      'LKCUST'
      ** PARAM LIST
     C                   PARM                    CALPHA           15
     C                   PARM                    CUSTNO            6 0
     C                   PARM                    CNAME            30
      *
     C                   MOVEL     CMNAME        CSTNAM           30
     C                   Z-ADD     CUSTNO        CUST#
     C                   MOVE      *BLANKS       CALPHA
     C                   ENDSR
     C******************
     C** CLEAR FIELDS
     C**************
     C     CLRFLD        BEGSR
     C                   Z-ADD     0             LBDATE
     C                   Z-ADD     0             LEDATE
     C                   Z-ADD     0             LBCYMD
     C                   Z-ADD     0             LECYMD
     C                   Z-ADD     0             LCUST
     C                   Z-ADD     0             CUST#
     C                   MOVE      *BLANKS       PC1NAM           30
     C                   MOVE      *BLANKS       PC2NAM           30
     C                   MOVE      *BLANKS       VBPC
     C                   MOVE      *BLANKS       VEPC
     C                   MOVE      *BLANKS       OVBPC             2
     C                   MOVE      *BLANKS       OVEPC             2
     C                   MOVE      *BLANKS       CMNAME
     C                   MOVE      *BLANKS       CANCEL
     C                   SETOFF                                       1011
     C                   SETOFF                                       2021
     C                   SETOFF                                       4041
     C                   SETOFF                                       99
     C                   ENDSR
     C*
      *********
      * PCSR
      *********
     C     PCSR          BEGSR
     C                   MOVEL     VPRCL         PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VPRCL
     C                   MOVEL     PCPRCL        VPRCL
     C                   MOVEL     PCDESC        VDESC            30
     C                   SETON                                        99
     C                   ENDSR
