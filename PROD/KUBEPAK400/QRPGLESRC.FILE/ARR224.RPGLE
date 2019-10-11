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
      *PROGRAM NAME-------- ARR224
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- COLLECTION INQUIRY BY FOLLOW UP DATE
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFARCMN    UF   E           K DISK
     F                                     RENAME(RARCMN:CMNFM)
     FFARCMNA3  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FARR224FM  CF   E             WORKSTN
     F                                     SFILE(DET10:RRN)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      *  PROGRAM NAME
     D  PROGID                 1     10
      *  RUN LIBRARY
     D  RLIBR                 81     90
      *  USER I.D.
     D  USERID               254    263
      *  SOURCE LIBRARY
     D  SLIBR                314    323
      *
     C     KKCMN         KLIST
     C                   KFLD                    CUST
     C                   KFLD                    CNTR
      *
     C                   TIME                    TIMOD             6 0
     C                   Z-ADD     UDATE         DTEN
     C                   CALL      '@DT@A1'                                     TEST DATE ENTD
     C                   PARM                    DTEN
     C                   PARM                    DTLS             07 0
     C                   PARM      'N'           RETC             01
      *
     C                   Z-ADD     DTEN          DTFM
     C                   Z-ADD     DTEN          DTTO
     C                   MOVEA     '000'         *IN(11)
      *
     C     TOP10         TAG
     C                   MOVE      '0'           *IN40
     C*                    WRITECLEAR
     C                   WRITE     HED010
     C                   READ      HED010                                 50
     C                   MOVEA     '000'         *IN(11)
     C                   MOVE      '1'           *IN40
      *
     C     *INKC         IFEQ      '1'
     C     *INKG         OREQ      '1'
     C                   GOTO      EOJ
     C                   END
      *
     C                   CALL      '@DT@A1'                                     TEST DATE
     C                   PARM                    DTFM
     C                   PARM                    DTFMXX           07 0
     C                   PARM      'N'           RETC
     C     RETC          IFEQ      'Y'
     C                   MOVE      '1'           *IN11
     C                   GOTO      TOP10
     C                   END
      *
     C                   CALL      '@DT@A1'                                     TEST DATE
     C                   PARM                    DTTO
     C                   PARM                    DTTOXX           07 0
     C                   PARM      'N'           RETC
     C     RETC          IFEQ      'Y'
     C                   MOVE      '1'           *IN12
     C                   GOTO      TOP10
     C                   END
      *
     C     DTFMXX        IFLT      DTTOXX
     C                   MOVE      '1'           *IN11
     C                   MOVE      '1'           *IN13
     C                   GOTO      TOP10
     C                   END
      *
     C     TOP20         TAG
     C                   EXSR      CLF
     C                   EXSR      SET
     C                   EXSR      LOD
     C                   MOVEA     '1100110'     *IN(90)
     C                   MOVE      '0'           *IN(97)
     C                   MOVEA     '000000'      *IN(10)
      *
     C     TOP30         TAG
MJT01C     PAGE#         IFLE      *ZEROS
MJT01C     PAGE#         ORGT      999
MJT01C                   Z-ADD     1             PAGE#
MJT01C                   END
     C                   WRITE     CTL10
     C                   READ      CTL10                                  50
     C                   MOVEA     '000000'      *IN(10)
      *
     C     *INKC         IFEQ      '1'
     C     *INKG         OREQ      '1'
     C                   GOTO      EOJ
     C                   END
      *
     C     *INKL         IFEQ      '1'
     C                   GOTO      TOP10
     C                   END
      *
     C                   MOVE      '1'           *IN(98)
     C                   Z-ADD     *ZEROS        CT               03 0
     C     TOP40         TAG
     C                   READC     DET10                                  50
