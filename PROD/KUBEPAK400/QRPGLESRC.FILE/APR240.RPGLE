      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.     1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *****************************************************************
      *PROGRAM NAME-------- APR240
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- OPEN INVOICE STATUS INQUIRY.
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  9/26/01 EFD ONLY HERE BECAUSE WE SHOW VMOFIL AS ACCOUNT #
      *
      *
     FAPR240FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     F                                     SFILE(PMTSFL:RECN1)
     FFAPOPN    IF   E           K DISK
     FFAPDTPVD  IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFAPCTL    IF   E           K DISK
WJB  FFAPWKS    IF   E           K DISK    PreFix(V_)
      *
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
     D  LVEND                172    177  0
     D  CALLD                178    178
      *
temp C                   Z-Add     12            PUTCSRLIN
temp C                   Z-Add     15            PUTCSRPOS
temp C                   Z-Add     1             PUTSFLRRN
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      * CHECK IF CALLED
      *
     C     CALLD         IfEQ      'Y'
     C                   Z-add     LVEND         VVEND
     C                   Z-ADD     1             FCNT
     C                   Z-ADD     1             PCNT
     C                   Z-ADD     TDATE         VDATE
     C                   Z-ADD     1             VINCL
     C                   GOTO      CALLED
     C                   END
      *
     C     RSTRTA        TAG
     C                   Z-ADD     1             FCNT
     C                   Z-ADD     1             PCNT
     C                   Z-ADD     TDATE         VDATE
     C                   Z-ADD     1             VINCL
     C                   MOVEL     *BLANKS       VMNAME
     C                   Z-ADD     0             VVEND
     C                   Z-ADD     0             TOTAP
     C                   Z-ADD     0             TOTDS
     C                   Z-ADD     0             TOTPD
     C                   Z-ADD     0             TPAID
     C                   Z-ADD     0             APCURR
     C                   Z-ADD     0             APPAST
     C                   Z-ADD     0             TOTAL
     C                   Z-ADD     0             APAGE1
     C                   Z-ADD     0             APAGE2
     C                   Z-ADD     0             APAGE3
     C                   Z-ADD     0             APAGE4
     C                   Z-ADD     0             APAGE5
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       203040
     C                   SETOFF                                       6061
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              GOTO      ENDP
      *
     C     Reload        TAG
     C                   Z-ADD     0             TOTAP
     C                   Z-ADD     0             TOTDS
     C                   Z-ADD     0             TOTPD
     C                   Z-ADD     0             TPAID
     C                   Z-ADD     0             APCURR
     C                   Z-ADD     0             APPAST
     C                   Z-ADD     0             TOTAL
     C                   Z-ADD     0             APAGE1
     C                   Z-ADD     0             APAGE2
     C                   Z-ADD     0             APAGE3
     C                   Z-ADD     0             APAGE4
     C                   Z-ADD     0             APAGE5
     C     VVEND         IFEQ      0
     C     VALPHA        ANDGT     *BLANKS
     C                   Z-ADD     LCO           VMCOMP            2 0
     C                   MOVEL     VALPHA        VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        VVEND
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         IFEQ      0
     C     VALPHA        ANDEQ     *BLANKS
     C     Search        ANDNE     *BLANKS
    ?C                   Call      'LKVEND'
    ?C                   Parm                    Search                         ?
    ?C                   Parm                    Account           6            ?
     C                   Move      Account       VVEND
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         IFGT      0
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        1011
     C   10
     CAN 11              GOTO      NXTA
     C                   ENDIF
      *
     C     CALLED        TAG
      *
     C     VVEND         CHAIN     FMVEND                             90
     C   90              SETON                                        1012
     C   10
     CAN 12              GOTO      NXTA
      *
     C     VINCL         IFLT      1
     C     VINCL         ORGT      3
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LCO           CHAIN     FAPCTL                             90
     C   90              SETON                                        30
     C   30              GOTO      NXTA
     C                   Z-ADD     AZAGPY        SVAGDY            3 0
     C                   Z-ADD     AZAGP2        SVAGD2            3 0
     C                   Z-ADD     AZAGP3        SVAGD3            3 0
     C                   Z-ADD     AZAGP4        SVAGD4            3 0
      *
     C                   Z-ADD     VDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        40
     C                   GOTO      NXTA
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RDATE             5 0          AS OF DATE
      *
      * OPEN A/P ONLY
      *
     C     VINCL         IFEQ      1
     C                   SETON                                        60
     C                   ENDIF
      *
      * PAID A/P ONLY
      *
     C     VINCL         IFEQ      2
     C                   SETON                                        61
     C                   ENDIF
      *
     C                   EXSR      AGDATS
      *
     C     VVEND         CHAIN     FMVEND                             90
     C                   EXSR      SUMRY
      *
     C     RSTRTB        TAG
     C     VVEND         SETLL     FAPOPN
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             TOTAP
     C                   Z-ADD     0             TOTPD
     C                   Z-ADD     0             TOTDS
      *
     C                   SETOFF                                       90
      *C   KF                GOTO RSTRTA
      *C   KC
      *COR KG                GOTO ENDP
      *
     C     NXTI          TAG
     C     VVEND         READE     FAPOPN                                 90
     C   90              GOTO      DSPL
     C     APCOMP        IFNE      LCO                                                      #
     C                   GOTO      NXTI
     C                   ENDIF
     C     APSTAT        IFEQ      'D'                                                      #
     C     APPAID        ANDEQ     0
     C                   GOTO      NXTI
     C                   ENDIF
     C   60APDUE$        IFEQ      0
     C                   GOTO      NXTI
     C                   ENDIF
     C   61APPAID        IFEQ      0
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C                   EXSR      APTYP
      *
     C                   Z-ADD     APDUE$        DUE
     C                   Z-ADD     APPAID        PAID
     C                   Z-ADD     APDAVL        DISC
     C     APDUE$        IFEQ      0
     C                   Z-ADD     0             DISC
     C                   ENDIF
     C     APDCDT        IFGT      0
     C                   Z-ADD     APDCDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DDATE             5 0
     C                   ENDIF
     C     DDATE         IFLT      RDATE
     C                   Z-ADD     0             DISC
     C                   ENDIF
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   ADD       APDUE$        TOTAP            11 2
     C                   ADD       APPAID        TOTPD            11 2
     C                   ADD       DISC          TOTDS            11 2
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C**         FCNT      IFGT 1
     C**                   GOTO NOTOT
     C**                   ENDIF
     C                   ADD       2             RECNO
     C                   Z-ADD     0             APVOUC
     C                   MOVEL     *BLANKS       TYPE
     C                   Z-ADD     0             APDUDT
     C                   Z-ADD     0             APCKDT
     C                   Z-ADD     0             DISC
     C                   Z-ADD     0             DUE
     C                   Z-ADD     0             PAID
     C                   Z-ADD     TOTAP         DUE
     C                   Z-ADD     TOTPD         PAID
     C                   Z-ADD     TOTDS         DISC
     C                   MOVEL     *BLANKS       APCHEK
     C                   MOVEL     '* Totals'    DESC1            10
     C                   MOVE      ' *'          DESC1
     C                   MOVEL     DESC1         APINV#
     C                   WRITE     RECSFL
     C                   ADD       1             FCNT              2 0
     C                   EXFMT     RECCTL
     C   KC
     COR KG              GOTO      ENDP
     C   KI              GOTO      RSTRTC
      *
     C                   If        *InKK or *INKM
     C                   EXSR      DSPSND
     C                   GOTO      ReLoad
     C                   EndIf
      *
     C     NOTOT         TAG
      *
     C                   GOTO      RSTRTA
      *
     C     RSTRTC        TAG
      *
     C     VVEND         SETLL     FAPDTPVD
     C                   MOVE      '1'           *IN80
     C                   WRITE     PMTCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECN1             5 0
     C                   Z-ADD     0             TPAID
      *
     C                   SETOFF                                       90
      *
     C     NXTP          TAG
     C     VVEND         READE     FAPDTPVD                               90
     C   90              GOTO      DSPL2
     C     ATCOMP        IFNE      LCO                                                      #
     C                   GOTO      NXTP
     C                   ENDIF
      *
     C                   ADD       1             RECN1
     C                   WRITE     PMTSFL
     C                   ADD       ATPAID        TPAID             9 2
     C                   GOTO      NXTP
      *
     C     DSPL2         TAG
     C*          FCNT      IFGT 1
     C*                    GOTO NPTOT
     C*                    ENDIF
     C                   ADD       2             RECN1
     C                   Z-ADD     0             ATVOUC
     C                   Z-ADD     0             ATCKDT
     C                   MOVEL     *BLANKS       ATINV#
     C                   MOVEL     *BLANKS       ATITYP
     C                   Z-ADD     0             ATCHEK
     C                   MOVEL     *BLANKS       ATDESC
     C                   Z-ADD     TPAID         ATPAID
     C                   MOVEL     *BLANKS       APCHEK
     C                   MOVEL     '* Total '    DESC1            10
     C                   MOVE      '* '          DESC1
     C                   MOVE      DESC1         ATDESC
     C                   WRITE     PMTSFL
     C                   ADD       1             PCNT              2 0
     C                   ADD       1             FCNT              2 0
     C                   EXFMT     PMTCTL
     C   KC
     COR KG              GOTO      ENDP
     C   KI              GOTO      RSTRTB
     C     NPTOT         TAG
      *
     C                   GOTO      RSTRTA
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
      *
      *          DSPSND- SHOW WHAT G/L# PAYMENT WENT TO
      *
     C     DSPSND        BEGSR
      *
     C     KeyVouch      KList
     C                   KFld                    APCOMP
     C                   KFld                    APVOUC
     C                   KFld                    APVEND
     C                   KFld                    APINV#
     C                   SELECT
     C     SflCsrRRN     WHENEQ    *ZERO
     C                   MOVE      *ON           *IN51
     C                   Z-add     15            WDWLIN
     C     SflCsrRRN     WHENNE    *ZERO
     C                   MOVE      *OFF          *IN51
     C     SflCsrRRN     DIV       12            WRKPOS            2 0
     C                   MVR                     WRKPOS
     C                   If        WRKPOS = *Zero
     C                   Eval      WRKPOS = 12
     C                   EndIF
     C     WRKPOS        ADD       09            WDWLIN
     C     SflCsrRRN     CHAIN     RECSFL                             52
     C     KeyVouch      Chain     FAPWKS
     C                   If        not %found(FAPWKS)
     C                   Clear                   RAPWKS
     C                   Eval      *In51 = *On
     C                   EndIF
     C                   ENDSL
      *    Put the Cursor Back where it was (On the Same SFL Page)
     C                   ExSr      WhereAmI

     C                   EXFMT     SCRND
      *
     C                   ENDSR

      *?  ...........................................................
      *?  :      WhereAmI - Figure out where the cursor is          :
      *?  :.........................................................:
    ?C     WhereAmI      BegSr                                                  ?

     C                   If        SFLCSRRRN = 0
