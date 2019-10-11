    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

     ?*--------------------------------------------------------------
     ?*
     ?*  COPYRIGHT EFD ENTERPRISES, INC.    1997
     ?*
     ?*       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
     ?*       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
     ?*       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
     ?*       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
     ?*       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
     ?*       BY EXPRESS WRITTEN PERMISSION OF
     ?*            EFD ENTERPRISES, INC.     215-643-5352
     ?*
     ?*--------------------------------------------------------------
      **?PROGRAM NAME-------- ORDBLD
      **?COMPANY------------- EFD ENTERPRISES, INC.
      **?SYSTEM-------------- TGMS
      **?PROGRAMMER---------- EFD
      **?APPLICATION--------- BUILD ORDER LIST
     ?*
     ?* TO CHANGE SEQUENCE NUMBERING SEARCH ON #SEQ
     ?*
     ?*            CHANGE--DATE-------DESCRIPTION
     ?* 12/28/2011 - Add logic to retain note about items (S/W #251)
     ?* 12/28/2011 - *In58 = Show Color Pink on SFL record to denote item has a note.
      **********************************************************************
      *?               :---------------:
      *?               : Modifications :
      *?               :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   04/22/19   S.Uthaya     Added Hide Field in Subfile from
      *                                 FMORLSFLG1 file
     F**********************************************************************
     FORDBLDFM  CF   E             WORKSTN
     F                                     SFILE(LSTSFL:RECNO)
     F                                     SFILE(HLSTSFL:RECN1)
     FFMORLH    UF A E           K DISK
     FFMORLS    UF A E           K DISK
SUD01FFMORLSFLG1UF A E           K DISK
     FFMORLSQ   IF   E           K DISK
     F                                     RENAME(RMORLS:MORLS)
     FFMSIZE    IF   E           K DISK
     FFMINVT    UF   E           K DISK
     FFMINVTDESCUF A E           K DISK
     FFMPRCL    IF   E           K DISK
     FFLISTCD   IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFFPERC    IF   E           K DISK
     FFMORLSEASLUF A E           K DISK
     FFMORLSSNM IF   E           K DISK
     ?*
     D TSQ             S              4  0 DIM(1000)                            NEW SEQ #'S
     D SZE             S              3    DIM(6)                               SIZES
     D TYP             S             10    DIM(2) CTDATA PERRCD(1)              FRT TYPES
     ?*
     D Resequence      S               N   Inz(*Off)
     D UseDesc4        S               N   Inz(*Off)
     ?*
     ?************************
      **?PROG DATA STRUCTURE *
     ?************************
     D                SDS
      **?PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      **?RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      **?USER I.D.
     D  USERID               254    263                                         ARC380
      **?SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
     ?****************
      **? LDA        *
     ?****************
     D                UDS
     D  LDAPTO                 1      1  0                                      ARC380

     D FMORLHCFGDS   E DS                  ExtName(FMORLHCFG) Inz

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date6
    ?D/COPY QFunctDefn,$isIFSObj
      *
     ?***********************
      **?MAIN LINE CODE    **
     ?***********************
     C     *ENTRY        PLIST
     C                   PARM                    LISTID
     C                   IF        LISTID <> *Blanks
     C                   EVAL      ACTNCD = 'C'
     C                   EVAL      *In25 = *On
     C                   GOTO      LOADLIST
     C                   ENDIF
     C     RSTART        TAG
     C                   MOVE      *ZEROS        *IN
     C                   CLEAR                   SCRNAA
     C                   CLEAR                   SCRNA
     C                   CLEAR                   SCRNB
     C                   CLEAR                   SCRNC
     C                   MOVE      *BLANKS       LISTID
     C                   MOVE      *BLANKS       OLIST             6
     C                   MOVE      *BLANKS       HLDESC
     C     NXTAA         TAG
    ?C  N25              WRITE     SCRNAA
    ?C  N25              READ      SCRNAA                                 90
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C   KA              DO
     C                   EXSR      SHOW
     C                   GOTO      NXTAA
     C                   ENDDO
     C                   SETOFF                                       101112
     C                   SETOFF                                       99
      **?CHECK FOR ALPHA SEARCH
     C                   MOVEL     LISTID        SRC               1
     C     SRC           IFEQ      '?'
     C     SRC           OREQ      '/'
     C                   MOVE      *BLANKS       DPT               1
     C                   MOVE      LISTID        SLIST             5
     C                   MOVE      *BLANKS       LSTALP            6
     C                   MOVEL     SLIST         LSTALP
     C                   CALL      'LKORLS'
     C                   PARM                    LIST              6
     C                   PARM                    NDESC
     C     LIST          IFEQ      *BLANKS
     C                   MOVE      *BLANKS       NDESC
     C                   END
     C                   MOVEL     LIST          LISTID
     C                   GOTO      NXTAA
     C                   END
     C     LISTID        IFLE      *BLANKS
     C                   MOVE      *BLANKS       NDESC
     C                   SETON                                        1099
     C                   MOVE      *BLANKS       OLIST             6
     C                   GOTO      NXTAA
     C                   END
     C     LOADLIST      TAG
      **?CHAIN LIST FILE
    ?C     LISTID        CHAIN     FMORLH                             91
    ?C     LISTID        CHAIN     FMORLSEASL                         93
     C   93              Eval      SEAS = *Zeros
     C  N93              Eval      SEAS = HSSNCD
     C  N93HSSNCD        Chain     FMORLSSNM                          93
     C   93              Eval      SEASD = '*Invalid Season'
     C  N93              Eval      SEASD = HMSEAS
     C  N93              Move      SEASD         SaveSEASD        15
     C  N93              Move      SEAS          SaveSEAS          2 0
     C   91              MOVE      *BLANKS       NDESC
     C   91              CLEAR                   RMORLH
     C   91              MOVEL     LISTID        HLLIST

     C   91ACTNCD        IFEQ      'D'
     C     ACTNCD        OREQ      'C'
     C                   SETON                                        101112
     C                   SETON                                        131499
     C                   GOTO      NXTAA
     C                   END
     C  N91ACTNCD        IFEQ      'A'
     C                   SETON                                        101199
     C                   GOTO      NXTAA
     C                   END
     C   99              GOTO      NXTAA
      **?IF HERE DISPLAY REST OF SCREEN.
     C  N91              EXSR      LODSCR
      **?IF DELETE DISPLAY AND DELETE
     C     ACTNCD        IFEQ      'D'
     C                   EXSR      DELE
     C                   GOTO      RSTART
     C                   END
     C     NXTA          TAG
    ?C  N25              WRITE     SCRNA
    ?C  N25              READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C   KA              DO
     C                   EXSR      SHOW
     C                   GOTO      NXTA
     C                   ENDDO
     C   KB              DO
     C                   Z-ADD     1             FPCONO
     C                   CALL      'LKFRCD'
     C                   PARM                    FPCONO
     C                   PARM                    HLFRCD
     C                   ENDDO
     C                   SETOFF                                       101112
     C                   SETOFF                                       134150
     C                   SETOFF                                       203040
     C                   SETOFF                                       99
     C     HLASST        IFEQ      'Y'
    ?C     MINKEY        KLIST
    ?C                   KFLD                    IMITEM
    ?C                   KFLD                    IMSIZE
     C                   MOVEL     LISTID        IMITEM
     C                   MOVE      'AST'         IMSIZE
    ?C     MINKEY        CHAIN(N)  FMINVT                             41
     C   41              SETON                                        4099
     C                   END
      **?CHECK DESCRIPTION IF ASSORTMENT USE MINVT DESC
     C     NDESC         IFLE      *BLANKS
     C     HLASST        IFEQ      'Y'
     C                   MOVEL     IMDES1        NDESC
     C                   ELSE
     C                   SETON                                        1399
     C                   GOTO      NXTA
     C                   END
     C                   END
      **?CHECK LIST FORMAT
     C     HLFORM        IFNE      'V'
     C     HLFORM        ANDNE     'H'
     C                   SETON                                        2099
     C                   GOTO      NXTA
     C                   END
      **?CHECK ASSORTMENT (Y/N)
     C     HLASST        IFNE      'Y'
     C     HLASST        ANDNE     'N'
     C                   SETON                                        4099
     C                   GOTO      NXTA
     C                   END
      **?CHECK SEASON CODE
     C     SEAS          Ifgt      *Zero
     C     SEAS          Chain     FMORLSSNM
     C                   If        not %Found(FMORLSSNM)
     C                   SETON                                        7099
     C                   GOTO      NXTA
     C                   Else
     C                   Eval      SEASD = HMSEAS
     C                   If        SEAS <> SaveSEAS
     C                   Eval      SEAS = HMSNCD
     C                   Eval      SaveSEAS = HMSNCD
     C     LISTID        Chain     FMORLSEASL
     C                   Eval      HSSNCD = HMSNCD
     C                   Eval      HSSEAS = HMSEAS
     C                   Eval      HSDTLA = $Date6($Date(0))
     C                   Eval      HSTIME = $Now()
     C                   Eval      HSUSER = $User()
     C                   If        %Found(FMORLSEASL)
     C                   Update    RMORLSEAS
     C                   Else
     C                   Eval      HSSTAT = 'A'
     C                   Eval      HSLIST = LISTID
     C                   Write     RMORLSEAS
     C                   EndIf
     C                   SETON                                          99
     C                   EndIf
     C                   EndIf
     C                   EndIf
      **?CHECK FREIGHT TYPE
     C     HLFRCD        IFGT      *BLANKS
     C                   Z-ADD     01            CO
    ?C     FRTKEY        CHAIN     FFPERC                             50
     C   50              GOTO      NXTA
     C                   END
      **?CHECK LIST TYPE
     C     HLTYPE        IFNE      'P'
     C     HLTYPE        ANDNE     'S'
     C     HLTYPE        ANDNE     'L'
     C     HLTYPE        ANDNE     'A'
     C                   SETON                                        3099
     C                   GOTO      NXTA
     C                   END
     C   99              GOTO      NXTA
      **?MOVE SCREENA FIELDS INTO FILE FIELDS
     C                   MOVEL     NDESC         HLDESC
      **?SEE IF WE NEED SCREEN B
     C     HLTYPE        IFEQ      'S'
     C     HLFORM        ANDEQ     'V'
     C                   MOVE      *BLANKS       HLSNTS
     C                   MOVE      *BLANKS       HLSIZ1
     C                   MOVE      *BLANKS       HLSIZ2
     C                   MOVE      *BLANKS       HLSIZ3
     C                   MOVE      *BLANKS       HLSIZ4
     C                   MOVE      *BLANKS       HLSIZ5
     C                   MOVEL     *BLANKS       HLSIZ6
     C                   MOVE      *BLANKS       HLHDG1
     C                   MOVE      *BLANKS       HLHDG2
     C                   MOVE      *BLANKS       HLHDG3
     C                   MOVE      *BLANKS       HLHDG4
     C                   MOVE      *BLANKS       HLHDG5
     C                   MOVE      *BLANKS       HLHDG6
     C                   GOTO      ENDB
     C                   ENDIF
     C     HLFORM        IFNE      'H'
     C                   EXSR      SCRB
     C                   END
     C     HLFORM        IFEQ      'H'
      **?GET COLUMN HEADINGS
     C                   EXSR      SCRC
     C                   ELSE
     C                   MOVE      *BLANKS       HLHDG1
     C                   MOVE      *BLANKS       HLHDG2
     C                   MOVE      *BLANKS       HLHDG3
     C                   MOVE      *BLANKS       HLHDG4
     C                   MOVE      *BLANKS       HLHDG5
     C                   MOVE      *BLANKS       HLHDG6
     C                   END                                                    HLFORM=V
     C     ENDB          TAG
      **?NOW GET LIST TYPE SELECTIONS
     C     HLTYPE        IFNE      'S'
     C                   EXSR      SCRD
     C                   END
      **?IF HERE HEADER OK OUTPUT RECORD
     C                   MOVEL     'A'           HLSTAT
     C  N91              UPDATE    RMORLH
    ?C   91              WRITE     RMORLH
      **?GET SELECTIONS IF NEEDED
     C     HLTYPE        IFEQ      'S'
     C     HLFORM        IFEQ      'V'
     C                   EXSR      GETSEL
     C                   ELSE
     C                   GOTO      HORIZ
     C                   END
     C                   SETOFF                                       98
     C/Free
         Clear FMORLHCFGDS;
         Exec SQL
           Select * into :FMORLHCFGDS from FMORLHCFG WHERE HCLIST = :LISTID;
           If HCGRUP = ' ';
             HCGRUP = '*NEW';
           EndIf;
           If HCACTV = ' ';
             HCACTV = 'N';
           EndIf;
      /End-Free
     C     NXTFMT        TAG
     C   99              SETOFF                                       98
    ?C                   EXFMT     LSTCTL
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C/Free
         Exec SQL
           UPDATE FMORLH SET HLFIL2 = :HCFORM WHERE HLLIST = :LISTID;
         Exec SQL
           Insert Into FMORLHCFG values
               ( :LISTID
               , :HCACTV
               , :HCDTFM
               , :HCDTTO
               , :HCDTNH
               , :HCFORM
               , :HCGRUP
               , :HCCOPP
               , :HCSZPT
               , :HCSZSB
               , :HCSZNC
               , :HCPTPT
               , :HCPTSB
               , :HCPTNC
               , :HCITSB
               , current timestamp
               , user );
         Exec SQL
           UPDATE FMORLHCFG
             SET HCACTV = :HCACTV
               , HCDTFM = :HCDTFM
               , HCDTTO = :HCDTTO
               , HCDTNH = :HCDTNH
               , HCFORM = :HCFORM
               , HCGRUP = :HCGRUP
               , HCCOPP = :HCCOPP
               , HCSZPT = :HCSZPT
               , HCSZSB = :HCSZSB
               , HCSZNC = :HCSZNC
               , HCPTPT = :HCPTPT
               , HCPTSB = :HCPTSB
               , HCPTNC = :HCPTNC
               , HCITSB = :HCITSB
               , HCTMST = current timestamp
               , HCUSER = user
             WHERE HCLIST = :LISTID;
      /End-Free
     C                   EXSR      CHKSEL
     C   99              GOTO      NXTFMT
     C   KA              DO
     C                   EXSR      SHOW
     C                   GOTO      NXTFMT
     C                   ENDDO
     C   KE              DO
     C                   EXSR      GETSEL
     C                   GOTO      NXTFMT
     C                   ENDDO
     C   KH              DO
     C                   Eval      Resequence = *On
     C                   ExSr      GETSEL
     C                   ExSr      GETSEL
     C                   GOTO      NXTFMT
     C                   ENDDO
     C   KJ              DO
     C                   If        UseDesc4
     C                   Eval      UseDesc4 = *Off
     C                   Else
     C                   Eval      UseDesc4 = *On
     C                   EndIf
     C                   ExSr      GETSEL
     C                   ExSr      GETSEL
     C                   GOTO      NXTFMT
     C                   ENDDO
     C   KB              DO
     C                   ExSr      Master
     C                   ExSr      GETSEL
     C                   ExSr      GETSEL
     C                   GOTO      NXTFMT
     C                   ENDDO
     C   23              DO
     C                   ExSr      Mouse
     C                   ExSr      GETSEL
     C                   ExSr      GETSEL
     C                   GOTO      NXTFMT
     C                   ENDDO
     C   KD              DO
     C                   EXSR      PUTSEL
      **?IF ANY ERROR DISPLAY ERROR SCREEN
     C   40              DO
     C     NXTE          TAG
    ?C                   WRITE     SCRNE
    ?C                   READ      SCRNE                                  90
     C   KA              DO
     C     HLFORM        IFEQ      'V'
     C                   EXSR      GETSEL
     C***                  ELSE
     C***                  EXSR GETHSL
     C                   END
     C                   GOTO      NXTFMT
     C                   ENDDO                                                  KA DO
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   ENDDO                                                  40 DO
     C                   EXSR      GETSEL
     C                   GOTO      NXTFMT
     C                   ENDDO                                                  KD DO
     C                   GOTO      NXTFMT
     C                   END                                                    HLTYPE=S
      **?GOTO RSTART
     C                   GOTO      RSTART
      **?HORIZONAL LIST
     C     HORIZ         TAG
     C                   EXSR      GETHSL
     C                   SETOFF                                       98
     C     NXTFMH        TAG
     C   99              SETOFF                                       98
    ?C                   EXFMT     HLSTCTL
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   EXSR      CHKHSL
     C   99              GOTO      NXTFMH
     C   KA              DO
     C                   EXSR      SHOW
     C                   GOTO      NXTFMH
     C                   ENDDO
     C   KD              DO
     C                   EXSR      PUTHSL
      **?IF ANY ERROR DISPLAY ERROR SCREEN
     C   40              DO
     C     NXTEH         TAG
    ?C                   WRITE     SCRNE
    ?C                   READ      SCRNE                                  90
     C   KA              DO
     C                   EXSR      GETHSL
     C                   GOTO      NXTFMH
     C                   ENDDO                                                  KA DO
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   ENDDO                                                  40 DO
     C                   GOTO      RSTART
     C                   ENDDO                                                  KD DO
     C                   GOTO      NXTFMH
      **?GOTO RSTART
     C                   GOTO      RSTART

      **? END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
     C                   Call      'FIXORLFL'
     ?***********************
      **?DELETE LIST       **
     ?***********************
     C     DELE          BEGSR
     C     NXTDEL        TAG
     C                   SETON                                        98
    ?C                   WRITE     SCRNA
    ?C                   READ      SCRNA                                  90
     C   KF              GOTO      ENDDEL
     C  NKD              GOTO      NXTDEL
     C                   DELETE    RMORLH
    ?C     HLLIST        SETLL     FMORLS
     C     NXTDE         TAG
    ?C     HLLIST        READE     RMORLS                                 90
     C   90              GOTO      ENDDEL
     C                   DELETE    RMORLS
     C                   GOTO      NXTDE
     C     ENDDEL        ENDSR
     ?***********************
      **?LOAD SCREENS      **
     ?***********************
     C     LODSCR        BEGSR
     C                   MOVEL     HLDESC        NDESC
     C                   MOVEL     HLSNTS        IORO
     C                   MOVEL     HLSIZ1        SIZE1
     C                   MOVEL     HLSIZ2        SIZE2
     C                   MOVEL     HLSIZ3        SIZE3
     C                   MOVEL     HLSIZ4        SIZE4
     C                   MOVEL     HLSIZ5        SIZE5
     C                   MOVEL     HLSIZ6        SIZE6
     C                   MOVEL     HLSIZ6        SIZE6
     C                   MOVE      *BLANKS       SDEC1
     C                   MOVE      *BLANKS       SDEC2
     C                   MOVE      *BLANKS       SDEC3
     C                   MOVE      *BLANKS       SDEC4
     C                   MOVE      *BLANKS       SDEC5
     C                   MOVE      *BLANKS       SDEC6
      **?GET FREIGHT TYPE
     C     HLFRCD        IFGT      *BLANKS
    ?C     FRTKEY        KLIST
    ?C                   KFLD                    CO
    ?C                   KFLD                    HLFRCD
     C                   Z-ADD     01            CO                2 0
    ?C     FRTKEY        CHAIN     FFPERC                             91
     C     FPTYPE        IFEQ      'F'
     C                   MOVEL     TYP(1)        FTYP
     C                   Z-ADD     0             FPCHRG
     C                   ELSE
     C                   MOVEL     TYP(2)        FTYP
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       FTYP
     C                   Z-ADD     0             FPCHRG
     C                   END
     C     SIZE1         IFGT      *BLANKS
    ?C     SIZE1         CHAIN     FMSIZE                             90
     C  N90              MOVEL     SZDESC        SDEC1
     C                   END
     C     SIZE2         IFGT      *BLANKS
    ?C     SIZE2         CHAIN     FMSIZE                             90
     C  N90              MOVEL     SZDESC        SDEC2
     C                   END
     C     SIZE3         IFGT      *BLANKS
    ?C     SIZE3         CHAIN     FMSIZE                             90
     C  N90              MOVEL     SZDESC        SDEC3
     C                   END
     C     SIZE4         IFGT      *BLANKS
    ?C     SIZE4         CHAIN     FMSIZE                             90
     C  N90              MOVEL     SZDESC        SDEC4
     C                   END
     C     SIZE5         IFGT      *BLANKS
    ?C     SIZE5         CHAIN     FMSIZE                             90
     C  N90              MOVEL     SZDESC        SDEC5
     C                   END
     C     SIZE6         IFGT      *BLANKS
    ?C     SIZE6         CHAIN     FMSIZE                             90
     C  N90              MOVEL     SZDESC        SDEC6
     C                   END
     C     HLTYPE        IFNE      'S'
     C     HLFORM        OREQ      'H'
     C     SIZE1         IFGT      *BLANKS
    ?C     SIZE1         CHAIN     FMSIZE                             51
     C  N51              MOVEL     SZDESC        SDEC1
     C                   END
     C     SIZE2         IFGT      *BLANKS
    ?C     SIZE2         CHAIN     FMSIZE                             51
     C  N51              MOVEL     SZDESC        SDEC2
     C                   END
     C     SIZE3         IFGT      *BLANKS
    ?C     SIZE3         CHAIN     FMSIZE                             51
     C  N51              MOVEL     SZDESC        SDEC3
     C                   END
     C     SIZE4         IFGT      *BLANKS
    ?C     SIZE4         CHAIN     FMSIZE                             51
     C  N51              MOVEL     SZDESC        SDEC4
     C                   END
     C     SIZE5         IFGT      *BLANKS
    ?C     SIZE5         CHAIN     FMSIZE                             51
     C  N51              MOVEL     SZDESC        SDEC5
     C                   END
     C     SIZE6         IFGT      *BLANKS
    ?C     SIZE6         CHAIN     FMSIZE                             51
     C  N51              MOVEL     SZDESC        SDEC6
     C                   END
     C                   END                                                     NE"S"OR "H"
     C                   MOVEL     HLHDG1        HDG1
     C                   MOVEL     HLHDG2        HDG2
     C                   MOVEL     HLHDG3        HDG3
     C                   MOVEL     HLHDG4        HDG4
     C                   MOVEL     HLHDG5        HDG5
     C                   MOVEL     HLHDG6        HDG6
     C                   ENDSR
     ?************************
      **?GET SIZE CODES      *
     ?************************
     C     SCRB          BEGSR
     C                   SETOFF                                       990910
     C                   SETOFF                                       111213
     C                   SETOFF                                       141516
     C                   Z-ADD     0             B1                5 0
     C     NXTB          TAG
    ?C                   WRITE     SCRNB
    ?C                   READ      SCRNB                                  90
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C   KA              DO
     C                   EXSR      SHOW
     C                   GOTO      NXTB
     C                   ENDDO
      **?INC/OMIT IF BLANK NO SIZES
     C                   SETOFF                                       0910
     C                   SETOFF                                       111213
     C                   SETOFF                                       141516
     C     IORO          IFEQ      *BLANKS
     C     SIZE1         IFGT      *BLANKS
     C                   SETON                                        111099
     C                   END
     C     SIZE2         IFGT      *BLANKS
     C                   SETON                                        121099
     C                   END
     C     SIZE3         IFGT      *BLANKS
     C                   SETON                                        131099
     C                   END
     C     SIZE4         IFGT      *BLANKS
     C                   SETON                                        141099
     C                   END
     C     SIZE5         IFGT      *BLANKS
     C                   SETON                                        151099
     C                   END
     C     SIZE6         IFGT      *BLANKS
     C                   SETON                                        161099
     C                   END
     C                   END                                                    IORO=BLANK
     C   99              GOTO      NXTB
      **?IORO IF GT BLANKS AT LEAST ONE SIZE MUST BE SELECTED
     C     IORO          IFGT      *BLANKS
     C     SIZE1         ANDEQ     *BLANKS
     C     SIZE2         ANDEQ     *BLANKS
     C     SIZE3         ANDEQ     *BLANKS
     C     SIZE4         ANDEQ     *BLANKS
     C     SIZE5         ANDEQ     *BLANKS
     C     SIZE6         ANDEQ     *BLANKS
     C                   SETON                                        091099
     C                   SETON                                        111213
     C                   SETON                                        141516
     C                   END                                                    IORO>BLANK
     C   99              GOTO      NXTB
      **?NOW CHECK SIZES ENTERED
     C                   MOVE      *BLANKS       SDEC1
     C     SIZE1         IFGT      *BLANKS
     C                   MOVEL     SIZE1         TST               1
     C     TST           IFEQ      '?'
     C     TST           OREQ      '/'
     C                   EXSR      GTSIZE
     C                   MOVEL     NWSIZE        SIZE1
     C                   END
    ?C     SIZE1         CHAIN     FMSIZE                             90
     C   90              SETON                                        1199
     C  N90              MOVEL     SZDESC        SDEC1
     C                   END
     C                   MOVE      *BLANKS       SDEC2
     C     SIZE2         IFGT      *BLANKS
     C                   MOVEL     SIZE2         TST               1
     C     TST           IFEQ      '?'
     C     TST           OREQ      '/'
     C                   EXSR      GTSIZE
     C                   MOVEL     NWSIZE        SIZE2
     C                   END
    ?C     SIZE2         CHAIN     FMSIZE                             90
     C   90              SETON                                        1299
     C  N90              MOVEL     SZDESC        SDEC2
     C                   END
     C                   MOVE      *BLANKS       SDEC3
     C     SIZE3         IFGT      *BLANKS
     C                   MOVEL     SIZE3         TST               1
     C     TST           IFEQ      '?'
     C     TST           OREQ      '/'
     C                   EXSR      GTSIZE
     C                   MOVEL     NWSIZE        SIZE3
     C                   END
    ?C     SIZE3         CHAIN     FMSIZE                             90
     C   90              SETON                                        1399
     C  N90              MOVEL     SZDESC        SDEC3
     C                   END
     C                   MOVE      *BLANKS       SDEC4
     C     SIZE4         IFGT      *BLANKS
     C                   MOVEL     SIZE4         TST               1
     C     TST           IFEQ      '?'
     C     TST           OREQ      '/'
     C                   EXSR      GTSIZE
     C                   MOVEL     NWSIZE        SIZE4
     C                   END
    ?C     SIZE4         CHAIN     FMSIZE                             90
     C   90              SETON                                        1499
     C  N90              MOVEL     SZDESC        SDEC4
     C                   END
     C                   MOVE      *BLANKS       SDEC5
     C     SIZE5         IFGT      *BLANKS
     C                   MOVEL     SIZE5         TST               1
     C     TST           IFEQ      '?'
     C     TST           OREQ      '/'
     C                   EXSR      GTSIZE
     C                   MOVEL     NWSIZE        SIZE5
     C                   END
    ?C     SIZE5         CHAIN     FMSIZE                             90
     C   90              SETON                                        1599
     C  N90              MOVEL     SZDESC        SDEC5
     C                   END
     C                   MOVE      *BLANKS       SDEC6
     C     SIZE6         IFGT      *BLANKS
     C                   MOVEL     SIZE6         TST               1
     C     TST           IFEQ      '?'
     C     TST           OREQ      '/'
     C                   EXSR      GTSIZE
     C                   MOVEL     NWSIZE        SIZE6
     C                   END
    ?C     SIZE6         CHAIN     FMSIZE                             90
     C   90              SETON                                        1699
     C  N90              MOVEL     SZDESC        SDEC6
     C                   END
     C   99              GOTO      NXTB
      **?SEE IF FIRST TIME THRU
     C     B1            IFEQ      0
     C                   ADD       1             B1
     C                   GOTO      NXTB
     C                   END
      **?NOW LOAD THE FILE FIELDS
     C                   MOVEL     IORO          HLSNTS
     C                   MOVEL     SIZE1         HLSIZ1
     C                   MOVEL     SIZE2         HLSIZ2
     C                   MOVEL     SIZE3         HLSIZ3
     C                   MOVEL     SIZE4         HLSIZ4
     C                   MOVEL     SIZE5         HLSIZ5
     C                   MOVEL     SIZE6         HLSIZ6
     C                   MOVE      *BLANKS       HLHDG1
     C                   MOVE      *BLANKS       HLHDG2
     C                   MOVE      *BLANKS       HLHDG3
     C                   MOVE      *BLANKS       HLHDG4
     C                   MOVE      *BLANKS       HLHDG5
     C                   MOVE      *BLANKS       HLHDG6
     C                   ENDSR
     ?************************
      **?GET COLUMN HEADINGS *
     ?************************
     C     SCRC          BEGSR
     C                   SETOFF                                       990910
     C                   SETOFF                                       203040
     C                   SETOFF                                       5060
     C                   SETOFF                                       112131
     C                   SETOFF                                       415161
     C                   Z-ADD     0             C1                5 0
     C     NXTC          TAG
     C   99              Z-ADD     0             C1                5 0
    ?C                   WRITE     SCRNC
    ?C                   READ      SCRNC                                  90
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C   KA              DO
     C                   EXSR      SHOW
     C                   GOTO      NXTC
     C                   ENDDO
     C                   SETOFF                                       9912
     C     SIZE1         IFLE      *BLANKS
     C     SIZE2         ANDLE     *BLANKS
     C     SIZE3         ANDLE     *BLANKS
     C     SIZE4         ANDLE     *BLANKS
     C     SIZE5         ANDLE     *BLANKS
     C     SIZE6         ANDLE     *BLANKS
     C                   SETON                                        101299
     C                   ENDIF
     C   99              GOTO      NXTC
      **?NOW CHECK SIZES ENTERED
     C                   MOVE      *BLANKS       SDEC1
     C     SIZE1         IFGT      *BLANKS
     C                   MOVEL     SIZE1         TST               1
     C     TST           IFEQ      '?'
     C     TST           OREQ      '/'
     C                   EXSR      GTSIZE
     C                   MOVEL     NWSIZE        SIZE1
     C                   END
    ?C     SIZE1         CHAIN     FMSIZE                             90
     C   90              SETON                                        1099
     C  N90              MOVEL     SZDESC        SDEC1
     C  N90HDG1          IFLE      *BLANKS
     C                   MOVEL     SDEC1         HDG1
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       SDEC1
     C                   MOVE      *BLANKS       HDG1
     C                   END
     C                   MOVE      *BLANKS       SDEC2
     C     SIZE2         IFGT      *BLANKS
     C                   MOVEL     SIZE2         TST               1
     C     TST           IFEQ      '?'
     C     TST           OREQ      '/'
     C                   EXSR      GTSIZE
     C                   MOVEL     NWSIZE        SIZE2
     C                   END
    ?C     SIZE2         CHAIN     FMSIZE                             90
     C   90              SETON                                        2099
     C  N90              MOVEL     SZDESC        SDEC2
     C  N90HDG2          IFLE      *BLANKS
     C                   MOVEL     SDEC2         HDG2
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       SDEC2
     C                   MOVE      *BLANKS       HDG2
     C                   END
     C                   MOVE      *BLANKS       SDEC3
     C     SIZE3         IFGT      *BLANKS
     C                   MOVEL     SIZE3         TST               1
     C     TST           IFEQ      '?'
     C     TST           OREQ      '/'
     C                   EXSR      GTSIZE
     C                   MOVEL     NWSIZE        SIZE3
     C                   END
    ?C     SIZE3         CHAIN     FMSIZE                             90
     C   90              SETON                                        3099
     C  N90              MOVEL     SZDESC        SDEC3
     C  N90HDG3          IFLE      *BLANKS
     C                   MOVEL     SDEC3         HDG3
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       SDEC3
     C                   MOVE      *BLANKS       HDG3
     C                   END
     C                   MOVE      *BLANKS       SDEC4
     C     SIZE4         IFGT      *BLANKS
     C                   MOVEL     SIZE4         TST               1
     C     TST           IFEQ      '?'
     C     TST           OREQ      '/'
     C                   EXSR      GTSIZE
     C                   MOVEL     NWSIZE        SIZE4
     C                   END
    ?C     SIZE4         CHAIN     FMSIZE                             90
     C   90              SETON                                        4099
     C  N90              MOVEL     SZDESC        SDEC4
     C  N90HDG4          IFLE      *BLANKS
     C                   MOVEL     SDEC4         HDG4
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       SDEC4
     C                   MOVE      *BLANKS       HDG4
     C                   END
     C                   MOVE      *BLANKS       SDEC5
     C     SIZE5         IFGT      *BLANKS
     C                   MOVEL     SIZE5         TST               1
     C     TST           IFEQ      '?'
     C     TST           OREQ      '/'
     C                   EXSR      GTSIZE
     C                   MOVEL     NWSIZE        SIZE5
     C                   END
    ?C     SIZE5         CHAIN     FMSIZE                             90
     C   90              SETON                                        5099
     C  N90              MOVEL     SZDESC        SDEC5
     C  N90HDG5          IFLE      *BLANKS
     C                   MOVEL     SDEC5         HDG5
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       SDEC5
     C                   MOVE      *BLANKS       HDG5
     C                   END
     C                   MOVE      *BLANKS       SDEC6
     C     SIZE6         IFGT      *BLANKS
     C                   MOVEL     SIZE6         TST               1
     C     TST           IFEQ      '?'
     C     TST           OREQ      '/'
     C                   EXSR      GTSIZE
     C                   MOVEL     NWSIZE        SIZE6
     C                   END
    ?C     SIZE6         CHAIN     FMSIZE                             90
     C   90              SETON                                        6099
     C  N90              MOVEL     SZDESC        SDEC6
     C  N90HDG6          IFLE      *BLANKS
     C                   MOVEL     SDEC6         HDG6
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       SDEC6
     C                   MOVE      *BLANKS       HDG6
     C                   END
     C   99              GOTO      NXTC
      **?SEE IF FIRST TIME THRU
     C     C1            IFEQ      0
     C                   ADD       1             C1
     C                   GOTO      NXTC
     C                   END
      **?NOW LOAD THE FILE FIELDS
     C                   MOVEL     SIZE1         HLSIZ1
     C                   MOVEL     SIZE2         HLSIZ2
     C                   MOVEL     SIZE3         HLSIZ3
     C                   MOVEL     SIZE4         HLSIZ4
     C                   MOVEL     SIZE5         HLSIZ5
     C                   MOVEL     SIZE6         HLSIZ6
     C                   MOVEL     HDG1          HLHDG1
     C                   MOVEL     HDG2          HLHDG2
     C                   MOVEL     HDG3          HLHDG3
     C                   MOVEL     HDG4          HLHDG4
     C                   MOVEL     HDG5          HLHDG5
     C                   MOVEL     HDG6          HLHDG6
     C                   MOVEL     SIZE1         SZE(1)
     C                   MOVEL     SIZE2         SZE(2)
     C                   MOVEL     SIZE3         SZE(3)
     C                   MOVEL     SIZE4         SZE(4)
     C                   MOVEL     SIZE5         SZE(5)
     C                   MOVEL     SIZE6         SZE(6)
     C                   ENDSR
     ?************************
      **?GET LIST TYPE SEL   *
     ?************************
     C     SCRD          BEGSR
    ?C     HLLSTC        CHAIN     FLISTCD                            10
     C   10              MOVE      *BLANKS       LCDESC
    ?C     HLPRDC        CHAIN     FMPRCL                             10
     C   10              MOVE      *BLANKS       PCDESC
     C                   SETOFF                                       990910
     C                   SETOFF                                       203040
     C                   SETOFF                                       5060
     C                   SETOFF                                       112131
     C                   SETOFF                                       415161
      **?SEE WHICH CODE WE WANT
     C     HLTYPE        IFEQ      'P'
     C                   SETON                                        2030
     C                   END
     C     HLTYPE        IFEQ      'L'
     C                   SETON                                        1030
     C                   END
     C     HLTYPE        IFEQ      'A'
     C                   SETON                                        1020
     C                   END
      **?BLANK OUT UNUSED FIELD
     C   10              MOVE      *BLANKS       HLPRDC
     C   20              MOVE      *BLANKS       HLLSTC
     C   30              MOVE      *BLANKS       HLALPH
     C                   SETOFF                                       112131
     C                   Z-ADD     0             D1                5 0
     C     NXTD          TAG
     C   99              Z-ADD     0             D1                5 0
    ?C                   WRITE     SCRND
    ?C                   READ      SCRND                                  90
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C   KA              DO
     C                   EXSR      SHOW
     C                   GOTO      NXTD
     C                   ENDDO
     C                   SETOFF                                       99
     C                   SETOFF                                       112131
      **?CHECK PRODUCT CLASS
     C  N10              DO
     C                   MOVEL     HLPRDC        TST               1
     C     TST           IFEQ      '?'
     C     TST           OREQ      '/'
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL            2
     C                   PARM                    PCDESC
     C                   MOVEL     PCPRCL        HLPRDC
     C     HLPRDC        IFGT      *BLANKS
     C                   ADD       1             D1
     C                   END
     C                   GOTO      NXTD
     C                   END
    ?C     HLPRDC        CHAIN     FMPRCL                             11
     C   11              SETON                                        99
     C   11              MOVE      *BLANKS       PCDESC
     C   99              GOTO      NXTD
     C     D1            IFLE      1
     C                   ADD       1             D1
     C                   GOTO      NXTD
     C                   END
     C                   GOTO      ENDD
     C                   ENDDO
      **?CHECK LIST CODE
     C  N20              DO
     C                   MOVEL     HLLSTC        TST               1
     C     TST           IFEQ      '?'
     C     TST           OREQ      '/'
     C                   CALL      'LKLIST'
     C                   PARM                    LCCODE
     C                   PARM                    LCDESC
     C                   MOVEL     LCCODE        HLLSTC
     C     HLLSTC        IFGT      *BLANKS
     C                   ADD       1             D1
     C                   END
     C                   GOTO      NXTD
     C                   END
    ?C     HLLSTC        CHAIN     FLISTCD                            21
     C   21              SETON                                        99
     C   21              MOVE      *BLANKS       LCDESC
     C   99              GOTO      NXTD
     C     D1            IFLE      1
     C                   ADD       1             D1
     C                   GOTO      NXTD
     C                   END
     C                   GOTO      ENDD
     C                   ENDDO
      **?CHECK ALPHA
     C  N30              DO
     C     HLALPH        IFLE      *BLANKS
     C                   SETON                                        2199
     C                   END
     C   99              GOTO      NXTD
     C     D1            IFLE      1
     C                   ADD       1             D1
     C                   GOTO      NXTD
     C                   END
     C                   GOTO      ENDD
     C                   ENDDO
     C     ENDD          ENDSR
     ?***********************
      **?GET SELECTED ITEMS *
     ?***********************
     C     GETSEL        BEGSR
     C                   SETON                                        80
    ?C                   WRITE     LSTCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             LSTSEQ
     C                   Z-Add     *Zero         NewSeq#           4 0
     C                   MOVE      *Off          *In47                          Non-Display
    ?C     HLLIST        SETLL     FMORLSQ
     C     NXTGET        TAG
     C                   Add       3             NewSeq#
    ?C     HLLIST        READE     FMORLSQ                                90
     C   90              GOTO      ENDGET
     C                   If        Resequence
     C                   Z-ADD     NewSeq#       SEQ
     C                   Else
     C                   Z-ADD     OLSEQ#        SEQ
     C                   EndIf
     C                   MOVE      OLITEM        ITEMSV
     C                   MOVE      OLSIZE        SIZESV
     C                   MOVE      OLLOOK        LOOKSV
     C                   MOVEL     OLNOTE        NOTEsv
     C                   MOVEL     OLRDYC        RDYCsv
     C                   MOVEL     OLITEM        ITEM
     C                   MOVEL     OLSIZE        SIZE
     C                   MOVEL     OLLOOK        SLLOOK
     C                   MOVEL     OLNOTE        SLNOTE
     C                   MOVEL     OLRDYC        SLRDYC
      **?FIELD ORGSEQ, ITEMsv, SIZEsv and WHSE are HIDDEN IN SUBFILE RECORDS
     C                   Z-ADD     OLSEQ#        ORGSEQ
     C                   MOVEL     OLITEM        ITEMsv
     C                   MOVEL     OLSIZE        SIZEsv
     C                   MOVEL     OLLOOK        LOOKsv
     C                   MOVEL     OLNOTE        NOTEsv
     C                   MOVEL     OLWHSE        WHSE
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   Eval      Desc = 'Item Not Found'
     C     OLKEY         KList
     C                   KFld                    OLITEM
     C                   KFld                    OLSIZE
     C     OLKEY         Chain(N)  FMINVT
     C                   If        %Found(FMINVT)
     C                   If        UseDesc4
     C                   Eval      Desc = IMDES4
     C                   Else
     C                   CALL      'GETDESC'
     C                   PARM                    ITEM
     C                   PARM                    SIZE
     C                   PARM                    WHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC
     C                   EndIf
     C                   EndIf
     C                   ADD       1             RECNO
      **?PROTECT SEQ #
     C* wjb 5/4          SETON                                        71
     C                   If        OLNOTE <> *Blanks
     C                   Eval      *In58 = *On
     C                   Else
     C                   Eval      *In58 = *Off
     C                   EndIf
      /Free
         // ItemOnly Pic
         If $isIFSObj(
            '/www/zendphp7/htdocs/PICTURES/'
             + %trim(ITEM) + '.jpg');
           *In45 = *On;
           ItemOnlyEx = 'View';
           ItemOnlyAc = '-Del';
           else;
           *In45 = *Off;
           ItemOnlyEx = ' -- ';
           ItemOnlyAc = '+Add';
         ENDIF;

         // ItemSize Pic
         If $isIFSObj(
            '/www/zendphp7/htdocs/PICTURES/'
             + %trim(ITEM) + '-' + %Trim(SIZE) + '.jpg');
           *In46 = *On;
           ItemSizeEx = 'View';
           ItemSizeAc = '-Del';
           else;
           *In46 = *Off;
           ItemSizeEx = ' -- ';
           ItemSizeAc = '+Add';
         endif;

         IN45 = *In45;
         IN46 = *In46;

SUD01    Chain (LISTID:ITEMSV:SIZESV) FMORLSFLG1;
  |      If %Found;
  |         If FlHide = '1';
  |            Hide = 'Y';
  |         Else;
  |            Hide = 'N';
  |         Endif;
  |      Else;
  |         Hide = 'N';
SUD01    Endif;

      /End-Free
    ?C                   WRITE     LSTSFL
     C                   Z-ADD     OLSEQ#        LSTSEQ            3 0
     C                   GOTO      NXTGET
     C     ENDGET        TAG
     C                   Z-ADD     0             SEQ
     C                   Z-ADD     0             ORGSEQ
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       SLLOOK
     C                   MOVE      *BLANKS       SLNOTE
     C                   MOVE      *BLANKS       SLRDYC
     C                   MOVE      *BLANKS       WHSE
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       ITEMsv
     C                   MOVE      *BLANKS       SIZEsv
     C                   MOVE      *BLANKS       LOOKsv
     C                   MOVE      *BLANKS       NOTEsv
     C                   MOVE      *OFF          *In45
     C                   MOVE      *OFF          *In46
     C                   MOVE      *On           *In47
     C                   MOVE      *Blanks       ITEMONLYEX
     C                   MOVE      *Blanks       ITEMONLYAC
     C                   MOVE      *Blanks       ITEMSIZEEX
     C                   MOVE      *Blanks       ITEMSIZEAC
     C* wjb 5/4          SETOFF                                       71
     C     RECNO         ADD       50            TSTREC            5 0
     C     NXTADS        TAG
     C                   ADD       1             RECNO
     C                   If        OLNOTE <> *Blanks
     C                   Eval      *In58 = *On
     C                   Else
     C                   Eval      *In58 = *Off
     C                   EndIf
    ?C                   WRITE     LSTSFL
     C     RECNO         IFLT      TSTREC
     C                   GOTO      NXTADS
     C                   END
     C                   If        Resequence
     C                   ExSr      PUTSEL
     C                   Eval      Resequence = *Off
     C                   EndIf
     C                   ENDSR
     ?***********************
      **?CHECK SUB FILE     *
     ?***********************
     C     CHKSEL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       102099
     C                   SETOFF                                       111213
     C                   SETOFF                                       818283
     C                   Z-ADD     0             TSQ
     C                   Z-ADD     0             X                 4 0
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
    ?C     RECNO         CHAIN     LSTSFL                             90
     C   90              GOTO      ENDCHK
     C                   SETOFF                                       102030
     C                   MOVEL     ITEM          TST
     C     TST           IFEQ      '?'
     C     TST           OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     ITEM:2        IMLOOK
     C                   MOVEL     DESHFR        SHPFR
     C                   MOVEL     SIZE          IMSIZE
     C                   CALL      'LKITAL'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   MOVEL     IMWHSE        WHSE
     C                   If        SLLOOK = *Blanks
     C                   MOVEL     IMLOOK        SLLOOK
     C                   EndIf
     C                   END
     C     ITEM          IFGT      *BLANKS
    ?C     MINKY         KLIST
    ?C                   KFLD                    ITEM
    ?C                   KFLD                    SIZE
    ?C                   KFLD                    WHSE
    ?C     MINKY         CHAIN(N)  FMINVT                             41
     C   41              SETON                                        109981
    ?C     MORITM        KLIST
    ?C                   KFLD                    HLLIST
    ?C                   KFLD                    ITEM
    ?C                   KFLD                    SIZE
    ?C                   KFLD                    WHSE
      **?CHECK FOR SAME ITEM IN FILE
    ?C     MORITM        CHAIN     FMORLS                             42
      **?FIELD ORGSEQ IS HIDDEN IN SUBFILE RECORDS
     C  N42OLSEQ#        IFNE      ORGSEQ
     C                   SETON                                        829910
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       DESC
     C     ORGSEQ        IFGT      0
      **?PROTECT SEQ #
     C* wjb 5/4          SETON                                        71
     C                   ELSE
     C* wjb 5/4          SETOFF                                       71
     C                   END
     C                   If        OLNOTE <> *Blanks
     C                   Eval      *In58 = *On
     C                   Else
     C                   Eval      *In58 = *Off
     C                   EndIf
     C                   Eval      *In45 = IN45
     C                   Eval      *In46 = IN46
     C                   UPDATE    LSTSFL
     C                   GOTO      NXTCHK
     C                   END
     C*    ORGSEQ        IFEQ      0
     C*    SEQ           ANDGT     0
     C*                  Z-ADD     SEQ           NSEQ
     C*    MORSEQ        CHAIN     FMORLSQ                            92
     C* N92              DO
     C*                  SETON                                        839930
     C*                  ENDDO
     C*                  END
      **?CHECK IF SEQ EXISTS IN TSQ ARRAY
     C*    SEQ           IFGT      0
     C*    ORGSEQ        ANDLE     0
     C*                  Z-ADD     1             Y                 4 0
     C*    SEQ           LOOKUP    TSQ(Y)                                 57
     C*  57              SETON                                        309983
     C* N57              ADD       1             X
     C* N57              Z-ADD     SEQ           TSQ(X)
     C*                  END
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    ITEM
     C                   PARM                    SIZE
     C                   PARM                    WHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC
     C     ORGSEQ        IFGT      0
      **?PROTECT SEQ #
     C* wjb 5/4          SETON                                        71
     C                   ELSE
     C* wjb 5/4          SETOFF                                       71
     C                   END
     C                   If        OLNOTE <> *Blanks
     C                   Eval      *In58 = *On
     C                   Else
     C                   Eval      *In58 = *Off
     C                   EndIf
     C                   Eval      *In45 = IN45
     C                   Eval      *In46 = IN46
     C                   UPDATE    LSTSFL
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C                   Z-ADD     0             SEQ
     C                   Z-ADD     0             ORGSEQ
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       SLLOOK
     C                   MOVE      *BLANKS       SLNOTE
     C                   MOVE      *BLANKS       SLRDYC
     C* wjb 5/4          SETOFF                                       71
     C  N99              SETON                                        98
     C                   ENDSR
     ?***********************
      **?PUT SUB FILE       *
     ?***********************
     C     PUTSEL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       40  99
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
    ?C     RECNO         CHAIN     LSTSFL                             90
     C   90              GOTO      ENDPUT
     C                   SetOff                                       8182
    ?C                   Select
      *? Existing Item Deleted
    ?C                   When      Item = *Blanks and ItemSv <> *Blanks
    ?C     SavKey        Chain     FMORLS                             91
    ?C  N91              Delete    RMORLS

      *? Existing Item or Size Changed
    ?C                   When      Item <> ItemSv and ItemSv <> *Blanks or
    ?C                             Size <> SizeSv and SizeSv <> *Blanks or
    ?C                             Whse <> WhseSv
    ?C     SavKey        Chain     FMORLS                             91
    ?C  N91              Delete    RMORLS
    ?C     SflKey        Chain     FMORLS
     C                   If        not %Found(FMORLS)
     C                   Clear                   RMINVT
    ?C     SflItemKey    Chain(N)  FMINVT
     C                   If        %Found(FMINVT) and not %Found(FMORLS)
     C                   Eval      OLSTAT = 'A'
     C                   Eval      OLLIST = LISTID
     C                   Eval      OLITEM = ITEM
     C                   Eval      OLSIZE = SIZE
     C                   Eval      OLWHSE = WHSE
     C                   Eval      OLSEQ# = SEQ
     C                   Eval      OLLOOK = IMLOOK
     C                   Eval      SLLOOK = IMLOOK
     C                   Eval      OLPCL1 = IMPCL1
     C                   Eval      OLRDYC = SLRDYC
     C                   Eval      OLNOTE = SLNOTE
    ?C                   Write     RMORLS
     C                   Eval      *In10 = *Off                                 ?Reverse Image Fld
     C                   Eval      *In81 = *Off                                 ?Invalid Item/Size
     C                   Else
     C                   Eval      *In10 = *On                                  ?Reverse Image Fld
     C                   Eval      *In81 = *On                                  ?Invalid Item/Size
     C                   EndIf
     C                   Else
     C                   Eval      *In10 = *On                                  ?Reverse Image Fld
     C                   Eval      *In82 = *On                                  ?Item/Size Exists
     C                   EndIf

      *? Existing Sequence or Alpha Sort Changed
    ?C                   When        (   Seq <> ORGSEQ
    ?C                             or SLLOOK <> LOOKsv
    ?C                             or SLRDYC <> RDYCsv
    ?C                             or SLNOTE <> NOTEsv) and
    ?C                             Item = ItemSv and
    ?C                             Size = SizeSv and
    ?C                             Whse = WhseSv
    ?C     SflKey        Chain     FMORLS
     C                   If        %Found(FMORLS)
     C                   Eval      OLSEQ# = SEQ
     C                   Eval      OLLOOK = SLLOOK
     C                   Eval      OLNOTE = SLNOTE
     C                   Eval      OLRDYC = SLRDYC
    ?C                   Update    RMORLS
     C                   EndIf
      *? New Item Added
    ?C                   When      Item <> ItemSv and ItemSv = *Blanks
    ?C     SflKey        Chain     FMORLS
     C                   If        not %Found(FMORLS)
     C                   Clear                   RMINVT
    ?C     SflItemKey    Chain(N)  FMINVT
     C                   If        %Found(FMINVT)
     C                   Eval      OLSTAT = 'A'
     C                   Eval      OLLIST = LISTID
     C                   Eval      OLITEM = ITEM
     C                   Eval      OLSIZE = SIZE
     C                   Eval      OLWHSE = WHSE
     C                   If        SEQ <> 0
     C                   Eval      OLSEQ# = SEQ
     C                   Else
     C                   Eval      OLSEQ# = NSEQ + 1
     C                   EndIf
     C                   Eval      OLLOOK = IMLOOK
     C                   Eval      SLLOOK = IMLOOK
     C                   Eval      OLPCL1 = IMPCL1
     C                   Eval      OLNOTE = SLNOTE
     C                   Eval      OLRDYC = SLRDYC
    ?C                   Write     RMORLS
     C                   Else
     C                   Eval      *In10 = *On                                  ?Reverse Image Fld
     C                   Eval      *In81 = *On                                  ?Invalid Item/Size
     C                   EndIf
     C                   Else
     C                   Eval      *In10 = *On                                  ?Reverse Image Fld
     C                   Eval      *In82 = *On                                  ?Item/Size Exists
     C                   EndIf
    ?C                   EndSl
SUD01 /Free
  |   *?  Check Record Exists in Order_List_Detail_Line_Flag_File
  |       If Item <> *Blanks and Size <> *Blanks;
  |          Chain (ListId:Item:Size) FMORLSFLG1;
  |          If %Found;
  |             If Hide = 'Y';
  |                FlHide = '1';
  |             Else;
  |                FlHide = '0';
  |             Endif;
  |             UPDATED_TS = %Timestamp;
  |             UPDATED_BY = UserID;
  |             Update RMORLSFLAG  %Fields(FLHIDE:UPDATED_TS:
  |                                      UPDATED_BY);
  |          Else;
  |             If Hide = 'Y';
  |                FLLIST = LISTID;
  |                FLITEM = ITEM;
  |                FLSIZE = SIZE;
  |                FlHide = '1';
  |                CREATED_TS = %Timestamp;
  |                CREATED_BY = UserID;
  |                Write RMORLSFLAG;
  |             Endif;
  |          Endif;
  |       Endif;
SUD01 /End-free
     C                   Z-ADD     SEQ           NSEQ              4 0
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
    ?C     MORSEQ        KLIST
    ?C                   KFLD                    HLLIST
    ?C                   KFLD                    NSEQ
    ?C     SflKey        KList
    ?C                   KFld                    LISTID
    ?C                   KFld                    Item
    ?C                   KFld                    Size
    ?C                   KFld                    Whse
    ?C     SavKey        KList
    ?C                   KFld                    LISTID
    ?C                   KFld                    ItemSv
    ?C                   KFld                    SizeSv
    ?C                   KFld                    WhseSv
    ?C     SflItemKey    KList
    ?C                   KFld                    Item
    ?C                   KFld                    Size
     C                   ENDSR
     ?***********************
      **?GET SELECTED ITEMS *  HORIZONAL
     ?***********************
     C     GETHSL        BEGSR
     C                   SETON                                        80
    ?C                   WRITE     HLSTCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECN1             5 0
     C                   Z-ADD     0             LSTSEQ
     C                   SETOFF                                       818283
     C                   SETOFF                                       8499
    ?C     HLLIST        SETLL     FMORLSQ
     C     NXTGTH        TAG
    ?C     HLLIST        READE     RMORLS                                 90
     C   90              GOTO      ENDGTH
     C                   SETON                                        515253
     C                   SETON                                        545556
     C                   SETOFF                                       1030
     C                   Z-ADD     0             FIRMIN            5 0
     C                   Z-ADD     0             FIRSIZ            1 0
     C                   Z-ADD     OLSEQ#        SEQ
     C                   Z-ADD     OLSEQ#        ORGSEQ
      **?FIELD ORGSEQ IS HIDDEN IN SUBFILE RECORDS
     C                   MOVEL     OLITEM        ITEM
     C                   MOVEL     OLSIZE        SIZE
     C                   MOVEL     OLWHSE        WHSE
     C                   MOVEL     OLLOOK        SLLOOK
     C                   MOVEL     OLNOTE        SLNOTE
     C                   MOVEL     OLRDYC        SLRDYC
     C                   MOVE      *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
      **?GET SIZES
    ?C     ITEM          SETLL     FMINVT
     C     NXTSB         TAG
    ?C     ITEM          READE(N)  FMINVT                                 91
     C  N91              DO
     C                   Z-ADD     1             S                 2 0
     C     IMWHSE        IFEQ      WHSE
     C                   ADD       1             FIRMIN
     C     IMSIZE        LOOKUP    SZE(S)                                 92
     C   92              DO
     C                   ADD       50            S
     C                   MOVEL     '0'           *IN(S)
     C     FIRSIZ        IFEQ      0
     C                   CALL      'GETDESC'
     C                   PARM                    ITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC
     C                   Z-ADD     1             FIRSIZ
     C                   END                                                    FIRSIZ=0
     C                   ENDDO                                                  92 DO
     C                   END
     C                   GOTO      NXTSB
     C                   ENDDO                                                  N91 DO
      **?CHECK IF VALID PART NUMBER
     C     FIRMIN        IFLE      0
     C                   SETON                                        108199
     C                   END                                                    FIRMIN=0
     C                   ADD       1             RECN1
      **?CHECK IF VALID SIZE
     C     *IN(51)       IFEQ      '1'
     C     *IN(52)       ANDEQ     '1'
     C     *IN(53)       ANDEQ     '1'
     C     *IN(54)       ANDEQ     '1'
     C     *IN(55)       ANDEQ     '1'
     C     *IN(56)       ANDEQ     '1'
     C                   SETON                                        108499    0
     C                   ENDIF
      **?PROTECT SEQ #
     C* wjb 5/4          SETON                                        71
    ?C                   WRITE     HLSTSFL
     C                   Z-ADD     OLSEQ#        LSTSEQ            3 0
     C                   GOTO      NXTGTH
     C     ENDGTH        TAG
     C                   Z-ADD     0             SEQ
     C                   Z-ADD     0             ORGSEQ
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       WHSE
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       SLLOOK
     C                   MOVE      *BLANKS       SLNOTE
     C                   MOVE      *BLANKS       SLRDYC
     C* wjb 5/4          SETOFF                                       71
     C                   SETOFF                                       515253
     C                   SETOFF                                       545556
     C     RECN1         ADD       50            TSTREC            5 0
     C     NXTADH        TAG
     C                   ADD       1             RECN1
    ?C                   WRITE     HLSTSFL
     C     RECN1         IFLT      TSTREC
     C                   GOTO      NXTADH
     C                   END
     C                   ENDSR
     ?***********************
      **?CHECK SUB FILE     *  HORIZONAL
     ?***********************
     C     CHKHSL        BEGSR
     C                   Z-ADD     0             RECN1
     C                   SETOFF                                       102099
     C                   SETOFF                                       111213
     C                   SETOFF                                       818283
     C                   SETOFF                                       84
     C                   Z-ADD     0             TSQ
     C                   Z-ADD     0             X                 4 0
     C     NXHCHK        TAG
     C                   ADD       1             RECN1
    ?C     RECN1         CHAIN     HLSTSFL                            90
     C   90              GOTO      ENHCHK
     C                   SETOFF                                       102030
     C                   SETON                                        515253
     C                   SETON                                        545556
     C                   MOVEL     ITEM          TST
     C     TST           IFEQ      '?'
     C     TST           OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C                   MOVEL     *BLANKS       IMSIZE
     C     11            SUBST     ITEM:2        IMLOOK
     C                   MOVEL     '   '         SHPFR
     C                   CALL      'LKITAL'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   MOVEL     IMWHSE        WHSE
     C                   MOVEL     IMLOOK        SLLOOK
     C                   END
     C     ITEM          IFGT      *BLANKS
     C                   Z-ADD     0             FIRMIN            5 0
     C                   Z-ADD     0             FIRSIZ            1 0
      **?GET SIZES
    ?C     ITEM          SETLL     FMINVT
     C     NXTSBC        TAG
    ?C     ITEM          READE(N)  FMINVT                                 91
     C  N91              DO
     C                   Z-ADD     1             S                 2 0
     C     IMWHSE        IFEQ      WHSE
     C                   ADD       1             FIRMIN
     C     IMSIZE        LOOKUP    SZE(S)                                 92
     C   92              DO
     C                   ADD       50            S
     C                   MOVEL     '0'           *IN(S)
     C     FIRSIZ        IFEQ      0
     C                   CALL      'GETDESC'
     C                   PARM                    ITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC
     C                   Z-ADD     1             FIRSIZ
     C                   END                                                    FIRSIZ=0
     C                   ENDDO                                                  92 DO
     C                   END
     C                   GOTO      NXTSBC
     C                   ENDDO                                                  N91 DO
      **?CHECK IF VALID PART NUMBER
     C     FIRMIN        IFLE      0
     C                   SETON                                        108199
     C                   END                                                    FIRMIN=0
     C*******              ADD  1         RECN1
      **?CHECK IF VALID SIZE
     C     *IN(51)       IFEQ      '1'
     C     *IN(52)       ANDEQ     '1'
     C     *IN(53)       ANDEQ     '1'
     C     *IN(54)       ANDEQ     '1'
     C     *IN(55)       ANDEQ     '1'
     C     *IN(56)       ANDEQ     '1'
     C                   SETON                                        108499    0
     C                   ENDIF
      **?CHECK FOR SAME ITEM IN FILE
     C                   MOVE      *BLANKS       SIZE
    ?C     MORITM        CHAIN     FMORLS                             42
      **?FIELD ORGSEQ IS HIDDEN IN SUBFILE RECORDS
     C  N42OLSEQ#        IFNE      ORGSEQ
     C                   SETON                                        829910
     C                   END
     C                   ELSE
     C                   SETOFF                                       515253
     C                   SETOFF                                       545556
     C                   MOVE      *BLANKS       DESC
     C                   END
     C     ORGSEQ        IFGT      0
      **?PROTECT SEQ #
     C* wjb 5/4          SETON                                        71
     C                   ELSE
     C* wjb 5/4          SETOFF                                       71
     C                   END
     C***                  UPDATHLSTSFL
     C***                  GOTO NXHCHK
     C     ORGSEQ        IFEQ      0
     C     SEQ           ANDGT     0
     C                   Z-ADD     SEQ           NSEQ
    ?C     MORSEQ        CHAIN     FMORLSQ                            92
     C  N92              DO
     C                   SETON                                        839930
     C                   ENDDO
     C                   END
      **?CHECK IF SEQ EXISTS IN TSQ ARRAY
     C     SEQ           IFGT      0
     C     ORGSEQ        ANDLE     0
     C                   Z-ADD     1             Y                 4 0
     C     SEQ           LOOKUP    TSQ(Y)                                 57
     C   57              SETON                                        309983
     C  N57              ADD       1             X
     C  N57              Z-ADD     SEQ           TSQ(X)
     C                   END
     C     ORGSEQ        IFGT      0
      **?PROTECT SEQ #
     C* wjb 5/4          SETON                                        71
     C                   ELSE
     C* wjb 5/4          SETOFF                                       71
     C                   END
     C                   UPDATE    HLSTSFL
     C                   GOTO      NXHCHK
     C     ENHCHK        TAG
     C                   Z-ADD     0             SEQ
     C                   Z-ADD     0             ORGSEQ
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       SLLOOK
     C                   MOVE      *BLANKS       SLNOTE
     C                   MOVE      *BLANKS       SLRDYC
     C* wjb 5/4          SETOFF                                       71
     C  N99              SETON                                        98
     C                   ENDSR
     ?***********************
      **?PUT SUB FILE       *  HORIZONAL
     ?***********************
     C     PUTHSL        BEGSR
     C                   Z-ADD     0             RECN1
     C                   SETOFF                                       40  99
     C     NXHPUT        TAG
     C                   ADD       1             RECN1
    ?C     RECN1         CHAIN     HLSTSFL                            90
     C   90              GOTO      ENHPUT
     C                   MOVE      *BLANKS       SIZE
     C     ITEM          IFGT      *BLANKS
      **?CHECK FOR SAME ITEM IN FILE
    ?C     MORITM        CHAIN     FMORLS                             42
      **?FIELD ORGSEQ IS HIDDEN IN SUBFILE RECORDS
     C  N42OLSEQ#        IFNE      ORGSEQ
     C                   GOTO      NXHPUT
     C                   END
     C***                  ELSE
     C***                  GOTO NXHPUT
     C                   END
     C     SEQ           IFGT      0
     C                   Z-ADD     SEQ           NSEQ              4 0
     C                   ELSE
      **?MAKE SURE SEQ LE 9998
     C     NSEQ          IFGT      9995
     C                   SETON                                        4099
     C                   GOTO      ENHPUT
     C                   END
      **?CHANGE SEQ NUMBERING HERE #SEQ
     C                   ADD       3             LSTSEQ
     C                   Z-ADD     LSTSEQ        NSEQ
     C                   END
    ?C     MORSEQ        CHAIN     FMORLSQ                            91
     C     ITEM          IFLE      *BLANKS
     C  N91              DELETE    RMORLS
     C                   GOTO      NXHPUT
     C                   END
     C   91              DO
     C                   CLEAR                   RMORLS
     C                   MOVEL     HLLIST        OLLIST
     C                   Z-ADD     NSEQ          OLSEQ#
     C                   END
     C                   MOVEL     IMLOOK        OLLOOK
     C                   MOVEL     IMPCL1        OLPCL1
     C                   MOVEL     ITEM          OLITEM
     C                   MOVEL     SIZE          OLSIZE
     C                   MOVEL     WHSE          OLWHSE
     C                   MOVEL     SLLOOK        OLLOOK
     C                   MOVEL     SLNOTE        OLNOTE
     C                   MOVEL     SLRDYC        OLRDYC
     C                   MOVEL     'A'           OLSTAT
     C  N91              UPDATE    RMORLS
    ?C   91              WRITE     RMORLS
SUD01 /Free
  |   *?  Check Record Exists in Order_List_Detail_Line_Flag_File
  |       If Item <> *Blanks and Size <> *Blanks;
  |          Chain (OLLIST:Item:Size) FMORLSFLG1;
  |          If %Found;
  |             If Hide = 'Y';
  |                FlHide = '1';
  |             Else;
  |                FlHide = '0';
  |             Endif;
  |             UPDATED_TS = %Timestamp;
  |             UPDATED_BY = UserID;
  |             Update RMORLSFLAG  %Fields(FLHIDE:UPDATED_TS:
  |                                      UPDATED_BY);
  |          Else;
  |             If Hide = 'Y';
  |                FLLIST = LISTID;
  |                FLITEM = ITEM;
  |                FLSIZE = SIZE;
  |                FlHide = '1';
  |                CREATED_TS = %Timestamp;
  |                CREATED_BY = UserID;
  |                Write RMORLSFLAG;
  |             Endif;
  |          Endif;
  |       Endif;
SUD01 /End-free
     C                   GOTO      NXHPUT
     C     ENHPUT        TAG
     C                   ENDSR
     ?***********************
      **?GET SIZE CODES    **
     ?***********************
     C     GTSIZE        BEGSR
     C                   MOVE      *BLANKS       NWSIZE
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       NWSIZE            3
     C                   MOVEL     SZCODE        NWSIZE
     C                   ENDSR
     ?***********************
      **?SHOW SCREEN       **
     ?***********************
     C     SHOW          BEGSR
     C                   MOVEL     DESHFR        OHSHFR
     C                   Z-ADD     0             OHORD#
     C                   Z-ADD     0             PRISEQ
     C                   Z-ADD     0             LSTSEQ
     C                   Z-ADD     TDATE         OHDTRQ
     C                   CALL      'ORDLST'
     C                   PARM                    LISTID            6
     C                   PARM                    OHORD#            6 0
     C                   PARM                    OHDTRQ            6 0
     C                   PARM                    OHSHFR            3
     C                   PARM                    PRISEQ            3 0
     C                   PARM                    LSTSEQ            3 0
     C                   PARM                    TOTAST           11 0
     C                   ENDSR
     ?************************
      **?UPDATE ITEM MASTER **
     ?************************
     C     MASTER        BEGSR
     C     SFLCSRRRN     Chain     LSTSFL
     C     ITEMSIZE      KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C     ITEMSIZE      CHAIN     FMINVT
     C                   If        %Found(FMINVT)
     C     ITEMSIZE      CHAIN     FMINVTDESC
     C                   If        not %Found(FMINVTDESC)
     C                   Clear                   RMINVTDESC
     C                   Eval      IDITEM = ITEM
     C                   Eval      IDSIZE = SIZE
     C                   Write     RMINVTDESC
     C     ITEMSIZE      CHAIN     FMINVTDESC
     C                   EndIf
     C                   ExFmt     SCRNF
     C                   If        not *InKL
     C                   Update    RMINVT
     C                   Update    RMINVTDESC
     C                   If        OLNOTE <> *Blanks
     C                   Eval      *In58 = *On
     C                   Else
     C                   Eval      *In58 = *Off
     C                   EndIf
     C                   Eval      *In45 = IN45
     C                   Eval      *In46 = IN46
     C                   Update    LSTSFL
     C                   Else
     C                   Unlock    FMINVT
     C                   EndIf
     C                   EndIf
     C                   ENDSR
      //***********************
      //*?  Process the mouse click
      //***********************
      /FREE
       BEGSR MOUSE;
         Chain SFLCSRRRN LSTSFL;
         Select;
           When CSRFLD = 'ITEMONLYEX' and ITEMONLYEX = 'View';
             qSys2Cmd('DSPITMPIC ' + %trim(ITEM));
           When CSRFLD = 'ITEMSIZEEX' and ITEMSIZEEX = 'View';
             qSys2Cmd('DSPITMPIC ITEMSIZE('''
                          + %trim(ITEM)+ '-' + %trim(SIZE) + ''')');
           When CSRFLD = 'ITEMONLYAC' and ITEMONLYAC = '+Add';
             qSys2Cmd('UPLITMPIC ITEMSIZE(''' + %trim(ITEM)+ ''')');
           When CSRFLD = 'ITEMSIZEAC' and ITEMSIZEAC = '+Add';
             qSys2Cmd('UPLITMPIC ITEMSIZE('''
                          + %trim(ITEM)+ '-' + %trim(SIZE) + ''')');
         ENDSL;
       ENDSR;
       //**********************
      /END-FREE
      **?START UP ROUTINE  **
     ?***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
    ?C     USERID        CHAIN     FMUSER                             90
     C   90              MOVE      '999'         USDEPT            3
    ?C     USDEPT        CHAIN     FMDEPT                             90
     C                   ENDSR
      /Free
       dcl-proc qSys2Cmd;
         DCL-PI *n;
           Command Char(1000) value;
         END-PI;
         exec sql CALL QSYS2.QCMDEXC(:Command);
       END-PROC;
       dcl-proc wait;
         exec sql CALL QSYS2.QCMDEXC('DLYJOB DLY(2)');
       END-PROC;
      /End-Free
** FRT TYPES
Flat Rate
Percentage
