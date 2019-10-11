      *--------------------------------------------------------------     ARR240
      *                                                                   ARR240
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999                          ARR240
      *                                                                   ARR240
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO         ARR240
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE         ARR240
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED      ARR240
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR         ARR240
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT      ARR240
      *       BY EXPRESS WRITTEN PERMISSION OF                            ARR240
      *            EFD ENTERPRISES, INC.     215-643-5352                 ARR240
      *                                                                   ARR240
      *--------------------------------------------------------------     ARR240
      *PROGRAM NAME-------- ARR240                                        ARR240
      *SYSTEM-------------- ACCOUNTS RECEIVABLE                           ARR240
      *DESCRIPTION--------- COMPANY A/R SUMMARY BALANCE                   ARR240
      *                                                                   ARR240
      *                                                                   ARR240
      *            CHANGE--DATE-------DESCRIPTION                         ARR240
      *                                                                   ARR240
      *                                                                   ARR240
     FARR240FM  CF   E             WORKSTN USROPN
     F                                     DEVID(WSID)
     FARR241P   O    E             Printer
     FFARCTL    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFAROPN    IF   E           K DISK
     FFGLBAL    IF   E           K DISK
      *                                                                   ARR240
     D #PD$            S             10  2 DIM(5)                               PAST DUE $       ARR
     D #PP$            S             11  2 DIM(5)                               PRINT LINE $
     D #FD             S              5  0 DIM(4) ASCEND                        AGING DAYS ARRAY ARR
     D #FD$            S             11  2 DIM(5)                               FUTURE        AY ARR
     D #IN             S              6  0 DIM(5)                               AGE # INVOICES   ARR
     D #CM             S              6  0 DIM(5)                               AGE # C/M'S      ARR
     D #LC             S              6  0 DIM(5)                               AGE # L/C'S      ARR
     D #OA             S              6  0 DIM(5)                               AGE # O/A'S      ARR
     D SAR             S             11  2 DIM(5)                               AGE # O/A'S      ARR
      *                                                                   ARR240
     D CR              S             11  2 DIM(13)
      *                                                                   ARR240
     D*               UDS
     D* LCO                    1      2  0
     D  LCO            S              2  0 Inz(1)
      *
     IRGLBAL
     I              GLT01                       CR(1)
     I              GLT02                       CR(2)
     I              GLT03                       CR(3)
     I              GLT04                       CR(4)
     I              GLT05                       CR(5)
     I              GLT06                       CR(6)
     I              GLT07                       CR(7)
     I              GLT08                       CR(8)
     I              GLT09                       CR(9)
     I              GLT10                       CR(10)
     I              GLT11                       CR(11)
     I              GLT12                       CR(12)
     I              GLT13                       CR(13)
      *
      *
     C                   setoff                                       99
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     TDATE         LDATE
      *                                                                   ARR240
     C     RSTRTA        TAG
     C   99              OPEN      ARR240FM
     C   99              WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       1020
     C   99              READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
      *                                                                   ARR240
     C     LCO           CHAIN     FARCTL                             90                    K
     C     LCO           CHAIN     FMCORG                             90                    K
     C     KEYGL         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GLGLNO
     C                   Eval      GLGLNO = 15000000
     C     KEYGL         CHAIN     FGLBAL                             97        GET $ AMOUNTS
     C                   Eval      GLBAL = GLBALT
     C                   Do        12            W                 2 0
     C                   ADD       CR(W)         GLBAL
     C                   EndDo
      *
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         #WKAOJ            5 0          AS OF DATE
      *                                                                   ARR240
     C                   EXSR      #AGDY                                                       ARR24
     C                   EXSR      SUMRY                                                       ARR24
      *                                                                   ARR240
     C                   Z-ADD     #IN(1)        IN1                                           ARR24
     C                   Z-ADD     #IN(2)        IN2                                           ARR24
     C                   Z-ADD     #IN(3)        IN3                                           ARR24
     C                   Z-ADD     #IN(4)        IN4                                           ARR24
     C                   Z-ADD     #IN(5)        IN5                                           ARR24
     C*                    Z-ADD#LC,1     LC1                             ARR240
     C*                    Z-ADD#LC,2     LC2                             ARR240
     C*                    Z-ADD#LC,3     LC3                             ARR240
     C*                    Z-ADD#LC,4     LC4                             ARR240
     C*                    Z-ADD#LC,5     LC5                             ARR240
     C                   Z-ADD     #PD$(1)       #PD$01                                        ARR24
     C                   Z-ADD     #PD$(2)       #PD$02                                        ARR24
     C                   Z-ADD     #PD$(3)       #PD$03                                        ARR24
     C                   Z-ADD     #PD$(4)       #PD$04                                        ARR24
     C                   Z-ADD     #PD$(5)       #PD$05                                        ARR24
      *                                                                   ARR240
     C     RSTRTB        TAG
     C                   If        GLBAL <> VARBAL
     C                   Eval      *In98 = *On
     C                   Eval      ARDIF = GLBAL - VARBAL
     C                   EndIf
     C   99              WRITE     SCRNB
     C                   WRITE     REPTB
     C                   SETOFF                                       1020
     C   99              READ      SCRNB                                  90
     C   KC
     COR KG              GOTO      END
      *                                                                   ARR240
     C                   GOTO      END
     C                   GOTO      RSTRTA
      *                                                                   ARR240
     C     END           TAG                                                                   ARR24
     C   99              Close     ARR240FM
     C                   SETON                                        LR
      *********                                                           ARR240
      * #AGDY *                                                           ARR240
      *********                                                           ARR240
      * USE THIS SUBROUTINE TO LOAD AGING DAYS PRINT HEADINGS             ARR240
      * LOAD "AS OF DATE" INTO FIELD ##MDY                                ARR240
      *                                                                   ARR240
     C     #AGDY         BEGSR                                                                 ARR24
     C                   Z-ADD     ACAGPY        #WKP1             3 0                         ARR24
     C                   Z-ADD     ACAGP2        #WKP2             3 0                         ARR24
     C                   Z-ADD     ACAGP3        #WKP3             3 0                         ARR24
     C                   Z-ADD     ACAGP4        #WKP4             3 0                         ARR24
     C                   Z-ADD     ACAGP4        #WKP4A            3 0                         ARR24
     C                   Z-ADD     1             #WKP0             3 0                         ARR24
     C     #WKP1         ADD       1             #WKP1A            3 0                         ARR24
     C     #WKP2         ADD       1             #WKP2A            3 0                         ARR24
     C     #WKP3         ADD       1             #WKP3A            3 0                         ARR24
     C                   Z-ADD     ACAGPY        #FD(1)                                        ARR24
     C                   Z-ADD     ACAGP2        #FD(2)                                        ARR24
     C                   Z-ADD     ACAGP3        #FD(3)                                        ARR24
     C                   Z-ADD     ACAGP4        #FD(4)                                        ARR24
     C                   ENDSR                                                                 ARR24
      *                                                                   ARR240
      ********                                                            ARR240
      * SUMRY                                                             ARR240
      ********                                                            ARR240
      * THIS SUBROUTINE READS THE FILE BY COMPANY                         ARR240
     C     SUMRY         BEGSR                                                                 ARR24
      *                                                                   ARR240
     C     AGAIN         TAG                                                    READ AGAIN     ARR24
     C                   READ      FAROPN                                 42    EOF            ARR24
     C   42              GOTO      SUMEND
      *                                                                   ARR240
     C     ARCOMP        IFNE      LCO                                                      #  ARR24
     C                   GOTO      AGAIN
     C                   END                                                                   ARR24
      *                                                                   ARR240
     C     ARSTAT        IFEQ      'D'                                                      #  ARR24
     C                   GOTO      AGAIN
     C                   END                                                                   ARR24
      *                                                                   ARR240
