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
      *PROGRAM NAME-        FXAPREC                                       GLR010
      *SYSTEM-              ACCOUNTS PAYABLE                              GLR010
      *APPLICATION-         APREC FILE FIX                                GLR010
      *                                                                   GLR010
      *
      **                                                                  GLR010
     FFAPREC    UF   E           K DISK
      *                                                                   GLR010
     C     KEY           KLIST
     C                   KFLD                    KEY1
     C                   KFLD                    KEY2
     C                   Z-ADD     01            KEY1              2 0
     C                   Z-ADD     028145        KEY2              6 0
     C     KEY           SETLL     FAPREC
     C     NXT           TAG
     C                   READ      FAPREC                                 90
     C   90              GOTO      NXT1
     C     AKCHEK        IFGE      28146
     C     AKCHEK        ANDLE     28167
     C                   ADD       100002        AKCHEK
     C                   UPDATE    RAPREC
     C                   ENDIF
     C                   GOTO      NXT
      *
     C     NXT1          TAG
     C                   Z-ADD     01            KEY1              2 0
     C                   Z-ADD     128145        KEY2              6 0
     C     KEY           SETLL     FAPREC
     C     NXT2          TAG
     C                   READ      FAPREC                                 90
     C   90              GOTO      END
     C**         AKCHEK    IFGE 128146
     C**         AKCHEK    ANDLE128169
     C                   SUB       100000        AKCHEK
     C                   UPDATE    RAPREC
     C***                  ENDIF
     C                   GOTO      NXT2
     C     END           TAG
     C                   SETON                                        LR
