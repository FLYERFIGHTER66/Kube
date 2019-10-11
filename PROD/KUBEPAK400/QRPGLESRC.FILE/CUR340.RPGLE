      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      **PROGRAM NAME-------- CUR340
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER----------
      **APPLICATION--------- CREATE TRANSFER FILE FOR P.C. TRANSFER
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFCUTORDI  UF   E           K DISK
     FFCUTCTL   UF   E           K DISK
     FFCALENCY  IF   E           K DISK
     FFMINVTVI  IF   E           K DISK
      *FFCUTSEQ IF  E           K        DISK
     FFCUTTXF   O  A E           K DISK
WJB  FFMVEND    IF   E           K DISK
      *
      * MESSAGE ARRAY
      *E                    MSG     1   1 30               MESSAGE
      *
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
      ****************
      *  LDA         *
      ****************
     D                UDS
     D  ORDER                  1      6  0                                      ARC380
     D  UPDAT                  7      7                                         ARC380
WJB
WJB  D  Vendor         S                   Like(IMVEND)
      ***********************
      ** START HERE        **
      ***********************
      ** GET LOW AND HIGH SOW DATE
     C                   EXSR      GETSOW
     C                   Z-ADD     LSOW          CSOW              7 0
     C                   MOVEL     *Blanks       IMVITM
     C     IMVITM        SETLL     FMINVTVI
     C     NXTSEQ        TAG
     C                   READ      FMINVTVI                               90
     C* N90      IMSTAT    IFEQ 'D'
     C*          IMSTAT    OREQ 'P'
     C*                    GOTO NXTSEQ
     C*                    ENDIF
     C                   MOVEL     IMDES1        CODES1
     C  N90              DO
     C*    IMVITM        IFGT      '9999'
     C*                  SETON                                        90
     C*                  ENDIF
     C                   ENDDO
     C   90              DO
     C     CSOW          IFGE      HSOW
     C                   GOTO      END
     C                   END
      ** GET NEXT DATE
     C                   Z-ADD     CSOW          ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   ADD       7             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        CSOW
     C**                   Z-ADD0         CSSEQ#
     C                   MOVEL     *Blanks       IMVITM
     C     IMVITM        SETLL     FMINVTVI
     C                   GOTO      NXTSEQ
     C                   ENDDO
     C     ORDKEY        KLIST
WJB  C                   KFLD                    Vendor
     C                   KFLD                    ORDER
     C                   KFLD                    CSOW
     C                   KFLD                    IMITEM
     C     ORDKEY        SETLL     FCUTORDI
     C     NXT           TAG
     C     ORDKEY        READE     FCUTORDI                               90
     C   90              GOTO      NXTSEQ
      ** ORDER BY HUNDREDS
     C                   MOVEL     COQTOO        QTY               5 0
     C                   MOVEL     IMVITM        COVITM
     C                   Z-ADD     QTY           COQTTO
     C     COSOWD        CHAIN     FCALENCY                           55
     C  N55              Z-ADD     CLWEEK        COSOWW
     C  N55              DO
     C                   MOVEL     CLDATE        MM                2 0
     C                   MOVE      CLDATE        YY                2 0
     C                   MOVEL     CLDATE        MMDD              4 0
     C                   MOVE      MMDD          DD                2 0
     C                   MOVEL     MM            MM3               3
     C                   MOVEL     DD            DD3               3
     C                   MOVE      '/'           MM3
     C                   MOVE      '/'           DD3
     C                   MOVEL     MM3           MD6               6
     C                   MOVE      DD3           MD6
     C                   MOVE      YY            COSOW
     C                   MOVEL     MD6           COSOW
WJB  C                   Z-add     Vendor        COVEND
     C                   ENDDO
     C                   WRITE     RCUTTXF
     C                   MOVEL     'Y'           COTRAN
     C                   UPDATE    RCUTORD
     C                   GOTO      NXT
     C     END           TAG
     C     UPDAT         IFEQ      'Y'
     C                   Z-ADD     1             CCCONO
WJB  C     VendCo#       KList
WJB  C                   KFld                    CCCONO
WJB  C                   KFld                    Vendor
WJB  C*    CCCONO        CHAIN     FCUTCTL                            57
WJB  C     VendCo#       CHAIN     FCUTCTL                            57
     C                   MOVEL     'Y'           CCTXFR
     C  N57              UPDATE    RCUTCTL
     C                   END
     C                   SETON                                        LR
      ***********************
      ** GET HIGH LOW SOW  **
      ***********************
     C     GETSOW        BEGSR
     C                   Z-ADD     0             HSOW              7 0
     C                   Z-ADD     9999999       LSOW              7 0
WJB  C     VendOrd#      KList
WJB  C                   KFld                    Vendor
WJB  C                   KFld                    ORDER
WJB  C*    ORDER         SETLL     FCUTORDI
WJB  C     VendOrd#      SETLL     FCUTORDI
     C     NXTSOW        TAG
WJB  C*    ORDER         READE(N)  FCUTORDI                               90
WJB  C     VendOrd#      READE(N)  FCUTORDI                               90
     C   90              GOTO      ENDSOW
     C     COSOWD        IFLT      LSOW
     C                   Z-ADD     COSOWD        LSOW
     C                   END
     C     COSOWD        IFGT      HSOW
     C                   Z-ADD     COSOWD        HSOW
     C                   END
     C                   GOTO      NXTSOW
     C     ENDSOW        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
WJB  C     *Entry        PList
WJB  C                   Parm                    Vendor
WJB  C     Vendor        Chain     FMVEND
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
      ** Messages
      **No Item Number Found                           1
