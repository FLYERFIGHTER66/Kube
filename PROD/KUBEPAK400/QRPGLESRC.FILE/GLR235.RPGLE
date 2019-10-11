      *
      *
     FFGLDETAC  IF   E           K DISK
     FFGLBAL    IF   E           K DISK
WJB  FFMVEND    IF   E           K DISK
     FQPRINT    O    F  120        PRINTER OFLIND(*IN10)
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

WJB  D  VendName       S             18                                         |Vendor Name

WJB  D  FirstTime      S               N   Inz(*on)

WJB  D                 DS
     D   EndPer                1      4S 0
     D   EndMonth              3      4S 0

WJB  D  Months         DS
     D   GLT01
     D   GLT02
     D   GLT03
     D   GLT04
     D   GLT05
     D   GLT06
     D   GLT07
     D   GLT08
     D   GLT09
     D   GLT10
     D   GLT11
     D   GLT12
     D   GLT13
     D   GLT                         11S 2 Dim(13) Overlay(Months)
      ***********************
      ** START HERE        **
      ***********************
     C**
     C     DETKEY        KLIST
     C                   KFLD                    GTCOMP
     C                   KFLD                    GTACCT
     C***
     C     BALKEY        KLIST
     C                   KFLD                    GLCOMP
     C                   KFLD                    GLGLNO
     C**
     C**********************************************************************
     C**
     C     *ENTRY        PLIST
     C                   PARM                    ACCT#             8 0
     C                   PARM                    FRMDAT            4 0
     C                   PARM                    ENDDAT            4 0
     C**
     C                   EXCEPT    HDG
     C**
     C                   CLEAR                   STRPER
     C                   CLEAR                   ENDPER
     C**
     C                   MOVE      1             GTCOMP
     C                   MOVE      ACCT#         GTACCT
     C     DETKEY        SETLL     FGLDETAC
     C     PASS          TAG
     C     DETKEY        READE     FGLDETAC                               95
     C**
     C     *IN95         DOWEQ     *OFF
     C**

WJB  C                   If        GTVEND <> 0
WJB  C     GTVEND        Chain     FMVEND
WJB  C                   If        %Found(FMVEND)
WJB  C                   Eval      VendName = %SUBST(VMNAME:1:%LEN(VendName))
WJB  C                   EndIf
WJB  C                   EndIf

     C                   MOVEL     FRMDAT        STRPER            4 0
     C                   MOVEL     ENDDAT        ENDPER            4 0
     C**
     C     GTAPER        IFLT      STRPER
     C     GTAPER        ORGT      ENDPER
     C                   GOTO      PASS
     C                   END
     C**
     C                   ADD       GTDOL$        TOTDET           11 2
     C                   If        FirstTime
     C                   Eval      FirstTime = *off
     C                   MOVE      GTCOMP        GLCOMP
     C                   MOVE      GTACCT        GLGLNO
     C     BALKEY        CHAIN     FGLBAL                             96
     C     *IN96         IFEQ      *OFF
     C                   Z-ADD     0             WKBALT           11 2
     C                   MOVE      GLBALT        WKBALT
     C                   Z-add     GLBALT        ENDBAL
     C*                  ADD       GTDOL$        TOTDET           11 2
     C*    WKBALT        ADD       TOTDET        ENDBAL           11 2
     C     1             Do        EndMonth      X                 2 0
     C                   Add       GLT(X)        ENDBAL           11 2
     C                   EndDo
     C                   END
     C                   EndIf
     C**
     C     *IN10         IFEQ      *ON
     C                   EXCEPT    HDG
     C                   MOVE      *OFF          *IN10
     C                   END
     C**
     C                   EXCEPT    DET
     C**
     C     DETKEY        READE     FGLDETAC                               95
     C                   ENDDO
     C**
     C                   MOVE      *ON           *INLR
     C                   EXCEPT    TOT
     C**
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OQPRINT    E            HDG            2 03
     O                                            6 'GLR235'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           65 'Account Detail Report'
     O                       PAGE          Z     95
     O                                           91 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           86 'Time:'
     O                       TIMOD               95 '  :  :  '
     O***
     O          E            HDG         1  1
     O                                           10 'Acct#'
     O                                           18 'Date'
     O                                           24 'SRC'
     O                                           43 'Description'
     O                                           66 'Amount'
     O                                           92 'Description'
     O                                          113 'Vendor Name'
     O          E            DET         1  1
     O                       GTACCT              10 '    -    '
     O                       GTTDAT        Y     20
     O                       GTSRCE              24
     O                       GTSRDS              55
     O                       GTDOL$        J     68
     O                       GTJEDS             100
     O                       VendName           120
     O          E            TOT         2  2
     O                                           20 'Last Year Begin Bal:'
     O                       GLBALT        J     35
     O                                           51 'Total Amt:'
     O                       TOTDET        J     66
     O                                           79 'End Bal:'
     O                       ENDBAL        J     94
