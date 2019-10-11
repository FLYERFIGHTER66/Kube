     H
     FHG9003S   CF   E             WORKSTN
     F                                     INFDS(ROLKEY)
     F                                     SFILE(DETAIL:R)
     FFMINVTL4  IF   E           K DISK
     F                                     RENAME(RMINVT:PRODL1)
      *
     D DESC            S              1    DIM(15)                              DYN SEARCH-DESCPT
      * ----lower case--------------------------------------------
     D LC              C                   CONST('abcdefghijklmnopqrst-
     D                                     uvwxyz')
      * ----UPPER CASE--------------------------------------------
     D UC              C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ')
      * ----------------------------------------------------------
      *
     D ROLKEY          DS
     D  ROLLKY           *STATUS
     D  CSRLOC               370    371B 0
     D  LOWRR                378    379B 0
      *
     C     START         TAG
      *
      *
     C                   MOVE      *ON           *IN77
     C                   EXSR      $SETLL
     C                   MOVE      *ZEROS        CTR               3 0
     C                   Z-ADD     1             BEGIN
     C                   MOVE      *ZEROS        R                 4 0
     C                   MOVE      *ON           *IN50
     C                   WRITE     HEADER
     C                   MOVEA     '010'         *IN(50)
      *
     C     PAGEDN        TAG
      *
     C                   Z-ADD     *ZERO         COUNT             2 0
     C     *IN72         DOWEQ     *OFF                                         <=======\
     C     COUNT         ANDLT     9                                                    |
     C     *IN77         IFEQ      *ON                                          <====\| |
     C                   ADD       1             R                    52             || |
     C                   ADD       1             COUNT                               || |
     C                   WRITE     DETAIL                                            || |
     C                   ENDIF                                                  <====/| |
     C                   EXSR      $READ                                                |
     C                   ENDDO                                                  <=======/
      *
     C     BEGIN         IFGT      R
     C                   Z-ADD     R             BEGIN
     C                   ENDIF
      *
     C                   WRITE     TRAILER
     C                   EXFMT     HEADER
     C                   MOVEL     $DESC         CHKDYN            1
      *
     C     *INKE         IFEQ      *ON
     C                   MOVE      *BLANKS       $DESC
     C                   GOTO      START
     C                   END
      *
     C     *INKC         IFEQ      *ON                                          <=======\
     C     *INKL         OREQ      *ON                                                  |
     C                   MOVE      *BLANKS       #ELOOK                                 |
     C                   MOVE      *BLANKS       #EITEM                                 |
     C                   MOVE      *BLANKS       #ESIZE                                 |
     C                   MOVE      '1'           *INLR
     C                   ELSE                                                   <-------#
     C     *IN33         CABEQ     *ON           START                                  |
     C   35              ADD       9             BEGIN                                  |
     C     *IN35         CABEQ     *ON           PAGEDN                                 |
      *                                                            |
     C     R             IFNE      *ZERO                                        <======\|
     C     CPOS          CHAIN     DETAIL                             90               ||
     C     *IN90         IFEQ      *OFF                                         <=====\||
      *
     C                   MOVEL     IMLOOK        #ELOOK                               |||
     C                   MOVE      IMITEM        #EITEM                               |||
     C                   MOVE      IMSIZE        #ESIZE                               |||
     C                   MOVE      *ON           *INLR                                |||
     C                   ELSE
     C                   GOTO      START
     C                   ENDIF                                                  <=====/||
     C                   ENDIF                                                  <======/|
     C                   RETURN                                                       |||
     C                   ENDIF                                                  <=======/
      *
     C                   MOVE      *ON           *INLR
      ********************************************
      * Initialization Routine
      ********************************************
     CSR   *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    #ELOOK           15
     C                   PARM                    #EITEM           12
     C                   PARM                    #ESIZE            3
      *
     C     DSCKEY        KLIST
     C                   KFLD                    $DESC
      *
      *
      *
     C                   Z-ADD     9             STRLEN            3 0
     C                   Z-ADD     1             STRPOS            3 0
     C                   MOVE      *BLANK        PATTRN           15
     C                   Z-ADD     9             PATLEN            3 0
     C                   MOVE      '1'           TRNLAT            1
     C                   MOVE      '1'           TRIM              1
     C                   MOVE      *BLANK        WILD              1
     C                   Z-ADD     *ZEROS        RESULT            3 0
      *
     C                   MOVE      *BLANKS       $DESC
      *
     CSR                 ENDSR
      *
      *****************************************************
     C     $SETLL        BEGSR
      *****************************************************
      *
     C                   MOVEA     '0000000'     *IN(21)
      *
31403C     $DESC         IFNE      *BLANKS
31403C                   MOVE      01            NL                2 0
31403C     ' '           CHECKR    $DESC         NL
31403C                   ENDIF
      *
     C     $DESC         COMP      *BLANKS                                24
      * DYNAMIC ITEM DESCRIPTION SEARCH
     C     $DESC         IFNE      *BLANKS
31403C     CHKDYN        ANDNE     '?'
31403C     DSCKEY        SETLL     PRODL1
31403C                   EXSR      $READ
31403C                   GOTO      ENDSET
     C                   ENDIF
      * ITEM CODE SEARCH
     C                   MOVE      ' '           BLNK             15
     C     BLNK          SETLL     PRODL1
     C     $DESC         IFNE      *BLANKS                                      DYN NAME SEARCH
     C     CHKDYN        ANDEQ     '?'
     C                   EXSR      DYN
     C                   END
     C                   EXSR      $READ
     CSR   ENDSET        ENDSR
      *
      ******************************************************
     CSR   $READ         BEGSR
      * DYNAMIC NAME SEARCH
     C     $DESC         IFNE      *BLANKS
     C     CHKDYN        ANDNE     '?'
     C     TNAME         TAG
     C                   READ      PRODL1                                 72
     C   72              GOTO      ENREAD
     C                   END
     C*          $DESC     IFEQ *BLANKS
     C     TPROD         TAG
     C                   READ      PRODL1                                 72
     C   72              GOTO      ENREAD
     C*                    END
      *
     C  N24CHKDYN        IFNE      '?'
     C                   CLEAR                   HLDNAM
     C     LC:UC         XLATE     IMLOOK        TEMP             15    96
     C     NL            SUBST     TEMP:1        HLDNAM           15
     C     HLDNAM        CABNE     $DESC         TNAME
     C                   ENDIF
     C     *IN24         IFEQ      '0'                                          DYN NAME SEARCH
     C     *IN62         ANDEQ     '0'
     C     CHKDYN        ANDEQ     '?'
     C                   EXSR      SCNNAM
     C   30              GOTO      TPROD
     C                   END
     C*
     C     ENREAD        ENDSR
      *
      **************************************************
      * DYN - NAME SEARCH IS DYNAMIC ?                 *
      **************************************************
     CSR   DYN           BEGSR
      *
     C                   SETOFF                                       3162
     C                   MOVE      $DESC         TEMP14           14
     C                   MOVEL     $DESC         TEMP1             1
     C     TEMP1         IFEQ      '?'
     C     TEMP14        IFNE      *BLANKS
     C                   MOVE      *BLANKS       NAME             15
     C                   MOVEL     TEMP14        NAME
     C                   SETON                                        31
      * FIND THE NAME FIELD LENTH
     C                   MOVEA     TEMP14        DESC
     C                   Z-ADD     15            I                 2 0
     C     DESC(I)       DOWEQ     ' '
     C     I             ANDGE     1
     C                   SUB       1             I
     C                   ENDDO
     C                   ELSE
     C                   MOVE      *ON           *IN62
     C                   ENDIF
     C                   ELSE
     C     $DESC         CAT       '9':0         NAME9            15
     C                   MOVEL     $DESC         NAME
     C                   ENDIF
      *
     CSR   DYNE          ENDSR
      *
      **************************************************
      * SCNNAM - DYNAMIC NAME SCAN.                    *
      **************************************************
     CSR   SCNNAM        BEGSR
      *
     C                   SETOFF                                       30
     C     LC:UC         XLATE     IMLOOK        TEMP             15    96
     C     *IN31         IFEQ      '1'
     C     NAME:I        SCAN      TEMP          RESULT            3 0    96
     C     RESULT        IFLE      0
     C                   SETON                                        30
     C                   ENDIF
     C                   ELSE
     C     TEMP          IFLT      NAME
     C     TEMP          ORGT      NAME9
     C                   SETON                                        30
     C                   ENDIF
     C                   ENDIF
35780 *
     CSR   SCNNAE        ENDSR
