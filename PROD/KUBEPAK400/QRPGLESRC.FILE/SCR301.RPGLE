      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- SCR300
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT SCANNER ORDER VERIFY ERROR LIST
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFHORDR    IF   E           K DISK
     FFPPO      IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFPUTORDO  IF   E           K DISK
     FFTROREO   IF   E           K DISK
     FFTRAY     IF   E           K DISK
     FFTRORD    IF   E           K DISK
     FSCR300    O    F   80        PRINTER OFLIND(*INOF)
      *
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
      * CONSTANTS
     D AREA0           C                   CONST('COLD AREA ONLY')
     D AREA1           C                   CONST('WARM CARTS ONLY')
     D AREA2           C                   CONST('WARM FLOOR ONLY')
     D AREA9           C                   CONST('ALL AREAS     ')
      ****************
      *   PARMS      *
      ****************
     C     *ENTRY        PLIST
     C                   PARM                    ORDER#            6 0
     C                   PARM                    SHCYMD            7 0
     C                   PARM                    SMASTER           2 0
     C                   PARM                    AREA              6
      *                                   AREA = '9' MEANS ALL AREAS
     C                   SELECT
     C     AREA          WHENEQ    '     0'
     C                   MOVE      '      '      AREA
     C                   MOVE      AREA0         AREANM           15
     C     AREA          WHENEQ    '     1'
     C                   MOVE      AREA1         AREANM
     C     AREA          WHENEQ    '     2'
     C                   MOVE      AREA2         AREANM
     C     AREA          WHENEQ    '     9'
     C                   MOVE      AREA9         AREANM
     C                   ENDSL
      ***********************
      ** START HERE        **
      ***********************
     C     ORDER#        CHAIN     FHORDR                             LR
     C     OHORD#        CHAIN(N)  FPPO                               91
     C   91              DO
     C                   MOVE      *BLANKS       POLOWC
     C                   MOVE      *BLANKS       POLOWF
     C                   ENDDO
     C     PUTKEY        KLIST
     C                   KFLD                    SHCYMD
     C                   KFLD                    SMASTER
     C                   KFLD                    ORDER#
     C     PUTRKY        KLIST
     C                   KFLD                    SHCYMD
     C                   KFLD                    ORDER#
      ** SEE IF ENOUGH
     C     PUTKEY        SETLL     FPUTORDO
     C     NXTPUT        TAG
     C     PUTKEY        READE     FPUTORDO                               90
     C   90              GOTO      ENDPUT
     C     PDQORD        IFNE      PDQSCN
     C     ITMKEY        KLIST
     C                   KFLD                    PDITEM
     C                   KFLD                    PDSIZE
     C     ITMKEY2       KLIST
     C                   KFLD                    PDITEM2          12
     C                   KFLD                    PDSIZE
     C                   If        %SubSt(PDITEM:12:1) = 'P'
     C                   Eval      PDITEM2 = %SubSt(PDITEM:1:11) + ' '
     C                   Eval      *In60 = *On
     C     ITMKEY2       Chain     FMINVT                             91
     C                   Else
     C                   Eval      *In60 = *Off
     C     ITMKEY        CHAIN     FMINVT                             91
     C                   EndIf
     C     IMBIN#        IFNE      AREA
     C     AREA          ANDNE     '     9'
     C                   GOTO      NXTPUT
     C                   ENDIF
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    SRTHED
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C     PDQORD        SUB       PDQSCN        SHORT             5 0
     C                   Z-ADD     PDQORD        ORD               5 0
     C                   Z-ADD     PDQSCN        SCN               5 0
     C                   MOVEL     IMITEM        ITEM              5
     C     SHORT         IFGT      0
     C                   MOVEL     '*Short* '    ERMSG             8
     C                   ELSE
     C                   MOVEL     '*Over*  '    ERMSG             8
     C                   END
     C                   Z-Add     PDSEQ#        PDSEQ#3           3 0
     C                   EXCEPT    SRTERR
     C                   END
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
     C                   MOVEL     'N'           HEDPRT            1
      ** NOW CHECK TRAY ERROR FILE
     C     PUTRKY        SETLL     FTROREO
     C     NXTTRY        TAG
     C     PUTRKY        READE     FTROREO                                90
     C   90              GOTO      ENDTRY
     C     TETAG#        CHAIN     FTRAY                              91
     C                   If        not *In91 and TRSTAT = 'P'
     C                   Eval      *In61 = *On
     C                   Else
     C                   Eval      *In61 = *Off
     C                   ENDIF
     C     TRYITM        KLIST
     C                   KFLD                    TRITEM
     C                   KFLD                    TRSIZE
     C     TRYITM        CHAIN     FMINVT                             91
     C                   SETOFF                                       101112
     C                   Z-ADD     0             TOORD#
     C                   MOVEL     TRITEM        ITEM
     C                   If        not *In91 and TRSTAT = 'P'
     C                   Eval      *In61 = *Off
     C                   ENDIF
     C     TEERR         IFEQ      'NO'
     C                   SETON                                        10
     C                   END
     C     TEERR         IFEQ      'DUP'
     C     TETAG#        CHAIN     FTRORD                             92
     C                   SETON                                        11
     C                   END
     C     TEERR         IFEQ      'OVR'
     C                   SETON                                        12
     C                   END
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    TRYHED
     C                   MOVEL     'Y'           HEDPRT            1
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C     HEDPRT        IFEQ      'N'
     C                   SETON                                        70
     C                   EXCEPT    TRYHED
     C                   MOVEL     'Y'           HEDPRT            1
     C                   END                                                    HEDPRT=N
     C                   SETOFF                                       70
     C                   EXCEPT    TRYERR
     C                   GOTO      NXTTRY
     C     ENDTRY        TAG
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
     OSCR300    E            HEAD           1 03
     O                                            6 'SCR301'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           60 'Order Confirmation Edit'
     O                                           65 'List'
     O                       PAGE          Z     80
     O                                           78 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           53 'Last Scanned By:'
     O                       USERID              64
     O                                           71 'Time:'
     O                       TIMOD               80 '  :  :  '
     O          E            HEAD           1
     O                                            9 'Order #:'
     O                       ORDER#        4     16
     O                                           25 'Ship To:'
     O                       OHNAME              56
     O                                           67 'Req. Date:'
     O                       OHDTRQ        Y     56
     O          E            HEAD           2
     O                       AREANM              15
     O                                           27 'Locations:'
     O                       OHLOC               36
     O                                           37 '-'
     O                       POLOWC              45
     O                                           46 '-'
     O                       POLOWF              54
     O          E            SRTHED         1
     O                                           24 'The following errors can'
     O                                           48 'be fixed by scanning in'
     O                                           67 'the missing items.'
     O          E            SRTHED         1
     O                                            3 'Ord'
     O                                           68 '-------Quantity--------'
     O          E            SRTHED         0
     O                                            3 'Seq'
     O                                            8 'Item'
     O                                           13 'Size'
     O                                           26 'Description'
     O                                           52 'Order'
     O                                           60 'Scan'
     O                                           68 'Diff.'
     O                                           77 'Error '
     O          E            SRTHED         1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           77 '_________________'
     O          E            SRTERR         1
     O*                      PDSEQ#        4      3
     O                       PDSEQ#3       4      3
     O                       ITEM                 9
     O               60                           9 'P'
     O                       PDSIZE              13
     O                       IMDES1              44
     O                       ORD           J     52
     O                       SCN           J     60
     O                       SHORT         J     68
     O                       ERMSG               77
     O          E    70      TRYHED         1
     O          E            TRYHED         1
     O                                           20 'To fix the following'
     O                                           43 'errors you must select'
     O                                           64 'the clear option and'
     O                                           79 'scan the order'
     O          E            TRYHED         0
     O                                            8 'Tag # '
     O                                           13 'Item'
     O                                           18 'Size'
     O                                           32 'Descripition'
     O                                           56 'Other Order'
     O                                           80 '       Error           '
     O          E            TRYHED         1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O          E            TRYERR         1
     O                       TETAG#        4      8
     O                       ITEM                14
     O               60                          14 'P'
     O                       TRSIZE              18
     O                       IMDES1              49
     O                       TOORD#        4     56
     O               10                          80 'This item not on order.'
     O               11                          80 'Scanned on two orders. '
     O               12                          80 'To many of this item.  '
