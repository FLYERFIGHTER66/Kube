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
      **PROGRAM NAME-------- CSR110
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CUSTOMER OPTIONS MASTER LIST
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCSTOPA  IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FCSR110    O    F  120        PRINTER OFLIND(*INOF)
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
      *   LDA        *
      ****************
     D                UDS
     I**                                      1   20LCO                   ARC380
      ***********************
      ** START HERE        **
      ***********************
     C     NXT           TAG
     C                   READ      FMCSTOPA                               90
     C   90              GOTO      END
     C     OPVEND        IFGT      0
     C     OPVEND        CHAIN     FMVEND                             80
     C                   MOVEL     VMNAME        VNAME            20
     C                   ELSE
     C                   MOVE      *BLANKS       VNAME
     C                   END
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   SETON                                        OF
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OCSR110    E            HEAD           1 03
     O                                            6 'CSR110'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           64 'Customer Options Listing'
     O                       PAGE          Z     85
     O                                           81 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           76 'Time:'
     O                       TIMOD               85 '  :  :  '
     O          E            HEAD           0
     O                                            4 'Code'
     O                                           22 'Description'
     O                                           48 'Search'
     O                                           64 'Vendor'
     O                                           69 'Name'
     O          E            HEAD           2
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O                                           85 '_____'
     O          EF           DETL           1
     O                       OPCODE              10
     O                       OPDESC              41
     O                       OPLOOK              57
     O                       OPVEND        4     64
     O                       VNAME               85
