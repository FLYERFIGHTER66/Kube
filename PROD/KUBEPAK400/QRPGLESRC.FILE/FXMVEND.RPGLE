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
      *PROGRAM NAME-------- FXMVEND                                       GLR010
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- A/P VENDOR MASTER FIX                         GLR010
      *                                                                   GLR010
      *            CHANGE--DATE-------DESCRIPTION
      *
      **                                                                  GLR010
     FFMVEND    UF   E           K DISK
      *                                                                   GLR010
     C     NXT           TAG
     C                   READ      FMVEND                                 90
     C   90              GOTO      END
     C                   Z-ADD     0             VMYPUR
     C                   Z-ADD     0             VMYDIT
     C                   Z-ADD     0             VMYDAV
     C                   Z-ADD     0             VMLYPU
     C                   Z-ADD     0             VMLYDT
     C                   Z-ADD     0             VMLYDV
     C                   Z-ADD     0             VMPAID
     C                   Z-ADD     0             VMLYPD
     C                   UPDATE    RMVEND
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
