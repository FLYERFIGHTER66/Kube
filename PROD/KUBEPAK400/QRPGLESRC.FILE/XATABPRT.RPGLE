     F*********************************************************************
     F*                                                                   *
     F* Program?- XATABPRT                                               *
     F*                                                                   *
     F*                                                                   *
     F* Purpose?- PRINT TABLE MASTER FILE BY SELECTED CATAGORIES         *
     F*                                                                   *
     F*   Date  ?Programmer   ?  Comment                             ? *
     F*  05/16/03  R. PIASECKI      Program Created                       *
     F*                                                                   *
     F*********************************************************************
     FXATABL    IF   E           K DISK
     FXATABE1   IF   E           K DISK
     F                                     RENAME(TBMASTR:MASTKY)
     FXATABLP   O    E             PRINTER OFLIND(*IN11)
     D                SDS
     D  ##PGM            *PROC
     D  PARM##           *PARMS
     D  PERR##                91    169
     D  JOB##                244    253
     D  USER##               254    263
     D  JOBN##               264    269
     D  JBDT##               276    281  0
     D  TIME@@               282    287  0
      *****************************************************************
      * ?Define Program Constants                                   ? *
      *****************************************************************
     D YES             C                   CONST('YES')
0046 C*                                                                   UNIOND
     C     TBKEY         SETLL     MASTKY
     C     *ON           DOWEQ     *ON
     C     TBKEY         READE     MASTKY                                 66
     C     *IN66         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
     C                   WRITE     DETAIL
     C     *IN11         IFEQ      *ON
     C                   WRITE     HEADER
     C                   MOVE      *OFF          *IN11
     C                   ENDIF
     C                   ENDDO
      *
      *? End the program                                  ?             ?
      *
     C                   MOVE      *ON           *INLR
      *
      * INZSR: INITIAL SUBROUTINE
      ******
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    TBCODE            7
     C     TBCODE        IFEQ      'BR     '
     C                   MOVE      *ON           *IN75
     C                   ENDIF
      *
     C     'TB'          CAT(P)    TBCODE:0      TBID              8
     C     TBID          CHAIN     XATABL                             65
     C                   MOVEL(P)  TBCODE        TBKEY
     C                   MOVEL     TBLONG        TBNAME
     C                   WRITE     HEADER
      *
     CSR                 ENDSR
