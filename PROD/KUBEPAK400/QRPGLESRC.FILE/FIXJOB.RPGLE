      *
      *
     FRPMOVJOB  IP   E             DISK
     F                                     RENAME(RMOVJOB:OLDREC)
     FFMOVJOB   O  A E             DISK
      *
     C     MJTDAT        IFEQ      011304
     C                   WRITE     RMOVJOB
     C                   ENDIF
