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
      *PROGRAM NAME-------- FXOPNORD                                      GLR010
      *                                                                   GLR010
      *            CHANGE--DATE-------DESCRIPTION
      *
      **                                                                  GLR010
     FFHORDR    IF   E           K DISK
      *                                                                   GLR010
     C     NXT           TAG
     C                   READ      FHORDR                                 90
     C   90              GOTO      END
     C     OHSTAT        IFNE      'D'
     C     OHCOFL        ANDNE     'Y'
     C                   CALL      'GETORD$'
     C                   PARM                    OHORD#            6 0
     C                   PARM                    TOTDOL            9 2
     C                   ENDIF
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
