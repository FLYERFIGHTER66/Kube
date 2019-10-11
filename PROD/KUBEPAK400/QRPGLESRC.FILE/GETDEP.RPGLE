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
      *PROGRAM NAME-------- GETDEP
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- GET DEPOSIT/DOWNPAYMENT FOR AN ORDER.
      *                     (THIS IS A CALLED PROGRAM)
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FGETDEPFM  CF   E             WORKSTN
     FFARHST    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMBANK    IF   E           K DISK
     FFMCRED    IF   E           K DISK
     FFIORDR    UF A E           K DISK
     FFAROPN    O  A E           K DISK
     FFMTRAN    O  A E           K DISK
      *
      *MESSAGE ARRAY
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)              MESSAGE
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
     C                   MOVEA     '0'           *IN
      **************
      * START HERE *
      **************
      *** CHECK IF OK TO INPUT A DEPOSIT
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
     C     IORKEY        KLIST
     C                   KFLD                    OHORD#
     C                   KFLD                    OISEQ#
     C                   Z-ADD     994           OISEQ#
     C     IORKEY        CHAIN     FIORDR                             92
     C  N92              DO
     C                   SETON                                        02
     C                   WRITE     SCRNE
     C                   READ      SCRNE                                  90
     C                   GOTO      END
     C                   ENDDO
     C                   MOVEA     '0'           *IN
      ***************
      ** GET SCRNA **
      ***************
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** IF F6 GOTO END
     C   KF              GOTO      END
     C                   SETOFF                                       102030
     C                   SETOFF                                       404550
     C                   SETOFF                                       607071
     C                   SETOFF                                           99
      *
      ** CHECK FOR AMOUNT
     C     AMOUNT        IFLE      0.00
     C                   SETON                                        10  99
     C                   GOTO      NXTA
     C                   END
      *
      ** CHECK FOR BANK CODE
     C                   MOVEL     BANK          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       BACODE
     C                   CALL      'LKBANK'
     C                   PARM                    BACODE
     C                   PARM                    BADESC
     C                   MOVEL     *BLANKS       BANK
     C                   MOVEL     BACODE        BANK
     C                   GOTO      NXTA
     C                   ENDIF
     C     BANK          IFGT      *BLANKS
     C     BANK          CHAIN     FMBANK                             96
     C   96              DO
     C                   MOVE      *BLANKS       BADESC
     C                   SETON                                        20  99
     C                   GOTO      NXTA
     C                   ENDDO
     C                   END
      ** IF F5 GET INFO FROM ARHST
     C   KE              DO
     C     OHARCU        CHAIN     FARHST                             90
     C  N90              DO
     C     HSCRCD        IFGT      *BLANKS
     C     HSCRC#        ANDGT     0
     C                   MOVEL     HSCRCD        CARDID
     C                   Z-ADD     HSCRC#        CRCD
     C                   Z-ADD     HSCRDT        CRCE
     C                   ELSE
     C                   SETON                                        60
     C                   END
     C                   ENDDO
     C                   GOTO      NXTA
     C                   ENDDO
      ** ONE HAS TO BE SELECTED
     C     BANK          IFLE      *BLANKS
     C     CARDID        ANDLE     *BLANKS
     C                   SETON                                        71  99
     C                   GOTO      NXTA
     C                   ENDIF
      *
      ** CHECK FOR CARD ID
     C                   MOVEL     CARDID        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   CALL      'LKCRED'
     C                   PARM                    CCCODE
     C                   PARM                    CCDESC
     C                   MOVEL     *BLANKS       CARDID
     C                   MOVEL     CCCODE        CARDID
     C                   GOTO      NXTA
     C                   ENDIF
     C     CARDID        IFGT      *BLANKS
     C     CARDID        CHAIN     FMCRED                             30
     C   30              DO
     C                   SETON                                        99
     C                   MOVE      *BLANKS       CCDESC
     C                   GOTO      NXTA
     C                   ENDDO
     C                   ELSE
     C                   MOVE      *BLANKS       CCDESC
     C                   END
      ** CHECK FOR CARD NUMBER
     C     CARDID        IFGT      *BLANKS
     C     CRCD          ANDLE     0
     C                   SETON                                        40  99
     C                   GOTO      NXTA
     C                   ENDIF
      ** CHECK FOR CARD EXPIRE DATE
     C     CARDID        IFGT      *BLANKS
     C     CRCE          IFLE      0
     C                   SETON                                        45  99
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
     C                   SETON                                        45  99
     C                   END
     C                   END
     C                   END
     C   99              GOTO      NXTA
      ** CHECK FOR CARD AUTHORIZATION
     C     CARDID        IFGT      *BLANKS
     C     CRCA          ANDLE     *BLANKS
     C                   SETON                                        50  99
     C                   GOTO      NXTA
     C                   END
      ** IF HERE CHECK ONLY 1 METHOD USED
     C     CARDID        IFGT      *BLANKS
     C     BANK          ANDGT     *BLANKS
     C                   SETON                                        70  99
     C                   GOTO      NXTA
     C                   END
     C   99              GOTO      NXTA
      ** IF HERE ALL OK
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   ENDDO
     C  NKB              GOTO      NXTA
     C     CARDID        IFGT      *BLANKS
     C     CCBANK        CHAIN     FMBANK                             77
     C                   END
      *
      ** OUTPUT AROPN AND MTRAN
      *
     C                   CLEAR                   RMTRAN
     C                   CLEAR                   RAROPN
     C                   MOVEL     'A'           MTSTAT
     C                   Z-ADD     OHARCU        MTCUST
     C                   Z-ADD     OHORD#        MTINV#
     C                   MOVEL     'DP'          MTSUFF
     C                   Z-ADD     0             MTSEQ#
     C                   MOVEL     OHTYPE        MTCTYP
     C                   MOVEL     OHSLM1        MTSLM1
     C                   Z-ADD     OHSCM1        MTCOM1
     C                   MOVEL     OHSLM2        MTSLM2
     C                   Z-ADD     OHSCM2        MTCOM2
     C**                                  MTTERR
     C                   Z-ADD     OHCOMP        MTCOMP
     C                   MOVEL     '11'          MTTTYP
     C                   Z-ADD     COMDAT        MTTDAT
     C                   Z-ADD     COMDAT        MTDUDT
     C                   Z-SUB     AMOUNT        MT$AMT
     C                   Z-ADD     BAGLNO        MTGLAC
     C                   Z-ADD     OHORD#        MTORD#
     C                   Z-ADD     OHCUST        MTSHCU
     C                   Z-ADD     OHSACU        MTSACU
     C                   Z-ADD     OHBLCU        MTBLCU
     C                   MOVEL     OHALPH        MTLOOK
     C                   MOVEL     OHPOS         MTPOS
     C                   MOVEL     OHSHFR        MTSHFR
     C                   MOVEL     CHECK#        MTCHEK
     C                   Z-ADD     TDATE         MTCKDT
     C                   MOVEL     MSG(1)        MTDESC
     C                   Z-ADD     TDATE         MTDTLA
     C                   Z-ADD     TIMOD         MTTIME
     C                   MOVEL     USERID        MTUSER
     C                   MOVEL     CARDID        MTCRCD
     C                   Z-ADD     CRCD          MTCRC#
     C                   Z-ADD     CRCE          MTCRCE
     C                   MOVEL     CRCA          MTCRCA
     C                   MOVEL     OHTXJU        MTTAXJ
     C                   MOVE      OHPONO        MTPONO
     C                   MOVEL     'A'           ARSTAT
     C                   Z-ADD     OHARCU        ARCUST
     C                   Z-ADD     OHORD#        ARINV#
     C                   MOVEL     'DP'          ARSUFF
     C                   Z-ADD     0             ARSEQ#
     C                   MOVEL     OHTYPE        ARCTYP
     C                   MOVEL     OHSLM1        ARSLM1
     C                   Z-ADD     OHSCM1        ARCOM1
     C                   MOVEL     OHSLM2        ARSLM2
     C                   Z-ADD     OHSCM2        ARCOM2
     C**                                  ARTERR
     C                   Z-ADD     OHCOMP        ARCOMP
     C                   MOVEL     '11'          ARTTYP
     C                   Z-ADD     COMDAT        ARTDAT
     C                   Z-ADD     COMDAT        ARDUDT
     C                   Z-SUB     AMOUNT        AR$AMT
     C                   Z-SUB     AMOUNT        ARDUE$
     C                   Z-ADD     BAGLNO        ARGLAC
     C                   Z-ADD     OHORD#        ARORD#
     C                   Z-ADD     OHCUST        ARSHCU
     C                   Z-ADD     OHSACU        ARSACU
     C                   Z-ADD     OHBLCU        ARBLCU
     C                   MOVEL     OHALPH        ARLOOK
     C                   MOVEL     OHPOS         ARPOS
     C                   MOVE      OHPONO        ARPONO
     C                   MOVEL     OHSHFR        ARSHFR
     C                   MOVEL     CHECK#        ARCHEK
     C                   Z-ADD     TDATE         ARCKDT
     C                   MOVEL     MSG(1)        ARDESC
     C                   Z-ADD     TDATE         ARDTLA
     C                   Z-ADD     TIMOD         ARTIME
     C                   MOVEL     USERID        ARUSER
     C                   MOVEL     CARDID        ARCRCD
     C                   Z-ADD     CRCD          ARCRC#
     C                   Z-ADD     CRCE          ARCRCE
     C                   MOVEL     CRCA          ARCRCA
     C                   MOVEL     OHTXJU        ARTAXJ
      ** OUTPUT AROPN AND MTRAN
     C                   WRITE     RMTRAN
     C                   WRITE     RAROPN
      ** NOW SET UP IORDR
     C                   CLEAR                   RIORDR
     C                   MOVEL     'A'           OISTAT
     C                   Z-ADD     OHORD#        OIORD#
     C                   Z-ADD     994           OISEQ#
     C                   MOVEL     MSG(1)        OIDES1
     C                   Z-ADD     OHCOMP        OICOMP
     C                   Z-SUB     AMOUNT        OIEXT$
     C                   MOVEL     OHSHPC        OISHPC
     C                   MOVEL     OHSLM1        OISLM1
     C                   Z-ADD     OHSCM1        OICOM1
     C                   MOVEL     OHSLM2        OISLM2
     C                   Z-ADD     OHSCM2        OICOM2
     C                   Z-ADD     OHCUST        OICUST
     C                   Z-ADD     OHDTRQ        OIDTRQ
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C                   MOVEL     USERID        OIUSER
     C                   MOVEL     'S'           OIITYP
     C                   MOVEL     OHROUT        OIROUT
     C                   Z-ADD     OHSTOP        OISTOP
     C                   MOVEL     OHSHFR        OISHFR
     C                   MOVEL     OHPHYT        OIPHYT
     C                   Z-ADD     OHDTRY        OIRVDT
     C                   MOVEL     OHALPH        OIALPH
      ** OUTPUT IORDR
     C                   WRITE     RIORDR
      ** END JOB
     C     END           TAG
     C                   SETON                                        LR
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
** MESSAGE ARRAY
Downpayment/Deposit
