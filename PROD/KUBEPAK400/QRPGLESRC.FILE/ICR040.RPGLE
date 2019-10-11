      *----------------------------------------------------------      ----
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 2000
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDE      RED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXC      EPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *       EFD ENTERPRISES INC.  215-643-5352
      *
      *----------------------------------------------------------      ----
      *PROGRAM NAME-------- ICR040
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- ENTER/UPDATE SIZE CODES
      *
      *
      *    DATE----INIT-------DESCRIPTION
      *
      *
     FICR040FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMSIZE    UF A E           K DISK
     FFMSIZD    UF A E           K DISK
     FFMINVTSZ  IF   E           K DISK
     FFSYSCTL   IF   E           K DISK
     FXATABL    IF   E           K DISK
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(5) CTDATA PERRCD(1)
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
      *
     D                UDS
     D  LLIST                  1      1
     D  LCANCL               133    133
      *
     D                 DS
     D  SZCTRD
     D  UPC1                   1     15A
     D  UPC2                  16     30A
      *
     C                   READ      FSYSCTL                                90
     C     ZZTYPE        IFEQ      'G'
     C                   SETON                                        01
     C                   ELSE
     C                   SETON                                        02
     C                   ENDIF
      *
     C     RSTRT         TAG
     C                   SETOFF                                       192021
     C                   SETOFF                                       222324
     C                   SETOFF                                       252627
     C                   SETOFF                                       283334
     C                   SETOFF                                       354041
     C                   SETOFF                                       505556
     C                   SETOFF                                       577780
     C                   SETOFF                                       8899
      *
     C                   MOVE      *BLANKS       VACT
     C                   MOVE      *BLANKS       VSIZE
     C                   MOVE      *BLANKS       SZCODE
     C                   MOVE      *BLANKS       SZDESC
     C                   Z-ADD     0             CNTB
     C                   Z-ADD     0             SZCUBF
     C                   Z-ADD     0             SZPERC
     C                   Z-ADD     0             SZCELL
     C                   Z-ADD     0             SZTAGS
     C                   Z-ADD     0             SZSALE
     C                   SETOFF                                       50
     C                   SETON                                        98
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       192026
     C                   SETOFF                                       272899
     C                   SETOFF                                       4041
     C                   Z-ADD     0             COUNT             2 0
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
WJB  C   11              DO
WJB  C                   UNLOCK    FMSIZE
WJB  C                   CALL      'ICR045'
WJB  C                   SETOFF                                       11
WJB  C                   GOTO      RSTRT
WJB  C                   ENDDO
      *
     C                   ADD       1             FIRST
     C  N50              EXSR      SR100A
     C   99              GOTO      NXTA
     C   50FIRST         IFEQ      0
     C                   GOTO      NXTA
     C                   END
     C     FIRST         IFNE      0
     C                   EXSR      SR100B
     C   25              GOTO      RSTRT
     C                   END
      *ERROR
     C   99              GOTO      NXTA
      *KF ON SCREEN B
     C   87              GOTO      RSTRT
      *REDISPLAY SCREEN ON R D I
     C     CNTB          IFGT      1
     C                   SETOFF                                       88
     C                   END
      *
      * CHECK IF COUNT > 0 IF SO REDISPLAY ELSE UPDATE RECORDS
     C  N77COUNT         IFGT      0
     C                   GOTO      NXTA
     C                   ELSE
     C                   EXSR      OUTREC
     C                   GOTO      RSTRT
     C                   END                                                    COUNT>0
      *
     C   77              GOTO      RSTRT
      *
     C     END           TAG
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KM
     COR KG              SETON                                        LR
      *
      **************************
      * SR100A - TOP OF SCREEN
      **************************
     C     SR100A        BEGSR
      *
     C     1             SUBST     VSIZE:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       VSIZE
     C                   MOVEL     SZCODE        VSIZE
     C                   MOVEL     SZDESC        VDESC            10
     C                   SETON                                        99
     C                   GOTO      E100A
     C                   ENDIF
      *
     C                   SETOFF                                       212223
     C     VACT          COMP      'A'                                262621     ADD CODE
     C   26VACT          COMP      'C'                                262622     CHANGE/UPDATE
     C   26VACT          COMP      'D'                                262623     DELETE
     C   26VACT          COMP      'I'                                262624     INQUIRE
      *
     C   26              SETON                                        99
     C   26              GOTO      E100A
      *
      * MUST HAVE SIZE CODE
      *
     C                   MOVEL     VSIZE         SZCODE
      *
      *  VALIDATE SIZE CODE
      *
     C     CKEY3         KLIST
     C                   KFLD                    SZCODE
     C     CKEY3         CHAIN     FMSIZD                             96
     C     CKEY3         CHAIN     FMSIZE                             96
      *
     C  N96VACT          IFEQ      'A'
     C                   SETON                                        9927
     C   99              GOTO      E100A
     C                   ENDIF
      *
     C   96VACT          IFNE      'A'
     C                   SETON                                        9920
     C   99              GOTO      E100A
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C     SZCODE        CHAIN     FMINVTSZ                           90
     C  N90              SETON                                          9940
     C   99              GOTO      E100A
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C     SZCODE        IFEQ      'ROY'
     C     SZCODE        OREQ      'AST'
     C     SZCODE        OREQ      'CUT'
     C     SZCODE        OREQ      'SED'
     C     SZCODE        OREQ      'TAG'
     C                   SETON                                          9940    41
     C   99              GOTO      E100A
     C                   ENDIF
     C                   ENDIF
      *
     C     VACT          IFEQ      'I'
     C                   SETON                                          77
     C                   ENDIF
      *
     C   21              MOVEL     'A'           SZSTAT
      *
     C  N99              SETON                                        50
      *
     C                   Z-ADD     0             FIRST             2 0
     C     E100A         TAG
      *
     C                   ENDSR
      *
      **************************
      ******     SR100B - BOTTOM OF SCREEN
      **************************
      *
     C     SR100B        BEGSR
      *
     C                   SETON                                        50
     C     VACT          IFNE      'D'
     C                   GOTO      NODEL
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        3388
     C                   ADD       1             CNTB              2 0
     C*                    GOTO ENDB
     C                   END
      *
      *  KX = OKAY TO DEL
      *
     C   KX              DELETE    RMSIZE
     C   KX              DELETE    RMSIZD
     C                   GOTO      RSTRT
      *
     C     NODEL         TAG
     C   KF              SETON                                        87
     C   KF              GOTO      ENDB
      *
     C   KC
     COR KG              GOTO      END
      *  Check for Category Inq.
