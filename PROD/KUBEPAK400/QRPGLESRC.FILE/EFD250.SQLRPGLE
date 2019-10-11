     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
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
      * 12/26/01 EFD ADD NEW PROD. CLASS SUMMARY
      *
     FEFD250FM  CF   E             WORKSTN
     F                                     SFILE(PCLSFL:RECNO)
     FFSLSDY    IF   E           K DISK
     FFPCSDY    IF   E           K DISK
     F                                     RENAME(RPCSDY:PCSDY)
     FFPCSDYPC  IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
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

     D FPCSDY_Rec    E DS                  EXTNAME(FPCSDY)

     D  DateThru       S              8P 0 Inz(0)
     D  Julian         S              5P 0 Inz(0)

      *  Function Prototypes
     D/COPY QFunctDefn,$AlignLeft
     D/COPY QFunctDefn,$_Dates

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
     C   KC              DO
     C                   Eval      *InLR = *On
     C                   GOTO      END
     C                   ENDDO                                                  KE DO
     C   KE              DO
     C                   EXSR      *INZSR
     C                   GOTO      RSTART
     C                   ENDDO                                                  KE DO
      *  Previous Day Requested
     C   08              DO
     C                   SETON                                        77
     C                   Eval      VDATE=$MDYDate($AddDate($DateMDY(TDATE):-1))
     C                   EXSR      *INZSR
     C                   GOTO      RSTART
     C                   ENDDO                                                  KE DO
      *  Next Day Requested
     C   09              DO
     C                   SETON                                        77
     C                   Eval      VDATE=$MDYDate($AddDate($DateMDY(TDATE):+1))
     C                   EXSR      *INZSR
     C                   GOTO      RSTART
     C                   ENDDO                                                  KE DO
     C   KB              DO
     C                   EXSR      SCNB
     C   LR              GOTO      END
     C                   SETON                                        77
     C                   EXSR      *INZSR
     C                   GOTO      RSTART
     C                   ENDDO                                                  KB DO
     C   KJ              DO
     C                   EXSR      MTD
     C   KB              DO
     C                   EXSR      SCNB
     C   LR              GOTO      END
     C                   SETON                                        77
     C                   EXSR      *INZSR
     C                   GOTO      RSTART
     C                   ENDDO                                                  KB DO
     C                   EXSR      *INZSR
     C                   GOTO      RSTART                                       KJ DO
     C                   ENDDO
     C   KL              DO
     C                   EXSR      YTD
     C   KB              DO
     C                   EXSR      SCNB
     C   LR              GOTO      END
     C                   SETON                                        77
     C                   EXSR      *INZSR
     C                   GOTO      RSTART
     C                   ENDDO                                                  KB DO
     C                   EXSR      *INZSR
     C                   GOTO      RSTART
     C                   ENDDO                                                  KL DO
      ** GET P.C. SUMM
     C   KD              DO
     C                   EXSR      PCSUMM
     C   LR              GOTO      END
     C                   SETON                                        77
     C                   Z-ADD     TDATE         VDATE
     C                   EXSR      *INZSR
     C                   GOTO      RSTART
     C                   ENDDO                                                  KD DO
     C*          NONXT     TAG
     C                   SETON                                        77
     C                   Z-ADD     TDATE         VDATE
     C                   EXSR      *INZSR
     C                   GOTO      RSTART
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
     C                   Z-ADD     0             DLASYR2
     C                   Z-ADD     0             DDIFF
     C                   Z-ADD     0             DDIFF2
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
     C     SYSHDT        ANDGT     LMEND2
     C                   GOTO      ENDMY
     C                   END
     C     SYSHDT        IFLE      LMEND
     C     SYTSLS        ADD       SYTCRM        WRK
     C                   ADD       WRK           DLASYR
     C                   ENDIF
     C     SYSHDT        IFLE      LMEND2
     C     SYTSLS        ADD       SYTCRM        WRK
     C                   ADD       WRK           DLASYR2
     C                   ENDIF
     C                   GOTO      NXTMY
     C     ENDMY         TAG
     C     DCURYR        SUB       DLASYR        DDIFF
     C     DLASYR        IFGT      0
     C     DDIFF         DIV(H)    DLASYR        WKPCT             9 4
     C     WKPCT         MULT(H)   100           DPCT
     C                   ELSE
     C                   Z-ADD     0             DPCT
     C                   END
     C     DCURYR        SUB       DLASYR2       DDIFF2
     C     DLASYR2       IFGT      0
     C     DDIFF2        DIV(H)    DLASYR2       WKPCT             9 4
     C     WKPCT         MULT(H)   100           DPCT2
     C                   ELSE
     C                   Z-ADD     0             DPCT2
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
     C                   Z-ADD     0             LLASYR2
     C                   Z-ADD     0             LDIFF
     C                   Z-ADD     0             LDIFF2
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
     C     SYSHDT        ANDGT     LYEND2
     C                   GOTO      ENDLYT
     C                   END
     C     SYSHDT        IFLE      LYEND
     C     SYTSLS        ADD       SYTCRM        WRK
     C                   ADD       WRK           LLASYR
     C                   ENDIF
     C     SYSHDT        IFLE      LYEND2
     C     SYTSLS        ADD       SYTCRM        WRK
     C                   ADD       WRK           LLASYR2
     C                   ENDIF
     C                   GOTO      NXTLYT
     C     ENDLYT        TAG
     C     LCURYR        SUB       LLASYR        LDIFF
     C     LLASYR        IFGT      0
     C     LDIFF         DIV(H)    LLASYR        WKPCT             9 4
     C     WKPCT         MULT(H)   100           LPCT
     C                   ELSE
     C                   Z-ADD     0             LPCT
     C                   END
     C     LCURYR        SUB       LLASYR2       LDIFF2
     C     LLASYR2       IFGT      0
     C     LDIFF2        DIV(H)    LLASYR2       WKPCT             9 4
     C     WKPCT         MULT(H)   100           LPCT2
     C                   ELSE
     C                   Z-ADD     0             LPCT2
     C                   END
     C                   ENDSR
      **********************
      ** P.C. SUMMARY     **
      **********************
     C     PCSUMM        BEGSR
     C     PCSUMMTAG     TAG
     C                   SETON                                        80
     C                   WRITE     PCLCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             PAGE#
     C                   Z-ADD     0             LSTREC            5 0
     C                   MOVE      *BLANKS       STRPC
     C     STRPC         SETLL     FMPRCL
     C     NXTPC         TAG
     C                   READ      FMPRCL                                 90
     C   90              GOTO      ENDPC
      ** GET NUMBERS
     C     PCSKEY        KLIST
     C                   KFLD                    PCPRCL
     C                   KFLD                    DATEK
     C     PCPKEY        KLIST
     C                   KFLD                    DATEK
     C                   KFLD                    PCPRCL
     C                   Z-ADD     0             TDAY$
     C                   Z-ADD     0             TDAYU
     C                   Z-ADD     0             LDAY$
     C                   Z-ADD     0             LDAYU
     C                   Z-ADD     0             DAY$D
     C                   Z-ADD     0             DAYUD
     C                   Z-ADD     0             TMT$
     C                   Z-ADD     0             TMTU
     C                   Z-ADD     0             LMT$
     C                   Z-ADD     0             LMTU
     C                   Z-ADD     0             MT$D
     C                   Z-ADD     0             MTUD
     C                   Z-ADD     0             TYR$
     C                   Z-ADD     0             TYRU
     C                   Z-ADD     0             LYR$
     C                   Z-ADD     0             LYRU
     C                   Z-ADD     0             YR$D
     C                   Z-ADD     0             YRUD
     C                   Z-ADD     0             COUNT             6 0
      ** GET THIS YEAR DAILY
     C                   Z-ADD     CPCSDT        DATEK             8 0
     C     PCPKEY        CHAIN     FPCSDY                             90
     C  N90              DO
     C     SPTSLS        ADD(H)    SPTCRM        TDAY$
     C     SPTSUN        ADD       SPTCUN        TDAYU
     C                   ADD       1             COUNT
     C                   ENDDO
      ** GET LAST YEAR DAILY
     C                   Z-ADD     LPCSDT        DATEK             8 0
     C     PCPKEY        CHAIN     FPCSDY                             90
     C  N90              DO
     C     SPTSLS        ADD(H)    SPTCRM        LDAY$
     C     SPTSUN        ADD       SPTCUN        LDAYU
     C                   ADD       1             COUNT
     C                   ENDDO
     C     COUNT         IFGT      0
     C     TDAY$         SUB       LDAY$         DAY$D
     C     TDAYU         SUB       LDAYU         DAYUD
     C                   ENDIF
      ** GET MONTH TO DATE THIS YEAR
     C                   Z-ADD     CMSTR         DATEK             8 0
     C     PCSKEY        SETLL     FPCSDYPC
     C     NXTCMP        TAG
     C     PCPRCL        READE     FPCSDYPC                               90
     C  N90              DO
     C     SPSHDT        IFLE      CMEND
     C     SPTSLS        ADD       SPTCRM        WRK$             11 2
     C                   ADD(H)    WRK$          TMT$
     C     SPTSUN        ADD       SPTCUN        WRKU              9 0
     C                   ADD       WRKU          TMTU
     C                   ADD       1             COUNT
     C                   GOTO      NXTCMP
     C                   END                                                    SPSHDT<CMEND
     C                   ENDDO                                                  N90 DO
      ** GET MONTH TO DATE LAST YEAR
     C                   Z-ADD     LMSTR         DATEK             8 0
     C     PCSKEY        SETLL     FPCSDYPC
     C     NXTCML        TAG
     C     PCPRCL        READE     FPCSDYPC                               90
     C  N90              DO
     C     SPSHDT        IFLE      LMEND
     C     SPTSLS        ADD       SPTCRM        WRK$
     C                   ADD(H)    WRK$          LMT$
     C     SPTSUN        ADD       SPTCUN        WRKU
     C                   ADD       WRKU          LMTU
     C                   ADD       1             COUNT
     C                   GOTO      NXTCML
     C                   END                                                    SPSHDT<CMEND
     C                   ENDDO                                                  N90 DO
      ** GET DIFF
     C     TMT$          SUB       LMT$          MT$D
     C     TMTU          SUB       LMTU          MTUD
      ** GET YEAR TO DATE THIS YEAR
     C                   Z-ADD     CYSTR         DATEK             8 0
     C     PCSKEY        SETLL     FPCSDYPC
     C     NXTCYP        TAG
     C     PCPRCL        READE     FPCSDYPC                               90
     C  N90              DO
     C     SPSHDT        IFLE      CYEND
     C     SPTSLS        ADD       SPTCRM        WRK$
     C                   ADD(H)    WRK$          TYR$
     C     SPTSUN        ADD       SPTCUN        WRKU
     C                   ADD       WRKU          TYRU
     C                   ADD       1             COUNT
     C                   GOTO      NXTCYP
     C                   END                                                    SPSHDT<CMEND
     C                   ENDDO                                                  N90 DO
      ** GET MONTH TO DATE LAST YEAR
     C                   Z-ADD     LYSTR         DATEK             8 0
     C     PCSKEY        SETLL     FPCSDYPC
     C     NXTCYL        TAG
     C     PCPRCL        READE     FPCSDYPC                               90
     C  N90              DO
     C     SPSHDT        IFLE      LYEND
     C     SPTSLS        ADD       SPTCRM        WRK$
     C                   ADD(H)    WRK$          LYR$
     C     SPTSUN        ADD       SPTCUN        WRKU
     C                   ADD       WRKU          LYRU
     C                   ADD       1             COUNT
     C                   GOTO      NXTCYL
     C                   END                                                    SPSHDT<CMEND
     C                   ENDDO                                                  N90 DO
      ** GET DIFF
     C     TYR$          SUB       LYR$          YR$D
     C     TYRU          SUB       LYRU          YRUD
      ** WRITE SUBFILE
     C     COUNT         IFGT      0
     C                   If        TDAY$ <> 0 or
     C                             TDAYU <> 0 or
     C                             LDAY$ <> 0 or
     C                             LDAYU <> 0 or
     C                             DAY$D <> 0 or
     C                             DAYUD <> 0 or
     C                             TMT$  <> 0 or
     C                             TMTU  <> 0 or
     C                             LMT$  <> 0 or
     C                             LMTU  <> 0 or
     C                             MT$D  <> 0 or
     C                             MTUD  <> 0 or
     C                             TYR$  <> 0 or
     C                             TYRU  <> 0 or
     C                             LYR$  <> 0 or
     C                             LYRU  <> 0 or
     C                             YR$D  <> 0 or
     C                             YRUD  <> 0
     C                   ADD       1             RECNO
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   WRITE     PCLSFL
     C                   EndIf
     C                   END
     C                   GOTO      NXTPC
     C     ENDPC         TAG
     C     RECNO         IFLE      0
     C                   GOTO      ENDPSM
     C                   END
     C                   EXSR      GETPAG
     C                   EXFMT     PCLCTL
      ** CHECK F KEYS
     C   KC
     COR KG              DO
     C                   SETON                                        LR
     C                   GOTO      ENDPSM
     C                   ENDDO
     C   KF              GOTO      ENDPSM
     C   KI              Do
     C                   EXSR      MOVPCL
     C                   GOTO      PCSUMMTAG
     C                   EndDo
     C                   GOTO      ENDPC
     C     ENDPSM        ENDSR
      ***********************************
      ** Move Between Product Classes  **
      ***********************************
     C     MOVPCL        BEGSR
      /Free
         Chain SFLCSRRRN PCLSFL;
         FROMPC = PCPRCL;
         TOPC = *Blanks;
         SPTSUN=0;
         SPTCUN=0;
         SPTSLS=0;
         SPTCRM=0;
         DateThru = $Date8($dateMDY(VDATE));
         Exec SQL  // Get Record from FPCSDY
           Select * into :FPCSDY_Rec from FPCSDY
             Where SPSHDT = :DateThru
               and SPPCL1 = :PCPRCL
           Fetch First Row Only;
         SLSQ2MOV =  SPTSUN;
         SLSQMAX  =  SPTSUN;
         CRDQ2MOV = -SPTCUN;
         CRDQMAX  = -SPTCUN;
         SLS$2MOV =  SPTSLS;
         SLS$MAX  =  SPTSLS;
         CRD$2MOV = -SPTCRM;
         CRD$MAX  = -SPTCRM;


         Dow not *InKC;

         ExFmt SCRNC;

         If *InKC;
            LeaveSR;
         ENDIF;

         If  SLSQ2MOV = 0 or (SLSQ2MOV > 0 and SLSQ2MOV <= SLSQMAX)
         and CRDQ2MOV = 0 or (CRDQ2MOV > 0 and CRDQ2MOV <= CRDQMAX)
         and SLS$2MOV = 0 or (SLS$2MOV > 0 and SLS$2MOV <= SLS$MAX)
         and CRD$2MOV = 0 or (CRD$2MOV > 0 and CRD$2MOV <= CRD$MAX);

           Exec SQL // Remove Amounts from Source PC
             Update FPCSDY
             Set    SPTSUN = SPTSUN - :SLSQ2MOV
               ,    SPTCUN = SPTCUN + :CRDQ2MOV
               ,    SPTSLS = SPTSLS - :SLS$2MOV
               ,    SPTCRM = SPTCRM + :CRD$2MOV
             Where  SPSHDT = :DateThru
               and  SPPCL1 = :FROMPC;
           SetLL (DateThru:ToPC) FPCSDY;
           If %Equal(FPCSDY);
             Exec SQL // Add Amounts to destination PC
               Update FPCSDY
               Set    SPTSUN = SPTSUN + :SLSQ2MOV
                 ,    SPTCUN = SPTCUN - :CRDQ2MOV
                 ,    SPTSLS = SPTSLS + :SLS$2MOV
                 ,    SPTCRM = SPTCRM - :CRD$2MOV
               Where  SPSHDT = :DateThru
                 and  SPPCL1 = :TOPC;
           LeaveSR;
           Else;
             Exec SQL // Add Amounts to destination PC
               Insert Into FPCSDY
                 VALUES(
                   :DateThru
                 , :ToPC
                 , :Julian
                 , + :SLS$2MOV
                 , - :CRD$2MOV
                 , 0
                 , + :SLSQ2MOV
                 , - :CRDQ2MOV );
             LeaveSR;
           ENDIF;
         Else;
           Iter;
         ENDIF;

         Enddo;

      /End-Free
     C                   ENDSR
      ***********************
      ** GET PAGE NUMBER   **
      ***********************
     C     GETPAG        BEGSR
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             PAGE#
     C     NXTGET        TAG
     C                   ADD       1             RECNO
     C     RECNO         CHAIN     PCLSFL                             90
     C  N90RECNO         IFLE      LSTREC
     C     PCPRCL        IFGE      STRPC
     C                   Z-ADD     RECNO         PAGE#
     C                   GOTO      ENDGET
     C                   END
     C                   GOTO      NXTGET
     C                   END
     C     ENDGET        TAG
     C     PAGE#         IFLE      0
     C                   Z-ADD     1             PAGE#
     C                   END
     C                   Z-ADD     LSTREC        RECNO
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C  N77              TIME                    TIMOD             6 0
     C  N77              TIME                    TMWRK            12 0
     C  N77              MOVE      TMWRK         TDATE             6 0
     C  N77              Eval      TDATE=$MDYDate($AddDate($DateMDY(TDATE):-1))
     C  N77              Eval      VDATE=TDATE
     C  N7700000000      SETLL     FSLSDY
     C  N77              READ      FSLSDY                                 90
     C  N77
     CANN90              Z-ADD     SYSHDT        ORGDAT
     C  N7700000000      SETLL     FPCSDY
     C  N77              READ      FPCSDY                                 90
     C  N77
     CANN90              Z-ADD     SPSHDT        ORGPCD
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
     C                   Eval      DAY2 = $AlignLeft(%Trim(@DAY(CL#Y)):9)
     C                   Eval      DAY3 = $AlignLeft(%Trim(@DAY(CL#Y)):9)
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
     C                   Z-ADD     SYSHDT        CPCSDT            8 0
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
     C                   ADD       Offset        CLWEEK
temp C*                  If        CLYEAR = 04
temp C*                  add       1             CLWEEK
temp C*                  EndIf
     C     XCLKEY        CHAIN     FCALEX                             90
     C  N90              Z-ADD     CLDATE        LYRDTE            6 0
     C  N90              Z-ADD     CLDATE        TODAT
     C  N90              Z-ADD     CLDATE        TODAT2
     C  N90              Z-ADD     CLDATE        TODAT3
     C     LYRDTE        MULT      10000.01      LRR               6 0
     C                   MOVEL     CLCENT        LYSHDT            8 0
     C                   MOVE      LRR           LYSHDT
     C                   Z-ADD     LYSHDT        LPCSDT            8 0
     C                   Z-ADD     LYSHDT        LMEND2            8 0
     C                   Z-ADD     LYSHDT        LYEND2            8 0
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
