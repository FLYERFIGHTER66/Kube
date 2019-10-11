      *
      *
     FFMINVT    UP   E           K DISK
      *
     C     IMSIZE        IFEQ      'SED'
     C*                    Z-ADD1000      IMLBS#
     C*                    Z-ADD7         IMMULT
     C                   MOVE      'MM'          IMSUOM
     C                   MOVE      'MM'          IMBPUM
     C*          IMQTOH    MULT 1000      IMQTOH
     C*          IMMREC    MULT 1000      IMMREC
     C*          IMBPOH    MULT 1000      IMBPOH
     C*          IMISSU    MULT 1000      IMISSU
     C                   UPDATE    RMINVT
     C                   UNLOCK    FMINVT
     C                   ENDIF
