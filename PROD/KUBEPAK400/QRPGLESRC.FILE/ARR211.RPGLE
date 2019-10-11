      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      *  TO ENTER RETURNED CHECKS FOR NSF
      *--------------------------------------------------------------
      *  SWITCH USAGE  U8 - WILL STOP KEYING OF CHECK DATE ON SEL1
      *--------------------------------------------------------------
      *--------------------------------------------------------------
      *  CASH PAYMENT TYPES  01 - INVOICE
      *                      02 - PAYMENT (CASH/CHECK)
      *                      03 - PAYMENT (CASH ON ACCOUNT)
      *                      04 - ADJUSTMENT
      *                      05 - CREDIT MEMO
      *                      06 - NON A/R CASH
      *                      07 - LATE CHARGE
      *          VOID        08 - PAYMENT (OLDEST FIRST)     VOID
      *                      09 - DISCOUNT
      *                      10 - PAYMENT (CREDIT CARD)
      *                      11 - DOWN PAYMENT
      *                      12 - BOUNCED CHECK
      *                      13 - DECLINED CREDIT CARD
      *                      14 - BOUNCED CHECK CHARGE
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ARR211
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- ENTER CASH NSF RECORDS
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
EFD01 *  8/08/02 EFD CHAIN TO ARHIST TO AVOID DUP RC RECORDS.
      *
     FFAROPNDD  IF   E           K DISK
     F                                     RENAME(RAROPN:RAROP1)
     FFARHIST   IF   E           K DISK
     FFAROPN    UF A E           K DISK
     FFMTRAN    UF A E           K DISK
     FFMCUST    IF   E           K DISK
     FFMBANK    IF   E           K DISK
     FFARCTL    IF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFARHST    UF   E           K DISK
     FARR211FM  CF   E             WORKSTN
     F                                     SFILE(S10SFL:RR1)
      *
     D N               S             31    DIM(5)                               NAMES ARRAY
     D TP              S              3    DIM(15) CTDATA PERRCD(1)             PRINT LINE $
     D CM              S             69    DIM(16) CTDATA PERRCD(1)             COMMAND KEY'S
     D ER              S             28    DIM(9) CTDATA PERRCD(1)              ERROR 28 ARRAY
     D PH              S             17    DIM(6) CTDATA PERRCD(1)              SELECTION ARRAY
     D WN              S             55    DIM(24) CTDATA PERRCD(1)             WARNING ARRAY
     D S1              S              2    DIM(10) CTDATA PERRCD(1)             SUFF ARRAY 01
     D S2              S              2    DIM(10) CTDATA PERRCD(1)             SUFF ARRAY 02
     D*             AHRVDT                          ARRVDT
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
      * SETUP ZONED NUMBERS FOR PASSING
     D                 DS
     D  ZON060                 1      6  0
     D                UDS
     D  LCO                    1      2  0
     D  LCUST                  3      8  0
     D  LHIST                  9      9
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *
     IRARHIS
     I              AHSTAT                      ARSTAT
     I              AHCUST                      ARCUST
     I              AHINV#                      ARINV#
     I              AHSUFF                      ARSUFF
     I              AHSEQ#                      ARSEQ#
     I              AHCTYP                      ARCTYP
     I              AHSLM1                      ARSLM1
     I              AHCOM1                      ARCOM1
     I              AHSLM2                      ARSLM2
     I              AHCOM2                      ARCOM2
     I              AHTERR                      ARTERR
     I              AHCOMP                      ARCOMP
     I              AHTTYP                      ARTTYP
     I              AHTDAT                      ARTDAT
     I              AHDUDT                      ARDUDT
     I              AH$AMT                      AR$AMT
     I              AHDISC                      ARDISC
     I              AHDTAK                      ARDTAK
     I              AHADJ$                      ARADJ$
     I              AHPAID                      ARPAID
     I              AHDUE$                      ARDUE$
     I              AHCHEK                      ARCHEK
     I*             AHCKDT                          ARCKDT
     I              AHGLAC                      ARGLAC
     I              AHDESC                      ARDESC
     I              AHDTLA                      ARDTLA
     I              AHTIME                      ARTIME
     I              AHUSER                      ARUSER
     I*             AHDCDT                          ARDCDT
     I              AHORD#                      ARHOR#
     I              AHLOOK                      ARLOOK
     I              AHSHCU                      ARSHCU
     I              AHSACU                      ARSACU
     I              AHBLCU                      ARBLCU
     I              AHPONO                      ARPONO
      *
     C     K0AROP        KLIST                                                  BILL TO ONLY
     C                   KFLD                    CUST
     C                   KFLD                    INV#
     C                   KFLD                    SUFF
     C                   KFLD                    SEQ#
     C     K1AROP        KLIST                                                  BILL TO ONLY
     C                   KFLD                    CUST
     C                   KFLD                    INV#
     C                   KFLD                    SUFF
      *
     C                   Z-ADD     LCO           ARCOMP
     C                   Z-ADD     LCO           LCOXX            02 0
     C                   MOVEL     CM(16)        CM7801
     C     LCO           CHAIN     FMAPER                             50
     C     *IN50         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   GOTO      EOJ
     C                   END
     C                   Z-ADD     ACFSST        TDATE            06 0          START FIS YEAR DATE
     C                   CALL      '@DT@A1'
     C                   PARM                    TDATE
     C                   PARM                    TDATPY           07 0
     C                   PARM      'N'           RETC
     C     ACMPCN        IFEQ      'M'
     C                   Z-ADD     ACEN12        TDATE
     C                   ELSE
     C                   Z-ADD     ACEN13        TDATE
     C                   END
     C                   CALL      '@DT@A1'
     C                   PARM                    TDATE
     C                   PARM                    TDATEY           07 0
     C                   PARM      'N'           RETC
      *
     C     RELOD         TAG
      *
     C     LCO           CHAIN     FARCTL                             50
     C     *IN50         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   GOTO      EOJ
     C                   END
     C     ACRCKC        IFEQ      *ZEROS
     C                   MOVEA     '01'          *IN(01)
     C                   ELSE
     C                   MOVEA     '10'          *IN(01)
     C                   END
      *
     C     LCO           CHAIN     FGLDF                              50
     C     *IN50         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   GOTO      EOJ
     C                   END
      *
     C                   EXSR      GETDAT                                       GET ENTRY DATE
     C     RETC          IFEQ      '3'
     C                   GOTO      EOJ
     C                   END
      *
     C                   MOVE      ACBANK        BANK                           GET ENTRY BANK #
     C     BANK          CHAIN     FMBANK                             50
     C     *IN50         IFEQ      '1'
     C                   MOVEL     'RNF'         BANKDS
     C                   ELSE
     C                   MOVE      BADESC        BANKDS
     C                   END
     C                   SETON                                        19
     C                   Z-ADD     *ZEROS        VALAST
     C                   Z-ADD     *ZEROS        VSLAST
      *
      * START A NEW RECEIPT
      *
     C     RSTRTA        TAG
     C                   MOVEA     '00000000'    *IN(10)
     C                   MOVEA     '000000'      *IN(18)
     C                   Z-ADD     *ZEROS        VACUST
     C                   MOVE      *BLANKS       LOK1             15
     C                   MOVE      *BLANKS       LOK2             15
     C                   MOVE      BANK          BANKXX
     C                   MOVE      '1'           *IN17
     C                   EXSR      CLRR1                                        CLEAR SELECTION SCRN
      *
      * CONTINUE WITH A RECEIPT
      *
     C     NXTA          TAG
      *
     C                   WRITE     SCRNA                                        GET CUSTOMER # AND
     C                   READ      SCRNA                                  90     A/R LINE TYPE
     C                   MOVEA     '00000000'    *IN(10)
     C                   MOVEA     '000000'      *IN(18)
     C                   SETOFF                                       99
      *
     C     *INKC         IFEQ      '1'                                          END OF JOB
     C     *INKG         OREQ      '1'
     C                   GOTO      EOJ
     C                   END
      *
      *
     C     *INKM         IFEQ      '1'                                          CHANGE ENTRY DATE
     C                   EXSR      GETDAT
     C     RETC          IFEQ      '3'
     C                   GOTO      EOJ
     C                   END
     C                   GOTO      RSTRTA
     C                   END
      *
      *
     C     VACUST        IFEQ      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   MOVEL     VALPHA        CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   Z-ADD     CMCUST        VACUST
     C                   EXSR      LODBT
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TELEPHONE # SEARCH
      *
     C     VACUST        IFEQ      *ZEROS
     C     VALPHA        ANDEQ     *BLANKS
     C     VATELE        ANDGT     *BLANKS
     C                   MOVEL     VATELE        CMPHON           10 0
     C                   CALL      'LKTELE'
     C                   PARM                    CMPHON
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       VATELE
     C                   Z-ADD     CMCUST        VACUST
     C                   EXSR      LODBT
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACUST        IFEQ      *ZEROS
     C     VALPHA        ANDEQ     *BLANKS
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACUST        IFGT      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACUST        CHAIN     FMCUST                             31
     C   31              SETON                                        1114
     C   31              GOTO      NXTA
     C                   EXSR      LODBT
     C                   MOVEL     CMLOOK        LOK1
      *
      *
     C** --- START WORKING PORTION OF THE PROGRAM ------------------------------
     C                   MOVEA     '00000000'    *IN(10)                        COMMON TO ALL
      *
     C                   Z-ADD     VACUST        CUST              6 0
     C                   MOVEL     LOK1          LOOK             15
     C                   MOVE      'N'           BTST             01            BT/ST KEY CONTROL
      *
      *
     C                   MOVEA     '1100'        *IN(01)
     C                   MOVE      'Y=Rev'       HD05
     C                   MOVE      PH(01)        P17A
     C                   MOVE      PH(02)        P17B
     C                   EXSR      SELC1
     C     *IN99         IFEQ      '1'
     C                   GOTO      RSTRTA
     C                   END
     C                   Z-ADD     PAID          PAY01            09 2          TOTAL TO PAY
     C                   Z-ADD     *ZEROS        PAY02            09 2          PERM APPLIED
     C                   Z-ADD     *ZEROS        PAY03            09 2          TEMP APPLIED
     C                   GOTO      SELCOK
      *
      *
     C** --- COMMON TO ALL TYPES -----------------------------------------------
     C     SELCOK        TAG
      *
      *
     C                   Z-ADD     VACUST        VALAST
     C                   Z-ADD     VSCUST        VSLAST
      *                                              11 = PAYMENT KEYABLE
      *                                              12 = DISPLAY 2 CMD'S
      *                                              13 = DISPLAY ER28 FIELD
     C                   MOVEL     CM(01)        CM6901
     C     DTYORN        IFEQ      'Y'
     C                   MOVEL     CM(02)        CM6902
     C                   ELSE
     C                   MOVEL     CM(03)        CM6902
     C                   END
     C                   MOVEA     '10'          *IN(12)
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
      *
     C     SELC1T        TAG
     C                   EXSR      OPNBLD                                       BUILD SUBFILE
     C                   EXSR      HSTBLD                                       BUILD SUBFILE
     C                   EXSR      BLKBLD                                       BUILD SUBFILE
      *
     C     SELC1X        TAG
     C                   EXSR      CALCOP
     C                   EXFMT     S10CTL                                       DISPLAY SCREEN
     C*                    MOVE *BLANKS   ER28
     C*                    MOVE '0'       *IN13
      *
     C     *INKD         IFEQ      '1'                                          OPTIONS WINDOW
     C     *INU4         ANDEQ     '1'
     C                   EXSR      OP010
     C                   GOTO      SELC1T
     C                   END
      *
     C     *INKH         IFEQ      '1'
     C                   EXSR      SELC1
     C     *IN99         IFEQ      '1'
     C                   GOTO      RSTRTA
     C                   END
     C                   GOTO      SELC1T
     C                   END
      *
     C     *INKE         IFEQ      '1'
     C                   EXSR      COLCOM
     C                   GOTO      SELC1X
     C                   END
      *
     C     *INKI         IFEQ      '1'                                          SELECT NONE
     C                   EXSR      S10NON                                       CLEAR SELECTIONS
     C                   END
      *
     C     *INKJ         IFEQ      '1'                                          CHG DISP Y OR N
     C     DTYORN        IFEQ      'Y'
     C                   MOVEL     CM(01)        CM6901
     C                   MOVEL     CM(03)        CM6902
     C                   MOVE      'N'           DTYORN
     C                   ELSE
     C                   MOVEL     CM(01)        CM6901
     C                   MOVEL     CM(02)        CM6902
     C                   MOVE      'Y'           DTYORN
     C                   END
     C                   GOTO      SELC1T
     C                   END
      *
     C     *INKF         IFEQ      '1'                                          RESTART
     C                   EXSR      CALCOP
     C     PAY09         IFEQ      *ZEROS
     C                   GOTO      RSTRTA
     C                   END
     C                   END
     C     *INKF         IFEQ      '1'                                          RESTART
     C                   GOTO      NXTA
     C*                    ELSE
     C*                    GOTO RSTRTA
     C                   END
      *
     C                   EXSR      S10CHK                                       CHECK DATA/ERRORS
      *
     C                   EXSR      CALCOP
     C     PAY01         IFNE      PAY09
     C                   END
      *
     C     *INKL         IFEQ      '1'                                          BAL ON ACCT
     C     PAY09         ANDNE     *ZEROS
     C*
     C                   Z-ADD     02            OLTTYP           02 0
     C                   Z-ADD     03            SLTTYP                         PAYMENT TYPE (ONACCT
     C                   EXSR      S10PUT                                       UPDATE PAID LINES
     C                   EXSR      S11PUT                                       OUTPUT SERVICE CHARG
     C                   EXSR      BALPUT                                       ADD ONACCOUNT LINE
     C                   GOTO      RSTRTA
     C                   END
      *
     C     *IN08         IFEQ      '0'                                          ERRORS DO NOT
     C                   GOTO      SELC1X                                       CONTINUE
     C                   END
      *
     C     *INKA         IFEQ      '1'
     C     PAY03         ANDEQ     *ZEROS
     C                   Z-ADD     13            CTW              03 0
     C                   EXSR      WARN01
     C                   GOTO      SELC1X
     C                   END
      *
     C     *INKA         IFEQ      '1'                                          OK APPLY
     C                   Z-ADD     02            SLTTYP           02 0          PAYMENT TYPE (CHECK)
     C                   EXSR      S10PUT                                       UPDATE PAID LINES
     C                   EXSR      S11PUT                                       OUTPUT SERVICE CHARG
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
     C                   EXSR      CALCOP
     C                   EXSR      CALDAT
     C*          PAY09     IFEQ *ZEROS
     C                   GOTO      RSTRTA                                       NEW RECEIPT
     C*                    ELSE
     C*                    GOTO NXTA                       NEW CUSTOMER
     C*                    END
     C                   END
      *
      *
     C                   GOTO      SELC1X
      *
      *
     C** -----------------------------------------------------------------------
      *
      *
     C     EOJ           TAG
     C                   SETON                                        LR
      *
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVE      TMWRK         EDAT
     C                   MOVE      'N'           DTYORN           01            DETAIL Y OR N
     C                   ENDSR
      **
      **
     CSR   GETDAT        BEGSR                                                  GET ENTRY DATE
     C                   MOVEA     '0000'        *IN(10)
     C                   MOVE      '0'           *IN98
     C                   MOVE      *BLANKS       RETC
     C     GETDT1        TAG
     C                   WRITE     SCRNDT
     C                   READ      SCRNDT                                 50
     C                   MOVEA     '0000'        *IN(10)
      *
     C     *INKB         IFEQ      '1'                                          CHG CTL FILE
     C                   CALL      'ARR000'
     C                   GOTO      RELOD
     C                   END
      **
     C     *INKC         IFEQ      '1'
     C     *INKG         OREQ      '1'
     C                   MOVE      '3'           RETC
     C                   GOTO      GETDT9
     C                   END
      **
     C                   Z-ADD     EDAT          TDATE            06 0          SETUP TRANS DATE
     C                   CALL      '@DT@A1'                                     NEED SCREEN INPUT
     C                   PARM                    TDATE
     C                   PARM                    TDAT             07 0
     C                   PARM      'N'           RETC             01
     C     RETC          IFEQ      'Y'
     C                   SETON                                        1011
     C                   GOTO      GETDT1
     C                   END
     C     TDAT          IFLT      TDATPY
     C                   SETON                                        1012
     C                   GOTO      GETDT1
     C                   END
     C     *IN98         IFEQ      '1'
     C                   GOTO      GETDT9
     C                   END
     C     TDAT          IFGT      TDATEY
     C                   Z-ADD     TDAT          TDATHD           07 0
     C                   SETON                                        1013
     C                   SETON                                        98
     C                   GOTO      GETDT1
     C                   END
     C     GETDT9        TAG
     C                   MOVEA     '0000'        *IN(10)
     C                   MOVE      '0'           *IN98
     CSR                 ENDSR
      **
      **
     CSR   SELC1         BEGSR
     C                   MOVE      'Y'           CSAJ             01
     C                   MOVE      '0'           *IN99
     C                   MOVEA     '0000000'     *IN(11)
     C                   MOVEA     '000000'      *IN(18)
     C                   MOVE      '1'           *IN19
     C     SELC1A        TAG
     C                   MOVE      'N'           SELCK1
     C*          '00000000'IFEQ *IN,11
     C*          '000000'  ANDEQ*IN,18
     C*                    MOVE '1'       *IN19
     C*                    END
      *
     C     ACRCKC        IFEQ      *ZEROS
     C                   MOVE      '1'           *IN12                          NON DISP OVERRIDE
     C                   END
     C     *INU8         IFEQ      '1'                                          STOP CHECK DATE
     C                   MOVE      '1'           *IN17
     C                   END
     C                   WRITE     SEL010
     C                   READ      SEL010                                 50
     C                   MOVEA     '0000000'     *IN(11)
     C                   MOVEA     '0000000'     *IN(18)
     C                   MOVE      '0'           *IN99
      *
     C     *INKF         IFEQ      '1'
     C                   MOVE      '1'           *IN99
     C                   GOTO      SELC1E
     C                   END
      *
     C                   MOVEL     BANK          TEST01           01
     C     TEST01        IFEQ      '?'                                          SEARCH BANK
     C     TEST01        OREQ      '/'
     C                   CALL      'LKBANK'
     C                   PARM                    BANKXX            3
     C                   PARM                    BANKDS           30
     C                   MOVE      BANKXX        BANK
     C                   MOVE      'Y'           SELCK1           01
     C                   GOTO      SELC1A
     C                   END
      *
     C     BANK          CHAIN     FMBANK                             50
     C     *IN50         IFEQ      '1'
     C                   SETON                                        1611
     C                   GOTO      SELC1A
     C                   ELSE
     C                   MOVE      BADESC        BANKDS
     C     SELCK1        IFEQ      'Y'
     C                   MOVE      '1'           *IN12
     C                   GOTO      SELC1A
     C                   END
     C                   END
      *
     C*          *INU8     IFEQ '0'
     C*          CHEK      IFEQ *BLANKS
     C*                    SETON                     1218
     C*                    GOTO SELC1A
     C*                    END
      *
     C*                    CALL '@DT@A1'                   TEST CHECK DATE
     C*                    PARM           CKDT
     C*                    PARM           CKDT07 070
     C*                    PARM 'N'       RETC   01
     C*          RETC      IFEQ 'Y'
     C*                    MOVE '1'       *IN14
     C*                    GOTO SELC1A
     C*                    END
     C*                    Z-ADDCKDT07    CKDTXX 070
     C*                    END
      *
     C     PAID          IFLE      *ZEROS
     C                   SETON                                        15
     C                   GOTO      SELC1A
     C                   END
      *
      *
     C     CHEK          IFEQ      *BLANKS
     C                   SETON                                        18
     C                   GOTO      SELC1A
     C                   END
      *
      *
     C     ONLY          IFNE      'Y'
     C     ONLY          ANDNE     'N'
     C     ONLY          ANDNE     *BLANKS
     C                   SETON                                        24
     C                   GOTO      SELC1A
     C                   END
      *
      *
     C*          DLFM      IFNE *ZEROS
     C*          DLTO      ANDEQ*ZEROS
     C*                    Z-ADDDLFM      DLTO
     C*                    END
     C     DTFM          IFNE      *ZEROS
     C     DTTO          ANDEQ     *ZEROS
     C                   Z-ADD     DTFM          DTTO
     C                   END
      *
      *
     C     DTFM          IFNE      *ZEROS
     C                   CALL      '@DT@A1'
     C                   PARM                    DTFM
     C                   PARM                    DTFM07           07 0
     C                   PARM      'N'           RETC             01
     C     RETC          IFEQ      'Y'
     C                   MOVE      '1'           *IN20
     C                   GOTO      SELC1A
     C                   END
     C                   END
      *
     C     DTTO          IFNE      *ZEROS
     C                   CALL      '@DT@A1'
     C                   PARM                    DTTO
     C                   PARM                    DTTO07           07 0
     C                   PARM      'N'           RETC             01
     C     RETC          IFEQ      'Y'
     C                   MOVE      '1'           *IN21
     C                   GOTO      SELC1A
     C                   END
     C                   END
      *
     C     DTFM          IFNE      *ZEROS
     C     DTTO          ANDNE     *ZEROS
     C     DTFM07        ANDGT     DTTO07
     C                   MOVE      '1'           *IN20
     C                   GOTO      SELC1A
     C                   END
      *
     C     DLFM          IFNE      *ZEROS
     C     DLTO          ANDNE     *ZEROS
     C     DLFM          ANDGT     DLTO
     C                   MOVE      '1'           *IN22
     C                   GOTO      SELC1A
     C                   END
      *
      *
     CSR   SELC1E        ENDSR
      **
      **
      *
     CSR   OPNBLD        BEGSR                                                  BUILD SUBFILE
      *                                                    *IN09 - RI SUFF
     C                   MOVE      '1'           *IN80
     C                   WRITE     S10CTL
     C                   MOVE      '0'           *IN80
      *
     C                   Z-ADD     *ZEROS        RR1              03 0
      *
     C     CUST          SETLL     FAROPNDD
      *
     C     *IN50         DOUEQ     '1'
     C     CUST          READE     FAROPNDD                               50
     C     *IN50         IFEQ      '1'
     C                   Z-ADD     RR1           LLIN             03 0
     C                   LEAVE
     C                   END
      *
     C                   Z-ADD     ARTTYP        CT               03 0
     C                   Z-ADD     ARTTYP        TTYP
     C     CT            IFGE      01
     C     CT            ANDLE     15
     C                   MOVEL     TP(CT)        TYPE
     C                   ELSE
     C                   MOVE      *BLANKS       TYPE
     C                   END
      *
     C                   EXSR      SET11                                        PAYMENTS ONLY
     C     *IN11         IFEQ      '0'
     C                   ITER
     C                   END
      *
     C     AR$AMT        MULT      -1.00         AR$AMT
      *
      * ------------------------------------------------------------------------
     C     ONLY          IFEQ      'Y'                                          TEST CHECK NUMB
     C     CHEK          ANDNE     ARCHEK
     C     ARCHEK        ANDNE     'Multiple'
     C                   ITER
     C                   END
     C     DTFM          IFNE      *ZEROS                                       TEST START DATE
     C     ARTDAT        ANDLT     DTFM07
     C                   ITER
     C                   END
     C     DTTO          IFNE      *ZEROS                                       TEST END DATE
     C     ARTDAT        ANDGT     DTTO07
     C                   ITER
     C                   END
     C     DLFM          IFNE      *ZEROS                                       TEST START DOLLARS
     C     AR$AMT        ANDLT     DLFM
     C                   ITER
     C                   END
     C     DLTO          IFNE      *ZEROS                                       TEST END DOLLARS
     C     AR$AMT        ANDGT     DLTO
     C                   ITER
     C                   END
      * ------------------------------------------------------------------------
      *
     C                   ADD       1             RR1
     C                   MOVE      *BLANKS       CODE
     C*                    Z-ADDARDUDT    DUDT07
     C                   Z-ADD     ARTDAT        DUDT07                         TRAN/PAID DATE
     C                   CALL      '@DTCNV'
     C                   PARM                    DUDT07            7 0          DATE CYYMMDD
     C                   PARM                    DUDT              6 0          DATE MDY
     C                   PARM      'N'           ##ERR             1            ERROR IF = Y
     C                   Z-ADD     DUDT          DATE
     C                   Z-ADD     DUDT07        DDAT
     C                   Z-ADD     *ZEROS        PAY$
     C*                    Z-ADD*ZEROS    PDIS
     C                   Z-ADD     ARINV#        INV#
     C                   Z-ADD     ARSEQ#        SEQ#
     C                   MOVE      ARSUFF        SUFF
     C                   MOVE      AR$AMT        DAMT
     C                   MOVE      ARCHEK        CKNM
     C                   MOVE      'O'           OORH
     C                   MOVE      *BLANKS       CM10
     C**
     C                   MOVE      '0'           *IN09
      *
     C                   WRITE     S10SFL
     C                   ENDDO
     CSR                 ENDSR
      *
      *
     CSR   HSTBLD        BEGSR                                                  BUILD SUBFILE
      *                                                    *IN09 - RI SUFF
      *
     C     CUST          SETLL     FARHIST
      *
     C     *IN50         DOUEQ     '1'
     C     CUST          READE     FARHIST                                50
     C     *IN50         IFEQ      '1'
     C                   Z-ADD     RR1           LLIN             03 0
     C                   LEAVE
     C                   END
      *
     C                   Z-ADD     ARTTYP        CT               03 0
     C                   Z-ADD     ARTTYP        TTYP
     C     CT            IFGE      01
     C     CT            ANDLE     15
     C                   MOVEL     TP(CT)        TYPE
     C                   ELSE
     C                   MOVE      *BLANKS       TYPE
     C                   END
      *
     C                   EXSR      SET11                                        PAYMENTS ONLY
     C     *IN11         IFEQ      '0'
     C                   ITER
     C                   END
      *
     C     AR$AMT        MULT      -1.00         AR$AMT
      *
      * ------------------------------------------------------------------------
     C     ONLY          IFEQ      'Y'                                          TEST CHECK NUMB
     C     CHEK          ANDNE     ARCHEK
     C     ARCHEK        ANDNE     'Multiple'
     C                   ITER
     C                   END
     C     DTFM          IFNE      *ZEROS                                       TEST START DATE
     C     ARTDAT        ANDLT     DTFM07
     C                   ITER
     C                   END
     C     DTTO          IFNE      *ZEROS                                       TEST END DATE
     C     ARTDAT        ANDGT     DTTO07
     C                   ITER
     C                   END
     C     DLFM          IFNE      *ZEROS                                       TEST START DOLLARS
     C     AR$AMT        ANDLT     DLFM
     C                   ITER
     C                   END
     C     DLTO          IFNE      *ZEROS                                       TEST END DOLLARS
     C     AR$AMT        ANDGT     DLTO
     C                   ITER
     C                   END
      * ------------------------------------------------------------------------
      *
     C                   ADD       1             RR1
     C                   MOVE      *BLANKS       CODE
     C*                    Z-ADDARDUDT    DUDT07
     C                   Z-ADD     ARTDAT        DUDT07                         TRAN/PAID DATE
     C                   CALL      '@DTCNV'
     C                   PARM                    DUDT07            7 0          DATE CYYMMDD
     C                   PARM                    DUDT              6 0          DATE MDY
     C                   PARM      'N'           ##ERR             1            ERROR IF = Y
     C                   Z-ADD     DUDT          DATE
     C                   Z-ADD     DUDT07        DDAT
     C                   Z-ADD     *ZEROS        PAY$
     C*                    Z-ADD*ZEROS    PDIS
     C                   Z-ADD     ARINV#        INV#
     C                   Z-ADD     ARSEQ#        SEQ#
     C                   MOVE      ARSUFF        SUFF
     C                   MOVE      AR$AMT        DAMT
     C                   MOVE      ARCHEK        CKNM
     C                   MOVE      'H'           OORH
     C                   MOVE      *BLANKS       CM10
     C**
     C                   MOVE      '0'           *IN09
      *
     C                   WRITE     S10SFL
     C                   ENDDO
     CSR                 ENDSR
      *
      *
     CSR   BLKBLD        BEGSR                                                  BUILD SUBFILE
      *
     C     RR1           IFEQ      *ZEROS                                       NO RECORDS FOUND
     C                   MOVEL     ER(08)        ER28
     C                   MOVE      '1'           *IN13
     C                   ADD       1             RR1
     C                   MOVE      *BLANKS       CODE
     C                   Z-ADD     *ZEROS        PAY$
     C                   Z-ADD     *ZEROS        INV#
     C                   MOVE      *BLANKS       SUFF
     C                   MOVE      *BLANKS       TYPE
     C                   Z-ADD     0             DATE
     C                   Z-ADD     *ZEROS        DAMT
     C                   MOVE      *BLANKS       CKNM
     C                   MOVE      *BLANKS       OORH
     C                   MOVE      *BLANKS       CKNM
     C                   MOVEL     'No AR Da'    CM10
     C                   MOVE      'ta'          CM10
     C                   WRITE     S10SFL
     C                   END
      *
     CSR                 ENDSR
      *
      *
      *
      *
     CSR   S10CHK        BEGSR
     C                   Z-ADD     *ZEROS        PAY03                          CLEAR TEMP PAYMENTS
     C                   EXSR      CALCOP
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
     C                   Z-ADD     *ZEROS        RR1
     C                   Z-ADD     *ZEROS        S10CT            03 0          LINE COUNTER
      *
     C     *IN50         DOUEQ     '1'
     C                   ADD       1             RR1
     C     RR1           CHAIN     S10SFL                             50
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
      *
     C                   Z-ADD     *ZEROS        LDUE             08 2          ADD DISC AND BAL TO
      *                                                    GET THE LARGEST $ AMT
     C*-------------------------------------------------------------------------
      * CODE *NE Y OR *BLANKS
     C     CODE          IFNE      'Y'
     C     CODE          ANDNE     *BLANKS
     C                   MOVE      'Y'           W25              01
     C                   END
     C*          PDIS      IFGT DISC
     C                   MOVE      ' '           W17              01
     C*                    END
     C*-------------------------------------------------------------------------
      * CODE = Y
L1   C     CODE          IFEQ      'Y'                                          PAY THE LINE
     C*-------------------------------------------------------------------------
      *  LINE > 0.00                                       GET THE LARGEST $ AMT
L3   C     DAMT          IFGT      *ZEROS                                       IF LINE > 0 = INV
L3   C     PAY$          ANDGT     *ZEROS                                       PAID MUST BE > LINE
      *                                                    GET THE LARGEST $ AMT
L4   C     PAY$          IFGT      DAMT
     C                   Z-ADD     DAMT          PAY$
L4   C                   END
      *                                                    GET THE LARGEST $ AMT
     C                   EXSR      TSTPY1                                       TEST PAYMENT
     C                   EXSR      SET11
     C                   UPDATE    S10SFL
     C                   ADD       PAY$          PAY03
     C                   EXSR      CALCOP
     C                   MOVE      '1'           *IN08
     C                   MOVEL     ER(09)        OP15
     C                   ITER                                                   LINE DONE
L3   C                   END
     C*-------------------------------------------------------------------------
      *  LINE < 0.00
      *                                                    GET THE LARGEST $ AMT
L3   C     DAMT          IFLT      *ZEROS                                       IF LINE < 0 = CRD
L3   C     PAY$          ANDLT     *ZEROS                                       PAID MUST BE > LINE
      *                                                    GET THE LARGEST $ AMT
L4   C     PAY$          IFLT      DAMT
     C                   Z-ADD     DAMT          PAY$
     C                   EXSR      SET11
     C                   UPDATE    S10SFL
     C                   ADD       PAY$          PAY03
     C                   EXSR      CALCOP
     C                   MOVE      '1'           *IN08
     C                   MOVEL     ER(09)        OP15
     C                   ITER                                                   LINE DONE
L4   C                   END
      *
L3   C                   END
      *
     C*-------------------------------------------------------------------------
      *  PAY$=0.00
L2   C     PAY$          IFEQ      *ZEROS
     C*
     C                   Z-ADD     DAMT          PAY$
     C*
     C                   EXSR      TSTPY1                                       TEST PAYMENT
     C                   EXSR      SET11
     C                   UPDATE    S10SFL
     C                   ADD       PAY$          PAY03
     C                   EXSR      CALCOP
     C*
     C                   MOVE      '1'           *IN08
     C                   MOVEL     ER(09)        OP15
     C                   ITER                                                   LINE DONE
L3   C                   END
     C*
     C*-------------------------------------------------------------------------
L2   C                   END
     C*-------------------------------------------------------------------------
      **
      **
     C                   EXSR      SET11
     C                   UPDATE    S10SFL
     C*                    MOVE '1'       *IN08
     C*                    MOVELER,09     OP15
     C*                    ITER
L1   C*                    END
     C*-------------------------------------------------------------------------
      **
     C     PAY$          IFNE      *ZEROS
     C                   MOVE      'Y'           W15              01
     C                   MOVE      '1'           *IN08
     C                   MOVEL     ER(09)        OP15
     C                   END
      **
     C                   ENDDO
      **
     C*          W10       IFEQ 'Y'
     C*                    Z-ADD01        CTW    020
     C*                    EXSR WARN01
     C*                    MOVE 'N'       W10
     C*                    MOVE '0'       *IN08
     C*                    END
     C     W15           IFEQ      'Y'
     C                   Z-ADD     04            CTW
     C                   EXSR      WARN01
     C                   MOVE      'N'           W15
     C                   MOVE      '0'           *IN08
     C                   END
     C*          W16       IFEQ 'Y'
     C*                    Z-ADD19        CTW
     C*                    EXSR WARN01
     C*                    MOVE 'N'       W16
     C*                    MOVE '0'       *IN08
     C*                    END
     C     W17           IFEQ      'Y'
     C                   Z-ADD     22            CTW
     C                   EXSR      WARN01
     C                   MOVE      'N'           W17
     C                   MOVE      '0'           *IN08
     C                   END
     C     W20           IFEQ      'Y'
     C                   Z-ADD     07            CTW
     C                   EXSR      WARN01
     C                   MOVE      'N'           W20
     C                   MOVE      '0'           *IN08
     C                   END
     C     W25           IFEQ      'Y'
     C                   Z-ADD     10            CTW
     C                   EXSR      WARN01
     C                   MOVE      'N'           W25
     C                   MOVE      'Y'           W25ER            01
     C                   MOVE      '0'           *IN08
     C                   END
      **
     CSR                 ENDSR
      *
      *
     CSR   S10PUT        BEGSR
     C                   Z-ADD     *ZEROS        RR1
WJB  C                   Z-ADD     *ZEROS        FRSINV            6 0
      *
     C     *IN50         DOUEQ     '1'
     C                   ADD       1             RR1
     C     RR1           CHAIN     S10SFL                             50
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
      **
     C     PAY$          IFEQ      *ZEROS
     C                   ITER
     C                   END
WJB  C     FRSINV        IFEQ      *ZEROS
WJB  C                   Z-ADD     INV#          FRSINV            6 0
WJB  C                   END
      ** --------------------------------------------------------------------
      ** BOUNCED CHECK LINE - 1 PER INVOICE
     C                   Z-ADD     01            CT
     C     S10PT1        TAG
     C*          K0AROP    KLIST                           BILL TO ONLY
     C*                    KFLD           CUST
     C*                    KFLD           INV#
     C*                    KFLD           SUFF
     C*                    KFLD           SEQ#             INVOICE KEY
     C*                    MOVE 'RC'      SUFF             SETUP DEAD BEAT
     C                   MOVE      S1(CT)        SUFF                           SETUP DEAD BEAT
     C                   Z-ADD     *ZEROS        SEQ#                           INVOICE KEY
     C**
     C                   EXSR      GETL                                         GET LAST SEQ #
     C**
     C     K0AROP        CHAIN     FAROPN                             52
EFD01C   52K0AROP        CHAIN     FARHIST                            52
     C**
     C     *IN52         IFEQ      '0'                                          OLD RECORD
     C     CT            ANDLT     10
     C                   ADD       1             CT
     C                   GOTO      S10PT1
     C                   END
     C**
     C     *IN52         IFEQ      '1'                                          NEW RECORD
     C                   EXSR      CLR1                                         CLEAR COMMON
     C*          LAST01    ADD  1         NEXT   030
     C                   Z-ADD     CUST          ARCUST
     C                   Z-ADD     INV#          ARINV#
     C                   Z-ADD     SEQ#          ARSEQ#
     C                   MOVE      SUFF          ARSUFF
     C                   Z-SUB     *ZEROS        ARDTAK
     C                   Z-ADD     PAY$          AR$AMT
     C                   Z-ADD     PAY$          ARDUE$
     C                   MOVEL     CHEK          ARCHEK
WJB  C                   MOVE      ' '           ARPRST                         RESET TO PRINT
     C                   END
     C**
     C     *IN52         IFEQ      '0'                                          OLD RECORD
     C                   ADD       PAY$          AR$AMT
     C                   ADD       PAY$          ARDUE$
     C                   MOVE      *BLANKS       ARCHEK
     C                   MOVEL     'Multiple'    ARCHEK
     C                   END
     C**
     C                   Z-ADD     12            ARTTYP                         COMMON INFO
     C                   Z-ADD     TDAT          ARTDAT
     C                   Z-ADD     DDAT          ARDUDT
     C*                    Z-ADDCKDTXX    ARCKDT
     C                   MOVE      *BLANKS       ARDESC
     C                   Z-ADD     GDARRC        ARGLAC
     C**
     C     *IN52         IFEQ      '1'
     C                   WRITE     RAROPN                                       OUTPUT NEW AR REC
     C                   ELSE
     C                   UPDATE    RAROPN                                       UPDATE OLD AR REC
     C                   END
     C**
     C                   EXSR      PUTTRN                                       OUTPUT NEW TRAN REC
      **
     C                   ADD       PAY$          PAY02                          ADD TO PERM #
     C                   SUB       PAY$          PAY03                          SUB FROM TEMP
      ** --------------------------------------------------------------------
      **
     C*          CODE      IFNE *BLANKS
     C*          PAY$      ORNE *ZEROS
     C                   MOVE      *BLANKS       CODE
     C                   Z-ADD     *ZEROS        PAY$
     C                   EXSR      SET11
     C                   UPDATE    S10SFL                                       UPDATE SUBFILE
     C*                    END
      **
     C                   ENDDO
      *
     CSR                 ENDSR
      *
      *
     CSR   S11PUT        BEGSR
      *
     C     ACRCKC        IFEQ      *ZEROS
     C                   GOTO      S11END                                       NO SERVICE CHARGE
     C                   END
      *
      ** --------------------------------------------------------------------
      ** SERVICE CHARGE - 1 PER BOUNCED CHECK
     C                   Z-ADD     01            CT
     C     S11PT1        TAG
     C*          K0AROP    KLIST                           BILL TO ONLY
     C*                    KFLD           CUST
     C*                    KFLD           INV#
     C*                    KFLD           SUFF             SETUP DEAD BEAT
     C*                    KFLD           SEQ#             INVOICE KEY
     C                   Z-ADD     EDAT          INV#
WJB  C                   Z-ADD     FRSINV        INV#                           USE FIRST INVOICE #
     C*                    MOVE 'CC'      SUFF             SETUP DEAD BEAT
     C                   MOVE      S2(CT)        SUFF                           SETUP DEAD BEAT
     C                   Z-ADD     *ZEROS        SEQ#                           INVOICE KEY
     C**
     C                   EXSR      GETL                                         GET LAST SEQ #
     C**
     C     K0AROP        CHAIN     FAROPN                             52
     C**
     C     *IN52         IFEQ      '0'                                          OLD RECORD
     C     CT            ANDLT     10
     C                   ADD       1             CT
     C                   GOTO      S11PT1
     C                   END
     C**
     C     *IN52         IFEQ      '1'                                          NEW RECORD
     C                   EXSR      CLR1                                         CLEAR COMMON
     C*          LAST01    ADD  1         NEXT   030
     C                   Z-ADD     CUST          ARCUST
     C                   Z-ADD     INV#          ARINV#
     C                   Z-ADD     SEQ#          ARSEQ#
     C                   MOVE      SUFF          ARSUFF
     C                   Z-SUB     *ZEROS        ARDTAK
     C                   Z-ADD     ACRCKC        AR$AMT
     C                   Z-ADD     ACRCKC        ARDUE$
     C                   MOVEL     CHEK          ARCHEK
     C                   END
     C**
     C     *IN52         IFEQ      '0'                                          OLD RECORD
     C                   ADD       ACRCKC        AR$AMT
     C                   ADD       ACRCKC        ARDUE$
     C                   MOVE      *BLANKS       ARCHEK
     C                   MOVEL     'Multiple'    ARCHEK
     C                   END
     C**
     C                   Z-ADD     14            ARTTYP                         COMMON INFO
     C                   Z-ADD     TDAT          ARTDAT
     C                   Z-ADD     TDAT          ARDUDT
     C*                    Z-ADDCKDTXX    ARCKDT
     C                   MOVE      *BLANKS       ARDESC
     C                   Z-ADD     ACRCGL        ARGLAC
WJB  C                   MOVE      ' '           ARPRST                         RESET TO PRINT
     C**
     C     *IN52         IFEQ      '1'
     C                   WRITE     RAROPN                                       OUTPUT NEW AR REC
     C                   ELSE
     C                   UPDATE    RAROPN                                       UPDATE OLD AR REC
     C                   END
     C**
     C                   EXSR      PUTTRN                                       OUTPUT NEW TRAN REC
      **
     C                   ADD       PAY$          PAY02                          ADD TO PERM #
     C                   SUB       PAY$          PAY03                          SUB FROM TEMP
      ** --------------------------------------------------------------------
      *
     CSR   S11END        ENDSR
      *
      *
      *
     CSR   BALPUT        BEGSR
      *
     C                   Z-ADD     01            CT
     C                   Z-ADD     EDAT          INV#
     C*                    MOVE 'RC'      SUFF
     C     BALPT1        TAG
     C                   MOVE      S1(CT)        SUFF
     C                   Z-ADD     *ZEROS        SEQ#
      *
     C                   EXSR      GETL
      *
     C     K0AROP        CHAIN     FAROPN                             50
     C     *IN50         IFEQ      '0'                                          OLD RECORD
     C     CT            ANDLT     10
     C                   ADD       1             CT
     C                   GOTO      BALPT1
     C                   END
      *
     C     *IN50         IFEQ      '0'
     C*                    EXSR GETA
     C                   Z-ADD     AR$AMT        XX$AMT           11 2
     C                   Z-ADD     ARDUE$        XXDUE$           11 2
     C                   Z-ADD     ARDISC        XXDISC           11 2
     C                   Z-ADD     ARDTAK        XXDTAK           11 2
     C                   Z-ADD     ARPAID        XXPAID           11 2
     C                   Z-ADD     ARADJ$        XXADJ$           11 2
     C                   MOVE      'N'           NEWYN            01
     C                   ELSE
     C                   Z-ADD     *ZEROS        XX$AMT
     C                   Z-ADD     *ZEROS        XXDUE$
     C                   Z-ADD     *ZEROS        XXDISC
     C                   Z-ADD     *ZEROS        XXDTAK
     C                   Z-ADD     *ZEROS        XXPAID
     C                   Z-ADD     *ZEROS        XXADJ$
     C                   MOVE      'Y'           NEWYN
     C                   END
     C                   Z-ADD     INV#          ARINV#
     C                   MOVE      SUFF          ARSUFF
     C                   Z-ADD     SEQ#          ARSEQ#
      **
      **
     C                   EXSR      CLR1                                         CLEAR COMMON
     C                   Z-ADD     *ZEROS        ARSEQ#
     C                   MOVEL     CHEK          ARCHEK
     C                   Z-ADD     12            ARTTYP
     C                   Z-ADD     TDAT          ARTDAT
     C                   Z-ADD     TDAT          ARDUDT
     C                   Z-ADD     *ZEROS        ARDTAK
     C                   Z-ADD     AAMT          AR$AMT
     C                   Z-ADD     AAMT          ARDUE$
     C                   Z-ADD     GDARRC        ARGLAC
     C                   Z-ADD     12            ARTTYP                         COMMON INFO
     C                   EXSR      PUTTRN
     C                   ADD       XX$AMT        AR$AMT
     C                   ADD       XXDUE$        ARDUE$
     C                   ADD       XXDISC        ARDISC
     C                   ADD       XXDTAK        ARDTAK
     C                   ADD       XXPAID        ARPAID
     C                   ADD       XXADJ$        ARADJ$
     C     NEWYN         IFEQ      'Y'
     C                   WRITE     RAROPN
     C                   ELSE
     C                   MOVE      *BLANKS       ARCHEK
     C                   MOVEL     'Multiple'    ARCHEK
     C                   UPDATE    RAROPN
     C                   END
     C                   Z-ADD     *ZEROS        AAMT
      **
     CSR                 ENDSR
      *
     CSR   PUTTRN        BEGSR
     C                   ADD       1             LAST02
     C                   MOVE      ARSTAT        MTSTAT
     C                   MOVE      ARCUST        MTCUST
     C                   MOVE      ARINV#        MTINV#
     C                   MOVE      ARSUFF        MTSUFF
     C                   MOVE      LAST02        MTSEQ#
     C                   MOVE      ARCTYP        MTCTYP
     C                   MOVE      ARSLM1        MTSLM1
     C                   MOVE      ARCOM1        MTCOM1
     C                   MOVE      ARSLM2        MTSLM2
     C                   MOVE      ARCOM2        MTCOM2
     C                   MOVE      ARTERR        MTTERR
     C                   MOVE      ARCOMP        MTCOMP
     C                   MOVE      ARTTYP        MTTTYP
     C                   MOVE      ARTDAT        MTTDAT
     C                   MOVE      ARDUDT        MTDUDT
     C                   Z-ADD     AR$AMT        MT$AMT
     C                   Z-ADD     *ZEROS        MTDIS$
     C                   Z-ADD     *ZEROS        MTQDIS
     C                   Z-ADD     *ZEROS        MTFRT$
     C                   Z-ADD     *ZEROS        MTSPL$
     C                   Z-ADD     *ZEROS        MTAMT1
     C                   Z-ADD     *ZEROS        MTAMT2
     C                   Z-ADD     *ZEROS        MTAMT3
     C                   Z-ADD     *ZEROS        MTMER$
     C                   MOVE      ARGLAC        MTGLAC
     C                   MOVE      *BLANKS       MTGLAR
     C                   MOVE      *BLANKS       MTGLUD
     C                   Z-ADD     *ZEROS        MTO30$
     C                   MOVE      ARDCDT        MTDCDT
     C                   MOVE      ARORD#        MTORD#
     C                   Z-ADD     ARDISC        MTDISC
     C                   MOVE      *BLANKS       MTDMFL
     C                   MOVE      *BLANKS       MTSMFL
     C                   MOVE      ARSHCU        MTSHCU
     C                   MOVE      ARSACU        MTSACU
     C                   MOVE      ARBLCU        MTBLCU
     C                   MOVE      ARLOOK        MTLOOK
     C                   MOVE      ARPONO        MTPONO
     C                   MOVE      *BLANKS       MTPOSC
     C                   MOVE      *BLANKS       MTPOS
     C                   MOVE      *BLANKS       MTCSAJ
     C                   MOVE      *BLANKS       MTSHFR
     C                   MOVE      ARCHEK        MTCHEK
     C                   MOVE      ARCKDT        MTCKDT
     C                   MOVE      ARDESC        MTDESC
     C                   MOVE      ARDTLA        MTDTLA
     C                   MOVE      ARTIME        MTTIME
     C                   MOVE      ARUSER        MTUSER
     C*
     C                   MOVE      *BLANKS       MTCRCD
     C                   Z-ADD     *ZEROS        MTCRC#
     C                   Z-ADD     *ZEROS        MTCRCE
     C                   MOVE      *BLANKS       MTCRCA
     C*
     C                   MOVE      *BLANKS       MTSHP#
     C                   WRITE     RMTRAN
     CSR                 ENDSR
      *
      *
     CSR   PUTREV        BEGSR
     C                   ADD       1             LAST02
     C*                    MOVE ARTMTGLAC MTSTAT
     C*                    MOVE ARCUST    MTCUST
     C*                    MOVE ARINV#    MTINV#
     C*                    MOVE ARSUFF    MTSUFF
     C                   MOVE      LAST02        MTSEQ#
     C*                    MOVE ARCTYP    MTCTYP
     C*                    MOVE ARSLM1    MTSLM1
     C*                    MOVE ARCOM1    MTCOM1
     C*                    MOVE ARSLM2    MTSLM2
     C*                    MOVE ARCOM2    MTCOM2
     C*                    MOVE ARTERR    MTTERR
     C*                    MOVE ARCOMP    MTCOMP
     C*                    MOVE ARTTYP    MTTTYP
     C*                    MOVE ARTDAT    MTTDAT
     C*                    MOVE ARDUDT    MTDUDT
     C                   Z-SUB     AR$AMT        MT$AMT
     C*                    Z-ADD*ZEROS    MTDIS$
     C*                    Z-ADD*ZEROS    MTQDIS
     C*                    Z-ADD*ZEROS    MTFRT$
     C*                    Z-ADD*ZEROS    MTSPL$
     C*                    Z-ADD*ZEROS    MTAMT1
     C*                    Z-ADD*ZEROS    MTAMT2
     C*                    Z-ADD*ZEROS    MTAMT3
     C*                    Z-ADD*ZEROS    MTMER$
     C                   MOVE      ARGLAC        MTGLAC
     C*                    MOVE *BLANKS   MTGLAR
     C*                    MOVE *BLANKS   MTGLUD
     C*                    Z-ADD*ZEROS    MTO30$
     C*                    MOVE ARDCDT    MTDCDT
     C*                    MOVE ARORD#    MTORD#
     C                   Z-SUB     ARDISC        MTDISC
     C*                    MOVE *BLANKS   MTDMFL
     C*                    MOVE *BLANKS   MTSMFL
     C*                    MOVE ARSHCU    MTSHCU
     C*                    MOVE ARSACU    MTSACU
     C*                    MOVE ARBLCU    MTBLCU
     C*                    MOVE ARLOOK    MTLOOK
     C*                    MOVE ARPONO    MTPONO
     C*                    MOVE *BLANKS   MTPOSC
     C*                    MOVE *BLANKS   MTPOS
     C*                    MOVE *BLANKS   MTCSAJ
     C*                    MOVE *BLANKS   MTSHFR
     C*                    MOVE ARCHEK    MTCHEK
     C*                    MOVE ARCKDT    MTCKDT
     C*                    MOVE ARDESC    MTDESC
     C*                    MOVE ARDTLA    MTDTLA
     C*                    MOVE ARTIME    MTTIME
     C*                    MOVE ARUSER    MTUSER
     C                   WRITE     RMTRAN
     CSR                 ENDSR
      *
      *
     CSR   S10NON        BEGSR                                                  CLEAR SELECTIONS
     C                   Z-ADD     *ZEROS        RR1
     C     *IN50         DOUEQ     '1'
     C                   ADD       1             RR1
     C     RR1           CHAIN     S10SFL                             50
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
      **
     C     CODE          IFNE      *BLANKS
     C     PAY$          ORNE      *ZEROS
     C*          PDIS      ORNE *ZEROS
     C                   MOVE      *BLANKS       CODE
     C                   Z-ADD     *ZEROS        PAY$
     C*                    Z-ADD*ZEROS    PDIS
     C                   EXSR      SET11
     C                   UPDATE    S10SFL
     C                   END
      **
     C                   ENDDO
      **
     CSR                 ENDSR
      **
      **
     CSR   GETL          BEGSR
     C                   Z-ADD     *ZEROS        LAST01           03 0
     C                   Z-ADD     *ZEROS        LAST02           03 0
     C     K1AROP        SETLL     FAROPN
     C     K1AROP        SETLL     FMTRAN
     C**
     C     *IN51         DOUEQ     '1'                                          GET LAST AR
     C     K1AROP        READE     FAROPN                                 51
     C     *IN51         IFEQ      '1'
     C                   LEAVE
     C                   END
     C                   Z-ADD     ARSEQ#        LAST01
     C                   ENDDO
     C**
     C     *IN51         DOUEQ     '1'                                          GET LAST TRAN
     C     K1AROP        READE     FMTRAN                                 51
     C     *IN51         IFEQ      '1'
     C                   LEAVE
     C                   END
     C                   Z-ADD     MTSEQ#        LAST02
     C                   ENDDO
     CSR                 ENDSR
      **
      **
     CSR   CLR1          BEGSR
CLR  C                   MOVE      *BLANKS       ARSTAT
CLR  C                   Z-ADD     *ZEROS        ARDUDT
CLR  C                   Z-ADD     *ZEROS        AR$AMT
CLR  C                   Z-ADD     *ZEROS        ARDISC
CLR  C                   Z-ADD     *ZEROS        ARDTAK
CLR  C                   Z-ADD     *ZEROS        ARADJ$
CLR  C                   Z-ADD     *ZEROS        ARPAID
CLR  C                   Z-ADD     *ZEROS        ARDUE$
CLR  C                   MOVE      *BLANKS       ARCHEK
CLR  C                   Z-ADD     *ZEROS        ARCKDT
CLR  C*                    Z-ADDCKDT      ARGLAC
CLR  C                   MOVE      *BLANKS       ARDESC
CLR  C                   Z-ADD     *ZEROS        ARDCDT
CLR  C                   MOVE      *BLANKS       ARCRCD
CLR  C                   Z-ADD     *ZEROS        ARCRC#
CLR  C                   Z-ADD     *ZEROS        ARCRCE
CLR  C                   MOVE      *BLANKS       ARCRCA
COM  C                   MOVE      UDATE         ARDTLA
COM  C                   MOVE      TIMOD         ARTIME
COM  C                   MOVE      USERID        ARUSER
COM  C                   MOVE      'A'           ARSTAT
COM  C                   Z-ADD     CUST          ARCUST
COM  C                   Z-ADD     *ZEROS        ARSHCU
     CSR                 ENDSR
      *
      *
     CSR   SET11         BEGSR                                                  PAYMENTS ONLY
     C     TTYP          IFEQ      02                                           CHECKS
     C     TTYP          OREQ      03                                           ON ACCOUNT
     C                   MOVE      '1'           *IN11
     C                   ELSE
     C                   MOVE      '0'           *IN11
     C                   END
     C**
     C**
     CSR                 ENDSR
      *
     CSR   TSTPY1        BEGSR
     C     PAY$          IFGT      0
     C     PAY$          ANDGT     PAY09
     C                   MOVE      'Y'           W20              01
     C                   Z-ADD     PAY09         PAY$
     C                   END
     CSR                 ENDSR
     C**
     CSR   TSTPY2        BEGSR
     C     PAY09         IFLT      *ZEROS                                       OVER PAID
     C*                    Z-ADD*ZEROS    PDIS
     C                   SUB       PAY$          PAY03
     C                   ADD       PAY09         PAY$
     C                   ADD       PAY$          PAY03
     C                   EXSR      CALCOP
     C                   END
     CSR                 ENDSR
      *
      *
      *
      *
     CSR   COLCOM        BEGSR
     C                   CALL      'ARR222'
     C                   PARM                    CUST
     C                   PARM                    RETC
     C     RETC          IFEQ      'A'
     C                   MOVE      CUST          CUSTA            06
     C                   CALL      'ARR223CA'
     C                   PARM                    CUSTA
     C                   END
     CSR                 ENDSR
     C**
     C**
     CSR   CALCOP        BEGSR                                                  CALCULATE OPEN BAL.
     C     PAY01         SUB       PAY02         PAY09            09 2
     C     PAY09         SUB       PAY03         PAY09
     C                   Z-ADD     PAY01         TAMT
     C                   Z-ADD     PAY09         AAMT
     CSR                 ENDSR
     C**
     C**
     CSR   WARN01        BEGSR
     C                   MOVEL     WN(CTW)       WN01
     C                   ADD       01            CTW
     C                   MOVEL     WN(CTW)       WN02
     C                   ADD       01            CTW
     C                   MOVEL     WN(CTW)       WN03
     C                   EXFMT     WARN00
     CSR                 ENDSR
      *
     CSR   POFALL        BEGSR
     C                   Z-ADD     *ZEROS        RR1
L1   C     *IN50         DOUEQ     '1'
     C                   ADD       1             RR1
     C     RR1           CHAIN     S10SFL                             50
L2   C     *IN50         IFEQ      '1'
     C                   LEAVE
L2   C                   END
L2   C     PAY$          IFEQ      *ZEROS
L2   C*          PDIS      ANDEQ*ZEROS
      ** ---
      ** ---
     C**
     C                   EXSR      TSTPY2                                       TEST FOR OVER PAY
     C                   EXSR      SET11
L3   C     PAY$          IFNE      *ZEROS
     C                   MOVE      'Y'           CODE
L3   C                   END
     C                   UPDATE    S10SFL
L2   C                   END
L1   C                   ENDDO
     CSR                 ENDSR
     C**
     C**
     CSR   LODBT         BEGSR
     C                   MOVE      *BLANKS       N
     C                   Z-ADD     01            CT
     C                   MOVEL     CMNAME        N(CT)
     C     CMADD2        IFNE      *BLANKS
     C                   ADD       1             CT
     C                   MOVEL     CMADD2        N(CT)
     C                   END
     C     CMADD3        IFNE      *BLANKS
     C                   ADD       1             CT
     C                   MOVEL     CMADD3        N(CT)
     C                   END
     C     CMADD4        IFNE      *BLANKS
     C                   ADD       1             CT
     C                   MOVEL     CMADD4        N(CT)
     C                   END
     C                   ADD       1             CT
     C     CMCITY        CAT       ',':0         NAM1             30
     C     NAM1          CAT       CMSTST:1      NAM2             30
     C     NAM2          CAT       CMZIP:1       NAM3             30
     C                   MOVEL     NAM3          N(CT)
     C                   MOVEL     N(01)         BT01
     C*                    MOVELN,02      BT02
     C*                    MOVELN,03      BT03
     C*                    MOVELN,04      BT04
     C*                    MOVELN,05      BT05
     CSR                 ENDSR
     C**
     C**
     CSR   CALDAT        BEGSR
     C     VACUST        CHAIN     FARHST                             50        GET FROM HISTORY
     C                   CALL      'GETCARBL'                                   CALC 30,60,90 DAYS
     C**
     C                   PARM                    LCOXX
     C                   PARM                    CUST
     C                   PARM                    CMARB$
     C                   PARM                    CMCUR$
     C                   PARM                    CMAR1$
     C                   PARM                    CMAR2$
     C                   PARM                    CMAR3$
     C                   PARM                    CMAR4$
     C                   PARM                    CMFUT$
     C**
     C                   UPDATE    RARHST
     C**
     CSR                 ENDSR
      *
      *
     CSR   CLRR1         BEGSR
     C                   MOVE      *BLANKS       ONLY
     C                   MOVE      *BLANKS       CHEK
     C                   Z-ADD     *ZEROS        PAID
     C                   MOVE      *BLANKS       CHEK
     C                   Z-ADD     *ZEROS        DTFM
     C                   Z-ADD     *ZEROS        DTTO
     C                   Z-ADD     *ZEROS        DLFM
     C                   Z-ADD     *ZEROS        DLTO
     CSR                 ENDSR
     C**
     CSR   OP010         BEGSR
     C*                    MOVE '0'       *IN61
     C     OP010T        TAG
     C                   EXFMT     OPT010
     C*          SL01      IFNE '1'
     C*          SL01      ANDNE'2'
     C*                    MOVE '1'       *IN61
     C*                    GOTO OP010T
     C*                    END
     C     *INKV         IFEQ      '1'
     C                   CALL      'ATTN01'
     C                   END
     CSR                 ENDSR
** TP
Inv                   1
Pmt                   2
Pmt                   3
Adj                   4
Crm                   5
Non                   6
L/C                   7
Pmt                   8
Dis                   9
C/C                  10
Dep                  11
                     12
                     13
                     14
                     15
** CM ***************************************************************
 Roll             F5=Coll Notes  F6=Restart              F9=Deselect   CSH TOP
 F10=No Detail       F8=Change Requirements   F12=Balance on Account      BOT A
 F10=Display Detail  F8=Change Requirements   F12=Balance on Account      BOT B












   Enter to Process    F3/F7=End of Job    F13=Change Trans. Date     1st A
** ER **********************
 Entry Must Balance To Zero
 Only One Update/Adjustment
Select Credit or Pymt To Use
 Select Invoice or Late Chg
 Only One Payment At A Time
 Select Lines To Omit
 Seq of 00 Must Be Paid
   No Open Records Found
   F1=Accept
** PH ***********
 Ret'd Check Amt:
  Bal To Reverse:




** WN **************************************************
      Please Remove "Y" From Lines That Should                         W10
          Not Be Selected At This Time.

Please place a "Y" on the lines that have a payment                    W15
amount but are not marked with a "Y" or remove the
payment amount.
Amount to be paid was larger than balance to apply.                    W20
The payment amount on at least one invoice has been
changed.
               "Y" Is The Only Valid Code.                             W25
              Change Code to "Y" or Blanks.

F1 Is Not Valid.   You Must Select A Transaction
       or Hit F6 To Restart With No Update.

   G/L Account Number is Missing.  Code Cannot be Used.


A discount amount has been taken on a line that does                   W16
not have a payment.  Please remove the discount or
make the line a payment.
Discount taken is greater than discount offered on                     W16
at least one line.  Please change the discount
amount.
**
RC
R1
R2
R3
R4
R5
R6
R7
R8
R9
**
CC
C1
C2
C3
C4
C5
C6
C7
C8
C9
