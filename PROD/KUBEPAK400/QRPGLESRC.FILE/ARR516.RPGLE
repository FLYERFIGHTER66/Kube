      *--------------------------------------------------------------     ARR510
      *** ALSO LOOK AT ARR515 THEY ARE THE SAME REPORT **************     ARR510
      *--------------------------------------------------------------     ARR510
      *                                                                   ARR510
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001                          ARR510
      *                                                                   ARR510
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO         ARR510
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE         ARR510
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED      ARR510
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR         ARR510
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT      ARR510
      *       BY EXPRESS WRITTEN PERMISSION OF                            ARR510
      *            EFD ENTERPRISES, INC.     215-643-5352                 ARR510
      *                                                                   ARR510
      *--------------------------------------------------------------     ARR510
      *PROGRAM NAME-------- ARR516                                        ARR510
      *SYSTEM-------------- ACCOUNTS RECEIVABLE                           ARR510
      *APPLICATION--------- PRINT CUSTOMER TRANSACTIONS                   ARR510
      *                                                                   ARR510
      *            CHANGE--DATE-------DESCRIPTION                         ARR510
      *  6/28/02 EFD ADD LOGIC IF PRINT ON STATEMENT = N DO NOT PRINT.    ARR510
      *                                                                   ARR510
      *                                                                   ARR510
      *                                                                   ARR510
     FFAROPN    IF   E           K DISK
     F                                     RENAME(RAROPN:AROPNR)
     FFAROPNDD  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFCMREAS   IF   E           K DISK
     FFARCTL    IF   E           K DISK
     FARR516A   O    F  120        PRINTER OFLIND(*INOF)                        ARR510
      *                                                                   ARR510
     D #SL             S             32    DIM(6)
     D #PD$            S             11  2 DIM(3)                               PAST DUE $
     D #FD             S              5  0 DIM(2) ASCEND                        AGING DAYS ARRAY
     D MSG             S             30    DIM(15) CTDATA PERRCD(1)
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
      ************
      * LDA      *
      ************
     D                UDS
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LBCUST                 9     14  0
     D  LECUST                15     20  0
     D  LDAYS                 25     27  0
     D  OPN                   28     28
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *                                                                   ARR510
      *                                                                   ARR510
     IRMCUST
     I              CMNAME                      #WSLD1
     I              CMADD2                      #WSLD2
     I              CMADD3                      #WSLD3
     I              CMADD4                      #WSLD4
     I              CMCITY                      #WSLCT
     I              CMSTST                      #WSLST
     I              CMZIP                       #WSLZP
      ****************************************************************
      *
      *
     C     LCO           CHAIN     FARCTL                             90                       ARR51
     C                   EXSR      #STDY                                                       ARR51
      *
     C                   MOVEL     ACCOM1        ARMSG1           30                           ARR51
     C                   MOVEL     ACCOM2        ARMSG2           30                           ARR51
     C                   MOVEL     ACCOM3        ARMSG3           30                           ARR51
     C                   MOVEL     ACCOM4        ARMSG4           30                           ARR51
      *
     C                   Z-ADD     LDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        LSDATE            7 0
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RDATE             5 0
      ** GET DAY # FOR NUMBER OF DAYS OLD
     C     LDAYS         IFGT      0
     C     RDATE         SUB       LDAYS         OVDAYS            5 0
     C                   ELSE
     C                   Z-ADD     0             OVDAYS
     C                   END
      *                                                                   ARR510
      * CHECK FOR SPECIFIC CUSTOMERS
      *                                                                   ARR510
     C     LBCUST        IFGT      0                                                           ARR51
     C                   SETON                                        42
     C                   SUB       1             LBCUST
     C                   ENDIF
      *                                                                   ARR510
     C     NXTC          TAG
     C                   Z-ADD     0             PAGE
     C                   Z-ADD     0             PAGE1
     C                   Z-ADD     0             PRT               6 0
     C                   Z-ADD     1             CNT               6 0
     C                   SETOFF                                       34
     C                   ADD       1             LBCUST
     C     LECUST        IFGT      0
     C     LBCUST        ANDGT     LECUST
     C                   GOTO      END
     C                   END
      *
     C     LBCUST        IFGT      9999
     C                   GOTO      END
     C                   END
      *                                                                   ARR510
      *                                                                   ARR510
     C     LBCUST        SETLL     FAROPNDD                           91
     C   91              GOTO      NXTC
      *                                                                   ARR510
     C     NXTA          TAG
     C     LBCUST        READE     FAROPNDD                               90
     C   90              DO
     C     PRT           IFGT      0
     C*                    EXSR CRMEMO                                    ARR510
     C                   EXCEPT    TL1
     C                   ENDIF
     C                   GOTO      NXTC
     C                   ENDDO
      * SEE IF OPEN AND DO WE PRINT                                       ARR510
     C     ARSEQ#        IFEQ      0
     C     ARDUE$        IFEQ      0
     C     OPN           ANDEQ     'Y'
     C                   SETON                                        59
     C                   ELSE
     C                   SETOFF                                       59
     C                   END
     C                   END
     C   59              GOTO      NXTA
      *IF PRINT ON STATEMENT = N SKIP THIS RECORD                         ARR510
     C     ARPRST        IFEQ      'N'
     C                   GOTO      NXTA
     C                   ENDIF
      *                                                                   ARR510
     C     ARCOMP        IFNE      LCO
     C                   GOTO      NXTA
     C                   ENDIF
      *                                                                   ARR510
     C     CNT           IFEQ      1
     C                   EXSR      VALID                                                       ARR51
     C   97              GOTO      NXTC                                                        ARR51
     C     LDAYS         IFGT      0
     C                   EXSR      GETBAL                                                      ARR51
     C  N36              GOTO      NXTC                                                        ARR51
     C                   END
     C                   ENDIF
      *                                                                   ARR510
      *                                                                   ARR510
      *  PRINT ONLY IF TRANS. DATE <= TO AS OF DATE
      *                                                                   ARR510
     C*                    Z-ADDARTDAT    ##MDY   60
      *                                                                   ARR510
     C*          ARTDAT    IFGT LSDATE
     C*                    GOTO NXTA
     C*                    ENDIF
      *                                                                   ARR510
     C*  34      ARTDAT    IFLT BDATE
     C*                    GOTO NXTA
     C*                    ENDIF
      *                                                                   ARR510
     C  N34CNT           IFEQ      1
     C                   EXSR      #SLD                                                        ARR51
     C                   EXCEPT    HDG                                                         ARR51
     C                   ENDIF
      *                                                                   ARR510
     C                   EXSR      GETLN                                                       ARR51
      *                                                                   ARR510
     C                   EXSR      AGING                                                       ARR51
      *                                                                   ARR510
     C   OF              DO                                                                    ARR51
     C                   EXCEPT    HDG                                                         ARR51
     C                   ENDDO
      *                                                                   ARR510
     C                   Z-ADD     ARTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TDAT              6 0
      *                                                                   ARR510
     C                   Z-ADD     ARDUDT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         DDAT              6 0
      *
     C     ARTTYP        IFEQ      01
     C     ARTTYP        OREQ      03
     C     ARTTYP        OREQ      05
     C     ARTTYP        OREQ      07
     C     ARTTYP        OREQ      11
     C     ARTTYP        OREQ      12
     C     ARTTYP        OREQ      14
     C                   EXCEPT    DETL                                                        ARR51
     C                   ELSE
     C                   EXCEPT    DETLD
     C                   END
     C                   ADD       1             PRT
     C                   Z-ADD     ARCUST        OLCUST            6 0
     C                   ADD       1             CNT
     C                   GOTO      NXTA
      *                                                                   ARR510
     C     END           TAG                                                                   ARR51
     C**         CNT       IFGT 1
     C**                   EXCPTTL1                                       ARR510
     C**                   END
     C                   SETON                                        LR
      *                                                                   ARR510
      **********                                                          ARR510
      * VALID  *                                                          ARR510
      **********                                                          ARR510
      *  DETERMINES IF CUSTOMER SHOULD PRINT THIS CYCLE                   ARR510
      *                                                                   ARR510
     C     VALID         BEGSR                                                                 ARR51
      *                                                                   ARR510
     C     ARCUST        CHAIN     FMCUST                             97                       ARR51
     C   97              GOTO      ENDV                                                        ARR51
      *                                                                   ARR510
     C     NCODE         TAG
      *                                                                   ARR510
     C     ENDV          ENDSR                                                                 ARR51
      *                                                                   ARR510
      ***********                                                         ARR510
      * CRMEMO  *                                                         ARR510
      ***********                                                         ARR510
      *  SPREAD CREDIT MEMO AMOUNTS                                       ARR510
      *                                                                   ARR510
     C     CRMEMO        BEGSR                                                                 ARR51
      *                                                                   ARR510
     C     #PD$(3)       IFGT      *ZEROS                                                      ARR51
     C     #PD$(3)       ADD       #WKTCR        #PD$(3)                81                     ARR51
     C  N81              Z-ADD     0             #WKTCR                                        ARR51
     C   81              Z-ADD     #PD$(3)       #WKTCR                                        ARR51
     C   81              Z-ADD     0             #PD$(3)                                       ARR51
     C                   END                                                                   ARR51
      *                                                                   ARR510
     C     #PD$(2)       IFGT      *ZEROS                                                      ARR51
     C     #PD$(2)       ADD       #WKTCR        #PD$(2)                81                     ARR51
     C  N81              Z-ADD     0             #WKTCR                                        ARR51
     C   81              Z-ADD     #PD$(2)       #WKTCR                                        ARR51
     C   81              Z-ADD     0             #PD$(2)                                       ARR51
     C                   END                                                                   ARR51
      *                                                                   ARR510
     C     #PD$(1)       IFGT      *ZEROS                                                      ARR51
     C     #PD$(1)       ADD       #WKTCR        #PD$(1)                81                     ARR51
     C  N81              Z-ADD     0             #WKTCR                                        ARR51
     C   81              Z-ADD     #PD$(1)       #WKTCR                                        ARR51
     C   81              Z-ADD     0             #PD$(1)                                       ARR51
     C                   END                                                                   ARR51
      *                                                                   ARR510
     C   81              ADD       #WKTCR        #WKCR$                                        ARR51
     C                   ENDSR                                                                 ARR51
      *                                                                   ARR510
      **********                                                          ARR510
      * GETLN  *                                                          ARR510
      **********                                                          ARR510
     C     GETLN         BEGSR                                                                 ARR51
      *                                                                   ARR510
     C                   SETOFF                                       010203                   ARR51
     C                   SETOFF                                       040507                   ARR51
     C                   SETOFF                                       0809                     ARR51
      *                                                                   ARR510
      *    LOAD DESCRIPTION FIELDS                                        ARR510
      *                                                                   ARR510
     C                   MOVE      *BLANKS       DESC1                                         ARR51
     C                   MOVE      *BLANKS       DESC             11                           ARR51
      ** GET DEFAAULT FOR ADJUSTMENT
     C     ARTTYP        IFEQ      04                                                          ARR51
     C                   MOVEL     MSG(10)       DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      01                                                          ARR51
     C                   MOVEL     MSG(1)        DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      02                                                          ARR51
     C     ARTTYP        OREQ      03                                                          ARR51
     C     ARTTYP        OREQ      08                                                          ARR51
     C                   MOVEL     MSG(2)        DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      10                                                          ARR51
     C                   MOVEL     MSG(9)        DESC1            24                           ARR51
     C                   MOVE      ARCRCD        DESC1
     C                   MOVEL     DESC1         DESC
     C                   ENDIF
     C     ARTTYP        IFEQ      04                                                          ARR51
     C     ARDESC        ANDGT     *BLANKS
     C                   MOVEL     ARDESC        DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      04                                                          ARR51
     C     ARDESC        ANDEQ     *BLANKS
     C     ARREAS        ANDGT     *BLANKS
     C     RKEY          KLIST
     C                   KFLD                    LCO
     C                   KFLD                    ARREAS
     C     RKEY          CHAIN     FCMREAS                            94
     C                   MOVEL     CRDESC        DESC                                          ARR51
     C                   ENDIF
