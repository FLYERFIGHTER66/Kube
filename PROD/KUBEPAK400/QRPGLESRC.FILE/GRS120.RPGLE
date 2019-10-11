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
      *PROGRAM NAME-------- GRS120
      *SYSTEM-------------- PRODUCTION MASTER FILES
      *APPLICATION--------- PRODUCTION FACTOR TABLE MASTER LISTING
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFPTABLE   IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FGRS120    O    F   80        PRINTER OFLIND(*INOF)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   MOVEL     '00'          MCCOMP
     C     CKEY          KLIST
     C                   KFLD                    MCCOMP
     C     CKEY          CHAIN(N)  FMCOMP                             90
     C     MCPRCO        CHAIN     FMCORG                             90
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       90
     C                   READ      FPTABLE                                90
     C   90              GOTO      END
      *
      * CHECK FOR DELETED RECORD
      *
     C     PTSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DETL
     C     PTBQ02        IFGT      0
     C   OF              EXCEPT    HDG
     C                   EXCEPT    DETL2
     C                   ENDIF
     C     PTBQ03        IFGT      0
     C   OF              EXCEPT    HDG
     C                   EXCEPT    DETL3
     C                   ENDIF
     C     PTBQ04        IFGT      0
     C   OF              EXCEPT    HDG
     C                   EXCEPT    DETL4
     C                   ENDIF
     C     PTBQ05        IFGT      0
     C   OF              EXCEPT    HDG
     C                   EXCEPT    DETL5
     C                   ENDIF
     C     PTBQ06        IFGT      0
     C   OF              EXCEPT    HDG
     C                   EXCEPT    DETL6
     C                   ENDIF
     C     PTBQ07        IFGT      0
     C   OF              EXCEPT    HDG
     C                   EXCEPT    DETL7
     C                   ENDIF
     C     PTBQ08        IFGT      0
     C   OF              EXCEPT    HDG
     C                   EXCEPT    DETL8
     C                   ENDIF
     C     PTBQ09        IFGT      0
     C   OF              EXCEPT    HDG
     C                   EXCEPT    DETL9
     C                   ENDIF
     C     PTBQ10        IFGT      0
     C   OF              EXCEPT    HDG
     C                   EXCEPT    DETL10
     C                   ENDIF
     C     PTBQ11        IFGT      0
     C   OF              EXCEPT    HDG
     C                   EXCEPT    DETL11
     C                   ENDIF
     C     PTBQ12        IFGT      0
     C   OF              EXCEPT    HDG
     C                   EXCEPT    DETL12
     C                   ENDIF
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OGRS120    E            HDG            1 03
     O                       PROGID              10
     O                                           20 'Reqd by:'
     O                       USERID              31
     O                       RGNAMC              55
     O                       PAGE          1     80
     O                                           77 'Page'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           52 'Production Factor Table'
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            1
     O                                            5 'Table'
     O                                           40 'Excl'
     O                                           62 '- Quantity To Sow -'
     O                                           80 '--- Factor ---'
     O          E            HDG            1
     O                                            4 'ID'
     O                                           18 'Description'
     O                                           40 'Type'
     O                                           52 'Beginning'
     O                                           62 'Ending'
     O                                           70 'Units'
     O                                           80 'Percents'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           80 '________'
     O          EF           DETL        1  1
     O                       PTABID               4
     O                       PTDESC              35
     O                       PTCTYP              40
     O                       PTBQ01        Z     52
     O                       PTEQ01        Z     62
     O                       PTUN01        Z     70
     O                       PTPE01        4     80
     O          EF           DETL2          1
     O                       PTBQ02        Z     52
     O                       PTEQ02        Z     62
     O                       PTUN02        Z     70
     O                       PTPE02        4     80
     O          EF           DETL3          1
     O                       PTBQ03        Z     52
     O                       PTEQ03        Z     62
     O                       PTUN03        Z     70
     O                       PTPE03        4     80
     O          EF           DETL3          1
     O                       PTBQ03        Z     52
     O                       PTEQ03        Z     62
     O                       PTUN03        Z     70
     O                       PTPE03        4     80
     O          EF           DETL4          1
     O                       PTBQ04        Z     52
     O                       PTEQ04        Z     62
     O                       PTUN04        Z     70
     O                       PTPE04        4     80
     O          EF           DETL5          1
     O                       PTBQ05        Z     52
     O                       PTEQ05        Z     62
     O                       PTUN05        Z     70
     O                       PTPE05        4     80
     O          EF           DETL6          1
     O                       PTBQ06        Z     52
     O                       PTEQ06        Z     62
     O                       PTUN06        Z     70
     O                       PTPE06        4     80
     O          EF           DETL7          1
     O                       PTBQ07        Z     52
     O                       PTEQ07        Z     62
     O                       PTUN07        Z     70
     O                       PTPE07        4     80
     O          EF           DETL8          1
     O                       PTBQ08        Z     52
     O                       PTEQ08        Z     62
     O                       PTUN08        Z     70
     O                       PTPE08        4     80
     O          EF           DETL9          1
     O                       PTBQ09        Z     52
     O                       PTEQ09        Z     62
     O                       PTUN09        Z     70
     O                       PTPE09        4     80
     O          EF           DETL10         1
     O                       PTBQ10        Z     52
     O                       PTEQ10        Z     62
     O                       PTUN10        Z     70
     O                       PTPE10        4     80
     O          EF           DETL11         1
     O                       PTBQ11        Z     52
     O                       PTEQ11        Z     62
     O                       PTUN11        Z     70
     O                       PTPE11        4     80
     O          EF           DETL12         1
     O                       PTBQ12        Z     52
     O                       PTEQ12        Z     62
     O                       PTUN12        Z     70
     O                       PTPE12        4     80
