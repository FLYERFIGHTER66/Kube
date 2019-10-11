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
      *PROGRAM NAME--------- APR260
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *APPLICATION---------- START UP ENTRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAPCTL    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FFAPOPN    IF   E           K DISK
     FFAPENT    UF A E           K DISK
     FAPR260FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    261
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RDATE             5 0
      *
     C                   Z-ADD     0             COMP              2 0
     C     COMP          CHAIN     FAPCTL                             90
     C                   Z-ADD     AZPRCO        VCO
      *
     C     RSTRT         TAG
     C                   Z-ADD     0             VVEND
     C                   Z-ADD     0             VINDTE
     C                   Z-ADD     0             VIDDTE
     C                   Z-ADD     0             VDDDTE
     C                   Z-ADD     0             VAMT
     C                   Z-ADD     0             VDISC
     C                   MOVEL     *BLANKS       VMNAME
     C                   MOVEL     *BLANKS       VINV#
     C                   MOVEL     *BLANKS       VDESC
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       40
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
      *
     C     VACT          IFNE      'A'
     C     VACT          ANDNE     'C'
     C     VACT          ANDNE     'D'
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         IFEQ      0
     C     VALPHA        ANDGT     *BLANKS
     C                   Z-ADD     VCO           VMCOMP            2 0
     C                   MOVEL     VALPHA        VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        VVEND
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         CHAIN     FMVEND                             90
     C   90              SETON                                        20
     C   20              GOTO      NXTA
      *
     C     VTYPE         IFLT      1
     C     VTYPE         ORGT      3
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCO           IFEQ      0
     C                   SETON                                        40
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCO           CHAIN     FAPCTL                             90
     C   90              SETON                                        40
     C   40              GOTO      NXTA
      *
     C     VMTMCD        CHAIN     FMTERM                             91
      *
     C     VTYPE         IFEQ      1
     C                   MOVEL     'Invoice'     TYPE
     C                   MOVEL     ' '           INVTYP            1
     C                   ENDIF
     C     VTYPE         IFEQ      2
     C                   MOVEL     'Credit M'    TYPE
     C                   MOVE      'emo'         TYPE
     C                   MOVEL     'C'           INVTYP            1
     C                   SETON                                        55
     C                   ENDIF
     C     VTYPE         IFEQ      3
     C                   MOVEL     'Freight'     TYPE
     C                   MOVEL     'F'           INVTYP            1
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C                   MOVEL     '  Add   '    ACTION
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   MOVEL     ' Change '    ACTION
     C                   SETON                                        86
      *
     C                   Z-ADD     VVEND         ANVEND
     C                   CALL      'LKAPENT'
     C                   PARM                    ANVEND            6 0
     C                   PARM                    ANCOMP            2 0
     C                   PARM                    ANVOUC            6 0
     C                   PARM                    ANIVDT            6 0
     C                   PARM                    ANDUDT            6 0
     C                   PARM                    ANDCDT            6 0
     C                   PARM                    ANDAVL            7 2
     C                   PARM                    AN$AMT           11 2
     C                   PARM                    ANINV#           10
     C                   PARM                    ANITYP            1
     C                   PARM                    ANTDES           30
     C                   MOVEL     ANVOUC        VVOUCH
     C                   MOVEL     ANINV#        VINV#
     C                   MOVEL     ANIVDT        VINDTE
     C                   MOVEL     AN$AMT        VAMT
     C                   MOVEL     ANTDES        VDESC
     C                   MOVEL     ANDUDT        VIDDTE
     C                   MOVEL     ANDCDT        VDDDTE
     C                   MOVEL     ANDAVL        VDISC
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   MOVEL     ' Delete '    ACTION
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   Z-ADD     1             CNTF              2 0
     C                   WRITE     SCRNB
     C                   SETOFF                                       101120
     C                   SETOFF                                       212230
     C                   SETOFF                                       405051
     C                   SETOFF                                       525354
     C                   SETOFF                                       6162
     C                   SETOFF                                       7071
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
     C*  86                GOTO DELREC
      *
     C     VINV#         IFEQ      *BLANKS
     C                   SETON                                        2021
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C   23              GOTO      NOCHK
     C     VACT          IFEQ      'C'
     C     VACT          OREQ      'D'
     C                   Z-ADD     0             SEQ               3 0
     C     APKEY         CHAIN     FAPENT                             93
     C   93              SETON                                        2122
     C   22              GOTO      RSTRTB
     C                   Z-ADD     ANIVDT        VINDTE
     C                   Z-ADD     AN$AMT        VAMT
     C                   MOVEL     ANTDES        VDESC
     C                   Z-ADD     ANDUDT        VIDDTE
     C                   Z-ADD     ANDCDT        VDDDTE
     C                   Z-ADD     ANDAVL        VDISC
     C                   SETON                                        23
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   SETON                                        8685
     C                   ENDIF
     C     VACT          IFNE      'A'
     C                   GOTO      RSTRTB
     C                   ENDIF
     C     NOCHK         TAG
      *
     C     VINDTE        IFEQ      0
     C                   SETON                                        30
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   Z-ADD     VINDTE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        30
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C                   Z-ADD     0             SEQ               3 0
     C                   Z-ADD     0             VVOUCH            6 0
     C     APKEY         KLIST
     C                   KFLD                    VVEND
     C                   KFLD                    VCO
     C                   KFLD                    VVOUCH
     C                   KFLD                    VINV#
     C                   KFLD                    SEQ
     C                   KFLD                    INVTYP
     C     APKEY         SETLL     FAPOPN
     C     NXTV          TAG
     C     VVEND         READE     FAPOPN                                 92
     C   92              GOTO      NXTF
     C     APINV#        IFEQ      VINV#
     C     APCOMP        ANDEQ     VCO
     C     APITYP        ANDEQ     INVTYP
     C                   SETON                                        6121
     C   61              GOTO      RSTRTB
     C                   ENDIF
     C                   GOTO      NXTV
     C     NXTF          TAG
      *
     C     APKEY         SETLL     FAPENT
     C     NXTT          TAG
     C     VVEND         READE     FAPENT                                 93
     C   93              GOTO      NXTG
     C     ANINV#        IFEQ      VINV#
     C     ANCOMP        ANDEQ     VCO
     C     ANITYP        ANDEQ     INVTYP
     C                   SETON                                        6221
     C                   GOTO      RSTRTB
     C                   ENDIF
     C                   GOTO      NXTT
     C     NXTG          TAG
     C                   ENDIF
      *
     C     VAMT          IFEQ      0
     C                   SETON                                        5051
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VIDDTE        IFEQ      0
     C                   EXSR      TERMS
     C                   ENDIF
      *
     C     VTYPE         IFEQ      2
     C     VDISC         ANDGT     0
     C                   SETON                                        7071
     C   70              GOTO      RSTRTB
     C                   ENDIF
      *
     C     VDISC         IFGT      0
     C                   Z-ADD     VDDDTE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   ENDIF
     C     VDISC         IFGT      0
     C     ##ERR         ANDEQ     'Y'
     C                   SETON                                        30
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VDDDTE        IFGT      0
     C     VDISC         ANDEQ     0
     C                   SETON                                        5471
     C   54              GOTO      RSTRTB
     C                   ENDIF
      *
     C                   ADD       1             CNT
     C     CNT           IFEQ      1
     C     CNTF          ORGT      1
     C                   SETON                                        88
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     DELREC        TAG
     C                   EXSR      GETREC
     C     VACT          IFEQ      'A'
     C                   WRITE     RAPENT
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RAPENT
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RAPENT
     C                   ENDIF
     C                   GOTO      RSTRT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      ***********
      * TERMS   *
      ***********
     C     TERMS         BEGSR
     C                   SETOFF                                       59
     C     VMTMCD        CHAIN(N)  FMTERM                             95
     C   95              GOTO      CALDT1
      *
     C                   MOVE      TCTRAT        #DISWK
      *
     C     TCTRTP        IFEQ      1
     C                   GOTO      TYP01
     C                   ENDIF
     C     TCTRTP        IFEQ      2
     C                   GOTO      TYP02
     C                   ENDIF
     C     TCTRTP        IFEQ      3
     C                   GOTO      TYP03
     C                   ENDIF
      *
     C     CALDT1        TAG
     C                   MOVE      VINDTE        DUDT
     C                   MOVE      VINDTE        CSHDUE
     C                   MOVE      0             #DISWK            4 4
     C                   GOTO      ECALDT
      *
      * CALCULATE FOR TERMS TYPE '1'
      *
     C     TYP01         TAG
     C                   Z-ADD     VINDTE        ##MDY             6 0
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         IDATE             5 0
     C                   Z-ADD     ##DDD         INDTE             5 0
     C                   ADD       TCTDAS        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   MOVE      ##MDY         DUDT              6 0
      *
     C                   ADD       TCTDAY        IDATE
     C                   Z-ADD     IDATE         ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   MOVE      ##MDY         CSHDUE            6 0
     C                   Z-ADD     CSHDUE        ##MDY             6 0
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DIDTE             5 0
     C                   GOTO      ECALDT
      *
      * CALCULATE TERMS TYPE '2'
      *
     C     TYP02         TAG
      *
      * GET CURRENT DAY OF MONTH FOR CUTOFF TEST
      *
     C                   MOVEL     VINDTE        #WMMDD            4 0
     C                   MOVEL     #WMMDD        #WMM              2 0
     C                   MOVE      #WMMDD        #WDD              2 0
     C                   MOVE      VINDTE        #WYY              2 0
      *
      * TEST TO SEE IF LESS THAN OR EQUAL TO CUTOFF DATE
      *
     C     #WDD          COMP      TCCUTO                               5858
     C   58#WMM          ADD       TCMBCO        #WMM
     C  N58#WMM          ADD       TCMACO        #WMM
      *
      * TEST TO SEE IF MONTHS EXCEEDS 12
      *
     C     #WMM          COMP      12                                 54
     C   54#WMM          SUB       12            #WMM
     C   54#WYY          ADD       1             #WYY
      *
     C                   MOVEL     #WMM          #WMMDD
     C   58              MOVE      TCNBCO        #WMMDD
     C  N58              MOVE      TCNACO        #WMMDD
     C                   MOVEL     #WMMDD        DUDT
     C                   MOVE      #WYY          DUDT
      *
      * CALCULATE DISCOUNT DUE DATE
      *
     C   58TCDBCO        COMP      0                                      59
     C  N58TCDACO        COMP      0                                      59
     C   59              MOVE      UDATE         CSHDUE
     C   58
     CANN59              MOVE      TCDBCO        #WMMDD
     C  N58
     CANN59              MOVE      TCDACO        #WMMDD
     C  N59              MOVEL     #WMMDD        CSHDUE
     C  N59              MOVE      #WYY          CSHDUE
     C                   GOTO      ECALDT
      *
      * CALCULATE TERMS TYPE '3'
      *
     C     TYP03         TAG
      *
     C                   MOVE      TCNDUE        DUDT
      *
     C     TCDDUE        IFEQ      0
     C                   Z-ADD     TDATE         CSHDUE
     C                   ELSE
     C                   Z-ADD     TCDDUE        CSHDUE
     C                   ENDIF
      *
     C     ECALDT        TAG
      *
      * CALCULATE DISCOUNT AVAILABLE BASED ON TERMS
      *
     C                   Z-ADD     0             DVAL              7 2
     C     VTYPE         IFEQ      1
     C     VAMT          MULT(H)   #DISWK        DVAL                           NOT FRGHT/CRM
     C                   ENDIF
      *
      * LOAD WORK FIELDS.
      *
     C     ETERMS        TAG
      *
     C                   Z-ADD     DUDT          VIDDTE
     C     RDATE         IFLE      DIDTE
     C     DVAL          ANDGT     0
     C                   Z-ADD     CSHDUE        VDDDTE
     C                   Z-ADD     DVAL          VDISC
     C                   ELSE
     C*                    Z-ADD0         VIDDTE
     C                   Z-ADD     0             VDDDTE
     C                   Z-ADD     0             VDISC
     C                   Z-ADD     0             Y                 2 0
     C                   ENDIF
      *
     C                   ENDSR
      **********
      * GETREC *
      **********
     C     GETREC        BEGSR
     C                   MOVEL     'A'           ANSTAT
     C                   Z-ADD     VVEND         ANVEND
     C                   Z-ADD     VCO           ANCOMP
     C                   Z-ADD     0             ANVOUC
     C                   MOVEL     VINV#         ANINV#
     C                   Z-ADD     0             ANSEQ#
     C                   MOVEL     INVTYP        ANITYP
     C                   MOVEL     *BLANKS       ANVTYP
     C                   Z-ADD     VINDTE        ANIVDT
     C     DUDT          MULT      10000.01      RVDATE            6 0
     C                   MOVEL     RVDATE        YR                2 0
     C     YR            IFGT      70
     C                   MOVEL     19            CYR               2 0
     C                   ELSE
     C                   MOVEL     20            CYR
     C                   ENDIF
     C                   MOVEL     CYR           ANRVDU
     C                   MOVE      RVDATE        ANRVDU
     C                   Z-ADD     DUDT          ANDUDT
     C                   Z-ADD     VDDDTE        ANDCDT
     C                   MOVEL     VMTMCD        ANVTCD
     C     VTYPE         IFEQ      2
     C                   Z-SUB     VAMT          AN$AMT
     C                   Z-SUB     VAMT          ANDUE$
     C                   ENDIF
     C     VTYPE         IFNE      2
     C                   Z-ADD     VAMT          AN$AMT
     C                   Z-ADD     VAMT          ANDUE$
     C                   ENDIF
     C                   Z-ADD     DVAL          ANDAVL
     C                   Z-ADD     TCTRAT        ANTRAT
     C                   MOVEL     *BLANKS       ANDOVT
     C                   Z-ADD     0             ANDTAK
     C                   Z-ADD     0             ANPAID
     C                   Z-ADD     0             ANGLAC
     C                   Z-ADD     TDATE         ANTDAT
     C                   Z-ADD     0             ANTTYP
     C                   MOVEL     VDESC         ANTDES
     C                   MOVEL     VMLOOK        ANLOOK
     C                   MOVEL     *BLANKS       ANCLCD
     C                   Z-ADD     0             ANCHEK
     C                   Z-ADD     0             ANCKDT
     C                   Z-ADD     0             ANPSDT
     C                   Z-ADD     0             ANBTCH
     C                   MOVEL     *BLANKS       ANTBPD
     C                   MOVEL     VMMVPC        ANMVPC
     C                   Z-ADD     TDATE         ANDTLA
     C                   Z-ADD     TIMOD         ANTIME
     C                   MOVEL     USERID        ANUSER
     C                   Z-ADD     VINDTE        ANAPER
     C                   Z-ADD     0             AN$TOP
     C                   Z-ADD     0             ANDISC
     C                   ENDSR
      *
