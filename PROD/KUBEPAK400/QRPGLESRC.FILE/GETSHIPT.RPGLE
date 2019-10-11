    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')


     FFMINVT    IF   E           K DISK
     FGETSHIPFM CF   E             WORKSTN
      **
      *
      ****************************************************************
      ********
      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$MDYDate

     C                   Eval      RDATE = $MDYDate($Monday($Date(0):'SAT'))
     C     NXTA          TAG
     C     ITMKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C                   KFLD                    IMWHSE
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
     C                   SETOFF                                       1020
     C     1             SUBST     ITEM:1        VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     ITEM:2        IMLOOK
     C                   CALL      'LKITAL'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   GOTO      NXTA
     C                   ENDIF
     C     ITMKEY        CHAIN     FMINVT                             20
     C   20              GOTO      NXTA
      ** NOW CHECK READY DATE
     C                   Z-ADD     RDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     ##CYMD        SOWDAT
     C                   CALL      'GETSHIP'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    REQDAT            7 0          CYMD
     C                   PARM                    SOWDAT            7 0          CYMD
     C                   Z-ADD     REQDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SDATE
     C                   GOTO      NXTA
     **
     C     END           TAG
     C                   SETON                                        LR
