      *--------------------------------------------------------------     GLR010
      *                                                                   GLR010
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999                          GLR010
      *                                                                   GLR010
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO         GLR010
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE         GLR010
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED      GLR010
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR         GLR010
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT      GLR010
      *       BY EXPRESS WRITTEN PERMISSION OF                            GLR010
      *            EFD ENTERPRISES, INC.     215-643-5352                 GLR010
      *                                                                   GLR010
      *--------------------------------------------------------------     GLR010
      *PROGRAM NAME-        FXGLDET                                       GLR010
      *SYSTEM-              GENERAL LEDGER                                GLR010
      *APPLICATION-         GLDET FILE FIX                                GLR010
      *                                                                   GLR010
      *
      **                                                                  GLR010
     FFGLDET    UF   E           K DISK
      *                                                                   GLR010
     C     NXT           TAG
     C                   READ      FGLDET                                 90
     C   90              GOTO      END
     C                   MOVEL     *BLANKS       GTPOST
     C                   UPDATE    RGLDET
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
