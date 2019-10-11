      *%*******************************************************************
      *%                                                                 **
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- Hard Goods Purchasing System                    **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- HG0016R                                                *
      *                                                                   *
      * Purpose?- Updates Quantity on Order                              *
      *                                                                   *
      *   Date  ?Programmer    ? Comment                             ? *
      *  04/30/04  R. Piasecki      Program Created                       *
      *********************************************************************
     FHGPODTL4  IP   E           K DISK
     FFMINVT    UF   E           K DISK
     D                 DS
     D  DDITEM                 1     12
     D  NSI                    1      3
     IDGDTL         01
     I                                          DDITEM        L1
     I                                          DDSIZE        L1
     C     NSI           IFNE      'NSI'
     C     DDRSTS        ANDEQ     'O'
      *? Clear ON ORDER Totals                      ?                   ?
     C     *INL1         IFEQ      *ON
     C     IMKEY         CHAIN(N)  RMINVT                             98
     C                   CLEAR                   ONORDR
     C                   ENDIF
     C     DDPQTY        SUB       DDRCQT        QTYREM            9 0
     C     QTYREM        MULT      IMLBS#        REMQTY           11 0
     C                   ADD       REMQTY        ONORDR           11 0
     C                   ENDIF
     CL1   IMKEY         CHAIN     RMINVT                             99
     CL1   *IN99         IFEQ      *OFF
     CL1                 Z-ADD     ONORDR        IMQTOO
     CL1                 UPDATE    RMINVT
     CL1                 ENDIF
0046 C*                                                                   UNIOND
      ********************************************************************
      * ?       Program Initialization and Housekeeping                 ?*
      ********************************************************************
     CSR   *INZSR        BEGSR
      *
      * Define Key Lists ?
      *
      * ?KLIST for file - FMINVT Library - *LIBL     ?
      * ? ITEM MASTER FILE                    ?
      *
     C     IMKEY         KLIST
     C                   KFLD                    DDITEM
     C                   KFLD                    DDSIZE
     CSR                 ENDSR