EFD  C                   ADD       AR$AMT        VARBAL           13 2          A/R TOTAL DUE  ARR24
      *                                                                   ARR240
      * ACCUMULATE CURRENT AMOUNTS                                        ARR240
      *                                                                   ARR240
     C     ARTTYP        IFEQ      01                                           INVOICE        ARR24
     C     ARTTYP        OREQ      12                                           NSF CK         ARR24
     C     ARTTYP        OREQ      14                                           CK CHRG        ARR24
     C                   ADD       1             #WKIN             6 0                         ARR24
     C                   ADD       1             VTINV             6 0                         ARR24
     C                   ENDIF                                                                 ARR24
      *                                                                   ARR240
     C     ARTTYP        IFEQ      03                                           ON ACCOUNT     ARR24
     C     ARTTYP        OREQ      11                                           DEPOSIT        ARR24
     C                   ADD       1             #WKOA             6 0                         ARR24
     C                   ADD       1             VTOA              6 0                         ARR24
     C                   ENDIF                                                                 ARR24
      *                                                                   ARR240
     C     ARTTYP        IFEQ      05                                           CREDIT MEMOS   ARR24
     C                   ADD       1             #WKCR             6 0                         ARR24
     C                   ADD       1             VTCRM             6 0                         ARR24
     C                   ENDIF                                                                 ARR24
      *                                                                   ARR240
     C     ARTTYP        IFEQ      07                                           LATE CHARGES   ARR24
     C                   ADD       1             #WKLC             6 0                         ARR24
     C                   ADD       1             VTLC              6 0                         ARR24
     C                   ENDIF                                                                 ARR24
      *                                                                   ARR240
     C                   EXSR      AGING                                                       ARR24
     C                   GOTO      AGAIN                                                       ARR24
      *                                                                   ARR240
     C     SUMEND        TAG
