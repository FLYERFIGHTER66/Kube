      *%*******************************************************************
      *%                                                                 **
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- Broker Sales Summary Update                     **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- SUMCLRT                                                *
      *                                                                   *
      * Purpose?- Clears Sales by Broker                                 *
      *                                                                   *
      *   Date  ?Programmer    ? Comment                             ? *
      *  05/27/03  R. Piasecki      Program Created                       *
      *                                                                   *
      *********************************************************************
0022 FXATABBR   IP   E           K DISK
0022 FFSHISTS   UF   E           K DISK
      **                                                               ***
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
      ********************************************************************
      ******************  Program Main Line?  ***************************
      ********************************************************************
     C     CUSTKY        CHAIN     FSHISTS                            97
     C     *IN97         IFEQ      *OFF
     C                   DELETE    RSHISTS
     C                   ENDIF
      ********************************************************************
      * ?       Program Initialization and Housekeeping                 ?*
      ********************************************************************
     CSR   *INZSR        BEGSR
     C     CUSTKY        KLIST
     C                   KFLD                    TBBROK
     C                   KFLD                    BIITEM
     C                   KFLD                    BISIZE
     C                   KFLD                    BISLSM
     C                   KFLD                    BICOMP
     C                   MOVE      *BLANKS       BIITEM           12
     C                   MOVE      *BLANKS       BISIZE            3
     C                   MOVE      *BLANKS       BISLSM            2
     C                   Z-ADD     1             BICOMP            2 0
     C                   ENDSR
