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
      **PROGRAM NAME-------- ALOCATE
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS DISTRIBUTION.
      **PROGRAMMER---------- EFD
      **APPLICATION--------- ALLOCATE ORDER LINE ITEMS (NON LOT)
      *                      (THIS IS A CALLED PROGRAM)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMINVT    UF   E           K DISK
     FFLKITM    UF   E           K DISK
      *
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
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    NEWQTY           11 1
     C                   PARM                    OLDQTY           11 1
     C                   PARM                    COMP              2 0
     C                   PARM                    ORDER#            6 0
     C                   PARM                    SEQ#              3 0
     C                   MOVEL     '99999999'    TST              12
     C                   MOVE      '999'         TST
     C     IMITEM        IFEQ      TST
     C                   GOTO      ENDLR
     C                   END
      ** IF QTYS THE SAME NO ACTION
     C     NEWQTY        IFEQ      OLDQTY
     C                   GOTO      END
     C                   END
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TIMWRK           12 0
     C                   MOVE      TIMWRK        TDATE             6 0
     C     MINKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
     C     MINKEY        CHAIN     FMINVT                             71
     C   71              GOTO      END
     C     MINKEY        CHAIN     FLKITM                             72
      ** SEE WHAT QTY WE USE
     C     NEWQTY        SUB       OLDQTY        WRKQTY           11 1
     C                   ADD       WRKQTY        IMQTAL
     C     IMQTAL        IFLT      0.0
     C                   Z-ADD     0             IMQTAL
     C                   END
      ** UPDATE MINVT
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C  N71              UPDATE    RMINVT
     C                   ADD       WRKQTY        LKPAL
     C     LKPAL         IFLT      0.0
     C                   Z-ADD     0             LKPAL
     C                   END
      ** UPDATE LKITM
     C  N72              UPDATE    RLKITM
      *** END PROGRAM
     C     END           TAG
     C                   UNLOCK    FMINVT
     C                   UNLOCK    FLKITM
     C                   RETURN
      *** END PROGRAM SET ON LR
     C     ENDLR         TAG
     C                   SETON                                        LR
