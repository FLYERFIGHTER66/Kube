     F*%******************************************************************
     F*%                                                                **
     F*% Programmer: Rich Piasecki                   8/11/03            **
     F*%******************************************************************
     F********************************************************************
     F* ?                                                               ?*
     F* ?   SDC361 - Selections for Item Cost Work File                 ?*
     F* ?                                                               ?*
     F* ?                                                               ?*
     F* ?   CALLING PROGRAM:  SDC360C                                   ?*
     F* ?                                                               ?*
     F* ?                                                               ?*
     F* ?   PROGRAMMER       - Richard E. Piasecki                      ?*
     F* ?   DATE WRITTEN     - 8/11/2003                                ?*
     F* ?                                                               ?*
     F********************************************************************
     FFSOHSTL1  IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FSDR360WK  UF A E           K DISK
     F*
      ********************************************************************
      * ?Program Status Data Structure                                  ?*
      ********************************************************************
     D                SDS
     D  ##PGM            *PROC
     D  ##PARM           *PARMS
     D  ##PERR                91    169
     D  ##JOB                244    253
     D  ##USER               254    263
     D  ##JOBN               264    269
     D  ##JBDT               276    281  0
     D  ##JBTM               282    287  0
      ****************
      *    LDA       *
      ****************
     D                UDS
     D  SIZE                  18     20
      ********************************************************************
      * ?Define From & To Dates                                         ?*
      ********************************************************************
     D                 DS
     D  FDATE                  1      8  0 INZ(0)
     D  FYY                    3      4  0 INZ(0)
     D  FMONTH                 5      6  0 INZ(0)
     D  FDAY                   7      8  0 INZ(0)
     D  TDATE                  9     16  0 INZ(0)
     D  TYY                   11     12  0 INZ(0)
     D  TMONTH                13     14  0 INZ(0)
     D  TDAY                  15     16  0 INZ(0)
     D                 DS
     D  $#MSID                 1      7
     D  $#MPFX                 1      3
     D  $#MSEQ                 4      7
     D                 DS
     D  SOSHDT                 1      7  0 INZ(0)
     D  SODTCC                 1      1  0
     D  SODTYY                 2      3  0
     D  SODTMM                 4      5  0
     D  SODTDD                 6      7  0
      *
      *                                                                 ?*
      ********************************************************************
      * ?Named Constants                                                ?*
      ********************************************************************
     D YES             C                   CONST('YES')
      ********************************************************************
      ********************************************************************
      ******************  Program Main Line?  ***************************
      ********************************************************************
      ********************************************************************
      *
|     *
     C                   MOVEL     '1'           FCYY              3 0
     C                   MOVE      FYY           FCYY
     C                   MOVEL     FCYY          FCYM              5 0
     C                   MOVE      FMONTH        FCYM
     C                   MOVEL     FCYM          FCYMD             7 0
     C                   MOVE      FDAY          FCYMD
     C                   MOVEL     '1'           TCYY              3 0
     C                   MOVE      TYY           TCYY
     C                   MOVEL     TCYY          TCYM              5 0
     C                   MOVE      TMONTH        TCYM
     C                   MOVEL     TCYM          TCYMD             7 0
     C                   MOVE      TDAY          TCYMD
     C                   EXSR      SELSIZ
     C                   ExSr      Incl_All
     C                   MOVE      *ON           *INLR
      *
      *****************************************************************
      * ?SELECT - Selects Data for the Dates Keyed                  ? *
      *****************************************************************
     CSR   SELSIZ        BEGSR
      ********************************************************************
     C     FCYMD         SETLL     FSOHSTL1
     C                   DO        99999999
     C                   READ      FSOHSTL1                               66
      *
     C     *IN66         IFEQ      *ON
     C     SOSHDT        ORGT      TCYMD
     C                   LEAVE
     C                   ENDIF
      *
      * ?SELECT - By Size if Entered                                ? *
     C     SIZE          IFGT      *BLANKS
     C     SOSIZE        IFEQ      SIZE
     C                   EXSR      OUTREC
      *
     C                   ENDIF
     C                   ENDIF
      *
      * ?SELECT - All sizes if Size is Blank                        ? *
     C     SIZE          IFEQ      *BLANKS
     C                   EXSR      OUTREC
     C                   ENDIF
      *
     C                   ENDDO
     CSR                 ENDSR
      ********************************************************************
      * ?Include All Items                                              ?*
      ********************************************************************
     C     Incl_All      BEGSR
      *
     C                   Eval      *In60 = *On
     C                   Eval      SOQSHP = *Zero
     C     *LoVal        SetLL     FMINVT
     C                   Read      FMINVT
     C                   DoW       not %eof(FMINVT)
     C     Size          IfEq      *Blanks
     C     Size          OrEq      IMSIZE
     C                   EXSR      OUTREC
     C                   EndIf
     C                   Read      FMINVT
     C                   EndDo
      *
     C                   ENDSR
      ********************************************************************
      * ?INIT - Program Initialization and Housekeeping                 ?*
      ********************************************************************
     CSR   *INZSR        BEGSR
      *
      *? *ENTRY Parms
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@FRDT            8
     C                   PARM                    @@TODT            8
     C                   MOVE      @@FRDT        FDATE
     C                   MOVE      @@TODT        TDATE
     C                   MOVE      ' '           WHOUSE            3
      *
     C     WRKKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
      *
     C     IMKEY         KLIST
     C                   KFLD                    SOITEM
     C                   KFLD                    SOSIZE
     C                   KFLD                    WHOUSE
     CSR                 ENDSR
      ********************************************************************
      * ?OUTREC - Output/Update Record in Work File                     ?*
      ********************************************************************
     CSR   OUTREC        BEGSR
WJB  C                   Eval      *In98 = *Off
     C  N60IMKEY         CHAIN     FMINVT                             98
WJB  C*    *IN98         IFEQ      *OFF
WJB  C                   If        not *In98 and
WJB  C*                            IMLOC <> 'K'
WJB  C*                            IMSOWC <> 'K'
WJB  C                             IMSOWC = ' '
     C     WRKKEY        CHAIN     SDR360WK                           99
     C     *IN99         IFEQ      *ON
     C                   MOVE      IMITEM        WKITEM
     C                   MOVEL     IMSIZE        WKSIZE
     C                   MOVEL     IMLOOK        WKLOOK
WJB  C*                  MOVEL     SODES1        WKDESC
WJB  C                   MOVEL     IMDES1        WKDESC
     C                   MOVEL     IMLIST        WKLIST
     C                   MOVEL     IMFRSZ        WKFRSZ
     C                   Z-ADD     SOQSHP        WKQSHP
     C                   WRITE     WKHSTR
     C                   ELSE
     C                   ADD       SOQSHP        WKQSHP
     C                   UPDATE    WKHSTR
     C                   ENDIF
     C                   ENDIF
      *
     CSR                 ENDSR
