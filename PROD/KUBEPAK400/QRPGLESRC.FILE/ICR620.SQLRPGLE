      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.,  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ICR620
      *SYSTEM-------------- INVENTORY
      *APPLICATION--------- POST PHYSICAL TO BOOK
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  7/24/00 EFD ALLOW ZERO OF LOT ITEMS.  EFD01
      *
     FFMINVT    UF   E           K DISK
     FFTINVT    O  A E           K DISK
      *
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)
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
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
     D  LBCODE                 3      4
     D  LECODE                 5      6
     D  LBLOC                  7      9
     D  LELOC                 10     12
     D  LBLIST                13     16
     D  LELIST                17     20
     D  LBPC                  21     22
     D  LEPC                  23     24
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     D  LDELETE              172    172
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ITYDAT
      *
     C     LBCODE        IFGT      *BLANKS
     C                   SETON                                        01
     C                   ENDIF
      *
     C     LBLOC         IFGT      *BLANKS
     C     LELOC         ORGT      *BLANKS
     C                   SETON                                        02
     C                   ENDIF
      *
     C     LBLIST        IFGT      *BLANKS
     C                   SETON                                        03
     C                   ENDIF
      *
     C     LBPC          IFGT      *BLANKS
     C                   SETON                                        04
     C                   ENDIF
      *
     C     NXT           TAG
     C                   Z-ADD     0             DIFF
     C                   Z-ADD     0             ITTQTY
     C                   READ      FMINVT                                 90
     C   90              GOTO      END
      *
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
EFD01C*          IMLOTC    IFEQ 'Y'
EFD01C*                    GOTO NXT
EFD01C*                    ENDIF
      *
     C   01IMCYCD        IFLT      LBCODE                                                      ARC38
     C     IMCYCD        ORGT      LECODE                                                      ARC38
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   02IMWHSE        IFLT      LBLOC                                                       ARC38
     C     IMWHSE        ORGT      LELOC                                                       ARC38
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   03IMLIST        IFLT      LBLIST
     C     IMLIST        ORGT      LELIST
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   04IMPCL1        IFLT      LBPC
     C     IMPCL1        ORGT      LEPC
     C                   GOTO      NXT
     C                   ENDIF
      *
      * 10 = NEGATIVE ADJUST
      * 20 = POSITIVE ADJUST
      *
     C     IMQPHY        SUB       IMQTOH        DIFF             11 1
      *
     C                   Z-ADD     DIFF          ITTQTY
      *
     C                   Eval      ITREAS = 'PHY'
     C                   EXSR      UTINVT
      *
     C                   Z-ADD     IMQPHY        IMQTOH
     C                   Z-ADD     0             IMQPHY
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C                   ADD       DIFF          IMMADJ
     C     IMUCST        MULT(H)   IMQTOH        IMCSOH
     C                   UPDATE    RMINVT
      *
     C                   If        LDELETE = 'Y'
      /Free
         Exec SQL
           Delete from FTINVT where ITITEM = :IMITEM and ITSIZE = :ITSIZE;
      /End-Free
     C                   Eval      ITREAS = 'CLR'
     C                   Z-ADD     *Zero         IMQTOH
     C                   EXSR      UTINVT
     C                   ENDIF
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      *********
      * UTINVT
      *********
     C     UTINVT        BEGSR
     C                   MOVEL     'A'           ITSTAT
     C                   MOVEL     IMITEM        ITITEM
     C                   MOVEL     IMSIZE        ITSIZE
     C                   Z-ADD     IMCOMP        ITTCOM
     C                   MOVEL     IMWHSE        ITTWSE
     C                   MOVEL     *BLANKS       ITTLOC
     C                   MOVEL     'A'           ITTYPE
     C                   Z-ADD     0             ITFCOM
     C                   MOVEL     IMWHSE        ITFWSE
     C                   MOVEL     *BLANKS       ITFLOC
     C                   Z-ADD     TDATE         ITTDAT
     C                   MOVEL     IMDES1        ITDESC
     C                   MOVEL     MSG(1)        ITTREF
     C                   MOVEL     IMPUOM        ITTUOM
     C                   MOVEL     *BLANKS       ITGLUD
     C                   Z-ADD     0             ITVEND
     C                   MOVEL     *BLANKS       ITCMRC
     C                   Z-ADD     IMUCST        ITCOST
     C                   MOVEL     *BLANKS       ITCDFL
     C                   Z-ADD     TDATE         ITDTLA
     C                   Z-ADD     TIMOD         ITTIME
     C                   MOVEL     USERID        ITUSER
     C                   MOVEL     *BLANKS       ITREPO
     C                   MOVEL     *BLANKS       ITRBLD
     C                   Z-ADD     0             ITCOAV
     C                   MOVEL     *BLANKS       ITVITM
     C                   MOVEL     *BLANKS       ITCFLG
     C                   Z-ADD     0             ITGLAC
     C                   Z-ADD     0             ITUPC
     C                   Z-ADD     0             ITULC
     C                   Z-ADD     0             ITUIC
     C                   Z-ADD     0             ITTRAN
     C                   Z-ADD     0             ITORD#
     C                   Z-ADD     0             ITSEQ#
     C                   MOVEL     *BLANKS       ITLOT
     C                   MOVEL     *BLANKS       ITRSCD
     C                   Z-ADD     0             ITLBS#
     C                   Z-ADD     0             ITYWGT
     C*                  MOVEL     'PHY'         ITREAS
     C                   WRITE     RTINVT
     C                   ENDSR
**
Physical Inventory Adjustment
