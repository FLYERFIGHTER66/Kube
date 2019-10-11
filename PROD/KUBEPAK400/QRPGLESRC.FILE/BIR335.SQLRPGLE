      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 2001
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
      **PROGRAM NAME-------- BIR335  - INVOICE PRINT NO PROCESS
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **APPLICATION--------- ORDER PROCESSING
      **DESCRIPTION--------- THIS PROGRAM WILL PRINT ACTIVE ORDER
      **                     HEADER RECORDS THAT ARE TO BE RELEASED. IT
      **                     DOES NOT UPDATE ANY FILES.
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFHORDRR   IF   E           K DISK
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
      ****************
      *   LDA        *
      ****************
     D                UDS
      ** COMPANY
     D  LDACOP                 1      2  0
      ** REPRINT Y/N
     D  LDARPT                 3      3
      ** JOBQ Y/N
     D  LDAJBQ                 4      4
      ** ROUTE I.D.
     D  LDARTE                 5      6
      ** ROUTE ALL
     D  LDAALL                 7      9
      ** BEGINING INVOICE NUMBER (REPRINT)
     D  LBINV                 10     15  0
      ** ENDING INVOICE NUMBER (REPRINT)
     D  LEINV                 16     21  0
      ** FORM NUMBER
     D**                                     21  30 LFORM
      ** PRINTER I.D.
     D  LPRTR                 31     40
      ** INVOICE DATE
     D  LDATE                 41     46  0
      ** SHIP FROM LOCATION
     D  LSHFR                 47     49
      ** BEGINING ORDER NUMBER
     D**                                     50  550LBORD
      ** ENDING ORDER NUMBER
     D**                                     56  610LEORD
      ** CANCEL  X=CANCEL
     D  LCANCL                62     62
      ** POINT OF SALE INVOICE Y/N
     D  LPOS                  63     63
      ** IMMEDIATE PRINT  Y/N
     D  LIMED                 64     64
      ** OPTION
     D  OPTION                65     65  0
      ** Confirming User to Process
     D  LUSER                 66     75
      /Free
         dcl-s CUSER like(LUSER);
      /End-Free
      *
      *  GET TIME
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     TDATE         MULT      10000.01      RDATE             6 0
     C                   MOVEL     RDATE         YY                2 0
     C     YY            IFGT      70
     C                   MOVEL     19            NDATE             2 0          19
     C                   ELSE
     C                   MOVEL     20            NDATE
     C                   ENDIF
     C                   MOVEL     NDATE         SDATE             8 0          19
     C                   MOVE      RDATE         SDATE                          19990815
     C                   MOVE      *BLANKS       LCANCL
     C                   Z-ADD     999999        LBINV
     C                   Z-ADD     0             LEINV
     C                   Z-ADD     0             LBORD             6 0
      *
     C     HKEY          KLIST
     C                   KFLD                    CODE
     C                   KFLD                    LDACOP
     C                   KFLD                    LBORD
     C                   MOVE      'R'           CODE              1
     C     HKEY          SETLL     FHORDRR
     C     NXT           TAG
     C                   READ      FHORDRR                                90
     C   90              GOTO      END
      ** IF OHHOLD NOT EQUAL R GOTO END
     C     OHHOLD        IFNE      'R'
     C                   GOTO      END
     C                   END
      ** CHECK FOR SPECIFIC USER IF SPECIFIED
     C     LUSER         IFNE      *BLANKS
      /Free
         Exec SQL  //  Get User from FPPO
           SELECT POCONF into :CUser FROM FPPO WHERE POORD#=:OHORD#;
      /End-Free
     C                   If        LUSER <> CUSER
     C                   GOTO      NXT
     C                   ENDIF
     C                   ENDIF
     C*
      *
      * CHECK OPTION FOR INVOICES WANTED
      * 1=ONLY UNPRINTED
      * 2=PRINTED AND UNPRINTED
      * 3=ONLY PRINTED
     C     OPTION        IFEQ      1
     C     OHINV#        ANDGT     0
     C                   GOTO      NXT
     C                   ENDIF
     C     OPTION        IFEQ      3
     C     OHINV#        ANDLE     0
     C                   GOTO      NXT
     C                   ENDIF
      *  GET INVOICE DATA
     C     OHINV#        IFLE      0
     C                   MOVEL     ' '           LIMED
     C                   Z-ADD     OHORD#        VORDER            6 0
     C                   Z-ADD     VORDER        LEORD
     C                   Z-ADD     LDATE         NWDATE            6 0
     C                   MOVEL     OHIMED        LIMED
     C                   CALL      'BIR440I'
     C                   PARM                    OHCOMP
     C                   PARM                    NWDATE
     C                   PARM                    VORDER
     C                   PARM                    LEORD             6 0
     C                   PARM                    LIMED             1
     C                   PARM                    OHINV#
     C                   END                                                    OHINV#<=0
      * GET BEGIN AND END INVOICE NUMBERS
     C     OHINV#        IFGT      LEINV
     C                   Z-ADD     OHINV#        LEINV
     C                   END
     C     OHINV#        IFLT      LBINV
     C                   Z-ADD     OHINV#        LBINV
     C                   END
     C                   GOTO      NXT
      *
     C     END           TAG
     C     LBINV         IFEQ      999999
     C                   MOVEL     'X'           LCANCL
     C                   END
     C                   SETON                                        LR
      *
