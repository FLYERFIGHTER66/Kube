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
      *PROGRAM NAME-------- GETCARBAL
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- GET CUSTOMER A/R INTO FMCUST.
      *                     (THIS IS A CALLED PROGRAM)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMCUST    UF   E           K DISK
     FFAROPN    IF   E           K DISK
     FFARCTL    IF   E           K DISK
      *
      * AGING DATE ARRAY
     D DT              S              7  0 DIM(6) DESCEND                       DATE ARRAY
      * AGING AMOUNT ARRAY
     D AMT             S             11  2 DIM(6)                               AMOUNT ARRAY
      *
      **************
      * PARMS      *
      **************
     C     *ENTRY        PLIST
     C                   PARM                    CO                2 0
     C                   PARM                    CMCUST
     C                   PARM                    CMARB$
     C                   PARM                    CMCUR$
     C                   PARM                    CMAR1$
     C                   PARM                    CMAR2$
     C                   PARM                    CMAR3$
     C                   PARM                    CMAR4$
     C                   PARM                    CMFUT$
      **************
      * START HERE *
      **************
      ** IF LR ON NO ARCTL RECORD END JOB
     C   LR              GOTO      END
      ** GET CUST
     C     CMCUST        CHAIN     FMCUST                             91
     C                   Z-ADD     0             CMARB$
     C                   Z-ADD     0             CMCUR$
     C                   Z-ADD     0             CMAR1$
     C                   Z-ADD     0             CMAR2$
     C                   Z-ADD     0             CMAR3$
     C                   Z-ADD     0             CMAR4$
     C                   Z-ADD     0             CMFUT$
     C                   Z-ADD     0             AMT
     C   91              GOTO      END
      ** NOW GET AR
     C     CMCUST        SETLL     FAROPN
     C     NXTAR         TAG
     C     CMCUST        READE     FAROPN                                 90
     C   90              GOTO      ENDAR
     C     ARSTAT        IFEQ      'D'
     C**         ARCOMP    ORNE CO     COMPANIES ARE COMBINED
     C                   GOTO      NXTAR
     C                   END
     C                   Z-ADD     1             X                 2 0
     C     ARDUDT        LOOKUP    DT(X)                                1010
     C                   ADD       AR$AMT        AMT(X)
     C                   GOTO      NXTAR
     C     ENDAR         TAG
      ** MOVE INTO CUSTOMER BUCKETS
     C                   XFOOT     AMT           CMARB$
     C                   Z-ADD     AMT(1)        CMFUT$
     C                   Z-ADD     AMT(2)        CMCUR$
     C                   Z-ADD     AMT(3)        CMAR1$
     C                   Z-ADD     AMT(4)        CMAR2$
     C                   Z-ADD     AMT(5)        CMAR3$
     C                   Z-ADD     AMT(6)        CMAR4$
     C                   UPDATE    RMCUST
     C     END           TAG
     C                   UNLOCK    FMCUST
     C                   MOVEA     '0'           *IN
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      ** GET BUCKETS
     C     CO            CHAIN     FARCTL                             91
     C   91              DO
     C                   SETON                                        LR
     C                   GOTO      ENDINZ
     C                   ENDDO
      ** GET BUCKET DATES BASED ON ARCTL
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        DT(2)                          CURRENT
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   ADD       ACAGPY        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        DT(1)                          FUTURE
      ** ONLY THIS TIME SUBTRACT 2 TIMES TO GET RID OF PREV ADD
     C                   SUB       ACAGPY        ##DDD
     C                   SUB       ACAGPY        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        DT(3)                          1  - 30
     C                   SUB       ACAGP2        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        DT(4)                          31 - 60
     C                   SUB       ACAGP3        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        DT(5)                          61 - 90
      ** THE LAST BUCKET CONTAINS EARLIEST DATE
     C                   Z-ADD     0700101       DT(6)                          91 AND OVER
     C     ENDINZ        ENDSR
