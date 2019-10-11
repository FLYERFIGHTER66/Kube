    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *--------------------------------------------------------------
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
      **PROGRAM NAME-------- TRR110
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TRUCK SCHEDULE
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CREATE TRUCK SCHEDULE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  4/18/02 EFD MOVE ROUT NUMBER INTO TRUCK NUMBER.
      *
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:CALEN)
     FFCALENCY  IF   E           K DISK
     FFMSVIA    IF   E           K DISK
     FFMCUST    UF   E           K DISK
     FFTRUCKSR  UF   E           K DISK
     FFTRSTAT   UF A E           K DISK
     FFTRSCHD   O  A E           K DISK
     FFTRHDRH   O  A E           K DISK
     FFHORDR    UF   E           K DISK
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$MDYDate
      *
      ** MCUST ARRAYS
     D RT              S              2    DIM(7)                               ROUTE M THR S
     D ST              S              3  0 DIM(7)                               STOP #
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
     D  LCO                    1      2  0                                      ARC380
     D  BEGDT                  3      8  0                                      ARC380
     D  ENDDT                  9     14  0                                      ARC380
     D  YEAR                  15     18  0                                      ARC380
     D  WEEK                  19     20  0                                      ARC380
     D  BEGCYM                21     27  0                                      ARC380
     D  CANCEL               133    133                                         ARC380
      *
     IRMCUST
     I              CMRTE1                      RT(1)
     I              CMRTE2                      RT(2)
     I              CMRTE3                      RT(3)
     I              CMRTE4                      RT(4)
     I              CMRTE5                      RT(5)
     I              CMRTE6                      RT(6)
     I              CMRTE7                      RT(7)
     I              CMSTP1                      ST(1)
     I              CMSTP2                      ST(2)
     I              CMSTP3                      ST(3)
     I              CMSTP4                      ST(4)
     I              CMSTP5                      ST(5)
     I              CMSTP6                      ST(6)
     I              CMSTP7                      ST(7)
      ***********************
      ** START OR RESTART  **
      ***********************
      ** GET CALEN WEEK INFGO
     C     BEGCYM        CHAIN     FCALENCY                           90
     C*                  MOVE      YEAR          CLYEAR
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    TSDAY#
     C                   Z-ADD     0             LSTSEQ            3 0
      ** TRANSFER FILE
     C     BEGCYM        SETLL     FTRUCKSR
     C     NXTBLD        TAG
     C     BEGCYM        READE     FTRUCKSR                               90
     C   90              GOTO      ENDBLD
      ** IF OUR TRUCK
     C     TSSVIA        IFEQ      '01'
     C     TSCUST        CHAIN     FMCUST                             88
     C                   Z-ADD     TSDAY#        D                 1 0
     C**         RT,D      IFLE *BLANKS
     C                   MOVEL     TSROUT        RT(D)
     C                   Z-ADD     TSSTOP        ST(D)
     C  N88              UPDATE    RMCUST
     C**                   END
     C                   ELSE                                                   TSSVIA=01
      ** ALL SHIP VIAS EXCPT 01 CAN HAVE BLANK ROUT AND DAY #.
     C     TSROUT        IFLE      *BLANKS
     C                   MOVEL     TSSVIA        TSROUT
     C                   END
     C     TSDAY#        IFLE      0
     C                   Z-ADD     1             TSDAY#
     C                   END
     C                   END                                                    TSSVIA=01
     C     CALKEY        CHAIN     FCALEX                             91
     C                   Z-ADD     CLCYMD        TRSHDT
     C                   Z-ADD     TSSTOP        TRSTOP
     C                   Z-ADD     TSCUST        TRCUST
     C                   Z-ADD     TSORD#        TRORD#
     C                   Z-ADD     TSQTY1        TRQTY1
     C                   Z-ADD     TSQTY2        TRQTY2
     C                   Z-ADD     TSQTY3        TRQTY3
     C                   Z-ADD     TSQTY4        TRQTY4
     C                   Z-ADD     TSQTY5        TRQTY5
     C                   Z-ADD     TSQTY6        TRQTY6
     C                   MOVEL     TSROUT        TRROUT
     C                   MOVEL     TSROUT        TRTRK#
     C                   Z-ADD     TSSEQ#        TRSEQ#
     C     TSSEQ#        IFGT      LSTSEQ
     C                   Z-ADD     TSSEQ#        LSTSEQ
     C                   END
     C                   WRITE     RTRSCHD
     C     TRORD#        CHAIN     FHORDR
     C                   If        %Found(FHORDR)
     C                   Eval      OHDTCN = $MDYDate($Date(TRSHDT))
     C                   Eval      OHROUT = TRTRK#
     C                   Eval      OHSTOP = TRSTP#
     C                   Update    RHORDR
     C                   EndIf
      ** GET HEADER REC IF NEEDED (ON FIRST DETAIL RECORD)
     C     TRROUT        IFNE      THROUT
     C     TRSHDT        ORNE      THSHDT
     C     TSSVIA        CHAIN     FMSVIA                             92
     C   92              MOVE      *BLANKS       THCOMM
     C  N92              MOVEL     SVDESC        THCOMM
     C                   MOVEL     TRROUT        THROUT
     C                   MOVEL     TRROUT        THTRK#
     C                   Z-ADD     TRSHDT        THSHDT
WJB  C                   MOVE      '8:00 AM'     THSTOP
     C                   WRITE     RTRHDRH
     C                   END
     C                   DELETE    RTRUCKS
     C                   GOTO      NXTBLD
      ** END BUILD
     C     ENDBLD        TAG
     C     BEGCYM        CHAIN     FTRSTAT                            91
     C   91              DO
     C                   CLEAR                   RTRSTAT
     C                   Z-ADD     BEGCYM        STSHDT
     C                   Z-ADD     LSTSEQ        STNSEQ
     C                   ENDDO
     C                   MOVEL     'Y'           STTRNR
     C                   Z-ADD     TDATE         STTRND
     C                   Z-ADD     TIMOD         STTRNT
     C                   MOVEL     USERID        STTRNU
     C   91              WRITE     RTRSTAT
     C  N91              UPDATE    RTRSTAT
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
