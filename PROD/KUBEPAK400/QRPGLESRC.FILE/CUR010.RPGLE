      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      **PROGRAM NAME-------- CUR010
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- ROUND CUTTINGS NEEDED TO NEXT 100
      *
      *   PROGRAM CREATED BECAUSE RULES FOR ROUNDING MAY CHANGE, THEN
      *   ONLY NEED TO CHANGE 1 PROGRAM.
      *            CHANGE--DATE-------DESCRIPTION
      * 10/23/01 EFD FIND HUNDREDS AND MULT BY 5 TO CALC EXTRAS VEND
      *              WILL SHIP AND TAKE OUT OF ROUND FACTOR.
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
      ****************
      * INPUT PARMS  *
      ****************
     C     *ENTRY        PLIST
     C                   PARM                    QTYORD            7 0
     C                   PARM                    QTYNED            7 0

     C                   MOVE      QTYORD        TST20             2 0          10'S OVER
     C                   MOVEL     QTYORD        TST50             5 0          100'S
     C     TST50         MULT      100           QTYNED
     C     TST20         IFNE      *ZERO
     C                   ADD       100           QTYNED
     C                   ENDIF
     C                   SETON                                        LR

     C     OldLogic      BegSr
     C                   Z-ADD     0             QTYNED
     C                   MOVE      QTYORD        TST20             2 0          10'S OVER
     C                   MOVEL     QTYORD        TST50             5 0          100'S
     C     TST50         MULT      5             EXTRA             7 0
      ** NO MATTER WHAT GET RID OF 10'S OVER
     C                   Z-ADD     QTYORD        QTYNED
     C                   SUB       TST20         QTYNED
      ** IF EXTRA IS GREATER THAN OVER DO NOT ORDER OVER
     C     TST20         IFGT      EXTRA
     C                   ADD       100           QTYNED
     C                   END
      *** END PROGRAM
     C                   SETON                                        LR
     C                   EndSr
