      *%*******************************************************************
      *%                                                                 **
      *%  ?                     ?                                        **
      *%  ?                     ?                                        **
      *%                        ?                                        **
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- Dietz & Watson Jobber P/O Maintenance           **
      *%                                                  ?              **
      *%                                                                 **
      *%  ?                     ?                                        **
      *%  ?                     ?                                        **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- KP0018R                                                *
      *                                                                   *
      * Purpose?- Inventory P/O Close                                    *
      *                                                                   *
      *   Date   Programmer    ? Comment                             ? *
      *  9/17/2003 R. Piasecki      Program Created                       *
      *                                                                   *
      *********************************************************************
     FKPPOHD    UF   E           K DISK
     FKPPODT    UF   E           K DISK
     FFMINVT    UF   E           K DISK
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
      *****************************************************************
      * ?Define Program Constants                                   ? *
      *****************************************************************
      *
      ********************************************************************
      ********************************************************************
      ******************  Program Main Line?  ***************************
      ********************************************************************
      ********************************************************************
      *
      * ?Read thru detail records for this P/O
     C     HDKEY         SETLL     DGDTL
B001 C                   DO        999999
     C     HDKEY         READE     DGDTL                                  61
      *
      * ?If end of detail, leave loop
B002 C                   SELECT
     C     *IN61         WHENEQ    *ON
     C                   LEAVE
      *
      * ?If open detail record read, change status
     C     DDRSTS        WHENNE    'C'
     C                   MOVE      'C'           DDRSTS
     C                   UPDATE    DGDTL
      *
      * ?Subtract any un-received quantity from Item Master file -
      * ?quantity on order:
     C     DDPQTY        SUB       DDRCQT        WKQTY                           balance of order
      *
      * ?Update product/jobber record
      *
B003 C     WKQTY         IFGT      0
     C                   CLEAR                   *IN99
     C     ITKEY         CHAIN     RMINVT                             99
B004 C     *IN99         IFEQ      '0'
     C                   SUB       WKQTY         IMQTOO
B005 C     IMQTOO        IFLT      *ZERO
     C                   CLEAR                   IMQTOO
E005 C                   ENDIF
     C                   UPDATE    RMINVT
E004 C                   ENDIF
E003 C                   ENDIF
      *
E002 C                   ENDSL
      *
E001 C                   ENDDO
      *
      *? Change status of header record to "H"istory          ?                ?
     C                   CLEAR                   *IN99
     C     HDKEY         CHAIN     DGHDR                              99
B001 C     *IN99         IFEQ      *OFF
     C                   MOVE      'H'           DGOST
     C                   UPDATE    DGHDR
E001 C                   ENDIF
      *
      *? End the program                                  ?             ?
      *
     C                   MOVE      '1'           *INLR
      *
      ********************************************************************
      ********************************************************************
      ********************  End Main Line?  *****************************
      ********************************************************************
      ********************************************************************
      *
      ********************************************************************
      * ?       Program Initialization and Housekeeping                 ?*
      ********************************************************************
     CSR   *INZSR        BEGSR
      *
      * ?*ENTRY parameter list
      *
     C     *ENTRY        PLIST
     C                   PARM                    #EPOYR            2
     C                   PARM                    #EDGPO            6
      *
      * ?Move *ENTRY parms to numeric fields
      *
     C                   MOVE      #EPOYR        DGPOYR
     C                   MOVE      #EDGPO        DGDGPO
      *
      * Define *LIKE Fields ?
      *
     C     *LIKE         DEFINE    DDPQTY        WKQTY
      *
      * Define Key Lists ?
      *
      * ?KLIST for Jobber P/O Header File
      *
     C     HDKEY         KLIST
     C                   KFLD                    DGPOYR
     C                   KFLD                    DGDGPO
      *
      * ?KLIST for Inventory Item Master File
      *
     C     ITKEY         KLIST
     C                   KFLD                    DDITEM
     C                   KFLD                    DDSIZE
      *
     CSR                 ENDSR
