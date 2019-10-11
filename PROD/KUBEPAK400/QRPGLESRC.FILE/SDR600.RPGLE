      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      **PROGRAM NAME-------- SDR600
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- DSIPLAY HISTORY SEED PRICES
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  9/20/01 EFD ELIMINATE PRICE 8 COL. AND MOVE CUR PRICE TO COL 1
      *  7/25/02 EFD MAKE PRICE 2 DECIMAL FIELD.
      *
     FSDR600FM  CF   E             WORKSTN
     F                                     SFILE(PRCSFL:RECNO)
     FFMVEND    IF   E           K DISK
      ** SERIES FILES
     FFSERIES   IF   E           K DISK
     FFILE1     IF   E           K DISK    EXTIND(*INU1)
     F                                     RENAME(RSERIES:SER1)
     FFILE2     IF   E           K DISK    EXTIND(*INU2)
     F                                     RENAME(RSERIES:SER2)
     FFILE3     IF   E           K DISK    EXTIND(*INU3)
     F                                     RENAME(RSERIES:SER3)
     FFILE4     IF   E           K DISK    EXTIND(*INU4)
     F                                     RENAME(RSERIES:SER4)
     FFILE5     IF   E           K DISK    EXTIND(*INU5)
     F                                     RENAME(RSERIES:SER5)
     FFILE6     IF   E           K DISK    EXTIND(*INU6)
     F                                     RENAME(RSERIES:SER6)
     FFILE7     IF   E           K DISK    EXTIND(*INU7)
     F                                     RENAME(RSERIES:SER7)
      *FFILE8   IF  E           K        DISK                           U8
      *F            RSERIES                           KRENAMESER8
      ** SERPRC FILES
     FFSERPRC   IF   E           K DISK
     FFILE11    IF   E           K DISK    EXTIND(*INU1)
     F                                     RENAME(RSERPRC:RPRC1)
     FFILE12    IF   E           K DISK    EXTIND(*INU2)
     F                                     RENAME(RSERPRC:RPRC2)
     FFILE13    IF   E           K DISK    EXTIND(*INU3)
     F                                     RENAME(RSERPRC:RPRC3)
     FFILE14    IF   E           K DISK    EXTIND(*INU4)
     F                                     RENAME(RSERPRC:RPRC4)
     FFILE15    IF   E           K DISK    EXTIND(*INU5)
     F                                     RENAME(RSERPRC:RPRC5)
     FFILE16    IF   E           K DISK    EXTIND(*INU6)
     F                                     RENAME(RSERPRC:RPRC6)
     FFILE17    IF   E           K DISK    EXTIND(*INU7)
     F                                     RENAME(RSERPRC:RPRC7)
      *FFILE18  IF  E           K        DISK                           U8
      *F            RSERPRC                           KRENAMERPRC8
      *
      * INPUT YEAR ARRAY  IE 2000 2001 ETC
      *
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
     D  LCO                    1      2  0                                      ARC380
     D  YR                    20     51  0                                      ARC380
     D                                     DIM(8)                               YEAR NUMBERS
      ** YEAR 1
     I**                                     20  230YR,1                  ARC380
      ** YEAR 2
     I*                                      24  270YR,2                  ARC380
      ** YEAR 3
     I*                                      28  310YR,3                  ARC380
      ** YEAR 4
     I*                                      32  350YR,4                  ARC380
      ** YEAR 5
     I*                                      36  390YR,5                  ARC380
      ** YEAR 6
     I*                                      40  430YR,6                  ARC380
      ** YEAR 7
     I*                                      44  470YR,7                  ARC380
      ** YEAR 8
     I*                                      48  510YR,8                  ARC380
      *****************
      ** START HERE  **
      *****************
     C     RSTART        TAG
     C                   MOVE      *BLANKS       ALPHA
     C                   SETOFF                                       10  99
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
      ** CHECK VEND NUMBER
     C     VEND          IFLE      0
     C     ALPHA         ANDGT     *BLANKS
     C                   MOVEL     ALPHA         VMLOOK
     C                   Z-ADD     01            VMCOMP            2 0
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       ALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        VEND
     C     VEND          IFLE      0
     C                   GOTO      NXTA
     C                   ENDIF
     C                   ENDIF
     C     VEND          IFLE      0
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
     C     VEND          CHAIN     FMVEND                             10
     C   10              GOTO      NXTA
      ** IF HERE WE HAVE A GOOD VENDOR
     C                   EXSR      BLDSFL
     C   99              GOTO      NXTA
     C                   MOVE      *BLANKS       OSTRT
     C     NXTSFL        TAG
     C     PAGE#         IFLE      0
     C     PAGE#         ORGT      RECNO
     C                   Z-ADD     1             PAGE#
     C                   END
     C                   EXFMT     PRCCTL
      ** CHECK F KEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C     STRTW         IFNE      OSTRT
     C                   EXSR      CHKSFL
     C                   MOVEL     STRTW         OSTRT            10
     C                   END
     C                   GOTO      NXTSFL
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   MOVE      '1'           *IN(80)
     C                   WRITE     PRCCTL
     C                   MOVE      '0'           *IN(80)
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      *BLANKS       SECODE
     C     SECODE        SETLL     FSERIES
     C     NXTBLD        TAG
     C                   READ      FSERIES                                90
     C   90              GOTO      ENDBLD
     C                   Z-ADD     SEFORM        FORM
     C                   MOVEL     SEDESC        DESC
     C                   SETOFF                                       98
     C   01              EXSR      GET01
     C   02              EXSR      GET02
     C   03              EXSR      GET03
     C   04              EXSR      GET04
     C   05              EXSR      GET05
     C   06              EXSR      GET06
     C   07              EXSR      GET07
     C*  08                EXSR GET08
      ** 98 IS TURNED ON IF ANY HITS
     C  N98              GOTO      NXTBLD
     C     PRCKEY        CHAIN     FSERPRC                            91
     C                   Z-ADD     0             CURPRC
     C  N91              DO
     C     FORM          COMP      2                                  232122
     C   21              Z-ADD(H)  SPPRC1        CURPRC
     C   22              Z-ADD(H)  SPPRC2        CURPRC
     C   23              Z-ADD(H)  SPPRC3        CURPRC
     C                   ENDDO
     C                   ADD       1             RECNO
     C                   WRITE     PRCSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C     RECNO         IFLE      0
     C                   SETON                                        99
     C                   ELSE
     C                   SETOFF                                       99
     C                   END
     C                   ENDSR
      ***********************
      ** CHECK SUB FILE    **
      ***********************
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             PAGE#
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   Z-ADD     0             RECNO
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     PRCSFL                             90
     C   90              GOTO      NXTCHK
     C     SPCODE        IFGE      STRTW
     C                   Z-ADD     RECNO         PAGE#
     C                   GOTO      ENDCHK
     C                   END
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C                   Z-ADD     LSTREC        RECNO
     C                   ENDSR
      ***********************
      ** GET PRIOR INFO 1  **
      ***********************
     C     GET01         BEGSR
     C                   Z-ADD     0             PRC1
     C     SECODE        CHAIN     FILE1                              90
     C     PRCKEY        KLIST
     C                   KFLD                    VEND
     C                   KFLD                    SECODE
     C     PRCKEY        CHAIN     FILE11                             91
     C  N91              DO
     C     SEFORM        COMP      2                                  232122
     C   21              Z-ADD(H)  SPPRC1        PRC1
     C   22              Z-ADD(H)  SPPRC2        PRC1
     C   23              Z-ADD(H)  SPPRC3        PRC1
     C                   SETON                                        98
     C                   ENDDO
     C                   ENDSR
      ***********************
      ** GET PRIOR INFO 2  **
      ***********************
     C     GET02         BEGSR
     C                   Z-ADD     0             PRC2
     C     SECODE        CHAIN     FILE2                              90
     C     PRCKEY        CHAIN     FILE12                             91
     C  N91              DO
     C     SEFORM        COMP      2                                  232122
     C   21              Z-ADD(H)  SPPRC1        PRC2
     C   22              Z-ADD(H)  SPPRC2        PRC2
     C   23              Z-ADD(H)  SPPRC3        PRC2
     C                   SETON                                        98
     C                   ENDDO
     C                   ENDSR
      ***********************
      ** GET PRIOR INFO 3  **
      ***********************
     C     GET03         BEGSR
     C                   Z-ADD     0             PRC3
     C     SECODE        CHAIN     FILE3                              90
     C     PRCKEY        CHAIN     FILE13                             91
     C  N91              DO
     C     SEFORM        COMP      2                                  232122
     C   21              Z-ADD(H)  SPPRC1        PRC3
     C   22              Z-ADD(H)  SPPRC2        PRC3
     C   23              Z-ADD(H)  SPPRC3        PRC3
     C                   SETON                                        98
     C                   ENDDO
     C                   ENDSR
      ***********************
      ** GET PRIOR INFO 4  **
      ***********************
     C     GET04         BEGSR
     C                   Z-ADD     0             PRC4
     C     SECODE        CHAIN     FILE4                              90
     C     PRCKEY        CHAIN     FILE14                             91
     C  N91              DO
     C     SEFORM        COMP      2                                  232122
     C   21              Z-ADD(H)  SPPRC1        PRC4
     C   22              Z-ADD(H)  SPPRC2        PRC4
     C   23              Z-ADD(H)  SPPRC3        PRC4
     C                   SETON                                        98
     C                   ENDDO
     C                   ENDSR
      ***********************
      ** GET PRIOR INFO 5  **
      ***********************
     C     GET05         BEGSR
     C                   Z-ADD     0             PRC5
     C     SECODE        CHAIN     FILE5                              90
     C     PRCKEY        CHAIN     FILE15                             91
     C  N91              DO
     C     SEFORM        COMP      2                                  232122
     C   21              Z-ADD(H)  SPPRC1        PRC5
     C   22              Z-ADD(H)  SPPRC2        PRC5
     C   23              Z-ADD(H)  SPPRC3        PRC5
     C                   SETON                                        98
     C                   ENDDO
     C                   ENDSR
      ***********************
      ** GET PRIOR INFO 6  **
      ***********************
     C     GET06         BEGSR
     C                   Z-ADD     0             PRC6
     C     SECODE        CHAIN     FILE6                              90
     C     PRCKEY        CHAIN     FILE16                             91
     C  N91              DO
     C     SEFORM        COMP      2                                  232122
     C   21              Z-ADD(H)  SPPRC1        PRC6
     C   22              Z-ADD(H)  SPPRC2        PRC6
     C   23              Z-ADD(H)  SPPRC3        PRC6
     C                   SETON                                        98
     C                   ENDDO
     C                   ENDSR
      ***********************
      ** GET PRIOR INFO 7  **
      ***********************
     C     GET07         BEGSR
     C                   Z-ADD     0             PRC7
     C     SECODE        CHAIN     FILE7                              90
     C     PRCKEY        CHAIN     FILE17                             91
     C  N91              DO
     C     SEFORM        COMP      2                                  232122
     C   21              Z-ADD(H)  SPPRC1        PRC7
     C   22              Z-ADD(H)  SPPRC2        PRC7
     C   23              Z-ADD(H)  SPPRC3        PRC7
     C                   SETON                                        98
     C                   ENDDO
     C                   ENDSR
      ***********************
      ** GET PRIOR INFO 8  **
      ***********************
     C*          GET08     BEGSR
     C*                    Z-ADD0         PRC8
     C*          SECODE    CHAINFILE8                90
     C*          PRCKEY    CHAINFILE18               91
     C* N91                DO
     C*          SEFORM    COMP 2                    232122
     C*  21                Z-ADDSPPRC1    PRC8      H
     C*  22                Z-ADDSPPRC2    PRC8      H
     C*  23                Z-ADDSPPRC3    PRC8      H
     C*                    SETON                     98
     C*                    ENDDO
     C*                    ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      ** SET UP SCREEN INDICATORS AND HEADINGS
     C                   MOVEA     '00000000'    *IN(1)
     C   U1              SETON                                        01
     C   U2              SETON                                        02
     C   U3              SETON                                        03
     C   U4              SETON                                        04
     C   U5              SETON                                        05
     C   U6              SETON                                        06
     C   U7              SETON                                        07
     C   U8              SETON                                        08
     C   U1              Z-ADD     YR(1)         YEAR1
     C   U2              Z-ADD     YR(2)         YEAR2
     C   U3              Z-ADD     YR(3)         YEAR3
     C   U4              Z-ADD     YR(4)         YEAR4
     C   U5              Z-ADD     YR(5)         YEAR5
     C   U6              Z-ADD     YR(6)         YEAR6
     C   U7              Z-ADD     YR(7)         YEAR7
      *  U8                Z-ADDYR,8      YEAR8
     C                   ENDSR
