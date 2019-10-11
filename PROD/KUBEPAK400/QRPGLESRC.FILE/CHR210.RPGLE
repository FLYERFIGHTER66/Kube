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
      **PROGRAM NAME-------- CHR210
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- CHAS. BUCK
      **APPLICATION--------- SPLIT JOB FILE TO RUN FILE.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FCHR210FM  CF   E             WORKSTN
     FFCHMCTL   IF   E           K DISK
     FFCHMAPPR  IF   E           K DISK
     FFCHMSPY   IF   E           K DISK
     FFCHMJOB   IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCALEN    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:ICALEN)
     FFCHMRUN   UF A E           K DISK
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

     C     *Entry        PList
     C                   Parm                    Date7@            7

     C**
     C     JOBKEY        KLIST
     C                   KFLD                    CJWKDT
     C                   KFLD                    JOB#
     C**
     C     INVKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C**
     C     APPKEY        KLIST
     C                   KFLD                    CAWKDT
     C                   KFLD                    CAITEM
     C                   KFLD                    CASIZE
     C                   KFLD                    CAPPM
     C                   KFLD                    CASPRY
     C**
     C     SPYKEY        KLIST
     C                   KFLD                    CSITEM
     C                   KFLD                    CSSIZE
     C                   KFLD                    CSPPM
     C**
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    BEGWW
     C                   KFLD                    CL#Y
     C**
      ***********************
      ** START OR RESTART  **
      ***********************
     C     RSTART        TAG
     C*                    Z-ADD0         FRMDAT
     C*                    Z-ADD0         BEGYY
     C*                    Z-ADD0         BEGWW
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                       9899
      ** DISPLAY SCREEN
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   GOTO      PASS
     C                   ENDDO
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                         99
      **
      ** CHECK DATE
      **
     C     FRMDAT        IFLE      0
     C     BEGYY         ANDLE     0
     C     BEGWW         ANDLE     0
     C                   SETON                                        10  99
     C                   GOTO      NXTA
     C                   ENDIF
      **
     C     FRMDAT        IFGT      0
     C     FRMDAT        CHAIN     FCALEN                             92
     C   92              DO
     C                   SETON                                        1099
     C                   GOTO      NXTA
     C                   ENDDO
     C*    CL#Y          IFNE      1
     C*                  SETON                                        101199
     C*                  GOTO      NXTA
     C*                  END
     C                   MOVEL     CLCENT        BEGYY
     C                   MOVE      CLYEAR        BEGYY
     C                   Z-ADD     CLWEEK        BEGWW
     C                   Z-ADD     CLCYMD        STRDAT            7 0
     C                   ELSE                                                   FRMDAT > 0
     C                   MOVEL     BEGYY         CLCENT
     C                   MOVE      BEGYY         CLYEAR
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             92
     C   92              DO
     C                   SETON                                        2099
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        FRMDAT
     C                   Z-ADD     CLCYMD        STRDAT            7 0
     C                   END                                                    FRMDAT > 0
     C**
      ** CHECK CONTROL FILE
     C     STRDAT        CHAIN     FCHMCTL                            12
     C   12              DO
     C                   SETON                                        102099
     C                   GOTO      NXTA
     C                   ENDDO

     C     STRDAT        SetLL     FCHMRUN
     C     STRDAT        ReadE     FCHMRUN
     C                   DoW       not %eof(FCHMRUN)
     C                   Delete    RCHMRUN
     C     STRDAT        ReadE     FCHMRUN
     C                   EndDo
     C                   Move      STRDAT        Date7@

     C*
     C** CHAIN TO THE JOB FILE
     C*
     C                   MOVEL     STRDAT        CJWKDT
     C                   Z-ADD     1             JOB#              6 0
     C     JOBKEY        SETLL     FCHMJOB
     C     NXTREC        TAG
     C     JOBKEY        READE     FCHMJOB                                91
     C     *IN91         DOWEQ     *OFF
     C*
     C*
     C                   MOVE      CJTRAY        CRTRAY
     C                   MOVE      CJWKDT        CRWKDT
     C                   MOVE      CJSTAT        CRSTAT
     C                   MOVE      JOB#          CRJOB#
     C                   MOVE      CJSPIT        CRSPIT
     C                   MOVE      CJSPSZ        CRSPSZ
     C                   MOVE      CJPPM         CRPPM
     C                   MOVE      CJSECT        CRSECT
     C                   MOVE      CJBAY         CRBAY
     C                   MOVE      CJNOS         CRNOS
     C                   MOVE      CJSPOL        CRSPOL
     C                   MOVE      CJSLOR        CRSLOR
     C                   MOVE      CJSPKY        CRSPKY
     C                   MOVE      CJEPOL        CREPOL
     C                   MOVE      CJELOR        CRELOR
     C                   MOVE      CJEPKY        CREPKY
     C                   MOVE      CJDTLA        CRDTLA
     C                   MOVE      CJTIME        CRTIME
     C                   MOVE      CJUSER        CRUSER
     C*
     C*   GET THE CHEMICAL DESCRIPTION  I.E. BONZI
     C*
     C                   MOVEL     CJSPIT        IMITEM
     C                   MOVEL     CJSPSZ        IMSIZE
     C     INVKEY        CHAIN     FMINVT                             95
     C     *IN95         IFEQ      *OFF
     C                   MOVEL     IMDES1        CRLOOK
     C                   END
     C*
     C*   GET THE SPRAYER CONTROL FILE TO CHECK FOR MAX POLES FOR BOSS
     C*
     C                   MOVEL     CJSPIT        CSITEM
     C                   MOVEL     CJSPSZ        CSSIZE
     C                   MOVEL     CJPPM         CSPPM
     C     SPYKEY        CHAIN     FCHMSPY                            92
     C     *IN92         IFEQ      *OFF
     C**
     C                   Z-ADD     0             TOTRY
     C     CSXPL         MULT      55            TOTRY             7 2
     C                   END
     C**
     C     CJTRAY        IFGT      TOTRY
     C                   MOVEL     'BEAN'        CRSPRY
     C                   ELSE
     C                   MOVEL     'BOSS'        CRSPRY
     C                   END
     C*
     C*   GET THE APPLICATOR FOR SPECIFIC CHEMICAL
     C*
     C                   CLEAR                   WRAPP1
     C                   CLEAR                   WRAPP2
     C                   MOVEL     CJSPIT        CAITEM
     C                   MOVEL     CJSPSZ        CASIZE
     C                   MOVEL     CJPPM         CAPPM
     C                   MOVEL     CRSPRY        CASPRY
     C     APPKEY        CHAIN     FCHMAPPR                           95
     C     *IN95         IFEQ      *OFF
     C                   MOVEL     CAAPP1        WRAPP1            8
     C                   MOVEL     CAAPP2        WRAPP2            8
     C                   END
     C*
     C                   MOVEL     WRAPP1        CRAPP1
     C                   MOVEL     WRAPP2        CRAPP2
     C*
     C**   WRITE TO THE CHMRUN FILE
     C*
     C                   WRITE     RCHMRUN
     C                   ADD       1             JOB#
     C                   GOTO      NXTREC
     C                   ENDDO                                                  *IN91 ENDDO
     C*
     C     PASS          TAG
     C                   SETON                                        LR
     C**
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     TDATE         CHAIN     FCALEN                             90
     C     CALKY1        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
     C                   Z-ADD     1             CL#Y
     C     CALKY1        CHAIN     FCALEX                             92
     C                   Z-ADD     CLDATE        FRMDAT
     C                   MOVEL     CLCENT        BEGYY
     C                   MOVE      CLYEAR        BEGYY
     C                   Z-ADD     CLWEEK        BEGWW
     C                   ENDSR
