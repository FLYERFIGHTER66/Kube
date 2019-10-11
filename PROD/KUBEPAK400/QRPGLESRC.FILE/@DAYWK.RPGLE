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
      **PROGRAM NAME-------- @DAYWK
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CALCULATE DAY OF WEEK
      *
      ********************************************************************
      * FIGURES OUT DAY OF THE WEEK THAT ENTERED DATE IS.
      * ##DDD INPUT DATE DDDDD - RESULT FROM @DT@B2
      * #Y OUTPUT INDEX REFLECTING DAY OF WEEK
      * 1=MONDAY
      ********************************************************************
      *            CHANGE--DATE-------DESCRIPTION
      *
     C     *ENTRY        PLIST
     C                   PARM                    ##DDD             5 0
     C                   PARM                    #Y
      *
     C     ##DDD         DIV       7.0000        #WKS             10 5
     C                   MOVE      #WKS          ##R               5 5
     C     ##R           MULT(H)   7             #Y                1 0
      *
     C     #Y            IFGT      7
     C     #Y            SUB       7             #Y
     C                   END
      *
     C     #Y            IFEQ      0
     C                   Z-ADD     7             #Y
     C                   END
      *
     C                   SETON                                        LR
      *