MJT01C     *IN50         IFEQ      '0'
MJT01C     RRN           IFGT      08
MJT01C     RRN           DIV       08            RRNX             04 0
MJT01C     RRNX          MULT      08            PAGE#
MJT01C                   ADD       1             PAGE#
MJT01C                   END
MJT01C     RRN           IFLE      08
MJT01C                   Z-ADD     1             PAGE#
MJT01C                   END
MJT01C                   END
     C     *IN50         IFEQ      '1'
     C     *IN97         IFEQ      '1'
     C                   GOTO      TOP20
     C                   END
     C                   GOTO      TOP30
     C                   END
      *
     C                   ADD       1             CT
     C                   SETOFF                                       98
      *
     C     OPTN          IFNE      *BLANKS
     C     OPTN          ANDNE     'D'
     C                   SETON                                        97
     C                   SETOFF                                       98
     C  N13
     CANN14
     CANN15              SETON                                        13
     C                   END
      *
     C     OPTN          IFEQ      'D'
     C     KKCMN         CHAIN     FARCMN                             51
     C     *IN51         IFEQ      '0'
     C                   DELETE    CMNFM
     C                   SETON                                        97
     C                   SETOFF                                       98
     C                   END
     C                   END
      *
     C     OPTN          IFEQ      'V'
     C                   MOVE      CUST          CUSTA            06
     C                   CALL      'ARR223CA'
     C                   PARM                    CUSTA
     C                   MOVE      *BLANKS       OPTN
     C                   UPDATE    DET10
     C                   GOTO      TOP40
     C                   END
      *
     C     OPTN          IFEQ      'I'
     C                   MOVE      CUST          CUSTA            06
     C                   CALL      'ARR220CB'
     C                   PARM                    CUSTA
     C                   MOVE      *BLANKS       OPTN
     C                   UPDATE    DET10
     C                   GOTO      TOP40
     C                   END
      *
     C                   CALL      '@DT@A1'                                     TEST DATE ENTD
     C                   PARM                    DTEN
     C                   PARM                    DTENXX           07 0
     C                   PARM      'N'           RETC
     C     RETC          IFEQ      'Y'
     C                   SETON                                        1080
     C                   SETOFF                                       98
     C  N13
     CANN14
     CANN15              SETON                                        15
     C                   UPDATE    DET10
     C                   GOTO      TOP30
     C                   END
      *
     C     CMNT          IFEQ      *BLANKS                                      TEST COMMENTS
     C                   SETON                                        1180
     C                   SETOFF                                       98
     C  N13
     CANN14
     CANN15              SETON                                        14
     C                   UPDATE    DET10
     C                   GOTO      TOP30
     C                   END
      *
     C                   CALL      '@DT@A1'                                     TEST DATE FOLLOW UP
     C                   PARM                    DTFL
     C                   PARM                    DTFLXX           07 0
     C                   PARM      'N'           RETC
     C     RETC          IFEQ      'Y'
     C                   SETON                                        1280
     C                   SETOFF                                       98
     C  N13
     CANN14
     CANN15              SETON                                        15
     C                   UPDATE    DET10
     C                   GOTO      TOP30
     C                   END
      *
     C     KKCMN         CHAIN     FARCMN                             51
     C     *IN51         IFEQ      '0'
     C                   MOVE      *BLANKS       ACSTAT
     C                   MOVE      CMNT          ACCMNT
     C                   MOVE      CMNT2         ACCMNT2
     C                   MOVE      CMNT3         ACCMNT3
     C                   MOVE      TIMOD         ACTIME
     C                   MOVE      USERID        ACUSER
     C                   Z-ADD     DTLS          ACDTLS
     C                   Z-ADD     DTFLXX        ACDTFL
     C                   Z-ADD     DTENXX        ACDTEN
     C                   UPDATE    CMNFM
     C                   MOVEA     '000'         *IN(10)
     C                   UPDATE    DET10
     C                   END
      *
     C                   GOTO      TOP40
      *
      *
     C     EOJ           TAG
     C                   MOVE      '1'           *INLR
      **
      **
     CSR   CLF           BEGSR
     C                   MOVEA     '0001001'     *IN(90)
     C                   Z-ADD     001           RRN
     C                   WRITE     CTL10
     CSR                 ENDSR
      **
      **
     CSR   SET           BEGSR
     C                   MOVEA     '0011001'     *IN(90)
     C                   Z-ADD     001           RRN
     C                   WRITE     DET10
     CSR                 ENDSR
      **
      **
     CSR   LOD           BEGSR
     C     DTFMXX        SETLL     FARCMNA3
     C                   Z-ADD     *ZEROS        RRN              05 0
     C     *IN50         DOUEQ     '1'
     C                   READ      FARCMNA3                               50
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
     C     ACDTFL        IFLT      DTTOXX
     C                   LEAVE
     C                   END
      *
     C                   ADD       1             RRN
     C     RRN           CHAIN     DET10                              51
      *
     C                   Z-ADD     ACCUST        CUST
     C     CUST          CHAIN     FMCUST                             52
     C     *IN52         IFEQ      '0'
     C                   MOVEL     CMNAME        NAME
     C                   ELSE
     C                   MOVE      *BLANKS       NAME
     C                   MOVEL     'RNF'         NAME
     C                   END
      *
     C                   MOVE      *BLANKS       OPTN
     C                   CALL      '@DTCNV'
     C                   PARM                    ACDTEN
     C                   PARM                    DTEN
     C                   PARM                    RETC
     C                   MOVE      ACCMNT        CMNT
     C                   MOVE      ACCMNT2       CMNT2
     C                   MOVE      ACCMNT3       CMNT3
     C                   CALL      '@DTCNV'
     C                   PARM                    ACDTFL
     C                   PARM                    DTFL
     C                   PARM                    RETC
     C                   Z-ADD     ACCNTR        CNTR
     C                   MOVE      *BLANKS       OPTN
     C     *IN51         IFEQ      '1'
     C                   WRITE     DET10
     C                   ELSE
     C                   UPDATE    DET10
     C                   END
      *
     C                   ENDDO
      *
     C     RRN           IFEQ      *ZEROS
     C                   ADD       1             RRN
     C     RRN           CHAIN     DET10                              51
     C                   MOVE      *BLANKS       OPTN
     C                   MOVE      *BLANKS       DTEN
     C                   MOVE      *BLANKS       CMNT
     C                   MOVE      *BLANKS       CMNT2
     C                   MOVE      *BLANKS       CMNT3
     C                   MOVEL     'NO DATA'     CMNT
     C                   MOVE      *BLANKS       DTFL
     C     *IN51         IFEQ      '1'
     C                   WRITE     DET10
     C                   ELSE
     C                   UPDATE    DET10
     C                   END
     C                   END
      *
     CSR                 ENDSR
