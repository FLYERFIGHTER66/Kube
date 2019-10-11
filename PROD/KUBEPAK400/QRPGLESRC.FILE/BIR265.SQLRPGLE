      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR265
      *APPLICATION--------- ORDER ENTRY
      *DESCRIPTION--------- OPEN ORDERS BY ITEM INQUIRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 3/03/00 GD CHANGED SHIP FROM TO OHLOC IN HORDR
      * 4/17/00 GD CHANGED LF FROM FIORDISC TO FIORDISA
      * 5/12/00 EFD ADD SET DOWN LOCATIONS 2,3
      *  5/02/01 EFD DO NOT CLEAR SCREEN A FIELDS
      *  5/16/02 EFD CMDKEY TO SWITCH DATE DISPLAY
      *
     FBIR265FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFHORDR    IF   E           K DISK
     FFIORDISA  IF   E           K DISK
     FFIORASTD  IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFPPO      IF   E           K DISK
     FFLKITM    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(4) CTDATA PERRCD(1)              MESSAGE


     D Last_RC_Code    S              5A
     D Code_Error      S               N   INZ(*On)
     D CalledMode      S               N   INZ(*Off)
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

      *
     D                UDS
     D  LCO                    1      2  0
     D  VITEM                501    512
     D  VSIZE                513    515
     D  VSHDAT               516    521S 0
     D  VCODE                522    522S 0
      *
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DESHFR        VSHFR             3

      *  If ITEM Passed in *LDA, then skip screen A
     C                   If        VITEM <> *Blanks
     C                   Eval      CalledMode = *On
     C* 5/11/16          Eval      VCODE = 1    // This now passed from caller
     C                   Goto      SKIPA
     C                   EndIf

     C                   Z-ADD     TDATE         VSHDAT
     C                   Z-ADD     1             VCODE
      *
      *
      *  MAIN FLOW OF PROGRAM
      *
     C     RSTRT         TAG
     C                   SETOFF                                       99
     C                   MOVEL     *BLANKS       DESC
     C**                   MOVEL*BLANKS   VITEM
     C**                   MOVEL*BLANKS   VSIZE
     C**                   Z-ADD1         VCODE
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131417
     C                   SETOFF                                       303225
     C                   SETOFF                                       809926
     C                   SETOFF                                       354036
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C     SKIPA         TAG
     C     VITEM         IFEQ      *BLANKS
     C                   SETON                                        261499
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C                   MOVEL     VITEM         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       ITEM11
     C                   MOVE      *BLANKS       IMLOOK
     C                   MOVE      VITEM         ITEM11           11
     C                   MOVEL     ITEM11        IMLOOK
     C                   MOVE      VSHFR         SHPFR             3
     C                   MOVE      VSIZE         IMSIZE
     C                   CALL      'LKITEM'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    VSHFR
     C                   MOVEL     IMITEM        VITEM
     C                   MOVEL     IMSIZE        VSIZE
     C                   MOVEL     IMWHSE        VWHSE             3
     C                   MOVEL     IMDES1        DESC
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VCODE         IFLT      1
     C     VCODE         ORGT      6
     C                   SETON                                        17
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
      * OPEN ITEMS
      *
     C     VCODE         IFEQ      2
     C                   SETON                                        40
     C                   ENDIF
      *
     C     VSHFR         IFGT      *BLANKS
     C     VSHFR         CHAIN     FMWHSE                             92
     C   92              SETON                                        35
     C   35              GOTO      RSTRTA
     C**                   SETON                     36
     C                   ENDIF
      * ZERO OUT FIELDS
     C                   Z-ADD     0             LOOH
     C                   Z-ADD     0             LOAV
     C                   Z-ADD     0             LOAL
     C                   Z-ADD     0             TOTQTY            6 1
     C                   Z-ADD     0             TOTSIZ            6 1
     C                   Z-ADD     0             TOTSHP            6 1
      *
     C**N36                GOTO ALSHFR
      ** SEE IF NO SIZE
     C     VSIZE         IFLE      *BLANKS
     C                   SETON                                        52
     C                   ELSE
     C                   SETOFF                                       52
     C                   END
     C     KEYIC         KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C                   KFLD                    VSHFR
     C     KEYIN         KLIST
     C                   KFLD                    VITEM
     C  N52KEYIC         CHAIN     FMINVT                             90
     C   52KEYIN         CHAIN     FMINVT                             90
     C  N52KEYIC         CHAIN     FLKITM                             90
      *
      /Free
         Exec SQL
           select coalesce(olrdyc,'ERROR'), coalesce(TBSHRT,'Bad Code Entered')
           into :RC_CODE, :RC_DESC
           from fmorls join XATABE1 on OLRDYC = TBC6 and TBTB = 'RC'
           where (OLITEM, OLSIZE) = (:VITEM,:VSIZE) ;
         Last_RC_CODE = RC_CODE;
      /End-Free
     C                   Z-ADD     IMQTOH        LOOH
     C                   Z-ADD     IMQTAL        LOAL
     C     IMQTOH        SUB       IMQTAL        AVWRK            11 0
     C                   Z-ADD     AVWRK         LOAV
     C**         LOAV      ADD  IMQTOO    LOONPO
      *
     C                   EXSR      GETDES
      *
     C     ALSHFR        TAG
     C     KEY18         KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C     KEY18         SETLL     FMINVT
     C                   Z-ADD     1             FIRST             4 0
     C     AGAIN         TAG
     C                   READ      FMINVT                                 30
     C   30FIRST         IFEQ      1
     C                   SETON                                        2614
     C                   GOTO      RSTRTA
     C                   END
     C     VITEM         IFNE      IMITEM
     C**         VSIZE     ORNE IMSIZE
     C     FIRST         IFEQ      1
     C                   SETON                                        2614
     C   26              GOTO      RSTRTA
     C                   END
     C                   ENDIF
     C     FIRST         IFEQ      1
     C                   EXSR      GETDES
     C                   END
     C     VITEM         IFNE      IMITEM
     C     VSIZE         ORNE      IMSIZE
     C     FIRST         ANDGT     1
     C     *In30         OrEq      *On
     C     FIRST         ANDGT     1
     C                   GOTO      NOREC
     C                   ENDIF
      *
     C                   ADD       1             FIRST
     C*                    ADD  IMQTOH    TOOH
     C*          IMQTOH    SUB  IMQTAL    AVWRK  110
     C*                    ADD  AVWRK     TAVAIL
     C*                    ADD  AVWRK     TAVOPO
     C*                    ADD  IMQTOO    TAVOPO
     C                   GOTO      AGAIN
      *
     C     NOREC         TAG
      *  N36               MOVEL'ALL'     VSHFR
      *
      * SET FIORDR BACK TO BEGINING OF ITEM
      *
      ** FIRST USE REQ DATE
     C*                  SETON                                        51
      ** COME HERE ON DATE CHANGE
     C     DATCHG        TAG
     C                   Z-ADD     0             TOTQTY
     C                   Z-ADD     0             TOTSHP
     C                   Z-ADD     0             TOTSIZ
     C                   MOVE      *BLANKS       OLDSIZ            3
     C     KITEM         KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C     KITEMD        KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C                   KFLD                    RVSDT
     C     VSHDAT        IFGT      0
     C                   Z-ADD     VSHDAT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        RVSDT             7 0
     C                   ELSE
     C                   Z-ADD     0             RVSDT
     C                   ENDIF
     C     KITEMD        SETLL     FIORDISA
     C     KITEMD        SETLL     FIORASTD
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C*  51              DO
     C*                  MOVEL     MSG(1)        CMDDES
     C*                  MOVEL     MSG(3)        DATTYP
     C*                  ENDDO                                                    51  DO
     C* N51              DO
     C*                  MOVEL     MSG(2)        CMDDES
     C*                  MOVEL     MSG(4)        DATTYP
     C*                  ENDDO                                                   N51  DO
     C     RSTRTB        TAG
     C                   SETOFF                                       9091
     C  N52KITEM         READE     FIORDISA                               90
     C   52VITEM         READE     FIORDISA                               90
     C  N52KITEM         READE     FIORASTD                               91
     C     NXTI          TAG
     C   90
     CAN 91              GOTO      DSPL
     C   90
     CANN91              GOTO      IAST
     C  N90
     CAN 91              GOTO      IORD
      ** PRINT REGULAR ORDERS FIRST
     C     OIRVDT        IFLE      IARVDT
     C                   GOTO      IORD
     C                   ELSE
     C                   GOTO      IAST
     C                   END
      * IORDR READ
     C     IORD          TAG
      ** SEE IF SIZXE CHANGED
     C     OISIZE        IFNE      OLDSIZ
     C   52OLDSIZ        IFGT      *BLANKS
     C                   ADD       1             RECNO
     C                   Z-ADD     0             OHORD#
     C                   Z-ADD     0             OHDTOR
     C                   MOVEL     *ZEROS        OHCUST
     C                   MOVEL     *ZEROS        CUST
     C                   MOVEL     *BLANKS       OHPOS
     C                   MOVEL     *BLANKS       SVIA
     C                   MOVEL     *BLANKS       OIITEM
     C**                   MOVEL*BLANKS   OISIZE
     C*                    MOVEL*BLANKS   DESC
     C**                   MOVEL*BLANKS   OIUUOM
     C                   MOVEL     *BLANKS       AST
     C                   MOVEL     *BLANKS       SHFR
     C                   MOVEL     *BLANKS       LOC
     C                   MOVEL     *BLANKS       NAME
     C                   Z-ADD     TOTSIZ        QTY
     C                   Z-ADD     0             SHP
     C                   Z-ADD     0             DTRQ
     C                   Z-ADD     0             DTCN
     C                   MOVEL     *BLANKS       SHIPD
     C                   MOVEL     '** Total'    DESC1            16
     C                   MOVE      ' Size **'    DESC1
     C                   MOVE      DESC1         NAME
     C                   WRITE     RECSFL
     C                   END                                                     OLDSIZ>" "
     C                   Z-ADD     0             TOTSIZ
     C                   MOVEL     OISIZE        OLDSIZ
     C                   END                                                     OISIZE><OSI
     C   36OISHFR        IFNE      VSHFR
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C                   If        ONLY = 'Y' and OIRVDT <> RVSDT
     C                   GoTo      ENDIOR
     C                   EndIF
      *
     C   40OISTAT        IFEQ      'D'
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     OIQORD        IFEQ      0
     C     *In53         andne     *On                                          *In53 = Show 0 recs
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     OISTAT        IFEQ      'D'
     C     OIQSHP        ANDEQ     0
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     OICOFL        IFEQ      'Y'
     C     VCODE         ANDEQ     2
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     OICOFL        IFEQ      'N'
     C     VCODE         ANDEQ     3
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     OIORD#        CHAIN     FHORDR                             92
     C   92              Eval      OHORD# = 999999
     C   92              GOTO      ENDIOR
     C                   MOVEL     OHNAME        NAME
     C                   Z-ADD     OHCUST        CUST
     C                   MOVE      *BLANKS       SVIA
     C     OHSHPC        IFEQ      '01'
     C                   MOVEL     'T'           SVIA
     C                   END
     C     OHSHPC        IFEQ      '02'
     C                   MOVEL     'P'           SVIA
     C                   END
     C     OIORD#        CHAIN     FPPO                               92
      *
     C     OHCOMP        IFNE      LCO
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     OHPOS         IFNE      'S'
     C     VCODE         ANDEQ     4
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     OHPOS         IFNE      'F'
     C     VCODE         ANDEQ     5
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     OHPOS         IFNE      'P'
     C     VCODE         ANDEQ     6
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     VSHDAT        IFGT      *ZEROS
     C                   Z-ADD     OIDTRQ        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        RVODT             7 0
     C                   ENDIF
      * GET LOCATION BASED ON IMBIN#
     C                   MOVEL     OHLOC         LOC
     C     IMBIN#        IFEQ      '     1'
     C                   MOVEL     POLOWC        LOC
     C                   END
     C     IMBIN#        IFEQ      '     2'
     C                   MOVEL     POLOWF        LOC
     C                   END
      *
     C     VSHDAT        IFGT      *ZEROS
     C     RVODT         ANDLT     RVSDT
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C*          OICOFL    IFEQ 'Y'
     C*          OIQSHP    ANDNEOIQORD
     C*                    GOTO ENDIOR
     C*                    ENDIF
      *
     C                   Z-ADD     OIQORD        QTY
     C                   ADD       QTY           TOTQTY
     C                   ADD       QTY           TOTSIZ
     C                   Z-ADD     OIQSHP        SHP
     C                   ADD       SHP           TOTSHP
      *
      * ITEM HAS BEEN SHIPPED
      *
     C     OICOFL        IFEQ      'Y'
