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
      *PROGRAM NAME-------- CSTALOOK
      *SYSTEM-------------- LOOKUP
      *DESCRIPTION--------- CUSTOMER ALPHA SEARCH
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCUSTAL  IF   E           K DISK
     FCUSTALFM  CF   E             WORKSTN
      *
     D LN              S              2  0 DIM(20)
     D CN              S              6  0 DIM(20)
     D BR              S              5    DIM(20)
     D NM              S             30    DIM(20)
     D CT              S             18    DIM(20)
     D ST              S              2    DIM(20)
     D SH              S              1    DIM(20)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    CMLOOK           15
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVE      CMLOOK        HLDLOK           15
     C                   MOVE      CMLOOK        VLOOK            15
     C                   MOVE      *BLANKS       OLDSRC           15
      *
     C     RSTRT         TAG
     C                   MOVEA     *ZEROS        LN
     C                   MOVEA     *ZEROS        CN
     C                   MOVEA     *BLANKS       BR
     C                   MOVEA     *BLANKS       NM
     C                   MOVEA     *BLANKS       CT
     C                   MOVEA     *BLANKS       ST
     C                   Z-ADD     1             X                 2 0
     C                   Z-ADD     0             LINE#
     C     OLDSRC        IFNE      VLOOK
     C     VLOOK         SETLL     FMCUSTAL
     C                   MOVE      VLOOK         OLDSRC
     C                   ENDIF
     C     NXTX          TAG
     C                   SETOFF                                       010203
     C                   SETOFF                                       040506
     C                   SETOFF                                       070809
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       161718
     C                   SETOFF                                       1920
     C                   SETOFF                                       50
     C                   READ      FMCUSTAL                               50
     C   50              GOTO      ENDX
     C     CMSTAT        IFEQ      'D'
     C                   GOTO      NXTX
     C                   ENDIF
     C     CMBLCU        IFNE      CMCUST
     C                   MOVE      '1'           *IN(X)
     C                   MOVE      '*'           SH(X)
     C                   ELSE
     C                   MOVE      '0'           *IN(X)
     C                   MOVE      ' '           SH(X)
     C                   ENDIF
     C                   Z-ADD     X             LN(X)
     C                   Z-ADD     CMCUST        CN(X)
     C                   MOVEL     CMBABB        BR(X)
     C                   MOVEL     CMNAME        NM(X)
     C                   MOVEL     CMCITY        CT(X)
     C                   MOVEL     CMSTST        ST(X)
     C                   ADD       1             X
     C     X             IFLE      20
     C                   GOTO      NXTX
     C                   ENDIF
     C     ENDX          TAG
     C     X             IFLE      20
     C     X             ANDGT     0
     C                   Z-ADD     *ZEROS        CN(X)
     C                   MOVE      *BLANKS       NM(X)
     C                   MOVE      *BLANKS       SH
     C                   MOVE      *BLANKS       OLDSRC
     C                   MOVEL     '* End of'    ENDD             16
     C                   MOVE      ' Data * '    ENDD
     C                   MOVEL     ENDD          NM(X)
     C                   ENDIF
     C                   SUB       1             X
      *
     C                   EXSR      LOADC
     C     OUTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       1050
     C                   READ      SCRNA                                  90
     C** KF                SETON                     LR
     C   KF              Z-ADD     *ZEROS        CMCUST
     C   KF              GOTO      END
     C   50LINE#         IFEQ      0
     C*          VLOOK     ANDEQOLDSRC
     C                   MOVEL     HLDLOK        VLOOK
     C                   GOTO      RSTRT
     C                   ENDIF
     C     LINE#         IFGT      0
     C     LINE#         ANDLE     20
     C                   Z-ADD     CN(LINE#)     CMCUST
     C                   MOVEL     NM(LINE#)     CMNAME
     C**                   SETON                     LR
     C                   GOTO      END
     C                   ENDIF
     C     LINE#         IFGT      X
     C                   SETON                                        10
     C                   GOTO      OUTA
     C                   ELSE
     C                   Z-ADD     0             LINE#
     C                   ENDIF
     C                   GOTO      RSTRT
     C     END           TAG
     C*******              SETON                     LR
     C                   RETURN
      *
     C     LOADC         BEGSR
     C                   Z-ADD     CN(1)         CN1
     C                   Z-ADD     CN(2)         CN2
     C                   Z-ADD     CN(3)         CN3
     C                   Z-ADD     CN(4)         CN4
     C                   Z-ADD     CN(5)         CN5
     C                   Z-ADD     CN(6)         CN6
     C                   Z-ADD     CN(7)         CN7
     C                   Z-ADD     CN(8)         CN8
     C                   Z-ADD     CN(9)         CN9
     C                   Z-ADD     CN(10)        CN10
     C                   Z-ADD     CN(11)        CN11
     C                   Z-ADD     CN(12)        CN12
     C                   Z-ADD     CN(13)        CN13
     C                   Z-ADD     CN(14)        CN14
     C                   Z-ADD     CN(15)        CN15
     C                   Z-ADD     CN(16)        CN16
     C                   Z-ADD     CN(17)        CN17
     C                   Z-ADD     CN(18)        CN18
     C                   Z-ADD     CN(19)        CN19
     C                   Z-ADD     CN(20)        CN20
      **
     C                   Z-ADD     LN(1)         LN1
     C                   Z-ADD     LN(2)         LN2
     C                   Z-ADD     LN(3)         LN3
     C                   Z-ADD     LN(4)         LN4
     C                   Z-ADD     LN(5)         LN5
     C                   Z-ADD     LN(6)         LN6
     C                   Z-ADD     LN(7)         LN7
     C                   Z-ADD     LN(8)         LN8
     C                   Z-ADD     LN(9)         LN9
     C                   Z-ADD     LN(10)        LN10
     C                   Z-ADD     LN(11)        LN11
     C                   Z-ADD     LN(12)        LN12
     C                   Z-ADD     LN(13)        LN13
     C                   Z-ADD     LN(14)        LN14
     C                   Z-ADD     LN(15)        LN15
     C                   Z-ADD     LN(16)        LN16
     C                   Z-ADD     LN(17)        LN17
     C                   Z-ADD     LN(18)        LN18
     C                   Z-ADD     LN(19)        LN19
     C                   Z-ADD     LN(20)        LN20
      **
     C                   MOVEL     BR(1)         BR1
     C                   MOVEL     BR(2)         BR2
     C                   MOVEL     BR(3)         BR3
     C                   MOVEL     BR(4)         BR4
     C                   MOVEL     BR(5)         BR5
     C                   MOVEL     BR(6)         BR6
     C                   MOVEL     BR(7)         BR7
     C                   MOVEL     BR(8)         BR8
     C                   MOVEL     BR(9)         BR9
     C                   MOVEL     BR(10)        BR10
     C                   MOVEL     BR(11)        BR11
     C                   MOVEL     BR(12)        BR12
     C                   MOVEL     BR(13)        BR13
     C                   MOVEL     BR(14)        BR14
     C                   MOVEL     BR(15)        BR15
     C                   MOVEL     BR(16)        BR16
     C                   MOVEL     BR(17)        BR17
     C                   MOVEL     BR(18)        BR18
     C                   MOVEL     BR(19)        BR19
     C                   MOVEL     BR(20)        BR20
      **
     C                   MOVEL     NM(1)         NM1
     C                   MOVEL     NM(2)         NM2
     C                   MOVEL     NM(3)         NM3
     C                   MOVEL     NM(4)         NM4
     C                   MOVEL     NM(5)         NM5
     C                   MOVEL     NM(6)         NM6
     C                   MOVEL     NM(7)         NM7
     C                   MOVEL     NM(8)         NM8
     C                   MOVEL     NM(9)         NM9
     C                   MOVEL     NM(10)        NM10
     C                   MOVEL     NM(11)        NM11
     C                   MOVEL     NM(12)        NM12
     C                   MOVEL     NM(13)        NM13
     C                   MOVEL     NM(14)        NM14
     C                   MOVEL     NM(15)        NM15
     C                   MOVEL     NM(16)        NM16
     C                   MOVEL     NM(17)        NM17
     C                   MOVEL     NM(18)        NM18
     C                   MOVEL     NM(19)        NM19
     C                   MOVEL     NM(20)        NM20
      **
     C                   MOVEL     CT(1)         CT1
     C                   MOVEL     CT(2)         CT2
     C                   MOVEL     CT(3)         CT3
     C                   MOVEL     CT(4)         CT4
     C                   MOVEL     CT(5)         CT5
     C                   MOVEL     CT(6)         CT6
     C                   MOVEL     CT(7)         CT7
     C                   MOVEL     CT(8)         CT8
     C                   MOVEL     CT(9)         CT9
     C                   MOVEL     CT(10)        CT10
     C                   MOVEL     CT(11)        CT11
     C                   MOVEL     CT(12)        CT12
     C                   MOVEL     CT(13)        CT13
     C                   MOVEL     CT(14)        CT14
     C                   MOVEL     CT(15)        CT15
     C                   MOVEL     CT(16)        CT16
     C                   MOVEL     CT(17)        CT17
     C                   MOVEL     CT(18)        CT18
     C                   MOVEL     CT(19)        CT19
     C                   MOVEL     CT(20)        CT20
      **
     C                   MOVEL     ST(1)         ST1
     C                   MOVEL     ST(2)         ST2
     C                   MOVEL     ST(3)         ST3
     C                   MOVEL     ST(4)         ST4
     C                   MOVEL     ST(5)         ST5
     C                   MOVEL     ST(6)         ST6
     C                   MOVEL     ST(7)         ST7
     C                   MOVEL     ST(8)         ST8
     C                   MOVEL     ST(9)         ST9
     C                   MOVEL     ST(10)        ST10
     C                   MOVEL     ST(11)        ST11
     C                   MOVEL     ST(12)        ST12
     C                   MOVEL     ST(13)        ST13
     C                   MOVEL     ST(14)        ST14
     C                   MOVEL     ST(15)        ST15
     C                   MOVEL     ST(16)        ST16
     C                   MOVEL     ST(17)        ST17
     C                   MOVEL     ST(18)        ST18
     C                   MOVEL     ST(19)        ST19
     C                   MOVEL     ST(20)        ST20
      **
     C                   MOVEL     SH(1)         SH1
     C                   MOVEL     SH(2)         SH2
     C                   MOVEL     SH(3)         SH3
     C                   MOVEL     SH(4)         SH4
     C                   MOVEL     SH(5)         SH5
     C                   MOVEL     SH(6)         SH6
     C                   MOVEL     SH(7)         SH7
     C                   MOVEL     SH(8)         SH8
     C                   MOVEL     SH(9)         SH9
     C                   MOVEL     SH(10)        SH10
     C                   MOVEL     SH(11)        SH11
     C                   MOVEL     SH(12)        SH12
     C                   MOVEL     SH(13)        SH13
     C                   MOVEL     SH(14)        SH14
     C                   MOVEL     SH(15)        SH15
     C                   MOVEL     SH(16)        SH16
     C                   MOVEL     SH(17)        SH17
     C                   MOVEL     SH(18)        SH18
     C                   MOVEL     SH(19)        SH19
     C                   MOVEL     SH(20)        SH20
      **
     C                   ENDSR
