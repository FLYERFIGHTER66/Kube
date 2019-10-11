    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

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
      **PROGRAM NAME-------- PRGIORDR
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **DESCRIPTION--------- THIS PROGRAM PROMPTS FOR DATE AND SHIP
      **                     FROM DATA TO DETERMINE WHICH FIORDR RECORDS
      **                     SHOULD BE DELETED.  THOSE RECORDS
      **                     ARE DELETED.
      **
      *            **     PROGRAM CHANGE LOG    **
      *
      *
     FPRGIORFM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFIORDR    UF   E           K DISK
     FFHORDR    UF   E           K DISK
     FFHORDRHISTO  A E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
      *
     D @MDY            S              1    DIM(8)
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND
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

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$TimeStamp

      *
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LCANCL                 1      1                                         ARC380
      **
     C                   SETON                                        50
      *
     C                   Z-ADD     01            VCO
     C                   MOVE      *BLANKS       LCANCL
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102030
     C                   SETOFF                                       21
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
      *
      *  CHECK FOR A VALID DATE.
      *
     C     VDATE         IFEQ      *ZEROS
     C                   SETON                                        10
     C   10              GOTO      RSTRT
     C                   ENDIF
     C                   Z-ADD     VDATE         ##MDY             6 0
     C                   EXSR      @DT@A1
     C   90              SETON                                        10
     C   10              GOTO      RSTRT
      *
      *  GET DAY OF CENTURY
      *
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         PDATE             5 0
      *
      *  SHIP FROM
      *
     C     VSHFR         IFEQ      '? '
     C                   MOVEL     VSHFR         VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         VSHFR
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     VSHFR         IFGT      *BLANKS
     C     VSHFR         CHAIN     FMWHSE                             91
     C   91              SETON                                        20
     C   20              GOTO      RSTRT
     C                   SETON                                        21
     C                   ENDIF
      *
     C     VCO           CHAIN     FMCOMP                             90
     C   90              SETON                                        30
     C   30              GOTO      RSTRT
      *
     C                   ADD       1             CNT               2 0
     C     CNT           IFEQ      1
     C                   SETOFF                                       50
     C                   GOTO      RSTRT
     C                   ELSE
     C                   GOTO      CHK
     C                   ENDIF
      *
     C     CHK           TAG
     C   KA              GOTO      NXT
     C                   GOTO      RSTRT
      *
      * GET FIORDR
      *
     C     NXT           TAG
     C                   READ      FIORDR                                 90
     C   90              GOTO      NXTH1
      * IF NO HEADER DELETE
     C     OIORD#        CHAIN     FHORDR                             91
     C   91              DELETE    RIORDR
     C   91              GOTO      NXT
      *
     C     OISTAT        IFNE      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   21OISHFR        IFNE      VSHFR
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OICOMP        IFNE      VCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     OIDTRQ        ##MDY             6 0
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         IDATE             5 0
      *
     C     IDATE         IFGT      PDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   DELETE    RIORDR
     C                   GOTO      NXT
      *
      * GET FHORDR
      *
     C     NXTH1         TAG
     C                   Z-ADD     0             OHORD#
     C     OHORD#        SETLL     FHORDR
     C     NXTH          TAG
     C                   READ      FHORDR                                 90
     C   90              GOTO      END
      * IF NO DETAIL DELETE
     C     OHORD#        CHAIN     FIORDR                             91
     C   91              DELETE    RHORDR
     C                   Eval      HSTUSER    = $User()
     C                   Eval      HSTPROGRAM = 'PRGIORDR_1'
     C                   Eval      HSTTIME    = $Timestamp()
     C   91              Write     RHORDRHIST
     C   91              GOTO      NXTH
      *
     C     OHSTAT        IFNE      'D'
     C                   GOTO      NXTH
     C                   ENDIF
      *
     C   21OHSHFR        IFNE      VSHFR
     C                   GOTO      NXTH
     C                   ENDIF
      *
     C     OHCOMP        IFNE      VCO
     C                   GOTO      NXTH
     C                   ENDIF
      *
     C                   Z-ADD     OHDTRQ        ##MDY             6 0
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         HDATE             5 0
      *
     C     HDATE         IFGT      PDATE
     C                   GOTO      NXTH
     C                   ENDIF
      *
     C     OHORD#        SETLL     FIORDR
     C                   READ      FIORDR                                 91
     C     OIORD#        IFEQ      OHORD#
     C                   GOTO      NXTH
     C                   ENDIF
      *
     C                   DELETE    RHORDR
     C                   Eval      HSTUSER    = $User()
     C                   Eval      HSTPROGRAM = 'PRGIORDR_2'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
     C                   GOTO      NXTH
      *
     C     END           TAG
     C                   SETON                                        LR
      *
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
      *****
      ********************************************************************@DT@B1
      * CONVERT CYYMMDD TO DAY OF CENTURY DDDDD. INDICATOR 90 MINUS DATE  @DT@B1
      * ##CYMD INPUT DATE CYYMMDD                                         @DT@B1
      * ##DDD OUTPUT DAY OF CENTURY DDDDD. BASE DATE IS 01/01/1900        @DT@B1
      * INDICATORS USED 90-92.                                            @DT@B1
      ********************************************************************@DT@B1
     C     @DT@B1        BEGSR                                                                 @DT@B
     C                   Z-ADD     ##CYMD        ##CYMD            7 0  90      NEG DATE       @DT@B
      * CONVERT YEAR TO DAYS                                              @DT@B1
     C                   MOVEL     ##CYMD        #03               3 0          YY             @DT@B
     C     #03           MULT      365           ##DDD             5 0          FIRST LEAP     @DT@B
     C     #03           DIV       4             #03                      93    # OF LEAPS     @DT@B
     C                   MVR                     #02A              2 0    91    LEAP YEAR      @DT@B
     C   91
     CANN93#03           SUB       1             #03                                           @DT@B
     C     #03           ADD       ##DDD         ##DDD                          DAYS FOR LEAP  @DT@B
      * CONVERT MONTH TO DAYS                                             @DT@B1
     C                   MOVE      ##CYMD        #04               4 0          MMDD           @DT@B
     C                   MOVEL     #04           #02A                           MM             @DT@B
     C     #02A          IFLT      1
     C     #02A          ORGT      12
     C                   Z-ADD     1             #02A
     C                   END
     C     #DY(#02A)     ADD       ##DDD         ##DDD                          DAY OF YEAR    @DT@B
     C     #02A          COMP      02                                 92        GT FEB         @DT@B
     C   91
     CAN 92
     CANN931             ADD       ##DDD         ##DDD                          LP YR MM 3-12  @DT@B
      * ADD DAY OF MONTH                                                  @DT@B1
     C                   MOVE      ##CYMD        #02               2 0          DD             @DT@B
     C     #02           ADD       ##DDD         ##DDD                          ADD DAYS       @DT@B
     C   90              Z-ADD     0             ##DDD                                         @DT@B
     C                   SETOFF                                       919293                   @DT@B
     C                   ENDSR                                                                 @DT@B
      *********
      * LOCSR
      *********
     C     LOCSR         BEGSR
     C                   MOVEL     VWHSE         WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       VWHSE
     C                   MOVEL     WHWHSE        VWHSE
     C                   MOVEL     WHDESC        VDESC            25
     C                   ENDSR
      *
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
