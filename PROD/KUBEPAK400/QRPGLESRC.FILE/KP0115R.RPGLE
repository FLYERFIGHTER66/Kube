      *****************************************************************
      *                                                               *
      * Program?- KP0115R                                            *
      *                                                               *
      *                                                               *
      * Purpose?- Inventory RETURN PURCHASE ORDERS                   *
      *                                                               *
      *                      ?Modification Log     ?                  *
      *                                                               *
      *    Date   ?Programmer       ? Comment                      ? *
      *  2/16/2004 Richard E. Piasecki Program Created                *
      *                                                               *
      *****************************************************************
     FKPROHD    UF   E           K DISK
     FKPRODT    UF   E           K DISK
     FPOCNTL    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMINVT    UF   E           K DISK
     FKPITMWHS  UF   E           K DISK
     FKPHIST    O  A E           K DISK
     FKPWHOUSE  IF   E           K DISK
     FKP0115P   O    E             PRINTER OFLIND(*IN88)
     F*X0016P O   E             89     PRINTER                        UC
     F*           HEADER                            KRENAMEFAXHDR
     F*           DETAIL                            KRENAMEFAXDTL
     F*           TOTAL                             KRENAMEFAXTTL
      *****************************************************************
      * ?Arrays & tables                                            ? *
      *****************************************************************
     D WKAD            S             35    DIM(4)
     D CADR            S             35    DIM(4)
     D WADR            S             35    DIM(4)
     D JADR            S             35    DIM(4)
      *****************************************************************
      * ?Data structures                                            ? *
      *****************************************************************
     D                 DS                  INZ
     D  PRDATE                 1      6  0
     D  DGPOEM                 1      2  0
     D  DGPOED                 3      4  0
     D  DGPOEY                 5      6  0
      *
     D                 DS                  INZ
     D  PRDUDT                 1      6  0
     D  DGPODM                 1      2  0
     D  DGPODD                 3      4  0
     D  DGPODY                 5      6  0
      *
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
      *****************************************************************
      * ?Define Program Constants                                   ? *
      *****************************************************************
     D @CEXT1          C                   CONST('********************-
     D                                     **')
     D @CEXTA          C                   CONST('** RETURN ADDITION  -
     D                                     **')
     D @CEXTR          C                   CONST('**     REPRINT      -
     D                                     **')
     D @RETRN          C                   CONST('RETURN ORD')
      *****************************************************************
      * ?Mainline processing                                        ? *
      *****************************************************************
      * ?
      * ?Get P/O control file
      * ?
     C     999999        CHAIN     POCNTL                             99
      * ?
      * ?Get P/O header
      * ?
     C                   CLEAR                   *IN99
     C     POKEY         CHAIN     DGRHDR                             99
     C     DGOST         IFEQ      'H'
     C                   MOVE      *ON           *IN23
     C                   ELSE
     C                   MOVE      'H'           DGOST
     C                   ENDIF
     C                   UPDATE    DGRHDR
     C     PRDUDT        MULT      10000.01      YYMMDD            6 0
     C                   Z-ADD     YYMMDD        DHCYMD
     C                   MOVEL     DGPODC        DHCYMD
      * ?
      * ?Get jobber master record
      * ?
     C                   CLEAR                   *IN99
     C*                    Z-ADD001       CORP#
     C                   MOVEL     DGVNDR        PVEND#            6 0
     C     VMKEY         CHAIN     FMVEND                             99
      * ?
      * ?Get warehouse master record
      * ?
     C                   CLEAR                   *IN99
     C     DGWHSE        CHAIN     WHSE                               99
      * ?
      * ?If warehouse gets faxes, open fax file.
      * ?
     C*          WHFXYN    IFEQ 'Y'
     C*                    OPEN FX0016P
     C*                    ENDIF
      **************
      * ?Fill header fields
      **************
      * ?P/O year & number
     C                   Z-ADD     DGPOYR        PRPOYR
     C                   Z-ADD     DGDGPO        PRDGPO
      * ?Company name
     C                   MOVEL     POCONM        PRCNAM
      * ?
      * ?Company address
     C                   CLEAR                   X
     C     POCOA1        IFNE      *BLANKS
     C                   ADD       1             X                 1 0
     C                   MOVEL     POCOA1        CADR(X)
     C                   ENDIF
     C     POCOA2        IFNE      *BLANKS
     C                   ADD       1             X
     C                   MOVEL     POCOA2        CADR(X)
     C                   ENDIF
     C     POCOCY        CAT(P)    ',':0         WKCSZ            35
     C                   CAT       POCOST:1      WKCSZ
     C                   CAT       POCOZP:1      WKCSZ
     C                   ADD       1             X
     C                   MOVEL     WKCSZ         CADR(X)
      *
     C                   MOVEL     CADR(1)       PRCAD1
     C                   MOVEL     CADR(2)       PRCAD2
     C                   MOVEL     CADR(3)       PRCAD3
     C                   MOVEL     CADR(4)       PRCAD4
      * ?Warehouse name
     C                   MOVEL     WHWNAM        PRWNAM
      * ?
      * ?Warehouse address
     C                   CLEAR                   X
     C     WHWAD1        IFNE      *BLANKS
     C                   ADD       1             X
     C                   MOVEL     WHWAD1        WADR(X)
     C                   ENDIF
     C     WHWAD2        IFNE      *BLANKS
     C                   ADD       1             X
     C                   MOVEL     WHWAD2        WADR(X)
     C                   ENDIF
     C     WHWAD3        IFNE      *BLANKS
     C                   ADD       1             X
     C                   MOVEL     WHWAD3        WADR(X)
     C                   ENDIF
     C     WHWCTY        CAT(P)    ',':0         WKCSZ
     C                   CAT       WHWSTT:1      WKCSZ
     C                   CAT       WHWZIP:1      WKCSZ
     C                   ADD       1             X
     C                   MOVEL     WKCSZ         WADR(X)
      *
     C                   MOVEL     WADR(1)       PRWAD1
     C                   MOVEL     WADR(2)       PRWAD2
     C                   MOVEL     WADR(3)       PRWAD3
     C                   MOVEL     WADR(4)       PRWAD4
      * ?Vendor number
     C                   Z-ADD     DGVNDR        PRVNDR
      * ?Vendor name
     C                   MOVEL     VMNAME        PRJNAM
      * ?
      * ?Vendor address
     C                   CLEAR                   X
     C     VMADD2        IFNE      *BLANKS
     C                   ADD       1             X
     C                   MOVEL     VMADD2        JADR(X)
     C                   ENDIF
     C     VMADD3        IFNE      *BLANKS
     C                   ADD       1             X
     C                   MOVEL     VMADD3        JADR(X)
     C                   ENDIF
     C     VMCITY        CAT(P)    ',':0         WKCSZ
     C                   CAT       VMSTST:1      WKCSZ
     C                   MOVEL     VMZIPD        WKZIP5            5
     C                   MOVE      VMZIPD        WKZIP4            4
     C                   CAT       WKZIP5:1      WKCSZ
     C     WKZIP4        IFNE      *ZEROS
     C                   CAT       '-':0         WKCSZ
     C                   CAT       WKZIP4:0      WKCSZ
     C                   ENDIF
     C                   ADD       1             X
     C                   MOVEL     WKCSZ         JADR(X)
      *
     C                   MOVEL     JADR(1)       PRJAD1
     C                   MOVEL     JADR(2)       PRJAD2
     C                   MOVEL     JADR(3)       PRJAD3
      *
      * ?Extra description
     C                   SELECT
     C     #EPRTF        WHENEQ    'A'
     C                   MOVEL     @CEXT1        PREXT1
     C                   MOVEL     @CEXTA        PREXT2
     C                   MOVEL     @CEXT1        PREXT3
     C     #EPRTF        WHENEQ    'R'
     C                   MOVEL     @CEXT1        PREXT1
     C                   MOVEL     @CEXTR        PREXT2
     C                   MOVEL     @CEXT1        PREXT3
     C                   ENDSL
      **************
      * ?Print headings
      **************
     C                   CLEAR                   *IN31
     C                   WRITE     HEADER
      *
     C*          WHFXYN    IFEQ 'Y'
     C*                    MOVE '1'       *IN31
     C*                    WRITEFAXHDR
     C*                    ENDIF
      **************
      * ?Read thru detail records
      **************
     C     POKEY         SETLL     DGRDTL
     C     POKEY         READE     DGRDTL                                 61
     C     *IN61         DOWEQ     '0'
      **************
      * ?Fill detail fields
      **************
      *
      * ?Item number
     C                   MOVEL     DDITEM        PRITEM
      *
      * ?Quantity ordered
     C                   Z-ADD     DDPQTY        PRQTYO
      *
      * ?SIZE
     C                   MOVEL     DDSIZE        PRSIZE            3
     C                   MOVE      'C'           DDRSTS
     C                   UPDATE    DGRDTL
      *
      * ?Item description and Update Qty Received
     C     PRKEY         CHAIN     RMINVT                             99
     C                   MOVEL     DDIDS1        PRDESC
     C*          DDPQTY    MULT IMLBS#    RETQTY 110
      *
      * ?Unit cost
     C                   Z-ADD     DDOPRC        PROPRC
      *
      * ?Line total
     C     DDPQTY        MULT      DDOPRC        PRLTTL
      *
      * ?Do only if not a reprint
     C     *IN23         IFEQ      *OFF
     C     DDPQTY        MULT      -1            QTYRET            9 0
     C                   SUB       DDPQTY        IMMREC
     C                   SUB       DDPQTY        IMQTOH
     C                   UPDATE    RMINVT
      **************
      * ?Update Item History and Item Warehouse Files
      **************
     C     ITWKEY        CHAIN     KPITMWHS                           99
     C                   SUB       DDPQTY        IWQTOH
     C                   UPDATE    ITMWHSR
      **************
     C*                    MOVE 'IM'      DHRCID
     C                   MOVE      DDITEM        DHPITM
     C                   MOVE      'X'           DHTRAN
     C                   MOVE      @RETRN        DHTYPE
     C                   MOVE      DDWHSE        DHFWHS
     C                   MOVE      QTYRET        DHTQTY
     C                   MOVE      DDOPRC        DHPPRC
     C                   MOVE      DGPOYR        DHPOYR
     C                   MOVE      DGDGPO        DHDGPO
     C                   WRITE     DGHISTR
     C                   ENDIF
      * ?Check for overflow
      **************
     C     *IN88         IFEQ      *ON
     C                   CLEAR                   *IN31
     C                   WRITE     HEADER
     C                   CLEAR                   *IN88
     C                   ENDIF
      *
     C*          WHFXYN    IFEQ 'Y'
     C*          *IN89     ANDEQ*ON
     C*                    MOVE '1'       *IN31
     C*                    WRITEFAXHDR
     C*                    CLEAR*IN89
     C*                    ENDIF
      **************
      * ?Print detail line
      **************
     C                   CLEAR                   *IN31
     C                   WRITE     DETAIL
      *
     C*          WHFXYN    IFEQ 'Y'
     C*                    MOVE '1'       *IN31
     C*                    WRITEFAXDTL
     C*                    ENDIF
      **************
      * ?Accumulate order total
      **************
     C                   ADD       PRLTTL        PRPTTL
      **************
      * ?Read next detail records
      **************
     C     POKEY         READE     DGRDTL                                 61
     C                   ENDDO
      **************
      * ?Print P/O total
      **************
     C                   WRITE     TOTAL
      * ?
      **************
      * ?Fax P/O
      **************
     C*          WHFXYN    IFEQ 'Y'
      * ?
      * ?Close fax file.
      * ?
     C*                    CLOSEFX0016P
      *
      * ?Call CLP to Send Fax.
      * ?
     C*                    MOVEL'FX0016P' FXFILE 10
     C*                    MOVELJOB##     FXJOBN 10
     C*                    MOVELUSER##    FXUSER 10
     C*                    MOVE JOBN##    FXNUMB  6
      *
     C*                    MOVE DGPOYR    WKPOYR  2
     C*                    MOVE DGDGPO    WKDGPO  6
     C*          'P/O#'    CAT  WKPOYR:1  FXDESC 50 P
     C*                    CAT  '-':0     FXDESC
     C*                    CAT  WKDGPO:0  FXDESC
     C*                    CAT  'for':1   FXDESC
     C*                    CAT  PVENDN:1  FXDESC
      *
     C*                    MOVE WHFARP    WKFARP  1
     C*                    MOVE WHFARA    WKFARA  3
     C*                    MOVE WHFPRE    WKFPRE  3
     C*                    MOVE WHFNUM    WKFNUM  4
     C*          WKFARP    CAT  WKFARA:0  FXFAX# 50 P
     C*                    CAT  WKFPRE:0  FXFAX#
     C*                    CAT  WKFNUM:0  FXFAX#
      *
     C*                    CALL 'DGFAXC'
     C*                    PARM           FXFILE
     C*                    PARM           FXJOBN
     C*                    PARM           FXUSER
     C*                    PARM           FXNUMB
     C*                    PARM           FXDESC
     C*                    PARM           FXFAX#
     C*                    PARM 'Y'       FXDELT  1
     C*                    ENDIF
      **************
      * ?End the program
      **************
     C                   MOVE      '1'           *INLR
      *****************************************************************
      * ?*INZSR - Initialization                                   ? *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * ?*ENTRY parameter list
      *
     C     *ENTRY        PLIST
     C                   PARM                    #EPOYR            2
     C                   PARM                    #EJBPO            6
     C                   PARM                    #EPRTF            1
      *
      * ?Move *ENTRY parms to numeric fields
      *
     C                   MOVEL     #EPOYR        DGPOYR
     C                   MOVEL     #EJBPO        DGDGPO
      *
      * ?KLIST for P/O files - JBPOHD & POJBDT
      *
     C     POKEY         KLIST
     C                   KFLD                    DGPOYR
     C                   KFLD                    DGDGPO
      *
      * ?KLIST for Product master - DGITEM
      *
     C     PRKEY         KLIST
     C                   KFLD                    DDITEM
      *
      * ?KLIST for Item Warehouse File - DGITMWHS
      *
     C     ITWKEY        KLIST
     C                   KFLD                    DDITEM
     C                   KFLD                    DDSIZE
     C                   KFLD                    IWWHSE
     C                   MOVE      '01'          IWWHSE            2 0
      *
      * ?KLIST for file - APMSTP      Library - APAYFILE  ?
      *
     C     VMKEY         KLIST
     C                   KFLD                    PVEND#
      *
     C                   ENDSR
