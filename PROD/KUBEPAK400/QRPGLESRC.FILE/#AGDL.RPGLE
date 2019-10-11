      ** ARRAYS
     D #PP$            S             11  2 DIM(5)                               PRINT LINE $
     D #PD$            S             11  2 DIM(5)                               PAST DUE $
     D #FD$            S             11  2 DIM(5)                               FUTURE DUE $
     D #FD             S              5  0 DIM(4) ASCEND                        AGING DAYS ARRAY
      ** START HERE
     C     ENTRY         PLIST
     C                   PARM                    #PP$                           PRINT LINE $
     C                   PARM                    #PD$                           PAST DUE $
     C                   PARM                    #FD$                           FUTURE DUE $
     C                   PARM                    #FD                            AG. DAYS ARRAY
     C                   PARM                    #PP              11 2          CURR $ AMT
     C                   PARM                    #WKAR$           11 2          $ AMT
     C                   PARM                    #WKAOJ            5 0          AS OF ##DDD
     C                   PARM                    #DUEDT            6 0          DUE DATE
     C                   PARM                    #WKCR$           11 2          TOT CUR $
     C                   PARM                    ##ERR             1            ERROR IF = Y
      *
      *  USE THIS SUBROUTINE TO AGE ITEMS
      *       SUBROUTINE ASSUMES ARRAY #FD HAS BEEN LOADED - USE #AGDY
      *       LOAD DUE DATE INTO FIELD #DUEDT  MMDDYY
      *       LOAD AS OF DATE INTO FIELD #WKAOJ  ##DDD(DAY OF CENT)
      *       LOAD DOLLAR AMOUNT INTO FIELD #WKAR$
      *
      *       USE FIELD #PP TO PRINT CURRENT DOLLAR AMOUNTS
      *       USE ARRAY #PP$ TO PRINT PAST DUE AMOUNTS 1 - 5
      *       USE FIELD #WKCR$ TO PRINT TOTAL CURRENT DOLLAR AMOUNTS
      *       USE ARRAY #PD$ TO PRINT TOTAL PAST DUE AMOUNTS 1 - 5
      *       USE ARRAY #FD$ TO FUTURE AGE THE CURRENT AMOUNT
      *
     C                   MOVE      *BLANKS       ##ERR
     C                   Z-ADD     0             #PP              11 2
     C                   Z-ADD     *ZEROS        #PP$
     C                   Z-ADD     #DUEDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   GOTO      END
     C                   END
      *
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
      *
     C                   Z-ADD     ##DDD         #WKTRJ            5 0
      *
      *  SUBTRACT AS OF DATE (JULIAN) FROM DUE DATE (JULIAN)
      *
     C     #WKTRJ        SUB       #WKAOJ        #WKTRJ
     C                   Z-ADD     #WKTRJ        #WKTRR            5 0
      *
      *  ACCUMULATE FOR TOTAL BALANCE
     C                   ADD       #WKAR$        #WKAT$           11 2
      *
      *  TEST DATE RELATIVE TO AGING DAYS - POSITIVE = FUTURE DUE
      *                                     NEGATIVE = PAST DUE
      *
     C     #WKTRJ        IFGE      0
      *
      *  ACCUMULATE CURRENT AMOUNTS AND AGE FUTURE DUE
      *
     C                   ADD       #WKAR$        #WKCR$           11 2
     C                   ADD       #WKAR$        #PP
     C                   Z-ADD     1             X                 1 0
     C     #WKTRJ        LOOKUP    #FD(X)                             90  90
     C   90              ADD       #WKAR$        #FD$(X)
     C  N90              ADD       #WKAR$        #FD$(5)
     C                   ELSE
      *
      *  AGE PAST DUE AMOUNTS
      *
     C                   MLLZO     1             #WKTRJ
     C                   Z-ADD     1             X
     C     #WKTRJ        LOOKUP    #FD(X)                             90  90
     C   90              ADD       #WKAR$        #PD$(X)
     C  N90              ADD       #WKAR$        #PD$(5)
     C   90              ADD       #WKAR$        #PP$(X)
     C  N90              ADD       #WKAR$        #PP$(5)
      *
     C                   END
      *
     C     END           TAG
     C                   SETON                                        LR