MJT01C     ARTTYP        IFEQ      04
MJT01C     ARSSUF        IFEQ      'OA'
MJT01C                   MOVEL     MSG(11)       DESC
MJT01C                   END
MJT01C     ARSSUF        IFEQ      'CM'
MJT01C                   MOVEL     MSG(12)       DESC
MJT01C                   END
MJT01C                   ENDIF
     C     ARTTYP        IFEQ      05                                                          ARR51
     C                   MOVEL     MSG(3)        DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      07                                                          ARR51
     C                   MOVEL     MSG(4)        DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      09                                                          ARR51
     C                   MOVEL     MSG(5)        DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      11                                                          ARR51
     C                   MOVEL     MSG(6)        DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      12                                                          ARR51
     C                   MOVEL     MSG(7)        DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      14                                                          ARR51
     C                   MOVEL     MSG(8)        DESC                                          ARR51
     C                   ENDIF
      *                                                                   ARR510
     C     ENDLN         ENDSR                                                                 ARR51
      **********                                                          ARR510
      * GETBAL *                                                          ARR510
      **********                                                          ARR510
     C     GETBAL        BEGSR                                                                 ARR51
     C     LBCUST        SETLL     FAROPN                                                      ARR51
     C                   SETOFF                                       3536                     ARR51
     C     NXTBAL        TAG
     C     LBCUST        READE     FAROPN                                 35                   ARR51
     C   35              GOTO      ENDBL                                                       ARR51
      * GET RID OF PAID ITEMS AND DETAIL RECS                             ARR510
     C     ARCOMP        IFNE      LCO
     C     ARSEQ#        ORNE      0
     C     ARDUE$        OREQ      0.00
     C                   GOTO      NXTBAL
     C                   ENDIF
      *                                                                   ARR510
     C                   Z-ADD     ARDUDT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##DDD         IFLE      OVDAYS
     C                   SETON                                        3536
     C                   GOTO      ENDBL
     C                   END
     C                   GOTO      NXTBAL                                                      ARR51
      *                                                                   ARR510
     C     ENDBL         ENDSR                                                                 ARR51
      *                                                                   ARR510
      *********                                                           ARR510
      * AGING *                                                           ARR510
      *********                                                           ARR510
      *    THIS LOADS THE WORK FIELDS NEEDED FOR AGING.                   ARR510
      *                                                                   ARR510
     C     AGING         BEGSR                                                                 ARR51
      *                                                                   ARR510
     C     *LIKE         DEFINE    AR$AMT        #WKAR$                                        ARR51
     C                   Z-ADD     AR$AMT        #WKAR$                                        ARR51
     C                   Z-ADD     ARDUDT        ##CYMD                                        ARR51
     C                   Z-ADD     ARTTYP        #WKTT                                         ARR51
     C                   EXSR      #STDL                                                       ARR51
     C                   ENDSR                                                                 ARR51
      **********                                                          ARR510
      * CLRFLD *                                                          ARR510
      **********                                                          ARR510
     C     CLRFLD        BEGSR                                                                 ARR51
      *                                                                   ARR510
     C                   Z-ADD     0             #WKAT$                                        ARR51
     C                   Z-ADD     *ZEROS        #PD$                                          ARR51
     C                   Z-ADD     0             #WKCR$                                        ARR51
     C                   Z-ADD     0             #WKAR$                                        ARR51
     C                   Z-ADD     0             #WKTCR                                        ARR51
     C                   Z-ADD     0             #WKPCR                                        ARR51
     C                   Z-ADD     0             #WKTT                                         ARR51
     C                   Z-ADD     0             PAGE                                          ARR51
     C                   Z-ADD     0             PAGE1                                         ARR51
     C                   ENDSR                                                                 ARR51
      *********                                                           ARR510
      * #STDY *                                                           ARR510
      *********                                                           ARR510
     C     #STDY         BEGSR
      *
      *  USE THIS SUBROUTINE TO LOAD AGING DAYS PRINT HEADINGS
      *  USE THIS SUBROUTINE FOR AGING STATEMENTS ONLY
      *
     C                   Z-ADD     ACAGPY        #WKP1             3 0
     C                   Z-ADD     ACAGP2        #WKP2             3 0
     C                   Z-ADD     1             #WKP0             3 0
     C     #WKP1         ADD       1             #WKP1A            3 0
     C                   Z-ADD     ACAGPY        #FD(1)
     C                   Z-ADD     ACAGP2        #FD(2)
      *
     C                   ENDSR
      *********                                                           ARR510
      * #STDL *                                                           ARR510
      *********                                                           ARR510
     C     #STDL         BEGSR
      *
      *  USE THIS SUBROUTINE TO AGE ITEMS FOR STATEMENT PRINT ONLY
      *  SUBROUTINE ASSUMES ARRAY #FD HAS BEEN LOADED - USE #STDY
      *  SUBROUTINE ASSUMES FIELD #WKAOJ HAS BEEN LOADED
      *  LOAD DUE DATE INTO FIELD ##MDY
      *  LOAD TRANS TYPE INTO FIELD #WKTT
      *  LOAD DOLLAR AMOUNT INTO FIELD #WKAR$
      *  #WKAR$ MUST BE DEFINED IN PGM
      *  USE FIELD #WKCR$ TO PRINT TOTAL CURRENT DOLLAR AMOUNTS
      *  USE ARRAY #PD$ TO PRINT TOTAL PAST DUE AMOUNTS 1 - 3
      *
     C                   MOVE      'P'           #WKCP             1
     C                   MOVE      #WKTT         #WKTT             2 0
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         #WKTRJ            5 0
      *
      *  SUBTRACT AS OF DATE (RDATE) FROM DUE DATE (#WKTRJ)
      *
     C     #WKTRJ        SUB       RDATE         #WKTRJ
      *
      *  ACCUMULATE FOR TOTAL BALANCE
      *
     C                   ADD       #WKAR$        #WKAT$           11 2
      *
      *  INITIALIZE CONTINUATION FLAG FOR AGING ON ACCOUNT AND LATE
      *  CHARGE TRANSACTION TYPES PLUS ANY TRANSACTIONS SUBORDINATE TO
      *  THESE TRANSACTIONS
      *
     C     #WKTT         IFEQ      01
     C                   MOVE      ' '           #WKCON            1
     C                   END
     C     #WKTT         IFEQ      03
     C                   MOVE      'Y'           #WKCON                         ON ACCT
     C                   END
     C     #WKTT         IFEQ      05
     C                   MOVE      ' '           #WKCON
     C                   END
     C*          #WKTT     IFEQ 07                         LATE CHRGS
     C*                    MOVE 'Y'       #WKCON
     C*                    END
      *
      *  IF CONTINUATION FLAG IS 'Y' FORCE AGING INTO CURRENT AMOUNT
      *
     C     #WKCON        IFEQ      'Y'
     C                   Z-ADD     0             #WKTRJ
     C                   END
      *
      *  TEST DATE RELATIVE TO AGING DAYS - POSITIVE = FUTURE DUE
      *                                     NEGATIVE = PAST DUE
      *
     C     #WKTRJ        IFGE      0
     C                   MOVE      'C'           #WKCP
     C*                    END
      *
      *  ACCUMULATE FOR ALL TRANSACTIONS EXCEPT CREDIT MEMOS
      *
     C     #WKTT         IFNE      05
      *  ACCUMULATE CURRENT AMOUNTS
     C                   ADD       #WKAR$        #WKCR$           11 2
     C                   ELSE
     C                   ADD       #WKAR$        #WKTCR           11 2
     C                   END
     C                   ELSE
      *
      *  AGE PAST DUE AMOUNTS
      *
     C     #WKTT         IFNE      05
     C                   MLLZO     1             #WKTRJ
     C                   Z-ADD     1             X                 1 0
     C     #WKTRJ        LOOKUP    #FD(X)                             90  90
     C   90              ADD       #WKAR$        #PD$(X)
     C  N90              ADD       #WKAR$        #PD$(3)
     C                   ELSE
     C                   ADD       #WKAR$        #WKTCR
     C                   ADD       #WKAR$        #WKPCR           11 2
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      ***********
      * #SLD    *
      ***********
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE SOLD TO
      *  ADDRESS.  WORK FIELDS ARE DEFINED AS:
      *
      *                 WORK  = CITY,STATE,ZIP(9 DIGIT)
      *                 WORK1 = CITY, STATE
      *                 WORK2 = ZIP CODE(XXXXX-XXXX)
      *                 WORK3 = STANDARD ZIP CODE(XXXXX)
      *                 WORK4 = ADDITIONAL ZIP CODE(-XXXX)
      *
      *  THE SUBROUTINE REQUIRES MOVING NAME AND ADDRESS INFORMATION TO
      *  BE CONDENSED TO A DATA STRUCTURE
      *
     C     #SLD          BEGSR
      *
     C                   MOVE      *BLANKS       #SL
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WSLD1        #SL(#X)
     C                   ADD       1             #X
     C     #WSLD2        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD1
     C                   MOVEL     #WSLD2        #SL(#X)
     C                   ADD       1             #X
     C     #SLD1         TAG
     C     #WSLD3        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD2
     C                   MOVEL     #WSLD3        #SL(#X)
     C                   ADD       1             #X
     C     #SLD2         TAG
     C     #WSLD4        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD3
     C                   MOVEL     #WSLD4        #SL(#X)
     C                   ADD       1             #X
     C     #SLD3         TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WSLCT        CAT       #WSLST:1      WORK1
     C                   MOVEL     #WSLZP        WORK3
     C                   MOVE      #WSLZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SL(#X)
     C                   SETOFF                                       919293
     C                   ADD       1             #X
     C                   MOVEL     CMCOUN        #SL(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *****************                                                   ARR510
      * PRINT REPORT  *
      *****************                                                   ARR510
     OARR516A   E            HDG            1 03                                ARR510
     O                                            6 'ARR516'
     O                                           53 'Customer Balance Report'
     O                                           74 'Page'                      ARR510
     O                       PAGE1         Z     79                             ARR510
     O          E            HDG            2                                   ARR510
     O                                           13 'Requested by:'
     O                       USERID              24
     O                                           40 'As Of:'
     O                       LDATE         Y     49                             ARR510
     O          E            HDG            2                                   ARR510
     O                                           24 'Customer Number:'
     O                       CMCUST        Z     31                             ARR510
     O          E            HDG            1                                   ARR510
     O                       #SL(1)              40                             ARR510
     O                                           53 'Contact:'
     O                       CMCNAM              84
     O          E            HDG            1                                   ARR510
     O                       #SL(2)              40                             ARR510
     O                                           53 'Phone #:'
     O                       CMPHON              66 '   -   -    '
     O          E            HDG            1                                   ARR510
     O                       #SL(3)              40                             ARR510
     O                       ARMSG1              71                             ARR510
     O          E            HDG            1                                   ARR510
     O                       #SL(4)              40                             ARR510
     O                       ARMSG2              71                             ARR510
     O          E            HDG            1                                   ARR510
     O                       #SL(5)              40                             ARR510
     O                       ARMSG3              71                             ARR510
     O          E            HDG            2                                   ARR510
     O                       #SL(6)              40                             ARR510
     O                       ARMSG4              71                             ARR510
     O          E            HDG            1
     O                                           38 '------Dates------'         ARR510
     O          E            HDG            0
     O                                            9 'Invoice #'                 ARR510
     O                                           21 'Type       '               ARR510
     O                                           28 'Trans '                    ARR510
     O                                           37 'Due  '                     ARR510
     O                                           48 'Check Num.'
     O                                           63 'Amount '                   ARR510
     O                                           78 'Amount Due'
     O          E            HDG            1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O          E            DETL           1                                   ARR510
     O                       ARINV#        Z      7                             ARR510
     O                       ARSUFF               9                             ARR510
     O                       DESC                21                             ARR510
     O                       TDAT          Y     28                             ARR510
     O                       DDAT          Y     37                             ARR510
     O                       ARCHEK         B    48
     O                       AR$AMT        K     63                             ARR510
     O                       ARDUE$        K     78
     O          E            DETLD          1                                   ARR510
     O                       ARINV#        Z      7                             ARR510
     O                       ARSUFF               9                             ARR510
     O                       DESC                21                             ARR510
     O                       TDAT          Y     28                             ARR510
     O*****                    DDAT  Y   37                               ARR510
     O                       ARCHEK         B    48
     O                       AR$AMT        K     63                             ARR510
     O          E            TL1         2  2                                   ARR510
     O                                           14 'Current'
     O                       #WKP0         3     21                             ARR510
     O                                           22 '-'                         ARR510
     O                       #WKP1         Z     25                             ARR510
     O                       #WKP1A        3     35                             ARR510
     O                                           36 '-'                         ARR510
     O                       #WKP2         Z     39                             ARR510
     O                                           48 'OVER'                      ARR510
     O                       #WKP2         Z     52                             ARR510
     O                                           66 'Total Due'
     O          E            TL1            1                                   ARR510
     O                       #WKAT$        KB    67                             ARR510
     O                       #PD$(3)       KB    53                             ARR510
     O                       #PD$(2)       KB    41                             ARR510
     O                       #PD$(1)       KB    28                             ARR510
     O                       #WKCR$        KB    15                             ARR510
      *
**
Invoice                                     1
Payment                                     2
Credit Memo                                 3
Late Charge                                 4
Discount                                    5
Deposit                                     6
Ret Check                              7
Ret Chk Cg                     8
C.C. Pay                        9
Adjustment                                 10
O/A Pay                                    11
Apy. C/M                                   12
