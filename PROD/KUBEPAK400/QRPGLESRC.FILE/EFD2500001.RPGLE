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
      **PROGRAM NAME-------- EFD250
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- DISPLAY DAILY SALES TOTALS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FEFD250FM  CF   E             WORKSTN
     FFSLSDY    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFCALEN    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:XCALEN)
      *
      ** DAY NAME ARRAY CENTERED
     D @DAY            S              9    DIM(7) CTDATA PERRCD(1)              Day Names
      ** MESSAGE ARRAY
     D MSG             S             30    DIM(7) CTDATA PERRCD(1)              HEADINGSs
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
     D  LDAPTO                 1      1  0                                      ARC380
      *****************
      * START HERE    *
      *****************
     C     RSTART        TAG
     C                   MOVEL     LYSHDT        ENDL6             6 0
     C                   MOVEL     SYSHDT        ENDC6             6 0
     C                   MOVEL     LYSHDT        ENDL8             8 0
     C                   MOVEL     SYSHDT        ENDC8             8 0
     C                   SETOFF                                       7710
     C     SYSHDT        SETLL     FSLSDY
     C                   Z-ADD     0             BCURYR
     C                   Z-ADD     0             BLASYR
     C                   Z-ADD     0             BDIFF
     C     NXTSL         TAG
     C     SYSHDT        READE     FSLSDY                                 90
     C   90              GOTO      ENDSL
     C     SYTSLS        ADD       SYTCRM        BCURYR
     C                   GOTO      NXTSL
     C     ENDSL         TAG
      ** GET LAST YEAR
     C     LYSHDT        SETLL     FSLSDY
     C     NXTLY         TAG
     C     LYSHDT        READE     FSLSDY                                 90
     C   90              GOTO      ENDLY
     C     SYTSLS        ADD       SYTCRM        BLASYR
     C                   GOTO      NXTLY
     C     ENDLY         TAG
     C     BCURYR        SUB       BLASYR        BDIFF
     C     BLASYR        IFGT      0
     C     BDIFF         DIV(H)    BLASYR        WKPCT             9 4
     C     WKPCT         MULT(H)   100           BPCT
     C                   ELSE
     C                   Z-ADD     0             BPCT
     C                   END
      * GET MTD AND YTD
     C                   EXSR      MTD
     C                   EXSR      YTD
      *
     C     NXTA          TAG
     C                   SETON                                        79
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       79
     C   KE              DO
     C                   EXSR      *INZSR
     C                   GOTO      RSTART
     C                   ENDDO
     C   KB              DO
     C                   EXSR      SCNB
     C   LR              GOTO      END
     C                   SETON                                        77
     C                   EXSR      *INZSR
     C                   GOTO      RSTART
     C                   ENDDO
     C   KJ              DO
     C                   EXSR      MTD
     C   KB              DO
     C                   EXSR      SCNB
     C   LR              GOTO      END
     C                   SETON                                        77
     C                   EXSR      *INZSR
     C                   GOTO      RSTART
     C                   ENDDO
     C                   EXSR      *INZSR
     C                   GOTO      RSTART
     C                   ENDDO
     C   KL              DO
     C                   EXSR      YTD
     C   KB              DO
     C                   EXSR      SCNB
     C   LR              GOTO      END
     C                   SETON                                        77
     C                   EXSR      *INZSR
     C                   GOTO      RSTART
     C                   ENDDO
     C                   EXSR      *INZSR
     C                   GOTO      RSTART
     C                   ENDDO
     C*          NONXT     TAG
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** MONTH TO DATE     **
      ***********************
     C     MTD           BEGSR
     C***        CYRDTE    SUB  1         MTDDTE  60
     C                   MOVE      CYRDTE        YYW               2 0
     C     100           ADD       YYW           YYW3              3 0
     C                   SUB       1             YYW3
     C                   MOVE      YYW3          YYW
     C                   Z-ADD     CYRDTE        MTDDTE            6 0
     C                   MOVE      YYW           MTDDTE
     C                   Z-ADD     MTDDTE        TODATM
     C     CMSTR         SETLL     FSLSDY
     C                   MOVEL     MSG(2)        HEADM            30
     C                   MOVEL     MSG(5)        DATEHM
     C                   Z-ADD     0             DCURYR
     C                   Z-ADD     0             DLASYR
     C                   Z-ADD     0             DDIFF
     C     NXTML         TAG
     C                   READ      FSLSDY                                 90
     C   90              GOTO      ENDML
     C     SYSHDT        IFGT      CMEND
     C                   GOTO      ENDML
     C                   END
     C     SYTSLS        ADD       SYTCRM        WRK              11 2
     C                   ADD       WRK           DCURYR
     C                   GOTO      NXTML
     C     ENDML         TAG
      ** GET LAST YEAR
     C     LMSTR         SETLL     FSLSDY
     C     NXTMY         TAG
     C                   READ      FSLSDY                                 90
     C   90              GOTO      ENDMY
     C     SYSHDT        IFGT      LMEND
     C                   GOTO      ENDMY
     C                   END
     C     SYTSLS        ADD       SYTCRM        WRK
     C                   ADD       WRK           DLASYR
     C                   GOTO      NXTMY
     C     ENDMY         TAG
     C     DCURYR        SUB       DLASYR        DDIFF
     C     DLASYR        IFGT      0
     C     DDIFF         DIV(H)    DLASYR        WKPCT             9 4
     C     WKPCT         MULT(H)   100           DPCT
     C                   ELSE
     C                   Z-ADD     0             DPCT
     C                   END
      *
     C                   ENDSR
      **********************
      ** YEAR TO DATE     **
      **********************
     C     YTD           BEGSR
     C                   MOVEL     MSG(3)        HEADY            30
     C                   MOVEL     MSG(6)        DATEHY
     C                   MOVE      CYRDTE        YYW               2 0
     C     100           ADD       YYW           YYW3              3 0
     C                   SUB       1             YYW3
     C                   MOVE      YYW3          YYW
     C                   Z-ADD     CYRDTE        MTDDTE            6 0
     C                   MOVE      YYW           MTDDTE
     C                   Z-ADD     MTDDTE        TODATY
     C******     CYRDTE    SUB  1         MTDDTE  60
     C                   Z-ADD     MTDDTE        TODATY
     C     CYSTR         SETLL     FSLSDY
     C                   Z-ADD     0             LCURYR
     C                   Z-ADD     0             LLASYR
     C                   Z-ADD     0             LDIFF
     C     NXTYL         TAG
     C                   READ      FSLSDY                                 90
     C   90              GOTO      ENDYL
     C     SYSHDT        IFGT      CYEND
     C                   GOTO      ENDYL
     C                   END
     C     SYTSLS        ADD       SYTCRM        WRK              11 2
     C                   ADD       WRK           LCURYR
     C                   GOTO      NXTYL
     C     ENDYL         TAG
      ** GET LAST YEAR
     C     LYSTR         SETLL     FSLSDY
     C     NXTLYT        TAG
     C                   READ      FSLSDY                                 90
     C   90              GOTO      ENDLYT
     C     SYSHDT        IFGT      LYEND
     C                   GOTO      ENDLYT
     C                   END
     C     SYTSLS        ADD       SYTCRM        WRK
     C                   ADD       WRK           LLASYR
     C                   GOTO      NXTLYT
     C     ENDLYT        TAG
     C     LCURYR        SUB       LLASYR        LDIFF
     C     LLASYR        IFGT      0
     C     LDIFF         DIV(H)    LLASYR        WKPCT             9 4
     C     WKPCT         MULT(H)   100           LPCT
     C                   ELSE
     C                   Z-ADD     0             LPCT
     C                   END
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C  N77              TIME                    TIMOD             6 0
     C  N77              TIME                    TMWRK            12 0
     C  N77              MOVE      TMWRK         TDATE             6 0
     C   77              MOVE      VDATE         TDATE             6 0
     C                   Z-ADD     TDATE         CYRDTE            6 0
     C                   MOVE      TDATE         TST3              3 0
     C                   ADD       100           TST3
     C                   SUB       1             TST3
     C                   MOVE      TST3          TST2              2 0
     C                   Z-ADD     TDATE         FRMDAT
     C                   Z-ADD     TDATE         FRMDAY
     C                   Z-ADD     TDATE         FRMDAM
     C                   MOVE      TDATE         LYRDTE
     C                   MOVE      TST2          LYRDTE
     C     TDATE         CHAIN     FCALEN                             90
     C  N90              DO
     C                   MOVEL     @DAY(CL#Y)    DAY               9
     C                   END
     C                   MOVE      *BLANKS       HEADD            30
     C                   MOVEL     MSG(1)        HEADD
     C                   MOVE      *BLANKS       DATEHD
     C                   MOVEL     MSG(4)        DATEHD
     C                   MOVEL     DAY           HEADWK           18
     C                   MOVEL     MSG(4)        HEADW1            8
     C                   MOVE      HEADW1        HEADWK
     C                   MOVE      HEADWK        DATEHD
     C     TDATE         MULT      10000.01      RDATE             6 0
     C                   MOVEL     RDATE         YY                2 0
     C     YY            IFGT      70
     C                   MOVEL     19            SYSHDT
     C                   ELSE
     C                   MOVEL     20            SYSHDT
     C                   END
     C                   MOVE      RDATE         SYSHDT
      ** GET MTH AND YEAR START AND END
     C                   MOVEL     SYSHDT        CYR4              4 0
     C     CYR4          SUB       1             LYR4              4 0
     C                   MOVEL     TDATE         MM2               2 0
     C                   MOVE      RDATE         DD2               2 0
     C                   MOVEL     MM2           WK4               4 0
     C                   MOVE      01            WK4
     C                   MOVEL     CYR4          CMSTR             8 0
     C                   MOVE      WK4           CMSTR
     C                   MOVEL     LYR4          LMSTR             8 0
     C                   MOVE      WK4           LMSTR
     C                   MOVE      DD2           WK4
     C                   MOVEL     CYR4          CMEND             8 0
     C                   MOVE      WK4           CMEND
     C                   MOVEL     LYR4          LMEND             8 0
     C                   MOVE      WK4           LMEND
      ** YEAR END SAME AS MONTH END
     C                   Z-ADD     CMEND         CYEND             8 0
     C                   Z-ADD     LMEND         LYEND             8 0
      ** GET START YEAR DATE FROM MPER RECORD
     C     01            CHAIN     FMAPER                             91
     C                   MOVEL     ACFSST        WK4
     C                   MOVE      ACFSST        NCY               2 0
     C     NCY           IFLT      90
     C     2000          ADD       NCY           CYR4              4 0
     C                   ELSE
     C     1900          ADD       NCY           CYR4
     C                   END
     C                   MOVEL     CYR4          CYSTR             8 0
     C                   MOVE      WK4           CYSTR
     C     CYR4          SUB       1             LYR4              4 0
     C                   MOVEL     LYR4          LYSTR             8 0
     C                   MOVE      WK4           LYSTR
     C     XCLKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
     C     CLYEAR        IFGT      00
     C                   SUB       1             CLYEAR
     C                   ELSE
     C                   Z-ADD     99            CLYEAR
      ** FOR 1999 USE  WEEK 1 THRU 52 NOT 53
     C***                  ADD  1         CLWEEK
     C                   SUB       1             CLCENT
     C                   END
     C     XCLKEY        CHAIN     FCALEX                             90
     C  N90              Z-ADD     CLDATE        LYRDTE            6 0
     C  N90              Z-ADD     CLDATE        TODAT
     C     LYRDTE        MULT      10000.01      LRR               6 0
     C                   MOVEL     CLCENT        LYSHDT            8 0
     C                   MOVE      LRR           LYSHDT
     C                   ENDSR
      *******
      * SCNB - GET NEW DATE
      *******
     C     SCNB          BEGSR
     C     RSTRTB        TAG
     C                   Z-ADD     0             VDATE
     C                   WRITE     SCRNB
     C                   SETOFF                                       10
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      ENDB
     C                   Z-ADD     VDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C   90              SETON                                        10
     C   10              GOTO      RSTRTB
     C     ENDB          ENDSR
      *
**  DAY NAMES  SPACE TO CENTER ON SCREEN
 Monday
 Tuesday
Wednesday
Thursday
 Friday
Saturday
 Sunday
**  HEADINGS  SPACE TO CENTER ON SCREEN
 Current Day Sales by Branch                          1
Month to Date Sales by Branch                         2
 Year to Date Sales by Branch                         3
--------                                              4
----Month to Date Thru-----                           5
-----Year to Date Thru-----                           6
Company Summary                                       7
