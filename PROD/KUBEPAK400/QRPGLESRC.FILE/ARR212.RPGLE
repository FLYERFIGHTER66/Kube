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
      *PROGRAM NAME-------- ARR212
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- TO BE CALLED FROM ANOTHER PROGRAM
      *                     AND TO BE USED TO TEST THE CUSTOMER BALANCE
      *                     FOR EACH INVOICE.
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAROPN    IF   E           K DISK
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      *  PROGRAM NAME
     D  PROGID                 1     10
      *  RUN LIBRARY
     D  RLIBR                 81     90
      *  USER I.D.
     D  USERID               254    263
      *  SOURCE LIBRARY
     D  SLIBR                314    323
      *
     C     *ENTRY        PLIST
     C                   PARM                    CUST             06 0
     C                   PARM                    INV#             06 0
     C                   PARM                    SUFF             02
     C                   PARM                    RETC             01
      *
     C     K1AROP        KLIST
     C                   KFLD                    CUST
     C                   KFLD                    INV#
     C                   KFLD                    SUFF
      *
      *
     C                   MOVE      *BLANKS       RETC
     C                   Z-ADD     *ZEROS        AMT$00           09 2
     C                   Z-ADD     *ZEROS        DISC00           09 2
     C                   Z-ADD     *ZEROS        DTAK00           09 2
     C                   Z-ADD     *ZEROS        ADJ$00           09 2
     C                   Z-ADD     *ZEROS        PAID00           09 2
     C                   Z-ADD     *ZEROS        DUE$00           09 2
     C                   Z-ADD     *ZEROS        AMT$             09 2
     C                   Z-ADD     *ZEROS        DISC             09 2
     C                   Z-ADD     *ZEROS        DTAK             09 2
     C                   Z-ADD     *ZEROS        ADJ$             09 2
     C                   Z-ADD     *ZEROS        PAID             09 2
     C                   Z-ADD     *ZEROS        DUE$             09 2
      *
      *
     C     K1AROP        SETLL     FAROPN
     C     *IN50         DOUEQ     '1'
      *
     C     K1AROP        READE     FAROPN                                 50
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
      *
     C     ARSEQ#        IFEQ      *ZEROS
     C                   Z-ADD     AR$AMT        AMT$00
     C                   Z-ADD     ARDISC        DISC00
     C                   Z-ADD     ARDTAK        DTAK00
     C                   Z-ADD     ARADJ$        ADJ$00
     C                   Z-ADD     ARPAID        PAID00
     C                   Z-ADD     ARDUE$        DUE$00
     C                   END
      *
     C     ARSEQ#        IFNE      *ZEROS
     C     ARTTYP        IFEQ      4
     C                   Z-ADD     AR$AMT        ARADJ$
     C                   Z-ADD     *ZEROS        AR$AMT
     C                   END
     C                   ADD       AR$AMT        AMT$
     C                   ADD       ARDISC        DISC
     C                   ADD       ARDTAK        DTAK
     C                   ADD       ARADJ$        ADJ$
     C                   ADD       ARPAID        PAID
     C                   ADD       ARDUE$        DUE$
     C                   END
      *
     C                   ENDDO
      *
      *
     C                   Z-ADD     AMT$00        AMT01            09 2          LINE STARTING BALANC
     C*                    SUB  DISC00    AMT01            SUB DISCOUNT AVAIL
     C                   SUB       DTAK00        AMT01                          SUB DISCOUNT TAKEN
     C                   ADD       ADJ$00        AMT01                          ADD ADJUSTMENTS
     C                   SUB       PAID00        AMT01                          SUB PAID AMOUNT
      *                                                    EQUALS LINE BALANCE
      *
     C     DUE$00        IFNE      AMT01                                        LINE IS OUT OF BAL
     C                   MOVE      '1'           RETC
     C                   GOTO      END
     C                   END
      *
     C     DTAK          MULT      -1.00         DTAK
     C     DTAK00        IFNE      DTAK                                         DISCOUNT TAKEN IS OO
     C                   MOVE      '2'           RETC
     C                   GOTO      END
     C                   END
      *
     C     ADJ$00        IFNE      ADJ$                                         ADJUSTMENT IS OOB
     C                   MOVE      '3'           RETC
     C                   GOTO      END
     C                   END
      *
     C                   Z-SUB     AMT$          AMT01            09 2          LINE STARTING BALANC
     C*                    SUB  DTAK00    AMT01            SUB DISCOUNT TAKEN
     C*                    ADD  ADJ$00    AMT01            ADD ADJUSTMENTS
     C     PAID00        IFNE      AMT01                                        AMT PAID IS OOB
     C                   MOVE      '5'           RETC
     C                   GOTO      END
     C                   END
      *
      *
     C     END           TAG
     C                   MOVE      '1'           *INLR
     C                   RETURN
