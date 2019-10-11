      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      **PROGRAM NAME-------- QPK312
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SUMMARY PICK SLIB DETAIL BY CUSTOMER/ORDER
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCUST    IF   E           K DISK
     FWBIR312   IF   E           K DISK
     FQPK312    O    F  120        PRINTER OFLIND(*INOF)
      *
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LCONO                  1      2  0
     D  LCALL                  3      5
     D  LJOBQ                  6      6
     D  LP1ID                 17     24
     D  LP2ID                 27     34
     D  LDAPID                17     18
     D  LBEGDT                37     42  0
     D  LENDDT                43     48  0
     D  LSELEC                49     49  0
     D  LORDER                50     55  0
     D  LOALL                 56     58
     D  LPC1                  59     60
     D  LPC2                  61     62
     D  LRTE1                 63     64
     D  LRTE2                 65     66
     D  LPHY1                 67     67
     D  LPHY2                 68     68
     D  LPREV                 69     69
     D  LSHP1                 70     71
     D  LSHP2                 72     73
     D  LLOC1                 74     76
     D  LLOC2                 77     79
     D  LCANCL               133    133
      ***********************
      ** START HERE        **
      ***********************
     C     NXT           TAG
     C                   READ      WBIR312                                90
     C   90              GOTO      END
     C     OWCUST        IFNE      OCUST
     C     OCUST         IFGT      0
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                           OF
     C                   ENDDO
     C                   EXCEPT    TOTL
     C                   END
     C     OWCUST        CHAIN     FMCUST                             91
     C                   Z-ADD     0             CTOT              9 0
     C                   Z-ADD     OWCUST        OCUST             6 0
     C                   END
     C                   Z-ADD     OWQOPN        QOPN              9 0
     C                   ADD       OWQOPN        CTOT
     C                   ADD       OWQOPN        FTOT              9 0
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                           OF
     C                   ENDDO
     C                   EXCEPT    DETL
     C                   GOTO      NXT
     C     END           TAG
     C     OCUST         IFGT      0
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    TOTL
     C                   END
     C                   EXCEPT    TOTLR
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   SETON                                        OF
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OQPK312    E            HEAD           1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           50 'Order Summary'
     O                       PAGE          Z     85
     O                                           81 'Page:'
     O          E            HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           76 'Time:'
     O                       TIMOD               85 '  :  :  '
     O          E            HEAD           2
     O                                            5 'From:'
     O                       LBEGDT        Y     14
     O                                           18 'To:'
     O                       LENDDT        Y     27
     O                                           71 'Prod Class:'
     O                       LPC1                74
     O                                           77 'To'
     O                       LPC2                80
     O          E            HEAD           0
     O                                           10 'Order#'
     O                                           22 'Customer'
     O                                           71 'Quantity'
     O          E            HEAD           1
     O                                           10 '______'
     O                                           22 '________'
     O                                           71 '________'
     O          EF           DETL           1
     O                       OWORD#        4     10
     O                       OWCUST        4     20
     O                       CMNAME              51
     O                       QOPN          1     71
     O          EF           TOTL           1
     O                                           71 '--------'
     O          EF           TOTL           2
     O                                           51 'Customer Total ========>'
     O                       CTOT          1     71
     O          EF           TOTLR          1
     O                                           71 '========'
     O          EF           TOTLR          1
     O                                           51 'Report Total ========>'
     O                       FTOT          1     71
