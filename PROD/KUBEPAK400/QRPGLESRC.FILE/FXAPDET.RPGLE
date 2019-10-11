      *--------------------------------------------------------------     GLR010
      *                                                                   GLR010
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001                          GLR010
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
      *PROGRAM NAME-        FXAPDET                                       GLR010
      *SYSTEM-              ACCOUNTS PAYABLE                              GLR010
      *APPLICATION-         APDET FILE FIX                                GLR010
      *                                                                   GLR010
      *
      **                                                                  GLR010
     FFAPDET    UF   E           K DISK
      *                                                                   GLR010
     C     NXT           TAG
     C                   READ      FAPDET                                 90
     C   90              GOTO      END
     C                   MOVE      ADAPER        YEAR              2 0
     C     YEAR          IFGE      04
     C                   GOTO      NXT
     C                   ENDIF
     C     YEAR          IFLE      03
     C                   DELETE    FAPDET
     C                   ENDIF
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