temp C                   Z-Add     12            PUTCSRLIN
temp C                   Z-Add     15            PUTCSRPOS
     C                   Else
     C                   Eval      PUTCSRLIN = WRKPOS + 11                      ?Cursor on Line
     C                   Eval      PUTCSRPOS = 15                               ?Cursor in Position
     C                   Eval      PUTSFLRRN = SFLCSRRRN                        ?Subfile on Page
    ?C                   EndIf                                                  ?

    ?C                   EndSr                                                  ?

      **********
      * AGDATS *     AGE DUE DATES
      **********
     C     AGDATS        BEGSR
     C     RDATE         ADD       1             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVASD1            6 0
     C     RDATE         ADD       SVAGDY        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVASD2            6 0
     C     ##DDD         ADD       1             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVASD3            6 0
     C     RDATE         ADD       SVAGD2        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVASD4            6 0
     C     ##DDD         ADD       1             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVASD5            6 0
     C     RDATE         ADD       SVAGD3        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVASD6            6 0
     C     ##DDD         ADD       1             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVASD7            6 0
     C     RDATE         ADD       SVAGD4        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVASD8            6 0
     C                   Z-ADD     ##MDY         SVASD9            6 0
     C                   ENDSR
      *
      ************
      * SUMRY    *    TOTALS FOR A/P BALANCE DUE
      ************
     C     SUMRY         BEGSR
     C                   Z-ADD     0             APVOUC
     C                   MOVE      *BLANKS       APINV#
     C                   Z-ADD     0             APSEQ#
     C                   Z-ADD     LCO           VCO               2 0
     C                   MOVE      *BLANKS       APITYP
     C     APKEY         KLIST
     C                   KFLD                    VVEND
     C                   KFLD                    VCO
     C                   KFLD                    APVOUC
     C                   KFLD                    APINV#
     C                   KFLD                    APSEQ#
     C                   KFLD                    APITYP
     C     APKEY         SETLL     FAPOPN
     C     AGAIN         TAG
     C                   READ      FAPOPN                                 92
     C   92              GOTO      ENDSUM
     C     APCOMP        IFNE      LCO
     C                   GOTO      AGAIN
     C                   ENDIF
     C     APVEND        IFGT      VVEND
     C                   GOTO      ENDSUM
     C                   ENDIF
     C     APSTAT        IFEQ      'D'                                                      S?
     C     APCLCD        OREQ      'C'                                                      LE
     C                   GOTO      AGAIN
     C                   ENDIF
     C                   EXSR      AGING
     C                   GOTO      AGAIN
     C     ENDSUM        ENDSR
      *
      **********
      * AGING  *    DETERMINES APPROPRIATE AGING DAYS
      **********
     C     AGING         BEGSR
     C                   SETOFF                                       181920
     C                   SETOFF                                       2122
     C                   Z-ADD     APDUDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         SVDUDT            5 0             DUE DATE
     C     SVDUDT        SUB       RDATE         RESULT            5 0                      OF
     C     RESULT        IFLT      0                                                        OF
     C                   ADD       APDUE$        APPAST           11 2
     C                   GOTO      EAGE
     C                   ENDIF
     C     RESULT        IFEQ      0                                                        OF
     C                   ADD       APDUE$        APCURR           11 2
     C                   GOTO      EAGE
     C                   ENDIF
     C     RESULT        IFGT      0                                                        OF
     C     RESULT        ANDLE     AZAGPY                                                   OF
     C                   ADD       APDUE$        APAGE1           11 2
     C                   GOTO      EAGE
     C                   ENDIF
     C     RESULT        IFGT      AZAGPY                                                   OF
     C     RESULT        ANDLE     AZAGP2                                                   OF
     C                   ADD       APDUE$        APAGE2           11 2
     C                   GOTO      EAGE
     C                   ENDIF
     C     RESULT        IFGT      AZAGP2                                                   OF
     C     RESULT        ANDLE     AZAGP3                                                   OF
     C                   ADD       APDUE$        APAGE3           11 2
     C                   GOTO      EAGE
     C                   ENDIF
     C     RESULT        IFGT      AZAGP3                                                   OF
     C     RESULT        ANDLE     AZAGP4                                                   OF
     C                   ADD       APDUE$        APAGE4           11 2
     C                   GOTO      EAGE
     C                   ENDIF
     C                   ADD       APDUE$        APAGE5           11 2
     C     EAGE          TAG
      *
     C                   ADD       APDUE$        TOTAL            11 2          TOTAL A/P
     C                   ENDSR
      *
      **********
      * APTYP  *    GET TYPE
      **********
     C     APTYP         BEGSR
     C     APTBPD        IFEQ      'H'
     C                   MOVEL     'Hld'         TYPE
     C                   GOTO      ETYPE
     C                   ENDIF
     C     APITYP        IFEQ      *BLANKS
     C     APITYP        OREQ      'I'                                                      Y
     C                   MOVEL     'Inv'         TYPE
     C                   GOTO      ETYPE
     C                   ENDIF
     C     APITYP        IFEQ      'F'
     C                   MOVEL     'Frt'         TYPE
     C                   GOTO      ETYPE
     C                   ENDIF
     C     APITYP        IFEQ      'M'
     C                   MOVEL     'Pmt'         TYPE
     C                   GOTO      ETYPE
     C                   ENDIF
     C     APITYP        IFEQ      'C'
     C                   MOVEL     'C/M'         TYPE
     C                   GOTO      ETYPE
     C                   ENDIF
     C     ETYPE         ENDSR
      *
