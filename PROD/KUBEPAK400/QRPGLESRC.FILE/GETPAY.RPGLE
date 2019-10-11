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
      *PROGRAM NAME-------- GETPAY
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- GET PAYMENTS FOR AN ORDER.
      *                     (THIS IS A CALLED PROGRAM)
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FGETPAYFM  CF   E             WORKSTN
     F                                     SFILE(PAYSFL:RECNO)
     FFARHST    IF   E           K DISK
     FFHORDR    UF   E           K DISK
     FFMBANK    IF   E           K DISK
     FFMCRED    IF   E           K DISK
     FFPAYMNT   UF A E           K DISK
      *
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
      *
      **************
      * PARMS      *
      **************
     C     *ENTRY        PLIST
     C                   PARM                    OHORD#
     C                   PARM                    INVAMT
     C                   PARM                    PAYAMT
     C                   Z-ADD     0             PAYAMT
     C                   MOVEA     '0'           *IN
      **************
      * START HERE *
      **************
      *** CHECK IF OK TO INPUT A PAYMENT
     C     OHORD#        CHAIN     FHORDR                             91
     C   91              DO
     C                   SETON                                        01
     C                   WRITE     SCRNE
     C                   READ      SCRNE                                  90
     C                   GOTO      END
     C                   ENDDO
     C     OHCOFL        IFEQ      'Y'
     C                   SETON                                        03
     C                   WRITE     SCRNE
     C                   READ      SCRNE                                  90
     C                   GOTO      END
     C                   END
     C                   MOVEA     '0'           *IN
      ****************
      * SUB FILE     *
      ****************
     C                   EXSR      BLDSFL
     C     NXTFMT        TAG
     C   99              SETOFF                                       98
     C                   EXFMT     PAYCTL
     C   KF              GOTO      END
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTFMT
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTFMT
     C                   ENDDO
     C  NKB              GOTO      NXTFMT
      ** IF HERE ALL OK
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTFMT
     C                   ENDDO
     C  NKB              GOTO      NXTFMT
      ** IF HERE OUTPUT RECORD AND END PROGRAM
     C                   EXSR      PUTSFL
      ** END JOB
     C     END           TAG
     C                   SETON                                        LR
      *************
      ** BLDSFL  **
      *************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     PAYCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             PAYAMT
     C                   Z-ADD     0             OPNAMT
     C                   Z-ADD     0             LSTSEQ            3 0
     C                   MOVEA     '0'           *IN
     C     OHORD#        SETLL     FPAYMNT
     C     NXTBLD        TAG
     C                   SETOFF                                       102030
     C                   SETOFF                                       404550
     C                   SETOFF                                       98  99
     C                   MOVE      *BLANKS       BANK
     C                   MOVE      *BLANKS       CHECK#
     C                   Z-ADD     0             PYSEQ#
     C                   MOVE      *BLANKS       CRCD
     C                   Z-ADD     0             CRC#
     C                   Z-ADD     0             CRCE
     C                   MOVEL     *BLANKS       CRCA
     C     OHORD#        READE     FPAYMNT                                90
     C   90              GOTO      ENDBLD
     C                   MOVE      *BLANKS       BADESC
     C                   MOVE      *BLANKS       CCDESC
     C     PYSEQ#        IFGT      LSTSEQ
     C                   Z-ADD     PYSEQ#        LSTSEQ
     C                   END
     C     PYSTAT        IFEQ      'D'
     C                   GOTO      NXTBLD
     C                   END
     C                   Z-SUB     PYCASH        AMOUNT
     C                   ADD       AMOUNT        PAYAMT
     C     PYBANK        IFGT      *BLANKS
     C     PYBANK        CHAIN     FMBANK                             10
     C   10              DO
     C                   MOVE      *BLANKS       BADESC
     C                   SETON                                          1199
     C                   ENDDO
     C                   MOVEL     PYBANK        BANK
     C                   MOVEL     PYCHEK        CHECK#
     C                   END
     C     PYCRCD        IFGT      *BLANKS
     C     PYCRCD        CHAIN     FMCRED                             20
     C   30              DO
     C                   SETON                                        21  99
     C                   MOVE      *BLANKS       CCDESC
     C                   ENDDO
     C                   MOVEL     PYCRCD        CRCD
     C                   Z-ADD     PYCRC#        CRC#
     C                   Z-ADD     PYCRCE        CRCE
     C                   MOVEL     PYCRCA        CRCA
     C                   END
     C                   ADD       1             RECNO
     C                   WRITE     PAYSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
      ** BUILD BLANK RECORDS
     C                   SETOFF                                       102030
     C                   SETOFF                                       404550
     C                   MOVE      *BLANKS       BANK
     C                   MOVE      *BLANKS       CCDESC
     C                   MOVE      *BLANKS       BADESC
     C                   MOVE      *BLANKS       CHECK#
     C                   Z-ADD     0             PYSEQ#
     C                   MOVE      *BLANKS       CRCD
     C                   Z-ADD     0             CRC#
     C                   Z-ADD     0             CRCE
     C                   Z-ADD     0             AMOUNT
     C                   MOVEL     *BLANKS       CRCA
     C     25            SUB       RECNO         BLANK             5 0
     C     RECNO         DOUGT     BLANK
     C                   ADD       1             RECNO
     C                   WRITE     PAYSFL
     C                   ENDDO
     C                   Z-ADD     RECNO         LSTREC            5 0
     C     INVAMT        SUB       PAYAMT        OPNAMT
     C                   ENDSR
      *************
      ** CHKSFL  **
      *************
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             PAYAMT
     C                   Z-ADD     0             OPNAMT
     C                   SETOFF                                       112131
     C                   SETOFF                                       4146
     C                   SETOFF                                       515253
     C                   SETOFF                                       456099
     C                   SETOFF                                       07
     C     NXTCHK        TAG
     C                   SETOFF                                       102030
     C                   SETOFF                                       404550
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     PAYSFL                             90
     C   90              GOTO      NXTCHK
     C     BANK          IFGT      *BLANKS
     C                   EXSR      CHKBNK
     C                   END
     C     BANK          IFLE      *BLANKS
     C     CRCD          ANDLE     *BLANKS
      ** IF F5 GET INFO FROM ARHST
     C   KE
     CANN07              DO
     C     OHARCU        CHAIN     FARHST                             90
     C  N90              DO
     C     HSCRCD        IFGT      *BLANKS
     C     HSCRC#        ANDGT     0
     C                   MOVEL     HSCRCD        CRCD
     C                   Z-ADD     HSCRC#        CRC#
     C                   Z-ADD     HSCRDT        CRCE
     C                   ELSE
     C                   SETON                                        6099
     C                   END
     C                   ENDDO
     C                   ENDDO
     C                   SETON                                        07
     C                   END
     C     CRCD          IFGT      *BLANKS
     C                   EXSR      CHKCC
     C                   END
     C     CRCD          IFGT      *BLANKS
     C     BANK          ANDGT     *BLANKS
     C                   SETON                                        102052
     C                   SETON                                        99
     C                   ENDIF
     C     AMOUNT        IFGT      0.00
     C     BANK          ANDLE     *BLANKS
     C     CRCD          ANDLE     *BLANKS
     C                   SETON                                        102053
     C                   SETON                                        99
     C                   ENDIF
     C     AMOUNT        IFLE      0.00
     C     BANK          ANDGT     *BLANKS
     C     AMOUNT        ORLE      0.00
     C     CRCD          ANDGT     *BLANKS
     C                   SETON                                        102051
     C                   SETON                                        99
     C                   ENDIF
     C                   ADD       AMOUNT        PAYAMT
     C                   UPDATE    PAYSFL
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C     PAYAMT        IFLE      0.00
     C                   SETON                                        99
     C                   ELSE
     C     INVAMT        SUB       PAYAMT        OPNAMT
     C                   END
     C                   ENDSR
      *************
      ** CHKCC   **    **CHECK FOR CARD ID
      *************
     C     CHKCC         BEGSR
     C                   MOVEL     CRCD          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   CALL      'LKCRED'
     C                   PARM                    CCCODE
     C                   PARM                    CCDESC
     C                   MOVEL     *BLANKS       CRCD
     C                   MOVEL     CCCODE        CRCD
     C                   ENDIF
     C     CRCD          CHAIN     FMCRED                             20
     C   20              DO
     C                   SETON                                        21  99
     C                   MOVE      *BLANKS       CCDESC
     C                   ENDDO
      ** CHECK FOR CARD NUMBER
     C     CRC#          IFLE      0
     C                   SETON                                        303199
     C                   ENDIF
      ** CHECK FOR CARD EXPIRE DATE
     C     CRCE          IFLE      0
     C                   SETON                                        404199
     C                   ELSE
     C                   MOVEL     CRCE          MM                2 0
     C                   MOVE      CRCE          YY                2 0
     C     MM            IFLT      12
     C                   ADD       1             MM
     C                   ELSE
     C                   Z-ADD     1             MM
     C                   ADD       1             YY
     C                   END
     C                   Z-ADD     1             MMDD              4 0
     C                   MOVEL     MM            MMDD
     C                   MOVEL     MMDD          ##MDY
     C                   MOVE      YY            ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        CRDDAT            7 0
     C     CRDDAT        IFLT      COMDAT
     C                   SETON                                        464099
     C                   END
     C                   END
     C                   ENDSR
      **************
      ** CHKBNK   **   **CHECK FOR BANK CODE
      **************
     C     CHKBNK        BEGSR
     C                   MOVEL     BANK          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       BACODE
     C                   CALL      'LKBANK'
     C                   PARM                    BACODE
     C                   PARM                    BADESC
     C                   MOVEL     *BLANKS       BANK
     C                   MOVEL     BACODE        BANK
     C                   ENDIF
     C     BANK          CHAIN     FMBANK                             96
     C   96              DO
     C                   MOVE      *BLANKS       BADESC
     C                   SETON                                        101199
     C                   ENDDO
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        COMDAT            7 0
     C                   ENDSR
      *************
      ** PUTSFL  **
      *************
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             PYSEQ#
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     PAYSFL                             90
     C   90              GOTO      NXTPUT
     C     AMOUNT        IFGT      0.00
     C     PAYKEY        KLIST
     C                   KFLD                    OHORD#
     C                   KFLD                    PYSEQ#
     C     PAYKEY        CHAIN     FPAYMNT                            77
     C   77              DO
     C                   CLEAR                   RPAYMNT
     C                   MOVEL     'A'           PYSTAT
     C                   Z-ADD     OHORD#        PYORD#
     C                   ADD       1             LSTSEQ
     C                   Z-ADD     LSTSEQ        PYSEQ#
     C                   ENDDO
     C     CRCD          IFGT      *BLANKS
     C     CRCD          CHAIN     FMCRED                             20
     C  N20              MOVEL     CCBANK        BANK
     C                   ENDIF
     C                   Z-ADD     OHCOMP        PYCOMP
     C                   Z-ADD     OHCUST        PYCUST
     C                   Z-ADD     OHDTRQ        PYDTRQ
     C                   Z-ADD     OHDTRY        PYDTRY
     C                   Z-ADD     TDATE         PYTDAT
     C                   MOVE      *BLANKS       PYIVCD
     C                   Z-ADD     TDATE         PYDTLA
     C                   Z-ADD     TIMOD         PYTIME
     C                   MOVEL     USERID        PYUSER
     C                   Z-ADD     OHARCU        PYARCU
     C                   Z-ADD     OHSACU        PYSACU
     C                   Z-ADD     OHBLCU        PYBLCU
     C                   Z-ADD     OHDTAC        PYDTAC
     C                   MOVEL     OHALPH        PYLOOK
     C                   MOVEL     OHSHFR        PYSHFR
     C                   MOVEL     OHPOS         PYPOS
     C                   Z-SUB     AMOUNT        PYCASH
     C                   MOVEL     CRCD          PYCRCD
     C                   Z-ADD     CRC#          PYCRC#
     C                   Z-ADD     CRCE          PYCRCE
     C                   MOVEL     CRCA          PYCRCA
     C                   MOVEL     BANK          PYBANK
     C                   MOVEL     CHECK#        PYCHEK
      ** OUTPUT PAYMENT RECORD
     C   77              WRITE     RPAYMNT
     C  N77              UPDATE    RPAYMNT
     C                   END
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
     C                   Z-ADD     PAYAMT        OHCASH
     C                   UPDATE    RHORDR
     C                   ENDSR
