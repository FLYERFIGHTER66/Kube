      *%*******************************************************************
      *%                                                                 **
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- Dietz & Watson Chain Store Billing              **
      *%                                                               ?**
      *********************************************************************
      *                                                                   *
      * Program?- SIT126R                                                *
      *                                                                   *
      * Purpose?- Print Itinerary History Report By Date                 *
      *            Uses Wintouch Files                                    *
      *                                                                   *
      *   Date  ?Programmer    ? Comment                             ? *
      *   1/06/03  R. Piasecki      Program Created                       *
      *                                                                   *
      *********************************************************************
     FTRANWORK  IP   E           K DISK                                         DWUPDT
     FKP4011P   O    E             PRINTER OFLIND(*IN11)
     D MDS             S              9    DIM(12) CTDATA PERRCD(1)
      *****************************************************************
      * ?Program Status Data Structure?                               *
      *****************************************************************
     D                SDS
     D  PGRM##           *PROC
     D  PARM##           *PARMS
     D  PERR##                91    169
     D  JOB##                244    253
     D  USER##               254    263
     D  JOBN##               264    269
     D  JBDT##               276    281  0
     D  TIME@@               282    287  0
     D                 DS
     D  WCSDTE                 1      8  0 INZ(0)
     D  FRCCYY                 1      4  0
     D  FRMM                   5      6  0
     D  FRDD                   7      8  0
     D                 DS
     D  WCEDTE                 1      8  0 INZ(0)
     D  TOCCYY                 1      4  0
     D  TOMM                   5      6  0
     D  TODD                   7      8  0
     D                 DS
     D  DHCYMD                 1      8  0 INZ(0)
     D  SICCYY                 1      4  0
     D  SIMM                   5      6  0
     D  SIDD                   7      8  0
     D  SIDTE                  3      8  0
     IDGHISTR       01
     I                                          DHUSER        L1
     I                                          DHCYMD        L2
      *****************************************************************
      * ?Mainline Routine                                          ? *
      *****************************************************************
      *****
      * ?Print Itinerary History Report                                 ?*
      *****                                                            ***
     C*                                                                ***
     C*                                                                ***
     C     *IN90         IFEQ      *OFF
     C                   MOVE      *ON           *IN90
     C                   WRITE     HEADER
     C                   ENDIF
      *
     C     SIDTE         MULT      100.0001      DATE              6 0
     C                   MOVEL     DHPITM        ITEM
      *
     C     *INL2         IFEQ      *ON
     C     *IN11         IFEQ      *OFF
     C                   WRITE     HEADL1
     C                   ENDIF
     C                   ENDIF
     C*                                                                ***
     C                   WRITE     DETAIL
     C                   EXSR      CKOVR
      *
      *****************************************************************
      * ?*INZSR - Initialization                                   ? *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    USER             10
     C                   PARM                    FDTE              8
     C                   PARM                    TDTE              8
     C                   MOVE      FDTE          WCSDTE            8 0
     C                   MOVE      TDTE          WCEDTE            8 0
     C                   MOVE      FRMM          M#                2 0
     C                   MOVE      FRDD          DAY               2 0
     C                   MOVE      FRCCYY        CCYY              4
     C                   EXSR      $ALDTE
     C                   MOVEL     WKALDT        FRMDTE
     C                   MOVE      TOMM          M#
     C                   MOVE      TODD          DAY               2 0
     C                   MOVE      TOCCYY        CCYY              4
     C                   EXSR      $ALDTE
     C                   MOVEL     WKALDT        TODTE
      *
     C     USER          IFEQ      *BLANKS
     C                   MOVE      *ON           *IN50
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * ?$ALDTE - Converts date to alpha format                     ? *
      *****************************************************************
     CSR   $ALDTE        BEGSR
      *
      * ?Put month name in alpha field
      *
     C                   MOVEL(P)  MDS(M#)       WKALDT           18
     C                   MOVE      DAY           WKDD              2 0
      *
      * ?Put day of month in alpha field
      *
     C     DAY           IFLE      9
     C                   MOVE      DAY           WKD1              1
     C                   CAT       WKD1:1        WKALDT
     C                   ELSE
     C                   MOVE      DAY           WKD2              2
     C                   CAT       WKD2:1        WKALDT
     C                   ENDIF
      *
      * ?Put century in alpha field
      *
     C                   CAT       ',':0         WKALDT
     C                   CAT       CCYY:1        WKALDT
      *
     C                   ENDSR
      *****************************************************************
      * ?CKOVR  - Check Overflow Routine                            ? *
      *****************************************************************
     CSR   CKOVR         BEGSR
     C     *IN11         IFEQ      *ON
     C                   WRITE     HEADER
     C                   WRITE     HEADL1
     C                   MOVE      '0'           *IN11
     C                   ENDIF
     C                   ENDSR
** MDS - Month descriptions
January
February
March
April
May
June
July
August
September
October
November
December