EFD  C*                    Z-ADD#WKAT$    VARBAL 132       A/R TOTAL DUE  ARR240
      *                                                                   ARR240
     C                   ENDSR                                                                 ARR24
      ********                                                            ARR240
      * AGING                                                             ARR240
      ********                                                            ARR240
      * DETERMINE APPROPRIATE AGING AND ACCUMULATE TOTAL                  ARR240
      *                                                                   ARR240
     C     AGING         BEGSR                                                                 ARR24
      *                                                                   ARR240
     C     *LIKE         DEFINE    AR$AMT        #WKAR$                                        ARR24
     C                   Z-ADD     AR$AMT        #WKAR$                                        ARR24
     C                   EXSR      AGDL                                                        ARR24
     C                   ADD       #PP           SCUR             10 2
     C                   ADD       #PP$          SAR
      *                                                                   ARR240
     C                   ENDSR                                                                 ARR24
      *******                                                             ARR240
      * AGDL                                                              ARR240
      *******                                                             ARR240
      *  USE THIS SUBROUTINE TO AGE ITEMS                                 ARR240
      *      SUBROUTINE ASSUMES ARRAY #FD HAS BEEN LOADED - USE #AGDY     ARR240
      *      SUBROUTINE ASSUMES FIELD #WKAOJ HAS BEEN LOADED              ARR240
      *      LOAD DUE DATE INTO FIELD ##MDY                               ARR240
      *      LOAD DOLLAR AMOUNT INTO FIELD #WKAR$                         ARR240
      *                                                                   ARR240
      * USE FIELD #WKCR$ TO PRINT TOTAL CURRENT DOLLAR AMOUNTS            ARR240
      * USE ARRAY #PD$ TO PRINT TOTAL PAST DUE AMOUNTS 1 - 5              ARR240
      *                                                                   ARR240
     C     AGDL          BEGSR                                                                 ARR24
     C                   Z-ADD     0             #PP              11 2
     C                   Z-ADD     0             #PP$
     C                   Z-ADD     ARDUDT        ##CYMD                                        ARR24
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         DUDT              6 0
      *
     C                   Z-ADD     DUDT          ##MDY
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         #WKTRJ            5 0                         ARR24
      *                                                                   ARR240
      * SUBTRACT AS OF DATE (#WKAOJ) FROM DUE DATE (#WKTRJ)               ARR240
      *                                                                   ARR240
     C     #WKTRJ        SUB       #WKAOJ        #WKTRJ                                        ARR24
     C                   Z-ADD     #WKTRJ        #WKTRR            5 0
      *                                                                   ARR240
      * ACCUMULATE FOR TOTAL BALANCE                                      ARR240
     C                   ADD       #WKAR$        #WKAT$           11 2                         ARR24
      *                                                                   ARR240
      * TEST DATE RELATIVE TO AGING DAYS - POSITIVE = FUTURE DUE          ARR240
      *                                    NEGATIVE = PAST DUE            ARR240
      *                                                                   ARR240
     C     #WKTRJ        IFGE      0                                                           ARR24
      *                                                                   ARR240
      * ACCUMULATE CURRENT AMOUNTS AND AGE FUTURE DUE
      *
     C                   ADD       #WKAR$        #WKCR$           10 2
     C                   ADD       #WKAR$        #PP
     C                   Z-ADD     1             X                 1 0
     C     #WKTRJ        LOOKUP    #FD(X)                             90  90
     C   90              ADD       #WKAR$        #FD$(X)
     C  N90              ADD       #WKAR$        #FD$(5)
     C                   ELSE
      *
      * AGE PAST DUE AMOUNTS
      *
     C                   MLLZO     1             #WKTRJ
     C                   Z-ADD     1             X
     C     #WKTRJ        LOOKUP    #FD(X)                             90  90
     C   90              ADD       #WKAR$        #PD$(X)
     C  N90              ADD       #WKAR$        #PD$(5)
     C   90              ADD       #WKAR$        #PP$(X)
     C  N90              ADD       #WKAR$        #PP$(5)
      *
     C                   ENDIF
      *
      *  AGE PAST DUE AMOUNTS                                             ARR240
      *                                                                   ARR240
EFD  C*                    MLLZO1         #WKTRJ                          ARR240
EFD  C*                    Z-ADD1         X       10                      ARR240
EFD  C*          #WKTRJ    LOKUP#FD,X                90  90               ARR240
     C*  90                ADD  #WKAR$    #PD$,X                          ARR240
     C* N90                ADD  #WKAR$    #PD$,5                          ARR240
      *                                                                   ARR240
     C     ARTTYP        IFEQ      01                                           INVOICE        ARR24
     C     ARTTYP        OREQ      12                                           NSF CK         ARR24
     C     ARTTYP        OREQ      14                                           CK CHRG        ARR24
     C   90              ADD       1             #IN(X)                                        ARR24
     C  N90              ADD       1             #IN(5)                                        ARR24
     C*                    ADD  1         VTINV            TOTAL INVOICES ARR240
     C                   ENDIF                                                                 ARR24
      *                                                                   ARR240
     C     ARTTYP        IFEQ      03                                           ON ACCOUNT     ARR24
     C     ARTTYP        OREQ      11                                           DEPOSIT        ARR24
     C   90              ADD       1             #OA(X)                                        ARR24
     C  N90              ADD       1             #OA(5)                                        ARR24
     C*                    ADD  1         VTOA             TOTAL ON ACCT  ARR240
     C                   ENDIF                                                                 ARR24
      *                                                                   ARR240
     C     ARTTYP        IFEQ      05                                           CREDIT MEMO    ARR24
     C   90              ADD       1             #CM(X)                                        ARR24
     C  N90              ADD       1             #CM(5)                                        ARR24
     C*                    ADD  1         VTCRM            TOTAL C/M      ARR240
     C                   ENDIF                                                                 ARR24
      *                                                                   ARR240
     C     ARTTYP        IFEQ      07                                           LATE CHARGES   ARR24
     C   90              ADD       1             #LC(X)                                        ARR24
     C  N90              ADD       1             #LC(5)                                        ARR24
     C*                    ADD  1         VTLC             TOTAL LATE CHRGARR240
     C                   ENDIF                                                                 ARR24
      *                                                                   ARR240
     C     ARTTYP        IFEQ      01                                                          ARR24
     C     ARTTYP        OREQ      12                                           NSF CK         ARR24
     C     ARTTYP        OREQ      14                                           CK CHRG        ARR24
     C                   ADD       #WKAR$        VTINV$           11 2                         ARR24
     C                   ENDIF                                                                 ARR24
     C     ARTTYP        IFEQ      03                                                          ARR24
     C     ARTTYP        OREQ      11                                                          ARR24
     C                   ADD       #WKAR$        VTOCT$           11 2                         ARR24
     C                   ENDIF                                                                 ARR24
     C     ARTTYP        IFEQ      05                                                          ARR24
     C                   ADD       #WKAR$        VTCRM$           11 2                         ARR24
     C                   ENDIF                                                                 ARR24
     C     ARTTYP        IFEQ      07                                                          ARR24
     C                   ADD       #WKAR$        VTLCH$           11 2                         ARR24
     C                   ENDIF                                                                 ARR24
     C     ARTTYP        IFEQ      02                                                          ARR24
     C     ARTTYP        OREQ      08                                                          ARR24
     C     ARTTYP        OREQ      10                                                          ARR24
     C     ARTTYP        OREQ      11                                                          ARR24
     C                   ADD       #WKAR$        VTOTP$           11 2                         ARR24
     C                   ADD       1             VTOTP#                                        ARR24
     C                   ENDIF                                                                 ARR24
     C     ARTTYP        IFEQ      04                                                          ARR24
     C                   ADD       #WKAR$        VTOAD$           11 2                         ARR24
     C                   ADD       1             VTOAD#                                        ARR24
     C                   ENDIF                                                                 ARR24
      *                                                                   ARR240
     C                   ENDSR                                                                 ARR24
      *                                                                   ARR240
