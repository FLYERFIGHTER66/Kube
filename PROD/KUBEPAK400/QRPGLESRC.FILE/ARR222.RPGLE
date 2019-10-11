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
      *PROGRAM NAME-------- ARR222
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- COLLECTION WINDOW
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFARCMN    UF A E           K DISK
     FARR222FM  CF   E             WORKSTN
     F*                                       RECNO KSFILE RECSFL
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
     I*          UDS
     I*                                       1   20LCO
     I*                                       3   80LCUST
     I*                                       9   9 LHIST
     I*                                     100 109 LPRTR
     I*                                     110 119 LFORM
     I*                                     120 1210LCOPY
     I*                                     122 122 LJOBQ
     I*                                     123 126 LHOLD
     I*                                     127 130 LSAVE
     I*                                     133 133 LCANCL
     I*                                     134 141 LPROG
     I*                                     142 171 LNAME
      *
     C     *ENTRY        PLIST
     C                   PARM                    CUST             06 0
     C                   PARM                    RETC             01
      *
     C     KKCMN         KLIST
     C                   KFLD                    CUST
     C                   KFLD                    LAST
      *
     C                   MOVE      RETC          RETCXX           01
     C                   MOVE      *BLANKS       RETC
      *
     C                   TIME                    TIMOD             6 0
     C                   Z-ADD     UDATE         DTEN
     C                   CALL      '@DT@A1'                                     TEST DATE ENTD
     C                   PARM                    DTEN
     C                   PARM                    DTLS             07 0
     C                   PARM      'N'           RETC
     C                   MOVE      *BLANKS       CMNT
     C                   MOVE      *BLANKS       CMNT2
     C                   MOVE      *BLANKS       CMNT3
     C                   MOVE      *BLANKS       DTFL
     C                   MOVEA     '0100'        *IN(10)
     C                   MOVE      '0'           *IN(80)
     C                   MOVE      '0'           *IN(98)
      *
     C                   Z-ADD     *ZEROS        ACCNTR
     C     CUST          SETLL     FARCMN
     C     *IN50         DOUEQ     '1'
     C     CUST          READE     FARCMN                                 50
     C     *IN50         IFEQ      '1'
     C                   Z-ADD     ACCNTR        LAST             05 0
     C                   LEAVE
     C                   END
     C                   ENDDO
      *
     C     TOP10         TAG
     C                   WRITE     WIN010
     C                   READ      WIN010                                 50
     C                   MOVEA     '0000'        *IN(10)
     C                   MOVE      '0'           *IN(80)
     C                   MOVE      '1'           *IN(98)
      *
     C     *INKF         IFEQ      '1'
     C                   GOTO      EOJ
     C                   END
     C     *INKL         IFEQ      '1'
     C                   MOVE      'A'           RETC
     C                   GOTO      EOJ
     C                   END
      *
     C                   CALL      '@DT@A1'                                     TEST DATE ENTD
     C                   PARM                    DTEN
     C                   PARM                    ACDTEN           07 0
     C                   PARM      'N'           RETC
     C     RETC          IFEQ      'Y'
     C                   SETON                                        1080
     C                   SETOFF                                       98
     C                   GOTO      TOP10
     C                   END
      *
     C     CMNT          IFEQ      *BLANKS                                      TEST COMMENTS
     C                   SETON                                        111280
     C                   SETOFF                                       98
     C                   GOTO      TOP10
     C                   END
      *
     C                   CALL      '@DT@A1'                                     TEST DATE FOLLOW UP
     C                   PARM                    DTFL
     C                   PARM                    ACDTFL           07 0
     C                   PARM      'N'           RETC
     C     RETC          IFEQ      'Y'
     C                   SETON                                        1380
     C                   SETOFF                                       98
     C                   GOTO      TOP10
     C                   END
      *
     C     *IN98         IFEQ      '0'
     C                   GOTO      TOP10
     C                   END
      *
     C                   ADD       1             LAST
     C                   MOVE      *BLANKS       ACSTAT
     C                   Z-ADD     CUST          ACCUST
     C                   Z-ADD     LAST          ACCNTR
     C                   MOVE      CMNT          ACCMNT
     C                   MOVE      CMNT2         ACCMNT2
     C                   MOVE      CMNT3         ACCMNT3
     C                   MOVE      TIMOD         ACTIME
     C                   MOVE      USERID        ACUSER
     C                   Z-ADD     DTLS          ACDTLS
     C                   WRITE     RARCMN
      *
     C     EOJ           TAG
     C                   MOVE      '1'           *INLR
