      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 2000
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC       ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES INC.      215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- FXARDUDT
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- FIX DUE DATE
      *DESCRIPTION--------- FIX DUE DATE ON OPEN INVOICES
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFAROPN    UP   E           K DISK
     FFHORDW    IF   E           K DISK
     FFMTERM    IF   E           K DISK
      *
      *
     C     ARTTYP        IFNE      01                                           NOT INVOICE
     C                   GOTO      END
     C                   END
      *
     C     ARDUE$        IFEQ      *ZEROS                                       NOT OPEN
     C                   GOTO      END
     C                   END
      *
     C     ARINV#        CHAIN     FHORDW                             50
     C     *IN50         IFEQ      '1'
     C                   GOTO      END
     C                   END
      *
     C                   EXSR      CALDT
      *
     C     CHGDT         IFEQ      'N'
     C                   GOTO      END
     C                   END
      *
      *
     C                   Z-ADD     DUEDTC        ARDUDT
     C                   Z-ADD     CSHDUC        ARDCDT
     C                   EXCEPT    UPD001
      *
      *
     C     END           TAG
     *******************************************************************
     C     CALDT         BEGSR
      *
      *** SETUP DIFFERENT FIELD NAMES
     C                   Z-ADD     ARTDAT        LDATEC            7 0
     C                   Z-ADD     ARTDAT        ##CYMD                         TRANS DATE
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   MOVE      'N'           CHGDT             1
     C                   GOTO      ECALDT
     C                   END
     C                   MOVE      'Y'           CHGDT             1
     C                   Z-ADD     ##MDY         LDATE             6 0          INVOICE DATE
      ***
      *
      *            DETERMINE TYPE OF TERMS
     C                   MOVEL     WHTMCD        TERMCD            2
     C     TERMCD        CHAIN     FMTERM                             75
     C  N75              SETON                                        79
     C                   SETOFF                                       79
     C   75              GOTO      CALDT1
      *
     C     TCTRTP        COMP      1                                      21
     C     TCTRTP        COMP      2                                      22
     C     TCTRTP        COMP      3                                      23
     C   21
     COR 22
     COR 23              MOVE      TCTRAT        #DISWK
     C   21              GOTO      TYP01
     C   22              GOTO      TYP02
     C   23              GOTO      TYP03
      *
     C     CALDT1        TAG
     C                   Z-ADD     LDATEC        DUEDTC            7 0
     C                   MOVE      LDATE         DUEDTE
     C                   MOVE      LDATE         CSHDUE
     C                   Z-ADD     LDATEC        CSHDUC            7 0
     C                   MOVE      *ZEROS        #DISWK            4 4
     C                   GOTO      ECALDT
      *
      *            CALCULATE FOR TERMS TYPE '1'
      *
     C     TYP01         TAG
     C                   Z-ADD     LDATEC        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DTNUMB            5 0
     C                   ADD       TCTDAS        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   MOVE      ##MDY         DUEDTE            6 0
     C                   Z-ADD     ##CYMD        DUEDTC
      *  CALCULATE DISCOUNT DUE DATE.
      *
     C                   ADD       TCTDAY        DTNUMB
     C                   Z-ADD     DTNUMB        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   MOVE      ##MDY         CSHDUE            6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        CSHDUC
     C                   GOTO      ECALDT
      *
      * CALCULATE TERMS TYPE '2'
      *
     C     TYP02         TAG
      *
      * GET CURRENT DAY OF MONTH FOR CUTOFF TEST
      *
     C                   MOVEL     LDATE         #WMMDD            4 0
     C                   MOVEL     #WMMDD        #WMM              2 0
     C                   MOVE      #WMMDD        #WDD              2 0
     C                   MOVE      LDATE         #WYY              2 0
      *
      * TEST TO SEE IF LESS THAN OR EQUAL TO CUTOFF DATE
      *
     C     #WDD          COMP      TCCUTO                               2828
     C   28#WMM          ADD       TCMBCO        #WMM
     C  N28#WMM          ADD       TCMACO        #WMM
      *
      * TEST TO SEE IF MONTHS EXCEEDS 12
      *
     C     #WMM          COMP      12                                 27
     C   27#WMM          SUB       12            #WMM
     C   27#WYY          ADD       1             #WYY
      *
     C                   MOVEL     #WMM          #WMMDD
     C   28              MOVE      TCNBCO        #WMMDD
     C  N28              MOVE      TCNACO        #WMMDD
     C                   MOVEL     #WMMDD        DUEDTE
     C                   MOVE      #WYY          DUEDTE
     C                   Z-ADD     DUEDTE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        DUEDTC
      *
      * CALCULATE DISCOUNT DUE DATE
      *
     C   28TCDBCO        COMP      *ZEROS                                 29
     C  N28TCDACO        COMP      *ZEROS                                 29
     C   29              MOVE      LDATE         CSHDUE
     C   28
     CANN29              MOVE      TCDBCO        #WMMDD
     C  N28
     CANN29              MOVE      TCDACO        #WMMDD
     C  N29              MOVEL     #WMMDD        CSHDUE
     C  N29              MOVE      #WYY          CSHDUE
     C                   Z-ADD     CSHDUE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        CSHDUC
     C                   GOTO      ECALDT
      *
      * CALCULATE TERMS TYPE '3'
      *
     C     TYP03         TAG
      *
     C                   MOVE      TCNDUE        DUEDTE
      *
     C     TCDDUE        COMP      *ZEROS                                 29
     C   29              MOVE      LDATE         CSHDUE
     C  N29              MOVE      TCDDUE        CSHDUE
     C                   Z-ADD     DUEDTE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        DUEDTC
     C                   Z-ADD     CSHDUE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        CSHDUC
      *
     C     ECALDT        ENDSR
      *
     ORAROPN    E            UPD001
     O                       ARDUDT
     O                       ARDCDT