WJB  C   04              DO
     C                   Move      *Blanks       TableKey          8
     C                   CALL      'XATABLE'
     C                   PARM      'SZ'          TABLE             2
     C                   PARM      *Blanks       TableCd           2
     C                   PARM      *Blanks       TableElem         6
     C                   Eval      SZCATG = TableElem
WJB  C                   SETOFF                                       04
WJB  C                   Z-ADD     0             COUNT             2 0
WJB  C                   Eval      *In59 = *On
WJB  C                   ENDDO
      *
      * DESCRIPTION REQUIRED
      *
     C                   SETOFF                                       995758
     C     SZDESC        IFEQ      *BLANKS
     C                   SETON                                        9957
     C                   ENDIF
     C     SZDESC        IFNE      ODESC
     C                   ADD       1             COUNT             2 0
     C                   MOVEL     SZDESC        ODESC            20
     C                   ENDIF
      * VALIDATE SIZE CATEGORY
     C                   Eval      TableKey = 'SZ' + SZCATG
     C     TableKey      SetLL     XATABL
     C                   If        not %Equal(XATABL)
     C                   SETON                                        9958
     C                   EndIf
      *
     C   99
     CAN 58
     CAN 59
     CAN 57              GOTO      ENDB
      *
     C   99
     CAN 55              GOTO      ENDB
      *
     C     ENDB          TAG
      *
      * WHAT ACTION NEXT IF COUNT>0 SET OF 98 IF 99 SET ON 98
      *
     C     COUNT         IFGT      0
     C                   SETOFF                                       98
     C                   ELSE
     C                   SETON                                        98
     C                   ENDIF
     C   99              SETON                                        98
     C                   ENDSR
      *
      **********
      * OUTREC *
      **********
     C     OUTREC        BEGSR
     C   21              WRITE     RMSIZE
     C   21              WRITE     RMSIZD
     C   22              UPDATE    RMSIZE
     C   22              UPDATE    RMSIZD
     C   23              DELETE    RMSIZE
     C   23              DELETE    RMSIZD
     C                   ENDSR
      *
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVEL     'AST'         SZCODE
     C     SZCODE        CHAIN(N)  FMSIZE                             90
     C   90              DO
     C                   MOVEL     'AST'         SZCODE
     C                   MOVEL     'A'           SZSTAT
     C                   MOVEL     MSG(1)        SZDESC
     C                   Z-ADD     0             SZCUBF
     C                   Z-ADD     0             SZPERC
     C                   Z-ADD     0             SZCELL
     C                   Z-ADD     0             SZSALE
     C                   Z-ADD     0             SZTAGS
     C                   WRITE     RMSIZE
     C                   ENDDO
     C                   MOVEL     'CUT'         SZCODE
     C     SZCODE        CHAIN(N)  FMSIZE                             90
     C   90              DO
     C                   MOVEL     'CUT'         SZCODE
     C                   MOVEL     'A'           SZSTAT
     C                   MOVEL     MSG(2)        SZDESC
     C                   Z-ADD     0             SZCUBF
     C                   Z-ADD     0             SZPERC
     C                   Z-ADD     0             SZCELL
     C                   Z-ADD     0             SZSALE
     C                   Z-ADD     0             SZTAGS
     C                   WRITE     RMSIZE
     C                   ENDDO
     C                   MOVEL     'ROY'         SZCODE
     C     SZCODE        CHAIN(N)  FMSIZE                             90
     C   90              DO
     C                   MOVEL     'ROY'         SZCODE
     C                   MOVEL     'A'           SZSTAT
     C                   MOVEL     MSG(3)        SZDESC
     C                   Z-ADD     0             SZCUBF
     C                   Z-ADD     0             SZPERC
     C                   Z-ADD     0             SZCELL
     C                   Z-ADD     0             SZSALE
     C                   Z-ADD     0             SZTAGS
     C                   WRITE     RMSIZE
     C                   ENDDO
     C                   MOVEL     'SED'         SZCODE
     C     SZCODE        CHAIN(N)  FMSIZE                             90
     C   90              DO
     C                   MOVEL     'SED'         SZCODE
     C                   MOVEL     'A'           SZSTAT
     C                   MOVEL     MSG(4)        SZDESC
     C                   Z-ADD     0             SZCUBF
     C                   Z-ADD     0             SZPERC
     C                   Z-ADD     0             SZCELL
     C                   Z-ADD     0             SZSALE
     C                   Z-ADD     0             SZTAGS
     C                   WRITE     RMSIZE
     C                   ENDDO
     C                   MOVEL     'TAG'         SZCODE
     C     SZCODE        CHAIN(N)  FMSIZE                             90
     C   90              DO
     C                   MOVEL     'TAG'         SZCODE
     C                   MOVEL     'A'           SZSTAT
     C                   MOVEL     MSG(5)        SZDESC
     C                   Z-ADD     0             SZCUBF
     C                   Z-ADD     0             SZPERC
     C                   Z-ADD     0             SZCELL
     C                   Z-ADD     0             SZSALE
     C                   Z-ADD     0             SZTAGS
     C                   WRITE     RMSIZE
     C                   ENDDO
     C                   ENDSR
      *
** Message array
Assortment
Cuttings
Royalty
Seed
Tag
