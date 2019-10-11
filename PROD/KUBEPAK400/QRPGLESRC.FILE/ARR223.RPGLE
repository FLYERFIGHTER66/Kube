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
      *PROGRAM NAME-------- ARR223
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- COLLECTION INQUIRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFARCMN    UF   E           K DISK
     F                                     RENAME(RARCMN:CMNFM)
     FFARCMNA1  IF   E           K DISK
     FARR223FM  CF   E             WORKSTN
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
     C     *ENTRY        PLIST
     C                   PARM                    CUST              6 0
     C                   PARM                    RETC              1
     C                   PARM                    LCOI              2
     C                   PARM                    VDATE             6 0
     C                   PARM                    VACUST            6 0
     C                   PARM                    CMNAME           30
     C                   PARM                    VSCUST            6 0
     C                   PARM                    CSNAME           30
     C                   PARM                    #WKP1             3 0
     C                   PARM                    #PF$1            11 2
     C                   PARM                    CMCNAM           30
     C                   PARM                    #WKP1A            3 0
     C                   PARM                    #WKP2             3 0
     C                   PARM                    #PF$2            11 2
     C                   PARM                    CMPHON           10 0
     C                   PARM                    #WKP2A            3 0
     C                   PARM                    #WKP3             3 0
     C                   PARM                    #PF$3            11 2
     C                   PARM                    CMVOPO            9 2
     C                   PARM                    #WKCR$           11 2
     C                   PARM                    #WKP3A            3 0
     C                   PARM                    #PF$4            11 2
     C                   PARM                    #WKAT$           11 2
     C                   PARM                    CMCRL$            9 2
     C                   MOVE      LCOI          LCO               2 0
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
     C                   PARM      'N'           RETC
     C                   MOVE      '0'           *IN(98)
      *
     C     TOP00         TAG
     C                   EXSR      CLF
     C                   EXSR      SET
     C                   EXSR      LOD
     C                   MOVEA     '1100110'     *IN(90)
     C                   MOVE      '0'           *IN(97)
      *
     C     TOP10         TAG
MJT01C     PAGE#         IFLE      *ZEROS
MJT01C     PAGE#         ORGT      999
MJT01C                   Z-ADD     1             PAGE#
MJT01C                   END
     C                   WRITE     CTL10
     C                   READ      CTL10                                  50
     C                   MOVEA     '000000'      *IN(10)
      *
      *
MJT01C     *INKF         IFEQ      '1'
MJT01C                   GOTO      EOJ
MJT01C                   END
      *
     C     *INKJ         IFEQ      '1'
     C                   CALL      'ARR222'
     C                   PARM                    VACUST
     C                   PARM      ' '           RETC             01
     C                   GOTO      TOP00
     C                   END
      *
     C                   MOVE      '1'           *IN(98)
     C                   Z-ADD     *ZEROS        CT               03 0
     C     TOP20         TAG
     C                   READC     DET10                                  50
MJT01C     *IN50         IFEQ      '0'
MJT01C     RRN           IFGT      10
MJT01C     RRN           DIV       10            RRNX             04 0
MJT01C     RRNX          MULT      10            PAGE#
MJT01C                   ADD       1             PAGE#
MJT01C                   END
MJT01C     RRN           IFLE      10
MJT01C                   Z-ADD     1             PAGE#
MJT01C                   END
MJT01C                   END
     C     *IN50         IFEQ      '1'
MJT01C*          *IN97     IFEQ '1'
MJT01C*                    GOTO TOP10
MJT01C*                    END
MJT01C*          *IN98     IFEQ '1'
MJT01C*                    GOTO EOJ
MJT01C*                    END
     C                   GOTO      TOP10
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
     C                   CALL      '@DT@A1'                                     TEST DATE ENTD
     C                   PARM                    DTEN
     C                   PARM                    DTENXX           07 0
     C                   PARM      'N'           RETC
     C     RETC          IFEQ      'Y'
     C                   SETON                                        1080
     C                   SETOFF                                       98
     C  N13
     CANN14
     CANN15              SETON                                        14
     C                   UPDATE    DET10
     C                   GOTO      TOP10
     C                   END
      *
     C     CMNT          IFEQ      *BLANKS                                      TEST COMMENTS
     C                   SETON                                        1180
     C                   SETOFF                                       98
     C  N13
     CANN14
     CANN15              SETON                                        15
     C                   UPDATE    DET10
     C                   GOTO      TOP10
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
     CANN15              SETON                                        14
     C                   UPDATE    DET10
     C                   GOTO      TOP10
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
     C                   GOTO      TOP20
      *
     C     EOJ           TAG
     C                   MOVE      '1'           *INLR
      *
      *
     CSR   CLF           BEGSR
     C                   MOVEA     '0001001'     *IN(90)
     C                   Z-ADD     001           RRN
     C                   WRITE     CTL10
     CSR                 ENDSR
      *
      *
     CSR   SET           BEGSR
     C                   MOVEA     '0011001'     *IN(90)
     C                   Z-ADD     001           RRN
     C                   WRITE     DET10
     CSR                 ENDSR
      *
      *
     CSR   LOD           BEGSR
     C     CUST          SETLL     FARCMNA1
     C                   Z-ADD     *ZEROS        RRN              03 0
     C     *IN50         DOUEQ     '1'
     C     CUST          READE     FARCMNA1                               50
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
     C                   ADD       1             RRN
     C     RRN           CHAIN     DET10                              51
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
