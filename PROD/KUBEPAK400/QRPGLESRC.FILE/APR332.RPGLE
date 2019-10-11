      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  .  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- APR332
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- PRINT CHECKS
      *DESCRIPTION-         REBUILD TOPAY AFTER A CHECK JAM
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *   *************************************************************
      *   ****** NOTE IF YOU MAKE CHANGES HERE DO THE SAME IN APR331 **
      *   *************************************************************
      *
      *
      *
     FAPR331FM  CF   E             WORKSTN
     FFTOPAY    UF   E           K DISK
     FFTOPAYCK  IF   E           K DISK
     F                                     RENAME(RTOPAY:PAYCHK)
     FFAPCTL    UF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFAPREC    IF   E           K DISK
     FFAPCHK    UF A E           K DISK
      *
      * Description array
     D MSG             S             30    DIM(3) CTDATA PERRCD(1)
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LCO                    1      2  0
     D  LPROG                 29     36
     D  LNAME                 37     60
     D  LDATE                 61     66  0
     D  LCHECK                67     72  0
     D  LVOID                 73     74  0
     D  LRERUN                76     76
     D  LPRTR1                81     90
     D  LPRTR2               100    109
     D  LCOPY                114    115  0
     D  LJOB                 116    116
     D  LHOLD                117    120
     D  LSAVE                121    124
     D  LCANCL               133    133
     D  JAMRCV               150    150
      * FIRST CHECK IN CURRENT RUN
     D  FSTCHK               151    156  0
      * LAST CHECK IN CURRENT RUN
     D  LSTCHK               157    162  0
     D  LFORM1               163    172
     D  LFORM2               173    182
      * LAST GOOD CHECK PRINTED
     D  LSTGDC               183    188  0
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVE      *BLANKS       LCANCL
      * CLEAR OLD NUMBERS FROM CHECK FILES
     C                   EXSR      DELOLD
     C     VEND          SETLL     FTOPAY
      ** GET NUMBER OF STUB LINES
     C     LCO           CHAIN(N)  FAPCTL                             90
     C     AZSTBL        IFLE      0
     C                   Z-ADD     7             AZSTBL
     C                   END
      *
     C                   Z-ADD     1             CNT               6 0
     C                   MOVEL     'N'           OVER              1
      *
     C                   Z-ADD     LCHECK        CHKNUM            6 0
     C                   Z-ADD     LCHECK        BEGNUM            6 0
      *
      * CREATE VOID CHECKS IN APCHK
      *
     C     LVOID         IFEQ      0
     C                   GOTO      NOVOID
     C                   ENDIF
      *
     C                   Z-ADD     3             M                 2 0
     C     VOID          TAG
     C     V             IFGE      LVOID
     C                   GOTO      NOVOID
     C                   ENDIF
      *
     C                   EXSR      APVOID
     C                   ADD       1             V                 3 0
     C                   ADD       1             CHKNUM
     C                   GOTO      VOID
      *
     C     NOVOID        TAG
      **
      *
     C     NXT           TAG
     C                   SETOFF                                       31
     C                   READ      FTOPAY                                 90
     C   90              GOTO      END
      ** CHECK FOR SAME COMPANY
     C     LCO           IFNE      TPCOMP
     C                   GOTO      NXT
     C                   ENDIF
      *** CHECK FOR CHECK #
     C     TPCHEK        IFGT      0
     C     TPCOMP        ORNE      LCO
     C                   GOTO      NXT
     C                   END
      *
     C     CNT           IFEQ      1
     C                   EXSR      VENDOR
     C                   ENDIF
      *
     C     CNT           IFGT      1
     C     TPVEND        ANDNE     OLVEND
     C                   EXSR      CHECK
     C                   EXSR      VENDOR
     C                   Z-ADD     0             OVOUC
     C                   ENDIF
      *
     C                   Z-ADD     TPVEND        OLVEND            6 0
     C                   MOVEL     VMSUMM        OLSUMM            1
     C                   ADD       1             CNT
      *
     C     VMMVPC        IFEQ      'N'
     C     TPVOUC        ANDNE     OVOUC
     C     OVOUC         ANDNE     0
     C     CNT           ANDGT     1
     C                   EXSR      CHECK
     C                   END
     C                   Z-ADD     TPVOUC        OVOUC             6 0
      *
     C                   Z-ADD     CHKNUM        TPCHEK
     C                   Z-ADD     LDATE         TPCKDT
     C                   UPDATE    RTOPAY
      *
     C                   GOTO      NXT
      *
     C     END           TAG
      *
      ** CHECK IF ANY NUMBERS USED IN APREC
     C                   Z-ADD     CHKNUM        ENDNUM
     C                   EXSR      CHKCHK
     C     LCANCL        IFLE      *BLANKS
      *
     C     LCO           CHAIN     FAPCTL                             90
     C                   Z-ADD     LDATE         AZDTCK
     C                   Z-ADD     CHKNUM        AZLSCK
     C                   ADD       1             CHKNUM
     C                   Z-ADD     CHKNUM        AZCHEK
     C                   Z-ADD     TDATE         AZDTLA
     C                   Z-ADD     TIMOD         AZTIME
     C                   MOVEL     USERID        AZUSER
     C                   UPDATE    RAPCTL
     C                   ENDIF
     C                   SETON                                        LR
      *
      **********
      * APVOID *
      **********
     C     APVOID        BEGSR
      *
     C     VOIKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    CHKNUM
      * NOW APCHK RECORD FOR VOID
      *
     C     VOIKEY        CHAIN     FAPCHK                             90
     C   90              DO
     C                   MOVEL     'A'           ACSTAT
     C                   Z-ADD     LCO           ACCOMP
     C                   Z-ADD     CHKNUM        ACCHEK
     C                   Z-ADD     TDATE         ACCKDT
     C                   Z-ADD     *ZEROS        ACVEND
     C                   Z-ADD     *ZEROS        AC$AMT
     C                   Z-ADD     *ZEROS        ACDTAK
     C                   Z-ADD     *ZEROS        AC$NET
     C                   Z-ADD     TDATE         ACTDAT
     C                   MOVEL     *BLANKS       ACTDES
     C                   MOVEL     MSG(M)        ACTDES
     C                   Z-ADD     *ZEROS        ACPEDT
     C                   Z-ADD     *ZEROS        ACPSDT
     C                   MOVEL     'Y'           ACGLUD
     C                   MOVEL     'Y'           ACVUPD
     C                   Z-ADD     TDATE         ACDTLA
     C                   Z-ADD     TIMOD         ACTIME
     C                   MOVEL     USERID        ACUSER
     C                   MOVEL     'V'           ACCTYP
     C                   WRITE     RAPCHK
     C                   ENDDO
     C                   ENDSR
      *
      **********
      * DELOLD *
      **********
     C     DELOLD        BEGSR
      *
     C     LSTGDC        ADD       1             WRKDEL            6 0
     C     CHKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    WRKDEL
     C     CHKEY         CHAIN     FTOPAYCK                           88
     C                   Z-ADD     TPVEND        FVEND             6 0
     C                   Z-ADD     TPVOUC        FVOUC             6 0
     C                   MOVEL     TPINV#        FINV#            10
     C                   Z-ADD     TPSEQ#        FSEQ#             3 0
     C                   MOVEL     TPITYP        FITYP             1
      * NOW APCHK RECORD FOR DELETE
      *
     C     CHKEY         SETLL     FAPCHK
     C     NXTDL2        TAG
     C     LCO           READE     FAPCHK                                 90
     C   90              GOTO      ENDDL2
     C     ACCHEK        IFLE      LSTCHK
     C                   DELETE    RAPCHK
     C                   GOTO      NXTDL2
     C                   END
     C     ENDDL2        TAG
      *
      * NOW TOPAY RECS TO ZERO CHECK NUMBER
      *
     C                   Z-ADD     0             VEND              6 0
     C     CHKEYN        KLIST
     C                   KFLD                    FVEND
     C                   KFLD                    LCO
     C                   KFLD                    FVOUC
     C                   KFLD                    FINV#
     C                   KFLD                    FSEQ#
     C                   KFLD                    FITYP
     C     CHKEYN        SETLL     FTOPAY
     C     NXTDL3        TAG
     C                   READ      FTOPAY                                 90
     C   90              GOTO      ENDDL3
     C     TPCOMP        IFNE      LCO
     C                   GOTO      NXTDL3
     C                   END
     C     TPCHEK        IFLE      LSTCHK
     C                   Z-ADD     0             TPCHEK
     C                   UPDATE    RTOPAY
     C                   GOTO      NXTDL3
     C                   END
     C     ENDDL3        TAG
     C                   ENDSR
      *
      *********
      * CHECK *  PRINTS CHECK WITH INV DETAILS AND TOTAL PAID
      *********
      *
     C     CHECK         BEGSR
      *
      *
     C                   ADD       1             CHKNUM
      *
      *
     C                   ENDSR
      *
      *********
      * CHKCHK*  CHECKS IF ANY CHECK NUMBERS WE NEED ARE ALREADY USED
      *********
      *
     C     CHKCHK        BEGSR
     C     APRKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    BEGNUM
     C     APRKEY        SETLL     FAPREC
     C     LCO           READE     FAPREC                                 90
     C   90              GOTO      ENCK
     C     AKCHEK        IFLE      ENDNUM
     C                   WRITE     SCRENA
     C                   READ      SCRENA                                 91
     C                   MOVEL     'X'           LCANCL
     C                   END
     C     ENCK          ENDSR
      **********
      * VENDOR * CK FOR MULTI VOUCHERS AND SUMMARY CK STUB
      **********
      *
     C     VENDOR        BEGSR
      *
     C     TPVEND        CHAIN     FMVEND                             11
     C   11              GOTO      EVENDR
      *
      * MULTI VOUCHERS PER CHECK
      *
     C     VMMVPC        IFEQ      'N'
     C                   GOTO      EVENDR
     C                   ENDIF
      *
      * SUMMARY CHECK STUB - IF 'Y' WILL CREATE APR33A REPORT
      *
     C     VMSUMM        IFEQ      'Y'
     C                   GOTO      EVENDR
     C                   ENDIF
      * CALC THE NUMBER OF CHECKS TO VOID FOR STUB OVERFLOW
     C                   Z-ADD     0             CHK#              6 0
     C     TOPCVK        KLIST
     C                   KFLD                    TPCOMP
     C                   KFLD                    CHK#
     C                   KFLD                    TPVEND
     C                   Z-ADD     TPCOMP        GTCOMP            2 0
     C                   Z-ADD     TPVEND        GTVEND            6 0
     C                   Z-ADD     0             STUBC
     C                   Z-ADD     0             CHK#
     C                   CALL      'GETSTB#'
     C                   PARM                    GTCOMP
     C                   PARM                    CHK#              6 0
     C                   PARM                    GTVEND
     C                   PARM                    STUBC             5 0
     C     STUBC         IFGT      AZSTBL
     C     STUBC         DIV       AZSTBL        NETC              9 4
     C                   MOVE      NETC          NETCT             4 4          GET ALL FRAC
     C     1             SUB       NETCT         NETCT                          INTO WHOLE #
     C                   ADD       NETCT         NETC
     C                   SUB       1             NETC
      *
     C                   Z-ADD     0             V
     C                   Z-ADD     2             M                 2 0
     C     VOID1         TAG
     C     V             IFLE      NETC
     C                   EXSR      APVOID
     C                   ADD       1             V                 3 0
     C                   ADD       1             CHKNUM
     C                   GOTO      VOID1
     C                   ENDIF
      *
     C                   ELSE
     C                   GOTO      EVENDR
     C                   END                                                    STUBC>AZSTBL
      *
     C     EVENDR        TAG
     C                   ENDSR
** DESCRIPTIONS
Void Check                                     1
Void Check-Stub Over Flow                      2
Void Check-Printer Jam                         3