EFD01C     OISTAT        OREQ      'D'
EFD01C     OIQSHP        ANDGT     0
     C                   MOVEL     '*'           SHIPD
     C                   ELSE
     C                   If        OIBOLN <> ' '
     C                   MOVEL     'B'           SHIPD
     C                   Else
     C                   MOVEL     *BLANKS       SHIPD
     C                   EndIf
     C                   ENDIF
      * GET SUBFILE FIELD NAMES
     C                   MOVEL     OISHFR        SHFR              3

     C                   Z-ADD     OIDTRQ        DTRQ
     C                   Z-ADD     OHDTCN        DTCN
     C                   MOVEL     ' '           AST
      ** USE ASSORTMENT FOR LOT CONTROL LINE CANNOT BE BOTH
     C     OILOTC        IFEQ      'Y'
     C     OILOT#        IfEq      'CustomOrdr'
     C                   MOVEL     'C'           AST
     C                   else
     C                   MOVEL     'L'           AST
     C                   EndIf
     C                   Else
      /Free
       AST = '-';
       Exec SQL
         Select 'c' into :AST from FHORDRCSTM where COORD# = :OIORD#
         Fetch first Row Only;
      /End-Free
     C                   END
      ** USE ASSORTMENT FOR STA
     C     OISTA         IFEQ      'Y'
     C                   MOVEL     'A'           AST
     C                   END
     C                   MOVEL     OISIZE        SIZE
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C     ENDIOR        TAG
     C  N52KITEM         READE     FIORDISA                               90
     C   52VITEM         READE     FIORDISA                               90
     C   90              Z-ADD     0             OIRVDT
     C                   GOTO      NXTI
      *
      * IORDAST READ
     C     IAST          TAG
     C   36IASHFR        IFNE      VSHFR
     C                   GOTO      ENDIST
     C                   ENDIF
      *
     C   40IASTAT        IFEQ      'D'
     C                   GOTO      ENDIST
     C                   ENDIF
      *
     C     IACOFL        IFEQ      'Y'
     C     VCODE         ANDEQ     2
     C                   GOTO      ENDIST
     C                   ENDIF
      *
     C     IACOFL        IFNE      'Y'
     C     VCODE         ANDEQ     3
     C                   GOTO      ENDIST
     C                   ENDIF
      *
     C     IAORD#        CHAIN     FHORDR                             92
     C   92              Eval      OHORD# = 999999
     C   92              GOTO      ENDIST
     C                   MOVEL     OHNAME        NAME
      *
     C     VSHDAT        IFGT      *ZEROS
     C                   Z-ADD     IADTRQ        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        RVODT             7 0
     C                   ENDIF
     C     VSHDAT        IFGT      *ZEROS
     C     RVODT         ANDLT     RVSDT
     C                   GOTO      ENDIST
     C                   ENDIF
      * 11/19/96 TEMP FIX
     C     IACOFL        IFEQ      'Y'
     C     IAQSHP        ANDNE     IAQORD
     C                   GOTO      ENDIST
     C                   ENDIF
      *
     C                   Z-ADD     IAQORD        QTY
     C                   ADD       QTY           TOTQTY
     C                   ADD       QTY           TOTSIZ
     C                   Z-ADD     IAQSHP        SHP
     C                   ADD       SHP           TOTSHP
      *
      *  ITEM HAS BEEN SHIPPED
      *
     C*****      IACOFL    IFEQ 'Y'
     C     IAQORD        IFLE      IAQSHP
     C                   MOVEL     '*'           SHIPD
     C                   ELSE
     C                   MOVEL     *BLANKS       SHIPD
     C                   ENDIF
      * GET SUBFILE FIELD NAMES
     C                   MOVEL     IASHFR        SHFR
     C                   Z-ADD     IADTRQ        DTRQ
     C                   MOVEL     'S'           AST
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C     ENDIST        TAG
     C     KITEM         READE     FIORASTD                               91
     C   91              Z-ADD     0             IARVDT
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C     RECNO         IFEQ      0
     C**         LKSAL     ANDEQ0
     C                   SETON                                        8014
     C                   GOTO      RSTRT
     C                   ENDIF
     C   52OLDSIZ        IFGT      *BLANKS
     C                   ADD       1             RECNO
     C                   Z-ADD     0             OHORD#
     C                   Z-ADD     0             OHDTOR
     C                   MOVEL     *ZEROS        OHCUST
     C                   MOVEL     *ZEROS        CUST
     C                   MOVEL     *BLANKS       OHPOS
     C                   MOVEL     *BLANKS       SVIA
     C                   MOVEL     *BLANKS       OIITEM
     C**                   MOVEL*BLANKS   OISIZE
     C*                    MOVEL*BLANKS   DESC
     C**                   MOVEL*BLANKS   OIUUOM
     C                   MOVEL     *BLANKS       AST
     C                   MOVEL     *BLANKS       SHFR
     C                   MOVEL     *BLANKS       LOC
     C                   MOVEL     *BLANKS       NAME
     C                   Z-ADD     TOTSIZ        QTY
     C                   Z-ADD     0             SHP
     C                   Z-ADD     0             DTRQ
     C                   Z-ADD     0             DTCN
     C                   MOVEL     *BLANKS       SHIPD
     C                   MOVEL     '** Total'    DESC1            16
     C                   MOVE      ' Size **'    DESC1
     C                   MOVE      DESC1         NAME
     C                   WRITE     RECSFL
     C                   END                                                     OLDSIZ>" "
     C                   ADD       2             RECNO
     C                   Z-ADD     0             OHORD#
     C                   Z-ADD     0             OHDTOR
     C                   MOVEL     *ZEROS        OHCUST
     C                   MOVEL     *ZEROS        CUST
     C                   MOVEL     *BLANKS       OHPOS
     C                   MOVEL     *BLANKS       SIZE
     C                   MOVEL     *BLANKS       SVIA
     C                   MOVEL     *BLANKS       OIITEM
     C                   MOVEL     *BLANKS       OISIZE
     C*                    MOVEL*BLANKS   DESC
     C                   MOVEL     *BLANKS       OIUUOM
     C                   MOVEL     *BLANKS       AST
     C                   MOVEL     *BLANKS       SHFR
     C                   MOVEL     *BLANKS       LOC
     C                   MOVEL     *BLANKS       NAME
     C                   Z-ADD     TOTQTY        QTY
     C                   Z-ADD     TOTSHP        SHP
     C                   Z-ADD     0             DTRQ
     C                   Z-ADD     0             DTCN
     C                   MOVEL     *BLANKS       SHIPD
     C                   MOVEL     '** Total'    DESC1            16
     C                   MOVE      's **    '    DESC1
     C                   MOVE      DESC1         NAME
     C                   WRITE     RECSFL
     C     EXFMTSFL      TAG
     C                   EXFMT     RECCTL
      /Free
         Code_Error = *Off;
         If Last_RC_CODE <> RC_CODE;
           reset Code_Error;
           Exec SQL
             Select '0' into :Code_Error from XATABE1
              where TBTB = 'RC' and TBC6 = :RC_CODE;
           If Code_Error;
             RC_DESC = %trim(RC_CODE) + ' invalid';
             RC_CODE = Last_RC_CODE;
            Else;
             Exec SQL
               UPDATE FMORLS
               SET olrdyc = :RC_CODE
               WHERE (OLITEM, OLSIZE) = (:VITEM,:VSIZE) ;
             Exec SQL
               select coalesce(olrdyc,'ERROR')
                     ,coalesce(TBSHRT,'Bad Code Entered')
               into :RC_CODE, :RC_DESC
               from fmorls join XATABE1 on OLRDYC = TBC6 and TBTB = 'RC'
               where (OLITEM, OLSIZE) = (:VITEM,:VSIZE) ;
             Last_RC_CODE = RC_CODE;
           EndIf;
         ENDIF;
      /End-Free
     C                   If        Code_Error
     C                   GOTO      EXFMTSFL
     C                   ENDIF
     C   KC
     COR KG              GOTO      EOJ
     C   KK              DO
     C     SFLCSRRRN     Chain     RECSFL
     C                   call      'BIR100CLO'
     C                   Parm                    OHORD#
     C                   Parm                    OISEQ#
     C                   GOTO      EXFMTSFL
     C                   ENDDO                                                    KD DO
     C   KI              DO                                                     Inventory Trans
     C                   Call      'ICR200CL'
     C                   Parm                    VITEM
     C                   Parm                    VSIZE
     C                   GOTO      EXFMTSFL
     C                   ENDDO                                                    KD DO
      ** KD CHANGE DATE DISPLAYED
     C*  KD              DO
     C*  51              Z-ADD     0             IN51              1 0
     C* N51              Z-ADD     1             IN51
     C*                  MOVEL     IN51          *IN(51)
     C*                  GOTO      DATCHG
     C*                  ENDDO                                                    KD DO
      ** KE Toggle Show Zeros
      /Free
        If *InKE;
          *In53 = not *In53;  // *In53 = Show Zero Records
        ENDIF;
      /End-free
     C   KE              GOTO      DATCHG
     C                   If        not CalledMode
     C                   GOTO      RSTRT
     C                   EndIf
      *
     C     EOJ           TAG
     C                   SETON                                        LR
      *
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC             40
     C                   ENDSR
      *
**
  F4=Show Date Wanted
 F4=Show Requested Date
Requested
  Wanted
