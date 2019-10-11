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
      *PROGRAM NAME-------- LKCUST
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- CUSTOMER LOOKUP
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  8/13/99 EFD ADD ADDRESS LINE 2 TO SCREEN
      *

     FFMCUSTAL  IF   E           K DISK
     FLKCUSTFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      *
     D CustomersDS     DS                               Inz
     D  C1_CUST                            Like(CMCUST)
     D  C1_NAME                            Like(CMNAME)
     D  C1_ADD2                            Like(CMADD2)
     D  C1_CITY                            Like(CMCITY)
     D  C1_STST                            Like(CMSTST)
     D  C1_BABB                            Like(CMBABB)
     D  C1_PHON                            Like(CMPHON)
     D  C1_LOOK                            Like(CMLOOK)
     D  C1_CTYP                            Like(CMCTYP)
     D  C1_BLCU                            Like(CMBLCU)

     D  endOfFile      S               N
     D  selVLOOK       S             +2    Like(VLOOK)

      * ALPHA ARRAY
     D ALP             S              1    DIM(15)                              ALPHA SEARCH
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
     C                   MOVE      'N'           showDeltd
     C                   MOVE      *BLANKS       OLDDeltd          1
     C                   MOVE      'N'           searchName
     C                   MOVE      *BLANKS       OLDSearch         1
     C                   MOVE      *ZEROS        *IN
      *  CHECK FOR FINAL END PROGRAM
     C     CMLOOK        IFGE      '99999999'
     C                   GOTO      ENDLR
     C                   END
      *
     C     RSTRT         TAG
     C                   EXSR      BLDSFL
     C     NXTFMT        TAG
     C                   Z-ADD     0             LINE
     C                   EXFMT     RECCTL
     C   KF              DO
     C                   MOVEL     *BLANKS       CMBABB
     C                   MOVEL     *BLANKS       SHIP
     C                   MOVE      *BLANKS       CMNAME
     C                   MOVE      *BLANKS       CMCITY
     C                   MOVE      *BLANKS       CMSTST
     C                   Z-ADD     0             CMCUST
     C                   GOTO      END
     C                   ENDDO
      * SEE IF ON A SUBFILE LINE
     C     LINE          IFGT      0
     C     LINE          ANDLE     LSTREC
     C     LINE          CHAIN     RECSFL                             90
     C   90              GOTO      NXTFMT
     C                   MOVE      *BLANKS       CMNAME
     C                   MOVEL     NM1           CMNAME
     C                   GOTO      END
     C                   END
     C     LINE#         IFGT      LSTREC
     C                   SETON                                        90
     C                   GOTO      NXTFMT
     C                   END
     C     VLOOK         IFNE      OLDSRC
     C     showDeltd     OrNE      OLDDeltd
     C     searchName    OrNE      OLDSearch
     C                   MOVEL     VLOOK         OLDSRC
     C                   MOVEL     showDeltd     OLDDeltd
     C                   MOVEL     searchName    OLDSearch
     C                   GOTO      RSTRT
     C                   END
     C     LINE#         IFEQ      0
     C                   GOTO      NXTFMT
     C                   END
      *
      * GET THE SELECTED CUSTOMER
      *
     C                   Z-ADD     LINE#         RECNO
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTFMT
     C                   MOVE      *BLANKS       CMNAME
     C                   MOVEL     NM1           CMNAME
     C     END           TAG
     C                   MOVE      *ZEROS        *IN
     C                   SETON                                        LR
     C                   RETURN
     C     ENDLR         TAG
     C                   SETON                                        LR
      ***************
      * BUILD SFILE *
      ***************
     C     BLDSFL        BEGSR
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             LINE#
     C                   Z-ADD     0             VLINE
     C     NEWSRC        TAG
     C                   ExSr      OpenData
     C*    VLOOK         SETLL     FMCUSTAL
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      VLOOK         OLDSRC
     C                   MOVE      showDeltd     OLDDeltd
     C                   MOVE      searchName    OLDSearch
     C     NXTX          TAG
     C                   SETOFF                                       50
     C                   ExSr      ReadData
     C*                  READ      FMCUSTAL                               50
     C                   If        EndOfFile
     C                   Goto      DSPL
     C                   ENDIF
     C*  50              GOTO      DSPL
     C     CMSTAT        IFEQ      'D'
     C                   GOTO      NXTX
     C                   ENDIF
     C     ALOK          TAG
      *
     C     CMBLCU        IFNE      CMCUST
     C                   MOVEL     'Y'           SHIP
     C                   ELSE
     C                   MOVEL     *BLANKS       SHIP
     C                   ENDIF
      * MOVE INTO SHORTER FIELDS
     C                   MOVEL     CMNAME        NM1
     C                   MOVEL     CMADD2        AD2
     C                   MOVEL     CMCITY        CT1
     C                   ADD       1             RECNO
     C                   ADD       1             VLINE
     C                   WRITE     RECSFL
     C                   GOTO      NXTX
      *
     C     DSPL          TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       2             RECNO
     C                   Z-ADD     0             VLINE
     C                   MOVEL     *BLANKS       NM1
     C                   MOVEL     '* End of'    ENDFLD           16
     C                   MOVE      ' Data * '    ENDFLD
     C                   MOVEL     ENDFLD        NM1
     C                   Z-ADD     0             CMCUST
     C                   MOVEL     *BLANKS       CMBABB
     C                   MOVEL     *BLANKS       SHIP
     C                   MOVEL     *BLANKS       CT1
     C                   MOVEL     *BLANKS       AD2
     C                   MOVEL     *BLANKS       CMSTST
     C                   MOVEL     *BLANKS       CMLOOK
     C                   MOVEL     *BLANKS       CMNAME
     C                   Z-add     *Zero         CMPHON
     C                   WRITE     RECSFL
     C                   ExSr      CloseData
     C                   ENDSR

      *?  ...........................................................
      *?  :      OpenData - Open Data Source                        :
      *?  :.........................................................:
    ?C     OpenData      BegSr                                                  ?

     C                   Eval      selVLOOK = '%' + %trim(VLOOK) + '%'

    ?c/exec sql
    ?c+
    ?c+    DECLARE  C1 cursor for
    ?c+
    ?c+    select   CMCUST                     as customerNumber
    ?c+         ,   CMNAME                     as customerName
    ?c+         ,   CMADD2                     as address2
    ?c+         ,   CMCITY                     as city
    ?c+         ,   CMSTST                     as state
    ?c+         ,   CMBABB                     as brokerAbbreviation
    ?c+         ,   CMPHON                     as customerPhone
    ?c+         ,   CMLOOK                     as customerAlpha
    ?c+         ,   CMCTYP                     as customerType
    ?c+         ,   CMBLCU                     as billingCustomer
    ?c+    from     FMCUST
    ?c+    where (( CMNAME like trim(:selVLOOK) and :searchName = 'Y' )
    ?c+       or  ( CMLOOK like trim(:selVLOOK) and :searchName = 'Y' )
    ?c+       or  ( CMLOOK like trim(:VLOOK)||'%')
    ?c+       or    trim(char(CMPHON)) like trim(:selVLOOK)
    ?c+       or    trim(char(CMZIP )) like trim(:selVLOOK))
    ?c+      and  ( :showDeltd  = 'Y' or CMCTYP <> '30' )
    ?c+    Order By CMLOOK
    ?c+
    ?c+    For Read only
    ?c+
    ?c/end-exec

     ?*  Open the SQL recordset
    ?c/exec sql
    ?c+                  Open      C1
    ?c/end-exec

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ReadData - Read Data                               :
      *?  :.........................................................:

     C     ReadData      BegSr

     ?*  Read Sow Schedule Records
    ?c/exec sql
    ?c+ Fetch C1 into :CustomersDS
    ?c/end-exec

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   Eval      CMCUST      = C1_CUST
     C                   Eval      CMNAME      = C1_NAME
     C                   Eval      CMADD2      = C1_ADD2
     C                   Eval      CMCITY      = C1_CITY
     C                   Eval      CMSTST      = C1_STST
     C                   Eval      CMBABB      = C1_BABB
     C                   Eval      CMPHON      = C1_PHON
     C                   Eval      CMLOOK      = C1_LOOK
     C                   Eval      CMCTYP      = C1_CTYP
     C                   Eval      CMBLCU      = C1_BLCU
     C                   EndIf

     C                   EndSr

      *?  ...........................................................
      *?  :      CloseDate - Close the Data Set                     :
      *?  :.........................................................:

     C     CloseData     BegSr

     ?*  Close the SQL recordset
    ?c/exec sql
    ?c+ Close C1
    ?c/end-exec

     C                   EndSr
