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
      *PROGRAM NAME-------- ICR030
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- CREATE CUSTOMER/ITEM # CROSS REFERENCE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFCUSTNO   UF A E           K DISK
     FFMCUST    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMINVTPC  IF   E           K DISK
     FICR030FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     D ITM             S             15    DIM(15)
     D CIT             S             15    DIM(15)
     D DES             S             30    DIM(15)
     D ODES            S             30    DIM(15)
     D TDES            S             30    DIM(15)
      *
     ISCRNB
     I              ITEM01                      ITM(1)
     I              ITEM02                      ITM(2)
     I              ITEM03                      ITM(3)
     I              ITEM04                      ITM(4)
     I              ITEM05                      ITM(5)
     I              ITEM06                      ITM(6)
     I              ITEM07                      ITM(7)
     I              ITEM08                      ITM(8)
     I              ITEM09                      ITM(9)
     I              ITEM10                      ITM(10)
     I              ITEM11                      ITM(11)
     I              ITEM12                      ITM(12)
     I              ITEM13                      ITM(13)
     I              ITEM14                      ITM(14)
     I              ITEM15                      ITM(15)
      ***
     I              CITM01                      CIT(1)
     I              CITM02                      CIT(2)
     I              CITM03                      CIT(3)
     I              CITM04                      CIT(4)
     I              CITM05                      CIT(5)
     I              CITM06                      CIT(6)
     I              CITM07                      CIT(7)
     I              CITM08                      CIT(8)
     I              CITM09                      CIT(9)
     I              CITM10                      CIT(10)
     I              CITM11                      CIT(11)
     I              CITM12                      CIT(12)
     I              CITM13                      CIT(13)
     I              CITM14                      CIT(14)
     I              CITM15                      CIT(15)
      ***
     I              DES01                       DES(1)
     I              DES02                       DES(2)
     I              DES03                       DES(3)
     I              DES04                       DES(4)
     I              DES05                       DES(5)
     I              DES06                       DES(6)
     I              DES07                       DES(7)
     I              DES08                       DES(8)
     I              DES09                       DES(9)
     I              DES10                       DES(10)
     I              DES11                       DES(11)
     I              DES12                       DES(12)
     I              DES13                       DES(13)
     I              DES14                       DES(14)
     I              DES15                       DES(15)
      *
     C     CLEAR         TAG
     C                   SETOFF                                       101112
     C                   SETOFF                                       12
     C                   MOVE      *BLANKS       CNAME
     C                   Z-ADD     0             VCUST
     C                   MOVE      *BLANKS       VPCL
     C     RSTRTA        TAG
     C                   Z-ADD     *ZEROS        Y                 3 0
     C                   MOVEL     *BLANKS       OITEM
     C                   SETON                                        60
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       13
     C                   SETOFF                                       989960
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              SETON                                        LRU1      CMD7-EOJ
     C   KC
     COR KG              GOTO      END
      *
     C     VCUST         IFEQ      *ZEROS                                                   K
     C     VALPHA        ANDEQ     *BLANKS                                                  K
     C                   SETON                                        109913
     C                   GOTO      RSTRTA
     C                   ENDIF
      * GET ALPHA SEARCH
     C     VCUST         IFEQ      *ZEROS                                                   K
     C     VALPHA        ANDNE     *BLANKS                                                  K
     C                   MOVEL     VALPHA        CMLOOK           15
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     CMCUST        VCUST
     C                   MOVEL     CMNAME        CNAME            30
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VCUST         CHAIN     FMCUST                             98
     C   98              SETON                                        1099
     C  N98CMSTAT        IFEQ      'D'
     C   98              SETON                                        1099
     C                   ENDIF
     C   10
     CAN 99              GOTO      RSTRTA
     C                   MOVEL     CMNAME        CNAME            30
      *
     C     1             SUBST     VPCL:1        VPC1              1
     C     VPC1          IFEQ      '?'
     C     VPC1          OREQ      '/'
     C                   MOVEL     VPCL          PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VPCL
     C                   MOVEL     PCPRCL        VPCL
     C                   MOVEL     PCDESC        VDESC            30
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VPCL          IFEQ      *BLANKS                                                  OS
     C                   SETON                                        1199
     C                   GOTO      RSTRTA
     C                   END
      *
     C     VPCL          CHAIN     FMPRCL                             98
     C   98              SETON                                        1199
     C   11
     CAN 99              GOTO      RSTRTA
     C  N98PCSTAT        IFEQ      'D'
     C   98              SETON                                        1199
     C   11
     CAN 99              GOTO      RSTRTA
     C                   ENDIF
      *
     C                   MOVEL     PCDESC        PCNAME           30
      *
     C     VPCL          SETLL     FMINVTPC
     C                   READ      FMINVTPC                               98
     C   98              SETON                                        1299
     C   12
     CAN 99              GOTO      RSTRTA
      *
     C  N98IMPCL1        IFNE      VPCL
     C                   SETON                                        1299
     C                   GOTO      RSTRTA
     C                   END
      *
     C                   Z-ADD     *ZEROS        X                 2 0
      * SET MINVT BACK TO BEGINING OF CLASS
     C     VPCL          SETLL     FMINVTPC
     C     RSTRTB        TAG
     C                   SETOFF                                       313233
     C                   SETOFF                                       343536
     C                   SETOFF                                       373839
     C                   SETOFF                                       404142
     C                   SETOFF                                       434445
     C                   MOVEL     *BLANKS       DES
     C                   MOVEL     *BLANKS       ODES
     C                   MOVEL     *BLANKS       ITM
     C                   MOVEL     *BLANKS       CIT
     C                   Z-ADD     1             X
     C     X             DOUEQ     15
     C     Y             IFGT      1
     C                   SETOFF                                       60
     C                   END
      *
      *    75 = END OF FILE OR PRODUCT CLASS
      *
     C     REREAD        TAG
     C                   READ      FMINVTPC                               75
      *
     C  N75IMPCL1        IFNE      VPCL
     C                   SETON                                            75
     C                   END
     C  N75              GOTO      NOTEOF
      *
     C   75              MOVEL     '* End of'    EOFA              8
     C   75              MOVE      ' Product'    EOFB              8
     C   75              MOVE      ' Class *'    EOFC              8
     C   75              MOVEL     EOFA          EOFD             16
     C   75              MOVE      EOFB          EOFD
     C   75              MOVEL     EOFD          EOFE             24
     C   75              MOVE      EOFC          EOFE
     C   75              MOVEL     EOFE          DES(X)
     C   75              MOVEL     *BLANKS       ITM(X)
     C   75              MOVEL     *BLANKS       CIT(X)
     C   75              Z-ADD     15            X
      *  LINE NUMBER FOR END OF FILE
     C   75              Z-ADD     X             EOFLN             2 0
     C   75              GOTO      WSCRN
      *
     C     NOTEOF        TAG
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      REREAD
     C                   END
      *
     C     OITEM         IFGT      *BLANKS
     C     IMITEM        ANDEQ     OITEM
     C                   GOTO      REREAD
     C                   END
      *
     C                   MOVEL     IMITEM        ITM(X)
     C                   MOVEL     IMDES1        DES(X)
     C                   MOVEL     IMDES1        ODES(X)
     C                   MOVEL     IMDES1        TDES(X)
     C                   Z-ADD     VCUST         CNCUST
     C                   MOVEL     ITM(X)        CNITEM
     C     KEY21         KLIST
     C                   KFLD                    CNCUST
     C                   KFLD                    CNITEM
     C     KEY21         CHAIN     FCUSTNO                            96
     C  N96              MOVEL     CNCST#        CIT(X)
     C  N96CNCSDS        IFGT      *BLANKS
     C                   MOVEL     CNCSDS        DES(X)
     C                   MOVEL     CNCSDS        ODES(X)
     C                   END
     C                   MOVEL     IMITEM        ITM(X)
     C                   MOVEL     IMITEM        OITEM            15
     C                   ADD       1             X
     C                   ADD       1             Y
     C                   END
      *
     C     WSCRN         TAG
     C     ITM(01)       COMP      *BLANKS                            31
     C     ITM(02)       COMP      *BLANKS                            32
     C     ITM(03)       COMP      *BLANKS                            33
     C     ITM(04)       COMP      *BLANKS                            34
     C     ITM(05)       COMP      *BLANKS                            35
     C     ITM(06)       COMP      *BLANKS                            36
     C     ITM(07)       COMP      *BLANKS                            37
     C     ITM(08)       COMP      *BLANKS                            38
     C     ITM(09)       COMP      *BLANKS                            39
     C     ITM(10)       COMP      *BLANKS                            40
     C     ITM(11)       COMP      *BLANKS                            41
     C     ITM(12)       COMP      *BLANKS                            42
     C     ITM(13)       COMP      *BLANKS                            43
     C     ITM(14)       COMP      *BLANKS                            44
     C     ITM(15)       COMP      *BLANKS                            45
      *
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  95
     C   KF              GOTO      RSTRTA
      *
      *    ADD OR UPDATE RECORD TO FCUSTNO
      *
     C                   Z-ADD     1             Z                 2 0
     C     Z             DOUEQ     15
     C                   Z-ADD     VCUST         CNCUST
     C                   MOVEL     ITM(Z)        CNITEM
     C     KEY21         CHAIN     FCUSTNO                            94
     C  N94              GOTO      OKOUT
     C     CIT(Z)        IFEQ      *BLANKS
     C     DES(Z)        ANDEQ     ODES(Z)
     C                   GOTO      NOOUT
     C                   ENDIF
     C     CIT(Z)        IFEQ      *BLANKS
     C     DES(Z)        ANDEQ     *BLANKS
     C                   GOTO      NOOUT
     C                   ENDIF
     C     OKOUT         TAG
     C                   MOVEL     VCUST         CNCUST
     C                   MOVEL     ITM(Z)        CNITEM
     C                   MOVEL     CIT(Z)        CNCST#
     C     DES(Z)        IFNE      TDES(Z)
     C                   MOVEL     DES(Z)        CNCSDS
     C                   ELSE
     C                   MOVE      *BLANKS       CNCSDS
     C                   END
     C                   MOVEL     'A'           CNSTAT
     C  N94              UPDATE    RCUSTNO
     C   94              WRITE     RCUSTNO
     C     NOOUT         TAG
     C                   ADD       1             Z
     C     EOFLN         IFEQ      Z
     C                   Z-ADD     15            Z
     C                   END
     C                   END
     C  N75              GOTO      RSTRTB
     C   75              GOTO      RSTRTA
     C     END           TAG
     C                   SETON                                        LR
      **
