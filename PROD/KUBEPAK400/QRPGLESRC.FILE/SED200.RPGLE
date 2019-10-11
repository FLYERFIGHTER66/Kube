      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1997
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
      **PROGRAM NAME-------- SEED200
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SEED INVENTORY RECEIPTS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FSED200FM  CF   E             WORKSTN
     FFMVEND    IF   E           K DISK
     FFMINVT    UF   E           K DISK
     FFSEDLOT   UF A E           K DISK
     FFSEDTRN   O  A E             DISK
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LDAPTO                 1      1  0                                      ARC380
      ***********************
      ** MAIN LINE CODE    **
      ***********************
     C     RSTART        TAG
     C                   TIME                    TIMOD             6 0
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       IMDES1
     C**                   Z-ADD0         VEND
     C                   Z-ADD     0             QTYREC
     C                   Z-ADD     0             GRMPCT
     C                   Z-ADD     0             TSTDAT
     C**                   MOVE *BLANKS   VMNAME
     C                   MOVE      *BLANKS       VLOT#
     C                   SETOFF                                       102030
     C                   SETOFF                                       509899
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       102030
     C                   SETOFF                                       50  99
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C   KA              DO
     C                   MOVEL     *BLANKS       VMLOOK
     C                   CALL      'VENDLOOK'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP            2 0
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C**                   MOVEL*BLANKS   VALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        VEND
     C                   GOTO      NXTA
     C                   END
     C                   MOVEL     ITEM          VITST             1
     C     VITST         IFEQ      '?'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     ITEM:2        IMLOOK
     C                   MOVEL     '   '         SHPFR
     C                   CALL      'ITMALOKS'
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
     C**                   MOVELIMSIZE    VSIZE
     C**                   MOVELIMWHSE    VWHSE
     C                   GOTO      NXTA
     C                   ENDIF
     C                   MOVEL     'SED'         SLSIZE
     C     MINKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SLSIZE
     C     MINKEY        CHAIN     FMINVT                             10
     C   10              SETON                                        99
     C   99              GOTO      NXTA
      ** CHECK VENDOR
     C     VEND          IFGT      0
     C     VEND          CHAIN     FMVEND                             20
     C   20              SETON                                        99
     C   99              GOTO      NXTA
     C                   END
      ** CHECK QUANTITY
     C     QTYREC        IFEQ      0
     C                   SETON                                        3099
     C                   GOTO      NXTA
     C                   END
      ** CHECK TEST DATE
     C     TSTDAT        IFGT      0
     C                   Z-ADD     TSTDAT        ##MDY
     C                   EXSR      @DT@A1
     C   90              SETON                                        5099
     C   99              GOTO      NXTA
     C                   END
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   ENDDO
      ** IF HERE WRITE RECORD AND START OVER
     C                   ADD       QTYREC        IMQTOH
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C                   UPDATE    RMINVT
     C     SLTKEY        KLIST
     C                   KFLD                    SLITEM
     C                   KFLD                    SLSIZE
     C                   KFLD                    SLLOC
     C                   KFLD                    SLVEND
     C                   KFLD                    SLVLOT
     C                   MOVE      *BLANKS       SLLOC
     C                   MOVEL     ITEM          SLITEM
     C                   MOVEL     'SED'         SLSIZE
     C                   Z-ADD     VEND          SLVEND
     C                   MOVEL     VLOT#         SLVLOT
     C     SLTKEY        CHAIN     FSEDLOT                            91
     C   91              DO
     C                   Z-ADD     0             SLQTOH
     C                   Z-ADD     0             SLQTRX
     C                   Z-ADD     0             SLQTIS
     C                   Z-ADD     0             SLQTAJ
     C                   ENDDO
     C                   ADD       QTYREC        SLQTOH
     C                   ADD       QTYREC        SLQTRX
     C                   Z-ADD     GRMPCT        SLGRPC
     C                   Z-ADD     TSTDAT        SLTSDT
     C   91              WRITE     RSEDLOT
     C  N91              UPDATE    RSEDLOT
     C                   TIME                    STTIME
     C                   MOVEL     USERID        STUSER
     C                   MOVEL     'R'           STTRNT
     C                   MOVEL     'A'           STSTAT
     C                   MOVEL     SLITEM        STITEM
     C                   MOVEL     SLSIZE        STSIZE
     C                   MOVEL     SLLOC         STLOC
     C                   Z-ADD     QTYREC        STQTY
     C                   Z-ADD     VEND          STVEND
     C                   MOVEL     VLOT#         STVLOT
     C                   Z-ADD     GRMPCT        STGRPC
     C                   Z-ADD     TSTDAT        STTSDT
     C                   WRITE     RSEDTRN
     C                   GOTO      RSTART
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        SLRXDT
     C                   Z-ADD     ##CYMD        STTRND
     C                   ENDSR
      ********************************************************************@DT@A1
      * VALIDATE DATES. INDICATOR 90 IS ON IF ERROR. 91-92 ALWAYS SETOF.  @DT@A1
      * YY GE 00  MM 01-12 DAY 01-28/29/30/31                             @DT@A1
      * ##MDY INPUT DATE MMDDYY                                           @DT@A1
      * ##CYMD OUTPUT DATE CYYMMDD IF DATE IS OK. ELSE ZERO.              @DT@A1
      * C IDENTIFIES 20 OR 21 CENTURY. C=0 FOR YY 70-99. C=1 FOR YY 00-69.@DT@A1
     C     @DT@A1        BEGSR                                                                 @DT@A
     C                   MOVE      ##MDY         #03A              3 0          MYY            @DT@A
     C                   MOVEL     0             #03A                           CYY            @DT@A
     C                   MOVEL     ##MDY         #04               4 0          MMDD           @DT@A
     C                   MOVEL     ##MDY         #02B              2 0          MM             @DT@A
     C                   MOVE      #04           #02C              2 0          DD             @DT@A
     C                   Z-ADD     ##MDY         ##MDY             6 0  90      YY IS NEGATIVE @DT@A
     C  N90              Z-ADD     #02B          #02               2 0    90    MM LT 01 ERROR @DT@A
     C  N90#02B          COMP      12                                 90        MM GT 12 ERROR @DT@A
     C  N90#02C          COMP      01                                   90      DD LT 01 ERROR @DT@A
     C  N90#02C          COMP      31                                 90  91    DD GT OR EQ 31 @DT@A
     C     #02B          COMP      07                                 92        MM 08-12       @DT@A
     C   921             ADD       #02B          #02                            MAKE MM ODD    @DT@A
     C     #02           DIV       2             #02                                           @DT@A
     C                   MVR                     #02                  92        31 DAY MONTH   @DT@A
     C   91
     CANN92              SETON                                        90        MM EVEN DD 31  @DT@A
     C     #02B          COMP      02                                     91    FEB            @DT@A
     C  N91                                                                                    @DT@A
     COR 90              GOTO      @DT@AX                                                      @DT@A
     C     #03A          DIV       4             #03               3 0          JUST FOR MVR   @DT@A
     C                   MVR                     #02                      91    LEAP YEAR      @DT@A
     C     #02C          COMP      29                                 90  92    DD GT 29 ERROR @DT@A
     C  N91
     CAN 92              SETON                                        90        NO LEAP DD 29  @DT@A
     C     @DT@AX        TAG                                                    GOOD DATE      @DT@A
     C                   MOVEL     #03A          ##CYMD            7 0          CYY----        @DT@A
     C                   MOVE      #04           ##CYMD                         CYYMMDD        @DT@A
     C     #03A          COMP      070                                  91                     @DT@A
     C   91              MOVEL     1             ##CYMD                         21ST CENTURY   @DT@A
     C   90              Z-ADD     0             ##CYMD                         ERROR          @DT@A
     C                   SETOFF                                       9192                     @DT@A
     C                   ENDSR                                                                 @DT@A
