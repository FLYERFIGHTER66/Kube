      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      *PROGRAM NAME-------- QPK140
      *SYSTEM-------------- TGMS
      *APPLICATION--------- UPDATE PRICES BY LIST CODE PROMPT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FQPK140FM  CF   E             WORKSTN
     FFLISTCD   IF   E           K DISK
     FFMINVTLS  UF   E           K DISK
     FFIORDISC  UF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFHORDRCSTMIF   E           K DISK
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
      **************
      * LDA        *
      **************
     D                UDS
     D  LLIST                  1      4
     D  LCANCL               133    133
      *
      * SCREEN A
      ** SETOF INDICATORS AND SET DEFAULTS
     C                   SETOFF                                       102030
     C                   SETOFF                                       999798
     C                   MOVE      *BLANKS       VLIST
     C                   MOVE      *BLANKS       OLIST             4
     C                   MOVEL     'Y'           UPDORD
     C                   MOVEL     'Y'           OPDORD            1
     C                   Z-ADD     TDATE         REQDAT
     C                   Z-ADD     TDATE         ORQDAT            6 0
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   SETOFF                                       97
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
      ** SETOF INDICATORS
     C                   SETOFF                                       102030
     C                   SETOFF                                       99
      ** CHECK LIST CODE
     C                   MOVEL     VLIST         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     VLIST         LCCODE
     C                   CALL      'LKLIST'
     C                   PARM                    LCCODE
     C                   PARM                    LCDESC           30
     C                   MOVEL     *BLANKS       VLIST
     C                   MOVEL     LCCODE        VLIST
     C                   GOTO      NXTA
     C                   END
      ** SEE IF VALID
     C     VLIST         IFGT      *BLANKS
     C     VLIST         CHAIN     FLISTCD                            10
     C   10              DO
     C                   SETON                                        99
     C                   GOTO      NXTA
     C                   ENDDO
     C                   END
      ** CHECK UPDATE ORDERS
     C     UPDORD        IFNE      'Y'
     C     UPDORD        ANDNE     'N'
     C                   SETON                                        2099
     C                   GOTO      NXTA
     C                   END
      ** IF UPDORD = N ZERO DATE
     C     UPDORD        IFEQ      'N'
     C                   Z-ADD     0             REQDAT
     C                   END
      ** IF UPDORD = Y CHECK FOR VALID DATE
     C     UPDORD        IFEQ      'Y'
     C                   Z-ADD     REQDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        30  99
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     ##CYMD        STRDAT            7 0
     C                   END                                                    UPDORD = Y
      ** IF HERE ALL OK CHECK IF CHANGED
     C     UPDORD        IFNE      OPDORD
     C     REQDAT        ORNE      ORQDAT
     C     VLIST         ORNE      OLIST
     C                   SETOFF                                       98
     C                   MOVEL     UPDORD        OPDORD
     C                   Z-ADD     REQDAT        ORQDAT
     C                   MOVEL     VLIST         OLIST
     C                   ENDIF
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   END
      ** IF NOT F4         GO BACK TO SCREEN
     C  NKD              GOTO      NXTA
      ** DISPLAY SCREEN AND UPDATE FILES
     C                   SETON                                        97
     C                   SETOFF                                       98
     C                   WRITE     SCRNA
     C                   EXSR      UPDAT
      *
     C                   Call      'ICR016'
      *
      * END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      *
      ***********************
      ** UPDATE FILES      **
      ***********************
     C     UPDAT         BEGSR
     C     VLIST         SETLL     FLISTCD
     C     NXTUPD        TAG
     C                   READ      FLISTCD                                90
     C   90              GOTO      ENDUPD
     C     VLIST         IFGT      *BLANKS
     C     VLIST         ANDNE     LCCODE
     C                   GOTO      ENDUPD
     C                   END
      ** GET MINVT RECORDS
     C     LCCODE        SETLL     FMINVTLS
     C     NXTMIN        TAG
     C     LCCODE        READE     FMINVTLS                               91
     C   91              GOTO      NXTUPD
     C                   Z-ADD     LCSEL1        IMSEL1
     C                   Z-ADD     LCSEL2        IMSEL2
     C                   Z-ADD     LCSEL3        IMSEL3
     C                   Z-ADD     LCSEL4        IMSEL4
     C                   Z-ADD     LCSEL5        IMSEL5
     C                   Z-ADD     TDATE         IMDTLA
     C                   Z-ADD     TIMOD         IMTIME
     C                   MOVEL     'QPK140  '    IMUSER
     C                   UPDATE    RMINVT
     C     UPDORD        IFEQ      'N'
     C                   GOTO      NXTMIN
     C                   END
      ** IF HERE UPDATE ORDERS
     C     ORDKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    STRDAT
     C     ORDTST        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C     ORDKEY        SETLL     FIORDISC
     C     NXTORD        TAG
     C     ORDTST        READE     FIORDISC                               92
     C   92              GOTO      NXTMIN
     C     OIORD#        CHAIN     FHORDR                             93
     C   93              GOTO      NXTORD
     C     OISTAT        IFEQ      'D'
     C     OICOFL        OREQ      'Y'
     C     OIOVER        OREQ      'Y'
     C                   GOTO      NXTORD
     C                   ENDIF
     C     OHORD#        SETLL     FHORDRCSTM                             92
     C                   If        %Equal(FHORDRCSTM)
     C                   GOTO      NXTORD
     C                   ENDIF
     C                   MOVE      *BLANKS       ORDD              1
     C                   Z-ADD     0             VOLDSC            4 2
     C     OIQORD        SUB       OIQSHP        QTYORD            8 1
     C                   Z-ADD     OIUPRI        #OPRC             9 4
     C                   CALL      '#PRICE'
     C                   PARM                    OHBLCU
     C                   PARM                    OIITEM
     C                   PARM                    OISIZE
     C                   PARM                    OIWHSE
     C                   PARM                    OIUUOM
     C                   PARM                    QTYORD
     C                   PARM                    OHPRCD
     C                   PARM                    #OPRC
     C                   PARM                    OIQDDC
     C                   PARM                    OICTCD
     C                   PARM                    VOLDSC
     C                   PARM                    OIFRQD
     C                   PARM                    OHORD#
     C                   PARM                    ORDD              1
     C                   Z-ADD     #OPRC         OIUPRI
      *
     C     QTYORD        MULT(H)   #OPRC         OIEXT$
     C                   UPDATE    RIORDR
     C                   GOTO      NXTORD
      *
     C     ENDUPD        ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
