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
      *PROGRAM NAME-        FXGLBAL                                       GLR010
      *SYSTEM-              GENERAL LEDGER                                GLR010
      *APPLICATION-         GLBAL FILE FIX                                GLR010
      *                                                                   GLR010
      *
      **                                                                  GLR010
     FFGLBAL    UF   E           K DISK
      *                                                                   GLR010
     C     NXT           TAG
     C                   READ      FGLBAL                                 90
     C   90              GOTO      END
     C                   Z-ADD     0             GLBALT
     C                   Z-ADD     0             GLBALL
     C                   Z-ADD     0             GLT01
     C                   Z-ADD     0             GLT02
     C                   Z-ADD     0             GLT03
     C                   Z-ADD     0             GLT04
     C                   Z-ADD     0             GLT05
     C                   Z-ADD     0             GLT06
     C                   Z-ADD     0             GLT07
     C                   Z-ADD     0             GLT08
     C                   Z-ADD     0             GLT09
     C                   Z-ADD     0             GLT10
     C                   Z-ADD     0             GLT11
     C                   Z-ADD     0             GLT12
     C                   Z-ADD     0             GLT13
     C                   Z-ADD     0             GLL01
     C                   Z-ADD     0             GLL02
     C                   Z-ADD     0             GLL03
     C                   Z-ADD     0             GLL04
     C                   Z-ADD     0             GLL05
     C                   Z-ADD     0             GLL06
     C                   Z-ADD     0             GLL07
     C                   Z-ADD     0             GLL08
     C                   Z-ADD     0             GLL09
     C                   Z-ADD     0             GLL10
     C                   Z-ADD     0             GLL11
     C                   Z-ADD     0             GLL12
     C                   Z-ADD     0             GLL13
     C                   UPDATE    RGLBAL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
